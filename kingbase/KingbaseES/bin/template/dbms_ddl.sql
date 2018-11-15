CREATE OR REPLACE PACKAGE DBMS_DDL AS
    PROCEDURE CREATE_WRAPPED(IN DDL VARCHAR2(8000));
    FUNCTION WRAP(IN DDL VARCHAR2(8000)) RETURNS VARCHAR2(8000);
END;
