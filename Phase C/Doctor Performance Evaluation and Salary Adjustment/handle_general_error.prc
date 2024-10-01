-- Procedure to handle errors and exceptions
CREATE OR REPLACE PROCEDURE handle_general_error(error_code IN NUMBER, error_message IN VARCHAR2)
IS
BEGIN
    -- Print the error code and message
    DBMS_OUTPUT.PUT_LINE('Error Code: ' || error_code);
    DBMS_OUTPUT.PUT_LINE('Error Message: ' || error_message);
    -- Rollback the transaction if needed
    ROLLBACK;
END;
/
