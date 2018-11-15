CREATE OR REPLACE PACKAGE DBMS_LOB AUTHID CURRENT_USER AS
  SESSION CONSTANT INTEGER := 10;
  PROCEDURE CREATETEMPORARYBLOB(lob_loc INOUT OID default 0,cache IN BOOLEAN, dur IN INTEGER default 10);
  PROCEDURE CREATETEMPORARYCLOB(lob_loc INOUT OID default 0,cache IN BOOLEAN, dur IN INTEGER default 10);
  PROCEDURE FREETEMPORARY(lob_loc INOUT OID);
  FUNCTION ISTEMPORARY (lob_loc INOUT OID) RETURN BOOL;
  
  PROCEDURE APPEND(dest_lob INOUT BLOB, src_lob IN BLOB);
  PROCEDURE APPENDBLOB(dest_lob IN OID, src_lob IN OID);
  PROCEDURE APPEND(dest_lob INOUT CLOB, src_lob IN CLOB);
  PROCEDURE APPENDCLOB(dest_lob IN OID, src_lob IN OID);
  
  FUNCTION SUBSTR(lob_loc IN BLOB,amount IN INTEGER default 32767,off_set IN INTEGER default 1) RETURN BYTEA;
  FUNCTION SUBSTRBLOB(lob_loc IN OID,amount IN INTEGER default 32767,off_set IN INTEGER default 1) RETURN BYTEA;
  FUNCTION SUBSTR(lob_loc IN CLOB,amount IN INTEGER default 32767,off_set IN INTEGER default 1) RETURN TEXT;
  FUNCTION SUBSTRCLOB(lob_loc IN OID,amount IN INTEGER default 32767,off_set IN INTEGER default 1) RETURN TEXT;
  
  FUNCTION GETLENGTH(lob_loc IN BLOB) RETURN INTEGER;
  FUNCTION GETLENGTHBLOB(lob_loc IN OID) RETURN INTEGER;
  FUNCTION GETLENGTH(lob_loc IN CLOB) RETURN INTEGER;
  FUNCTION GETLENGTHCLOB(lob_loc IN OID) RETURN INTEGER;
  
END;
