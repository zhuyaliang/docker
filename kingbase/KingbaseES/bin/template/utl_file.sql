CREATE OR REPLACE PACKAGE utl_file AS
  TYPE internal_info IS TABLE OF utl_file_internal INDEX BY TEXT;
  TYPE file_status IS TABLE OF BOOL INDEX BY TEXT;
  internal_data internal_info;
  file_isopen file_status;
  FUNCTION fopen(location VARCHAR(1024), filename VARCHAR(63), open_mode VARCHAR(2), max_linesize int DEFAULT 1024) RETURN file_type;
  PROCEDURE fclose(INOUT file file_type);
  PROCEDURE fclose_all();
  PROCEDURE put(file file_type, buffer TEXT);
  PROCEDURE new_line(file file_type, lines INT DEFAULT 1);
  PROCEDURE put_line(file file_type, buffer TEXT, autoflush BOOL DEFAULT FALSE);
  PROCEDURE get_line(file file_type, buf TEXT, len INT DEFAULT NULL);
  PROCEDURE fflush(file file_type);
END;
