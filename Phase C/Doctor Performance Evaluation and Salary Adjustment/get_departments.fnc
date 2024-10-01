CREATE OR REPLACE FUNCTION get_departments
RETURN SYS_REFCURSOR
IS
    department_cursor SYS_REFCURSOR;
BEGIN
    -- Open a cursor to fetch department list
    OPEN department_cursor FOR 
        SELECT DepartmentID, DepartmentName 
        FROM Departments;
    RETURN department_cursor;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No departments found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Unable to fetch departments - ' || SQLERRM);
END;
/
