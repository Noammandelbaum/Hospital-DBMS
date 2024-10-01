CREATE OR REPLACE FUNCTION get_department_percentiles(department_id IN NUMBER)
RETURN SYS_REFCURSOR
IS
    percentiles_cursor SYS_REFCURSOR;
BEGIN
    -- Open cursor for percentile calculations
    OPEN percentiles_cursor FOR
    SELECT ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY performance_score), 2) AS top_10,
           ROUND(PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY performance_score), 2) AS top_20,
           ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY performance_score), 2) AS top_50,
           ROUND(PERCENTILE_CONT(0.2) WITHIN GROUP (ORDER BY performance_score), 2) AS low_20
    FROM (
        SELECT d.DoctorID, 
               AVG(NVL(p.ReleaseDate, SYSDATE) - p.AdmissionDate) / COUNT(p.PatientID) AS performance_score
        FROM Doctors d
        LEFT JOIN PatientDoctor pd ON d.DoctorID = pd.DoctorID
        LEFT JOIN Patients p ON pd.PatientID = p.PatientID
        WHERE d.DepartmentID = department_id
        GROUP BY d.DoctorID
    );

    RETURN percentiles_cursor;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No performance data found for department ' || department_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error calculating percentiles for department ' || department_id || ' - ' || SQLERRM);
        RETURN NULL;
END;
/
