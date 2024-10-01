CREATE OR REPLACE PROCEDURE process_department(department_id IN NUMBER, department_name IN VARCHAR2)
IS
    top_10_threshold NUMBER;
    top_20_threshold NUMBER;
    top_50_threshold NUMBER;
    low_20_threshold NUMBER;
    percentiles_cursor SYS_REFCURSOR;
BEGIN
    -- Print department name and ID
    DBMS_OUTPUT.PUT_LINE(CHR(10) || CHR(10) || 'Department: ' || department_name || ' (ID: ' || department_id || ')');
    
    -- Fetch percentiles for the department
    percentiles_cursor := get_department_percentiles(department_id);
    FETCH percentiles_cursor INTO top_10_threshold, top_20_threshold, top_50_threshold, low_20_threshold;
    
    -- Print calculated percentiles
    DBMS_OUTPUT.PUT_LINE('Percentiles calculated: Top 10%: ' || top_10_threshold ||
                         ', Top 20%: ' || top_20_threshold || 
                         ', Top 50%: ' || top_50_threshold || 
                         ', Bottom 20%: ' || low_20_threshold);
    
    -- Print doctor performance for the department
    evaluate_doctor_performance(department_id);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No data found for department ' || department_name);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error processing department ' || department_name || ' - ' || SQLERRM);
END;
/
