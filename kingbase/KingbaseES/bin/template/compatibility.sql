-- BUGID: 8762: set up compatibility shemas.

-- DBA_OBJECTS describes all objects in the database.
CREATE OR REPLACE VIEW dba_objects(
		  owner
        , object_name
        , subobject_name
        , object_id, data_object_id
        , object_type, created
        , last_ddl_time, timestamp
        , status, temporary, generated, secondary
        , namespace
		)
AS 
SELECT    CAST(u.usename AS VARCHAR2(30 BYTE)) -- TODO: Oracle uses 32.
        , CAST(relname AS VARCHAR2(30 BYTE))
        , CAST(NULL AS VARCHAR2(30 BYTE))
        , CAST(CAST(c.oid AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
        , CAST(NULL AS NUMERIC(38,0))
        , CAST(
            (CASE relkind
	            -- when 'c' THEN 'COMPOSITE'
	            WHEN 'r' THEN 'TABLE'
	            WHEN 'S' THEN 'SEQUENCE'
	            -- WHEN 's' THEN 'SPECIAL'
	            WHEN 't' THEN 'TYPE'
	            WHEN 'v' THEN 'VIEW'
	            WHEN 'i' THEN 'INDEX'
	            ELSE 'UNKNOWN'
			END)
            AS VARCHAR2(19 BYTE))
        , CAST(NULL AS DATE)
        , CAST(NULL AS DATE)
        , CAST(NULL AS VARCHAR2(20 BYTE))
        , CAST(
            (CASE c.relkind
                WHEN 'v' THEN
                (CASE c.reloptions @> array['force_view=0']
                WHEN 't' THEN 'INVALID'
                ELSE 'VALID'
                END)
            ELSE 'VALID'
          END) AS VARCHAR2(7 BYTE))
        , CAST((CASE WHEN  ts.spcname = 'TEMP' THEN 'Y' ELSE 'N' END) AS VARCHAR2(1 BYTE))
        , CAST(NULL AS VARCHAR2(1 BYTE))
        , CAST(NULL AS VARCHAR2(1 BYTE))
        , CAST(CAST(relnamespace AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
    FROM sys_class c JOIN sys_user u
        ON c.relowner = u.usesysid JOIN sys_tablespace ts ON ts.oid = c.reltablespace
    WHERE NOT (c.relparttyp = 'p')
		AND c.RELNAMESPACE != sys_my_temp_schema()

UNION
SELECT    CAST(u.usename AS VARCHAR2(30 BYTE)) -- TODO: Oracle uses 32.
        , CAST(l.relname AS VARCHAR2(30 BYTE))
        , CAST(c.relname AS VARCHAR2(30 BYTE)) 
        , CAST(CAST(c.oid AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
        , CAST(CAST(c.oid AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
        , CAST(
			(CASE c.relkind 
				WHEN 'r' THEN 'TABLE PARTITION'
				WHEN 'i' THEN 'INDEX PARTITON'
				ELSE 'UNKNOWN'
			END)
		  AS VARCHAR2(19 BYTE))
        , CAST(NULL AS DATE)
        , CAST(NULL AS DATE)
        , CAST(NULL AS VARCHAR2(20 BYTE))
        , CAST('VALID' AS VARCHAR2(7 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(CAST(c.relnamespace AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
    FROM sys_class c JOIN sys_user u ON c.relowner = u.usesysid, 
	     sys_class l, sys_partition p
    WHERE c.relparttyp = 'p' AND p.partitionrelid = c.oid 
	      AND p.partrelid = l.oid

UNION

SELECT    CAST(current_user AS VARCHAR2(30 BYTE)) -- TODO: Oracle uses 32.
        , CAST('TRIGGER_PKG' AS VARCHAR2(30 BYTE))
        , CAST(NULL AS VARCHAR2(30 BYTE))
        , CAST(0 AS NUMERIC(38,0))
        , CAST(NULL AS NUMERIC(38,0))
        , CAST('PACKAGE'  AS VARCHAR2(19 BYTE))
        , CAST(NULL AS DATE)
        , CAST(NULL AS DATE)
        , CAST(NULL AS VARCHAR2(20 BYTE))
        , CAST('VALID' AS VARCHAR2(7 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(0 AS NUMERIC(38,0))

UNION

SELECT    CAST(current_user AS VARCHAR2(30 BYTE)) -- TODO: Oracle uses 32.
        , CAST('OPEN2000E_PKG' AS VARCHAR2(30 BYTE))
        , CAST(NULL AS VARCHAR2(30 BYTE))
        , CAST(0 AS NUMERIC(38,0))
        , CAST(NULL AS NUMERIC(38,0))
        , CAST('PACKAGE'  AS VARCHAR2(19 BYTE))
        , CAST(NULL AS DATE)
        , CAST(NULL AS DATE)
        , CAST(NULL AS VARCHAR2(20 BYTE))
        , CAST('VALID' AS VARCHAR2(7 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(0 AS NUMERIC(38,0))
        
UNION

SELECT    CAST(current_user AS VARCHAR2(30 BYTE)) -- TODO: Oracle uses 32.
        , CAST('FORM_TM_ND_TAP_MEAS' AS VARCHAR2(30 BYTE))
        , CAST(NULL AS VARCHAR2(30 BYTE))
        , CAST(0 AS NUMERIC(38,0))
        , CAST(NULL AS NUMERIC(38,0))
        , CAST('PACKAGE'  AS VARCHAR2(19 BYTE))
        , CAST(NULL AS DATE)
        , CAST(NULL AS DATE)
        , CAST(NULL AS VARCHAR2(20 BYTE))
        , CAST('VALID' AS VARCHAR2(7 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(0 AS NUMERIC(38,0))
        
UNION

SELECT    CAST(current_user AS VARCHAR2(30 BYTE)) -- TODO: Oracle uses 32.
        , CAST('NEW_STATISTICS_SAMPLE_PKG' AS VARCHAR2(30 BYTE))
        , CAST(NULL AS VARCHAR2(30 BYTE))
        , CAST(0 AS NUMERIC(38,0))
        , CAST(NULL AS NUMERIC(38,0))
        , CAST('PACKAGE'  AS VARCHAR2(19 BYTE))
        , CAST(NULL AS DATE)
        , CAST(NULL AS DATE)
        , CAST(NULL AS VARCHAR2(20 BYTE))
        , CAST('VALID' AS VARCHAR2(7 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(0 AS NUMERIC(38,0))
        
UNION

SELECT    CAST(u.usename AS VARCHAR2(30 BYTE)) -- TODO: Oracle uses 32.
        , CAST(proname AS VARCHAR2(30 BYTE))
        , CAST(NULL AS VARCHAR2(30 BYTE))
        , CAST(CAST(p.oid AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
        , CAST(NULL AS NUMERIC(38,0))
        , CAST(
            (CASE protype
	            WHEN 'f' THEN 'FUNCTION'
	            WHEN 'p' THEN 'PROCEDURE'
	            ELSE 'UNKNOWN'
			END)
            AS VARCHAR2(19 BYTE))
        , CAST(NULL AS DATE)
        , CAST(NULL AS DATE)
        , CAST(NULL AS VARCHAR2(20 BYTE))
        , CAST(
              (CASE p.PROSTATUS 
               WHEN 't' THEN 'VALID'
               WHEN 'f' THEN 'INVALID'
               END) AS VARCHAR2(7 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(CAST(pronamespace AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
    FROM sys_proc p JOIN sys_user u
        ON p.proowner = u.usesysid
	WHERE p.propkgoid = 0

UNION

SELECT    CAST(u.usename AS VARCHAR2(30 BYTE)) -- TODO: Oracle uses 32.
        , CAST(t.tgname AS VARCHAR2(30 BYTE))
        , CAST(NULL AS VARCHAR2(30 BYTE))
        , CAST(CAST(t.oid AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
        , CAST(NULL AS NUMERIC(38,0))
        , CAST('TRIGGER'AS VARCHAR2(19 BYTE))
        , CAST(NULL AS DATE)
        , CAST(NULL AS DATE)
        , CAST(NULL AS VARCHAR2(20 BYTE))
        , CAST((CASE WHEN  t.tgstatus = 't' THEN 'VALID' ELSE 'INVALID' END) AS VARCHAR2(7 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(CAST(tgnamespace AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
	FROM sys_trigger t JOIN sys_class c ON t.tgrelid = c.oid , 
	     sys_user u
	WHERE  c.relowner = u.usesysid
                  
UNION

SELECT    CAST(u.usename AS VARCHAR2(30 BYTE)) -- TODO: Oracle uses 32.
        , CAST(pkgname AS VARCHAR2(30 BYTE))
        , CAST(NULL AS VARCHAR2(30 BYTE))
        , CAST(CAST(pkg.oid AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
        , CAST(NULL AS NUMERIC(38,0))
        , CAST(
			(CASE pkgtype
                WHEN 's' THEN 'PACKAGE'
	            WHEN 'b' THEN 'PACKAGE BODY'
	            ELSE 'UNKNOWN'
			END)
			AS VARCHAR2(19 BYTE))
        , CAST(NULL AS DATE)
        , CAST(NULL AS DATE)
        , CAST(NULL AS VARCHAR2(20 BYTE))
        , CAST(
              (CASE pkg.PKGSTATUS
              WHEN 't' THEN 'VALID'
              WHEN 'f' THEN 'INVALID'
              END) AS VARCHAR2(7 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(NULL AS VARCHAR(1 BYTE))
        , CAST(CAST(pkgnamespace AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
    FROM sys_package pkg JOIN sys_user u
        ON pkg.pkgowner = u.usesysid
;

REVOKE ALL ON sys_catalog.dba_objects FROM PUBLIC;

-- USER_OBJECTS describes all objects owned by the current user. 
-- This VIEW does not display the OWNER column.
CREATE OR REPLACE VIEW user_objects
   AS
	SELECT object_name, subobject_name
	       , object_id, data_object_id
		   , object_type
		   , created, last_ddl_time, timestamp
		   , status
		   , temporary, generated, secondary
		   , namespace
    FROM dba_objects
	WHERE owner = CAST(current_user AS VARCHAR(30 BYTE)) 
;

-- bug#23796: an abnormity with qurrying to all_objects view.
-- test current user has privilege to the trigger.
CREATE OR REPLACE FUNCTION has_trigger_privilege(triggeroid OID, operation NAME)
RETURNS BOOL AS
DECLARE
	funcoid OID;
	relid OID;
BEGIN
	funcoid := NULL;
	relid := NULL;
	SELECT TGRELID, TGFOID INTO relid, funcoid FROM SYS_TRIGGER WHERE OID=triggeroid;
	IF funcoid IS NOT NULL AND has_table_privilege(CAST(CAST(relid AS VARCHAR(38 BYTE)) AS oid), 'TRIGGER') THEN
		RETURN has_function_privilege(CAST(CAST(funcoid AS VARCHAR(38 BYTE)) AS oid), operation);
	ELSE
		RETURN FALSE;
	END IF;
END;

-- ALL_OBJECTS describes all objects accessible to the current user.
CREATE OR REPLACE VIEW all_objects
    AS
    SELECT * FROM dba_objects
	WHERE owner = CAST(current_user AS VARCHAR2(30 BYTE))
	    OR ((object_type = 'PROCEDURE' OR object_type = 'FUNCTION') 
		     AND has_function_privilege(CAST(CAST(object_id AS VARCHAR(38 BYTE)) AS oid), 'EXECUTE')
			 )
		OR ((object_type = 'PACKAGE' OR object_type = 'PACKAGE BODY')
			 AND has_package_privilege(CAST(object_name AS NAME), 'EXECUTE')
			 )
		OR ((object_type = 'TRIGGER') AND has_trigger_privilege(CAST(CAST(object_id AS VARCHAR(38 BYTE)) AS oid), 'EXECUTE')
			 ) -- bug#23796: an abnormity with qurrying to all_objects view.
		OR ((object_type <> 'PROCEDURE' AND object_type <> 'FUNCTION'
			AND object_type <> 'PACKAGE' AND object_type <> 'PACKAGE BODY' AND object_type <> 'TRIGGER') -- bug#23796: an abnormity with qurrying to all_objects view.
                     AND (has_table_privilege(CAST(CAST(object_id AS VARCHAR(38 BYTE)) AS oid), 'SELECT')
                     OR has_table_privilege(CAST(CAST(object_id AS VARCHAR(38 BYTE)) AS oid), 'INSERT')
                     OR has_table_privilege(CAST(CAST(object_id AS VARCHAR(38 BYTE)) AS oid), 'UPDATE')
                     OR has_table_privilege(CAST(CAST(object_id AS VARCHAR(38 BYTE)) AS oid), 'DELETE')
                     OR has_table_privilege(CAST(CAST(object_id AS VARCHAR(38 BYTE)) AS oid), 'REFERENCES')
                     OR has_table_privilege(CAST(CAST(object_id AS VARCHAR(38 BYTE)) AS oid), 'TRIGGER'))
		   )
;

-- DBA_TABLES describes all (partition) tables in the database.
CREATE OR REPLACE VIEW dba_tables(OWNER
		, TABLE_NAME
		, TABLESPACE_NAME
		, CLUSTER_NAME
		, IOT_NAME
		, STATUS
		, PCT_FREE
		, PCT_USED
		, INI_TRANS
		, MAX_TRANS
		, INITIAL_EXTENT
		, NEXT_EXTENT
		, MIN_EXTENTS
		, MAX_EXTENTS
		, PCT_INCREASE
		, FREELISTS
		, FREELIST_GROUPS
		, LOGGING
		, BACKED_UP
		, NUM_ROWS
		, BLOCKS
		, EMPTY_BLOCKS
		, AVG_SPACE
		, CHAIN_CNT
		, AVG_ROW_LEN
		, AVG_SPACE_FREELIST_BLOCKS
		, NUM_FREELIST_BLOCKS
		, DEGREE
		, INSTANCES
		, CACHE
		, TABLE_LOCK
		, SAMPLE_SIZE
		, LAST_ANALYZED
		, PARTITIONED
		, IOT_TYPE
		, TEMPORARY
		, SECONDARY
		, NESTED
		, BUFFER_POOL
		, ROW_MOVEMENT
		, GLOBAL_STATS
		, USER_STATS
		, DURATION
		, SKIP_CORRUPT
		, MONITORING
		, CLUSTER_OWNER
		, DEPENDENCIES
		, COMPRESSION
		, DROPPED
		)
AS
SELECT DISTINCT CAST(SYS_GET_USERBYID(c.relowner) AS VARCHAR(30 BYTE)) 
        , CAST(relname AS VARCHAR(30 BYTE))
        , CAST(if(c.relparttyp = 't' or c.relparttyp = 'v' or i.INDISCLUSTERED, NULL, ts.spcname)  AS VARCHAR(30 BYTE))
        , CAST(NULL AS VARCHAR(30 BYTE))
        , CAST(NULL AS VARCHAR(30 BYTE))
        , CAST('valid' AS VARCHAR(30 BYTE))
        , 50
        , 50
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , CAST('yes' AS VARCHAR(3 BYTE))
        , CAST('N' AS VARCHAR(1 BYTE))
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , CAST('1' AS VARCHAR(10 BYTE))
        , CAST('1' AS VARCHAR(10 BYTE))
        , CAST('N' AS VARCHAR(5 BYTE))
        , CAST('ENABLED' AS VARCHAR(8 BYTE))
        , 0
        , CAST(NULL AS DATE)
        , CAST('yes' AS VARCHAR(3 BYTE))
		, CAST(NULL AS VARCHAR(12 BYTE))
		, CAST((CASE WHEN  ts.spcname = 'TEMP' THEN 'Y' ELSE 'N' END) AS VARCHAR(1 BYTE))
		, CAST('N' AS VARCHAR(1 BYTE))
		, CAST('no' AS VARCHAR(3 BYTE))
		, CAST('DEFAULT' AS VARCHAR(7 BYTE))
		, CAST('DISABLED' AS VARCHAR(8 BYTE))
        , CAST('yes' AS VARCHAR(3 BYTE))
        , CAST('yes' AS VARCHAR(3 BYTE))
        , CAST(
			(CASE WHEN ts.spcname = 'TEMP' THEN
			  (CASE (array_to_string(c.reloptions, ', ') ilike '%oncommit=1%')
				WHEN true THEN 'SYS$SESSION'
				ELSE 'SYS$TRANSACTION'
				END)
			  ELSE ' '
			  END	
			)AS VARCHAR(15 BYTE))
		, CAST('DISABLED' AS VARCHAR(8 BYTE))
        , CAST('yes' AS VARCHAR(3 BYTE))
        , CAST(NULL AS VARCHAR(30 BYTE))
		, CAST('DISABLED' AS VARCHAR(8 BYTE))
		, CAST('DISABLED' AS VARCHAR(8 BYTE))
		, CAST('no' AS VARCHAR(3 BYTE))
    FROM sys_class c, sys_tablespace ts, sys_index i
	WHERE relkind = 'r' AND relparttyp != 'p'
		AND c.reltablespace=ts.oid
		AND c.RELNAMESPACE != sys_my_temp_schema()
		and c.oid = i.indrelid(+);

REVOKE ALL ON sys_catalog.dba_tables FROM PUBLIC;

-- USER_TABLES describes all (partition) tables owned by the current user.
CREATE OR REPLACE VIEW user_tables
AS
	SELECT TABLE_NAME
		, TABLESPACE_NAME
		, CLUSTER_NAME
		, IOT_NAME
		, STATUS
		, PCT_FREE
		, PCT_USED
		, INI_TRANS
		, MAX_TRANS
		, INITIAL_EXTENT
		, NEXT_EXTENT
		, MIN_EXTENTS
		, MAX_EXTENTS
		, PCT_INCREASE
		, FREELISTS
		, FREELIST_GROUPS		
		, LOGGING
		, BACKED_UP
		, NUM_ROWS
		, BLOCKS
		, EMPTY_BLOCKS
		, AVG_SPACE
		, CHAIN_CNT
		, AVG_ROW_LEN
		, AVG_SPACE_FREELIST_BLOCKS
		, NUM_FREELIST_BLOCKS
		, DEGREE
		, INSTANCES
		, CACHE
		, TABLE_LOCK
		, SAMPLE_SIZE
		, LAST_ANALYZED
		, PARTITIONED
		, IOT_TYPE
		, TEMPORARY
		, SECONDARY
		, NESTED
		, BUFFER_POOL
		, ROW_MOVEMENT
		, GLOBAL_STATS
		, USER_STATS
		, DURATION
		, SKIP_CORRUPT
		, MONITORING
		, CLUSTER_OWNER
		, DEPENDENCIES
		, COMPRESSION
		, DROPPED		
    FROM dba_tables
        WHERE owner = CAST(current_user AS VARCHAR(30 BYTE))
;

-- ALL_TABLES describes all (partition) tables accessible to the current user.
CREATE OR REPLACE VIEW all_tables(OWNER
		, TABLE_NAME
		, TABLESPACE_NAME
		, CLUSTER_NAME
		, IOT_NAME
		, STATUS
		, PCT_FREE
		, PCT_USED
		, INI_TRANS
		, MAX_TRANS
		, INITIAL_EXTENT
		, NEXT_EXTENT
		, MIN_EXTENTS
		, MAX_EXTENTS
		, PCT_INCREASE
		, FREELISTS
		, FREELIST_GROUPS
		, LOGGING
		, BACKED_UP
		, NUM_ROWS
		, BLOCKS
		, EMPTY_BLOCKS
		, AVG_SPACE
		, CHAIN_CNT
		, AVG_ROW_LEN
		, AVG_SPACE_FREELIST_BLOCKS
		, NUM_FREELIST_BLOCKS
		, DEGREE
		, INSTANCES
		, CACHE
		, TABLE_LOCK
		, SAMPLE_SIZE
		, LAST_ANALYZED
		, PARTITIONED
		, IOT_TYPE
		, TEMPORARY
		, SECONDARY
		, NESTED
		, BUFFER_POOL
		, ROW_MOVEMENT
		, GLOBAL_STATS
		, USER_STATS
		, DURATION
		, SKIP_CORRUPT
		, MONITORING
		, CLUSTER_OWNER
		, DEPENDENCIES
		, COMPRESSION
		, DROPPED
		)
AS
SELECT DISTINCT CAST(SYS_GET_USERBYID(c.relowner) AS VARCHAR(30 BYTE)) 
        , CAST(relname AS VARCHAR(30 BYTE))
        , CAST(if(c.relparttyp = 't' or c.relparttyp = 'v' or i.INDISCLUSTERED, NULL, ts.spcname)  AS VARCHAR(30 BYTE))
        , CAST(NULL AS VARCHAR(30 BYTE))
        , CAST(NULL AS VARCHAR(30 BYTE))
        , CAST('valid' AS VARCHAR(30 BYTE))
        , 50
        , 50
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , CAST('yes' AS VARCHAR(3 BYTE))
        , CAST('N' AS VARCHAR(1 BYTE))
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , 0
        , CAST('1' AS VARCHAR(10 BYTE))
        , CAST('1' AS VARCHAR(10 BYTE))
        , CAST('N' AS VARCHAR(5 BYTE))
        , CAST('ENABLED' AS VARCHAR(8 BYTE))
        , 0
        , CAST(NULL AS DATE)
        , CAST('yes' AS VARCHAR(3 BYTE))
		, CAST(NULL AS VARCHAR(12 BYTE))
		, CAST((CASE WHEN  ts.spcname = 'TEMP' THEN 'Y' ELSE 'N' END)AS VARCHAR(1 BYTE))
		, CAST('N' AS VARCHAR(1 BYTE))
		, CAST('no' AS VARCHAR(3 BYTE))
		, CAST('DEFAULT' AS VARCHAR(7 BYTE))
		, CAST('DISABLED' AS VARCHAR(8 BYTE))
        , CAST('yes' AS VARCHAR(3 BYTE))
        , CAST('yes' AS VARCHAR(3 BYTE))
        , CAST(
			(CASE WHEN ts.spcname = 'TEMP' THEN
			  (CASE (array_to_string(c.reloptions, ', ') ilike '%oncommit=1%')
				WHEN true THEN 'SYS$SESSION'
				ELSE 'SYS$TRANSACTION'
				END)
			  ELSE ' '
			  END	
			)AS VARCHAR(15 BYTE))
		, CAST('DISABLED' AS VARCHAR(8 BYTE))
        , CAST('yes' AS VARCHAR(3 BYTE))
        , CAST(NULL AS VARCHAR(30 BYTE))
		, CAST('DISABLED' AS VARCHAR(8 BYTE))
		, CAST('DISABLED' AS VARCHAR(8 BYTE))
		, CAST('no' AS VARCHAR(3 BYTE))
    FROM sys_class c, sys_tablespace ts, sys_index i
	WHERE relkind = 'r' AND relparttyp != 'p'
		AND c.reltablespace=ts.oid
		AND c.RELNAMESPACE != sys_my_temp_schema()
		and c.oid = i.indrelid(+)
		AND ((c.relowner=uid)
			OR has_table_privilege(c.oid, 'SELECT')
			OR has_table_privilege(c.oid, 'INSERT')
			OR has_table_privilege(c.oid, 'UPDATE')
			OR has_table_privilege(c.oid, 'DELETE')
			OR has_table_privilege(c.oid, 'REFERENCES')
			OR has_table_privilege(c.oid, 'TRIGGER'))
;

-- BUGID: 9262: add view dba_users to be compatible with oracle
-- DBA_USER describes all the user's information.
CREATE OR REPLACE VIEW dba_users(USERNAME
	, USER_ID
	, PASSWORD
	, ACCOUNT_STATUS
	, LOCK_DATE
	, EXPIRY_DATE
	, DEFAULT_TABLESPACE
	, TEMPORARY_TABLESPACE
	, CREATED
	, PROFILE
	, INITIAL_RSRC_CONSUMER_GROUP
	, EXTERNAL_NAME
	, PASSWORD_VERSIONS
	, EDITIONS_ENABLED
	)
AS
SELECT CAST(rolname AS VARCHAR(30 BYTE))
	, CAST(CAST(oid AS VARCHAR(38 BYTE)) AS NUMERIC(38,0))
	, CAST(NULL AS VARCHAR(30 BYTE))
	, CAST(CASE WHEN CURRENT_TIMESTAMP <= ISNULL(rolvaliduntil, CURRENT_TIMESTAMP) THEN 'OPEN' ELSE 'EXPIRED' END AS VARCHAR(32 BYTE))
	, CAST(NULL AS DATE)
	, CAST(rolvaliduntil AS DATE)
	, CAST('SYSTEM' AS VARCHAR(30 BYTE))
	, CAST(NULL AS VARCHAR(30 BYTE))
	, CAST(NULL AS DATE)
	, CAST(NULL AS VARCHAR(30 BYTE))
	, CAST(NULL AS VARCHAR(30 BYTE))
	, CAST(NULL AS VARCHAR(4000 BYTE))
	, CAST(LEFT(SUBSTRING(version(), INSTR(version(), ' ') + 1, INSTR(version(), ' ', 1, 2) - INSTR(version(), ' ') - 1), 5) AS VARCHAR(8 BYTE))
	, CAST('N' as VARCHAR(1 BYTE))
	FROM sys_catalog.sys_authid
	WHERE roltype <> 'R' 
	AND roldatabase = (SELECT OID FROM SYS_DATABASE WHERE DATNAME = CURRENT_DATABASE());
	
-- bug#11152: add view dba_col_privs to be compatible with oracle
-- DBA_COL_PRIVS describes all the user's or role's column privileges.
CREATE OR REPLACE VIEW dba_col_privs AS
    SELECT CAST(u_grantor.rolname AS character varying(30 byte)) AS grantor,
 		   CAST(u_owner.rolname AS character varying(30  byte)) AS owner,
		   CAST(grantee.rolname AS character varying(30  byte)) AS grantee,
           CAST(current_database() AS character varying(30  byte)) AS table_catalog,
           CAST(nc.nspname AS character varying(30  byte)) AS table_schema,
           CAST(c.relname AS character varying(30  byte)) AS table_name,
           CAST(a.attname AS character varying(30  byte)) AS column_name,
           CAST(pr.type AS character varying(40 char)) AS privilege_type,
           CAST(
             CASE WHEN aclcontains(a.attacl,
                                   makeaclitem(grantee.oid, u_grantor.oid, pr.type, true))
                  THEN 'YES' ELSE 'NO' END AS character varying(3 char)) AS is_grantable
    FROM sys_attribute a,
         sys_class c,
         sys_authid u_owner,
         sys_namespace nc,
         sys_authid u_grantor,
         ( SELECT oid, rolname FROM sys_authid
		   UNION ALL
		   SELECT 0::oid,'PUBLIC'
         ) AS grantee (oid, rolname),
         (SELECT 'SELECT' UNION ALL
          SELECT 'INSERT' UNION ALL
          SELECT 'UPDATE' UNION ALL
          SELECT 'REFERENCES') AS pr (type)
    WHERE a.attrelid = c.oid
		  AND c.relowner=u_owner.oid
          AND c.relkind IN ('r', 'v')
		  AND NOT a.attisdropped
		  AND c.relparttyp != 'p'
          AND aclcontains(a.attacl,
                          makeaclitem(grantee.oid, u_grantor.oid, pr.type, false))
          AND substr(nc.nspname,1,4)<>'SYS_'
		  AND substr(nc.nspname,1,12)<>'INFORMATION_'
      AND c.relnamespace = nc.oid;


-- bug#11152: add view USER_COL_PRIVS to be compatible with oracle
-- USER_COL_PRIVS describes the current user's column privileges.
CREATE VIEW USER_COL_PRIVS AS
	SELECT * FROM dba_col_privs
	WHERE grantor=cast(current_user as varchar(30 byte))
	      OR grantee=cast(current_user as varchar(30 byte))
		  OR owner=cast(current_user as varchar(30 byte));
		  
-- bug#11152: add view ALL_COL_PRIVS to be compatible with oracle
-- ALL_COL_PRIVS describes the current user's and active role's(including PUBLIC) column privileges.
CREATE VIEW ALL_COL_PRIVS AS
	SELECT dba_col_privs.* FROM dba_col_privs
	WHERE grantee='PUBLIC'
          OR grantor=cast(current_user as varchar(30 byte))
	      OR grantee=cast(current_user as varchar(30 byte))
		  OR owner=cast(current_user as varchar(30 byte))
          OR grantee in (select cast(r.rolname as varchar(30 byte)) from sys_authid r,sys_authid u where u.roldefault=r.oid
                         UNION ALL
                         select cast(current_role as varchar(30 byte)));
                         
REVOKE ALL ON dba_col_privs FROM PUBLIC;

-- bug#11152: same as ALL_COL_PRIVS
CREATE VIEW SYS_COL_PRIVS AS SELECT * FROM ALL_COL_PRIVS;

-- bug#13918: Compatible with ORACLE, add ALL_CONSTRAINTS view
CREATE OR REPLACE  VIEW ALL_CONSTRAINTS AS 
SELECT (sys_get_userbyid(c.relowner))::CHARACTER VARYING(63 BYTE) AS "OWNER" ,
(cs1.CONNAME)::CHARACTER VARYING(63 BYTE) AS CONSTRAINT_NAME,
(
   	CASE WHEN (cs1.CONTYPE = 'c'::"CHAR") THEN 'C'::TEXT 
  	     WHEN (cs1.CONTYPE = 'p'::"CHAR") THEN 'P'::TEXT 
         WHEN (cs1.CONTYPE = 'u'::"CHAR") THEN 'U'::TEXT 
         WHEN (cs1.CONTYPE = 'f'::"CHAR") THEN 'R'::TEXT ELSE NULL::TEXT 
    END
)::CHARACTER VARYING(1 BYTE) AS CONSTRAINT_TYPE,
(C.RELNAME)::CHARACTER VARYING(63 BYTE) AS TABLE_NAME,
cs1.CONSRC AS SEARCH_CONDITION,
SYS_GET_USERBYID(c_ref.RELOWNER)::CHARACTER VARYING(63 BYTE) AS R_OWNER,
(
	cs2.conname::CHARACTER VARYING(63 BYTE) 
) AS R_CONSTRAINT_NAME,
  (
  	CASE WHEN (cs1.CONFDELTYPE = 'a'::"CHAR") THEN 'NO ACTION'::TEXT 
      	WHEN (cs1.CONFDELTYPE = 'c'::"CHAR") THEN 'CASCADE'::TEXT 
      	WHEN (cs1.CONFDELTYPE = 'r'::"CHAR") THEN 'RESTRICT'::TEXT 
      	WHEN (cs1.CONFDELTYPE = 'n'::"CHAR") THEN 'SET NULL'::TEXT 
      	WHEN (cs1.CONFDELTYPE = 'd'::"CHAR") THEN 'SET DEFAULT'::TEXT 
      	ELSE NULL::TEXT END
  )::CHARACTER VARYING(9 BYTE) AS DELETE_RULE,
  (
    CASE WHEN (cs1.CONTYPE = 'f'::"CHAR") THEN
    (
        SELECT DISTINCT (CASE WHEN (TRG.TGENABLED=true) THEN 'ENABLED'::TEXT
                                ELSE 'DISABLED'::TEXT END ) 
        FROM SYS_TRIGGER TRG
        WHERE  TRG.TGCONSTRNAME = cs1.CONNAME 
        AND TRG.TGRELID = cs1.CONRELID
    )
      WHEN (cs1.CONTYPE = 'p'::"CHAR" OR cs1.CONTYPE = 'u'::"CHAR") THEN
      (
	         SELECT (CASE WHEN (IND.INDUNUSABLE=false) THEN 'ENABLED'::TEXT
	                       ELSE  'DISABLED'::TEXT END ) 
           	  FROM SYS_INDEX IND,SYS_DEPEND DEP
	         WHERE DEP.REFOBJID=cs1.OID
           	  AND DEP.CLASSID='SYS_CLASS'::REGCLASS
	         AND EXISTS (SELECT * FROM SYS_CLASS WHERE OID=DEP.OBJID AND RELKIND='i')
	         AND IND.INDEXRELID=DEP.OBJID
      )
      WHEN (cs1.CONTYPE = 'c'::"CHAR") THEN 
	  (
			CASE WHEN (cs1.CONSTATUS = 'f') THEN 'DISABLE'::TEXT 
			ELSE 'ENABLE'::TEXT END	
	  )
	  END
)::CHARACTER VARYING(8 BYTE) AS "STATUS", 
  (
     	CASE WHEN (cs1.CONDEFERRABLE = false) THEN 'NOT DEFERRABLE'::TEXT 
     	ELSE 'DEFERRABLE'::TEXT END
   )::CHARACTER VARYING(14 CHAR) AS "DEFERRABLE",
  (
     	CASE WHEN (cs1.CONDEFERRED = false) THEN 'IMMEDIATE'::TEXT 
     	ELSE 'DEFERRED'::TEXT END
  )::CHARACTER VARYING(9 CHAR) AS "DEFERRED",
(
  CASE WHEN (cs1.CONVALIDATE ='t') THEN 'VALIDATED'::TEXT
       WHEN (cs1.CONVALIDATE ='f') THEN 'NOVALIDATED'::TEXT
      ELSE NULL::TEXT END
)::CHARACTER VARYING(13 BYTE) AS "VALIDATED", 
  'USER NAME'::CHARACTER VARYING(14 BYTE) AS GENERATED,
  NULL::CHARACTER VARYING(3 CHAR) AS BAD, 
  NULL::CHARACTER VARYING(4 CHAR) AS RELY, 
  NULL::TIMESTAMP(0) WITHOUT TIME ZONE AS LAST_CHANGE,
(	
	CASE WHEN (cs1.CONTYPE = 'p' OR cs1.CONTYPE = 'u') THEN
		(
			SELECT sys_get_userbyid(t.relowner) FROM SYS_INDEX IND, SYS_CLASS T, SYS_DEPEND DEP
			WHERE INDEXRELID = DEP.OBJID 
			AND DEP.REFOBJID = cs1.OID
			AND T.OID = IND.INDEXRELID
		)
	ELSE
		NULL
	END
 )::CHARACTER VARYING(63 BYTE) AS "INDEX_OWNER",
 (	
	CASE WHEN (cs1.CONTYPE = 'p' OR cs1.CONTYPE = 'u') THEN
		(
			SELECT T.RELNAME FROM SYS_INDEX IND ,SYS_CLASS T,SYS_DEPEND DEP
			WHERE INDEXRELID = DEP.OBJID 
			AND DEP.REFOBJID = cs1.OID
			AND T.OID = IND.INDEXRELID
		)
	ELSE
		NULL
	END
 )::CHARACTER VARYING(63 BYTE) AS "INDEX_NAME",
 NULL::CHARACTER VARYING(7 BYTE) AS INVALID, 
  NULL::CHARACTER VARYING(14 BYTE) AS VIEW_RELATED
from( sys_constraint cs1 left outer join sys_constraint cs2 on 
		(
			/* bug#16909: bad r_constraint_name value. */
			cs1.confrelid = cs2.conrelid and 
			(cs2.contype = 'u' or cs2.contype = 'p') and  /* show only keys which can keep rows unique. */
			cs1.contype = 'f' and /* only foreign key make r_constraint_name not null */
			cs2.conkey = cs1.confkey	/* Does cs2.conname make the foreign key(cs1.conname) values unique? */
		)
	)
	-- The outer join bellowing is used to get the referenced relation's information.
	left outer join sys_class c_ref on cs1.confrelid = c_ref.oid
	,
	sys_class c
WHERE cs1.CONRELID = C.OID
  AND (HAS_TABLE_PRIVILEGE(C.OID,'SELECT') = TRUE
	OR has_table_privilege(c.oid, 'INSERT') = TRUE
	OR has_table_privilege(c.oid, 'UPDATE') = TRUE
	OR has_table_privilege(c.oid, 'DELETE') = TRUE
	OR has_table_privilege(c.oid, 'REFERENCES') = TRUE
	OR has_table_privilege(c.oid, 'TRIGGER'));
-- bug#13918: Compatible with ORACLE, add USER_CONSTRAINTS view
CREATE OR REPLACE VIEW USER_CONSTRAINTS AS 
SELECT * FROM ALL_CONSTRAINTS 
WHERE OWNER = (SELECT cast(CURRENT_USER as varchar2(30 byte)));


-- bug#13918: Compatible with ORACLE, add DBA_TAB_COLS view
CREATE OR REPLACE  VIEW DBA_TAB_COLS AS
SELECT 
U.USENAME ::CHARACTER VARYING(30 BYTE) AS "OWNER",
C.RELNAME ::CHARACTER VARYING(30 BYTE) AS TABLE_NAME,
ATTR.ATTNAME ::CHARACTER VARYING(30 BYTE) AS COLUMN_NAME,
(
  CASE T.TYPNAME
    WHEN 'BPCHAR' THEN 'CHAR'
  ELSE
    T.TYPNAME
  END
)::CHARACTER VARYING(106 BYTE) AS DATA_TYPE,
NULL ::CHARACTER VARYING(3 CHAR) AS DATA_TYPE_MOD,
AU.ROLNAME ::CHARACTER VARYING(30 BYTE) AS DATA_TYPE_OWNER,
(
	CASE WHEN ATTR.ATTLEN = -1 THEN
	(
		CASE T.TYPNAME WHEN 'BIT' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'BIT VARYING' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIMETZ' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIME' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIMESTAMPTZ' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIMESTAMP' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'INTERVAL' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'VARBIT' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
			--bug#15842: system views compatible with oracle.
			--we ignore char or byte option, as can't get the relation of them.
			--We also ignore atttypmod = -1 for special situations, such as sys_class.relkeyid, and sys_attribute.attkeyid, 
			--they are not bpchar, but appear to be.
			WHEN 'VARCHAR' THEN (CASE ATTR.ATTTYPMOD WHEN -1 THEN NULL ELSE ABS(ATTR.ATTTYPMOD) - 4 END)
			WHEN 'BPCHAR' THEN (CASE ATTR.ATTTYPMOD WHEN -1 THEN NULL ELSE ABS(ATTR.ATTTYPMOD) - 4 END)
  			ELSE (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)-4) ELSE 0 END)
		END
	)
  	ELSE
		ATTR.ATTLEN
  	END
  )::number AS DATA_LENGTH,
(
	CASE DATA_TYPE 
		WHEN 'NUMERIC' THEN 
    (
      CASE WHEN ATTR.ATTTYPMOD = -1 THEN 38
      ELSE ((ATTR.ATTTYPMOD - 4) >> 16) & 0xFFFF
      END
    )
		WHEN 'FLOAT4' THEN 7 --float
		WHEN 'FLOAT8' THEN 15 --double. hard coded in kingbase.
	ELSE 
		NULL
	END
)::number AS DATA_PRECISION,
(
	CASE DATA_TYPE 
		WHEN 'NUMERIC' THEN (ATTR.ATTTYPMOD - 4) & 0xFFFF
	ELSE 
		NULL
	END
)::number AS DATA_SCALE,
(
	if (ATTR.ATTNOTNULL, 'N', 'Y')
) ::CHARACTER VARYING(1 CHAR) AS NULLABLE,
ATTR.ATTNUM ::number AS COLUMN_ID,
(	
	CASE ATTR.ATTHASDEF WHEN FALSE THEN NULL
	ELSE DATA_LENGTH
	END
) ::number AS DEFAULT_LENGTH,
DEF.ADSRC::TEXT AS DATA_DEFAULT,
0 ::number AS NUM_DISTINCT,
0 ::number AS LOW_VALUE,
0 ::number AS HIGH_VALUE,
0 ::number AS DENSITY,
0 ::number AS NUM_NULLS,
0 ::number AS NUM_BUCKETS,
NULL::TIMESTAMP(0) WITHOUT TIME ZONE AS LAST_ANALYZED,
0 ::number AS SAMPLE_SIZE,
NULL ::CHARACTER VARYING(44 CHAR) AS CHARACTER_SET_NAME,
0 ::number AS CHAR_COL_DECL_LENGTH,
'NO' ::CHARACTER VARYING(3 CHAR) AS GLOBAL_STATS,
'NO' ::CHARACTER VARYING(3 CHAR) AS USER_STATS,
0 ::number AS AVG_COL_LEN,
(
	CASE DATA_TYPE IN('VARCHAR', 'BPCHAR', 'NCHAR', 'NVARCHAR') WHEN TRUE THEN DATA_LENGTH
	ELSE 0
	END
) :: number AS CHAR_LENGTH,
(
	CASE DATA_TYPE IN ('VARCHAR', 'BPCHAR', 'NCHAR', 'NVARCHAR') AND ATTR.ATTTYPMOD <> -1 WHEN TRUE THEN 
	(
		CASE ATTR.ATTTYPMOD >> 16 WHEN 0 THEN 'C'
		ELSE 'B'
		END
	)
	ELSE 
		NULL
	END
) ::CHARACTER VARYING(1 CHAR) AS CHAR_USED,
'NO' ::CHARACTER VARYING(3 CHAR) AS V80_FMT_IMAGE,
'NO' ::CHARACTER VARYING(3 CHAR) AS DATA_UPGRADED,
'NO' ::CHARACTER VARYING(3 CHAR) AS HIDDEN_COLUMN,
'NO' ::CHARACTER VARYING(3 CHAR) AS VIRTUAL_COLUMN,
0 ::number AS SEGMENT_COLUMN_ID,
ATTR.ATTNUM ::number AS INTERNAL_COLUMN_ID,
NULL ::CHARACTER VARYING(15 CHAR) AS HISTOGRAM,
NULL ::CHARACTER VARYING(4000 CHAR) AS QUALIFIED_COL_NAME
FROM SYS_USER U,SYS_CLASS C,SYS_ATTRIBUTE ATTR,SYS_TYPE T,SYS_AUTHID AU, SYS_ATTRDEF DEF
WHERE C.RELOWNER = U.USESYSID
AND ATTR.ATTNUM > 0
AND ATTR.ATTTYPID = T.OID
AND ATTR.ATTRELID = C.OID
AND T.TYPOWNER = AU.OID
AND ATTR.ATTNUM = DEF.ADNUM(+)
AND ATTR.ATTRELID = DEF.ADRELID(+);

REVOKE ALL ON sys_catalog.DBA_TAB_COLS FROM PUBLIC;

-- bug#13918: Compatible with ORACLE, add DBA_TAB_COLS view
CREATE OR REPLACE  VIEW ALL_TAB_COLS AS
SELECT 
U.USENAME ::CHARACTER VARYING(30 BYTE) AS "OWNER",
C.RELNAME ::CHARACTER VARYING(30 BYTE) AS TABLE_NAME,
ATTR.ATTNAME ::CHARACTER VARYING(30 BYTE) AS COLUMN_NAME,
(
  CASE T.TYPNAME
    WHEN 'BPCHAR' THEN 'CHAR'
  ELSE
    T.TYPNAME
  END
)::CHARACTER VARYING(106 BYTE) AS DATA_TYPE,
NULL ::CHARACTER VARYING(3 CHAR) AS DATA_TYPE_MOD,
AU.ROLNAME ::CHARACTER VARYING(30 BYTE) AS DATA_TYPE_OWNER,
(
	CASE WHEN ATTR.ATTLEN = -1 THEN
	(
		CASE T.TYPNAME WHEN 'BIT' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'BIT VARYING' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIMETZ' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIME' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIMESTAMPTZ' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIMESTAMP' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'INTERVAL' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'VARBIT' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			--bug#15842: system views compatible with oracle.
			--we ignore char or byte option, as can't get the relation of them.
			--We also ignore atttypmod = -1 for special situations, such as sys_class.relkeyid, and sys_attribute.attkeyid, 
			--they are not bpchar, but appear to be.
			WHEN 'VARCHAR' THEN (CASE ATTR.ATTTYPMOD WHEN -1 THEN NULL ELSE ABS(ATTR.ATTTYPMOD) - 4 END)
			WHEN 'BPCHAR' THEN (CASE ATTR.ATTTYPMOD WHEN -1 THEN NULL ELSE ABS(ATTR.ATTTYPMOD) - 4 END)
  			ELSE (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)-4) ELSE 0 END)
		END
	)
  	ELSE
		ATTR.ATTLEN
  	END
  )::number AS DATA_LENGTH,
(
	CASE DATA_TYPE 
		WHEN 'NUMERIC' THEN 
    (
      CASE WHEN ATTR.ATTTYPMOD = -1 THEN 38
      ELSE ((ATTR.ATTTYPMOD - 4) >> 16) & 0xFFFF
      END
    )
		WHEN 'FLOAT4' THEN 7 --float
		WHEN 'FLOAT8' THEN 15 --double. hard coded in kingbase.
	ELSE 
		NULL
	END
)::number AS DATA_PRECISION,
(
	CASE DATA_TYPE 
		WHEN 'NUMERIC' THEN (ATTR.ATTTYPMOD - 4) & 0xFFFF
	ELSE 
		NULL
	END
)::number AS DATA_SCALE,
(
	if (ATTR.ATTNOTNULL, 'N', 'Y')
) ::CHARACTER VARYING(1 CHAR) AS NULLABLE,
ATTR.ATTNUM ::number AS COLUMN_ID,
(	
	CASE ATTR.ATTHASDEF WHEN FALSE THEN NULL
	ELSE DATA_LENGTH
	END
) ::number AS DEFAULT_LENGTH,
DEF.ADSRC::TEXT AS DATA_DEFAULT,
0 ::number AS NUM_DISTINCT,
0 ::number AS LOW_VALUE,
0 ::number AS HIGH_VALUE,
0 ::number AS DENSITY,
0 ::number AS NUM_NULLS,
0 ::number AS NUM_BUCKETS,
NULL::TIMESTAMP(0) WITHOUT TIME ZONE AS LAST_ANALYZED,
0 ::number AS SAMPLE_SIZE,
NULL ::CHARACTER VARYING(44 CHAR) AS CHARACTER_SET_NAME,
0 ::number AS CHAR_COL_DECL_LENGTH,
'NO' ::CHARACTER VARYING(3 CHAR) AS GLOBAL_STATS,
'NO' ::CHARACTER VARYING(3 CHAR) AS USER_STATS,
0 ::number AS AVG_COL_LEN,
(
	CASE DATA_TYPE IN('VARCHAR', 'BPCHAR', 'NCHAR', 'NVARCHAR') WHEN TRUE THEN DATA_LENGTH
	ELSE 0
	END
) :: number AS CHAR_LENGTH,
(
	CASE DATA_TYPE IN ('VARCHAR', 'BPCHAR', 'NCHAR', 'NVARCHAR') AND ATTR.ATTTYPMOD <> -1 WHEN TRUE THEN 
	(
		CASE ATTR.ATTTYPMOD >> 16 WHEN 0 THEN 'C'
		ELSE 'B'
		END
	)
	ELSE 
		NULL
	END
) ::CHARACTER VARYING(1 CHAR) AS CHAR_USED,
'NO' ::CHARACTER VARYING(3 CHAR) AS V80_FMT_IMAGE,
'NO' ::CHARACTER VARYING(3 CHAR) AS DATA_UPGRADED,
'NO' ::CHARACTER VARYING(3 CHAR) AS HIDDEN_COLUMN,
'NO' ::CHARACTER VARYING(3 CHAR) AS VIRTUAL_COLUMN,
0 ::number AS SEGMENT_COLUMN_ID,
ATTR.ATTNUM ::number AS INTERNAL_COLUMN_ID,
NULL ::CHARACTER VARYING(15 CHAR) AS HISTOGRAM,
NULL ::CHARACTER VARYING(4000 CHAR) AS QUALIFIED_COL_NAME
FROM SYS_USER U,SYS_CLASS C,SYS_TYPE T,SYS_AUTHID AU, SYS_ATTRIBUTE ATTR left outer join SYS_ATTRDEF DEF on (attr.attnum = def.adnum and attr.attrelid = def.adrelid)
WHERE C.RELOWNER = U.USESYSID
AND ATTR.ATTNUM > 0
AND ATTR.ATTTYPID = T.OID
AND ATTR.ATTRELID = C.OID
AND T.TYPOWNER = AU.OID
AND (HAS_TABLE_PRIVILEGE(C.OID,'SELECT') = TRUE
OR has_table_privilege(c.oid, 'INSERT') = TRUE
OR has_table_privilege(c.oid, 'UPDATE') = TRUE
OR has_table_privilege(c.oid, 'DELETE') = TRUE
OR has_table_privilege(c.oid, 'REFERENCES') = TRUE
OR has_table_privilege(c.oid, 'TRIGGER'));

-- bug#15842: Compatible with ORACLE, add USER_TAB_COLS view
CREATE OR REPLACE  VIEW USER_TAB_COLS AS
SELECT 
C.RELNAME ::CHARACTER VARYING(30 BYTE) AS TABLE_NAME,
ATTR.ATTNAME ::CHARACTER VARYING(30 BYTE) AS COLUMN_NAME,
(
  CASE T.TYPNAME
    WHEN 'BPCHAR' THEN 'CHAR'
  ELSE
    T.TYPNAME
  END
)::CHARACTER VARYING(106 BYTE) AS DATA_TYPE,
NULL ::CHARACTER VARYING(3 CHAR) AS DATA_TYPE_MOD,
AU.ROLNAME ::CHARACTER VARYING(30 BYTE) AS DATA_TYPE_OWNER,
(
	CASE WHEN ATTR.ATTLEN = -1 THEN
	(
		CASE T.TYPNAME WHEN 'BIT' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'BIT VARYING' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIMETZ' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIME' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIMESTAMPTZ' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'TIMESTAMP' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'INTERVAL' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			WHEN 'VARBIT' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
  			--bug#15842: system views compatible with oracle.
			--we ignore char or byte option, as can't get the relation of them.
			--We also ignore atttypmod = -1 for special situations, such as sys_class.relkeyid, and sys_attribute.attkeyid, 
			--they are not bpchar, but appear to be.
			WHEN 'VARCHAR' THEN (CASE ATTR.ATTTYPMOD WHEN -1 THEN NULL ELSE ABS(ATTR.ATTTYPMOD) - 4 END)
			WHEN 'BPCHAR' THEN (CASE ATTR.ATTTYPMOD WHEN -1 THEN NULL ELSE ABS(ATTR.ATTTYPMOD) - 4 END)
			ELSE (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)-4) ELSE 0 END)
		END
	)
  	ELSE
		ATTR.ATTLEN
  	END
  )::number AS DATA_LENGTH,
(
	CASE DATA_TYPE 
		WHEN 'NUMERIC' THEN 
    (
      CASE WHEN ATTR.ATTTYPMOD = -1 THEN 38
      ELSE ((ATTR.ATTTYPMOD - 4) >> 16) & 0xFFFF
      END
    )
		WHEN 'FLOAT4' THEN 7 --float
		WHEN 'FLOAT8' THEN 15 --double. hard coded in kingbase.
	ELSE 
		NULL
	END
)::number AS DATA_PRECISION,
(
	CASE DATA_TYPE 
		WHEN 'NUMERIC' THEN (ATTR.ATTTYPMOD - 4) & 0xFFFF
	ELSE 
		NULL
	END
)::number AS DATA_SCALE,
(
	if (ATTR.ATTNOTNULL, 'N', 'Y')
) ::CHARACTER VARYING(1 CHAR) AS NULLABLE,
ATTR.ATTNUM ::number AS COLUMN_ID,
(	
	CASE ATTR.ATTHASDEF WHEN FALSE THEN NULL
	ELSE DATA_LENGTH
	END
) ::number AS DEFAULT_LENGTH,
DEF.ADSRC::TEXT AS DATA_DEFAULT,
0 ::number AS NUM_DISTINCT,
0 ::number AS LOW_VALUE,
0 ::number AS HIGH_VALUE,
0 ::number AS DENSITY,
0 ::number AS NUM_NULLS,
0 ::number AS NUM_BUCKETS,
NULL::TIMESTAMP(0) WITHOUT TIME ZONE AS LAST_ANALYZED,
0 ::number AS SAMPLE_SIZE,
NULL ::CHARACTER VARYING(44 CHAR) AS CHARACTER_SET_NAME,
0 ::number AS CHAR_COL_DECL_LENGTH,
'NO' ::CHARACTER VARYING(3 CHAR) AS GLOBAL_STATS,
'NO' ::CHARACTER VARYING(3 CHAR) AS USER_STATS,
0 ::number AS AVG_COL_LEN,
(
	CASE DATA_TYPE IN('VARCHAR', 'BPCHAR', 'NCHAR', 'NVARCHAR') WHEN TRUE THEN DATA_LENGTH
	ELSE 0
	END
) :: number AS CHAR_LENGTH,
(
	CASE DATA_TYPE IN ('VARCHAR', 'BPCHAR', 'NCHAR', 'NVARCHAR') AND ATTR.ATTTYPMOD <> -1 WHEN TRUE THEN 
	(
		CASE ATTR.ATTTYPMOD >> 16 WHEN 0 THEN 'C'
		ELSE 'B'
		END
	)
	ELSE 
		NULL
	END
) ::CHARACTER VARYING(1 CHAR) AS CHAR_USED,
'NO' ::CHARACTER VARYING(3 CHAR) AS V80_FMT_IMAGE,
'NO' ::CHARACTER VARYING(3 CHAR) AS DATA_UPGRADED,
'NO' ::CHARACTER VARYING(3 CHAR) AS HIDDEN_COLUMN,
'NO' ::CHARACTER VARYING(3 CHAR) AS VIRTUAL_COLUMN,
0 ::number AS SEGMENT_COLUMN_ID,
ATTR.ATTNUM ::number AS INTERNAL_COLUMN_ID,
NULL ::CHARACTER VARYING(15 CHAR) AS HISTOGRAM,
NULL ::CHARACTER VARYING(4000 CHAR) AS QUALIFIED_COL_NAME
FROM SYS_CLASS C,SYS_ATTRIBUTE ATTR,SYS_TYPE T,SYS_AUTHID AU, SYS_ATTRDEF DEF
WHERE C.RELOWNER = UID
AND ATTR.ATTNUM > 0
AND ATTR.ATTTYPID = T.OID
AND ATTR.ATTRELID = C.OID
AND T.TYPOWNER = AU.OID
AND ATTR.ATTNUM = DEF.ADNUM(+)
AND ATTR.ATTRELID = DEF.ADRELID(+);

-- with the table oid, colnum, get the uniques constraint text of the column
CREATE OR REPLACE FUNCTION get_col_uniques(taboid OID, colnum INT)
RETURNS TEXT
AS
DECLARE
	uniques_text TEXT;
	unique_record RECORD;
	col_number INT;
BEGIN
	uniques_text := NULL;
	col_number := 0;
	FOR unique_record IN SELECT CONNAME, CONKEY FROM SYS_CONSTRAINT CONSTR
		WHERE taboid = CONSTR.CONRELID AND CONSTR.CONTYPE = 'u' AND colnum = any(CONSTR.CONKEY)
	LOOP
		IF uniques_text IS NOT NULL THEN
			uniques_text := CONCAT(uniques_text, ', ');
		ELSE
			uniques_text := '';
		END IF;
		uniques_text := CONCAT(uniques_text, unique_record.CONNAME);
		uniques_text := CONCAT(uniques_text, '(');
		FOR col_number in 1..array_length(unique_record.CONKEY, 1)
		LOOP
			IF col_number > 1 THEN
				uniques_text := CONCAT(uniques_text, ', ');
			END IF;
			uniques_text := CONCAT(uniques_text, unique_record.CONKEY[col_number]);
		END LOOP;
		uniques_text := CONCAT(uniques_text, ')');
	END LOOP;
	RETURN uniques_text;
END;

-- with the table oid, colnum, get the primary key constraint text of the column
CREATE OR REPLACE FUNCTION get_col_primary(taboid OID, colnum INT)
RETURNS TEXT
AS
DECLARE
	primary_text TEXT;
	con_key SMALLINT[];
	con_key_id INT;
BEGIN
	primary_text := NULL;
	SELECT CONNAME, CONKEY INTO primary_text, con_key FROM SYS_CONSTRAINT CONSTR
	WHERE taboid = CONSTR.CONRELID AND CONSTR.CONTYPE = 'p' AND colnum = any(CONSTR.CONKEY);
	IF primary_text IS NOT NULL THEN
		primary_text := CONCAT(primary_text, '(');
		FOR con_key_id in 1..array_length(con_key, 1)
		LOOP
			IF con_key_id > 1 THEN
				primary_text := CONCAT(primary_text, ', ');
			END IF;
			primary_text := CONCAT(primary_text, con_key[con_key_id]);
		END LOOP;
		primary_text := CONCAT(primary_text, ')');
	END IF;
	RETURN primary_text;
END;

-- with the table oid ,colnum, get the checks constraint text of the column
CREATE OR REPLACE FUNCTION get_col_checks(taboid OID, colnum INT)
RETURNS TEXT
AS
DECLARE
	checks_text TEXT;
	check_record RECORD;
BEGIN
	checks_text := NULL;
	FOR check_record IN SELECT CONSRC FROM SYS_CONSTRAINT CONSTR
		WHERE taboid = CONSTR.CONRELID AND CONSTR.CONTYPE = 'c' AND colnum = any(CONSTR.CONKEY)
	LOOP
		IF checks_text IS NOT NULL THEN
			checks_text := CONCAT(checks_text, ', ');
		ELSE
			checks_text := '';
		END IF;
		checks_text := CONCAT(checks_text, check_record.CONSRC);
	END LOOP;
	RETURN checks_text;
END;

-- with the table oid ,colnum ,get the foreigns constraint text of the column
CREATE OR REPLACE FUNCTION get_col_foreigns(taboid OID, colnum INT)
RETURNS TEXT
AS
DECLARE
	foreigns_text TEXT;
	foreign_record record;
	temp_table_oid OID;
BEGIN
	foreigns_text := NULL;
	temp_table_oid := NULL;
	FOR foreign_record IN SELECT CONSTR.CONFRELID tableoid, CLASS.RELNAME tablename, ATTR.ATTNAME colname
		FROM SYS_CONSTRAINT CONSTR, SYS_CLASS CLASS, SYS_ATTRIBUTE ATTR
		WHERE taboid = CONSTR.CONRELID AND CONSTR.CONFRELID = CLASS.OID AND colnum = any(CONSTR.CONKEY) AND CONSTR.CONTYPE = 'f'
		AND ATTR.ATTRELID = CONSTR.CONFRELID AND ATTR.ATTNUM = any(CONSTR.confkey) ORDER BY tableoid
	LOOP -- get tables and foreign constraints information
		IF temp_table_oid = foreign_record.tableoid THEN
			foreigns_text := CONCAT(foreigns_text, ',');
			foreigns_text := CONCAT(foreigns_text, foreign_record.colname);
		ELSE
			IF foreigns_text IS NOT NULL THEN
				foreigns_text := CONCAT(foreigns_text, ')');
				foreigns_text := CONCAT(foreigns_text, ', ');
			ELSE
				foreigns_text := '';
			END IF;
			foreigns_text := CONCAT(foreigns_text, foreign_record.tablename);
			foreigns_text := CONCAT(foreigns_text, '(');
			foreigns_text := CONCAT(foreigns_text, foreign_record.colname);
			temp_table_oid := foreign_record.tableoid;
		END IF;
	END LOOP;
	IF foreigns_text IS NOT NULL THEN
		foreigns_text := CONCAT(foreigns_text, ')');
	END IF;
	RETURN foreigns_text;
END;

-- with the table oid ,colnum, get the indexs text of the column
CREATE OR REPLACE FUNCTION get_col_indexs(taboid OID, colnum INT)
RETURNS TEXT
AS
DECLARE
	indexs_text TEXT;
	index_record record;
	temp_index_oid OID;
BEGIN
	indexs_text := NULL;
	temp_index_oid := NULL;
	FOR index_record IN SELECT CLASS.RELNAME indexname, ATTR.ATTNAME colname, INDEX.INDEXRELID indexoid
		FROM SYS_INDEX INDEX, SYS_CLASS CLASS, SYS_ATTRIBUTE ATTR
		WHERE taboid = INDEX.INDRELID AND colnum = any(INDEX.INDKEY) AND INDEX.INDEXRELID = CLASS.OID
		AND ATTR.ATTRELID = INDEX.INDRELID AND ATTR.ATTNUM = any(INDEX.INDKEY) ORDER BY indexoid
	LOOP						-- get indexs and column information
		IF temp_index_oid = index_record.indexoid THEN
			indexs_text := CONCAT(indexs_text, ', ');
			indexs_text := CONCAT(indexs_text, index_record.colname);
		ELSE
			IF  indexs_text IS NOT NULL THEN
				indexs_text := CONCAT(indexs_text, ')');
				indexs_text := CONCAT(indexs_text, ', ');
			ELSE
				indexs_text := '';
			END IF;
			indexs_text := CONCAT(indexs_text, index_record.indexname);
			indexs_text := CONCAT(indexs_text, '(');
			indexs_text := CONCAT(indexs_text, index_record.colname);
			temp_index_oid := index_record.indexoid;
		END IF;
	END LOOP;
	IF indexs_text IS NOT NULL  THEN
		indexs_text := CONCAT(indexs_text, ')');
	END IF;
	RETURN indexs_text;
END;

-- bug#23252 Add view user_table_cols similar to user_tab_columns view, can querry to all the information about column
CREATE OR REPLACE  VIEW USER_TABLE_COLS AS
SELECT
(
    SELECT NSPNAME FROM SYS_NAMESPACE
    WHERE SYS_NAMESPACE.OID = C.RELNAMESPACE
) ::CHARACTER VARYING(30 BYTE) AS NSPNAME,
C.RELNAME ::CHARACTER VARYING(30 BYTE) AS TABLE_NAME,
ATTR.ATTNAME ::CHARACTER VARYING(30 BYTE) AS COLUMN_NAME,
(
  CASE T.TYPNAME
    WHEN 'BPCHAR' THEN 'CHAR'
  ELSE
    T.TYPNAME
  END
)::CHARACTER VARYING(106 BYTE) AS DATA_TYPE,
NULL ::CHARACTER VARYING(3 CHAR) AS DATA_TYPE_MOD,
AU.ROLNAME ::CHARACTER VARYING(30 BYTE) AS DATA_TYPE_OWNER,
(
    CASE WHEN ATTR.ATTLEN = -1 THEN
    (
        CASE T.TYPNAME WHEN 'BIT' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
            WHEN 'BIT VARYING' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
            WHEN 'TIMETZ' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
            WHEN 'TIME' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
            WHEN 'TIMESTAMPTZ' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
            WHEN 'TIMESTAMP' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
            WHEN 'INTERVAL' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
            WHEN 'VARBIT' THEN (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)) ELSE 0 END)
            --bug#15842: system views compatible with oracle.
            --we ignore char or byte option, as can't get the relation of them.
            --We also ignore atttypmod = -1 for special situations, such as sys_class.relkeyid, and sys_attribute.attkeyid,
            --they are not bpchar, but appear to be.
            WHEN 'VARCHAR' THEN (CASE ATTR.ATTTYPMOD WHEN -1 THEN NULL ELSE ABS(ATTR.ATTTYPMOD) - 4 END)
            WHEN 'BPCHAR' THEN (CASE ATTR.ATTTYPMOD WHEN -1 THEN NULL ELSE ABS(ATTR.ATTTYPMOD) - 4 END)
            ELSE (CASE(ATTR.ATTTYPMOD >> 16) WHEN 0 THEN (ATTR.ATTTYPMOD - ((ATTR.ATTTYPMOD >> 16) <<16)-4) ELSE 0 END)
        END
    )
    ELSE
        ATTR.ATTLEN
END
  )::number AS DATA_LENGTH,
(
    CASE DATA_TYPE
        WHEN 'NUMERIC' THEN
    (
      CASE WHEN ATTR.ATTTYPMOD = -1 THEN 38
      ELSE ((ATTR.ATTTYPMOD - 4) >> 16) & 0xFFFF
      END
    )
        WHEN 'FLOAT4' THEN 7 --float
        WHEN 'FLOAT8' THEN 15 --double. hard coded in kingbase.
    ELSE
        NULL
    END
)::number AS DATA_PRECISION,
(
    CASE DATA_TYPE
        WHEN 'NUMERIC' THEN (ATTR.ATTTYPMOD - 4) & 0xFFFF
    ELSE
        NULL
    END
)::number AS DATA_SCALE,
(
    if (ATTR.ATTNOTNULL, 'N', 'Y')
) ::CHARACTER VARYING(1 CHAR) AS NULLABLE,
ATTR.ATTNUM ::number AS COLUMN_ID,
(
    CASE ATTR.ATTHASDEF WHEN FALSE THEN NULL
    ELSE DATA_LENGTH
    END
) ::number AS DEFAULT_LENGTH,
DEF.ADSRC::TEXT AS DATA_DEFAULT,
0 ::number AS NUM_DISTINCT,
0 ::number AS LOW_VALUE,
0 ::number AS HIGH_VALUE,
0 ::number AS DENSITY,
0 ::number AS NUM_NULLS,
0 ::number AS NUM_BUCKETS,
NULL::TIMESTAMP(0) WITHOUT TIME ZONE AS LAST_ANALYZED,
0 ::number AS SAMPLE_SIZE,
NULL ::CHARACTER VARYING(44 CHAR) AS CHARACTER_SET_NAME,
0 ::number AS CHAR_COL_DECL_LENGTH,
'NO' ::CHARACTER VARYING(3 CHAR) AS GLOBAL_STATS,
'NO' ::CHARACTER VARYING(3 CHAR) AS USER_STATS,
0 ::number AS AVG_COL_LEN,
(
    CASE DATA_TYPE IN('VARCHAR', 'BPCHAR', 'NCHAR', 'NVARCHAR') WHEN TRUE THEN DATA_LENGTH
    ELSE 0
    END
) :: number AS CHAR_LENGTH,
(
    CASE DATA_TYPE IN ('VARCHAR', 'BPCHAR', 'NCHAR', 'NVARCHAR') AND ATTR.ATTTYPMOD <> -1 WHEN TRUE THEN
    (
        CASE ATTR.ATTTYPMOD >> 16 WHEN 0 THEN 'C'
        ELSE 'B'
        END
    )
    ELSE
        NULL
    END
) ::CHARACTER VARYING(1 CHAR) AS CHAR_USED,
'NO' ::CHARACTER VARYING(3 CHAR) AS V80_FMT_IMAGE,
'NO' ::CHARACTER VARYING(3 CHAR) AS DATA_UPGRADED,
'NO' ::CHARACTER VARYING(3 CHAR) AS HIDDEN_COLUMN,
'NO' ::CHARACTER VARYING(3 CHAR) AS VIRTUAL_COLUMN,
0 ::number AS SEGMENT_COLUMN_ID,
ATTR.ATTNUM ::number AS INTERNAL_COLUMN_ID,
NULL ::CHARACTER VARYING(15 CHAR) AS HISTOGRAM,
NULL ::CHARACTER VARYING(4000 CHAR) AS QUALIFIED_COL_NAME,
ATTR.ATTISENCRYPTED ::BOOLEAN AS  ISENCRYPTED,
ATTR.ATTCOMPMETHOD ::CHARACTER VARYING(1 CHAR) AS COMPMETHOD,
ATTR.ATTSTORAGE ::CHARACTER VARYING(1 CHAR) AS STORAGE,
(
    SELECT RELNAME FROM SYS_CLASS IDENTITY WHERE IDENTITY.OID = ATTR.ATTSEQOID
) ::CHARACTER VARYING(30 BYTE)   AS IDENTITY_NAME,
get_col_checks(ATTR.ATTRELID, ATTR.ATTNUM)::TEXT AS CHECKS,
get_col_foreigns(ATTR.ATTRELID, ATTR.ATTNUM)::TEXT AS FOREIGNS,
get_col_primary(ATTR.ATTRELID, ATTR.ATTNUM) ::TEXT AS PRIMARY_KEY,
get_col_uniques(ATTR.ATTRELID, ATTR.ATTNUM)::TEXT AS UNIQUES,
(
	array_cat(ATTR.ATTACL,C.RELACL)
)::ACLITEM[] AS GRANTS,
get_col_indexs(C.OID, ATTR.ATTNUM)::TEXT AS INDEXS,
(
    SELECT
	(
		CASE PARTTABLES.PARTITIONKEY
		WHEN NULL THEN NULL
		ELSE
		(
			CASE STRPOS(PARTTABLES.PARTITIONKEY, ATTR.ATTNAME)
			WHEN 0 THEN NULL
			ELSE PARTTABLES.PARTITIONTYPE END
		) END
	)
	FROM SYS_PARTTABLES PARTTABLES, SYS_NAMESPACE NAMESPACE
	WHERE C.RELNAME = PARTTABLES.TABLENAME AND NAMESPACE.OID = C.RELNAMESPACE AND NAMESPACE.NSPNAME = PARTTABLES.SCHEMANAME
) ::CHARACTER VARYING(30 BYTE) AS PARTITIONTYPE,
(
	SELECT
	(
		CASE PARTTABLES.PARTITIONKEY
		WHEN NULL THEN NULL
		ELSE
		(
			CASE STRPOS(PARTTABLES.PARTITIONKEY, ATTR.ATTNAME)
			WHEN 0 THEN NULL
			ELSE PARTTABLES.PARTITIONKEY END
		) END
	)
	FROM SYS_PARTTABLES PARTTABLES, SYS_NAMESPACE NAMESPACE
	WHERE C.RELNAME = PARTTABLES.TABLENAME AND NAMESPACE.OID = C.RELNAMESPACE AND NAMESPACE.NSPNAME = PARTTABLES.SCHEMANAME
) ::TEXT AS PARTITIONKEY
FROM SYS_CLASS C,SYS_ATTRIBUTE ATTR, SYS_TYPE T, SYS_AUTHID AU, SYS_ATTRDEF DEF
WHERE C.RELOWNER = UID
AND ATTR.ATTNUM > 0
AND ATTR.ATTTYPID = T.OID
AND ATTR.ATTRELID = C.OID
AND T.TYPOWNER = AU.OID
AND ATTR.ATTNUM = DEF.ADNUM(+)
AND ATTR.ATTRELID = DEF.ADRELID(+);

REVOKE ALL ON USER_TABLE_COLS from PUBLIC;
GRANT select on USER_TABLE_COLS to PUBLIC;

/* null means user has no privilege,then will check "* ANY TABLE" privilege exists or not.
 * true means user has the privilege.
 * false means user has no privilege.
 */
create or replace function sys_has_any_table_priv(id oid := uid, priv text := null) returns boolean as
declare
	rolspr char(10);
begin
	select usesuper into rolspr from sys_user where usesysid = id;
	
	if rolspr in ('true', 'D', 't') then --"D" means DBA,equals ture.t is short for true.
		return true;
	end if;
	
	if upper(priv) not in('SELECT ANY TABLE', 'INSERT ANY TABLE', 'UPDATE ANY TABLE', 'DELETE ANY TABLE', 'LOCK ANY TABLE') then
		raise 'invalid PRIV value : %, must be one of ''SELECT ANY TABLE'', ''INSERT ANY TABLE'', ''UPDATE ANY TABLE'', ''DELETE ANY TABLE'', ''LOCK ANY TABLE''', priv;
	end if;
	
	if priv is null or length(priv) = 0 then
		if exists(
			select null from sys_sysauth where GRANTEE = id and privilege in (select PRIVILEGE from sys_sysauth_map where upper(name) in ('SELECT ANY TABLE', 'INSERT ANY TABLE', 'UPDATE ANY TABLE', 'DELETE ANY TABLE', 'LOCK ANY TABLE'))) then
			return true;
		end if;
	else
		if exists(	
			select null from sys_sysauth where GRANTEE = id and privilege in (select PRIVILEGE from sys_sysauth_map where upper(name) = upper(priv) )) then
			return true;
		end if;
	end if;
		
	return false;
end;

-- bug#18020: Compatible with ORACLE, add USER_INDEXES view
CREATE OR REPLACE  VIEW USER_INDEXES AS 
SELECT C.RELNAME ::CHARACTER VARYING(30 BYTE) AS INDEX_NAME, 
A.AMNAME ::CHARACTER VARYING(30 BYTE) AS INDEX_TYPE, 
SYS_GET_USERBYID(D.RELOWNER) ::CHARACTER VARYING(30 BYTE) AS TABLE_OWNER, 
(SELECT RELNAME FROM SYS_CLASS WHERE  OID = INDRELID )::CHARACTER VARYING(30 BYTE) AS TABLE_NAME,
'TABLE'::TEXT AS TABLE_TYPE,
if(I.INDISUNIQUE or I.INDISPRIMARY,'UNIQUE','NONUNIQUE')::CHARACTER VARYING(9 CHAR) AS UNIQUENESS,
'DISABLED'::CHARACTER VARYING(8 CHAR)  AS COMPRESSION,
0 ::number AS PREFIX_LENGTH, 
(SELECT SPCNAME FROM SYS_TABLESPACE WHERE OID = C.RELTABLESPACE)::CHARACTER VARYING(30 BYTE) AS TABLESPACE_NAME,
NULL::CHARACTER VARYING(7 CHAR) AS INI_TRANS,
NULL::CHARACTER VARYING(7 CHAR) AS MAX_TRANS,
NULL::CHARACTER VARYING(7 CHAR) AS INITIAL_EXTENT, 
NULL::CHARACTER VARYING(7 CHAR) AS NEXT_EXTENT,
NULL::CHARACTER VARYING(7 CHAR) AS MIN_EXTENTS,
NULL::CHARACTER VARYING(7 CHAR) AS MAX_EXTENTS,
NULL::CHARACTER VARYING(7 CHAR) AS PCT_INCREASE,
NULL::CHARACTER VARYING(7 CHAR) AS PCT_THRESHOLD,
NULL::CHARACTER VARYING(7 CHAR) AS INCLUDE_COLUMN, 
NULL::CHARACTER VARYING(7 CHAR) AS FREELISTS, 
NULL::CHARACTER VARYING(7 CHAR) AS FREELIST_GROUPS,
NULL::CHARACTER VARYING(7 CHAR) AS PCT_FREE, 
NULL::CHARACTER VARYING(7 CHAR) AS LOGGING,
NULL::CHARACTER VARYING(7 CHAR) AS BLEVEL, 
NULL::CHARACTER VARYING(7 CHAR) AS LEAF_BLOCKS,
NULL::CHARACTER VARYING(7 CHAR) AS DISTINCT_KEYS,
NULL::CHARACTER VARYING(7 CHAR) AS AVG_LEAF_BLOCKS_PER_KEY,
NULL::CHARACTER VARYING(7 CHAR) AS AVG_DATA_BLOCKS_PER_KEY,
NULL::CHARACTER VARYING(7 CHAR) AS CLUSTERING_FACTOR, 
NULL::CHARACTER VARYING(8 CHAR) AS STATUS,
NULL::CHARACTER VARYING(7 CHAR) AS NUM_ROWS,
NULL::CHARACTER VARYING(7 CHAR) AS SAMPLE_SIZE,
NULL::CHARACTER VARYING(20 CHAR) AS LAST_ANALYZED, 
NULL::CHARACTER VARYING(40 CHAR) AS DEGREE, 
NULL::CHARACTER VARYING(40 CHAR)AS INSTANCES,
NULL::CHARACTER VARYING(3 CHAR) AS PARTITIONED,
NULL::CHARACTER VARYING(1 CHAR) AS "TEMPORARY", 
NULL::CHARACTER VARYING(1 CHAR) AS GENERATED,
NULL::CHARACTER VARYING(1 CHAR) AS SECONDARY,
NULL::CHARACTER VARYING(7 CHAR) AS BUFFER_POOL,
NULL::CHARACTER VARYING(3 CHAR) AS USER_STATS,
NULL::CHARACTER VARYING(15 CHAR) AS "DURATION", 
NULL::CHARACTER VARYING(7 CHAR) AS PCT_DIRECT_ACCESS, 
NULL::CHARACTER VARYING(30 byte) AS ITYP_OWNER,
NULL::CHARACTER VARYING(30 byte) AS ITYP_NAME,
NULL::CHARACTER VARYING(1000 CHAR) AS PARAMETERS, 
NULL::CHARACTER VARYING(3 CHAR) AS GLOBAL_STATS, 
NULL::CHARACTER VARYING(12 CHAR) AS DOMIDX_STATUS, 
NULL::CHARACTER VARYING(6 CHAR) AS DOMIDX_OPSTATUS, 
NULL::CHARACTER VARYING(8 CHAR) AS FUNCIDX_STATUS, 
'NO'::TEXT AS JOIN_INDEX, 
'NO'::TEXT AS IOT_REDUNDANT_PKEY_ELIM, 
'NO'::TEXT AS DROPPED 
FROM  SYS_INDEX I, SYS_CLASS C,SYS_CLASS D,SYS_AM A 
WHERE 
C.RELOWNER = UID
AND I.INDRELID = D.OID
AND I.INDEXRELID = C.OID
AND A.OID = C.RELAM;
comment on view USER_INDEXES is 'Description of the user''s own indexes';
comment on column USER_INDEXES.INDEX_NAME is 'Name of the index';
comment on column USER_INDEXES.TABLE_OWNER is'Owner of the indexed object';
comment on column USER_INDEXES.TABLE_NAME is 'Name of the indexed object';
comment on column USER_INDEXES.TABLE_TYPE is 'Type of the indexed object';
comment on column USER_INDEXES.UNIQUENESS is 'Uniqueness status of the index:  "UNIQUE",  "NONUNIQUE", or "BITMAP"';
comment on column USER_INDEXES.COMPRESSION is 'Compression property of the index: "ENABLED",  "DISABLED", or NULL';
comment on column USER_INDEXES.PREFIX_LENGTH is 'Number of key columns in the prefix used for compression';
comment on column USER_INDEXES.TABLESPACE_NAME is 'Name of the tablespace containing the index';
comment on column USER_INDEXES.INI_TRANS is 'Initial number of transactions';
comment on column USER_INDEXES.MAX_TRANS is 'Maximum number of transactions';
comment on column USER_INDEXES.INITIAL_EXTENT is 'Size of the initial extent in bytes';
comment on column USER_INDEXES.NEXT_EXTENT is 'Size of secondary extents in bytes';
comment on column USER_INDEXES.MIN_EXTENTS is 'Minimum number of extents allowed in the segment';
comment on column USER_INDEXES.MAX_EXTENTS is 'Maximum number of extents allowed in the segment';
comment on column USER_INDEXES.PCT_INCREASE is 'Percentage increase in extent size';
comment on column USER_INDEXES.PCT_THRESHOLD is 'Threshold percentage of block space allowed per index entry';
comment on column USER_INDEXES.INCLUDE_COLUMN is 'User column-id for last column to be included in index-only table top index';
comment on column USER_INDEXES.FREELISTS is 'Number of process freelists allocated in this segment';
comment on column USER_INDEXES.FREELIST_GROUPS is 'Number of freelist groups allocated to this segment';
comment on column USER_INDEXES.PCT_FREE is 'Minimum percentage of free space in a block';
comment on column USER_INDEXES.LOGGING is 'Logging attribute';
comment on column USER_INDEXES.BLEVEL is 'B-Tree level';
comment on column USER_INDEXES.LEAF_BLOCKS is 'The number of leaf blocks in the index';
comment on column USER_INDEXES.DISTINCT_KEYS is 'The number of distinct keys in the index';
comment on column USER_INDEXES.AVG_LEAF_BLOCKS_PER_KEY is 'The average number of leaf blocks per key';
comment on column USER_INDEXES.AVG_DATA_BLOCKS_PER_KEY is 'The average number of data blocks per key';
comment on column USER_INDEXES.CLUSTERING_FACTOR is 'A measurement of the amount of (dis)order of the table this index is for';
comment on column USER_INDEXES.NUM_ROWS is 'Number of rows in the index';
comment on column USER_INDEXES.SAMPLE_SIZE is 'The sample size used in analyzing this index';
comment on column USER_INDEXES.LAST_ANALYZED is 'The date of the most recent time this index was analyzed';
comment on column USER_INDEXES.DEGREE is 'The number of threads per instance for scanning the partitioned index';
comment on column USER_INDEXES.INSTANCES is 'The number of instances across which the partitioned index is to be scanned';
comment on column USER_INDEXES.PARTITIONED is 'Is this index partitioned? YES or NO';
comment on column USER_INDEXES.TEMPORARY is 'Can the current session only see data that it place in this object itself?';
comment on column USER_INDEXES.GENERATED is 'Was the name of this index system generated?';
comment on column USER_INDEXES.SECONDARY is 'Is the index object created as part of icreate for domain indexes?';
comment on column USER_INDEXES.BUFFER_POOL is 'The default buffer pool to be used for index blocks';
comment on column USER_INDEXES.USER_STATS is 'Were the statistics entered directly by the user?';
comment on column USER_INDEXES.DURATION is 'If index on temporary table, then duration is sys$session or sys$transaction else NULL';
comment on column USER_INDEXES.PCT_DIRECT_ACCESS is 'If index on IOT, then this is percentage of rows with Valid guess';
comment on column USER_INDEXES.ITYP_OWNER is 'If domain index, then this is the indextype owner';
comment on column USER_INDEXES.ITYP_NAME is 'If domain index, then this is the name of the associated indextype';
comment on column USER_INDEXES.PARAMETERS is 'If domain index, then this is the parameter string';
comment on column USER_INDEXES.GLOBAL_STATS is 'Are the statistics calculated without merging underlying partitions?';
comment on column USER_INDEXES.DOMIDX_STATUS is 'Is the indextype of the domain index valid';
comment on column USER_INDEXES.DOMIDX_OPSTATUS is 'Status of the operation on the domain index';
comment on column USER_INDEXES.FUNCIDX_STATUS is 'Is the Function-based Index DISABLED or ENABLED?';
comment on column USER_INDEXES.JOIN_INDEX is 'Is this index a join index?';
comment on column USER_INDEXES.IOT_REDUNDANT_PKEY_ELIM is 'Were redundant primary key columns eliminated from iot secondary index?';
comment on column USER_INDEXES.DROPPED is 'Whether index is dropped and is in Recycle Bin';

-- bug#13918: Compatible with ORACLE, add ALL_INDEXES view
CREATE OR REPLACE  VIEW ALL_INDEXES AS 
SELECT U.USENAME ::CHARACTER VARYING(30 BYTE)  AS "OWNER",
C.RELNAME ::CHARACTER VARYING(30 BYTE) AS INDEX_NAME, 
A.AMNAME ::CHARACTER VARYING(27 BYTE) AS INDEX_TYPE, 
U.USENAME ::CHARACTER VARYING(30 BYTE) AS TABLE_OWNER, 
(SELECT RELNAME FROM SYS_CLASS WHERE  OID = INDRELID )::CHARACTER VARYING(30 BYTE) AS TABLE_NAME,
'TABLE'::TEXT AS TABLE_TYPE,
if(I.INDISUNIQUE or I.INDISPRIMARY,'UNIQUE','NONUNIQUE')::CHARACTER VARYING(9 CHAR) AS UNIQUENESS,
'DISABLED'::CHARACTER VARYING(8 CHAR)  AS COMPRESSION,
0 ::number AS PREFIX_LENGTH, 
(SELECT SPCNAME FROM SYS_TABLESPACE WHERE OID = C.RELTABLESPACE)::CHARACTER VARYING(30 BYTE) AS TABLESPACE_NAME,
NULL::CHARACTER VARYING(7 CHAR) AS INI_TRANS,
NULL::CHARACTER VARYING(7 CHAR) AS MAX_TRANS,
NULL::CHARACTER VARYING(7 CHAR) AS INITIAL_EXTENT, 
NULL::CHARACTER VARYING(7 CHAR) AS NEXT_EXTENT,
NULL::CHARACTER VARYING(7 CHAR) AS MIN_EXTENTS,
NULL::CHARACTER VARYING(7 CHAR) AS MAX_EXTENTS,
NULL::CHARACTER VARYING(7 CHAR) AS PCT_INCREASE,
NULL::CHARACTER VARYING(7 CHAR) AS PCT_THRESHOLD,
NULL::CHARACTER VARYING(7 CHAR) AS INCLUDE_COLUMN, 
NULL::CHARACTER VARYING(7 CHAR) AS FREELISTS, 
NULL::CHARACTER VARYING(7 CHAR) AS FREELIST_GROUPS,
NULL::CHARACTER VARYING(7 CHAR) AS PCT_FREE, 
NULL::CHARACTER VARYING(7 CHAR) AS LOGGING,
NULL::CHARACTER VARYING(7 CHAR) AS BLEVEL, 
NULL::CHARACTER VARYING(7 CHAR) AS LEAF_BLOCKS,
NULL::CHARACTER VARYING(7 CHAR) AS DISTINCT_KEYS,
NULL::CHARACTER VARYING(7 CHAR) AS AVG_LEAF_BLOCKS_PER_KEY,
NULL::CHARACTER VARYING(7 CHAR) AS AVG_DATA_BLOCKS_PER_KEY,
NULL::CHARACTER VARYING(7 CHAR) AS CLUSTERING_FACTOR, 
NULL::CHARACTER VARYING(8 CHAR) AS STATUS,
NULL::CHARACTER VARYING(7 CHAR) AS NUM_ROWS,
NULL::CHARACTER VARYING(7 CHAR) AS SAMPLE_SIZE,
NULL::CHARACTER VARYING(20 CHAR) AS LAST_ANALYZED, 
NULL::CHARACTER VARYING(40 CHAR) AS DEGREE, 
NULL::CHARACTER VARYING(40 CHAR)AS INSTANCES,
NULL::CHARACTER VARYING(3 CHAR) AS PARTITIONED,
NULL::CHARACTER VARYING(1 CHAR) AS "TEMPORARY", 
NULL::CHARACTER VARYING(1 CHAR) AS GENERATED,
NULL::CHARACTER VARYING(1 CHAR) AS SECONDARY,
NULL::CHARACTER VARYING(7 CHAR) AS BUFFER_POOL,
NULL::CHARACTER VARYING(3 CHAR) AS USER_STATS,
NULL::CHARACTER VARYING(15 CHAR) AS "DURATION", 
NULL::CHARACTER VARYING(7 CHAR) AS PCT_DIRECT_ACCESS, 
NULL::CHARACTER VARYING(30 BYTE) AS ITYP_OWNER,
NULL::CHARACTER VARYING(30 BYTE) AS ITYP_NAME,
NULL::CHARACTER VARYING(1000 CHAR) AS PARAMETERS, 
NULL::CHARACTER VARYING(3 CHAR) AS GLOBAL_STATS, 
NULL::CHARACTER VARYING(12 CHAR) AS DOMIDX_STATUS, 
NULL::CHARACTER VARYING(6 CHAR) AS DOMIDX_OPSTATUS, 
NULL::CHARACTER VARYING(8 CHAR) AS FUNCIDX_STATUS, 
'NO'::TEXT AS JOIN_INDEX, 
'NO'::TEXT AS IOT_REDUNDANT_PKEY_ELIM, 
'NO'::TEXT AS DROPPED 
FROM SYS_USER U, SYS_INDEX I, SYS_CLASS C,SYS_CLASS D,
SYS_AM A 
WHERE 
U.USESYSID = C.RELOWNER
AND I.INDRELID = D.OID
AND I.INDEXRELID = C.OID
AND A.OID = C.RELAM
AND 
(
   ( 
     HAS_TABLE_PRIVILEGE(D.OID,'SELECT') = TRUE
	 OR HAS_TABLE_PRIVILEGE(D.OID, 'INSERT') = TRUE
	 OR HAS_TABLE_PRIVILEGE(D.OID, 'UPDATE') = TRUE
	 OR HAS_TABLE_PRIVILEGE(D.OID, 'DELETE') = TRUE
	 OR HAS_TABLE_PRIVILEGE(D.OID, 'REFERENCES') = TRUE
	 OR HAS_TABLE_PRIVILEGE(D.OID, 'TRIGGER')
   )
     OR 
   ( 
     sys_has_any_table_priv()
   )
)
;
comment on view ALL_INDEXES is 'Descriptions of indexes on tables accessible to the user';
comment on column ALL_INDEXES.OWNER is 'Username of the owner of the index';
comment on column ALL_INDEXES.STATUS is 'Whether the non-partitioned index is in USABLE or not';
comment on column ALL_INDEXES.INDEX_NAME is 'Name of the index';
comment on column ALL_INDEXES.TABLE_OWNER is 'Owner of the indexed object';
comment on column ALL_INDEXES.TABLE_NAME is 'Name of the indexed object';
comment on column ALL_INDEXES.TABLE_TYPE is 'Type of the indexed object';
comment on column ALL_INDEXES.UNIQUENESS is 'Uniqueness status of the index: "UNIQUE",  "NONUNIQUE", or "BITMAP"';
comment on column ALL_INDEXES.COMPRESSION is 'Compression property of the index: "ENABLED",  "DISABLED", or NULL';
comment on column ALL_INDEXES.PREFIX_LENGTH is 'Number of key columns in the prefix used for compression';
comment on column ALL_INDEXES.TABLESPACE_NAME is 'Name of the tablespace containing the index';
comment on column ALL_INDEXES.INI_TRANS is 'Initial number of transactions';
comment on column ALL_INDEXES.MAX_TRANS is 'Maximum number of transactions';
comment on column ALL_INDEXES.INITIAL_EXTENT is 'Size of the initial extent';
comment on column ALL_INDEXES.NEXT_EXTENT is 'Size of secondary extents';
comment on column ALL_INDEXES.MIN_EXTENTS is 'Minimum number of extents allowed in the segment';
comment on column ALL_INDEXES.MAX_EXTENTS is 'Maximum number of extents allowed in the segment';
comment on column ALL_INDEXES.PCT_INCREASE is 'Percentage increase in extent size';
comment on column ALL_INDEXES.PCT_THRESHOLD is 'Threshold percentage of block space allowed per index entry';
comment on column ALL_INDEXES.INCLUDE_COLUMN is 'User column-id for last column to be included in index-organized table top index';
comment on column ALL_INDEXES.FREELISTS is 'Number of process freelists allocated in this segment';
comment on column ALL_INDEXES.FREELIST_GROUPS is 'Number of freelist groups allocated to this segment';
comment on column ALL_INDEXES.PCT_FREE is 'Minimum percentage of free space in a block';
comment on column ALL_INDEXES.LOGGING is 'Logging attribute';
comment on column ALL_INDEXES.BLEVEL is 'B-Tree level';		
comment on column ALL_INDEXES.LEAF_BLOCKS is 'The number of leaf blocks in the index';
comment on column ALL_INDEXES.DISTINCT_KEYS is 'The number of distinct keys in the index';
comment on column ALL_INDEXES.AVG_LEAF_BLOCKS_PER_KEY is 'The average number of leaf blocks per key';
comment on column ALL_INDEXES.AVG_DATA_BLOCKS_PER_KEY is 'The average number of data blocks per key';
comment on column ALL_INDEXES.CLUSTERING_FACTOR is 'A measurement of the amount of (dis)order of the table this index is for';
comment on column ALL_INDEXES.SAMPLE_SIZE is 'The sample size used in analyzing this index';
comment on column ALL_INDEXES.LAST_ANALYZED is 'The date of the most recent time this index was analyzed';
comment on column ALL_INDEXES.DEGREE is 'The number of threads per instance for scanning the partitioned index';
comment on column ALL_INDEXES.INSTANCES is 'The number of instances across which the partitioned index is to be scanned';
comment on column ALL_INDEXES.PARTITIONED is 'Is this index partitioned? YES or NO';
comment on column ALL_INDEXES.TEMPORARY is 'Can the current session only see data that it place in this object itself?';
comment on column ALL_INDEXES.GENERATED is 'Was the name of this index system generated?';
comment on column ALL_INDEXES.SECONDARY is 'Is the index object created as part of icreate for domain indexes?';
comment on column ALL_INDEXES.BUFFER_POOL is 'The default buffer pool to be used for index blocks';
comment on column ALL_INDEXES.USER_STATS is 'Were the statistics entered directly by the user?';
comment on column ALL_INDEXES.DURATION is 'If index on temporary table, then duration is sys$session or sys$transaction else NULL';
comment on column ALL_INDEXES.PCT_DIRECT_ACCESS is 'If index on IOT, then this is percentage of rows with Valid guess';
comment on column ALL_INDEXES.ITYP_OWNER is 'If domain index, then this is the indextype owner';
comment on column ALL_INDEXES.ITYP_NAME is 'If domain index, then this is the name of the associated indextype';
comment on column ALL_INDEXES.PARAMETERS is 'If domain index, then this is the parameter string';
comment on column ALL_INDEXES.GLOBAL_STATS is 'Are the statistics calculated without merging underlying partitions?';
comment on column ALL_INDEXES.DOMIDX_STATUS is 'Is the indextype of the domain index valid';
comment on column ALL_INDEXES.DOMIDX_OPSTATUS is 'Status of the operation on the domain index';
comment on column ALL_INDEXES.FUNCIDX_STATUS is 'Is the Function-based Index DISABLED or ENABLED?';
comment on column ALL_INDEXES.JOIN_INDEX is 'Is this index a join index?';
comment on column ALL_INDEXES.IOT_REDUNDANT_PKEY_ELIM is 'Were redundant primary key columns eliminated from iot secondary index?';
comment on column ALL_INDEXES.DROPPED is 'Whether index is dropped and is in Recycle Bin';

-- bug#18020: Compatible with ORACLE, add DBA_INDEXES view
CREATE OR REPLACE  VIEW DBA_INDEXES AS 
SELECT U.USENAME ::CHARACTER VARYING(30 BYTE)  AS "OWNER",
C.RELNAME ::CHARACTER VARYING(30 BYTE) AS INDEX_NAME, 
A.AMNAME ::CHARACTER VARYING(30 BYTE) AS INDEX_TYPE, 
U.USENAME ::CHARACTER VARYING(30 BYTE) AS TABLE_OWNER, 
(SELECT RELNAME FROM SYS_CLASS WHERE  OID = INDRELID )::CHARACTER VARYING(30 BYTE) AS TABLE_NAME,
'TABLE'::TEXT AS TABLE_TYPE,
if(I.INDISUNIQUE or I.INDISPRIMARY,'UNIQUE','NONUNIQUE')::CHARACTER VARYING(9 CHAR) AS UNIQUENESS,
'DISABLED'::CHARACTER VARYING(8 CHAR)  AS COMPRESSION,
0 ::number AS PREFIX_LENGTH, 
(SELECT SPCNAME FROM SYS_TABLESPACE WHERE OID = C.RELTABLESPACE)::CHARACTER VARYING(30 BYTE) AS TABLESPACE_NAME,
NULL::CHARACTER VARYING(7 CHAR) AS INI_TRANS,
NULL::CHARACTER VARYING(7 CHAR) AS MAX_TRANS,
NULL::CHARACTER VARYING(7 CHAR) AS INITIAL_EXTENT, 
NULL::CHARACTER VARYING(7 CHAR) AS NEXT_EXTENT,
NULL::CHARACTER VARYING(7 CHAR) AS MIN_EXTENTS,
NULL::CHARACTER VARYING(7 CHAR) AS MAX_EXTENTS,
NULL::CHARACTER VARYING(7 CHAR) AS PCT_INCREASE,
NULL::CHARACTER VARYING(7 CHAR) AS PCT_THRESHOLD,
NULL::CHARACTER VARYING(7 CHAR) AS INCLUDE_COLUMN, 
NULL::CHARACTER VARYING(7 CHAR) AS FREELISTS, 
NULL::CHARACTER VARYING(7 CHAR) AS FREELIST_GROUPS,
NULL::CHARACTER VARYING(7 CHAR) AS PCT_FREE, 
NULL::CHARACTER VARYING(7 CHAR) AS LOGGING,
NULL::CHARACTER VARYING(7 CHAR) AS BLEVEL, 
NULL::CHARACTER VARYING(7 CHAR) AS LEAF_BLOCKS,
NULL::CHARACTER VARYING(7 CHAR) AS DISTINCT_KEYS,
NULL::CHARACTER VARYING(7 CHAR) AS AVG_LEAF_BLOCKS_PER_KEY,
NULL::CHARACTER VARYING(7 CHAR) AS AVG_DATA_BLOCKS_PER_KEY,
NULL::CHARACTER VARYING(7 CHAR) AS CLUSTERING_FACTOR, 
NULL::CHARACTER VARYING(8 CHAR) AS STATUS,
NULL::CHARACTER VARYING(7 CHAR) AS NUM_ROWS,
NULL::CHARACTER VARYING(7 CHAR) AS SAMPLE_SIZE,
NULL::CHARACTER VARYING(20 CHAR) AS LAST_ANALYZED, 
NULL::CHARACTER VARYING(40 CHAR) AS DEGREE, 
NULL::CHARACTER VARYING(40 CHAR)AS INSTANCES,
NULL::CHARACTER VARYING(3 CHAR) AS PARTITIONED,
NULL::CHARACTER VARYING(1 CHAR) AS "TEMPORARY", 
NULL::CHARACTER VARYING(1 CHAR) AS GENERATED,
NULL::CHARACTER VARYING(1 CHAR) AS SECONDARY,
NULL::CHARACTER VARYING(7 CHAR) AS BUFFER_POOL,
NULL::CHARACTER VARYING(3 CHAR) AS USER_STATS,
NULL::CHARACTER VARYING(15 CHAR) AS "DURATION", 
NULL::CHARACTER VARYING(7 CHAR) AS PCT_DIRECT_ACCESS, 
NULL::CHARACTER VARYING(30 BYTE) AS ITYP_OWNER,
NULL::CHARACTER VARYING(30 BYTE) AS ITYP_NAME,
NULL::CHARACTER VARYING(1000 CHAR) AS PARAMETERS, 
NULL::CHARACTER VARYING(3 CHAR) AS GLOBAL_STATS, 
NULL::CHARACTER VARYING(12 CHAR) AS DOMIDX_STATUS, 
NULL::CHARACTER VARYING(6 CHAR) AS DOMIDX_OPSTATUS, 
NULL::CHARACTER VARYING(8 CHAR) AS FUNCIDX_STATUS, 
'NO'::TEXT AS JOIN_INDEX, 
'NO'::TEXT AS IOT_REDUNDANT_PKEY_ELIM,  
'NO'::TEXT AS DROPPED 
FROM SYS_USER U, SYS_INDEX I, SYS_CLASS C,SYS_CLASS D,
SYS_AM A 
WHERE 
U.USESYSID = C.RELOWNER
AND I.INDRELID = D.OID
AND I.INDEXRELID = C.OID
AND A.OID = C.RELAM;
REVOKE ALL ON DBA_INDEXES FROM PUBLIC;
comment on view DBA_INDEXES is 'Description for all indexes in the database';
comment on column DBA_INDEXES.OWNER is 'Username of the owner of the index';
comment on column DBA_INDEXES.INDEX_NAME is 'Name of the index';
comment on column DBA_INDEXES.TABLE_OWNER is 'Owner of the indexed object';
comment on column DBA_INDEXES.TABLE_NAME is 'Name of the indexed object';
comment on column DBA_INDEXES.TABLE_TYPE is 'Type of the indexed object';
comment on column DBA_INDEXES.UNIQUENESS is 'Uniqueness status of the index: "UNIQUE",  "NONUNIQUE", or "BITMAP"';
comment on column DBA_INDEXES.COMPRESSION is 'Compression property of the index: "ENABLED",  "DISABLED", or NULL';
comment on column DBA_INDEXES.PREFIX_LENGTH is 'Number of key columns in the prefix used for compression';
comment on column DBA_INDEXES.TABLESPACE_NAME is 'Name of the tablespace containing the index';
comment on column DBA_INDEXES.INI_TRANS is 'Initial number of transactions';
comment on column DBA_INDEXES.MAX_TRANS is 'Maximum number of transactions';
comment on column DBA_INDEXES.INITIAL_EXTENT is 'Size of the initial extent';
comment on column DBA_INDEXES.NEXT_EXTENT is 'Size of secondary extents';
comment on column DBA_INDEXES.MIN_EXTENTS is 'Minimum number of extents allowed in the segment';
comment on column DBA_INDEXES.MAX_EXTENTS is 'Maximum number of extents allowed in the segment';
comment on column DBA_INDEXES.PCT_INCREASE is 'Percentage increase in extent size';
comment on column DBA_INDEXES.PCT_THRESHOLD is 'Threshold percentage of block space allowed per index entry';
comment on column DBA_INDEXES.INCLUDE_COLUMN is 'User column-id for last column to be included in index-only table top index';
comment on column DBA_INDEXES.FREELISTS is 'Number of process freelists allocated in this segment';
comment on column DBA_INDEXES.FREELIST_GROUPS is 'Number of freelist groups allocated to this segment';
comment on column DBA_INDEXES.PCT_FREE is 'Minimum percentage of free space in a block';
comment on column DBA_INDEXES.LOGGING is 'Logging attribute';
comment on column DBA_INDEXES.BLEVEL is 'B-Tree level';
comment on column DBA_INDEXES.LEAF_BLOCKS is 'The number of leaf blocks in the index';
comment on column DBA_INDEXES.DISTINCT_KEYS is 'The number of distinct keys in the index';
comment on column DBA_INDEXES.AVG_LEAF_BLOCKS_PER_KEY is 'The average number of leaf blocks per key';
comment on column DBA_INDEXES.AVG_DATA_BLOCKS_PER_KEY is 'The average number of data blocks per key';
comment on column DBA_INDEXES.CLUSTERING_FACTOR is 'A measurement of the amount of (dis)order of the table this index is for';
comment on column DBA_INDEXES.SAMPLE_SIZE is 'The sample size used in analyzing this index';
comment on column DBA_INDEXES.LAST_ANALYZED is 'The date of the most recent time this index was analyzed';
comment on column DBA_INDEXES.DEGREE is 'The number of threads per instance for scanning the partitioned index';
comment on column DBA_INDEXES.INSTANCES is 'The number of instances across which the partitioned index is to be scanned';
comment on column DBA_INDEXES.PARTITIONED is 'Is this index partitioned? YES or NO';
comment on column DBA_INDEXES.TEMPORARY is 'Can the current session only see data that it place in this object itself?';
comment on column DBA_INDEXES.GENERATED is 'Was the name of this index system generated?';
comment on column DBA_INDEXES.SECONDARY is 'Is the index object created as part of icreate for domain indexes?';
comment on column DBA_INDEXES.BUFFER_POOL is 'The default buffer pool to be used for index blocks';
comment on column DBA_INDEXES.USER_STATS is 'Were the statistics entered directly by the user?';
comment on column DBA_INDEXES.DURATION is 'If index on temporary table, then duration is sys$session or sys$transaction else NULL';
comment on column DBA_INDEXES.PCT_DIRECT_ACCESS is 'If index on IOT, then this is percentage of rows with Valid guess';
comment on column DBA_INDEXES.ITYP_OWNER is 'If domain index, then this is the indextype owner';
comment on column DBA_INDEXES.ITYP_NAME is 'If domain index, then this is the name of the associated indextype';
comment on column DBA_INDEXES.PARAMETERS is 'If domain index, then this is the parameter string';
comment on column DBA_INDEXES.GLOBAL_STATS is 'Are the statistics calculated without merging underlying partitions?';
comment on column DBA_INDEXES.DOMIDX_STATUS is 'Is the indextype of the domain index valid';
comment on column DBA_INDEXES.DOMIDX_OPSTATUS is 'Status of the operation on the domain index';
comment on column DBA_INDEXES.FUNCIDX_STATUS is 'Is the Function-based Index DISABLED or ENABLED?';
comment on column DBA_INDEXES.JOIN_INDEX is 'Is this index a join index?';
comment on column DBA_INDEXES.IOT_REDUNDANT_PKEY_ELIM is 'Were redundant primary key columns eliminated from iot secondary index?';
comment on column DBA_INDEXES.DROPPED is 'Whether index is dropped and is in Recycle Bin';

--these view are for jobs
CREATE OR REPLACE VIEW DBA_JOBS AS
		SELECT 	J.JOB_ID::NUMBER(38)		AS JOB,
				(SELECT USENAME FROM SYS_USER U WHERE U.USESYSID = J.CREATOR)::VARCHAR(30 BYTE)	AS LOG_USER,
				(SELECT USENAME FROM SYS_USER U WHERE U.USESYSID = J.PRIV_USER)::VARCHAR(30 BYTE)	AS PRIV_USER,
				(SELECT USENAME FROM SYS_USER U WHERE U.USESYSID = J.PRIV_USER)::VARCHAR(30 BYTE)	AS SCHEMA_USER,
				J.LAST_START_DATE::DATE	AS LAST_DATE,
				J.LAST_START_DATE::TIME(0)::VARCHAR(8 BYTE)	AS LAST_SEC,
				J.THIS_RUN_DATE::DATE	AS THIS_DATE,
				J.THIS_RUN_DATE::TIME(0)::VARCHAR(8 BYTE)	AS THIS_SEC,
				J.NEXT_RUN_DATE::DATE	AS NEXT_DATE,
				J.NEXT_RUN_DATE::TIME(0)::VARCHAR(8 BYTE) 	AS NEXT_SEC,
				J.TOTAL_TIME::NUMBER						AS TOTAL_TIME,
				(CASE WHEN J.JOB_STATUS & 0X08=0X08 THEN 'Y' ELSE 'N' END)::VARCHAR(1 BYTE) AS BROKEN,
				S.RECURRENCE_EXPR::VARCHAR(4000 BYTE) AS "INTERVAL",
				J.FAILURE_COUNT::NUMBER						AS FAILURES,
				P.ACTION::VARCHAR(4000 BYTE) 				AS WHAT,
				''::VARCHAR(4000 BYTE)						AS NLS_ENV,
				'0000000000000000'::BYTEA 					AS MISC_ENV,
				J.INSTANCE_ID::NUMBER						AS INSTANCE,
				(SELECT DATNAME FROM SYS_DATABASE D WHERE D.OID = J.DB) AS DBNAME
		FROM SYS_SCHEDULER_JOB J, SYS_SCHEDULER_SCHEDULE S, SYS_SCHEDULER_PROGRAM P
		WHERE J.PROGRAM_ID = P.OID AND J.SCHEDULE_ID = S.OID AND (J.JOB_STATUS & 0x20000 = 0 /* dropped job should not be shown. */) ORDER BY JOB;
REVOKE ALL ON DBA_JOBS FROM PUBLIC;
comment on view DBA_JOBS 				is 'All jobs in the database';
comment on column DBA_JOBS.JOB 			is 'Identifier of job.  Neither import/export nor repeated executions change it.';
comment on column DBA_JOBS.LOG_USER 	is 'USER who was logged in when the job was submitted';
comment on column DBA_JOBS.PRIV_USER 	is 'USER whose default privileges apply to this job';
comment on column DBA_JOBS.SCHEMA_USER 	is 'select * from bar  means  select * from schema_user.bar ' ;
comment on column DBA_JOBS.LAST_DATE 	is 'Date that this job last successfully executed';
comment on column DBA_JOBS.LAST_SEC 	is 'Same as LAST_DATE.  This is when the last successful execution started.';
comment on column DBA_JOBS.THIS_DATE 	is 'Date that this job started executing (usually null if not executing)';
comment on column DBA_JOBS.THIS_SEC 	is 'Same as THIS_DATE.  This is when the last successful execution started.';
comment on column DBA_JOBS.TOTAL_TIME 	is 'Total wallclock time spent by the system on this job, in seconds';
comment on column DBA_JOBS.NEXT_DATE 	is 'Date that this job will next be executed';
comment on column DBA_JOBS.NEXT_SEC 	is 'Same as NEXT_DATE.  The job becomes due for execution at this time.';
comment on column DBA_JOBS.BROKEN 		is 'If Y, no attempt is being made to run this job.  See dbms_jobq.broken(job).';
comment on column DBA_JOBS."INTERVAL" 	is 'A date function, evaluated at the start of execution, becomes next NEXT_DATE';
comment on column DBA_JOBS.FAILURES 	is 'How many times has this job started and failed since its last success?';
comment on column DBA_JOBS.WHAT 		is 'Body of the anonymous PL/SQL block that this job executes';
comment on column DBA_JOBS.NLS_ENV 		is 'alter session parameters describing the NLS environment of the job';
comment on column DBA_JOBS.MISC_ENV 	is 'a versioned raw maintained by the kernel, for other session parameters';
comment on column DBA_JOBS.INSTANCE 	is 'Instance number restricted to run the job';
comment on column DBA_JOBS.DBNAME 		is 'The database which this job resides in.';

CREATE OR REPLACE VIEW USER_JOBS AS 
		SELECT 	J.JOB_ID::NUMBER(38) 		AS JOB,
				(SELECT USENAME FROM SYS_USER U WHERE U.USESYSID = J.CREATOR)::VARCHAR(30 BYTE)	AS LOG_USER,
				(SELECT USENAME FROM SYS_USER U WHERE U.USESYSID = J.PRIV_USER)::VARCHAR(30 BYTE)	AS PRIV_USER,
				(SELECT USENAME FROM SYS_USER U WHERE U.USESYSID = J.PRIV_USER)::VARCHAR(30 BYTE)	AS SCHEMA_USER,
				J.LAST_START_DATE::DATE	AS LAST_DATE,
				J.LAST_START_DATE::TIME(0)::VARCHAR(8 BYTE)	AS LAST_SEC,
				J.THIS_RUN_DATE::DATE	AS THIS_DATE,
				J.THIS_RUN_DATE::TIME(0)::VARCHAR(8 BYTE)	AS THIS_SEC,
				J.NEXT_RUN_DATE::DATE	AS NEXT_DATE,
				J.NEXT_RUN_DATE::TIME(0)::VARCHAR(8 BYTE)	AS NEXT_SEC,
				J.TOTAL_TIME::NUMBER						AS TOTAL_TIME,
				(CASE WHEN J.JOB_STATUS & 0X08=0X08 THEN 'Y' ELSE 'N' END)::VARCHAR(1 BYTE) AS BROKEN,
				S.RECURRENCE_EXPR::VARCHAR(4000 BYTE) AS "INTERVAL",
				J.FAILURE_COUNT::NUMBER						AS FAILURES,
				P.ACTION::VARCHAR(4000 BYTE)				AS WHAT,
				''::VARCHAR(4000 BYTE)						AS NLS_ENV,
				'0000000000000000'::bytea		AS MISC_ENV,
				J.INSTANCE_ID::NUMBER						AS INSTANCE,
				(SELECT DATNAME FROM SYS_DATABASE D WHERE D.OID = J.DB) AS DBNAME
		FROM SYS_SCHEDULER_JOB J, SYS_SCHEDULER_SCHEDULE S, SYS_SCHEDULER_PROGRAM P
		WHERE J.PROGRAM_ID = P.OID AND J.SCHEDULE_ID = S.OID AND (J.JOB_STATUS & 0x20000 = 0 /* dropped job should not be shown. */) AND (J.CREATOR = UID OR J.PRIV_USER = UID) ORDER BY JOB;
GRANT SELECT ON sys_catalog.USER_JOBS TO PUBLIC;
comment on view USER_JOBS 				is 'All jobs owned by this user';
comment on column USER_JOBS.JOB 		is 'Identifier of job.  Neither import/export nor repeated executions change it.';
comment on column USER_JOBS.LOG_USER 	is 'USER who was logged in when the job was submitted';
comment on column USER_JOBS.PRIV_USER 	is 'USER whose default privileges apply to this job';
comment on column USER_JOBS.SCHEMA_USER	is 'select * from bar  means  select * from schema_user.bar ' ;
comment on column USER_JOBS.LAST_DATE 	is 'Date that this job last successfully executed';
comment on column USER_JOBS.LAST_SEC 	is 'Same as LAST_DATE.  This is when the last successful execution started.';
comment on column USER_JOBS.THIS_DATE 	is 'Date that this job started executing (usually null if not executing)';
comment on column USER_JOBS.THIS_SEC 	is 'Same as THIS_DATE.  This is when the last successful execution started.';
comment on column USER_JOBS.TOTAL_TIME 	is 'Total wallclock time spent by the system on this job, in seconds';
comment on column USER_JOBS.NEXT_DATE 	is 'Date that this job will next be executed';
comment on column USER_JOBS.NEXT_SEC 	is 'Same as NEXT_DATE.  The job becomes due for execution at this time.';
comment on column USER_JOBS.BROKEN 		is 'If Y, no attempt is being made to run this job.  See dbms_jobq.broken(job).';
comment on column USER_JOBS."INTERVAL" 	is 'A date function, evaluated at the start of execution, becomes next NEXT_DATE';
comment on column USER_JOBS.FAILURES 	is 'How many times has this job started and failed since its last success?';
comment on column USER_JOBS.WHAT 		is 'Body of the anonymous PL/SQL block that this job executes';
comment on column USER_JOBS.NLS_ENV 	is 'alter session parameters describing the NLS environment of the job';
comment on column USER_JOBS.MISC_ENV 	is 'a versioned raw maintained by the kernel, for other session parameters';
comment on column USER_JOBS.INSTANCE 	is 'Instance number restricted to run the job';
comment on column USER_JOBS.DBNAME 		is 'The database which this job resides in.';

create or replace view ALL_JOBS as select * from sys_catalog.USER_JOBS;
grant select on sys_catalog.ALL_JOBS to public;

CREATE OR REPLACE VIEW DBA_JOBS_RUNNING AS
	SELECT 	J.SID::NUMBER(38)				AS SID,
			J.JOB_ID::NUMBER(38)			AS JOB,
			J.FAILURE_COUNT::NUMBER		AS FAILURES,
			J.LAST_START_DATE::DATE		AS LAST_DATE,
			J.LAST_START_DATE::TIME(0)::VARCHAR(8 BYTE)	AS LAST_SEC,
			J.THIS_RUN_DATE::DATE		AS THIS_DATE,
			J.THIS_RUN_DATE::TIME(0)::VARCHAR(8 BYTE)	AS THIS_SEC,
			J.INSTANCE_ID::NUMBER		AS INSTANCE,			
			(SELECT DATNAME FROM SYS_DATABASE D WHERE D.OID = J.DB) AS DBNAME
	FROM SYS_SCHEDULER_JOB J, SYS_SCHEDULER_SCHEDULE S, SYS_SCHEDULER_PROGRAM P
	WHERE J.PROGRAM_ID = P.OID AND J.SCHEDULE_ID = S.OID AND (J.JOB_STATUS & 0x02 = 0x02) ORDER BY JOB;
REVOKE ALL ON sys_catalog.DBA_JOBS_RUNNING FROM PUBLIC;
comment on view DBA_JOBS_RUNNING 			 is 'All jobs in the database which are currently running';
comment on column DBA_JOBS_RUNNING.SID 		 is 'Identifier of process which is executing the job. ';
comment on column DBA_JOBS_RUNNING.JOB 		 is 'Identifier of job.  This job is currently executing.';
comment on column DBA_JOBS_RUNNING.LAST_DATE is 'Date that this job last successfully executed';
comment on column DBA_JOBS_RUNNING.LAST_SEC  is 'Same as LAST_DATE.  This is when the last successful execution started.';
comment on column DBA_JOBS_RUNNING.THIS_DATE is 'Date that this job started executing (usually null if not executing)';
comment on column DBA_JOBS_RUNNING.THIS_SEC  is 'Same as THIS_DATE.  This is when the last successful execution started.';
comment on column DBA_JOBS_RUNNING.FAILURES  is 'How many times has this job started and failed since its last success?';
comment on column DBA_JOBS_RUNNING.INSTANCE  is 'The instance number restricted to run the job';
comment on column DBA_JOBS_RUNNING.DBNAME 	 is 'The database which this job resides in.';

--for sys_scheduler_job:
create or replace procedure update_sys_scheduler_job(col_name name, job bigint, new_val text) as
declare 
	job_oid oid;
begin
	select oid into job_oid from sys_scheduler_job where job_id = job;
	
	if job_oid is null then
		raise invalid_job_number;
	end if;
	
	perform alter_sys_scheduler_tables('update', 'sys_scheduler_job', col_name, job_oid, new_val);
end;

--bug#15842: system views compatible with oracle.
create or replace view USER_TAB_COLUMNS
    (TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER,
     DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
     DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
     DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE,
     CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH,
     GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH, CHAR_USED,
     V80_FMT_IMAGE, DATA_UPGRADED, HISTOGRAM)
as
select TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER,
       DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
       DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
       DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE,
       CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH,
       GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH, CHAR_USED,
       V80_FMT_IMAGE, DATA_UPGRADED, HISTOGRAM
  from USER_TAB_COLS
 where HIDDEN_COLUMN = 'NO';

comment on view USER_TAB_COLUMNS is 'Columns of user''s tables, views and clusters';
comment on column USER_TAB_COLUMNS.TABLE_NAME is 'Table, view or cluster name';
comment on column USER_TAB_COLUMNS.COLUMN_NAME is 'Column name';
comment on column USER_TAB_COLUMNS.DATA_LENGTH is 'Length of the column in bytes';
comment on column USER_TAB_COLUMNS.DATA_TYPE is 'Datatype of the column';
comment on column USER_TAB_COLUMNS.DATA_TYPE_MOD is 'Datatype modifier of the column';
comment on column USER_TAB_COLUMNS.DATA_TYPE_OWNER is 'Owner of the datatype of the column';
comment on column USER_TAB_COLUMNS.DATA_PRECISION is 'Length: decimal digits (NUMBER) or binary digits (FLOAT)';
comment on column USER_TAB_COLUMNS.DATA_SCALE is 'Digits to right of decimal point in a number';
comment on column USER_TAB_COLUMNS.NULLABLE is 'Does column allow NULL values?';
comment on column USER_TAB_COLUMNS.COLUMN_ID is 'Sequence number of the column as created';
comment on column USER_TAB_COLUMNS.DEFAULT_LENGTH is 'Length of default value for the column';
comment on column USER_TAB_COLUMNS.DATA_DEFAULT is 'Default value for the column';
comment on column USER_TAB_COLUMNS.NUM_DISTINCT is 'The number of distinct values in the column';
comment on column USER_TAB_COLUMNS.LOW_VALUE is 'The low value in the column';
comment on column USER_TAB_COLUMNS.HIGH_VALUE is 'The high value in the column';
comment on column USER_TAB_COLUMNS.DENSITY is 'The density of the column';
comment on column USER_TAB_COLUMNS.NUM_NULLS is 'The number of nulls in the column';
comment on column USER_TAB_COLUMNS.NUM_BUCKETS is 'The number of buckets in histogram for the column';
comment on column USER_TAB_COLUMNS.LAST_ANALYZED is 'The date of the most recent time this column was analyzed';
comment on column USER_TAB_COLUMNS.SAMPLE_SIZE is 'The sample size used in analyzing this column';
comment on column USER_TAB_COLUMNS.CHARACTER_SET_NAME is 'Character set name';
comment on column USER_TAB_COLUMNS.CHAR_COL_DECL_LENGTH is 'Declaration length of character type column';
comment on column USER_TAB_COLUMNS.GLOBAL_STATS is 'Are the statistics calculated without merging underlying partitions?';
comment on column USER_TAB_COLUMNS.USER_STATS is 'Were the statistics entered directly by the user?';
comment on column USER_TAB_COLUMNS.AVG_COL_LEN is 'The average length of the column in bytes';
comment on column USER_TAB_COLUMNS.CHAR_LENGTH is 'The maximum length of the column in characters';
comment on column USER_TAB_COLUMNS.CHAR_USED is 'C is maximum length given in characters, B if in bytes';
comment on column USER_TAB_COLUMNS.V80_FMT_IMAGE is 'Is column data in 8.0 image format?';
comment on column USER_TAB_COLUMNS.DATA_UPGRADED is 'Has column data been upgraded to the latest type version format?';
grant select on sys_catalog.USER_TAB_COLUMNS to PUBLIC;

create or replace view ALL_TAB_COLUMNS
    ("OWNER", TABLE_NAME,
     COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER,
     DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
     DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
     DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE,
     CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH,
     GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH, CHAR_USED,
     V80_FMT_IMAGE, DATA_UPGRADED, HISTOGRAM)
as
select "OWNER", TABLE_NAME,
       COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER,
       DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
       DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
       DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE,
       CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH,
       GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH, CHAR_USED,
       V80_FMT_IMAGE, DATA_UPGRADED, HISTOGRAM
  from ALL_TAB_COLS
 where HIDDEN_COLUMN = 'NO';
comment on view ALL_TAB_COLUMNS is 'Columns of user''s tables, views and clusters';
comment on column ALL_TAB_COLUMNS.TABLE_NAME is 'Table, view or cluster name';
comment on column ALL_TAB_COLUMNS.COLUMN_NAME is 'Column name';
comment on column ALL_TAB_COLUMNS.DATA_LENGTH is 'Length of the column in bytes';
comment on column ALL_TAB_COLUMNS.DATA_TYPE is 'Datatype of the column';
comment on column ALL_TAB_COLUMNS.DATA_TYPE_MOD is 'Datatype modifier of the column';
comment on column ALL_TAB_COLUMNS.DATA_TYPE_OWNER is 'Owner of the datatype of the column';
comment on column ALL_TAB_COLUMNS.DATA_PRECISION is 'Length: decimal digits (NUMBER) or binary digits (FLOAT)';
comment on column ALL_TAB_COLUMNS.DATA_SCALE is 'Digits to right of decimal point in a number';
comment on column ALL_TAB_COLUMNS.NULLABLE is 'Does column allow NULL values?';
comment on column ALL_TAB_COLUMNS.COLUMN_ID is 'Sequence number of the column as created';
comment on column ALL_TAB_COLUMNS.DEFAULT_LENGTH is 'Length of default value for the column';
comment on column ALL_TAB_COLUMNS.DATA_DEFAULT is 'Default value for the column';
comment on column ALL_TAB_COLUMNS.NUM_DISTINCT is 'The number of distinct values in the column';
comment on column ALL_TAB_COLUMNS.LOW_VALUE is 'The low value in the column';
comment on column ALL_TAB_COLUMNS.HIGH_VALUE is 'The high value in the column';
comment on column ALL_TAB_COLUMNS.DENSITY is 'The density of the column';
comment on column ALL_TAB_COLUMNS.NUM_NULLS is 'The number of nulls in the column';
comment on column ALL_TAB_COLUMNS.NUM_BUCKETS is 'The number of buckets in histogram for the column';
comment on column ALL_TAB_COLUMNS.LAST_ANALYZED is 'The date of the most recent time this column was analyzed';
comment on column ALL_TAB_COLUMNS.SAMPLE_SIZE is 'The sample size used in analyzing this column';
comment on column ALL_TAB_COLUMNS.CHARACTER_SET_NAME is 'Character set name';
comment on column ALL_TAB_COLUMNS.CHAR_COL_DECL_LENGTH is 'Declaration length of character type column';
comment on column ALL_TAB_COLUMNS.GLOBAL_STATS is 'Are the statistics calculated without merging underlying partitions?';
comment on column ALL_TAB_COLUMNS.USER_STATS is 'Were the statistics entered directly by the user?';
comment on column ALL_TAB_COLUMNS.AVG_COL_LEN is 'The average length of the column in bytes';
comment on column ALL_TAB_COLUMNS.CHAR_LENGTH is 'The maximum length of the column in characters';
comment on column ALL_TAB_COLUMNS.CHAR_USED is 'C if maximum length is specified in characters, B if in bytes';
comment on column ALL_TAB_COLUMNS.V80_FMT_IMAGE is 'Is column data in 8.0 image format?';
comment on column ALL_TAB_COLUMNS.DATA_UPGRADED is 'Has column data been upgraded to the latest type version format?';
grant select on sys_catalog.ALL_TAB_COLUMNS to PUBLIC;

create or replace view DBA_TAB_COLUMNS
    ("OWNER", TABLE_NAME,
     COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER,
     DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
     DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
     DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE,
     CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH,
     GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH, CHAR_USED,
     V80_FMT_IMAGE, DATA_UPGRADED, HISTOGRAM)
as
select "OWNER", TABLE_NAME,
       COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER,
       DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
       DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
       DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE,
       CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH,
       GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH, CHAR_USED,
       V80_FMT_IMAGE, DATA_UPGRADED, HISTOGRAM
  from DBA_TAB_COLS
 where HIDDEN_COLUMN = 'NO';
comment on view DBA_TAB_COLUMNS is 'Columns of user''s tables, views and clusters';
comment on column DBA_TAB_COLUMNS.TABLE_NAME is 'Table, view or cluster name';
comment on column DBA_TAB_COLUMNS.COLUMN_NAME is 'Column name';
comment on column DBA_TAB_COLUMNS.DATA_LENGTH is 'Length of the column in bytes';
comment on column DBA_TAB_COLUMNS.DATA_TYPE is 'Datatype of the column';
comment on column DBA_TAB_COLUMNS.DATA_TYPE_MOD is 'Datatype modifier of the column';
comment on column DBA_TAB_COLUMNS.DATA_TYPE_OWNER is 'Owner of the datatype of the column';
comment on column DBA_TAB_COLUMNS.DATA_PRECISION is 'Length: decimal digits (NUMBER) or binary digits (FLOAT)';
comment on column DBA_TAB_COLUMNS.DATA_SCALE is 'Digits to right of decimal point in a number';
comment on column DBA_TAB_COLUMNS.NULLABLE is 'Does column allow NULL values?';
comment on column DBA_TAB_COLUMNS.COLUMN_ID is 'Sequence number of the column as created';
comment on column DBA_TAB_COLUMNS.DEFAULT_LENGTH is 'Length of default value for the column';
comment on column DBA_TAB_COLUMNS.DATA_DEFAULT is 'Default value for the column';
comment on column DBA_TAB_COLUMNS.NUM_DISTINCT is 'The number of distinct values in the column';
comment on column DBA_TAB_COLUMNS.LOW_VALUE is 'The low value in the column';
comment on column DBA_TAB_COLUMNS.HIGH_VALUE is 'The high value in the column';
comment on column DBA_TAB_COLUMNS.DENSITY is 'The density of the column';
comment on column DBA_TAB_COLUMNS.NUM_NULLS is 'The number of nulls in the column';
comment on column DBA_TAB_COLUMNS.NUM_BUCKETS is 'The number of buckets in histogram for the column';
comment on column DBA_TAB_COLUMNS.LAST_ANALYZED is 'The date of the most recent time this column was analyzed';
comment on column DBA_TAB_COLUMNS.SAMPLE_SIZE is 'The sample size used in analyzing this column';
comment on column DBA_TAB_COLUMNS.CHARACTER_SET_NAME is 'Character set name';
comment on column DBA_TAB_COLUMNS.CHAR_COL_DECL_LENGTH is 'Declaration length of character type column';
comment on column DBA_TAB_COLUMNS.GLOBAL_STATS is 'Are the statistics calculated without merging underlying partitions?';
comment on column DBA_TAB_COLUMNS.USER_STATS is 'Were the statistics entered directly by the user?';
comment on column DBA_TAB_COLUMNS.AVG_COL_LEN is 'The average length of the column in bytes';
comment on column DBA_TAB_COLUMNS.CHAR_LENGTH is 'The maximum length of the column in characters';
comment on column DBA_TAB_COLUMNS.CHAR_USED is 'C if the width was specified in characters, B if in bytes';
comment on column DBA_TAB_COLUMNS.V80_FMT_IMAGE is 'Is column data in 8.0 image format?';
comment on column DBA_TAB_COLUMNS.DATA_UPGRADED is 'Has column data been upgraded to the latest type version format?';

revoke all on sys_catalog.DBA_TAB_COLUMNS from public;

--bug#15842: system views compatible with oracle.

create or replace view DBA_SYNONYMS as
select 
	s.owner::CHARACTER VARYING(30 BYTE) as OWNER,
	s.synname::CHARACTER VARYING(30 BYTE) as SYNONYM_NAME,
	if (s.dblink is null, sys_get_userbyid(c.relowner), null)::CHARACTER VARYING(30 BYTE) as TABLE_OWNER,
	s.objname::CHARACTER VARYING(30 BYTE) as TABLE_NAME,
	s.dblink::CHARACTER VARYING(128 CHAR) as DB_LINK	
from
	--keep all synonym even they point to an invalid object.
	(sys_catalog.sys_synonyms s left outer join sys_catalog.sys_namespace n on (s.objnamespace = n.nspname))
	left outer join sys_catalog.sys_class c on (s.objname = c.relname and c.relnamespace = n.oid)
	;

revoke all on sys_catalog.DBA_SYNONYMS from PUBLIC;
comment on view DBA_SYNONYMS is 'All synonyms in the database';
comment on column DBA_SYNONYMS.OWNER is 'Username of the owner of the synonym';
comment on column DBA_SYNONYMS.SYNONYM_NAME is 'Name of the synonym';
comment on column DBA_SYNONYMS.TABLE_OWNER is 'Owner of the object referenced by the synonym';
comment on column DBA_SYNONYMS.TABLE_NAME is 'Name of the object referenced by the synonym';
comment on column DBA_SYNONYMS.DB_LINK is 'Name of the database link referenced in a remote synonym';

/* returning null means it points to a remote object or an invalid object.
 * true means user has the privilege on the object the synonym (nestedly) points to.
 * false means user has no privilege on the object the synonym (nestedly) points to.
 */
create or replace function has_synonym_privilege(synname_arg name, synnamespace_arg name, priv text)
returns boolean
as
declare 
	synname_looped_point name;
	synnamespace_looped_point name;
	synonyms_count int;
	obj_count int;
	synname_var name;
	synnamespace_var name;
begin
	synname_var := upper(synname_arg);
	synnamespace_var := upper(synnamespace_arg);

	select count(1) into synonyms_count from sys_synonyms s where s.synnamespace = synnamespace_var and s.synname = synname_var and s.dblink is not null;
	if synonyms_count > 0 then
		return null;
	end if;

	synnamespace_looped_point := synnamespace_var;
	synname_looped_point := synname_var;

	select upper(s.objname) into synname_looped_point from sys_synonyms s where s.synnamespace = synnamespace_var and s.synname = synname_var;
	select upper(s.objnamespace) into synnamespace_looped_point from sys_synonyms s where s.synnamespace = synnamespace_var and s.synname = synname_var;

	--if it points to a remote object.
	select count(1) into synonyms_count from sys_synonyms s where s.synnamespace = synnamespace_looped_point and s.synname = synname_looped_point and s.dblink is not null;
	if synonyms_count > 0 then 
		return null;
	end if;

	select count(1) into synonyms_count from sys_synonyms s where s.synnamespace = synnamespace_looped_point and s.synname = synname_looped_point;
	if synonyms_count = 0 then -- it's not a synonym any more.
		select count(1) into obj_count from sys_class c, sys_namespace n where c.relname = synname_looped_point and c.relnamespace = n.oid and n.nspname = synnamespace_looped_point;
		if obj_count > 0 then
		    if (has_schema_privilege(synnamespace_looped_point,'USAGE') = true) then
			   return has_table_privilege(synnamespace_looped_point || '.' || synname_looped_point, priv); 
			else
			   return false;
			end if;
		else
			return null; --points to an invalid object.
		end if;
	else
		return has_synonym_privilege(synname_looped_point, synnamespace_looped_point, priv);
	end if;
end;

create or replace view ALL_SYNONYMS as
select 
	s.owner::CHARACTER VARYING(30 BYTE) as OWNER,
	s.synname::CHARACTER VARYING(30 BYTE) as SYNONYM_NAME,
	if (s.dblink is null, sys_get_userbyid(c.relowner), null)::CHARACTER VARYING(30 BYTE) as TABLE_OWNER,
	s.objname::CHARACTER VARYING(30 BYTE) as TABLE_NAME,
	s.dblink::CHARACTER VARYING(128 CHAR) as DB_LINK	
from 
	--keep all synonym even they point to an invalid object.
	(sys_catalog.sys_synonyms s left outer join sys_catalog.sys_namespace n on (s.objnamespace = n.nspname))
	left outer join sys_catalog.sys_class c on (s.objname = c.relname and c.relnamespace = n.oid)
where
	s.owner = (cast(current_user as varchar2(30 byte)))
	or 
	(	has_synonym_privilege(s.synname, s.synnamespace, 'SELECT') -- objects (nestedly) pointed to by synonyms current user can select.
		 or has_synonym_privilege(s.synname, s.synnamespace, 'DELETE')
		 or has_synonym_privilege(s.synname, s.synnamespace, 'UPDATE') 
		 or has_synonym_privilege(s.synname, s.synnamespace, 'INSERT')
	)--user can select the local objects (nestedly) pointed by current user
	or
    (
      sys_has_any_table_priv()
    )
	or
    (
       select usesuper = 'D' from sys_user where usesysid = uid 
    )
	--or  upper(n.nspname) = 'PUBLIC'
	or upper(s.synnamespace) = 'PUBLIC'; -- all public synonyms
grant select on sys_catalog.ALL_SYNONYMS to public;

comment on view ALL_SYNONYMS is 'All synonyms for base objects accessible to the user and session';
comment on column ALL_SYNONYMS.OWNER is 'Owner of the synonym';
comment on column ALL_SYNONYMS.SYNONYM_NAME is 'Name of the synonym';
comment on column ALL_SYNONYMS.TABLE_OWNER is 'Owner of the object referenced by the synonym';
comment on column ALL_SYNONYMS.TABLE_NAME is 'Name of the object referenced by the synonym';
comment on column ALL_SYNONYMS.DB_LINK is 'Name of the database link referenced in a remote synonym';

create or replace view USER_SYNONYMS as
select 
	s.synname::CHARACTER VARYING(30 BYTE) as SYNONYM_NAME,
	if (s.dblink is null, sys_get_userbyid(c.relowner), null)::CHARACTER VARYING(30 BYTE) as TABLE_OWNER,
	s.objname::CHARACTER VARYING(30 BYTE) as TABLE_NAME,
	s.dblink::CHARACTER VARYING(128 CHAR) as DB_LINK	
from
	--keep all synonym even they point to an invalid object.
 	(sys_catalog.sys_synonyms s left outer join sys_catalog.sys_namespace n on (s.objnamespace = n.nspname))
	left outer join sys_catalog.sys_class c on (s.objname = c.relname and c.relnamespace = n.oid)
where
	s.owner = cast(current_user as varchar2(30 byte));
grant select on sys_catalog.USER_SYNONYMS to PUBLIC;

comment on view USER_SYNONYMS is 'The user''s private synonyms';
comment on column USER_SYNONYMS.SYNONYM_NAME is 'Name of the synonym';
comment on column USER_SYNONYMS.TABLE_OWNER is 'Owner of the object referenced by the synonym';
comment on column USER_SYNONYMS.TABLE_NAME is 'Name of the object referenced by the synonym';
comment on column USER_SYNONYMS.DB_LINK is 'Database link referenced in a remote synonym';

--bug#15842: system views compatible with oracle.
create or replace view DBA_IND_COLUMNS as
select 
	sys_get_userbyid(ic.relowner)::CHARACTER VARYING(30 BYTE) as INDEX_OWNER
	,ic.relname::CHARACTER VARYING(30 BYTE) as INDEX_NAME
	,sys_get_userbyid(tc.relowner)::CHARACTER VARYING(30 BYTE) as TABLE_OWNER
	,tc.relname::CHARACTER VARYING(30 BYTE) as TABLE_NAME
	,a.attname::CHARACTER VARYING(4000 CHAR) as COLUMN_NAME
	,ia.attnum as COLUMN_POSITION
	,(
		case when a.attlen = -1 then
		(
			--atttypmod < 0 means it's in bytes.
			case t.typname 
				when 'BIT' 			then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'BIT VARYING' 	then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIMETZ' 		then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIME' 		then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIMESTAMPTZ' 	then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIMESTAMP' 	then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'INTERVAL' 	then if((a.atttypmod >> 16)=0, a.atttypmod, 0)
				when 'VARBIT' 		then if((a.atttypmod >> 16)=0, a.atttypmod, 0)
				/* sys_class.relkeyid and sys_attribute.attkeyid all make a.atttypmod = -1, but they are not strings. */
				when 'VARCHAR' 		then if(a.atttypmod = -1, null, if ((a.atttypmod >> 16)=0, null, abs(a.atttypmod)-4))
				when 'BPCHAR' 		then if(a.atttypmod = -1, null, if ((a.atttypmod >> 16)=0, null, abs(a.atttypmod)-4))
				else if((a.atttypmod >> 16)=0,a.atttypmod-4, 0)
			end
		)
		else
			a.attlen
		end
	)::NUMBER AS COLUMN_LENGTH --Maximum length of column in bytes.
	,(
		case when a.attlen = -1 then
		(
			case T.typname 
				when 'VARCHAR' 	then if ((a.atttypmod>>16)=0, a.atttypmod - 4, null)
				when 'BPCHAR' 	then if ((a.atttypmod>>16)=0, a.atttypmod - 4, null)				
			end
		)
		else
			0
		end
	  )::NUMBER AS CHAR_LENGTH --Maximum length of column in chars. This column will show strings in characters only.
	,if ((i.indoption[COLUMN_POSITION-1]&0x01/* it's hard coded.*/)=0, 'ASC', 'DESC')::CHARACTER VARYING(4 CHAR) as DESCEND
from 
	sys_catalog.sys_index i, 
	sys_catalog.sys_class tc,	/* table in sys_class */
	sys_catalog.sys_class ic,	/* index in sys_class */
	sys_catalog.sys_attribute a,/* attribute of column */
	sys_catalog.sys_type t, 
	sys_catalog.sys_attribute ia/* index's column: the columns in indexes will be shown in this table too. */
where
	(i.indrelid = a.attrelid and a.attnum = any(i.indkey))
	and i.indrelid = tc.oid -- table's oid
	and i.indexrelid = ic.oid -- index's oid
	and a.atttypid = t.oid
	and ia.attrelid = i.indexrelid
	and ia.attname = a.attname
;
revoke all on sys_catalog.DBA_IND_COLUMNS from public;
comment on view DBA_IND_COLUMNS is 'COLUMNs comprising INDEXes on all TABLEs and CLUSTERs';
comment on column DBA_IND_COLUMNS.INDEX_OWNER is 'Index owner';
comment on column DBA_IND_COLUMNS.INDEX_NAME is 'Index name';
comment on column DBA_IND_COLUMNS.TABLE_OWNER is 'Table or cluster owner';
comment on column DBA_IND_COLUMNS.TABLE_NAME is 'Table or cluster name';
comment on column DBA_IND_COLUMNS.COLUMN_NAME is 'Column name or attribute of object column';
comment on column DBA_IND_COLUMNS.COLUMN_POSITION is 'Position of column or attribute within index';
comment on column DBA_IND_COLUMNS.COLUMN_LENGTH is 'Maximum length of the column or attribute, in bytes';
comment on column DBA_IND_COLUMNS.CHAR_LENGTH is 'Maximum length of the column or attribute, in characters';
comment on column DBA_IND_COLUMNS.DESCEND is 'DESC if this column is sorted in descending order on disk, otherwise ASC';

create or replace view ALL_IND_COLUMNS as
select 
	sys_get_userbyid(ic.relowner)::CHARACTER VARYING(30 BYTE) as INDEX_OWNER
	,ic.relname::CHARACTER VARYING(30 BYTE) as INDEX_NAME
	,sys_get_userbyid(tc.relowner)::CHARACTER VARYING(30 BYTE) as TABLE_OWNER
	,tc.relname::CHARACTER VARYING(30 BYTE) as TABLE_NAME
	,a.attname::CHARACTER VARYING(4000 CHAR) as COLUMN_NAME
	,ia.attnum as COLUMN_POSITION
	,(
		case when a.attlen = -1 then
		(
			--atttypmod < 0 means it's in bytes.
			case t.typname 
				when 'BIT' 			then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'BIT VARYING' 	then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIMETZ' 		then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIME' 		then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIMESTAMPTZ' 	then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIMESTAMP' 	then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'INTERVAL' 	then if((a.atttypmod >> 16)=0, a.atttypmod, 0)
				when 'VARBIT' 		then if((a.atttypmod >> 16)=0, a.atttypmod, 0)
				/* sys_class.relkeyid and sys_attribute.attkeyid all make a.atttypmod = -1, but they are not strings. */
				when 'VARCHAR' 		then if(a.atttypmod = -1, null, if ((a.atttypmod >> 16)=0, null, abs(a.atttypmod)-4))
				when 'BPCHAR' 		then if(a.atttypmod = -1, null, if ((a.atttypmod >> 16)=0, null, abs(a.atttypmod)-4))
				else if((a.atttypmod >> 16)=0,a.atttypmod-4, 0)
			end
		)
		else
			a.attlen
		end
	)::NUMBER AS COLUMN_LENGTH --Maximum length of column in bytes.
	,(
		case when a.attlen = -1 then
		(
			case T.typname 
				when 'VARCHAR' 	then if ((a.atttypmod>>16)=0, a.atttypmod - 4, null)
				when 'BPCHAR' 	then if ((a.atttypmod>>16)=0, a.atttypmod - 4, null)				
			end
		)
		else
			0
		end
	  )::NUMBER AS CHAR_LENGTH --Maximum length of column in chars. This column will show strings in characters only.
	,if ((i.indoption[COLUMN_POSITION-1]&0x01/* it's hard coded.*/)=0, 'ASC', 'DESC')::CHARACTER VARYING(4 CHAR) as DESCEND
from 
	sys_catalog.sys_index i, 
	sys_catalog.sys_class tc,	/* table in sys_class */
	sys_catalog.sys_class ic,	/* index in sys_class */
	sys_catalog.sys_attribute a,/* attribute of column */
	sys_catalog.sys_type t, 
	sys_catalog.sys_attribute ia/* index's column: the columns in indexes will be shown in this table too. */
where
	(i.indrelid = a.attrelid and a.attnum = any(i.indkey))
	and i.indrelid = tc.oid -- table's oid
	and i.indexrelid = ic.oid -- index's oid
	and a.atttypid = t.oid
	and ia.attrelid = i.indexrelid
	and ia.attname = a.attname
	and 
	(
	    (
		has_table_privilege(tc.oid, 'SELECT')
		or has_table_privilege(tc.oid, 'UPDATE')
		or has_table_privilege(tc.oid, 'DELETE')
	)
        or
		( 
		  sys_has_any_table_priv()
		)  
	)
;

grant select on sys_catalog.ALL_IND_COLUMNS to public;
comment on view ALL_IND_COLUMNS is 'COLUMNs comprising INDEXes on accessible TABLES';
comment on column ALL_IND_COLUMNS.INDEX_OWNER is 'Index owner';
comment on column ALL_IND_COLUMNS.INDEX_NAME is 'Index name';
comment on column ALL_IND_COLUMNS.TABLE_OWNER is 'Table or cluster owner';
comment on column ALL_IND_COLUMNS.TABLE_NAME is 'Table or cluster name';
comment on column ALL_IND_COLUMNS.COLUMN_NAME is 'Column name or attribute of object column';
comment on column ALL_IND_COLUMNS.COLUMN_POSITION is 'Position of column or attribute within index';
comment on column ALL_IND_COLUMNS.COLUMN_LENGTH is 'Maximum length of the column or attribute, in bytes';
comment on column ALL_IND_COLUMNS.CHAR_LENGTH is 'Maximum length of the column or attribute, in characters';
comment on column ALL_IND_COLUMNS.DESCEND is 'DESC if this column is sorted in descending order on disk, otherwise ASC';


create or replace view USER_IND_COLUMNS as
select 
	ic.relname::CHARACTER VARYING(30 BYTE) as INDEX_NAME
	,sys_get_userbyid(tc.relowner)::CHARACTER VARYING(30 BYTE) as TABLE_OWNER
	,tc.relname::CHARACTER VARYING(30 BYTE) as TABLE_NAME
	,a.attname::CHARACTER VARYING(4000 CHAR) as COLUMN_NAME
	,ia.attnum as COLUMN_POSITION
	,(
		case when a.attlen = -1 then
		(
			--atttypmod < 0 means it's in bytes.
			case t.typname 
				when 'BIT' 			then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'BIT VARYING' 	then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIMETZ' 		then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIME' 		then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIMESTAMPTZ' 	then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'TIMESTAMP' 	then if((a.atttypmod >> 16)!=0, abs(a.atttypmod), 0)
				when 'INTERVAL' 	then if((a.atttypmod >> 16)=0, a.atttypmod, 0)
				when 'VARBIT' 		then if((a.atttypmod >> 16)=0, a.atttypmod, 0)
				/* sys_class.relkeyid and sys_attribute.attkeyid all make a.atttypmod = -1, but they are not strings. */
				when 'VARCHAR' 		then if(a.atttypmod = -1, null, if ((a.atttypmod >> 16)=0, null, abs(a.atttypmod)-4))
				when 'BPCHAR' 		then if(a.atttypmod = -1, null, if ((a.atttypmod >> 16)=0, null, abs(a.atttypmod)-4))
				else if((a.atttypmod >> 16)=0,a.atttypmod-4, 0)
			end
		)
		else
			a.attlen
		end
	)::NUMBER AS COLUMN_LENGTH --Maximum length of column in bytes.
	,(
		case when a.attlen = -1 then
		(
			case T.typname 
				-- 
				when 'VARCHAR' 	then if ((a.atttypmod>>16)=0, a.atttypmod - 4, null)
				when 'BPCHAR' 	then if ((a.atttypmod>>16)=0, a.atttypmod - 4, null)				
			end
		)
		else
			0
		end
	)::NUMBER AS CHAR_LENGTH --Maximum length of column in chars. This column will show strings in characters only.
	,if ((i.indoption[COLUMN_POSITION-1]&0x01/* it's hard coded.*/)=0, 'ASC', 'DESC')::CHARACTER VARYING(4 CHAR) as DESCEND
from 
	sys_catalog.sys_index i, 
	sys_catalog.sys_class tc,	/* table in sys_class */
	sys_catalog.sys_class ic,	/* index in sys_class */
	sys_catalog.sys_attribute a,/* attribute of column */
	sys_catalog.sys_type t, 
	sys_catalog.sys_attribute ia/* index's column: the columns in indexes will be shown in this table too. */
where
	(i.indrelid = a.attrelid and a.attnum = any(i.indkey))
	and i.indrelid = tc.oid -- table's oid
	and i.indexrelid = ic.oid -- index's oid
	and ia.attrelid = i.indexrelid
	and ia.attname = a.attname
	and ic.relowner = uid
	and a.atttypid = t.oid
;
grant select on sys_catalog.USER_IND_COLUMNS to public;
comment on view USER_IND_COLUMNS is 'COLUMNs comprising user''s INDEXes and INDEXes on user''s TABLES';
comment on column USER_IND_COLUMNS.INDEX_NAME is 'Index name';
comment on column USER_IND_COLUMNS.TABLE_NAME is 'Table or cluster name';
comment on column USER_IND_COLUMNS.COLUMN_NAME is 'Column name or attribute of object column';
comment on column USER_IND_COLUMNS.COLUMN_POSITION is 'Position of column or attribute within index';
comment on column USER_IND_COLUMNS.COLUMN_LENGTH is 'Maximum length of the column or attribute, in bytes';
comment on column USER_IND_COLUMNS.CHAR_LENGTH is 'Maximum length of the column or attribute, in characters';
comment on column USER_IND_COLUMNS.DESCEND is 'DESC if this column is sorted descending on disk, otherwise ASC';

--bug#15842: system views compatible with oracle.
create or replace view USER_VIEWS as
select 
	c.relname::CHARACTER VARYING(30 BYTE) as VIEW_NAME
	, length(sys_get_viewdef(c.oid))::number as TEXT_LENGTH
	, sys_get_viewdef(c.oid) as TEXT
	, length(t.typname||'   ')::number as TYPE_TEXT_LENGTH
	, (t.typname||'   ')::CHARACTER VARYING(4000 CHAR) as TYPE_TEXT --with three blanks as tail.
	, null::NUMBER as OID_TEXT_LENGTH
	, null::CHARACTER VARYING(4000 CHAR) as OID_TEXT	
	, sys_get_userbyid(t.TYPOWNER)::CHARACTER VARYING(30 BYTE) as VIEW_TYPE_OWNER
	, t.typname::CHARACTER VARYING(30 BYTE) as VIEW_TYPE
	, null::CHARACTER VARYING(30 BYTE) as SUPERVIEW_NAME
	, 'N'::CHARACTER VARYING(1 CHAR) as EDITIONING_VIEW
	, CAST(
            (CASE WHEN sys_view_is_updatable(c.oid) IN (0, 2) THEN 'N'
				  ELSE 'Y'
			END)
            AS VARCHAR(1 CHAR)) as READ_ONLY
from 
	sys_class c
	,sys_type t
where
	upper(c.relkind) = 'V'
	and c.oid = t.typrelid(+)
	and c.relowner = uid
;

grant select on sys_catalog.USER_VIEWS to PUBLIC;
comment on view USER_VIEWS is 'Description of the user''s own views';
comment on column USER_VIEWS.VIEW_NAME is 'Name of the view';
comment on column USER_VIEWS.TEXT_LENGTH is 'Length of the view text';
comment on column USER_VIEWS.TEXT is 'View text';
comment on column USER_VIEWS.TYPE_TEXT_LENGTH is 'Length of the type clause of the object view';
comment on column USER_VIEWS.TYPE_TEXT is 'Type clause of the object view';
comment on column USER_VIEWS.OID_TEXT_LENGTH is 'Length of the WITH OBJECT OID clause of the object view';
comment on column USER_VIEWS.OID_TEXT is 'WITH OBJECT OID clause of the object view';
comment on column USER_VIEWS.VIEW_TYPE_OWNER is 'Owner of the type of the view if the view is a object view';
comment on column USER_VIEWS.VIEW_TYPE is 'Type of the view if the view is a object view';
comment on column USER_VIEWS.SUPERVIEW_NAME is 'Name of the superview, if view is a subview';
comment on column USER_VIEWS.EDITIONING_VIEW is 'An indicator of whether the view is an Editioning View';
comment on column USER_VIEWS.READ_ONLY is 'An indicator of whether the view is a Read Only View';


create or replace view ALL_VIEWS as
select 
	sys_get_userbyid(c.relowner)::CHARACTER VARYING(30 byte) as OWNER
	, c.relname::CHARACTER VARYING(30 byte) as VIEW_NAME
	, length(sys_get_viewdef(c.oid))::number as TEXT_LENGTH
	, sys_get_viewdef(c.oid) as TEXT
	, length(t.typname||'   ')::number as TYPE_TEXT_LENGTH
	, (t.typname||'   ')::CHARACTER VARYING(4000 CHAR) as TYPE_TEXT --with three blanks as tail.
	, null::NUMBER as OID_TEXT_LENGTH
	, null::CHARACTER VARYING(4000 CHAR) as OID_TEXT	
	, sys_get_userbyid(t.TYPOWNER)::CHARACTER VARYING(30 byte) as VIEW_TYPE_OWNER
	, t.typname::CHARACTER VARYING(30 byte) as VIEW_TYPE
	, null::CHARACTER VARYING(30 byte) as SUPERVIEW_NAME
	, 'N'::CHARACTER VARYING(1 CHAR) as EDITIONING_VIEW
	, CAST(
            (CASE WHEN sys_view_is_updatable(c.oid) IN (0, 2) THEN 'N'
				  ELSE 'Y'
			END)
            AS VARCHAR(1 CHAR)) as READ_ONLY
from 
	sys_class c left outer join sys_type t on (c.oid = t.typrelid)
where
	upper(c.relkind) = 'V'
	and 
	(
     	(
			has_table_privilege(c.oid, 'select')
			or has_table_privilege(c.oid, 'update')
			or has_table_privilege(c.oid, 'delete')
		)
		or
		(
		  sys_has_any_table_priv()
		)
	)	
;

grant select on sys_catalog.all_views to public;
comment on view ALL_VIEWS is 'Description of views accessible to the user';
comment on column ALL_VIEWS.OWNER is 'Owner of the view';
comment on column ALL_VIEWS.VIEW_NAME is 'Name of the view';
comment on column ALL_VIEWS.TEXT_LENGTH is 'Length of the view text';
comment on column ALL_VIEWS.TEXT is 'View text';
comment on column ALL_VIEWS.TYPE_TEXT_LENGTH is 'Length of the type clause of the object view';
comment on column ALL_VIEWS.TYPE_TEXT is 'Type clause of the object view';
comment on column ALL_VIEWS.OID_TEXT_LENGTH is 'Length of the WITH OBJECT OID clause of the object view';
comment on column ALL_VIEWS.OID_TEXT is 'WITH OBJECT OID clause of the object view';
comment on column ALL_VIEWS.VIEW_TYPE_OWNER is 'Owner of the type of the view if the view is an object view';
comment on column ALL_VIEWS.VIEW_TYPE is 'Type of the view if the view is an object view';
comment on column ALL_VIEWS.SUPERVIEW_NAME is 'Name of the superview, if view is a subview';
comment on column ALL_VIEWS.EDITIONING_VIEW is 'An indicator of whether the view is an Editioning View';
comment on column ALL_VIEWS.READ_ONLY is 'An indicator of whether the view is a Read Only View';

create or replace view DBA_VIEWS as
select 
	sys_get_userbyid(c.relowner)::CHARACTER VARYING(30 BYTE) as OWNER
	, c.relname::CHARACTER VARYING(30 BYTE) as VIEW_NAME
	, length(sys_get_viewdef(c.oid))::number as TEXT_LENGTH
	, sys_get_viewdef(c.oid) as TEXT
	, length(t.typname||'   ')::number as TYPE_TEXT_LENGTH
	, (t.typname||'   ')::CHARACTER VARYING(4000 CHAR) as TYPE_TEXT --with three blanks as tail.
	, null::NUMBER as OID_TEXT_LENGTH
	, null::CHARACTER VARYING(4000 CHAR) as OID_TEXT	
	, sys_get_userbyid(t.TYPOWNER)::CHARACTER VARYING(30 BYTE) as VIEW_TYPE_OWNER
	, t.typname::CHARACTER VARYING(30 BYTE) as VIEW_TYPE
	, null::CHARACTER VARYING(30 BYTE) as SUPERVIEW_NAME
	, 'N'::CHARACTER VARYING(1 CHAR) as EDITIONING_VIEW
	, CAST(
            (CASE WHEN sys_view_is_updatable(c.oid) IN (0, 2) THEN 'N'
				  ELSE 'Y'
			END)
            AS VARCHAR(1 CHAR)) as READ_ONLY
from 
	sys_class c
	,sys_type t
where
	upper(c.relkind) = 'V'
	and c.oid = t.typrelid(+)
;

revoke all on sys_catalog.dba_views from public;
comment on view DBA_VIEWS is 'Description of all views in the database';
comment on column DBA_VIEWS.OWNER is 'Owner of the view';
comment on column DBA_VIEWS.VIEW_NAME is 'Name of the view';
comment on column DBA_VIEWS.TEXT_LENGTH is 'Length of the view text';
comment on column DBA_VIEWS.TEXT is 'View text';
comment on column DBA_VIEWS.TYPE_TEXT_LENGTH is 'Length of the type clause of the object view';
comment on column DBA_VIEWS.TYPE_TEXT is 'Type clause of the object view';
comment on column DBA_VIEWS.OID_TEXT_LENGTH is 'Length of the WITH OBJECT OID clause of the object view';
comment on column DBA_VIEWS.OID_TEXT is 'WITH OBJECT OID clause of the object view';
comment on column DBA_VIEWS.VIEW_TYPE_OWNER is 'Owner of the type of the view if the view is an object view';
comment on column DBA_VIEWS.VIEW_TYPE is 'Type of the view if the view is an object view';
comment on column DBA_VIEWS.SUPERVIEW_NAME is 'Name of the superview, if view is a subview';
comment on column DBA_VIEWS.EDITIONING_VIEW is 'An indicator of whether the view is an Editioning View';
comment on column DBA_VIEWS.READ_ONLY is 'An indicator of whether the view is a Read Only View';

--bug#15842: system views compatible with oracle.
create or replace view DICTIONARY
    (TABLE_NAME, COMMENTS)
as 
	select c.relname::CHARACTER VARYING(30 BYTE), d.description::CHARACTER VARYING(4000 CHAR)
	from sys_catalog.sys_class c left outer join sys_catalog.sys_description d on (c.oid = d.objoid)
	where
		/* all dba_*, user_*, all_* views which can be selected by user. */
		c.relkind = 'v' 
		and c.relowner = 10 /* system user, by whom database was initialized. The same with Oracle's sys user */
		and (
				c.relname like 'USER%'
				or c.relname like 'ALL%'
				or (
						c.relname like 'DBA%'
						and ( 
							    ( 
							has_table_privilege(c.oid, 'SELECT')
							or has_table_privilege(c.oid, 'DELETE')
							or has_table_privilege(c.oid, 'UPDATE')
						)	
							 or
							    (
							      sys_has_any_table_priv(priv => 'SELECT ANY TABLE')
							    )	
						    )	
					)
			)
		and ( d.objsubid = 0 or d.objsubid is null) /* Get the description of relation. */

union
	/* hard coded system objects */
	select c.relname::CHARACTER VARYING(30 BYTE), d.description::CHARACTER VARYING(4000 CHAR)
	from sys_catalog.sys_class c, sys_catalog.sys_description d
	where
		c.oid = d.objoid(+)
		and c.relowner = 10 /* equally with oracle's SYS user */
		and upper(c.relname) in
		('AUDIT_ACTIONS', 'COLUMN_PRIVILEGES', 'DICTIONARY',
        'DICT_COLUMNS', 'DUAL', 'GLOBAL_NAME', 'INDEX_HISTOGRAM',
        'INDEX_STATS', 'RESOURCE_COST', 'ROLE_ROLE_PRIVS', 'ROLE_SYS_PRIVS',
        'ROLE_TAB_PRIVS', 'SESSION_PRIVS', 'SESSION_ROLES',
        'TABLE_PRIVILEGES','NLS_SESSION_PARAMETERS','NLS_INSTANCE_PARAMETERS',
        'NLS_DATABASE_PARAMETERS', 'DATABASE_COMPATIBLE_LEVEL',
        'DBMS_ALERT_INFO', 'DBMS_LOCK_ALLOCATED')
union
	/* synonyms for sys views and the synonyms' names are not the same as sys views */
	select s.synname::CHARACTER VARYING(30 BYTE), ('Synonym for ' || s.objname)::CHARACTER VARYING(4000 CHAR)
	from sys_catalog.sys_synonym s
	where 
		s.synowner = 10 /* system user, by whom database was initialized. */
		and not exists
			(/* synonym name should not be the same with view's name */
				select null from sys_catalog.sys_class c_sub where c_sub.relkind = 'v' and c_sub.relname = s.synname
				and c_sub.relowner = 10
			)
		and 
		(
			s.dblink is null /* only local objects */
			and 
			if (
					(select count(*) > 0 from sys_class c2, sys_namespace n2 where c2.relname = s.objname and c2.relnamespace = n2.oid and n2.nspname = s.objnamespace)
					,has_table_privilege(s.objnamespace || '.' ||s.objname, 'select')
					 or has_table_privilege(s.objnamespace || '.' ||s.objname, 'update')
					 or has_table_privilege(s.objnamespace || '.' ||s.objname, 'delete')
					,false --the synonym points to an invalid object.
			)
			or
				sys_has_any_table_priv()
		)
;
grant select on sys_catalog.DICTIONARY to public;
create or replace view DICT as select * from DICTIONARY;
grant select on sys_catalog.DICT to public;

--dba_sequences
create or replace function get_sequences(wherestmt text)
returns setof record as
declare
	rec record;
	seq record;
	retval record;
	sql  text;
begin
	for rec in execute 'select c.oid as oid, a.usename as usename, c.relname as relname, n.nspname as nspname 
  from sys_catalog.sys_class c, sys_catalog.sys_user a, sys_catalog.sys_namespace n 
  where c.relowner = a.usesysid and c.relkind=''S'' and c.relnamespace=n.oid ' || wherestmt 
	loop
		for seq in execute 'select * from ' || '"' || rec.nspname || '"' || '.' || '"' || rec.relname || '"' loop
		   SELECT into retval rec.usename, seq.sequence_name, seq.last_value, seq.increment_by,
            seq.max_value, seq.min_value, seq.cache_value, seq.log_cnt, seq.seed, seq.is_cycled, seq.is_called;
     	 return next retval;
	  end loop;
	end loop;
end;

create or replace view dba_sequences as
select
     cast(usename as character varying(30 byte)) as SEQUENCE_OWNER,
	   cast(seqname as character varying(30 byte)) as SEQUENCE_NAME,
	   cast(min_value as NUMBER(38,0)) as MIN_VALUE,
	   cast(max_value as NUMBER(38,0)) as MAX_VALUE,
	   cast(increment_by as NUMBER(38,0)) as INCREMENT_BY,
	   cast(is_cycled as character varying(1 char)) as CYCLE_FLAG,
	   cast('t' as character varying(1 char)) as ORDER_FLAG,
	   cast(cache_value as NUMBER(38,0)) as CACHE_SIZE,
	   cast(last_value as NUMBER(38,0)) as LAST_NUMBER 
from get_sequences('') as 
(usename name,
seqname name,
last_value bigint,
increment_by bigint,
max_value bigint,
min_value bigint,
cache_value bigint,
log_cnt bigint,
seed bigint,
is_cycled boolean,
is_called boolean);

--all_sequencese
create or replace view all_sequences as
select     
     cast(usename as character varying(30 byte)) as SEQUENCE_OWNER,
	   cast(seqname as character varying(30 byte)) as SEQUENCE_NAME,
	   cast(min_value as NUMBER(38,0)) as MIN_VALUE,
	   cast(max_value as NUMBER(38,0)) as MAX_VALUE,
	   cast(increment_by as NUMBER(38,0)) as INCREMENT_BY,
	   cast(is_cycled as character varying(1 byte)) as CYCLE_FLAG,
	   cast('t' as character varying(1 byte)) as ORDER_FLAG,
	   cast(cache_value as NUMBER(38,0)) as CACHE_SIZE,
	   cast(last_value as NUMBER(38,0)) as LAST_NUMBER 
from get_sequences(' AND (has_table_privilege(c.oid,''SELECT'')
           or has_table_privilege(c.oid,''INSERT'')
           or has_table_privilege(c.oid,''UPDATE'')
           or has_table_privilege(c.oid,''DELETE'')
           or has_table_privilege(c.oid,''REFERENCES'')
           or has_table_privilege(c.oid,''TRIGGER''))')
as 
(usename name,
seqname name,
last_value bigint,
increment_by bigint,
max_value bigint,
min_value bigint,
cache_value bigint,
log_cnt bigint,
seed bigint,
is_cycled boolean,
is_called boolean);
           
 
--user_sequences
create or replace view user_sequences as
select      
     cast(usename as character varying(30 byte)) as SEQUENCE_OWNER,
	   cast(seqname as character varying(30 byte)) as SEQUENCE_NAME,
	   cast(min_value as NUMBER(38,0)) as MIN_VALUE,
	   cast(max_value as NUMBER(38,0)) as MAX_VALUE,
	   cast(increment_by as NUMBER(38,0)) as INCREMENT_BY,
	   cast(is_cycled as character varying(1 byte)) as CYCLE_FLAG,
	   cast('t' as character varying(1 byte)) as ORDER_FLAG,
	   cast(cache_value as NUMBER(38,0)) as CACHE_SIZE,
	   cast(last_value as NUMBER(38,0)) as LAST_NUMBER 
from get_sequences(' and usename = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE))')
as 
(usename name,
seqname name,
last_value bigint,
increment_by bigint,
max_value bigint,
min_value bigint,
cache_value bigint,
log_cnt bigint,
seed bigint,
is_cycled boolean,
is_called boolean);


REVOKE ALL ON sys_catalog.dba_sequences FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_sequences TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_sequences TO PUBLIC;  
   
-- Compatible with ORACLE, add DBA_CONSTRAINTS view  2015-6-30
CREATE OR REPLACE  VIEW DBA_CONSTRAINTS AS 
SELECT (sys_get_userbyid(c.relowner))::CHARACTER VARYING(63 BYTE) AS "OWNER" ,
(cs1.CONNAME)::CHARACTER VARYING(63 BYTE) AS CONSTRAINT_NAME,
(
   	CASE WHEN (cs1.CONTYPE = 'c'::"CHAR") THEN 'C'::TEXT 
  	     WHEN (cs1.CONTYPE = 'p'::"CHAR") THEN 'P'::TEXT 
         WHEN (cs1.CONTYPE = 'u'::"CHAR") THEN 'U'::TEXT 
         WHEN (cs1.CONTYPE = 'f'::"CHAR") THEN 'R'::TEXT ELSE NULL::TEXT 
    END
)::CHARACTER VARYING(1 BYTE) AS CONSTRAINT_TYPE,
(C.RELNAME)::CHARACTER VARYING(63 BYTE) AS TABLE_NAME,
cs1.CONSRC AS SEARCH_CONDITION,
SYS_GET_USERBYID(c_ref.RELOWNER)::CHARACTER VARYING(63 BYTE) AS R_OWNER,
(
	cs2.conname::CHARACTER VARYING(63 BYTE) 
) AS R_CONSTRAINT_NAME,
  (
  	CASE WHEN (cs1.CONFDELTYPE = 'a'::"CHAR") THEN 'NO ACTION'::TEXT 
      	WHEN (cs1.CONFDELTYPE = 'c'::"CHAR") THEN 'CASCADE'::TEXT 
      	WHEN (cs1.CONFDELTYPE = 'r'::"CHAR") THEN 'RESTRICT'::TEXT 
      	WHEN (cs1.CONFDELTYPE = 'n'::"CHAR") THEN 'SET NULL'::TEXT 
      	WHEN (cs1.CONFDELTYPE = 'd'::"CHAR") THEN 'SET DEFAULT'::TEXT 
      	ELSE NULL::TEXT END
  )::CHARACTER VARYING(9 BYTE) AS DELETE_RULE,
(
    CASE WHEN (cs1.CONTYPE = 'f'::"CHAR") THEN
    (
        SELECT DISTINCT (CASE WHEN (TRG.TGENABLED=true) THEN 'ENABLED'::TEXT
                                ELSE 'DISABLED'::TEXT END ) 
        FROM SYS_TRIGGER TRG
        WHERE  TRG.TGCONSTRNAME = cs1.CONNAME 
        AND TRG.TGRELID = cs1.CONRELID
    )
      WHEN (cs1.CONTYPE = 'p'::"CHAR" OR cs1.CONTYPE = 'u'::"CHAR") THEN
      (
	         SELECT (CASE WHEN (IND.INDUNUSABLE=false) THEN 'ENABLED'::TEXT
	                       ELSE  'DISABLED'::TEXT END ) 
           	  FROM SYS_INDEX IND,SYS_DEPEND DEP
	         WHERE DEP.REFOBJID=cs1.OID
           	  AND DEP.CLASSID='SYS_CLASS'::REGCLASS
	         AND EXISTS (SELECT * FROM SYS_CLASS WHERE OID=DEP.OBJID AND RELKIND='i')
	         AND IND.INDEXRELID=DEP.OBJID
      )
      WHEN (cs1.CONTYPE = 'c'::"CHAR") THEN 
	  (
			CASE WHEN (cs1.CONSTATUS = 'f') THEN 'DISABLE'::TEXT 
			ELSE 'ENABLE'::TEXT END	
	  )
	  END
)::CHARACTER VARYING(8 BYTE) AS "STATUS", 
  (
     	CASE WHEN (cs1.CONDEFERRABLE = false) THEN 'NOT DEFERRABLE'::TEXT 
     	ELSE 'DEFERRABLE'::TEXT END
   )::CHARACTER VARYING(14 CHAR) AS "DEFERRABLE",
  (
     	CASE WHEN (cs1.CONDEFERRED = false) THEN 'IMMEDIATE'::TEXT 
     	ELSE 'DEFERRED'::TEXT END
  )::CHARACTER VARYING(9 CHAR) AS "DEFERRED",
(
  CASE WHEN (cs1.CONVALIDATE ='t') THEN 'VALIDATED'::TEXT
       WHEN (cs1.CONVALIDATE ='f') THEN 'NOVALIDATED'::TEXT
      ELSE NULL::TEXT END
)::CHARACTER VARYING(13 BYTE) AS "VALIDATED", 
  'USER NAME'::CHARACTER VARYING(14 BYTE) AS GENERATED,
  NULL::CHARACTER VARYING(3 CHAR) AS BAD, 
  NULL::CHARACTER VARYING(4 CHAR) AS RELY, 
  NULL::TIMESTAMP(0) WITHOUT TIME ZONE AS LAST_CHANGE,
(	
	CASE WHEN (cs1.CONTYPE = 'p' OR cs1.CONTYPE = 'u') THEN
		(
			SELECT sys_get_userbyid(t.relowner) FROM SYS_INDEX IND, SYS_CLASS T, SYS_DEPEND DEP
			WHERE INDEXRELID = DEP.OBJID 
			AND DEP.REFOBJID = cs1.OID
			AND T.OID = IND.INDEXRELID
		)
	ELSE
		NULL
	END
 )::CHARACTER VARYING(63 BYTE) AS "INDEX_OWNER",
 (	
	CASE WHEN (cs1.CONTYPE = 'p' OR cs1.CONTYPE = 'u') THEN
		(
			SELECT T.RELNAME FROM SYS_INDEX IND ,SYS_CLASS T,SYS_DEPEND DEP
			WHERE INDEXRELID = DEP.OBJID 
			AND DEP.REFOBJID = cs1.OID
			AND T.OID = IND.INDEXRELID
		)
	ELSE
		NULL
	END
 )::CHARACTER VARYING(63 BYTE) AS "INDEX_NAME",
 NULL::CHARACTER VARYING(7 BYTE) AS INVALID, 
  NULL::CHARACTER VARYING(14 BYTE) AS VIEW_RELATED
from( sys_constraint cs1 left outer join sys_constraint cs2 on 
		(
			/* bug#16909: bad r_constraint_name value. */
			cs1.confrelid = cs2.conrelid and 
			(cs2.contype = 'u' or cs2.contype = 'p') and  /* show only keys which can keep rows unique. */
			cs1.contype = 'f' and /* only foreign key make r_constraint_name not null */
			cs2.conkey = cs1.confkey	/* Does cs2.conname make the foreign key(cs1.conname) values unique? */
		)
	)
	-- The outer join bellowing is used to get the referenced relation's information.
	left outer join sys_class c_ref on cs1.confrelid = c_ref.oid
	,
	sys_class c
WHERE cs1.CONRELID = C.OID;

REVOKE ALL ON sys_catalog.dba_constraints FROM PUBLIC;

create or replace function get_trigger_column(relid oid, tgattr int[])
returns text as
declare 
retval text;
ndims   int;
i   int;
colname text;
begin
   retval := '';
  ndims = array_length(tgattr, 1);
  if (ndims is not null) then

  for i in 1.. ndims loop
     select attname into colname from sys_catalog.sys_attribute where attrelid = relid and attnum = tgattr[i-1];
     retval := retval || colname;
     if (i != ndims) then
        retval := retval || ',';
     end if;
  end loop;
  end if;
  return retval;
end;


--dba_triggers
create or replace view dba_triggers as
select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(t.tgname as character varying(30 byte)) as TRIGGER_NAME,
	cast((case (t.tgtype&66)
	when 2 then(case t.tgtype&1 when 0 then 'BEFORE STATEMENT' else 'BEFORE EACH ROW' end) 
	when 0 then(case t.tgtype&1 when 0 then 'AFTER STATEMENT' else 'AFTER EACH ROW' end)
	end) as character varying(16 byte)) as TRIGGER_TYPE,
	cast((case (t.tgtype&28) 
	when 4 then 'INSERT'
	when 8 then 'DELETE'
	when 16 then 'UPDATE'
	when 12 then 'INSERT DELETE'
	when 20 then 'INSERT UPDATE'
	when 24 then 'DELETE UPDATE'
	when 28 then 'INSERT DELETE UPDATE'
	end) as character varying(216 byte)) as TRIGGERING_EVENT,
	cast(a.usename as character varying(30 byte)) as TABLE_OWNER,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
	cast(get_trigger_column(c.oid, cast(t.tgattr as int[])) as character varying(4000 char)) as COLUMN_NAME,
	cast ((case t.tgenabled 
		when 't' then 'ENABLED'
		when 'f' then 'DISABLED'
	end) as character varying(8 byte)) as STATUS,
	cast((SYS_GET_TRIGGERDEF(t.OID)) as text) as TRIGGER_BODY
	from sys_catalog.sys_trigger t, sys_catalog.sys_class c, sys_catalog.sys_user a
	where t.tgrelid = c.oid and c.relowner = a.usesysid;


--all_triggers
create or replace view all_triggers as
select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(t.tgname as character varying(30 byte)) as TRIGGER_NAME,
	cast((case (t.tgtype&66)
	when 2 then(case t.tgtype&1 when 0 then 'BEFORE STATEMENT' else 'BEFORE EACH ROW' end) 
	when 0 then(case t.tgtype&1 when 0 then 'AFTER STATEMENT' else 'AFTER EACH ROW' end)
	end) as character varying(16 byte)) as TRIGGER_TYPE,
	cast((case (t.tgtype&28) 
	when 4 then 'INSERT'
	when 8 then 'DELETE'
	when 16 then 'UPDATE'
	when 12 then 'INSERT DELETE'
	when 20 then 'INSERT UPDATE'
	when 24 then 'DELETE UPDATE'
	when 28 then 'INSERT DELETE UPDATE'
	end) as character varying(216 byte)) as TRIGGERING_EVENT,
	cast(a.usename as character varying(30 byte)) as TABLE_OWNER,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
	cast(get_trigger_column(c.oid, cast(t.tgattr as int[])) as character varying(4000 char)) as COLUMN_NAME,
	cast ((case t.tgenabled 
		when 't' then 'ENABLED'
		when 'f' then 'DISABLED'
	end) as character varying(8 byte)) as STATUS,
	cast((SYS_GET_TRIGGERDEF(t.OID)) as text) as TRIGGER_BODY
	from sys_catalog.sys_trigger t, sys_catalog.sys_class c, sys_catalog.sys_user a
	where t.tgrelid = c.oid and c.relowner = a.usesysid 
	and (has_table_privilege(c.oid,'SELECT')
           or has_table_privilege(c.oid,'INSERT')
           or has_table_privilege(c.oid,'UPDATE')
           or has_table_privilege(c.oid,'DELETE')
           or has_table_privilege(c.oid,'REFERENCES')
           or has_table_privilege(c.oid,'TRIGGER'));

--user_triggers
create or replace view user_triggers as
select 
	cast(t.tgname as character varying(30 byte)) as TRIGGER_NAME,
	cast((case (t.tgtype&66)
	when 2 then(case t.tgtype&1 when 0 then 'BEFORE STATEMENT' else 'BEFORE EACH ROW' end) 
	when 0 then(case t.tgtype&1 when 0 then 'AFTER STATEMENT' else 'AFTER EACH ROW' end)
	end) as character varying(16 byte)) as TRIGGER_TYPE,
	cast((case (t.tgtype&28) 
	when 4 then 'INSERT'
	when 8 then 'DELETE'
	when 16 then 'UPDATE'
	when 12 then 'INSERT DELETE'
	when 20 then 'INSERT UPDATE'
	when 24 then 'DELETE UPDATE'
	when 28 then 'INSERT DELETE UPDATE'
	end) as character varying(216 byte)) as TRIGGERING_EVENT,
	cast(a.usename as character varying(30 byte)) as TABLE_OWNER,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
	cast(get_trigger_column(c.oid, cast(t.tgattr as int[])) as character varying(4000 char)) as COLUMN_NAME,
	cast ((case t.tgenabled 
		when 't' then 'ENABLED'
		when 'f' then 'DISABLED'
	end) as character varying(8 byte)) as STATUS,
	cast((SYS_GET_TRIGGERDEF(t.OID)) as text) as TRIGGER_BODY
	from sys_catalog.sys_trigger t, sys_catalog.sys_class c, sys_catalog.sys_user a
	where t.tgrelid = c.oid and c.relowner = a.usesysid and a.usename = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE));


REVOKE ALL ON sys_catalog.dba_triggers FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_triggers TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_triggers TO PUBLIC;  

--dba_source
create or replace view dba_source as
(select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(p.proname as character varying(30 byte)) as NAME,
	cast((case p.protype when 'p' then 'PROCEDURE' when 'f' then 'FUNCTION' end)as character varying(12 byte)) as TYPE,
	cast(p.prosrc as character varying(4000 char)) as TEXT
	from sys_catalog.sys_proc p, sys_catalog.sys_user a
	where p.proowner = a.usesysid)
UNION ALL
(select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(p.pkgname as character varying(30 byte)) as NAME,
	cast((case p.pkgtype  when 's' THEN 'PACKAGE' when 'b' THEN 'PACKAGE BODY' end )as character varying(12 byte)) as TYPE,
	cast(p.pkgsrc as character varying(4000 char)) as TEXT
	from sys_catalog.sys_package p, sys_catalog.sys_user a
	where p.pkgowner = a.usesysid)
UNION ALL
(select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(t.tgname as character varying(30 byte)) as NAME,
	cast( 'TRIGGER' as character varying(12 byte)) as TYPE,
	cast(SYS_GET_TRIGGERDEF(t.OID) as character varying(4000 char)) as TEXT
	from  sys_catalog.sys_trigger t, sys_catalog.sys_user a, sys_catalog.sys_proc p
	where t.tgfoid = p.oid and p.proowner = a.usesysid 
);


create or replace view all_source as
(select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(p.proname as character varying(30 byte)) as NAME,
	cast((case p.protype when 'p' then 'PROCEDURE' when 'f' then 'FUNCTION' end)as character varying(12 byte)) as TYPE,
	cast(p.prosrc as character varying(4000 char)) as TEXT
	from sys_catalog.sys_proc p, sys_catalog.sys_user a
	where p.proowner = a.usesysid and 
    (a.usename = CAST(current_user AS VARCHAR(63 BYTE))
     or has_function_privilege(p.oid, 'EXECUTE'))
)     
UNION ALL
(select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(p.pkgname as character varying(30 byte)) as NAME,
	cast((case p.pkgtype  when 's' THEN 'PACKAGE' when 'b' THEN 'PACKAGE BODY' end )as character varying(12 byte)) as TYPE,
	cast(p.pkgsrc as character varying(4000 char)) as TEXT
	from sys_catalog.sys_package p, sys_catalog.sys_user a
	where p.pkgowner = a.usesysid and
	      (a.usename = CAST(current_user AS VARCHAR(63 BYTE))
         or has_package_privilege(p.oid, 'EXECUTE'))
)
UNION ALL
(select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(t.tgname as character varying(30 byte)) as NAME,
	cast( 'TRIGGER' as character varying(12 byte)) as TYPE,
	cast(SYS_GET_TRIGGERDEF(t.OID) as character varying(4000 char)) as TEXT
	from  sys_catalog.sys_trigger t, sys_catalog.sys_user a, sys_catalog.sys_proc p, sys_catalog.sys_class c
	where t.tgfoid = p.oid and p.proowner = a.usesysid and t.tgrelid = c.oid
	and (has_table_privilege(c.oid,'SELECT')
           or has_table_privilege(c.oid,'INSERT')
           or has_table_privilege(c.oid,'UPDATE')
           or has_table_privilege(c.oid,'DELETE')
           or has_table_privilege(c.oid,'REFERENCES')
           or has_table_privilege(c.oid,'TRIGGER'))
);

--user_source
create or replace view user_source as
select * from sys_catalog.dba_source where owner = CAST("CURRENT_USER"() AS CHARACTER VARYING(30 BYTE));


REVOKE ALL ON sys_catalog.dba_source FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_source TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_source TO PUBLIC;  

--dba_tablespace
create or replace view dba_tablespace as
select 
	cast(ts.spcname as character varying(30 byte)) as TABLESPACE_NAME,
	cast(8 as NUMBER )as INITIALEXTENT,
	cast(8 as NUMBER )as NEXT_EXTENT,
	cast(8 as NUMBER) as MIN_EXTENTS,
	cast(NULl as NUMBER ) as MAX_EXTENTS,
	cast(NULL as NUMBER )as PCT_INCREASE,
	cast(8 as NUMBER ) as MIN_EXTLEN,
	cast((case ts.status
	when 't' then 'ONLINE'
	when 'f' then 'OFFLINE'
	end) as character varying(9 byte))as STATUS,
	cast('PERMANENT' as character varying(9 byte)) as CONTENTS,
	cast('LOGGING' as character varying(9 byte)) as LOGGING,
	cast('LOCAL'as character varying(10 byte)) as EXTENT_MANAGEMENT,
	cast((case ts.spcname
	when 'CATALOG' then 'SYSTEM' else 'USER'
	end) as character varying(9 byte)) as ALLOCATION_TYPE,
	cast('NO' as character varying(3 byte)) as PLUGGED_IN
	from sys_catalog.sys_tablespace ts;

--dba_tablespaces	
create or replace view dba_tablespaces as
select * from dba_tablespace;

	
--user_tablespace
create or replace view user_tablespace as
select 
	cast(ts.spcname as character varying(30 byte)) as TABLESPACE_NAME,
	cast(8 as NUMBER)as INITIALEXTENT,
	cast(8 as NUMBER)as NEXT_EXTENT,
	cast(8 as NUMBER) as MIN_EXTENTS,
	cast(NULL as NUMBER) 	as MAX_EXTENTS,
	cast(NULL as NUMBER)as PCT_INCREASE,
	cast(8 as NUMBER) as MIN_EXTLEN,
	cast((case ts.status
	when 't' then 'ONLINE'
	when 'f' then 'OFFLINE'
	end) as character varying(9 byte))as STATUS,
	cast('PERMANENT' as character varying(9 byte)) as CONTENTS,
	cast('LOGGING' as character varying(9 byte)) as LOGGING,
	cast('LOCAL'as character varying(10 byte)) as EXTENT_MANAGEMENT,
	cast((case ts.spcname
	when 'CATALOG' then 'SYSTEM' else 'USER'
	end) as character varying(9 byte)) as ALLOCATION_TYPE
from sys_catalog.sys_tablespace ts, sys_catalog.sys_user a where ts.spcowner = a.usesysid and a.usename = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE));

--user_tablespaces
create or replace view user_tablespaces as
select * from user_tablespace;

REVOKE ALL ON sys_catalog.dba_tablespace FROM PUBLIC;
REVOKE ALL ON sys_catalog.dba_tablespaces FROM PUBLIC;
GRANT SELECT ON sys_catalog.user_tablespace TO PUBLIC;  
GRANT SELECT ON sys_catalog.user_tablespaces TO PUBLIC; 
 
--all_users
create or replace view all_users as
select cast(usename as varchar(30 byte)) as username, 
       cast(cast(usesysid as bigint) as number(38,0)) as user_id, 
       cast(null as date) as CREATED
from sys_catalog.sys_user 
where has_database_privilege(current_database(), 'CONNECT');

--user_users
create or replace view user_users as
select 
cast(usename as varchar(30 byte)) as USERNAME,
cast(cast (usesysid as bigint) as number(38,0)) as USER_ID,
CAST(CASE WHEN CURRENT_TIMESTAMP <= ISNULL(VALUNTIL, CURRENT_TIMESTAMP) THEN 'OPEN' ELSE 'EXPIRED' END AS VARCHAR(32 BYTE)) as ACCOUNT_STATUS,
CAST(NULL AS DATE) as LOCK_DATE, 
CAST(VALUNTIL AS DATE) as EXPIRY_DATE,
CAST('SYSTEM' AS VARCHAR(30 BYTE)) as DEFAULT_TABLESPACE,
CAST(NULL AS VARCHAR(30 BYTE)) as TEMPORARY_TABLESPACE, 
CAST(NULL AS DATE) as CREATED, 
CAST(NULL AS VARCHAR(30 BYTE)) as INITIAL_RSRC_CONSUMER_GROUP,
CAST(NULL AS VARCHAR(30 BYTE)) as EXTERNAL_NAME
FROM sys_catalog.sys_user
WHERE sys_catalog.sys_user.usename = CURRENT_USER;

GRANT SELECT ON sys_catalog.all_users TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_users TO PUBLIC;  

--dba_tab_privs
create or replace view dba_tab_privs as
SELECT     CAST(grantee.rolname AS character varying(30 byte)) AS grantee,
           CAST(u_owner.usename AS character varying(30 byte)) AS owner,
           CAST(c.relname AS character varying(30 byte)) AS table_name,
           CAST(u_grantor.usename AS character varying(30 byte)) AS grantor,
           CAST(pr.type AS character varying(40 char)) AS privilege,
           CAST(
             CASE WHEN aclcontains(c.relacl,
                                   makeaclitem(grantee.oid, u_grantor.usesysid, pr.type, true))
                  THEN 'YES' ELSE 'NO' END AS character varying(3 byte)) AS grantable
FROM     sys_catalog.sys_class c,
         sys_catalog.sys_user u_owner,
         sys_catalog.sys_user u_grantor,
         ( SELECT usesysid, usename FROM sys_catalog.sys_user
           UNION ALL
           SELECT 0::oid,'PUBLIC'
         ) AS grantee (oid, rolname),
         (SELECT 'SELECT' UNION ALL
          SELECT 'INSERT' UNION ALL
          SELECT 'UPDATE' UNION ALL
          SELECT 'REFERENCES') AS pr (type)
where     c.relowner=u_owner.usesysid
          AND c.relkind IN ('r', 'v') 
          AND c.relparttyp != 'p'
          AND aclcontains(c.relacl,
          makeaclitem(grantee.oid, u_grantor.usesysid, pr.type, false));


--all_tab_privs
create or replace view all_tab_privs as
SELECT   dba_tab_privs.*
FROM sys_catalog.dba_tab_privs
WHERE     grantee='PUBLIC'
         OR grantor=cast(current_user as varchar2(30 byte))
	       OR grantee=cast(current_user as varchar2(30 byte))
		     OR owner=cast(current_user as varchar2(30 byte))
          OR grantee in (select r.rolname from sys_authid r,sys_authid u where u.roldefault=r.oid
                         UNION ALL
                         select cast(current_role as varchar2(30 byte)));

--user_tab_privs
create or replace view user_tab_privs as
SELECT dba_tab_privs.* FROM sys_catalog.dba_tab_privs
WHERE grantor=cast(current_user as varchar2(30 byte))
	      OR grantee=cast(current_user as varchar2(30 byte))
		  OR owner=cast(current_user as varchar2(30 byte));

REVOKE ALL ON sys_catalog.dba_tab_privs FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_tab_privs TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_tab_privs TO PUBLIC;  


--dba_cons_columns
create or replace view dba_cons_columns as
select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(ct.conname as character varying(30 byte)) as CONSTRAINT_NAME,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
	cast(attr.attname as character varying(4000 char)) as COLUMN_NAME,
	cast(attr.attnum as number) as POSITION
	from sys_catalog.sys_constraint ct, sys_catalog.sys_class c, sys_catalog.sys_user a, sys_catalog.sys_attribute attr
	where ct.conrelid = c.oid and c.relowner = a.usesysid 
	and attr.attrelid = c.oid and ARRAY[attr.attnum] <@ ct.conkey;

--all_cons_columns
create or replace view all_cons_columns as
select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(ct.conname as character varying(30 byte)) as CONSTRAINT_NAME,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
	cast(attr.attname as character varying(4000 char)) as COLUMN_NAME,
	cast(attr.attnum as number) as POSITION
	from sys_catalog.sys_constraint ct, sys_catalog.sys_class c, sys_catalog.sys_user a, sys_catalog.sys_attribute attr
	where ct.conrelid = c.oid and c.relowner = a.usesysid 
	and attr.attrelid = c.oid and ARRAY[attr.attnum] <@ ct.conkey
	and (has_table_privilege(c.oid,'SELECT')
           or has_table_privilege(c.oid,'INSERT')
           or has_table_privilege(c.oid,'UPDATE')
           or has_table_privilege(c.oid,'DELETE')
           or has_table_privilege(c.oid,'REFERENCES')
           or has_table_privilege(c.oid,'TRIGGER'));
--user_cons_columns
create or replace view user_cons_columns as
select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(ct.conname as character varying(30 byte)) as CONSTRAINT_NAME,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
	cast(attr.attname as character varying(4000 char)) as COLUMN_NAME,
	cast(attr.attnum as number) as POSITION
	from sys_catalog.sys_constraint ct, sys_catalog.sys_class c, sys_catalog.sys_user a, sys_catalog.sys_attribute attr
	where ct.conrelid = c.oid and c.relowner = a.usesysid 
	and attr.attrelid = c.oid and ARRAY[attr.attnum] <@ ct.conkey
	and a.usename = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE));

REVOKE ALL ON sys_catalog.dba_cons_columns FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_cons_columns TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_cons_columns TO PUBLIC;  

--dba_data_file
create or replace function getBlockSize()
returns int
immutable
as
 res int;
begin
   select cast (setting as int) into res from sys_settings where name='block_size';
   return res;
end;

create or replace view dba_data_files 
AS
SELECT
cast(df.filename as varchar2(513 BYTE)) as file_name,
cast(cast(df.fileid as bigint) as number(38,0)) as file_id,
cast(df.spcname as varchar2(30 BYTE)) as tablespace_name,	  
cast(df.currentblocks * cast(getBlockSize() as number(38,0)) as number(38,0)) as bytes,
cast(df.currentblocks as number(38)) as blocks,	  
cast('AVAILABLE' as varchar2(9 BYTE)) as status,
cast(cast(df.fileid as bigint) as number(38)) as relative_fno,
cast ((case when df.initsize < df.maxsize then 'YES'
      else 'NO' end) as  varchar2(3 BYTE))
      as autoextensible,
cast((cast((1024*1024) as number(38,0))*df.maxsize) as number(38,0)) as maxbytes,
cast(((1024*1024)/getBlockSize())*df.maxsize as number(38)) as maxblocks,
cast(cast(df.currentblocks as number(38,0))*df.growth/100 as number(38,0)) as increment_by, 
cast(cast(getBlockSize() as number(38,0))* (df.currentblocks
											-(((df.currentblocks-2)/(8*(getBlockSize()-64)*8+1))+1) 
											-(((df.currentblocks-1)/((getBlockSize()-64)+1))+1)     
											-(((df.currentblocks-3)/(8*(getBlockSize()-64)*8+1))+1) 
											-(((df.currentblocks-4)/(8*(getBlockSize()-64)*8+1))+1) 
											-(((df.currentblocks-5)/(8*(getBlockSize()-64)*8+1))+1) 
										   ) as number(38,0)) as user_bytes,
cast((df.currentblocks
	-(((df.currentblocks-2)/(8*(getBlockSize()-64)*8+1))+1) 
	-(((df.currentblocks-1)/((getBlockSize()-64)+1))+1)    
	-(((df.currentblocks-3)/(8*(getBlockSize()-64)*8+1))+1) 
	-(((df.currentblocks-4)/(8*(getBlockSize()-64)*8+1))+1) 
	-(((df.currentblocks-5)/(8*(getBlockSize()-64)*8+1))+1)  
	) as number(38,0)) as user_blocks,
cast(decode(df.status,true,'ONLINE',false,'OFFLINE') as varchar2(7 BYTE)) as online_staus 
FROM
sys_datafiles df;

REVOKE ALL ON sys_catalog.dba_data_files FROM PUBLIC;

--dba_roles
create or replace view dba_roles as
select 
	cast(a.rolname as character varying(30 byte)) as role,
	cast(decode(a.rolpassword,null,'NO','YES') as character varying(8 byte)) as PASSWORD_REQUIRED
    FROM sys_catalog.sys_authid a
    where a.roltype='R';

REVOKE ALL ON sys_catalog.dba_roles FROM PUBLIC;

create or replace function is_default_role(role oid )
returns boolean as
declare
begin
   perform 1 from sys_authid where roldefault = oid;
   if SQL%found then
      return true;
   else
       return false;
   end if; 
end;

--dba_role_privs
create or replace view dba_role_privs as
SELECT cast(SAI.ROLNAME as character varying(30 byte)) AS GRANTEE,
       cast(SA.ROLNAME as character varying(30 byte))AS GRANTED_ROLE,
       cast(case SAM.ADMIN_OPTION when true then 'YES' else 'NO' end as character varying(3 byte)) AS ADMIN_OPTION,
       cast(case is_default_role(SAI.oid) when true THEN 'YES'
            ELSE 'NO'
            END as character varying(3 byte)) AS DEFAULT_ROLE
FROM sys_catalog.SYS_AUTHID SA, sys_catalog.SYS_AUTHID SAI, sys_catalog.SYS_AUTH_MEMBERS SAM
WHERE SA.OID=SAM.grantor
      AND SAI.OID=SAM.ROLEID;


--user_role_privs
create or replace view user_role_privs as
SELECT cast(SAI.ROLNAME as character varying(30 byte)) AS GRANTEE,
       cast(SA.ROLNAME as character varying(30 byte))AS GRANTED_ROLE,
       cast(case SAM.ADMIN_OPTION when true then 'YES' else 'NO' end as character varying(3 byte)) AS ADMIN_OPTION,
       cast(case is_default_role(SAI.oid) when true THEN 'YES'
            ELSE 'NO'
            END as character varying(3 byte)) AS DEFAULT_ROLE
FROM sys_catalog.SYS_roles SA, sys_catalog.sys_roles SAI, sys_catalog.SYS_AUTH_MEMBERS SAM
WHERE SA.OID=SAM.grantor
      AND SAI.OID=SAM.ROLEID
	  and SAI.rolname = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE));

REVOKE ALL ON sys_catalog.dba_role_privs FROM PUBLIC;
GRANT SELECT ON sys_catalog.user_role_privs TO PUBLIC;  

--dba_tab_comments
create or replace view dba_tab_comments as
select cast(au.usename as character varying(30 byte)) as OWNER, 
       cast(c.relname as character varying(30 byte)) as TABLE_NAME,
       cast(decode(c.relkind,'r','TABLE','v','VIEW','TABLE') as character varying(11 byte)) as TABLE_TYPE,
       cast(d.DESCRIPTION as character varying(4000 char)) as COMMENTS
FROM  sys_catalog.SYS_CLASS C, sys_catalog.SYS_DESCRIPTION d, sys_catalog.SYS_user au
where c.oid = d.objoid and d.classoid = 1259 
      and d.objsubid=0
      and c.relowner=au.usesysid
      and c.relkind in ('r','v');

--all_tab_comments
create or replace view all_tab_comments as
select cast(au.usename as character varying(30 byte)) as OWNER, 
       cast(c.relname as character varying(30 byte)) as TABLE_NAME,
       cast(decode(c.relkind,'r','TABLE','v','VIEW','TABLE') as character varying(11 byte)) as TABLE_TYPE,
       cast(d.DESCRIPTION as character varying(4000 char)) as COMMENTS
FROM  sys_catalog.SYS_CLASS C, sys_catalog.SYS_DESCRIPTION d, sys_catalog.SYS_user au
where c.oid = d.objoid and d.classoid = 1259 
      and d.objsubid=0
      and c.relowner=au.usesysid
      and c.relkind in ('r','v')
	  and (has_table_privilege(c.oid,'SELECT')
           or has_table_privilege(c.oid,'INSERT')
           or has_table_privilege(c.oid,'UPDATE')
           or has_table_privilege(c.oid,'DELETE')
           or has_table_privilege(c.oid,'REFERENCES')
           or has_table_privilege(c.oid,'TRIGGER'));
--user_tab_comments
create or replace view user_tab_comments as
select cast(c.relname as character varying(30 byte)) as TABLE_NAME,
       cast(decode(c.relkind,'r','TABLE','v','VIEW','TABLE') as character varying(11 byte)) as TABLE_TYPE,
       cast(d.DESCRIPTION as character varying(4000 char)) as COMMENTS
FROM  sys_catalog.SYS_CLASS C, sys_catalog.SYS_DESCRIPTION d, sys_catalog.SYS_USER au
where c.oid = d.objoid and d.classoid = 1259 
      and d.objsubid=0
      and c.relowner=au.usesysid
      and c.relkind in ('r','v')
	  and au.usename = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE));

REVOKE ALL ON sys_catalog.dba_tab_comments FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_tab_comments TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_tab_comments TO PUBLIC;  


--dba_col_comments
create or replace view dba_col_comments as
select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
    cast(at.ATTNAME as character varying(30 byte)) AS COLUMN_NAME,
    cast(d.DESCRIPTION as character varying(4000 char)) AS COMMENTS
FROM SYS_CATALOG.SYS_user a, SYS_CATALOG.SYS_CLASS c, SYS_CATALOG.SYS_ATTRIBUTE at left join SYS_CATALOG.SYS_DESCRIPTION d on (
   d.classoid = 1259 and d.objoid=at.attrelid and at.attnum=d.objsubid)
WHERE at.attrelid = c.oid
      and at.attnum > 0 and at.attisdropped = false
      and c.relkind in ('r','v')
	  and c.relowner = a.usesysid;
--all_col_comments
create or replace view all_col_comments as
select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
    cast(at.ATTNAME as character varying(30 byte)) AS COLUMN_NAME,
    cast(d.DESCRIPTION as character varying(4000 char)) AS COMMENTS
	FROM SYS_CATALOG.SYS_USER a, SYS_CATALOG.SYS_CLASS c, SYS_CATALOG.SYS_ATTRIBUTE at left join SYS_CATALOG.SYS_DESCRIPTION d on ( d.classoid = 1259 
      and at.attnum=d.objsubid and d.objoid=at.attrelid )
	WHERE at.attrelid = c.oid
      and c.relkind in ('r','v')
	  and c.relowner = a.usesysid
	  and at.attnum > 0 and at.attisdropped = false
	  and (has_table_privilege(c.oid,'SELECT')
           or has_table_privilege(c.oid,'INSERT')
           or has_table_privilege(c.oid,'UPDATE')
           or has_table_privilege(c.oid,'DELETE')
           or has_table_privilege(c.oid,'REFERENCES')
           or has_table_privilege(c.oid,'TRIGGER'));
--user_col_comments
create or replace view user_col_comments as
select 
	cast(a.usename as character varying(30 byte)) as OWNER,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
    cast(at.ATTNAME as character varying(30 byte)) AS COLUMN_NAME,
    cast(d.DESCRIPTION as character varying(4000 char)) AS COMMENTS
FROM SYS_CATALOG.SYS_USER a, SYS_CATALOG.SYS_CLASS c, SYS_CATALOG.SYS_ATTRIBUTE at left join SYS_CATALOG.SYS_DESCRIPTION d on (
    d.classoid = 1259 and d.objoid=at.attrelid and at.attnum=d.objsubid)
	WHERE at.attrelid = c.oid 
      and c.relkind in ('r','v')
      and at.attnum > 0 and at.attisdropped = false
	  and c.relowner = a.usesysid
	  and a.usename = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE));
	  
	  
REVOKE ALL ON sys_catalog.dba_col_comments FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_col_comments TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_col_comments TO PUBLIC;  	  
	  
--dba_part_tables
create or replace view dba_part_tables as
SELECT 
	   cast(SA.USENAME as character varying(30 byte)) AS OWNER,
       cast(SC.RELNAME as character varying(30 byte)) AS TABLE_NAME,
       cast(DECODE(SPC.PRELMETHOD,'r','RANGE','l','LIST','h','HASH','c','COLUMN',NULL) as character varying(7 byte)) AS PARTITIONING_TYPE,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN DECODE((SELECT PRELMETHOD FROM SYS_PARTCLASS WHERE PRELID=C.OID),
                         'r','RANGE',
                         'l','LIST',
                         'h','HASH',
                         'c','COLUMN',
                         NULL)
            ELSE 'NONE'
            END as character varying(7 byte)) AS SUBPARTITIONING_TYPE,
       cast(SPC.PRELNPARTS as number) AS PARTITION_COUNT,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN (SELECT PRELNPARTS FROM SYS_PARTCLASS WHERE PRELID=C.OID)
            ELSE 0
            END as number) AS DEF_SUBPARTITION_COUNT,
       cast(SPC.PRELNKEYS as number) AS PARTITIONING_KEY_COUNT,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN (SELECT PRELNKEYS FROM SYS_PARTCLASS WHERE PRELID=C.OID)
            ELSE 0
            END as number) AS SUBPARTITIONING_KEY_COUNT,
       cast('VALID' as character varying(8 byte)) AS STATUS,
       cast('SYSTEM' as character varying(30 byte)) AS DEF_TABLESPACE_NAME,
	   cast(NULL as number) AS DEF_PCT_FREE,
	   cast(NULL as number) AS DEF_PCT_USED,
	   cast(NULL as number) AS DEF_INI_TRANS,
	   cast(NULL as number) AS DEF_MAX_TRANS,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_INITIAL_EXTENT,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_NEXT_EXTENT,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_MIN_EXTENTS,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_MAX_EXTENTS,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_PCT_INCREASE,
	   cast(NULL as number) AS DEF_FREELISTS,
	   cast(NULL as number) AS DEF_FREELIST_GROUPS,
	   cast('YES' as character varying(7 byte)) as DEF_LOGGING,
	   cast('DISABLED' as character varying(8 byte)) as DEF_COMPRESSION,
	   cast('DEFAULT' as character varying(7 byte)) as DEF_BUFFER_POOL
FROM SYS_CATALOG.SYS_USER SA,
     SYS_CATALOG.SYS_CLASS SC,
     SYS_CATALOG.SYS_PARTCLASS SPC, 
     SYS_CATALOG.SYS_CLASS C,
     SYS_CATALOG.SYS_PARTITION SP
WHERE SA.USESYSID=SC.RELOWNER
      AND SC.RELPARTTYP='t'
      AND C.RELPARTTYP='p'
      AND SC.OID=SPC.PRELID
      AND C.OID=SP.PARTITIONRELID
      AND SPC.PRELID=SP.PARTRELID;
--all_part_tables
create or replace view all_part_tables as
SELECT 
	   cast(SA.USENAME as character varying(30 byte)) AS OWNER,
       cast(SC.RELNAME as character varying(30 byte)) AS TABLE_NAME,
       cast(DECODE(SPC.PRELMETHOD,'r','RANGE','l','LIST','h','HASH','c','COLUMN',NULL) as character varying(7 byte)) AS PARTITIONING_TYPE,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN DECODE((SELECT PRELMETHOD FROM SYS_PARTCLASS WHERE PRELID=C.OID),
                         'r','RANGE',
                         'l','LIST',
                         'h','HASH',
                         'c','COLUMN',
                         NULL)
            ELSE 'NONE'
            END as character varying(7 byte)) AS SUBPARTITIONING_TYPE,
       cast(SPC.PRELNPARTS as number) AS PARTITION_COUNT,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN (SELECT PRELNPARTS FROM SYS_PARTCLASS WHERE PRELID=C.OID)
            ELSE 0
            END as number) AS DEF_SUBPARTITION_COUNT,
       cast(SPC.PRELNKEYS as number) AS PARTITIONING_KEY_COUNT,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN (SELECT PRELNKEYS FROM SYS_PARTCLASS WHERE PRELID=C.OID)
            ELSE 0
            END as number) AS SUBPARTITIONING_KEY_COUNT,
       cast('VALID' as character varying(8 byte)) AS STATUS,
       cast('SYSTEM' as character varying(30 byte)) AS DEF_TABLESPACE_NAME,
	   cast(NULL as number) AS DEF_PCT_FREE,
	   cast(NULL as number) AS DEF_PCT_USED,
	   cast(NULL as number) AS DEF_INI_TRANS,
	   cast(NULL as number) AS DEF_MAX_TRANS,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_INITIAL_EXTENT,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_NEXT_EXTENT,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_MIN_EXTENTS,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_MAX_EXTENTS,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_PCT_INCREASE,
	   cast(NULL as number) AS DEF_FREELISTS,
	   cast(NULL as number) AS DEF_FREELIST_GROUPS,
	   cast('YES' as character varying(7 byte)) as DEF_LOGGING,
	   cast('DISABLED' as character varying(8 byte)) as DEF_COMPRESSION,
	   cast('DEFAULT' as character varying(7 byte)) as DEF_BUFFER_POOL
FROM SYS_CATALOG.SYS_USER SA,
     SYS_CATALOG.SYS_CLASS SC,
     SYS_CATALOG.SYS_PARTCLASS SPC, 
     SYS_CATALOG.SYS_CLASS C,
     SYS_CATALOG.SYS_PARTITION SP
WHERE SA.USESYSID=SC.RELOWNER
      AND SC.RELPARTTYP='t'
      AND C.RELPARTTYP='p'
      AND SC.OID=SPC.PRELID
      AND C.OID=SP.PARTITIONRELID
      AND SPC.PRELID=SP.PARTRELID
	  and (has_table_privilege(C.oid,'SELECT')
           or has_table_privilege(C.oid,'INSERT')
           or has_table_privilege(C.oid,'UPDATE')
           or has_table_privilege(C.oid,'DELETE')
           or has_table_privilege(C.oid,'REFERENCES')
           or has_table_privilege(C.oid,'TRIGGER'));
--user_part_tables
create or replace view user_part_tables as
SELECT 
	   cast(SA.USENAME as character varying(30 byte)) AS OWNER,
       cast(SC.RELNAME as character varying(30 byte)) AS TABLE_NAME,
       cast(DECODE(SPC.PRELMETHOD,'r','RANGE','l','LIST','h','HASH','c','COLUMN',NULL) as character varying(7 byte)) AS PARTITIONING_TYPE,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN DECODE((SELECT PRELMETHOD FROM SYS_PARTCLASS WHERE PRELID=C.OID),
                         'r','RANGE',
                         'l','LIST',
                         'h','HASH',
                         'c','COLUMN',
                         NULL)
            ELSE 'NONE'
            END as character varying(7 byte)) AS SUBPARTITIONING_TYPE,
       cast(SPC.PRELNPARTS as number) AS PARTITION_COUNT,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN (SELECT PRELNPARTS FROM SYS_PARTCLASS WHERE PRELID=C.OID)
            ELSE 0
            END as number) AS DEF_SUBPARTITION_COUNT,
       cast(SPC.PRELNKEYS as number) AS PARTITIONING_KEY_COUNT,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN (SELECT PRELNKEYS FROM SYS_PARTCLASS WHERE PRELID=C.OID)
            ELSE 0
            END as number) AS SUBPARTITIONING_KEY_COUNT,
       cast('VALID' as character varying(8 byte)) AS STATUS,
       cast('SYSTEM' as character varying(30 byte)) AS DEF_TABLESPACE_NAME,
	   cast(NULL as number) AS DEF_PCT_FREE,
	   cast(NULL as number) AS DEF_PCT_USED,
	   cast(NULL as number) AS DEF_INI_TRANS,
	   cast(NULL as number) AS DEF_MAX_TRANS,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_INITIAL_EXTENT,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_NEXT_EXTENT,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_MIN_EXTENTS,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_MAX_EXTENTS,
	   cast('DEFAULT' as character varying(40 byte)) AS DEF_PCT_INCREASE,
	   cast(NULL as number) AS DEF_FREELISTS,
	   cast(NULL as number) AS DEF_FREELIST_GROUPS,
	   cast('YES' as character varying(7 byte)) as DEF_LOGGING,
	   cast('DISABLED' as character varying(8 byte)) as DEF_COMPRESSION,
	   cast('DEFAULT' as character varying(7 byte)) as DEF_BUFFER_POOL
FROM SYS_CATALOG.SYS_USER SA,
     SYS_CATALOG.SYS_CLASS SC,
     SYS_CATALOG.SYS_PARTCLASS SPC, 
     SYS_CATALOG.SYS_CLASS C,
     SYS_CATALOG.SYS_PARTITION SP
WHERE SA.USESYSID=SC.RELOWNER
      AND SC.RELPARTTYP='t'
      AND C.RELPARTTYP='p'
      AND SC.OID=SPC.PRELID
      AND C.OID=SP.PARTITIONRELID
      AND SPC.PRELID=SP.PARTRELID
	  and SA.usename = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE));


REVOKE ALL ON sys_catalog.dba_part_tables FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_part_tables TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_part_tables TO PUBLIC;  

--dba_tab_partitions
create or replace view dba_tab_partitions as
SELECT cast(SA.USENAME as character varying(30 byte)) AS TABLE_OWNER,
       cast(SC.RELNAME as character varying(30 byte)) AS TABLE_NAME,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN 'YES'
            ELSE 'NO'
            END as character varying(3 byte)) AS COMPOSITE,
       cast(C.RELNAME as character varying(30 byte)) AS PARTITION_NAME,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN (SELECT PRELNPARTS FROM SYS_PARTCLASS WHERE PRELID=C.OID)
            ELSE 0
            END as number) AS SUBPARTITION_COUNT,
		cast(SP.partboundval as TEXT) as HIGH_VALUE,
		cast(length(sp.partboundval) as number) as HIGH_VALUE_LENGTH,
       cast(SP.PARTPOS as number) AS PARTITION_POSITION,
       cast(STS.SPCNAME as character varying(30 byte)) AS TABLESPACE_NAME,
	   cast(NULL as number) AS PCT_FREE,
	   cast(NULL as number) AS PCT_USED,
	   cast(NULL as number) AS INI_TRANS,
	   cast(NULL as number) AS MAX_TRANS,
	   cast(8 as number) AS INITIAL_EXTENT,
	   cast(8 as number) AS NEXT_EXTENT,
	   cast(8 as number) AS MIN_EXTENT,
	   cast(NULL as number) AS MAX_EXTENT,
	   cast(NULL as number) AS PCT_INCREASE,
	   cast(NULL as number) AS FREELISTS,
	   cast(NULL as number) AS FREELIST_GROUPS,
	   cast('YES' as character varying(7 byte)) AS LOGGING,
	   cast('DISABLE' as character varying(8 byte)) as COMPRESSION,
	   cast(SC.reltuples as number(38,0)) AS NUM_ROWS,
	   cast(SC.relpages as number(38,0)) AS BLOCKS,
	   cast(NULL as number) AS EMPTY_BLOCKS,
	   cast(NULL as number) AS AVG_SPACE,
	   cast(NULL as number) AS CHAIN_CNT,
	   cast((case  sc.reltuples  when 0 then 0 else (cast ( sc.relpages as number(38,0)) * getBlockSize()/ sc.reltuples ) end ) as number(38,0)) AS AVG_ROW_LEN,
	   cast(NULL as number) AS SAMPLE_SIZE 
FROM SYS_CATALOG.SYS_USER SA,
     SYS_CATALOG.SYS_CLASS SC,
     SYS_CATALOG.SYS_PARTCLASS SPC, 
     SYS_CATALOG.SYS_CLASS C,
     SYS_CATALOG.SYS_PARTITION SP,
     SYS_CATALOG.SYS_TABLESPACE STS
WHERE SA.USESYSID=SC.RELOWNER
      AND SC.RELPARTTYP='t'
      AND C.RELPARTTYP='p'
      AND SC.OID=SPC.PRELID
      AND C.OID=SP.PARTITIONRELID
      AND SPC.PRELID=SP.PARTRELID
      AND C.RELTABLESPACE=STS.OID;
--all_tab_partitions
create or replace view all_tab_partitions as
SELECT cast(SA.USENAME as character varying(30 byte)) AS TABLE_OWNER,
       cast(SC.RELNAME as character varying(30 byte)) AS TABLE_NAME,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN 'YES'
            ELSE 'NO'
            END as character varying(3 byte)) AS COMPOSITE,
       cast(C.RELNAME as character varying(30 byte)) AS PARTITION_NAME,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN (SELECT PRELNPARTS FROM SYS_PARTCLASS WHERE PRELID=C.OID)
            ELSE 0
            END as number) AS SUBPARTITION_COUNT,
		cast(SP.partboundval as TEXT) as HIGH_VALUE,
		cast(length(sp.partboundval) as number) as HIGH_VALUE_LENGTH,
       cast(SP.PARTPOS as number) AS PARTITION_POSITION,
       cast(STS.SPCNAME as character varying(30 byte)) AS TABLESPACE_NAME,
	   cast(NULL as number) AS PCT_FREE,
	   cast(NULL as number) AS PCT_USED,
	   cast(NULL as number) AS INI_TRANS,
	   cast(NULL as number) AS MAX_TRANS,
	   cast(8 as number) AS INITIAL_EXTENT,
	   cast(8 as number) AS NEXT_EXTENT,
	   cast(8 as number) AS MIN_EXTENT,
	   cast(NULL as number) AS MAX_EXTENT,
	   cast(NULL as number) AS PCT_INCREASE,
	   cast(NULL as number) AS FREELISTS,
	   cast(NULL as number) AS FREELIST_GROUPS,
	   cast('YES' as character varying(7 byte)) AS LOGGING,
	   cast('DISABLE' as character varying(8 byte)) as COMPRESSION,
	   cast(SC.reltuples as number(38,0)) AS NUM_ROWS,
	   cast(SC.relpages as number(38,0)) AS BLOCKS,
	   cast(NULL as number) AS EMPTY_BLOCKS,
	   cast(NULL as number) AS AVG_SPACE,
	   cast(NULL as number) AS CHAIN_CNT,
	   cast(cast(sc.relpages as number(38,0)) * getBlockSize()/ sc.reltuples as number(38,0)) AS AVG_ROW_LEN,
	   cast(NULL as number) AS SAMPLE_SIZE 
FROM SYS_CATALOG.SYS_USER SA,
     SYS_CATALOG.SYS_CLASS SC,
     SYS_CATALOG.SYS_PARTCLASS SPC, 
     SYS_CATALOG.SYS_CLASS C,
     SYS_CATALOG.SYS_PARTITION SP,
     SYS_CATALOG.SYS_TABLESPACE STS
WHERE SA.USESYSID=SC.RELOWNER
      AND SC.RELPARTTYP='t'
      AND C.RELPARTTYP='p'
      AND SC.OID=SPC.PRELID
      AND C.OID=SP.PARTITIONRELID
      AND SPC.PRELID=SP.PARTRELID
      AND C.RELTABLESPACE=STS.OID
	  and (has_table_privilege(C.oid,'SELECT')
           or has_table_privilege(C.oid,'INSERT')
           or has_table_privilege(C.oid,'UPDATE')
           or has_table_privilege(C.oid,'DELETE')
           or has_table_privilege(C.oid,'REFERENCES')
           or has_table_privilege(C.oid,'TRIGGER'));

--user_tab_partitions
create or replace view user_tab_partitions as 
SELECT cast(SA.USENAME as character varying(30 byte)) AS TABLE_OWNER,
       cast(SC.RELNAME as character varying(30 byte)) AS TABLE_NAME,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN 'YES'
            ELSE 'NO'
            END as character varying(3 byte)) AS COMPOSITE,
       cast(C.RELNAME as character varying(30 byte)) AS PARTITION_NAME,
       cast(CASE WHEN C.OID IN (SELECT PRELID FROM SYS_PARTCLASS)
            THEN (SELECT PRELNPARTS FROM SYS_PARTCLASS WHERE PRELID=C.OID)
            ELSE 0
            END as number) AS SUBPARTITION_COUNT,
		cast(SP.partboundval as TEXT) as HIGH_VALUE,
		cast(length(sp.partboundval) as number) as HIGH_VALUE_LENGTH,
       cast(SP.PARTPOS as number) AS PARTITION_POSITION,
       cast(STS.SPCNAME as character varying(30 byte)) AS TABLESPACE_NAME,
	   cast(NULL as number) AS PCT_FREE,
	   cast(NULL as number) AS PCT_USED,
	   cast(NULL as number) AS INI_TRANS,
	   cast(NULL as number) AS MAX_TRANS,
	   cast(8 as number) AS INITIAL_EXTENT,
	   cast(8 as number) AS NEXT_EXTENT,
	   cast(8 as number) AS MIN_EXTENT,
	   cast(NULL as number) AS MAX_EXTENT,
	   cast(NULL as number) AS PCT_INCREASE,
	   cast(NULL as number) AS FREELISTS,
	   cast(NULL as number) AS FREELIST_GROUPS,
	   cast('YES' as character varying(7 byte)) AS LOGGING,
	   cast('DISABLE' as character varying(8 byte)) as COMPRESSION,
	   cast(SC.reltuples as number(38,0)) AS NUM_ROWS,
	   cast(SC.relpages as number(38,0)) AS BLOCKS,
	   cast(NULL as number) AS EMPTY_BLOCKS,
	   cast(NULL as number) AS AVG_SPACE,
	   cast(NULL as number) AS CHAIN_CNT,
	   cast(cast(sc.relpages as number(38,0)) * getBlockSize()/ sc.reltuples as number(38,0)) AS AVG_ROW_LEN,
	   cast(NULL as number) AS SAMPLE_SIZE 
FROM SYS_CATALOG.SYS_USER SA,
     SYS_CATALOG.SYS_CLASS SC,
     SYS_CATALOG.SYS_PARTCLASS SPC, 
     SYS_CATALOG.SYS_CLASS C,
     SYS_CATALOG.SYS_PARTITION SP,
     SYS_CATALOG.SYS_TABLESPACE STS
WHERE SA.USESYSID=SC.RELOWNER
      AND SC.RELPARTTYP='t'
      AND C.RELPARTTYP='p'
      AND SC.OID=SPC.PRELID
      AND C.OID=SP.PARTITIONRELID
      AND SPC.PRELID=SP.PARTRELID
      AND C.RELTABLESPACE=STS.OID
	  and SA.usename = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE));

REVOKE ALL ON sys_catalog.dba_tab_partitions FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_tab_partitions TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_tab_partitions TO PUBLIC;  

--dba_db_links
create or replace view dba_db_links as
select 
	cast(dl.lnkowner as character varying(30 byte)) as OWNER,
	cast(dl.lnkname as character varying(128 byte))  as DB_LINK,
	cast(dl.lnkuser as character varying(30 byte)) as USERNAME,
	cast(dl.lnksrc as character varying(2000 char)) as HOST, --not the same
	cast(dl.lnkcreated as date) as CREATED
	from sys_catalog.sys_dblink dl;
--all_db_links
create or replace view all_db_links as
select * from dba_db_links;
--user_db_links
create or replace view user_db_links as
select 
	cast(dl.lnkname as character varying(128 byte))  as DB_LINK,
	cast(dl.lnkuser as character varying(30 byte)) as USERNAME,
	cast(dl.lnksrc as character varying(2000 char)) as HOST, --not the same
	cast(dl.lnkcreated as date) as CREATED
	from sys_catalog.sys_dblink dl, sys_user u 
	where dl.lnkowner = u.usesysid and u.usename=current_user;

REVOKE ALL ON sys_catalog.dba_db_links FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_db_links TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_db_links TO PUBLIC;  


--dba_trigger_cols
create or replace view dba_trigger_cols as
select 
	cast(a.usename as character varying(30 byte)) as TRIGGER_OWNER,
	cast(tg.tgname as character varying(30 byte)) as TRIGGER_NAME,
	cast(a.usename as character varying(30 byte)) as TABLE_OWNER,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
	cast(get_trigger_column(tg.tgrelid, cast(tg.tgattr as int[])) as character varying(4000 char)) as COLUMN_NAME
	from sys_catalog.sys_trigger tg, sys_catalog.sys_class c, sys_catalog.sys_user  a
	where tg.tgrelid = c.oid and c.relowner = a.usesysid ;
--all_trigger_cols
create or replace view all_trigger_cols as
select 
	cast(a.usename as character varying(30 byte)) as TRIGGER_OWNER,
	cast(tg.tgname as character varying(30 byte)) as TRIGGER_NAME,
	cast(a.usename as character varying(30 byte)) as TABLE_OWNER,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
	cast(get_trigger_column(tg.tgrelid, cast(tg.tgattr as int[])) as character varying(4000 char)) as COLUMN_NAME
	from sys_catalog.sys_trigger tg, sys_catalog.sys_class c, sys_catalog.sys_user a
	where tg.tgrelid = c.oid and c.relowner = a.usesysid 
		and (has_table_privilege(c.oid,'SELECT')
           or has_table_privilege(c.oid,'INSERT')
           or has_table_privilege(c.oid,'UPDATE')
           or has_table_privilege(c.oid,'DELETE')
           or has_table_privilege(c.oid,'REFERENCES')
           or has_table_privilege(c.oid,'TRIGGER'));
--user_trigger_cols
create or replace view user_trigger_cols as
select 
	cast(a.usename as character varying(30 byte)) as TRIGGER_OWNER,
	cast(tg.tgname as character varying(30 byte)) as TRIGGER_NAME,
	cast(a.usename as character varying(30 byte)) as TABLE_OWNER,
	cast(c.relname as character varying(30 byte)) as TABLE_NAME,
	cast(get_trigger_column(tg.tgrelid, cast(tg.tgattr as int[])) as character varying(4000 char)) as COLUMN_NAME
	from sys_catalog.sys_trigger tg, sys_catalog.sys_class c, sys_catalog.sys_user a
	where tg.tgrelid = c.oid and c.relowner = a.usesysid 
	and a.usename = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE));
	
REVOKE ALL ON sys_catalog.dba_trigger_cols FROM PUBLIC;
GRANT SELECT ON sys_catalog.all_trigger_cols TO PUBLIC;   
GRANT SELECT ON sys_catalog.user_trigger_cols TO PUBLIC;  	

--dynamic view
--V$DATABASE
create or replace function get_log_mode()
returns setof record as
declare
	sqlcmd text;
	mode refcursor;
	rec record;
begin
	sqlcmd := 'show log_archive_start';
	open mode for sqlcmd;
	fetch mode into rec;
	close mode;
	return next rec;
end;

create or replace view V$DATABASE as
select
	cast(cast(db.oid as bigint) as number(38,0)) as DBID,
	cast(db.datname as character varying(30 byte)) as NAME,
	cast(null as date) as CREATED,
	cast((case when 'off'=(select * from get_log_mode() as (status text)) then 'NOARCHIVELOG' else 'ARCHIVELOG' end) as character varying(12 byte)) as LOG_MODE,
	cast(0 as number) as CHECKPOINT_CHANGE,
	cast(NULL as date) as CONTROLFILE_TIME,
	cast('READ WRITE' as character varying(10 byte)) as OPEN_MODE,
	cast(0 as number) as ARCHIVELOG_CHANGE,
	cast(0 as number) as CURRENT_SCN,
	cast(sum(sf.maxsize) as number(38,0)) as MAX_SIZE,
	cast(sum(cast(df.currentblocks as number(38,0))) * (ss.setting / 1024) / 1024 as number(38,0)) as TOTAL_SIZE,
	cast('ONLINE' as character varying(10 byte)) as STATUS$
	from sys_catalog.sys_database db, sys_catalog.sys_file sf, sys_catalog.sys_datafiles df ,sys_settings ss
	where db.oid = sf.datid and sf.fileid = df.fileid and ss.name='block_size'
	group by db.oid, db.datname, ss.setting;

GRANT SELECT ON sys_catalog.V$DATABASE TO PUBLIC;  

--V$SESSION
create or replace view V$SESSION as
select
	cast(sa.client_addr as character varying(20 byte)) as SADDR,
	cast(sa.procpid as number) as SID,
	cast(null as number) as SERIAL#,
	cast(null as number) as AUDSID,
	cast(NULL as character varying(20 byte))as PADDR,
	cast(cast(sa.usesysid as bigint) as number(38,0)) as USER#,
	cast(sa.usename as varchar2(30 byte)) as USERNAME,
	cast(NULL as number) as COMMAND,
	cast(null as number) as OWNERID,
	cast(NULL as varchar2(20 byte)) as TADDR,
	cast((case sa.waiting
	when 't' then (select l.objname from sys_catalog.sys_locks l where l.pid=sa.procpid and l.granted=false)
	else NULL end) as varchar2(8 byte))as LOCKWAIT,
	cast((case 
	when sa.current_query is null then 'INACTIVE' else 'ACTIVE' 
	end)as varchar2(8 byte)) as STATUS,
	cast('SHARED' as varchar2(9 byte)) as SERVER,
	cast(cast(sa.usesysid as bigint) as number(38,0))as SCHEMA#,
	cast(NULL as varchar2(30 byte)) as SCHEMANAME,
	cast(NULL as varchar2(30 byte)) as OSUSER,
	cast(NULL as varchar2(12 byte)) as PROCESS,
	cast(NULL as varchar2(64 byte)) as MACHINE,
	cast(NULL as varchar2(30 byte)) as TERMINAL,
	cast(NULL as varchar2(48 byte)) as PROGRAM,
	cast(NULL as varchar2(10 byte)) as TYPE,
	cast(NULL as character varying(20 byte)) as SQL_ADDRESS,
	cast(NULL as number) as SQL_HASH_VALUE,
	cast(NULL as varchar2(13 byte)) as SQL_ID,
	cast(0 as number) as SQL_CHILD_NUMBER,
	cast(NULL as character varying(20 byte)) as PREV_SQL_ADDR,
	cast(NULL as number) as PREV_HASH_VALUE,
	cast(NULL as varchar2(13 byte)) as PREV_SQL_ID,
	cast(NULL as number) as PREV_CHILD_NUMBER,
	cast(null as varchar2(48)) as MODULE,
	cast(NULL as number) as MODULE_HASH,
	cast(null as varchar2(32)) as ACTION,
	cast(NULL as number) as ACTION_HASH,
	cast(null as varchar2(64)) as CLIENT_INFO,
	cast(NULL as number) as FIXED_TABLE_SEQUENCE,
	cast(NULL as number) as ROW_WAIT_OBJ#,
	cast(NULL as number) as ROW_WAIT_FILE#,
	cast(NULL as number) as ROW_WAIT_BLOCK#,
	cast(NULL as number) as ROW_WAIT_ROW#,
	cast(sa.backend_start as date) as LOGON_TIME,
	cast(NULL as number) as LAST_CALL_ET,
	cast(NULL as varchar2(3)) as PDML_ENABLED,
	cast('NONE' as varchar2(13)) as FAILOVER_TYPE,
	cast('NONE' as varchar2(10)) as FAILOVER_METHOD,
	cast('NO' as varchar2(3)) as FAILED_OVER,
	cast(NULL as varchar2(32)) as RESOURCE_CONSUMER_GROUP,
	cast('DISABLED' as varchar2(8)) as PDML_STATUS,
	cast('DISABLED' as varchar2(8)) as PDDL_STATUS,
	cast('DISABLED' as varchar2(8)) as PQ_STATUS,
	cast(null as number) as CURRENT_QUEUE_DURATION,
	cast(NULL as varchar2(64)) as CLIENT_IDENTIFIER,
	cast('UNKNOWN' as varchar2(11)) as BLOCKING_SESSION_STATUS,
	cast(null as number) as BLOCKING_INSTANCE,
	cast(null as number) as BLOCKING_SESSION,
	cast(null as number) as SEQ#,
	cast(null as number) as EVENT#,
	cast(NULL as varchar2(64)) as EVENT,
	cast(NULL as varchar2(64)) as P1TEXT,
	cast(null as number) as P1,
	cast(NULL as varchar2(20)) as P1RAW,
	cast(NULL as varchar2(64)) as P2TEXT,
	cast(null as number) as P2,
	cast(NULL as varchar2(20)) as P2RAW,
	cast(NULL as varchar2(64)) as P3TEXT,
	cast(null as number) as P3,
	cast(NULL as varchar2(20)) as P3RAW,
	cast(null as number) as WAIT_CLASS_ID,
	cast(null as number) as WAIT_CLASS#,
	cast(NULL as varchar2(64)) as WAIT_CLASS,
	cast(null as number) as WAIT_TIME,
	cast(null as number) as SECONDS_IN_WAIT,
	cast((case sa.waiting 	when 't' then 'WAITING' else 'WAITED UNKNOWN TIME' end) as varchar2(19)) as STATE,
	cast(null as number) as SERVICE_NAME,
	cast('DISABLED' as varchar2(8)) as SQL_TRACE,
	cast('FALSE' as varchar2(5)) as SQL_TRACE_WAITS,
	cast('FALSE' as varchar2(5)) as SQL_TRACE_BINDS
	from sys_catalog.sys_stat_activity sa;

GRANT SELECT ON sys_catalog.V$SESSION TO PUBLIC;  	
	
--V$INSTANCE
create or replace view V$INSTANCE as
select 
	cast('instance1' as character varying(16 byte)) as INSTANCE_NAME,
	cast(NULL as character varying(64 byte)) as HOST_NAME,
	cast((select version()) as character varying(17 byte)) as VERSION,
	cast(NULL as date) as STARTUP_TIME,
	cast('STARTED' as character varying(12 byte)) as STATUS,
	cast('STOPPED' as character varying(7 byte)) as ARCHIVER,
	cast('ALLOWED' as character varying(10 byte)) as LOGIN,
	cast('NO' as character varying(3 byte)) as SHUTDOWN_PENDING,
	cast('ONLINE' as character varying(17 byte)) as DATABASE_STATUS,
	cast('PRIMARY_INSTANCE' as character varying(18 byte)) as INSTANCE_ROLE,
	cast('NORMAL' as character varying(9 byte)) as ACTIVE_STATE,
	cast('NO' as character varying(3 byte)) as BLOCKED
from dual;

GRANT SELECT ON sys_catalog.V$INSTANCE TO PUBLIC;  

--V$SYSSTAT

create or replace function sys_stat()
returns setof record as
declare
	i int;
	ret record;	
	rec record;
	sqlcmd text;
	statname cursor for select proname from sys_catalog.sys_proc where proname like 'SYS_STAT_GET_DB%';
	stat refcursor;
	dbname varchar(64);
	dbid oid;
	value int8;
begin
	open stat for select * from current_database();
	fetch stat into dbname;
	close stat;
	sqlcmd:='select oid from sys_catalog.sys_database db where db.datname='''||dbname||'''';
	open stat for sqlcmd;
	fetch stat into dbid;
	close stat;
	i:=0;
	for rec in statname
	loop
		sqlcmd:='select * from '||rec.proname||'('||dbid||')';
		open stat for sqlcmd;
		fetch stat into value;
		select into ret cast(i as number), cast(rec.proname as varchar(63 byte)), cast(value as number);
		close stat;
		i:=i+1;
		return next ret;
	end loop;
end;


create or replace view V$SYSSTAT as
select * from sys_stat() as (STATISTIC# number, NAME varchar(63 byte), VALUE number);
--V$DATAFILE
create or replace view V$DATAFILE as
select 
	cast(cast(df.fileid as bigint) as number(38,0)) as FILE#,
	cast(0 as number) as CREATION_CHANGE#,
	cast(NULL as date) as CREATION_TIME,
	cast(cast(tp.oid as bigint) as number(38,0)) TS#,
	cast(cast(df.fileid as bigint) as number(38,0))as RFILE#,
	cast('ONLINE' as character varying(7 byte)) as STATUS,
	cast('READ WRITE' as character varying(10 byte)) as ENABLED,
	cast(cast(getBlockSize() as number(38,0)) * userblocks as number(38,0)) as BYTES,
	cast(userblocks as number(38,0)) as BLOCKS,
	cast(cast(getBlockSize() as number(38,0)) * initsize as number(38,0)) as CREATE_BYTES,
	cast(getBlockSize() as number) as BLOCK_SIZE,
	cast(filename as character varying(513 byte)) as NAME
	from sys_catalog.sys_datafiles df, sys_catalog.sys_tablespace tp where df.spcname = tp.spcname;
	
GRANT SELECT ON sys_catalog.V$SYSSTAT TO PUBLIC;  	

--V$LOGFILE
create or replace view V$LOGFILE as
select 
	cast(0 as number) as GROUP#,
	cast((case rl.state
	when 'ACTIVE' then NULL else 'STALE' end
	)as character varying(7 byte))STATUS,
	cast('ONLINE' as character varying(7 byte)) as TYPE,
	cast(rl.logicalname as character varying(513 byte)) as MEMBER
	from sys_catalog.sys_redologs rl;

GRANT SELECT ON sys_catalog.V$LOGFILE TO PUBLIC; 

--V$LOCK
create or replace view V$LOCK as
select 
	cast(NULL as character varying(16 byte)) as ADDR,
	cast(NULL as character varying(16 byte)) as KADDR,
	cast(l.pid as number) as SID,
	cast((case l.locktype when 'transactionid' then 'TX' when 'userlock' then 'UL' 
       else 'TM' end)  as character varying(2 byte)) as TYPE,
	cast(case  l.granted when false then null else( (case l.mode when 'ACCESS SHARE' then 4 when 'ROW SHARE' then 2
        when 'ROW EXCLUSIVE' then 3 when 'EXCLUSIVE' then 6 when 'ACCESS EXCLUSIVE' then 6 when 'SHARE' then 4 else 5 end)  ) end  as number) as LMODE,	
	cast(case  l.granted when true then null else( (case l.mode when 'ACCESS SHARE' then 4 when 'ROW SHARE' then 2
        when 'ROW EXCLUSIVE' then 3 when 'EXCLUSIVE' then 6 when 'ACCESS EXCLUSIVE' then 6 when 'SHARE' then 4 else 5 end) )end  as number) as REQUEST,
	cast(NULL as number) as CTIME,
	cast(l.granted as number) as BLOCK
from sys_catalog.sys_locks l;

GRANT SELECT ON sys_catalog.V$LOCK TO PUBLIC; 

--V$PARAMETER
create or replace function get_parameter() 
returns setof record as
declare
	ret record;
	param record;
	setting cursor for select * from sys_settings;
	i int;
	isses_modifiable text;
	issys_modifiable text;
	ismodified text;
	typ int;
begin
	i:=1;
	for param in setting loop
  	if param.context='session' then 
  	isses_modifiable='TRUE'; 
  	else 
  	isses_modifiable='FALSE';
  	end if;
  	if param.context='system'  then 
  	issys_modifiable='TRUE'; 
  	else 
  	issys_modifiable='FALSE';
  	end if;
  	if param.source='default' then 
  	ismodified='FALSE'; 
  	else 
  	ismodified='TRUE';
  	end if;
  	if  param.vartype ='bool' then typ:=1;
  	elsif  param.vartype ='string' then typ:=2;
  	elsif param.vartype='integer' then typ:=3;
  	elsif param.vartype='real' then typ:=5;
  	end if;

  	select into ret cast(i as number), cast(param.name as varchar(80 byte)), cast(typ as number), 
  	cast(param.setting as varchar(512 byte)), cast(param.setting as varchar(512 byte)), 
  	cast(isses_modifiable as varchar(5 byte)), cast(issys_modifiable as varchar(9 byte)), cast(ismodified as varchar(10 byte)), 
  	cast(param.short_desc as varchar(255 byte));
  	
	  i:=i+1;
	  return next ret;
	end loop;
end;

create or replace view V$PARAMETER as
select * from sys_catalog.get_parameter() 
as(NUM number, NAME varchar(80 byte), TYPE number, VALUE varchar(512 byte), DISPLAY_VALUE varchar(512 byte), 
ISSES_MODIFIABLE varchar(5 byte), ISSYS_MODIFIALBE varchar(9 byte), ISMODIFIED varchar(10 byte), DESCRIPTION varchar(255 byte));

GRANT SELECT ON sys_catalog.V$PARAMETER TO PUBLIC; 

--bug#22817: dba_free_space and user_free_space
create or replace view dba_free_space
AS
SELECT
cast(df.spcname as varchar2(30 BYTE)) as tablespace_name,
cast(cast(df.fileid as bigint) as number(38)) as file_id,
cast(fs.startblocK as number(38)) as block_id,
cast(fs.nblocks * cast(getBlockSize() as number(38,0)) as number(38)) as bytes,
cast(fs.nblocks as number(38)) as blocks,
cast(cast(df.fileid as bigint) as number(38)) as relative_fno
FROM 
sys_datafiles df, sys_freespaces fs 
where fs.datname = current_database()
  and fs.logicalname = df.logicalname
  and df.status = 't';

REVOKE ALL ON sys_catalog.dba_free_space FROM PUBLIC; 

create or replace view user_free_space
AS
SELECT dfs.* FROM dba_free_space dfs, sys_tablespace ts, sys_authid a
WHERE ts.spcowner = a.oid
  and a.rolname = CAST(current_user AS VARCHAR(63 BYTE))
  and dfs.tablespace_name = ts.spcname;

GRANT SELECT ON sys_catalog.user_free_space TO PUBLIC; 

CREATE OR REPLACE VIEW V$LOCKED_OBJECT AS
SELECT 
CAST(null as number) AS XIDUSN,
CAST(null as number) AS XIDSLOT,
CAST(null as number) AS XIDSQN,
CAST(cast(l.objid as bigint) as number) AS OBJECT_ID,
CAST(l.pid as number) AS SESSION_ID,
CAST(a.usename as varchar2(30)) AS ORACLE_USERNAME,
CAST(null as varchar2(30)) AS OS_USER_NAME,
CAST(null as varchar2(30)) AS PROCESS,
cast((case l.mode when 'ACCESS SHARE' then 4 when 'ROW SHARE' then 2
        when 'ROW EXCLUSIVE' then 3 when 'EXCLUSIVE' then 6 when 'ACCESS EXCLUSIVE' then 6 when 'SHARE' then 4 else 5 end)  as number) as LOCKED_MODE
FROM sys_catalog.sys_locks l, sys_catalog.sys_stat_activity t, sys_user a
WHERE l.granted = true and l.pid = t.procpid and t.USESYSID = a.USESYSID;

GRANT SELECT ON sys_catalog.V$LOCKED_OBJECT TO PUBLIC; 

CREATE OR REPLACE INTERNAL FUNCTION create_sys_guid() RETURNS VOID AS '
DECLARE
  return_typ TEXT;
  stmt	TEXT;
BEGIN
  SELECT setting INTO return_typ FROM sys_catalog.sys_settings WHERE name = ''guid_default_return_type'';

  IF lower(return_typ) = ''bytea'' THEN
     stmt = ''CREATE OR REPLACE INTERNAL FUNCTION sys_guid() RETURN BYTEA AS $$SELECT sys_guid_bytea()$$ LANGUAGE sql;'';
  ELSE
     stmt = ''CREATE OR REPLACE INTERNAL FUNCTION sys_guid() RETURN NAME AS $$SELECT sys_guid_name()$$ LANGUAGE sql;'';
  END IF;

  EXECUTE stmt;
  
  RETURN;
END;
' LANGUAGE plsql;

CALL create_sys_guid();

