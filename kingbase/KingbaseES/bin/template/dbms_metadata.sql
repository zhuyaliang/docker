CREATE OR REPLACE PACKAGE DBMS_METADATA
AS
  FUNCTION GET_DDL(OBJTYPE VARCHAR2(63), OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63) DEFAULT NULL, MODEL VARCHAR2(63) DEFAULT NULL, VERSION VARCHAR2(63) DEFAULT NULL, TRANSFORM VARCHAR2(63) DEFAULT NULL) RETURN TEXT;

  FUNCTION GET_FUNC_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63)) RETURN TEXT;
  FUNCTION GET_PROCEDURE_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63)) RETURN TEXT;
  FUNCTION GET_VIEW_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63)) RETURN TEXT;
  FUNCTION GET_TABLE_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63)) RETURN TEXT;

  FUNCTION GET_PACKAGE_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63)) RETURN TEXT;
  FUNCTION GET_PACKAGE_BODY_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63)) RETURN TEXT;
  FUNCTION GET_SEQUENCE_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63)) RETURN TEXT;
  FUNCTION GET_TABLESPACE_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63)) RETURN TEXT;

  FUNCTION GET_TRIGGER_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63), TABOID OID DEFAULT 0) RETURN TEXT;
  FUNCTION GET_INDEX_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63), TABOID OID DEFAULT 0) RETURN TEXT;
  FUNCTION GET_CONSTRAINT_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63), TABOID OID DEFAULT 0) RETURN TEXT;
  FUNCTION GET_REF_CONSTRAINT_DDL(OBJNAME VARCHAR2(63), SCHEMA VARCHAR2(63), TABOID OID DEFAULT 0) RETURN TEXT;

  PROCEDURE GET_ATTR( IN TABOID OID, IN ATTRCNT INT, OUT BUF VARCHAR2(8000));

  FUNCTION CHECK_PRIVILEGE(IN owneroid OID) RETURN INT;
END;
