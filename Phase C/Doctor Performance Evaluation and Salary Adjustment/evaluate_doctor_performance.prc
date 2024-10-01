-- Procedure to print doctor performance and update salary for top performers in a given department
CREATE OR REPLACE PROCEDURE evaluate_doctor_performance(department_id IN NUMBER)
IS
    performance_cursor SYS_REFCURSOR;
    percentiles_cursor SYS_REFCURSOR;
    doctor_id NUMBER;
    doctor_name VARCHAR2(100);
    performance_score NUMBER;
    top_10_threshold NUMBER;
    top_20_threshold NUMBER;
    top_50_threshold NUMBER;
    low_20_threshold NUMBER;
    top_10_doctors VARCHAR2(2000) := '';
    top_20_doctors VARCHAR2(2000) := '';
    top_50_doctors VARCHAR2(2000) := '';
    low_20_doctors VARCHAR2(2000) := '';
    improvement_doctors VARCHAR2(2000) := '';
BEGIN
    -- Fetch percentiles from the external function
    percentiles_cursor := get_department_percentiles(department_id);
    FETCH percentiles_cursor INTO top_10_threshold, top_20_threshold, top_50_threshold, low_20_threshold;

    -- Fetch doctor performance sorted by score
    OPEN performance_cursor FOR
        SELECT d.DoctorID, d.FirstName || ' ' || d.LastName AS DoctorName,
               AVG(NVL(p.ReleaseDate, SYSDATE) - p.AdmissionDate) / COUNT(p.PatientID) AS performance_score
        FROM Doctors d
        LEFT JOIN PatientDoctor pd ON d.DoctorID = pd.DoctorID
        LEFT JOIN Patients p ON pd.PatientID = p.PatientID
        WHERE d.DepartmentID = department_id
        GROUP BY d.DoctorID, d.FirstName, d.LastName
        ORDER BY performance_score DESC;

    -- Loop through doctors and categorize based on performance
    LOOP
        FETCH performance_cursor INTO doctor_id, doctor_name, performance_score;
        EXIT WHEN performance_cursor%NOTFOUND;

        -- Round performance score
        performance_score := ROUND(performance_score, 2);

        -- Add doctor to the appropriate category
        IF performance_score >= top_10_threshold THEN
            top_10_doctors := top_10_doctors || CHR(10) || '  Doctor ' || doctor_name || ' (ID: ' || doctor_id || ') - Performance Score: ' || performance_score;
            -- Update salary for top 10% doctors
            UPDATE Doctors
            SET Salary = Salary + 1000
            WHERE DoctorID = doctor_id;
        ELSIF performance_score >= top_20_threshold THEN
            top_20_doctors := top_20_doctors || CHR(10) || '  Doctor ' || doctor_name || ' (ID: ' || doctor_id || ') - Performance Score: ' || performance_score;
            -- Update salary for top 20% doctors
            UPDATE Doctors
            SET Salary = Salary + 500
            WHERE DoctorID = doctor_id;
        ELSIF performance_score >= top_50_threshold THEN
            top_50_doctors := top_50_doctors || CHR(10) || '  Doctor ' || doctor_name || ' (ID: ' || doctor_id || ') - Performance Score: ' || performance_score;
        ELSIF performance_score >= low_20_threshold THEN
            low_20_doctors := low_20_doctors || CHR(10) || '  Doctor ' || doctor_name || ' (ID: ' || doctor_id || ') - Performance Score: ' || performance_score;
        ELSE
            improvement_doctors := improvement_doctors || CHR(10) || '  Doctor ' || doctor_name || ' (ID: ' || doctor_id || ') - Performance Score: ' || performance_score;
        END IF;
    END LOOP;

    -- Print results for each category and update salary based on performance percentile
    IF top_10_doctors IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Top 10% doctors with a salary raise of 1000: ' || top_10_doctors);
    END IF;

    IF top_20_doctors IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Top 20% doctors with a salary raise of 500: ' || top_20_doctors);
    END IF;

    IF top_50_doctors IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Top 50% doctors with a rating of "Very Good": ' || top_50_doctors);
    END IF;

    IF low_20_doctors IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Doctors with a rating of "Almost Good": ' || low_20_doctors);
    END IF;

    IF improvement_doctors IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Doctors needing improvement (Bottom 20%): ' || improvement_doctors);
    END IF;


    -- Close the performance cursor
    CLOSE performance_cursor;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No doctor performance data found for department ' || department_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error processing doctor performance for department ' || department_id || ' - ' || SQLERRM);
        CLOSE performance_cursor;
END;
/
