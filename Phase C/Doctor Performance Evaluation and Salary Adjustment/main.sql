DECLARE
    department_cursor SYS_REFCURSOR;
    department_id NUMBER;
    department_name VARCHAR2(100);
BEGIN
    -- Get the list of departments
    department_cursor := get_departments();

    -- Loop through departments and process each
    LOOP
        FETCH department_cursor INTO department_id, department_name;
        EXIT WHEN department_cursor%NOTFOUND;

        -- Process the department (calculate percentiles and print doctor performance)
        process_department(department_id, department_name);
    END LOOP;

    -- Close the department cursor
    CLOSE department_cursor;
    
    COMMIT;

EXCEPTION
    -- Handle any errors
    WHEN OTHERS THEN
        handle_general_error(SQLCODE, SQLERRM);
END;
