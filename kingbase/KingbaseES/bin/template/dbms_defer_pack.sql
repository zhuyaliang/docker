CREATE OR REPLACE PACKAGE DBMS_DEFER_PACK IS
	procedure PACK( ITEM IN TEXT, BUFFER IN OUT BYTEA, "POSITION" IN OUT INT );
	procedure PACK( ITEM IN NUMBER(38, 10), BUFFER IN OUT BYTEA, "POSITION" IN OUT INT );
	procedure PACK( ITEM IN TIMESTAMP, BUFFER IN OUT BYTEA, "POSITION" IN OUT INT );
	procedure PACK_RAW( ITEM IN BYTEA, BUFFER IN OUT BYTEA, "POSITION" IN OUT INT );
	procedure PACK_ROWID( ITEM IN ROWID, BUFFER IN OUT BYTEA, "POSITION" IN OUT INT );
	procedure UNPACK( ITEM OUT TEXT, BUFFER IN OUT BYTEA, "POSITION" IN OUT INT );
	procedure UNPACK( ITEM OUT NUMBER(38, 10), BUFFER IN OUT BYTEA, "POSITION" IN OUT INT );
	procedure UNPACK( ITEM OUT TIMESTAMP, BUFFER IN OUT BYTEA, "POSITION" IN OUT INT );
	procedure UNPACK_RAW( ITEM OUT BYTEA, BUFFER IN OUT BYTEA, "POSITION" IN OUT INT );
	procedure UNPACK_ROWID( ITEM OUT ROWID, BUFFER IN OUT BYTEA, "POSITION" IN OUT INT );
	function NEXT_ITEM_TYPE( BUFFER IN BYTEA, "POSITION" IN INT ) return integer;
	procedure RESET_BUFFER( BUFFER IN OUT BYTEA, "POSITION" OUT INT );
	function bytea_to_text(buffer bytea) return text;
	function text_to_bytea(buffer text) return bytea;
	function hex_to_num(buffer text) return number(38);
	function num_to_hex(num bigint) return text;

	procedure GET_TYPEID(buffer text, typeid out int, pos inout int);
	procedure GET_LENGTH(buffer text, len out number(38), pos inout int, istext bool default false);
	FUNCTION GET_00_POS(buf text, istext bool default false) returns int;
  
	varchar_typeid 	constant int := 1;
	number_typeid 	constant int := 2;
	timestamp_typeid constant int := 12;
	bytea_typeid	constant int := 23;
	rowid_typeid	constant int := 69;
	
	/* timestamp���ʱ����time_baseΪʱ����㣬ֻ�������ʱ������������ */
	time_base		constant timestamp := '1900-01-01 00:00:00'::timestamp;
	/* time_addition ����timestamp���������λ������λʱ�Ĳ������ݡ� */
	time_addition	constant bytea := 'FF';
	/* timestamp ���������ݳ��ȡ� */
	timedata_len	constant int  := 7;
			
	err				constant text := '�����package';
	char_set_data	constant text := '015203';
	over_flow_err_str constant text := '������еĻ�����������������������Ŀ';
END;
