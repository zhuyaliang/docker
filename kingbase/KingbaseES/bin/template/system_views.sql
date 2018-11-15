CREATE VIEW sys_roles AS 
    SELECT 
        rolname,
        rolsuper,
        rolcreaterole,
        rolcreatedb,
        rolcatupdate,
        '********'::text as rolpassword,
        rolconfig,
        oid
    FROM sys_authid
	WHERE roltype = 'R';

CREATE VIEW sys_shadow AS
    SELECT
        rolname AS usename,
        oid AS usesysid,
        rolcreatedb AS usecreatedb,
        rolcreaterole AS usecreaterole,
        rolcreateuser AS usecreateuser,
        rolsuper AS usesuper,
        rolcatupdate AS usecatupd,
        rolpassword AS passwd,
        rolvaliduntil AS valuntil,
        rolpassexpiretime AS passexpiretime,
        rolconfig AS useconfig,
        roltype AS type
    FROM sys_authid
    WHERE roltype = 'S' OR roltype = 'U';

REVOKE ALL on sys_shadow FROM public;

CREATE VIEW sys_user AS 
    SELECT 
        usename, 
        usesysid, 
        usecreatedb, 
        usecreaterole,
        usesuper, 
        usecatupd, 
        '********'::text as passwd, 
        valuntil, 
		passexpiretime,
        useconfig,
		type
    FROM sys_shadow;

CREATE VIEW sys_rules AS 
    SELECT 
        N.nspname AS schemaname, 
        C.relname AS tablename, 
        R.rulename AS rulename, 
        sys_get_ruledef(R.oid) AS definition 
    FROM (sys_rewrite R JOIN sys_class C ON (C.oid = R.ev_class)) 
        LEFT JOIN sys_namespace N ON (N.oid = C.relnamespace) 
    WHERE R.rulename != '_RETURN';

CREATE VIEW sys_views AS 
    SELECT 
        N.nspname AS schemaname, 
        C.relname AS viewname, 
        sys_get_userbyid(C.relowner) AS viewowner, 
        sys_get_viewdef(C.oid) AS definition, 
        CAST(
             CASE WHEN sys_view_check_option(c.oid) = 0
                  THEN 'NONE'
                  WHEN sys_view_check_option(c.oid) = 1
                  THEN 'CASCADED'
                  ELSE 'LOCAL' END
             AS varchar(8)) AS checkoption,
        CAST(
             CASE WHEN sys_view_is_updatable(c.oid) IN (0, 2)
                  THEN 'YES'
                  ELSE 'NO' END
             AS varchar(3)) AS isupdatable 
    FROM sys_class C LEFT JOIN sys_namespace N ON (N.oid = C.relnamespace) 
    WHERE C.relkind = 'v';

CREATE VIEW sys_tables AS 
    SELECT 
        N.nspname AS schemaname, 
        C.relname AS tablename, 
        sys_get_userbyid(C.relowner) AS tableowner, 
        T.spcname AS tablespace,
        C.relhasindex AS hasindexes, 
        C.relhasrules AS hasrules, 
        (C.reltriggers > 0) AS hastriggers 
    FROM sys_class C LEFT JOIN sys_namespace N ON (N.oid = C.relnamespace) 
         LEFT JOIN sys_tablespace T ON (T.oid = C.reltablespace)
    WHERE C.relkind = 'r' AND C.relparttyp != 'p' AND C.relparttyp != 'x'
                          AND C.relparttyp != 'm' AND C.relparttyp != 'q';

CREATE VIEW sys_matviews AS
    SELECT
        N.nspname AS schemaname,
        C.relname AS matviewname,
        sys_get_userbyid(C.relowner) AS matviewowner,
        T.spcname AS tablespace,
        C.relhasindex AS hasindexes,
        sys_get_viewdef(C.oid) AS definition
    FROM sys_class C LEFT JOIN sys_namespace N ON (N.oid = C.relnamespace)
         LEFT JOIN sys_tablespace T ON (T.oid = C.reltablespace)
    WHERE C.relkind = 'm';

CREATE VIEW sys_indexes AS 
    SELECT 
        N.nspname AS schemaname, 
        C.relname AS tablename, 
        I.relname AS indexname, 
        T.spcname AS tablespace,
        sys_get_indexdef(I.oid) AS indexdef 
    FROM sys_index X JOIN sys_class C ON (C.oid = X.indrelid) 
         JOIN sys_class I ON (I.oid = X.indexrelid) 
         LEFT JOIN sys_namespace N ON (N.oid = C.relnamespace) 
         LEFT JOIN sys_tablespace T ON (T.oid = I.reltablespace)
    WHERE C.relkind IN ('r', 'm') AND C.relparttyp != 'p' AND I.relkind = 'i' AND I.relparttyp != 'p';

CREATE VIEW sys_triggers AS  
	SELECT TG.OID AS TRIOID, TG.TGNAME, N.OID AS SCHEMAID, N.NSPNAME AS SCHEMANAME,
		TG.TGENABLED AS TGENABLED,
		C.RELNAME AS TABLENAME, TG.TGTYPE, TG.TGFOID, 
        TG.TGKIND, TG.TGCONSTRNAME, TG.TGCONSTRRELID, TG.TGDEFERRABLE, TG.TGINITDEFERRED, 
		TG.TGISENCRYPTED,
        SYS_GET_TRIGGERDEF(TG.OID) AS TRIDEF, 
        SYS_GET_USERBYID(C.RELOWNER) AS OWNER,DES.OBJCTIME::TEXT AS CREATEDATE, 
        DES.OBJMTIME::TEXT AS MODIFYDATE,
    ( CASE TG.tgstatus
      WHEN 't' THEN 'VALID'
      WHEN 'f' THEN 'INVALID'
      END) AS STATUS 
	FROM SYS_CLASS AS C  
        JOIN SYS_TRIGGER AS TG ON(C.OID=TG.TGRELID)
        LEFT JOIN SYS_DESCRIPTION AS DES ON(TG.OID = DES.OBJOID)
        JOIN SYS_NAMESPACE AS N ON(N.OID = TG.TGNAMESPACE)
	WHERE (DES.OBJOID IS NULL	
			OR DES.CLASSOID = (SELECT OID FROM SYS_CLASS WHERE RELNAME = 'SYS_TRIGGER'))  
		AND C.RELKIND IN ('r'::"CHAR", 'v'::"CHAR", 'm'::"CHAR");

-- Firstly creating some function used for creating the sys_packages view
CREATE INTERNAL FUNCTION get_function_definition(funcid OID) RETURNS TEXT AS '
DECLARE
  definition TEXT;
  funcInfo RECORD;

  -- parameter infomation
  funcParams TEXT DEFAULT '''';

  -- return type
  funcReturnType TEXT DEFAULT '''';
BEGIN
  SELECT proname,protype, provolatile, pronargs, proargnames, proargmodes, proargtypes,
         proargtypmods, proargdefbins, proretset, prorettypedef
  INTO funcInfo
  FROM sys_catalog.sys_proc WHERE oid = funcid;

  IF SQL%NOTFOUND THEN
    RETURN NULL;
  END IF;

  FOR idx IN 1..funcInfo.pronargs LOOP
    DECLARE
      pname TEXT;
      pmode TEXT;
      ptype TEXT;
      pdefault TEXT;
    BEGIN
      pname := funcInfo.proargnames[idx];

      IF (funcInfo.proargmodes[idx] = ''i'') OR (funcInfo.proargmodes[idx] IS NULL) THEN
        pmode := ''IN'';
      ELSIF (funcInfo.proargmodes[idx] = ''o'') THEN
        pmode := ''OUT'';
      ELSIF (funcInfo.proargmodes[idx] = ''b'') THEN
        pmode := ''INOUT'';
      ELSE
        RAISE EXCEPTION ''invalid parameter mode: %'', funcInfo.proargmodes[idx];
      END IF;

      -- FIXME: oidvector is insane
      ptype := sys_catalog.format_type(funcInfo.proargtypes[idx - 1], ISNULL(funcInfo.proargtypmods[idx], -1));

      -- FIXME: we need a rel
      pdefault := sys_catalog.sys_get_expr(funcInfo.proargdefbins[idx], 1259);

      IF (pname IS NOT NULL) THEN
        funcParams := funcParams || CASE WHEN LENGTH(pname) = 0 THEN ''""'' ELSE pname END || '' '';
      END IF;

      funcParams := funcParams || pmode || '' '';
      funcParams := funcParams || ptype;

      IF (pdefault IS NOT NULL) THEN
        funcParams := funcParams || '' DEFAULT '' || pdefault;
      END IF;

      IF idx <> funcInfo.pronargs THEN
        funcParams := funcParams || '', '';
      END IF;
    END;
  END LOOP;

  funcParams := ''('' || funcParams || '')'';

  -- Add ''SETOF'' keyword and ''RETURNS'' keyword
  IF funcInfo.protype = ''f'' THEN
     funcReturnType := CASE WHEN funcInfo.proretset IS TRUE THEN ''SETOF '' ELSE '''' END;
     funcReturnType := ''RETURNS '' || funcReturnType || (CASE WHEN funcInfo.prorettypedef = (SELECT oid FROM sys_catalog.sys_type WHERE typname = ''VOID'') THEN ''VOID''
                                                             ELSE sys_catalog.format_type(funcInfo.prorettypedef, NULL)
                                                        END);
  END IF;

  definition := funcInfo.proname || funcParams || '' '' || funcReturnType;

  RETURN definition;
END;
' LANGUAGE plsql;

CREATE INTERNAL FUNCTION get_pkg_function_type(funcid OID) RETURNS TEXT AS '
DECLARE
  funcTypeInfo RECORD;
  typ TEXT;
BEGIN
  SELECT proname, protype INTO funcTypeInfo FROM sys_catalog.sys_proc WHERE oid = funcid;

  IF SQL%NOTFOUND THEN
    RETURN NULL;
  END IF;

  IF funcTypeInfo.protype = ''p''
     AND ''b'' = ((SELECT pkgtype FROM sys_package
                             WHERE oid =(SELECT propkgoid FROM sys_proc WHERE oid = funcid))) THEN typ := ''INIT PROCEDURE'';
  ELSIF funcTypeInfo.protype = ''p'' THEN typ := ''PROCEDURE'';
  ELSIF funcTypeInfo.protype = ''f'' THEN typ := ''FUNCTION'';
  END IF;
  RETURN typ;
END;
' LANGUAGE plsql;

CREATE INTERNAL FUNCTION get_pkg_variable_type(varid OID) RETURNS TEXT AS '
DECLARE
  varInfo RECORD;
BEGIN
  SELECT pvtype, pvhasquery INTO varInfo FROM sys_catalog.sys_pkgvariable WHERE oid = varid;

  IF SQL%NOTFOUND THEN
    RETURN NULL;
  END IF;

  IF varInfo.pvtype = ''v'' THEN RETURN ''SCALAR VARIABLE'';
  ELSIF varInfo.pvtype = ''c'' AND varInfo.pvhasquery THEN RETURN ''CURSOR'';
  ELSIF varInfo.pvtype = ''c'' AND NOT varInfo.pvhasquery THEN RETURN ''REF CURSOR'';
  ELSIF varInfo.pvtype = ''r'' THEN RETURN ''RECORD'';
  ELSIF varInfo.pvtype = ''w'' THEN RETURN ''ROW VARIABLE'';
  ELSIF varInfo.pvtype = ''u'' THEN RETURN ''ASSOCIATIVE ARRAY'';
  ELSIF varInfo.pvtype = ''n'' THEN RETURN ''NESTED TABLE'';
  ELSIF varInfo.pvtype = ''V'' THEN RETURN ''VARRAY'';
  END IF;
END;
' LANGUAGE plsql;

-- Create view for Package: sys_packages
CREATE VIEW sys_packages AS
    SELECT
        (SELECT nspname FROM sys_namespace WHERE oid = sp.pkgnamespace) AS namespace,
        sp.pkgname AS packagename,
        sys_get_userbyid(sp.pkgowner) AS owner,
        CASE WHEN sd.classid = regclassin('SYS_PKGVARIABLE') THEN (SELECT get_pkg_variable_type(oid) AS type
                                                                   FROM sys_pkgvariable WHERE oid = sd.objid)
             WHEN sd.classid = regclassin('SYS_PROC') THEN (SELECT get_pkg_function_type(oid) AS type
                                                            FROM sys_proc WHERE oid = sd.objid)
        END AS type,
        CASE WHEN sd.classid = regclassin('SYS_PKGVARIABLE') THEN (SELECT pvsrc AS obj_info FROM sys_pkgvariable WHERE oid = sd.objid)
             WHEN sd.classid = regclassin('SYS_PROC') THEN (SELECT get_function_definition(oid) AS definition
                                                              FROM sys_proc WHERE oid = sd.objid)
        END AS obj,
        ( CASE sp.PKGSTATUS
         WHEN 't' THEN 'VALID'
         WHEN 'f' THEN 'INVALID'
        END) AS STATUS 
    FROM sys_depend AS sd
        JOIN sys_package AS sp
        ON sd.refclassid = regclassin('SYS_PACKAGE')
        AND sd.refobjid = sp.oid
    WHERE sd.classid <> (SELECT oid FROM sys_class WHERE relname = 'SYS_PACKAGE') -- The infornation of package or package body is filtered.
    ORDER BY namespace, packagename, owner, type, obj
;

CREATE VIEW sys_depends AS 
      (SELECT DISTINCT  
		C.OID AS OID, 	
		C.RELNAME AS NAME,  
		C.RELKIND AS TYPE,	
        BASE.OID AS REFRELID,	
        BASE.RELNAME AS REFRELNAME, 
        BASE.RELKIND AS REFRELTYPE 
   FROM SYS_CLASS C, SYS_REWRITE R, SYS_DEPEND D, SYS_CLASS BASE  
   WHERE C.OID=R.EV_CLASS AND R.OID=D.OBJID AND REFOBJID=BASE.OID AND BASE.OID!=C.OID) 
UNION ALL 
      (SELECT DISTINCT 
		R.OID AS OID, 
		R.TGNAME AS NAME, 
		't'::"CHAR" AS TYPE, 
        BASE.OID AS REFRELID,	
        BASE.RELNAME AS REFRELNAME, 
        BASE.RELKIND AS REFRELTYPE	
	FROM SYS_CLASS C, SYS_TRIGGER R, SYS_DEPEND D , SYS_CLASS BASE  
	WHERE C.OID=R.TGRELID AND R.OID=D.OBJID AND REFOBJID=BASE.OID
      AND R.TGKIND = 'n'
	ORDER BY BASE.OID);	
	
CREATE VIEW sys_primarykey_indexes AS 
  SELECT rel.relnamespace, 
          rel.relname, 
          con.conname AS primaryconname,
          idx.relnamespace AS indexnamespace, 
          idx.relname AS indexname  
  FROM sys_class rel, sys_class idx, sys_index, 
        sys_depend, sys_constraint con, sys_namespace nsp 
  WHERE sys_depend.refobjid = con.oid 
      AND idx.oid = sys_depend.objid 
      AND con.conrelid = rel.oid 
      AND idx.oid = sys_index.indexrelid 
      AND rel.relnamespace = nsp.oid 
      AND con.contype = 'p';

CREATE VIEW sys_uniquekey_indexes AS 
  SELECT rel.relnamespace, 
          rel.relname, 
          con.conname AS uniconname,
          idx.relnamespace AS indexnamespace, 
          idx.relname AS indexname  
  FROM  sys_class rel, sys_class idx, sys_index, 
        sys_depend, sys_constraint con, sys_namespace nsp 
  WHERE sys_depend.refobjid = con.oid 
      AND idx.oid = sys_depend.objid 
      AND con.conrelid = rel.oid 
      AND idx.oid = sys_index.indexrelid 
      AND rel.relnamespace = nsp.oid 
      AND con.contype = 'u';

CREATE VIEW sys_auto_triggers AS 
  SELECT relnamespace, 
          relname, 
          tgrelid, 
          tgname 
  FROM sys_trigger, sys_class 
  WHERE tgkind != 'n' 
      AND tgrelid = sys_class.oid; 
		
CREATE VIEW sys_stats AS 
    SELECT 
        nspname AS schemaname, 
        relname AS tablename, 
        attname AS attname, 
        stanullfrac AS null_frac, 
        stawidth AS avg_width, 
        stadistinct AS n_distinct, 
        CASE 1 
            WHEN stakind1 THEN stavalues1 
            WHEN stakind2 THEN stavalues2 
            WHEN stakind3 THEN stavalues3 
            WHEN stakind4 THEN stavalues4 
        END AS most_common_vals, 
        CASE 1 
            WHEN stakind1 THEN stanumbers1 
            WHEN stakind2 THEN stanumbers2 
            WHEN stakind3 THEN stanumbers3 
            WHEN stakind4 THEN stanumbers4 
        END AS most_common_freqs, 
        CASE 2 
            WHEN stakind1 THEN stavalues1 
            WHEN stakind2 THEN stavalues2 
            WHEN stakind3 THEN stavalues3 
            WHEN stakind4 THEN stavalues4 
        END AS histogram_bounds, 
        CASE 3 
            WHEN stakind1 THEN stanumbers1[1] 
            WHEN stakind2 THEN stanumbers2[1] 
            WHEN stakind3 THEN stanumbers3[1] 
            WHEN stakind4 THEN stanumbers4[1] 
        END AS correlation 
    FROM sys_statistic s JOIN sys_class c ON (c.oid = s.starelid) 
         JOIN sys_attribute a ON (c.oid = attrelid AND attnum = s.staattnum) 
         LEFT JOIN sys_namespace n ON (n.oid = c.relnamespace) 
    WHERE NOT attisdropped AND has_column_privilege(c.oid, a.attnum, 'select');

REVOKE ALL on sys_statistic FROM public;

CREATE VIEW sys_locks AS 
    SELECT L.locktype, L.database, L.relation, C.relname as objname, L.page,  
	       L.tuple, L.virtualxid, L.transactionid, L.classid, L.objid, L.objsubid,
		   L.virtualtransaction as transaction, L.pid, L.mode, L.granted
    FROM sys_lock_status() AS L
    (locktype text, database oid, relation oid, page int4, tuple int2,
		virtualxid text, transactionid xid, classid oid, objid oid, objsubid int2,
		virtualtransaction text, pid int4, mode text, granted boolean)
		LEFT JOIN sys_class C ON L.relation=C.oid;

CREATE VIEW sys_cursors AS
    SELECT C.name, C.statement, C.is_holdable, C.is_binary,
           C.is_scrollable, C.creation_time
    FROM sys_cursor() AS C
         (name text, statement text, is_holdable boolean, is_binary boolean,
          is_scrollable boolean, creation_time timestamptz);

CREATE VIEW sys_prepared_xacts AS
    SELECT P.transaction, P.gid, P.prepared,
           U.rolname AS owner, D.datname AS database
    FROM sys_prepared_xact() AS P
    (transaction xid, gid text, prepared timestamptz, ownerid oid, dbid oid)
         LEFT JOIN sys_authid U ON P.ownerid = U.oid
         LEFT JOIN sys_database D ON P.dbid = D.oid;

CREATE VIEW sys_prepared_statements AS
    SELECT P.name, P.statement, P.prepare_time, P.parameter_types
    FROM sys_prepared_statement() AS P
    (name text, statement text, prepare_time timestamptz,
     parameter_types regtype[]);
CREATE VIEW sys_prepare_limit AS
    SELECT P.backend_id, P.prepare_limit, P.current_count
    FROM sys_prepare_limit() AS P
    (backend_id int, prepare_limit int, current_count int);

CREATE VIEW sys_plan_cache_info AS
    SELECT P.statement, P.ref_count, P.hit_count, P.prepare_time, P.parameter_types, P.plan_source, P.is_dead, P.cache_querydesc
    FROM sys_plan_cache_info() AS P
    (statement text, ref_count bigint, hit_count bigint, prepare_time timestamptz,
     parameter_types regtype[], plan_source text, is_dead boolean, cache_querydesc text);

CREATE VIEW sys_plan_cache_stat AS
	SELECT P.cache_fetches, P.cache_hits
	FROM sys_auto_plan_cache_stat() AS P
	(cache_fetches bigint, cache_hits bigint);

CREATE VIEW sys_settings AS 
    SELECT name, setting, unit, category, short_desc, extra_desc, decode(context,'internal', 'cluster', 'kingbase', 'system', 'backend', 'system', 'sighup', 'global', 'superuser', 'session', 'user', 'session') as context, vartype, source, min_val, max_val, user_visible
    FROM sys_show_all_settings() AS A 
    (name text, setting text, unit text, category text, short_desc text, extra_desc text,
     context text, vartype text, source text, min_val text, max_val text, user_visible text);

CREATE RULE sys_settings_u AS 
    ON UPDATE TO sys_settings 
    WHERE new.name = old.name DO 
    SELECT set_config(old.name, new.setting, 'f');

CREATE RULE sys_settings_n AS 
    ON UPDATE TO sys_settings 
    DO INSTEAD NOTHING;

GRANT SELECT ON sys_settings TO PUBLIC;

CREATE VIEW sys_timezone_abbrevs AS
    SELECT * FROM sys_timezone_abbrevs(null,null,null);

CREATE VIEW sys_timezone_names AS
    SELECT * FROM sys_timezone_names(null,null,null,null);

-- Statistics views

CREATE VIEW sys_stat_all_tables AS 
    SELECT 
            C.oid AS relid, 
            N.nspname AS schemaname, 
            C.relname AS relname, 
            sys_stat_get_numscans(C.oid) AS seq_scan, 
            sys_stat_get_tuples_returned(C.oid) AS seq_tup_read, 
            sum(ISNULL(sys_stat_get_numscans(I.indexrelid),0))::bigint AS idx_scan, 
            sum(ISNULL(sys_stat_get_tuples_fetched(I.indexrelid),0))::bigint +
                    sys_stat_get_tuples_fetched(C.oid) AS idx_tup_fetch, 
            sys_stat_get_tuples_inserted(C.oid) AS n_tup_ins, 
            sys_stat_get_tuples_updated(C.oid) AS n_tup_upd, 
            sys_stat_get_tuples_deleted(C.oid) AS n_tup_del,
            sys_stat_get_last_vacuum_time(C.oid) as last_vacuum,
            sys_stat_get_last_autovacuum_time(C.oid) as last_autovacuum,
            sys_stat_get_last_analyze_time(C.oid) as last_analyze,
            sys_stat_get_last_autoanalyze_time(C.oid) as last_autoanalyze
    FROM sys_class C LEFT JOIN 
         sys_index I ON C.oid = I.indrelid 
         LEFT JOIN sys_namespace N ON (N.oid = C.relnamespace) 
    WHERE C.relkind IN ('r', 't', 'm')
    GROUP BY C.oid, N.nspname, C.relname;

CREATE VIEW sys_stat_sys_tables AS 
    SELECT * FROM sys_stat_all_tables 
    WHERE schemaname IN ('SYS_CATALOG', 'SYS_TOAST', 'INFORMATION_SCHEMA');

CREATE VIEW sys_stat_user_tables AS 
    SELECT * FROM sys_stat_all_tables 
    WHERE schemaname NOT IN ('SYS_CATALOG', 'SYS_TOAST', 'INFORMATION_SCHEMA');

CREATE VIEW sys_statio_all_tables AS 
    SELECT 
            C.oid AS relid, 
            N.nspname AS schemaname, 
            C.relname AS relname, 
            sys_stat_get_blocks_fetched(C.oid) - 
                    sys_stat_get_blocks_hit(C.oid) AS heap_blks_read, 
            sys_stat_get_blocks_hit(C.oid) AS heap_blks_hit, 
            sum(ISNULL(sys_stat_get_blocks_fetched(I.indexrelid),0) - 
                    ISNULL(sys_stat_get_blocks_hit(I.indexrelid),0))::bigint AS idx_blks_read, 
            sum(ISNULL(sys_stat_get_blocks_hit(I.indexrelid),0))::bigint AS idx_blks_hit, 
            sys_stat_get_blocks_fetched(T.oid) - 
                    sys_stat_get_blocks_hit(T.oid) AS toast_blks_read, 
            sys_stat_get_blocks_hit(T.oid) AS toast_blks_hit, 
            sys_stat_get_blocks_fetched(X.oid) - 
                    sys_stat_get_blocks_hit(X.oid) AS tidx_blks_read, 
            sys_stat_get_blocks_hit(X.oid) AS tidx_blks_hit 
    FROM sys_class C LEFT JOIN 
            sys_index I ON C.oid = I.indrelid LEFT JOIN 
            sys_class T ON C.reltoastrelid = T.oid LEFT JOIN 
            sys_class X ON T.reltoastidxid = X.oid 
            LEFT JOIN sys_namespace N ON (N.oid = C.relnamespace) 
    WHERE C.relkind IN ('r', 't', 'm')
    GROUP BY C.oid, N.nspname, C.relname, T.oid, X.oid;

CREATE VIEW sys_statio_sys_tables AS 
    SELECT * FROM sys_statio_all_tables 
    WHERE schemaname IN ('SYS_CATALOG', 'SYS_TOAST', 'INFORMATION_SCHEMA');

CREATE VIEW sys_statio_user_tables AS 
    SELECT * FROM sys_statio_all_tables 
    WHERE schemaname NOT IN ('SYS_CATALOG', 'SYS_TOAST', 'INFORMATION_SCHEMA');

CREATE VIEW sys_stat_all_indexes AS 
    SELECT 
            C.oid AS relid, 
            I.oid AS indexrelid, 
            N.nspname AS schemaname, 
            C.relname AS relname, 
            I.relname AS indexrelname, 
            sys_stat_get_numscans(I.oid) AS idx_scan, 
            sys_stat_get_tuples_returned(I.oid) AS idx_tup_read, 
            sys_stat_get_tuples_fetched(I.oid) AS idx_tup_fetch 
    FROM sys_class C JOIN 
            sys_index X ON C.oid = X.indrelid JOIN 
            sys_class I ON I.oid = X.indexrelid 
            LEFT JOIN sys_namespace N ON (N.oid = C.relnamespace) 
    WHERE C.relkind IN ('r', 't', 'm');

CREATE VIEW sys_stat_sys_indexes AS 
    SELECT * FROM sys_stat_all_indexes 
    WHERE schemaname IN ('SYS_CATALOG', 'SYS_TOAST', 'INFORMATION_SCHEMA');

CREATE VIEW sys_stat_user_indexes AS 
    SELECT * FROM sys_stat_all_indexes 
    WHERE schemaname NOT IN ('SYS_CATALOG', 'SYS_TOAST', 'INFORMATION_SCHEMA');

CREATE VIEW sys_statio_all_indexes AS 
    SELECT 
            C.oid AS relid, 
            I.oid AS indexrelid, 
            N.nspname AS schemaname, 
            C.relname AS relname, 
            I.relname AS indexrelname, 
            sys_stat_get_blocks_fetched(I.oid) - 
                    sys_stat_get_blocks_hit(I.oid) AS idx_blks_read, 
            sys_stat_get_blocks_hit(I.oid) AS idx_blks_hit 
    FROM sys_class C JOIN 
            sys_index X ON C.oid = X.indrelid JOIN 
            sys_class I ON I.oid = X.indexrelid 
            LEFT JOIN sys_namespace N ON (N.oid = C.relnamespace) 
    WHERE C.relkind IN ('r', 't', 'm');

CREATE VIEW sys_statio_sys_indexes AS 
    SELECT * FROM sys_statio_all_indexes 
    WHERE schemaname IN ('SYS_CATALOG', 'SYS_TOAST', 'INFORMATION_SCHEMA');

CREATE VIEW sys_statio_user_indexes AS 
    SELECT * FROM sys_statio_all_indexes 
    WHERE schemaname NOT IN ('SYS_CATALOG', 'SYS_TOAST', 'INFORMATION_SCHEMA');

CREATE VIEW sys_statio_all_sequences AS 
    SELECT 
            C.oid AS relid, 
            N.nspname AS schemaname, 
            C.relname AS relname, 
            sys_stat_get_blocks_fetched(C.oid) - 
                    sys_stat_get_blocks_hit(C.oid) AS blks_read, 
            sys_stat_get_blocks_hit(C.oid) AS blks_hit 
    FROM sys_class C 
            LEFT JOIN sys_namespace N ON (N.oid = C.relnamespace) 
    WHERE C.relkind = 'S';

CREATE VIEW sys_statio_sys_sequences AS 
    SELECT * FROM sys_statio_all_sequences 
    WHERE schemaname IN ('SYS_CATALOG', 'SYS_TOAST', 'INFORMATION_SCHEMA');

CREATE VIEW sys_statio_user_sequences AS 
    SELECT * FROM sys_statio_all_sequences 
    WHERE schemaname NOT IN ('SYS_CATALOG', 'SYS_TOAST', 'INFORMATION_SCHEMA');

CREATE VIEW sys_stat_activity AS 
    SELECT 
            D.oid AS datid, 
            D.datname AS datname, 
            sys_stat_get_backend_pid(S.backendid) AS procpid, 
            sys_stat_get_backend_userid(S.backendid) AS usesysid, 
            U.rolname AS usename, 
            sys_stat_get_backend_activity(S.backendid) AS current_query,
            sys_stat_get_backend_waiting(S.backendid) AS waiting,
            sys_stat_get_backend_txn_start(S.backendid) AS txn_start,
            sys_stat_get_backend_activity_start(S.backendid) AS query_start,
            sys_stat_get_backend_start(S.backendid) AS backend_start,
            sys_stat_get_backend_client_addr(S.backendid) AS client_addr,
            sys_stat_get_backend_client_port(S.backendid) AS client_port
    FROM sys_database D, 
            (SELECT sys_stat_get_backend_idset() AS backendid) AS S, 
            sys_authid U 
    WHERE sys_stat_get_backend_dbid(S.backendid) = D.oid AND 
            sys_stat_get_backend_userid(S.backendid) = U.oid;

CREATE VIEW sys_stat_database AS 
    SELECT 
            D.oid AS datid, 
            D.datname AS datname, 
            sys_stat_get_db_numbackends(D.oid) AS numbackends, 
            sys_stat_get_db_xact_commit(D.oid) AS xact_commit, 
            sys_stat_get_db_xact_rollback(D.oid) AS xact_rollback, 
            sys_stat_get_db_blocks_fetched(D.oid) - 
                    sys_stat_get_db_blocks_hit(D.oid) AS blks_read, 
            sys_stat_get_db_blocks_hit(D.oid) AS blks_hit 
    FROM sys_database D;

--views about status of data files
CREATE VIEW sys_file AS
    SELECT *
    FROM sys_data_files(true) AS A(datid oid, spcid oid, fileid oid, initsize int, maxsize int,
     growth int, logicalname name, filename text, status bool, enable bool, createtime TIMESTAMPTZ);

CREATE VIEW sys_datafiles_orig AS
	SELECT
			fileid,
			logicalname,
			spcname,
			filename,
			initsize,
			maxsize,
			growth,
			currentblocks,
			(currentblocks - freeblocks) AS usedblocks,
			userblocks,
			freeblocks,
			status,
			enable
	FROM		 
		(SELECT 
				fileid,
				logicalname,
				spcname,
				filename,
				initsize,
				maxsize,
				growth,
				(SELECT count(*)
					FROM sys_file_blocks(df.datid,df.fileid) AS A(dbid oid, file oid, block int,status text)) AS currentblocks,
				(SELECT count(*)
				 	FROM sys_file_blocks(df.datid,df.fileid) AS A(dbid oid, file oid, block int,status text) 
			 	 	WHERE status='FREE PAGE') as freeblocks,
				 (SELECT count(*)
				 	FROM sys_file_blocks(df.datid,df.fileid) AS A(dbid oid, file oid, block int,status text) 
			 	 	WHERE status='DATA PAGE') as userblocks,
			 	df.status,
			 	df.enable
		FROM sys_file df, sys_tablespace ts
		WHERE df.datid = (select oid from sys_database where datname = current_database()) and df.spcid = ts.oid			
		ORDER BY spcname) AS tmp;

CREATE VIEW SYS_CATALOG.sys_datafiles AS
	SELECT
			fileid,
			logicalname,
			spcname,
			filename,
			initsize,
			maxsize,
			growth,
			currentblocks,
			(currentblocks - freeblocks) AS usedblocks,
			userblocks,
			freeblocks,
			status,
			enable
	FROM		 
		(SELECT 
				fileid,
				logicalname,
				spcname,
				filename,
				initsize,
				maxsize,
				growth,
				cast(allc as bigint) as currentblocks,
				cast(free as bigint) as freeblocks,
				cast(data as bigint) as userblocks,
				df.status,
			 	df.enable
		FROM sys_file df, sys_tablespace ts,
			(select * from sys_file_block_count((select oid from sys_database where datname = current_database()), 0, false) 
			a(dbid oid, file oid, gam integer, pfs integer, iam integer, data integer, free integer, allc integer)) as dc
		WHERE df.datid = (select oid from sys_database where datname = current_database()) and df.spcid = ts.oid
			and df.datid = dc.dbid and df.fileid = dc.file
		ORDER BY spcname) AS tmp;

CREATE VIEW sys_alldatafiles_orig AS
	SELECT 
			fileid,
			logicalname,
			datname, 
			filename, 
			initsize, 
			maxsize,
			growth,
			currentblocks, 
			(currentblocks - freeblocks) AS usedblocks,
			userblocks,
			freeblocks
	FROM 
			(SELECT logicalname, filename, initsize, 
				(SELECT count(*)
					FROM sys_file_blocks(df.datid,df.fileid) AS A(dbid oid, file oid, block int,status text)) AS currentblocks,
				(SELECT count(*)
				 	FROM sys_file_blocks(df.datid,df.fileid) AS A(dbid oid, file oid, block int,status text) 
			 	 	WHERE status='FREE PAGE') as freeblocks,
				 (SELECT count(*)
				 	FROM sys_file_blocks(df.datid,df.fileid) AS A(dbid oid, file oid, block int,status text) 
			 	 	WHERE status='DATA PAGE') as userblocks,  
				maxsize, growth, datname, fileid
		  	FROM sys_file df, sys_database db
		  	WHERE df.datid = db.oid
		  	ORDER BY logicalname) as tmp;

CREATE VIEW SYS_CATALOG.sys_alldatafiles AS
	SELECT 
			fileid,
			logicalname,
			datname, 
			filename, 
			initsize, 
			maxsize,
			growth,
			currentblocks, 
			(currentblocks - freeblocks) AS usedblocks,
			userblocks,
			freeblocks
	FROM 
			(SELECT logicalname, filename, initsize, 
				cast(allc as bigint) as currentblocks,
				cast(free as bigint) as freeblocks,
				cast(data as bigint) as userblocks,  
				maxsize, growth, datname, fileid
		  	FROM sys_file df, sys_database db, 
				(select * from sys_file_block_count(0, 0, false) 
				a(dbid oid, file oid, gam integer, pfs integer, iam integer, data integer, free integer, allc integer)) as dc
		  	WHERE df.datid = db.oid and df.datid = dc.dbid and df.fileid = dc.file
		  	ORDER BY logicalname) as tmp;

CREATE INTERNAL FUNCTION sys_file_freespaces(integer,integer)
RETURNS setof record AS '
DECLARE
	rec record;
	retval RECORD;
	start int;
	num int;
	i int;
	last  bool;
	now  bool;
BEGIN
	last := false;
	now := false;
	num := 0;
	i := 0;

	FOR rec IN SELECT * FROM sys_file_blocks($1,$2) as a(dbid oid,fileid oid,blockno int,status text) LOOP
		if rec.status = ''FREE PAGE''  then
			if last = false then
				start := i;
				num := 1;
			else
				num := num+1;
			end if;

			now := true;
			i := i+1;
			last := now;
		else
			i := i+1;
			now := false;

			if last = true then
				last := now;
				select into retval start, num;
				RETURN NEXT retval;
			else last := now;
			end if;
		 end if;
	END LOOP;
	if now = true then
		select into retval start, num;
		RETURN NEXT retval;
	end if;
	 
END;
' LANGUAGE plsql;

CREATE INTERNAL FUNCTION sys_file_freespaces_by_name(dbname name, filename name)
RETURNS setof record AS '
DECLARE
	rec record;
	retval record;
	fid int;
	dbid int;
BEGIN
	select into dbid oid from SYS_DATABASE where SYS_DATABASE.datname=dbname;
	if not found then
	    raise exception ''database "%" does not exist'',dbname;
	end if;
	select into fid fileid from sys_file where sys_file.datid = dbid and sys_file.logicalname=filename;
	if not found then
	    raise exception ''file "%" does not exist'',filename;
	end if;
	for rec in select * from sys_file_freespaces(dbid, fid) as a(blockno int, nblocks int) Loop
	   SELECT into retval rec.blockno, rec.nblocks;
	   RETURN NEXT retval;
	end loop;
END;
' LANGUAGE plsql;

CREATE INTERNAL FUNCTION sys_freespace()
RETURNS setof record AS '
DECLARE
	rec1 record;
	rec2 record;
	retval record;
BEGIN
	FOR rec1 IN SELECT * FROM sys_file df, sys_database db WHERE df.datid = db.oid LOOP
		FOR rec2 IN SELECT * from sys_file_freespaces(rec1.datid, rec1.fileid) as a(blockno int, nblocks int) LOOP
			SELECT into retval rec1.datname, rec1.logicalname, rec2.blockno, rec2.nblocks;
			RETURN NEXT retval;
		END LOOP;
	END LOOP;
END;
'LANGUAGE plsql;

CREATE VIEW sys_freespaces AS
	SELECT * 
	FROM sys_freespace() AS (datname name, logicalname name, startblock int, nblocks int);

CREATE INTERNAL FUNCTION sys_file_blocks_by_name(dbname name, filename name)
RETURNS setof record AS '
DECLARE
	rec record;
	retval RECORD;
	fid int;
	did int;
BEGIN
	select into did oid from SYS_DATABASE where SYS_DATABASE.datname=dbname;
	if not found then
	    raise exception ''database "%" does not exist'',dbname;
	end if;
	select into fid fileid from sys_file where sys_file.datid = did and sys_file.logicalname = filename;
	if not found then
	    raise exception ''file "%" does not exist'',filename;
	end if;
	for rec in select * from sys_file_blocks(did,fid)
	    	as a(dbid oid,fileid oid,blockno int,status text) Loop
		SELECT into retval rec.dbid,rec.fileid,rec.blockno,rec.status;
		RETURN NEXT retval;
	end loop;
END;
' LANGUAGE plsql;

CREATE OR REPLACE INTERNAL FUNCTION sys_file_objects_by_name(dbname name, filename name)
RETURNS setof record AS '
DECLARE
	rec		record;
	retval	record;
	fid int;
	did int;
BEGIN
	select into did oid from SYS_DATABASE where SYS_DATABASE.datname=dbname;
	if not found then
	    raise exception ''database "%" does not exist'',dbname;
	end if;
	select into fid fileid from sys_file where sys_file.datid = did and sys_file.logicalname=filename;
	if not found then
	    raise exception ''file "%" does not exist'',filename;
	end if;
	for rec in select * from sys_file_objects(did, fid) 
		as a(blockno int,reloid oid) Loop
	  SELECT into retval rec.blockno,rec.reloid;
	  RETURN NEXT retval;
	end loop;
END;
' LANGUAGE plsql;

--visibility map debug related function
CREATE INTERNAL FUNCTION sys_visibility_map_by_name(relname name)
RETURNS setof RECORD AS '
DECLARE
	rec			record;
	retval		record;
	relid		oid;
	dbid		oid;
	isshared	bool;
BEGIN
	select into relid oid, isshared relisshared from sys_class where sys_class.relname=relname;
    if not found then
        raise exception ''relation "%" does not exist'',relname;
    end if;
	if isshared then
		select into dbid oid from sys_database where datname= ''GLOBAL'';
	else 
		select into dbid oid from sys_database where datname= current_database();
	end if;

	for rec in select * from sys_visibility_map(dbid,relid) as a(vm_blk bigint, page_content text, vm_visiable_count int) Loop
		SELECT into retval rec.vm_blk, rec.page_content, rec.vm_visiable_count;	  
		RETURN NEXT retval;
	end loop;
END;
' LANGUAGE plsql;

CREATE INTERNAL FUNCTION sys_page_visibility_by_name(relname name)
RETURNS setof RECORD AS '
DECLARE
	rec			record;
	retval		record;
	tableoid	oid;
	dbid		oid;
	isshared	bool;
BEGIN
	select into tableoid oid, isshared relisshared from sys_class where sys_class.relname=relname;
	if not found then
		raise exception ''relation "%" does not exist'',relname;
	end if;
	if isshared then
		select into dbid oid from sys_database where datname= ''GLOBAL'';
	else 
		select into dbid oid from sys_database where datname= current_database();
	end if;
	for rec in select * from sys_page_visibility(dbid, tableoid) as (relblock bigint, vmblock bigint, pd_all_visible int2, vm_hint int2) Loop
		SELECT into retval rec.relblock, rec.vmblock, rec.pd_all_visible, rec.vm_hint;
		RETURN NEXT retval;
	end loop;
END;
' LANGUAGE plsql;

--object related storage status function
CREATE INTERNAL FUNCTION sys_object_blocks(relname name)
RETURNS setof record AS '
DECLARE
	rec		record;
	rec2	record;
	retval	record;
	filenode	int;
	dbname		text;
	dbid		int;
	isshared	bool;
BEGIN
	select into filenode relfilenode, isshared relisshared from sys_class where sys_class.relname=relname;
    if not found then
        raise exception ''relation "%" does not exist'',relname;
    end if;
	if isshared then
		select into dbid oid from sys_database where datname= ''GLOBAL'';
	else 
		select into dbid oid from sys_database where datname= current_database();
	end if;
	for rec in select * from sys_object_iams(dbid,filenode) as a(fileblock int) Loop
		for rec2 in select * from sys_iam_blocks(dbid,rec.fileblock) as a(fileid oid, blockno int) loop
			SELECT into retval rec2.fileid, rec2.blockno;	  
			RETURN NEXT retval;
		end loop;
	end loop;
END;
' LANGUAGE plsql;

CREATE INTERNAL FUNCTION sys_object_iams_by_name(relname name)
RETURNS setof record AS '
DECLARE
	rec		record;
	retval	record;
	filenode	int;
	dbid		int;
	isshared	bool;
BEGIN
	select into filenode relfilenode, isshared relisshared from SYS_CLASS where SYS_CLASS.relname=relname;
	if not found then
	    raise exception ''relation "%" does not exist'',relname;
	end if;
	if isshared then
		select into dbid oid from sys_database where datname= ''GLOBAL'';
	else 
		select into dbid oid from sys_database where datname= current_database();
	end if;
	for rec in select * from sys_object_iams(dbid,filenode) as a(fileblock int) loop
	  SELECT into retval rec.fileblock;
	  RETURN NEXT retval;
	end loop;
END;
' LANGUAGE plsql;

--redo log related view and function
CREATE VIEW sys_redologs AS
    SELECT  fileid, logicalname, filename, size,
    CASE WHEN logid=(
        select max(logid) from (
            SELECT logid
            FROM sys_redologs() AS a
                (fileid oid, isactive int, logid oid, size int, 
                logicalname text, filename text)
        ) AS BAR where isactive=1) THEN 'CURRENT'
    WHEN isactive=1 THEN 'ACTIVE'
    ELSE 'NOACTIVE'
    END as state
    FROM (
        SELECT  fileid, logicalname, filename, size, isactive, logid
        FROM sys_redologs() AS a
        (fileid oid, isactive int, logid oid, size int, 
        logicalname text, filename text)
        ) AS FOO; 

CREATE INTERNAL FUNCTION sys_get_redologpath() RETURNS text
	AS $$ SELECT sys_get_dbpath() || '/REDOLOG' $$
	LANGUAGE SQL;

--function to return default data file path
CREATE INTERNAL FUNCTION sys_get_datafilepath() RETURNS text
	AS $$ SELECT sys_get_dbpath() || '/DB' $$
	LANGUAGE SQL;

--online backup info in history
CREATE or REPLACE VIEW sys_backupinfo AS
    SELECT bakTimeline, 
        bakBeginLogid, bakBeginOffset, bakEndLogid, bakEndOffset, 
        bakUser, bakName, bakBaseName, 
        CASE bakTypeValue 
            WHEN 20 THEN 'Online_full_backup'
            WHEN 21 THEN 'Online_differential_increment_backup'
            WHEN 22 THEN 'Online_cumulative_increment_backup'
            WHEN 30 THEN 'Offline_full_backup'
            WHEN 31 THEN 'Offline_differential_increment_backup'
            WHEN 32 THEN 'Offline_cumulative_increment_backup'
        END AS bakType, 
        bakBeginTime, bakPath, bakComment , bakEndTime,
        bakCkpLogid, bakCkpOffset
    FROM sys_backupinfo() AS a (bakTimeline oid, 
        bakBeginLogid oid, bakBeginOffset oid, bakEndLogid oid, bakEndOffset oid, 
        bakUser text, bakName text, bakBaseName text, bakTypeValue int, 
        bakBeginTime text, bakPath text, bakComment text, bakEndTime text,
        bakCkpLogid oid, bakCkpOffset oid) 
   WHERE LENGTH(BAKENDTIME)!=0;

--online backuping info
CREATE VIEW sys_bakinginfo AS
   SELECT  type, logicalIdentifier, startTime 
   FROM sys_bakinginfo() AS a (type text, logicalIdentifier text, startTime text);

--view related partition
CREATE VIEW	sys_table_partitions (schemaname, tablename, partitionname,
                            highvalue, highvaluelength, partitionposition, tablespacename)
    AS
	SELECT n.nspname, l.relname, 
           case strpos(c.relname,'_PRT_') when 1 then SUBSTRING(c.relname,INSTR(c.relname,'_',1,3)+1) else c.relname end,
		   p.partboundval,
	       length(p.partboundval), p.partpos, s.spcname
    FROM sys_partition p, sys_class c, sys_class l, sys_namespace n, sys_tablespace s
    WHERE p.partitionrelid = c.oid AND p.partrelid = l.oid
          AND l.relnamespace = n.oid and c.reltablespace = s.oid
		  AND l.relkind = 'r' AND c.relkind = 'r' AND (l.relparttyp = 't' OR l.relparttyp = 'v');

CREATE VIEW	sys_index_partitions (schemaname, indexname, partitionname, tablespacename)
    AS
	SELECT n.nspname, l.relname, c.relname, s.spcname
    FROM sys_partition p, sys_class c, sys_class l, sys_namespace n, sys_tablespace s
    WHERE p.partitionrelid = c.oid AND p.partrelid = l.oid
          AND l.relnamespace = n.oid and c.reltablespace = s.oid
		  AND l.relkind = 'i' AND c.relkind = 'i' AND l.relparttyp = 't';

CREATE VIEW sys_parttables (parentname, tablename, schemaname, partitiontype,
  partitioncount, partitionkeycount, partitionkey, tablespacedef)
  AS
  SELECT case c.relparttyp when 'p' then sys_get_partition_base(p.prelid) when 't' then '' end,
         case strpos(c.relname,'_PRT_') when 1 then SUBSTRING(c.relname,INSTR(c.relname,'_',1,3)+1) else c.relname end,
         n.nspname, 
         case p.prelmethod when 'r' then 'RANGE' when 'l' then 'LIST' when 'h' then 'HASH' when 'c' then 'COLUMN' end,
         p.prelnparts, p.prelnkeys, 
         sys_get_partitionkeys(c.oid),
         t.spcname
  FROM sys_class c, sys_partclass p, sys_namespace n, sys_tablespace t
  WHERE c.relnamespace = n.oid and c.oid = p.prelid and c.reltablespace = t.oid;

--related subpartition
CREATE VIEW	sys_table_subpartitions (schemaname, tablename, partitionname, subpartitionname,
                            highvalue, highvaluelength, subpartitionposition, tablespacename)
    AS
	SELECT n.nspname, sys_get_partition_base(p.partitionrelid),
           case strpos(l.relname,'_PRT_') when 1 then SUBSTRING(l.relname,INSTR(l.relname,'_',1,3)+1) else l.relname end, 
           case strpos(c.relname,'_PRT_') when 1 then SUBSTRING(c.relname,INSTR(c.relname,'_',1,3)+1) else c.relname end, 
           p.partboundval,
	       length(p.partboundval), p.partpos, s.spcname
    FROM sys_partition p, sys_class c, sys_class l, sys_namespace n, sys_tablespace s
    WHERE p.partitionrelid = c.oid AND p.partrelid = l.oid
          AND l.relnamespace = n.oid and c.reltablespace = s.oid
		  AND l.relkind = 'r' AND c.relkind = 'r' AND l.relparttyp = 'p';

CREATE VIEW	sys_index_subpartitions (schemaname, indexname, subpartitionname, tablespacename)
    AS
	SELECT n.nspname, l.relname, c.relname, s.spcname
    FROM sys_partition p, sys_class c, sys_class l, sys_namespace n, sys_tablespace s
    WHERE p.partitionrelid = c.oid AND p.partrelid = l.oid
          AND l.relnamespace = n.oid and c.reltablespace = s.oid
		  AND l.relkind = 'i' AND c.relkind = 'i' AND l.relparttyp = 'p';

CREATE OR REPLACE INTERNAL function sys_get_typmod(rel Oid, att_no int) 
returns setof record LANGUAGE plsql as 
'DECLARE
	rec		record;
	retval	record;
begin
	for rec in SELECT 
			(CASE	WHEN atttypid = 8098		--tinyint
						THEN 3
					WHEN atttypid = 21			--smallint
						THEN 5
					WHEN atttypid = 23			--int
						THEN 10
					WHEN atttypid = 20			--bigint
						THEN 19
					WHEN atttypid = 700			--real
						THEN 7
					WHEN atttypid = 701			--double
						THEN 15
					WHEN atttypid = 1700		--numeric
						THEN (CASE	WHEN atttypmod <> -1 
										THEN (((atttypmod - 4) >> 16) & 65535) 
							  END)
					WHEN atttypid IN (1042, 1043) --char, varchar
						THEN (CASE	WHEN atttypmod > -1 
										THEN atttypmod - 4 
									ELSE (- atttypmod - 4)  --char(n byte) 
							  END)
					WHEN atttypid = 17				--bytea
						THEN 64000
					WHEN atttypid IN (25, 90, 91)	--text, blob, clob
						THEN 2147483647
					WHEN atttypid = 16				--bool
						THEN 1
					WHEN atttypid IN (1560, 1562)			--bit, bit varying
						THEN atttypmod
					WHEN atttypid = 91						--bit varying
						THEN 2147483647
					WHEN atttypid = 1082					--date
						THEN 10
					WHEN atttypid = 1083					--time
						THEN (CASE	WHEN atttypmod = -1 
										THEN 15
									WHEN atttypmod = 0
										THEN 8  
									ELSE (atttypmod + 9)
							  END)
					WHEN atttypid = 1266					--time with time zone
						THEN (CASE	WHEN atttypmod = -1 
										THEN 18
									WHEN atttypmod = 0
										THEN 11  
									ELSE (atttypmod + 12)
							  END)
					WHEN atttypid = 1114					--timestamp
						THEN (CASE	WHEN atttypmod = -1 
										THEN 26
									WHEN atttypmod = 0
										THEN 19  
									ELSE (atttypmod + 20)
							  END)
					WHEN atttypid = 1184					--timestamp with time zone
						THEN (CASE	WHEN atttypmod = -1 
										THEN 29
									WHEN atttypmod = 0
										THEN 22  
									ELSE (atttypmod + 23)
							  END)
					WHEN atttypid = 1186					--interval
						THEN (CASE	-- interval year, interval month, interval day, interval hour, interval minitue
									WHEN ((atttypmod >> 16) & 32767) IN (1 << 1, 1 << 2, 1 << 3, 1 << 10, 1 << 11)
										THEN sys_interval_prec1(atttypmod)
									-- interval year to month
									WHEN ((atttypmod >> 16) & 32767) = ((1 << 1) | (1 << 2))
										THEN (sys_interval_prec1(atttypmod) + 3)
									-- interval second
									WHEN ((atttypmod >> 16) & 32767) = (1 << 12)
										THEN	(CASE	WHEN sys_interval_prec2(atttypmod) = 0
															THEN sys_interval_prec1(atttypmod)
														ELSE (sys_interval_prec1(atttypmod) + sys_interval_prec2(atttypmod) + 1)
												END)
									-- interval day to second
									WHEN ((atttypmod >> 16) & 32767) = ((1 << 3) | (1 << 10) | (1 << 11) | (1 << 12))
										THEN	(CASE	WHEN sys_interval_prec2(atttypmod) = 0
															THEN sys_interval_prec1(atttypmod) + 9
														ELSE (sys_interval_prec1(atttypmod) + sys_interval_prec2(atttypmod) + 10)
												END)
									ELSE 0
							  END)
					ELSE 0
		      END) AS LEN,
		      
			(CASE	WHEN atttypid = 8098		--tinyint
						THEN 3
					WHEN atttypid = 21			--smallint
						THEN 5
					WHEN atttypid = 23			--int
						THEN 10
					WHEN atttypid = 20			--bigint
						THEN 19
					WHEN atttypid = 700			--real
						THEN 7
					WHEN atttypid = 701			--double
						THEN 15
					WHEN atttypid = 1700		--numeric
						THEN (CASE	WHEN atttypmod <> -1 
										THEN (((atttypmod - 4) >> 16) & 65535) 
									ELSE 0 
							  END)
					WHEN atttypid IN (1042, 1043) --char, varchar
						THEN (CASE	WHEN atttypmod > -1 
										THEN (atttypmod - 4) 
									ELSE (- atttypmod - 4)  --char(n byte) 
							  END)
					WHEN atttypid = 17				--bytea
						THEN 64000
					WHEN atttypid IN (25, 90, 91)	--text, blob, clob
						THEN 2147483647
					WHEN atttypid = 16				--bool
						THEN 1
					WHEN atttypid IN (1560, 1562)			--bit, bit varying
						THEN atttypmod
					WHEN atttypid = 91						--bit varying
						THEN 2147483647
					WHEN atttypid = 1082					--date
						THEN 10
					WHEN atttypid = 1083					--time
						THEN (CASE	WHEN atttypmod = -1 
										THEN 15
									WHEN atttypmod = 0
										THEN 8  
									ELSE (atttypmod + 9)
							  END)
					WHEN atttypid = 1266					--time with time zone
						THEN (CASE	WHEN atttypmod = -1 
										THEN 18
									WHEN atttypmod = 0
										THEN 11  
									ELSE (atttypmod + 12)
							  END)
					WHEN atttypid = 1114					--timestamp
						THEN (CASE	WHEN atttypmod = -1 
										THEN 26
									WHEN atttypmod = 0
										THEN 19  
									ELSE (atttypmod + 20)
							  END)
					WHEN atttypid = 1184					--timestamp with time zone
						THEN (CASE	WHEN atttypmod = -1 
										THEN 29
									WHEN atttypmod = 0
										THEN 22  
									ELSE (atttypmod + 23)
							  END)
					WHEN atttypid = 1186					--interval
						THEN sys_interval_prec1(atttypmod)
					ELSE 0
		    END) AS PRECISION,
		 		
			(CASE 	WHEN atttypid = 1700		--numeric
						THEN (CASE	WHEN atttypmod <> -1 
										THEN ((atttypmod - 4) & 65535) 
									ELSE 0 
							  END)
					WHEN atttypid = 1186	--interval
						THEN (CASE	-- interval second, interval day to second
									WHEN ((atttypmod >> 16) & 32767) IN (1 << 12, ((1 << 3) | (1 << 10) | (1 << 11) | (1 << 12)))
										THEN sys_interval_prec2(atttypmod)
									ELSE 0
							  END)
					ELSE 0
			END) AS SCALE

		FROM SYS_ATTRIBUTE WHERE ATTRELID = rel AND ATTNUM = att_no ORDER BY ATTNUM
		
	LOOP
	  SELECT INTO RETVAL IFNULL(REC.LEN, 0), IFNULL(REC.PRECISION, 0), IFNULL(REC.SCALE, 0);
	  RETURN NEXT RETVAL;
	END LOOP;
	
	RETURN;
END;';

CREATE VIEW sys_buffers AS 
	select * from sys_buffers() AS (free_dirty_page bigint, free_clean_page bigint, 
	 used_dirty_page bigint, used_clean_page bigint);

-- USER_DBLINKS : current_user's dblink are visible
CREATE VIEW USER_DBLINKS AS
SELECT	sys_get_userbyid(slnk.lnkowner) AS owner,
		slnk.lnkname AS db_link, 
		slnk.lnkuser AS username,
		slnk.lnksrc AS host,
		snsp.nspname AS namespace,
		slnk.lnkcreated::timestamp(0) AS created
FROM sys_dblink slnk, sys_namespace snsp
WHERE slnk.lnknamespace = snsp.oid AND sys_get_userbyid(slnk.lnkowner) = CURRENT_USER
ORDER BY owner, db_link, username, host, namespace, created;

-- ALL_DBLINKS : all public and current_user's dblink are visible
CREATE VIEW ALL_DBLINKS AS
SELECT	sys_get_userbyid(slnk.lnkowner) AS owner,
		slnk.lnkname AS db_link, 
		slnk.lnkuser AS username,
		slnk.lnksrc AS host,
		snsp.nspname AS namespace,
		slnk.lnkcreated::timestamp(0) AS created
FROM sys_dblink slnk, sys_namespace snsp
WHERE slnk.lnknamespace = snsp.oid AND (slnk.lnkpublic  = 't' OR sys_get_userbyid(slnk.lnkowner) = CURRENT_USER)
ORDER BY owner, db_link, username, host, namespace, created;

-- DBA_DBLINKS : all existed dblink are visible
CREATE VIEW DBA_DBLINKS AS
SELECT	sys_get_userbyid(slnk.lnkowner) AS owner,
		slnk.lnkname AS db_link, 
		slnk.lnkuser AS username,
		slnk.lnksrc AS host,
		snsp.nspname AS namespace,
		slnk.lnkcreated::timestamp(0) AS created
FROM sys_dblink slnk, sys_namespace snsp
WHERE slnk.lnknamespace = snsp.oid
ORDER BY owner, db_link, username, host, namespace, created;

-- sys_connidents used to lookup all available connect identifier 
-- from sys_dblink.conf
CREATE VIEW sys_connidents AS
    SELECT 	connident.name, 
			connident.drivertype, 
			connident.drivername,
			connident.host, 
			connident.port, 
			connident.dbname, 
			connident.extendedproperties
    FROM sys_connident() AS connident
         (name text, drivertype text, drivername text, host text,
          port text, dbname text, extendedproperties text);

CREATE VIEW sys_waitevent AS
	 SELECT 	pid, user_typeid, event_type, event_type_name, cast(waittime as numeric(38,6)), waitnum, dummy
	 FROM       sys_waitevent()
	 AS 
				(pid int, user_typeid int, event_type int, event_type_name text, waittime double, waitnum int, dummy bigint) 
	 WHERE    	(waittime + waitnum + dummy) != 0;         

CREATE VIEW sys_sessionwait AS
	SELECT
	SYS_SESSIONWAIT.PID,  
  	SYS_SESSIONWAIT.EVENT_TYPE, 
	SYS_SESSIONWAIT.EVENT_TYPE_NAME, 
	SYS_SESSIONWAIT.WAITTIME as "WAITTIME(ms)", 
	SYS_SESSIONWAIT.STATUS
	FROM SYS_SESSIONWAIT() SYS_SESSIONWAIT(PID INT, EVENT_TYPE INT, EVENT_TYPE_NAME TEXT, WAITTIME FLOAT, STATUS INT)
	WHERE  WAITTIME != 0;  

CREATE VIEW sys_sql_records AS
	SELECT
	SYS_SQL_RECORDS.SQL,  
	SYS_SQL_RECORDS.COMMAND_TYPE, 
  	SYS_SQL_RECORDS.START_TIME, 
	SYS_SQL_RECORDS.END_TIME, 
	SYS_SQL_RECORDS.TOTAL_TIME as "TOTAL_TIME(ms)",
	SYS_SQL_RECORDS.DISK_READS,
	SYS_SQL_RECORDS.BUFFER_HITS,
	SYS_SQL_RECORDS.RUN_TIME_MEMORY as "RUN_TIME_MEMORY(KB)",
	SYS_SQL_RECORDS.ROWS_PROCESSED,
	SYS_SQL_RECORDS.USER_IO_WAIT_TIME as "USER_IO_WAIT_TIME(ms)",
	SYS_SQL_RECORDS.PARSE_TIME as "PARSE_TIME(ms)",
	SYS_SQL_RECORDS.ANALYZE_TIME as "ANALYZE_TIME(ms)",
	SYS_SQL_RECORDS.REWRITE_TIME as "REWRITE_TIME(ms)",
	SYS_SQL_RECORDS.PLAN_TIME as "PLAN_TIME(ms)",
	SYS_SQL_RECORDS.CPU_TIME as "CPU_TIME(ms)"
	FROM SYS_SQL_RECORDS() SYS_SQL_RECORDS(SQL TEXT, COMMAND_TYPE TEXT, START_TIME  TIMESTAMP WITH TIME ZONE, END_TIME  TIMESTAMP WITH TIME ZONE, TOTAL_TIME BIGINT, DISK_READS BIGINT, 
	BUFFER_HITS BIGINT, RUN_TIME_MEMORY BIGINT, ROWS_PROCESSED BIGINT, USER_IO_WAIT_TIME BIGINT, PARSE_TIME BIGINT, ANALYZE_TIME BIGINT, REWRITE_TIME BIGINT, PLAN_TIME BIGINT, CPU_TIME BIGINT)
	WHERE (CHAR_LENGTH(SQL) != 0) ORDER BY SYS_SQL_RECORDS.START_TIME;
  
    
CREATE VIEW sys_sql_history AS
	SELECT
	SYS_SQL_HISTORY.SQL,  
	SYS_SQL_HISTORY.COMMAND_TYPE, 
  	SYS_SQL_HISTORY.START_TIME, 
	SYS_SQL_HISTORY.END_TIME, 
	SYS_SQL_HISTORY.TOTAL_TIME as "TOTAL_TIME(ms)",
	SYS_SQL_HISTORY.DISK_READS,
	SYS_SQL_HISTORY.BUFFER_HITS,
	SYS_SQL_HISTORY.RUN_TIME_MEMORY as "RUN_TIME_MEMORY(KB)",
	SYS_SQL_HISTORY.ROWS_PROCESSED,
	SYS_SQL_HISTORY.USER_IO_WAIT_TIME as "USER_IO_WAIT_TIME(ms)",
	SYS_SQL_HISTORY.PARSE_TIME as "PARSE_TIME(ms)",
	SYS_SQL_HISTORY.ANALYZE_TIME as "ANALYZE_TIME(ms)",
	SYS_SQL_HISTORY.REWRITE_TIME as "REWRITE_TIME(ms)",
	SYS_SQL_HISTORY.PLAN_TIME as "PLAN_TIME(ms)",
	SYS_SQL_HISTORY.CPU_TIME as "CPU_TIME(ms)"
	FROM SYS_SQL_HISTORY() SYS_SQL_HISTORY(SQL TEXT, COMMAND_TYPE TEXT, START_TIME  TIMESTAMP WITH TIME ZONE, END_TIME  TIMESTAMP WITH TIME ZONE, TOTAL_TIME BIGINT, DISK_READS BIGINT, 
	BUFFER_HITS BIGINT, RUN_TIME_MEMORY BIGINT, ROWS_PROCESSED BIGINT, USER_IO_WAIT_TIME BIGINT, PARSE_TIME BIGINT, ANALYZE_TIME BIGINT, REWRITE_TIME BIGINT, PLAN_TIME BIGINT, CPU_TIME BIGINT)
	WHERE (CHAR_LENGTH(SQL) != 0) ORDER BY SYS_SQL_HISTORY.START_TIME;  

-- audit views
CREATE VIEW sys_audit_maps AS
    SELECT *
    FROM audit_option_map() AS A(action int, name text);

CREATE VIEW sys_actions AS
    SELECT * FROM sys_audit_maps WHERE action < 300 OR action BETWEEN 500 AND 502;

CREATE VIEW audit_actions AS
	SELECT * FROM sys_actions;

CREATE VIEW sys_audit_object_type_map AS
    SELECT *
    FROM audit_object_type_map() AS O(optid int, objtype text);

CREATE VIEW sys_stmt_audit_opts(database_name, user_name, audit_option,
        success, failure, proxy_name) AS
    SELECT
		db.datname,
        CASE
            WHEN a.audsetuser = 0 THEN null
            ELSE u.usename
        END AS user_name,
        m.name AS audit_option,
        CASE
            WHEN a.audsetsuccess = 'a' THEN 'BY ACCESS'
            WHEN a.audsetsuccess = 's' THEN 'BY SESSION'
        END,
        CASE
            WHEN a.audsetfailure = 'a' THEN 'BY ACCESS'
            WHEN a.audsetfailure = 's' THEN 'BY SESSION'
        END,
        CAST( '' AS TEXT)
    FROM sys_audset a LEFT JOIN sys_user u ON (u.usesysid = a.audsetuser)
        LEFT JOIN sys_audit_maps m ON (a.audsetaction = m.action)
		LEFT JOIN (select 0 as oid,'ALL DATABASE' as datname 
				   union all 
				   select oid,datname from sys_database
				  ) db ON (a.audsetdatabase = db.oid)
	WHERE a.audsetaction NOT BETWEEN 500 AND 502
    ORDER BY user_name, audit_option;

CREATE VIEW dba_stmt_audit_opts AS
    SELECT user_name, audit_option,success, failure, proxy_name 
	FROM sys_stmt_audit_opts
	WHERE database_name = current_database() OR database_name = 'ALL DATABASE';

CREATE VIEW sys_priv_audit_opts(database_name, user_name, privilege,
        success, failure, proxy_name) AS
    SELECT
	db.datname,
        CASE
            WHEN a.audsetuser = 0 THEN null
            ELSE u.usename
        END AS user_name,
        m.name AS privilege,
        CASE
            WHEN a.audsetsuccess = 'a' THEN 'BY ACCESS'
            WHEN a.audsetsuccess = 's' THEN 'BY SESSION'
        END,
        CASE
            WHEN a.audsetfailure = 'a' THEN 'BY ACCESS'
            WHEN a.audsetfailure = 's' THEN 'BY SESSION'
        END,
        CAST( '' AS TEXT)
    FROM sys_audset a LEFT JOIN sys_user u ON (u.usesysid = a.audsetuser)
        LEFT JOIN sys_audit_maps m ON (a.audsetaction = m.action)
          LEFT JOIN (select 0 as oid,'ALL DATABASE' as datname 
					 union all 
					 select oid,datname from sys_database
					) db ON (a.audsetdatabase = db.oid)
	WHERE a.audsetaction BETWEEN 500 AND 502 
    ORDER BY user_name, privilege;

CREATE VIEW dba_priv_audit_opts AS
    SELECT * FROM sys_priv_audit_opts;

CREATE OR REPLACE INTERNAL FUNCTION get_args_list(funcoid INT) RETURNS TEXT AS '
DECLARE 
	nargs INT;
	args TEXT;
	results TEXT DEFAULT ''''; 
BEGIN
	SELECT PRONARGS INTO nargs FROM sys_proc where oid = funcoid;
	IF nargs IS NULL THEN
		RETURN NULL;
	END IF;

	FOR i IN 0..(nargs-1) LOOP
		SELECT typname INTO args FROM sys_type t, sys_proc p WHERE t.oid = p.proargtypes[i] AND p.oid = funcoid;
		IF args IS NULL THEN
			RETURN NULL;
		END IF;
		IF i = 0 THEN
			results := args;
		ELSE
			results := results || '','' || args; 
		END IF;
	END LOOP;

	RETURN results;
END;
' LANGUAGE plsql;

-- SYS_OBJ_AUDIT_OPTS
CREATE VIEW sys_obj_audit_opts(owner, obj_name, schema_name, obj_type, obj_args,
        alt, ana, aud, clu, com, cop,
		del, exe, gra, ind, ins, loc,
		sel, tru, upd, vac, cre, rea,
		wri, fbk, ref, ren
) AS
    SELECT

		CASE
            WHEN (a.audobjkind = 'p') or (a.audobjkind = 'f') THEN SYS_GET_USERBYID(p.proowner)
			WHEN (a.audobjkind = 's') THEN SYS_GET_USERBYID(pac.pkgowner)
            ELSE SYS_GET_USERBYID(c.relowner)
        END as owner,
        CASE
            WHEN (a.audobjkind = 'p') or (a.audobjkind = 'f') THEN p.proname
            WHEN (a.audobjkind = 's') THEN pac.pkgname
            ELSE c.relname
        END as obj_name,
        n.nspname,
        CASE
            WHEN a.audobjkind = 'r' THEN 'TABLE'
            WHEN a.audobjkind = 'S' THEN 'SEQUENCE'
            WHEN a.audobjkind = 'v' THEN 'VIEW'
            WHEN a.audobjkind = 'p' THEN 'PROCEDURE'
            WHEN a.audobjkind = 'f' THEN 'FUNCTION'
            WHEN a.audobjkind = 's' THEN 'PACKAGE'
            WHEN a.audobjkind = 'i' THEN 'INDEX'
            ELSE 'UNKNOW TYPE'
        END,
        CASE
            WHEN (a.audobjkind = 'p') OR (a.audobjkind = 'f') THEN get_args_list(p.oid)
            ELSE null
        END,
        substr(a.audobjmap, 1, 1) || '/' || substr(a.audobjmap, 2, 1),
        substr(a.audobjmap, 3, 1) || '/' || substr(a.audobjmap, 4, 1),
        substr(a.audobjmap, 5, 1) || '/' || substr(a.audobjmap, 6, 1),
        substr(a.audobjmap, 7, 1) || '/' || substr(a.audobjmap, 8, 1),
        substr(a.audobjmap, 9, 1) || '/' || substr(a.audobjmap, 10, 1),
        substr(a.audobjmap, 11, 1) || '/' || substr(a.audobjmap, 12, 1),
        substr(a.audobjmap, 13, 1) || '/' || substr(a.audobjmap, 14, 1),
        substr(a.audobjmap, 15, 1) || '/' || substr(a.audobjmap, 16, 1),
        substr(a.audobjmap, 17, 1) || '/' || substr(a.audobjmap, 18, 1),
        substr(a.audobjmap, 19, 1) || '/' || substr(a.audobjmap, 20, 1),
        substr(a.audobjmap, 21, 1) || '/' || substr(a.audobjmap, 22, 1),
        substr(a.audobjmap, 23, 1) || '/' || substr(a.audobjmap, 24, 1),
        substr(a.audobjmap, 25, 1) || '/' || substr(a.audobjmap, 26, 1),
        substr(a.audobjmap, 27, 1) || '/' || substr(a.audobjmap, 28, 1),
        substr(a.audobjmap, 29, 1) || '/' || substr(a.audobjmap, 30, 1),
        substr(a.audobjmap, 31, 1) || '/' || substr(a.audobjmap, 32, 1),
        CAST( '' AS TEXT),
        CAST( '' AS TEXT),
        CAST( '' AS TEXT),
        CAST( '' AS TEXT),
        CAST( '' AS TEXT),
        CAST( '' AS TEXT)
    FROM sys_audobj a LEFT JOIN sys_class c ON (a.audobjobj = c.oid)
        LEFT JOIN sys_proc p ON (a.audobjobj = p.oid)
		LEFT JOIN sys_package pac ON (a.audobjobj = pac.oid), sys_namespace n
    WHERE c.relnamespace = n.oid OR p.pronamespace = n.oid OR pac.pkgnamespace = n.oid
    ORDER BY obj_name;

    
CREATE VIEW dba_obj_audit_opts AS SELECT * FROM sys_obj_audit_opts;
    
CREATE OR REPLACE INTERNAL FUNCTION GETOBJTYPE(typeId int) RETURNS TEXT LANGUAGE PLSQL
AS '
DECLARE
	result TEXT;
BEGIN
			SELECT
			 (CASE
				WHEN typeId = 0 THEN ''AGGREGATE''
				WHEN typeId = 1 THEN ''CAST''
				WHEN typeId = 2 THEN ''CATALOG''
				WHEN typeId = 3 THEN ''COLUMN''
				WHEN typeId = 4 THEN ''CONSTRAINT''
				WHEN typeId = 5 THEN ''CONVERSION''
				WHEN typeId = 6 THEN ''DATABASE''
				WHEN typeId = 7 THEN ''DATABASELINK''
				WHEN typeId = 8 THEN ''DOMAIN''
				WHEN typeId = 9 THEN ''FUNCTION''
				WHEN typeId = 10 THEN ''INDEX''
				WHEN typeId = 11 THEN ''INTERNALFUNCTION''
				WHEN typeId = 12 THEN ''LANGUAGE''
				WHEN typeId = 13 THEN ''LARGEOBJECT''
				WHEN typeId = 14 THEN ''OPCLASS''
				WHEN typeId = 15 THEN ''OPERATOR''
				WHEN typeId = 16 THEN ''PACKAGE''
				WHEN typeId = 17 THEN ''PACKAGE_BODY''
				WHEN typeId = 18 THEN ''PARTITION''
				WHEN typeId = 19 THEN ''PGFILES''
				WHEN typeId = 20 THEN ''PROCEDURE''
				WHEN typeId = 21 THEN ''ROLE''
				WHEN typeId = 22 THEN ''RULE''
				WHEN typeId = 23 THEN ''SCHEMA''
				WHEN typeId = 24 THEN ''SEQUENCE''
				WHEN typeId = 25 THEN ''SUBPARTITION''
				WHEN typeId = 26 THEN ''TABLE''
				WHEN typeId = 27 THEN ''TABLESPACE''
				WHEN typeId = 28 THEN ''TRIGGER''
				WHEN typeId = 29 THEN ''TSCONFIGURATION''
				WHEN typeId = 30 THEN ''TSDICTIONARY''
				WHEN typeId = 31 THEN ''TSPARSER''
				WHEN typeId = 32 THEN ''TSTEMPLATE''
				WHEN typeId = 33 THEN ''TYPE''
				WHEN typeId = 34 THEN ''USER''
				WHEN typeId = 35 THEN ''VIEW''
				WHEN typeId = 36 THEN ''MATERIALIZED VIEW''
				ELSE ''UNKNOW TYPE''
			END) INTO result;
	return result;
END;
';

-- SYS_AUDIT_TRAIL
CREATE VIEW sys_audit_trail
        (os_username, userid, username, userhost, userip,
		userport, terminal, timestamp, owner, obj_name, obj_type,
		schema_name, dbid, db_name, action, action_name, new_owner,
		new_name, grantee, audit_option, ses_actions, comment_text,
		sessionid, entryid, logoff_time, sql_text, grant_option, admin_option,
		is_grant, returncode, obj_privilege, sys_privilege, priv_used,
		client_id, econtext_id, extended_timestamp, global_uid,
		os_process, transactionid, sql_bind, statementid, scn, instance_number,
		session_cpu, proxy_sessionid, obj_edition_name, logoff_lread,
		logoff_pread, logoff_lwrite, logoff_dlock
        ) AS
    SELECT
    	audosusername,
    	auduserid,
        audusername,
        auduserhost,
        auduserip,
        auduserport,
        audterminal,
        audtimestamp,
        audowner,
        audobjname,
        GETOBJTYPE(audobjtype),
        audrelnamespace,
        auddatname,
        auddbname,
		audactionid,
		m.name,
		audnewowner,
		audnewobjectname,
		audgrantees,
		audauditoption,
		audsesactions,
		CAST( '' AS TEXT),
		audsessionid,
        audentryid,
        audlogofftime,
		audsqltext,
		CASE
            WHEN audgrantopt = TRUE THEN 'Y'
            ELSE CAST( '' AS TEXT)
        END,
		CASE
            WHEN audadminopt = TRUE THEN 'Y'
            ELSE CAST( '' AS TEXT)
        END,
        CASE
            WHEN audisgrant = TRUE THEN 'GRANT'
            WHEN audisgrant = FALSE THEN 'REVOKE'
            ELSE CAST( '' AS TEXT)
        END,
      	audreturncode,
    	audgrantobjpriv,
		audgrantsyspriv,
    	audsysprivilege,
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT),
    	CAST( '' AS TEXT)
    FROM sys_aud a LEFT JOIN sys_audit_maps m ON (a.audactionid = m.action)
		 LEFT JOIN sys_authid on a.audusername = sys_authid.rolname
    ORDER BY a.audtimestamp, a.audsessionid, a.audentryid;

CREATE VIEW sys_audit_trail_internal
	(os_username, userid, username, userhost, userip,
		userport, terminal, timestamp, owner, obj_name, obj_type,
		schema_name, dbid, db_name, action, action_name, new_owner,
		new_name, grantee, audit_option, ses_actions, comment_text,
		sessionid, entryid, logoff_time, sql_text, grant_option, admin_option,
		is_grant, returncode, obj_privilege, sys_privilege, priv_used) AS
    SELECT
    	audosusername,
    	auduserid,
        audusername,
        auduserhost,
        auduserip,
        auduserport,
        audterminal,
        audtimestamp,
        audowner,
        audobjname,
        GETOBJTYPE(audobjtype),
        audrelnamespace,
        auddatname,
        auddbname,
		audactionid,
		m.name,
		audnewowner,
		audnewobjectname,
		audgrantees,
		audauditoption,
		audsesactions,
		CAST( '' AS TEXT),
		audsessionid,
        audentryid,
        audlogofftime,
		audsqltext,
		CASE
            WHEN audgrantopt = TRUE THEN 'Y'
            ELSE CAST( '' AS TEXT)
        END,
		CASE
            WHEN audadminopt = TRUE THEN 'Y'
            ELSE CAST( '' AS TEXT)
        END,
        CASE
            WHEN audisgrant = TRUE THEN 'GRANT'
            WHEN audisgrant = FALSE THEN 'REVOKE'
            ELSE CAST( '' AS TEXT)
        END,
      	audreturncode,
    	audgrantobjpriv,
		audgrantsyspriv,
    	audsysprivilege
		FROM sys_aud a LEFT JOIN sys_audit_maps m ON (a.audactionid = m.action)
		 LEFT JOIN sys_authid on a.audusername = sys_authid.rolname
    ORDER BY a.audtimestamp, a.audsessionid, a.audentryid;

CREATE VIEW dba_audit_trail AS SELECT * FROM sys_audit_trail;

-- SYS_AUDIT_STATEMENT
CREATE VIEW sys_audit_statement AS
	SELECT
		os_username,
		username,
		userhost,
		userid,
		userip,
		userport,
		terminal,
		timestamp,
		owner,
		db_name,
		schema_name,
		obj_type,
		obj_name,
		action_name,
		new_name,
		obj_privilege,
		sys_privilege,
		is_grant,
		grant_option,
		admin_option,
		grantee,
		audit_option,
		ses_actions,
		comment_text,
		sessionid,
		entryid,
		returncode,
		priv_used,
		sql_text,
		client_id,
		econtext_id,
		extended_timestamp,
		proxy_sessionid
		global_uid,
		os_process,
		transactionid,
		sql_bind,
		statementid,
		scn,
		instance_number,
		session_cpu
		obj_edition_name
	FROM sys_audit_trail
	 where action in (   2 /* AUDIT OBJECT */,
						 8	/* GRANT OBJECT  */,                 
                        119 /* GRANT PROCEDURE */,
                        120 /* GRANT SCHEMA */,
                        121 /* GRANT SEQUENCE */,
						122 /* GRANT TABLE */,
						123 /* GRANT TABLESPACE*/,
						137 /* SET PARAMETER */,
						211 /* SYSTEM AUDIT */,
						212 /* SYSTEM GRANT */);

CREATE VIEW dba_audit_statement AS
	SELECT * FROM sys_audit_statement;

-- SYS_AUDIT_OBJECT
CREATE VIEW sys_audit_object AS
	SELECT
    	os_username,
		username,
		userhost,
		userid,
		userip,
		userport,
		terminal,
		timestamp,
		owner,
		db_name,
		schema_name,
		obj_type,
		obj_name,
		action_name,
		new_owner,
		new_name,
		ses_actions,
		comment_text,
		sessionid,
		entryid,
		returncode,
		priv_used,
		sql_text,
		client_id,
		econtext_id,
		extended_timestamp,
		proxy_sessionid
		global_uid,
		os_process,
		transactionid,
		sql_bind,
		scn,
		instance_number,
		session_cpu
		obj_edition_name
	 FROM sys_audit_trail
		WHERE (action between 0 and 1)
		or (action between 3 and 7)
		or (action between 9 and 14)
		or (action between 101 and 103)
		or (action = 107)
		or (action between 108 and 118)
		or (action between 124 and 147)
		or (action = 210)
		or (action = 213)
		or (action between 300 and 303)
		or (action between 310 and 357)
		or (action between 360 and 369)
		or (action between 372 and 385)
		or (action between 387 and 397)
		or (action between 399 and 429);

CREATE VIEW DBA_AUDIT_OBJECT AS SELECT * FROM sys_audit_object;

-- SYS_AUDIT_SESSION
CREATE VIEW sys_audit_session(
	os_username,
	username,
	userhost,
	terminal,
	timestamp,
	action_name,
	logoff_time,
	sessionid,
	db_name,
	userid,
	user_ip,
	userport,
	returncode,
	logoff_lread,
	logoff_pread,
	logoff_lwrite,
	logoff_dlock,
	client_id,
	session_cpu,
	extended_timestamp,
	proxy_sessionid,
	global_uid,
	instance_number,
	os_process)	AS
	SELECT
		os_username,
		username,
		userhost,
		terminal,
		timestamp,
		action_name,
		logoff_time,
		sessionid,
		DB_NAME,
		userid,
		userip,
		userport,
 		CAST( '' AS TEXT),
		CAST( '' AS TEXT),
		CAST( '' AS TEXT),
		CAST( '' AS TEXT),
		CAST( '' AS TEXT),
		CAST( '' AS TEXT),
		CAST( '' AS TEXT),
		CAST( '' AS TEXT),
		CAST( '' AS TEXT),
		CAST( '' AS TEXT),
		CAST( '' AS TEXT),
		CAST( '' AS TEXT)
    FROM sys_audit_trail
	WHERE action = 137
    ORDER BY timestamp, sessionid;

CREATE VIEW dba_audit_session as select * from sys_audit_session;

CREATE VIEW SYS_SERVER_AUDIT_TRAIL AS
SELECT * FROM SYS_SERVER_AUDIT_TRAIL() AS A(USERNAME TEXT, ACTION TEXT, TIME TIMESTAMPTZ);


--------------------
-- The five functions are for 'Audit Rule Analysis'.
--------------------
CREATE OR REPLACE FUNCTION db_obj_name_convertor(obj_name TEXT) RETURNS TEXT AS
DECLARE
  converted_name TEXT;
BEGIN
  -- Process the obj_name
  IF obj_name IS NULL THEN
    RETURN converted_name;
  ELSIF obj_name ~ '^([^"\s''])*$' THEN
    /* unquoted name, to upper */
    converted_name := UPPER(obj_name);
  ELSIF obj_name ~ '^"([^"]|"")*"$' THEN
    /* strip out the quote */
    converted_name := regexp_replace(obj_name, '""', '"');
    converted_name := regexp_replace(converted_name, '^"|"$', '', 'g');
  ELSE
    RAISE EXCEPTION 'invalid identifier: "%"', obj_name;
  END IF;

  RETURN converted_name;
END;

-- Create an Audit Rule
CREATE OR REPLACE FUNCTION create_audit_rule(
  rule_name NAME, 
  user_name NAME DEFAULT '',
  db_name NAME DEFAULT '', 
  schema_name NAME DEFAULT '', 
  object_name NAME DEFAULT '', 
  action_id INT DEFAULT -1,
  allow_ip INET[] DEFAULT NULL, 
  allow_dt TIMESTAMP WITHOUT TIME ZONE[] DEFAULT NULL
)
RETURNS INT
AS
BEGIN
  IF allow_dt IS NOT NULL AND (array_upper(allow_dt,1) % 2 <> 0) THEN
    RAISE EXCEPTION 'size of "allow_dt" should be even';
  END IF;

  IF rule_name IS NULL OR rule_name ~ '^\s*$' OR rule_name ~ '^""$' THEN
    RAISE EXCEPTION 'invalid identifier: "%"', rule_name;
  END IF;

  INSERT INTO SYS_AUDRULE VALUES(db_obj_name_convertor(rule_name),
								db_obj_name_convertor(user_name),
								db_obj_name_convertor(db_name),
								db_obj_name_convertor(schema_name),
								db_obj_name_convertor(object_name),
								action_id,
								allow_ip,
								allow_dt);
  RETURN 1;
EXCEPTION
  WHEN dup_val_on_index THEN
    RAISE EXCEPTION 'audit rule "%" already exists', db_obj_name_convertor(rule_name);
  WHEN insufficient_privilege THEN
    RAISE EXCEPTION 'permission denied';
  WHEN RAISE_EXCEPTION THEN
    RAISE EXCEPTION '%', SQLERRM;
END;

-- Drop an Audit Rule
CREATE OR REPLACE FUNCTION drop_audit_rule( rule_name NAME )
RETURNS INT
AS
DECLARE
  matched_rules INT;
BEGIN
  IF rule_name IS NULL OR rule_name ~ '^\s*$' OR rule_name ~ '^""$' THEN
    RAISE EXCEPTION 'invalid identifier: "%"', rule_name;
  END IF;

  SELECT COUNT(*) INTO matched_rules FROM sys_audrule where arname = db_obj_name_convertor(rule_name);
  IF matched_rules = 0 THEN
    RAISE EXCEPTION 'audit rule "%" does not exist', db_obj_name_convertor(rule_name);
  END IF;

  DELETE FROM SYS_AUDRULE WHERE arname = db_obj_name_convertor(rule_name);
  RETURN 1;
EXCEPTION 
  WHEN insufficient_privilege THEN
    RAISE EXCEPTION 'permission denied';
  WHEN RAISE_EXCEPTION THEN
    RAISE EXCEPTION '%', SQLERRM;
END;

-- Alter an Audit Rule
CREATE OR REPLACE FUNCTION alter_audit_rule(
  rule_name NAME, 
  user_name NAME DEFAULT '',
  db_name NAME DEFAULT '', 
  schema_name NAME DEFAULT '', 
  object_name NAME DEFAULT '', 
  action_id INT DEFAULT -1,
  allow_ip INET[] DEFAULT NULL, 
  allow_dt TIMESTAMP WITHOUT TIME ZONE[] DEFAULT NULL
)
RETURNS VOID
AS
BEGIN
  PERFORM drop_audit_rule(rule_name);
  PERFORM create_audit_rule(rule_name, user_name, db_name, schema_name, object_name, action_id, allow_ip, allow_dt);
EXCEPTION
  WHEN RAISE_EXCEPTION THEN
    RAISE EXCEPTION '%', SQLERRM;
END;

-- Apply an Audit Rule
CREATE OR REPLACE function apply_audit_rule(
  rule_name NAME, 
  user_name NAME DEFAULT '',
  db_name NAME DEFAULT '', 
  schema_name NAME DEFAULT '', 
  object_name NAME DEFAULT '',
  debug_mode BOOLEAN DEFAULT FALSE
) 
RETURNS SETOF sys_audit_trail
AS
DECLARE
  n INT;
  i INT;
  my_dbname TEXT;
  my_schemaname TEXT;
  my_objectname TEXT;
  my_username TEXT;
  ar_row sys_audrule%ROWTYPE;
  ip INET;
  dt TIMESTAMP WITH TIME ZONE;
  ip_allow BOOL;
  dt_allow BOOL;
  rec RECORD;
  filter_sql TEXT;
  aud_cursor REFCURSOR;
  aud_tuple RECORD;
BEGIN
  IF rule_name IS NULL OR rule_name ~ '^\s*$' OR rule_name ~ '^""$' THEN
    RAISE EXCEPTION 'invalid identifier: "%"', rule_name;
  END IF;
  SELECT * INTO ar_row FROM sys_audrule WHERE arname = db_obj_name_convertor(rule_name);
  IF NOT FOUND THEN
    RAISE EXCEPTION 'audit rule "%" does not exist', db_obj_name_convertor(rule_name);
    RETURN;
  END IF;
  IF db_name <> '' THEN 
    my_dbname := db_obj_name_convertor(db_name);
  ELSE
    my_dbname := ar_row.ardbname;
  END IF;
  IF schema_name <> '' THEN 
    my_schemaname := db_obj_name_convertor(schema_name);
  ELSE
    my_schemaname := ar_row.arschemaname;
  END IF;
  IF object_name <> '' THEN 
    my_objectname := db_obj_name_convertor(object_name);
  ELSE
    my_objectname := ar_row.arobjectname;
  END IF;
  IF user_name <> '' THEN
    my_username := db_obj_name_convertor(user_name);
  ELSE
    my_username := ar_row.arusername;
  END IF;
  filter_sql := 'SELECT * FROM sys_audit_trail WHERE TRUE';
  IF my_dbname <> '' THEN
    filter_sql := filter_sql || ' AND db_name = ' || quote_literal(my_dbname);
  END IF;
  IF my_schemaname <> '' THEN
    filter_sql := filter_sql || ' AND schema_name = ' || quote_literal(my_schemaname);
  END IF;
  IF my_objectname <> '' THEN
    filter_sql := filter_sql || ' AND obj_name = ' || quote_literal(my_objectname);
  END IF;
  IF my_username <> '' THEN
    filter_sql := filter_sql || ' AND username = ' || quote_literal(my_username);
  END IF;
  IF ar_row.arallowdt IS NOT NULL THEN
    n := array_upper(ar_row.arallowdt, 1);
    IF n > 0 THEN
      filter_sql := filter_sql || ' AND NOT (';
      i := 1;
      WHILE i <= n LOOP
        IF i <> 1 THEN
          filter_sql := filter_sql || ' OR ';
        END IF;
        filter_sql := filter_sql || 'timestamp BETWEEN CAST(''' || ar_row.arallowdt[i] || ''' AS TIMESTAMP) AND CAST(''' || ar_row.arallowdt[i+1] || ''' AS TIMESTAMP)';
        i := i + 2;
      END LOOP;
      filter_sql := filter_sql || ')';
    END IF;
  END IF;
  IF ar_row.arallowip IS NOT NULL THEN
    n := array_upper(ar_row.arallowip, 1);
    IF n > 0 THEN
      filter_sql := filter_sql || ' AND NOT CAST(userip AS INET) <<= ANY (CAST(''{' || array_to_string(ar_row.arallowip, ',') || '}'' AS CIDR[]))';
    END IF;
  END IF;
  IF debug_mode = TRUE THEN
     RAISE NOTICE '%', filter_sql;
  END IF;  
  OPEN aud_cursor FOR EXECUTE filter_sql;
  LOOP
    FETCH aud_cursor INTO aud_tuple;
    IF aud_cursor%NOTFOUND THEN
      EXIT;
    END IF;
    RETURN NEXT aud_tuple;
  END LOOP;
  CLOSE aud_cursor;
  RETURN;
EXCEPTION 
  WHEN insufficient_privilege THEN
    RAISE EXCEPTION 'permission denied';
  WHEN RAISE_EXCEPTION THEN
    RAISE EXCEPTION '%', SQLERRM;
END;

/* bug#12186: support synonym for table */
CREATE VIEW sys_synonyms AS
SELECT sys_get_userbyid(synony.synowner) AS owner,
			snsp.nspname AS synnamespace,
			synony.synname AS synname,
			synony.objnamespace AS objnamespace,
			synony.objname	AS objname,
			dblink AS dblink
FROM sys_synonym synony, sys_namespace snsp
WHERE synony.synnamespace = snsp.oid;

--bug#12161:views about component and it's type in current license 
CREATE VIEW sys_component AS
    SELECT *
    FROM sys_components() AS A(component_name name, is_support bool, type name);

--bug#19084: view to show license base date and end date.
CREATE VIEW sys_valid_date AS
	SELECT *
	FROM sys_valid_dates() AS A(owner name, base_date date, end_date date);

/* support result cache */
CREATE VIEW sys_result_cache_statistics AS
SELECT * FROM sys_rscache_statistics() AS A(CACHE_SIZE INT, CACHE_FETCHES INT, CACHE_HITS INT, CACHE_FREE INT, INVALIDATIONS INT);

CREATE VIEW sys_result_cache_objects AS
SELECT * FROM sys_rscache_objects() AS A(CACHEID INT, STATEMENT TEXT, DEPENDENT_OBJECTS REGTYPE[], STATUS TEXT);

/*
 * MAC policy views
 *
 *  policy:
 *    SYS_MAC_POLICIES
 *    SYS_MAC_LEVELS
 *    SYS_MAC_COMPARTMENTS
 *    SYS_MAC_TABLE_POLICIES
 *  label:
 *    SYS_MAC_LABELS
 *    SYS_MAC_LABEL_LEVELS
 *    SYS_MAC_LABEL_COMPARTMENTS
 *  user:
 *    SYS_MAC_USER_PRIVS
 *    SYS_MAC_USER_LEVELS
 *    SYS_MAC_USER_COMPARTMENTS
 *  session:
 *    SYS_MAC_SESSION
 *    SYS_MAC_SESSION_LABEL_LOOKUP_INFO(debug)
 *    SYS_MAC_SESSION_LABEL_MEDIATION(debug)
 */
CREATE VIEW sys_mac_levels AS
	SELECT
		P.policy_name AS policy_name,
		L.level_id AS level_id,
		L.level_shortname AS short_name,
		L.level_longname AS long_name
	FROM sys_mac_level L INNER JOIN sys_mac_policy P ON (L.policy_id = P.oid);

CREATE VIEW sys_mac_compartments AS
	SELECT
		P.policy_name AS policy_name,
		C.compartment_id AS comp_id,
		C.compartment_shortname AS short_name,
		C.compartment_longname AS long_name
	FROM sys_mac_compartment C INNER JOIN sys_mac_policy P ON (C.policy_id = P.oid);

CREATE VIEW sys_mac_labels AS
	SELECT
		P.policy_name AS policy_name,
		L.label_id AS label_id,
		label_to_char(label_id) AS label
	FROM sys_mac_label L INNER JOIN sys_mac_policy P ON (L.policy_id = P.oid);

CREATE VIEW sys_mac_policies AS
	SELECT
		policy_name AS policy_name,
		policy_col_name AS column_name,
		policy_col_hidden AS column_hide,
		policy_enable AS policy_enable,
		oid AS policy_id
	FROM sys_mac_policy;

CREATE VIEW sys_mac_table_policies AS
	SELECT
		P.policy_name AS policy_name,
		N.nspname AS schema_name,
		C.relname AS table_name,
		P.policy_col_name AS policy_col_column,
		P.policy_col_hidden AS policy_table_hide
	FROM sys_mac_policy P INNER JOIN sys_mac_policy_enforcement E ON (E.policy_id = P.oid)
		INNER JOIN sys_class C ON (E.relation_id = C.Oid)
		INNER JOIN sys_namespace N ON (c.relnamespace = N.Oid);

CREATE VIEW sys_mac_user_levels AS
	SELECT
		policy_name AS policy_name,
		rolname AS user_name,
		(SELECT level_shortname FROM sys_mac_level WHERE policy_id = U.policy_id AND level_id = U.max_levelid) AS max_level,
		(SELECT level_shortname FROM sys_mac_level WHERE policy_id = U.policy_id AND level_id = U.min_levelid) AS min_level,
		(SELECT level_shortname FROM sys_mac_level WHERE policy_id = U.policy_id AND level_id = U.def_levelid) AS def_level,
		(SELECT level_shortname FROM sys_mac_level WHERE policy_id = U.policy_id AND level_id = U.row_levelid) AS row_level
	FROM sys_mac_user U INNER JOIN sys_authid A ON U.role_id = A.oid
		INNER JOIN sys_mac_policy P ON U.policy_id = P.oid;

CREATE VIEW sys_mac_user_compartments AS
	SELECT
			(SELECT policy_name FROM sys_mac_policy WHERE oid = policy_id) AS policy_name,
			(SELECT rolname FROM sys_authid WHERE oid = role_id) AS user_name,
			(SELECT compartment_shortname FROM sys_mac_compartment WHERE policy_id = UC.policy_id AND compartment_id = UC.compartment_id) AS comp,
			CASE WHEN ARRAY[UC.compartment_id] <@ (SELECT write_compartmentids::int2[] FROM sys_mac_user U WHERE policy_id = UC.policy_id AND role_id = UC.role_id) THEN 'WRITE' ELSE 'READ' END AS rw_access,
			CASE WHEN ARRAY[UC.compartment_id] <@ (SELECT def_compartmentids::int2[] FROM sys_mac_user U WHERE policy_id = UC.policy_id AND role_id = UC.role_id) THEN 'Y' ELSE 'N' END AS def_comp,
			CASE WHEN ARRAY[UC.compartment_id] <@ (SELECT row_compartmentids::int2[] FROM sys_mac_user U WHERE policy_id = UC.policy_id AND role_id = UC.role_id) THEN 'Y' ELSE 'N' END AS row_comp,
			CASE WHEN ARRAY[UC.compartment_id] <@ (SELECT min_write_compartmentids::int2[] FROM sys_mac_user U WHERE policy_id = UC.policy_id AND role_id = UC.role_id) THEN 'Y' ELSE 'N' END AS min_write_comp
		FROM (SELECT policy_id, role_id, unnest(read_compartmentids) AS compartment_id FROM sys_mac_user) UC;

CREATE VIEW sys_mac_user_privs AS
	SELECT
		rolname AS user_name,
		policy_name AS policy_name,
		mac_privs_to_char(privilege) AS user_privileges
	FROM sys_mac_user U INNER JOIN sys_authid A ON U.role_id = A.oid
		INNER JOIN sys_mac_policy P ON U.policy_id = P.oid;

CREATE VIEW sys_mac_session AS
	SELECT
			COALESCE((SELECT policy_name FROM sys_mac_policy WHERE oid = policy_id), 'ERROR:DORPPED POLICY:' || policy_id) AS policy_name,
			(SELECT rolname FROM sys_authid WHERE oid = role_id) AS user_name,
			privs,
			max_read_label,
			max_write_label,
			min_write_label,
			def_read_label,
			def_write_label,
			def_row_label
	FROM SHOW_LABEL() AS foo(policy_id oid, role_id oid, privs text,
							max_read_label text, max_write_label text,
							min_write_label text, def_read_label text,
							def_write_label text,  def_row_label text)
	ORDER BY policy_id;

CREATE VIEW sys_mac_label_levels AS
	SELECT
		policy_name,
		LABEL_TO_CHAR(label_id) AS label,
		L.level_shortname AS level_shortname
	FROM sys_mac_label LL INNER JOIN sys_mac_policy P ON P.oid = LL.policy_id
		INNER JOIN sys_mac_level L ON LL.policy_id = L.policy_id and LL.level_id = L.level_id;

CREATE VIEW sys_mac_label_compartments AS
	SELECT
		policy_name,
		LABEL_TO_CHAR(label_id) AS label,
		compartment_shortname AS compartment_shortname
	FROM (SELECT policy_id, label_id, unnest(compartment_ids) AS compartment_id FROM sys_mac_label) LC INNER JOIN sys_mac_policy P ON P.oid = LC.policy_id
		INNER JOIN sys_mac_compartment C ON C.policy_id = LC.policy_id AND C.compartment_id = LC.compartment_id;

CREATE VIEW sys_mac_session_label_lookup_info AS
	SELECT 
		policy_id AS policy_id,
		COALESCE((SELECT policy_name FROM sys_mac_policy WHERE oid = policy_id), 'ERROR:DORPPED POLICY') AS policy_name,
		default_row_label_id,
		max_label_id,
		min_label_id,
		label_count
	FROM show_session_label_lookup() AS foo(policy_id OID, default_row_label_id INT,
											max_label_id INT, min_label_id INT, label_count INT)
	ORDER BY policy_id;

CREATE VIEW sys_mac_session_label_mediation AS
	SELECT 
		label_id AS label_id,
		CASE WHEN EXISTS (SELECT label_id FROM sys_mac_label WHERE label_id = foo.label_id) THEN LABEL_TO_CHAR(label_id) ELSE 'ERROR:DROPPED LEVEL:' || policy_id END AS label,
		policy_id AS policy_id,
		COALESCE((SELECT policy_name FROM sys_mac_policy WHERE oid = policy_id), 'ERROR:DORPPED POLICY') AS policy_name,
		CASE WHEN informations & 2 THEN 'READ_PRIV_ACCESS' WHEN informations & 1 THEN 'READ_ACCESS' ELSE 'NO_ACCESS' END AS read_access,
		CASE WHEN informations & 8 THEN 'WRITE_PRIV_ACCESS' WHEN informations & 4 THEN 'WRITE_ACCESS' ELSE 'NO_ACCESS' END AS write_access,
		CASE WHEN informations & 32 THEN 'INSERT_PRIV_ACCESS' WHEN informations & 16 THEN 'INSERT_ACCESS' ELSE 'NO_ACCESS' END AS insert_access,
		CASE WHEN informations & 64 THEN 'USED' ELSE 'NOT USED' END AS priv_read_used,
		CASE WHEN informations & 128 THEN 'USED' ELSE 'NOT USED' END AS priv_full_used
	FROM show_session_label_mediation() AS foo(label_id INT, policy_id OID, informations INT)
	ORDER BY policy_id, label_id;

/* show the grant information */
CREATE VIEW sys_grant_privileges AS 
--table, view, sequence 
                SELECT 
                        grantor.name AS grantor, 
                        grantor.type AS grantortype, 
                        grantee.name AS grantee, 
                        grantee.type AS granteetype, 
                        c.relname AS object_name, 
                        ( 
                                CASE WHEN c.relkind = 'r' THEN 'TABLE' 
                                WHEN c.relkind = 'v' THEN 'VIEW' 
                                ELSE 'SEQUENCE' END 
                        ) AS object_type, 
                        nsp.nspname AS object_schema, 
                        pr.type AS privilege_type, 
                        ( 
                        CASE WHEN 
                        ( 
                                aclcontains (c.relacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, true))   
                                OR grantor.name = grantee.name 
                        ) 
                        THEN 'YES' ELSE 'NO' END ) AS is_grantable 
                FROM sys_class c,  
                         sys_namespace nsp, 
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        )as grantor(usesysid, name, type), 
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        ) AS grantee (usesysid, name, type), 
            ( SELECT 'SELECT' UNION ALL 
                        SELECT 'DELETE' UNION ALL 
                        SELECT 'INSERT' UNION ALL 
                        SELECT 'UPDATE' UNION ALL 
                        SELECT 'REFERENCES' UNION ALL 
                        SELECT 'USAGE' UNION ALL 
                        SELECT 'TRIGGER') AS pr (type) 
                WHERE 
                        ( 
                                ((c.relacl is null) AND (grantor.name=grantee.name) AND (SYS_GET_USERBYID(c.relowner) = grantee.usesysid)) 
                                 OR  aclcontains(c.relacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, false)) 
                        ) 
                        AND (c.relkind = 'r' OR c.relkind = 'v' OR c.relkind = 'S') 
                        AND c.relnamespace != 11 
                        AND c.relnamespace = nsp.oid 
                        AND grantor.name != grantee.name 
--function, procedure 
UNION ALL 
                SELECT  
                        grantor.name AS grantor, 
                        grantor.type AS grantortype, 
                        grantee.name AS grantee, 
                        grantee.type AS granteetype, 
                        p.proname AS object_name, 
                        ( 
                                CASE WHEN p.protype = 'f' THEN 'FUNCTION' 
                                ELSE 'PROCEDURE' END 
                        ) AS object_type, 
                        nsp.nspname AS object_schema, 
                        pr.type AS privilege_type, 
                        ( 
                        CASE WHEN 
                        ( 
                                aclcontains (p.proacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, true))   
                                OR grantor.name = grantee.name 
                        ) 
                        THEN 'YES' ELSE 'NO' END ) AS is_grantable 
                FROM sys_proc p,  
                         sys_namespace nsp, 
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        )as grantor(usesysid, name, type), 
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        ) AS grantee (usesysid, name, type), 
            ( SELECT 'EXECUTE') AS pr (type) 
                WHERE 
                        ( 
                                ((p.proacl is null) AND (grantor.name=grantee.name) AND (SYS_GET_USERBYID(p.proowner) = grantee.usesysid)) 
                                 OR  aclcontains(p.proacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, false)) 
                        ) 
                        AND (p.protype = 'f' OR p.protype = 'p') 
                        AND p.pronamespace != 11 
                        AND p.pronamespace = nsp.oid 
                        AND grantor.name != grantee.name 
--package 
UNION ALL 
                SELECT  
                        grantor.name AS grantor, 
                        grantor.type AS grantortype, 
                        grantee.name AS grantee, 
                        grantee.type AS granteetype, 
                        p.pkgname AS object_name, 
                        'PACKAGE' AS object_type, 
                        nsp.nspname AS object_schema, 
                        pr.type AS privilege_type, 
                        ( 
                        CASE WHEN 
                        ( 
                                aclcontains (p.pkgacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, true))   
                                OR grantor.name = grantee.name 
                        ) 
                        THEN 'YES' ELSE 'NO' END ) AS is_grantable 
                FROM sys_package p,  
                         sys_namespace nsp, 
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        )as grantor(usesysid, name, type), 
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        ) AS grantee (usesysid, name, type), 
            ( SELECT 'EXECUTE') AS pr (type) 
                WHERE 
                        ( 
                                ((p.pkgacl is null) AND (grantor.name=grantee.name) AND (SYS_GET_USERBYID(p.pkgowner) = grantee.usesysid)) 
                                 OR  aclcontains(p.pkgacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, false)) 
                        ) 
                        AND p.pkgnamespace != 11 
                        AND p.pkgnamespace = nsp.oid 
                        AND grantor.name != grantee.name 
  
--database 
UNION ALL 
                SELECT  
                        grantor.name AS grantor, 
                        grantor.type AS grantortype, 
                        grantee.name AS grantee, 
                        grantee.type AS granteetype, 
                        d.datname AS object_name, 
                        'DATABASE' AS object_type, 
                        NULL AS object_schema, 
                        pr.type AS privilege_type, 
                        ( 
                        CASE WHEN 
                        ( 
                                aclcontains (d.datacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, true))   
                                OR grantor.name = grantee.name 
                        ) 
                        THEN 'YES' ELSE 'NO' END ) AS is_grantable 
                FROM sys_database d,  
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        )as grantor(usesysid, name, type), 
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        ) AS grantee (usesysid, name, type), 
            ( SELECT 'CREATE' UNION ALL 
                        SELECT 'TEMPORARY' UNION ALL 
                        SELECT 'CONNECT') AS pr (type) 
                WHERE 
                        ( 
                                ((d.datacl is null) AND (grantor.name=grantee.name) AND (SYS_GET_USERBYID(d.datdba) = grantee.usesysid)) 
                                 OR  aclcontains(d.datacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, false)) 
                        ) 
                        AND grantor.name != grantee.name 
  
--tablespace 
UNION ALL 
                SELECT  
                        grantor.name AS grantor, 
                        grantor.type AS grantortype, 
                        grantee.name AS grantee, 
                        grantee.type AS granteetype, 
                        t.spcname AS object_name, 
                        'TABLESPACE' AS object_type, 
                        NULL AS object_schema, 
                        pr.type AS privilege_type, 
                        ( 
                        CASE WHEN 
                        ( 
                                aclcontains (t.spcacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, true))   
                                OR grantor.name = grantee.name 
                        ) 
                        THEN 'YES' ELSE 'NO' END ) AS is_grantable 
                FROM sys_tablespace t,  
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        )as grantor(usesysid, name, type), 
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        ) AS grantee (usesysid, name, type), 
            (SELECT 'CREATE') AS pr (type) 
                WHERE 
                        ( 
                                ((t.spcacl is null) AND (grantor.name=grantee.name) AND (SYS_GET_USERBYID(t.spcowner) = grantee.usesysid)) 
                                 OR  aclcontains(t.spcacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, false)) 
                        ) 
                        AND grantor.name != grantee.name 
  
--SCHEMA 
UNION ALL 
                SELECT  
                        grantor.name AS grantor, 
                        grantor.type AS grantortype, 
                        grantee.name AS grantee, 
                        grantee.type AS granteetype, 
                        n.nspname AS object_name, 
                        'SCHEMA' AS object_type, 
                        NULL AS object_schema, 
                        pr.type AS privilege_type, 
                        ( 
                        CASE WHEN 
                        ( 
                                aclcontains (n.nspacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, true))   
                                OR grantor.name = grantee.name 
                        ) 
                        THEN 'YES' ELSE 'NO' END ) AS is_grantable 
                FROM sys_namespace n,  
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        )as grantor(usesysid, name, type), 
                        ( 
                                SELECT usesysid, usename, 'USER' FROM sys_user 
                                UNION ALL 
                                SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                        ) AS grantee (usesysid, name, type), 
            (SELECT 'CREATE' UNION ALL 
                        SELECT 'USAGE') AS pr (type) 
  
                WHERE 
                        ( 
                                ((n.nspacl is null) AND (grantor.name=grantee.name) AND (SYS_GET_USERBYID(n.nspowner) = grantee.usesysid)) 
                                 OR  aclcontains(n.nspacl, makeaclitem(grantee.usesysid, grantor.usesysid, pr.type, false)) 
                        ) 
                        AND grantor.name != grantee.name 
                        ORDER BY object_type, object_name, grantee; 
  
CREATE VIEW sys_grant_roles AS 
        SELECT grantor.USENAME AS grantor, 
                grantee.name AS grantee, 
                grantee.type AS granteetype, 
                r.rolname AS role_name, 
                (CASE WHEN m.admin_option THEN 'YES' ELSE 'NO' END) AS admin_option 
        FROM SYS_USER AS grantor, 
                ( 
                        SELECT usesysid, usename, 'USER' FROM sys_user 
                        UNION ALL 
                        SELECT OID, ROLNAME, 'ROLE' from sys_roles 
                ) AS grantee (usesysid, name, type), 
                SYS_roles r, 
                sys_auth_members m 
        WHERE m.GRANTOR = grantor.usesysid 
        AND m.MEMBER = grantee.usesysid 
        AND m.ROLEID = r.oid; 

CREATE VIEW sys_stat_database_conflicts AS
    SELECT
            D.oid AS datid,
            D.datname AS datname,
            sys_stat_get_db_conflict_lock(D.oid) AS confl_lock,
            sys_stat_get_db_conflict_snapshot(D.oid) AS confl_snapshot,
            sys_stat_get_db_conflict_bufferpin(D.oid) AS confl_bufferpin,
            sys_stat_get_db_conflict_startup_deadlock(D.oid) AS confl_deadlock
    FROM sys_database D;

CREATE VIEW DBMS_ALERT_INFO AS
        SELECT RELNAME::VARCHAR(30) AS NAME,LISTENERPID::VARCHAR(30) AS SID,
                STATUS::VARCHAR(1) AS CHANGED,MESSAGE::VARCHAR(1800) AS MESSAGE
        FROM SYS_LISTENER;

CREATE OR REPLACE PROCEDURE raise_application_error(Num integer, Msg text, Keeperrorstack Boolean default false) AS
DECLARE
	MsgTemp text;
	MsgLength int;
	isnull bool := 0;
BEGIN
	if Num < -20999 or Num > -20000 then
		RAISE EXCEPTION 'SQLCODE "%" out of data range,should be -20999~-20000', Num;
	end if;

	MsgLength := CHAR_LENGTH(Msg);
	if MsgLength > 2048 then
		select substring(Msg, 1, 2048) into MsgTemp;
	else
		select Msg into MsgTemp;
	end if;
	
	if MsgTemp is NULL THEN
		RAISE '' USING ERRCODE = Num;
	else
		RAISE EXCEPTION USING ERRCODE = Num,MESSAGE = MsgTemp;
	end if;
END;

CREATE OR REPLACE VIEW X$KZSRO AS
       SELECT 00000000 ADDR, 0 INDX, 1 INST_ID, KZSROROL from sys_get_role() AS A(KZSROROL);

CREATE OR REPLACE VIEW SESSION_ROLES AS
       SELECT SYS_AUTHID.ROLNAME FROM SYS_AUTHID,X$KZSRO WHERE X$KZSRO.KZSROROL = SYS_AUTHID.OID;

CREATE SEQUENCE SYSTEM_PRIVILEGE_SERIAL START WITH 1;
GRANT USAGE ON SYSTEM_PRIVILEGE_SERIAL TO PUBLIC;

create or replace view dba_sys_privs as
SELECT  CAST(authid.rolname AS character varying(30 byte)) AS grantee,
              CAST(map.name AS character varying(40 byte))  AS privilege,
              CAST((CASE WHEN auth.admin_option THEN 'YES' ELSE 'NO' END) as character varying(3 byte))  AS admin_option
       FROM sys_catalog.sys_sysauth auth,
            sys_catalog.sys_sysauth_map map,
            sys_catalog.sys_authid authid
       WHERE authid.OID = auth.GRANTEE
       AND map.PRIVILEGE = auth.PRIVILEGE;

create or replace view user_sys_privs as
SELECT cast(SYS_USER.USENAME as character varying(30 byte)) AS GRANTEE,
              cast(map.NAME as character varying(40 byte)) AS PRIVILEGE,
              cast((CASE WHEN auth.admin_option THEN 'YES' ELSE 'NO' END) as character varying(3 byte)) AS ADMIN_OPTION
       FROM sys_catalog.SYS_SYSAUTH auth,
            sys_catalog.SYS_SYSAUTH_MAP map,
            sys_catalog.SYS_USER
       WHERE SYS_USER.USESYSID = auth.GRANTEE
       AND map.PRIVILEGE = auth.PRIVILEGE
	   and SYS_USER.USENAME = CAST("CURRENT_USER"() AS CHARACTER VARYING(63 BYTE));

CREATE VIEW ROLE_SYS_PRIVS AS
       SELECT GRANTEE AS ROLE,
              PRIVILEGE,
              ADMIN_OPTION
       FROM DBA_SYS_PRIVS
       WHERE DBA_SYS_PRIVS.GRANTEE IN
       (SELECT SYS_ROLES.ROLNAME 
       FROM SYS_ROLES,SYS_AUTH_MEMBERS,SYS_AUTHID
       WHERE SYS_AUTH_MEMBERS.MEMBER = SYS_AUTHID.OID
       AND SYS_AUTHID.ROLNAME = CURRENT_USER);
CREATE OR REPLACE VIEW SYS_AUDTEMPLATE AS
		SELECT * FROM audit_template() AS ta(TEMPLATENAME TEXT, TEMPLATERULE TEXT);
CREATE OR REPLACE VIEW SYS_LS_AUDITTRAIL AS
		SELECT * FROM  sys_ls_audittrail() as t(FILENAME TEXT, FILESIZE TEXT);

REVOKE ALL ON sys_catalog.dba_sys_privs FROM PUBLIC;
REVOKE ALL ON  sys_catalog.ROLE_SYS_PRIVS FROM PUBLIC;   
GRANT SELECT ON sys_catalog.user_sys_privs TO PUBLIC;  


CREATE OR REPLACE VIEW sys_shared_buffer_info AS
		SELECT ISNULL(C.relname, '<N/A>') AS tablename,
				blockid,
				usagecount,
				refcount,
				isdirty,
				status AS bufpoolstrategy
		FROM sys_buffer_stat() as B(dbid int, spcid int, relfilenode int,
				blockid int, status text, isdirty bool,
				usagecount smallint, refcount int)
			LEFT JOIN sys_class C on C.relfilenode <> 0 AND B.relfilenode = C.relfilenode;

-- query rule pre-defination
SELECT create_query_rule('Q3',
'select '
	'l_orderkey, '
	'sum(l_extendedprice * (1 - l_discount)) as revenue, '
	'o_orderdate, '
	'o_shippriority '
'from '
	'customer, '
	'orders, '
	'lineitem '
'where '
	'c_mktsegment = $1 '
	'and c_custkey = o_custkey '
	'and l_orderkey = o_orderkey '
	'and o_orderdate < $2::date '
	'and l_shipdate > $3::date '
'group by '
	'l_orderkey, '
	'o_orderdate, '
	'o_shippriority '
'order by '
	'revenue desc, '
	'o_orderdate '
'limit 10; ',

'select '
	'l_orderkey, '
	'sum(l_extendedprice * (1 - l_discount)) as revenue, '
	'o_orderdate, '
	'o_shippriority '
'from '
	'customer, '
	'orders, '
	'lineitem '
'where '
	'c_mktsegment = $1 '
	'and c_custkey = o_custkey '
	'and l_orderkey = o_orderkey '
	'and o_orderdate < $2::date '
	'and l_shipdate < $2::date + interval ''121'' day(3) '	--r
	'and l_shipdate > $3::date '
	'and o_orderdate > $3::date - interval ''121'' day(3) '	--r
'group by '
	'l_orderkey, '
	'o_orderdate, '
	'o_shippriority '
'order by '
	'revenue desc, '
	'o_orderdate '
'limit 10; ', false, 'analyze');


-- Q4
select create_query_rule('Q4',
'select '
'	o_orderpriority, '
'	count(*) as order_count '
'from '
'	orders '
'where '
'	o_orderdate >= $1::date '
'	and o_orderdate < $2::date + interval ''3'' month '
'	and exists ( '
'		select '
'			* '
'		from '
'			lineitem '
'		where '
'			l_orderkey = o_orderkey '
'			and l_commitdate < l_receiptdate '
'	) '
'group by '
'	o_orderpriority '
'order by '
'	o_orderpriority; ',

'select  '
' o_orderpriority,  '
' count(*) as order_count '
'from '
' orders '
'where '
' o_orderdate >= $1::date '
' and o_orderdate < $2::date + interval ''3'' month '
' and exists (  '
'  select '
'   *  '
'  from '
'   lineitem '
'  where '
'   l_orderkey = o_orderkey '
'   and l_commitdate < l_receiptdate '
'   and l_shipdate > $1::date '
'   and l_shipdate <= $2::date + interval ''7'' month '
'  ) '
'group by '
' o_orderpriority  '
'order by '
' o_orderpriority; ', false, 'analyze');

select create_query_rule('Q5',
'select  '
'	n_name, '
'	sum(l_extendedprice * (1 - l_discount)) as revenue '
'from '
'	customer, '
'	orders, '
'	lineitem, '
'	supplier, '
'	nation, '
'	region '
'where '
'	c_custkey = o_custkey '
'	and l_orderkey = o_orderkey '
'	and l_suppkey = s_suppkey '
'	and c_nationkey = s_nationkey '
'	and s_nationkey = n_nationkey '
'	and n_regionkey = r_regionkey '
'	and r_name = $1 '
'	and o_orderdate >= $2::date '
'	and o_orderdate < $3::date + interval ''1'' year '
'group by '
'	n_name '
'order by '
'	revenue desc; ',

'select '
' n_name, '
' sum(l_extendedprice * (1 - l_discount)) as revenue '
'from '
' customer, '
' orders, '
' lineitem, '
' supplier, '
' nation, '
' region '
'where '
' c_custkey = o_custkey '
' and l_orderkey = o_orderkey '
' and l_suppkey = s_suppkey '
' and c_nationkey = s_nationkey '
' and s_nationkey = n_nationkey '
 'and n_regionkey = r_regionkey '
' and r_name = $1 '
' and o_orderdate >= $2::date '
' and o_orderdate < $3::date + interval ''1'' year '
 'and l_shipdate > $2::date '
' and l_shipdate <= $3::date + interval ''17'' month '
'group by  '
' n_name '
'order by '
' revenue desc; ', false, 'analyze');

--Q7
select create_query_rule('Q7',
'select '
	'supp_nation, '
	'cust_nation, '
	'l_year, '
	'sum(volume) as revenue '
'from '
	'( '
		'select '
			'n1.n_name as supp_nation, '
			'n2.n_name as cust_nation, '
			'extract(year from l_shipdate) as l_year, '
			'l_extendedprice * (1 - l_discount) as volume '
		'from '
			'supplier, '
			'lineitem, '
			'orders, '
			'customer, '
			'nation n1, '
			'nation n2 '
		'where '
			's_suppkey = l_suppkey '
			'and o_orderkey = l_orderkey '
			'and c_custkey = o_custkey '
			'and s_nationkey = n1.n_nationkey '
			'and c_nationkey = n2.n_nationkey '
			'and ( '
				'(n1.n_name = $1 and n2.n_name = $2) '
				'or (n1.n_name = $3 and n2.n_name = $4) '
			') '
			'and l_shipdate between date ''1995-01-01'' and date ''1996-12-31'' '
	') shipping '
'group by '
	'supp_nation, '
	'cust_nation, '
	'l_year '
'order by '
	'supp_nation, '
	'cust_nation, '
	'l_year; ',

'select '
	'supp_nation, '
	'cust_nation, '
	'l_year, '
	'sum(volume) as revenue '
'from '
	'( '
		'select '
			'n1.n_name as supp_nation, '
			'n2.n_name as cust_nation, '
			'extract(year from l_shipdate) as l_year, '
			'l_extendedprice * (1 - l_discount) as volume '
		'from '
			'supplier, '
			'lineitem, '
			'orders, '
			'customer, '
			'(select n_nationkey, n_name from nation where n_name in($1, $2)) n1, '
			'(select n_nationkey, n_name from nation where n_name in($1, $2)) n2 '
		'where '
			's_suppkey = l_suppkey '
			'and o_orderkey = l_orderkey '
			'and c_custkey = o_custkey '
			'and s_nationkey = n1.n_nationkey '
			'and c_nationkey = n2.n_nationkey '
			'and ( '
				'(n1.n_name = $1 and n2.n_name = $2) '
				'or (n1.n_name = $3 and n2.n_name = $4) '
			') '
			'and l_shipdate between date ''1995-01-01'' and date ''1996-12-31'' '
			'and o_orderdate < date ''1996-12-31'' '
	') shipping '
'group by '
	'supp_nation, '
	'cust_nation, '
	'l_year '
'order by '
	'supp_nation, '
	'cust_nation, '
	'l_year; ', false, 'analyze');


select create_query_rule('Q8',
'select '
	'o_year, '
	'sum(case '
		'when nation = $1 then volume '
		'else 0 '
	'end) / sum(volume) as mkt_share '
'from '
	'( '
		'select '
			'extract(year from o_orderdate) as o_year, '
			'l_extendedprice * (1 - l_discount) as volume, '
			'n2.n_name as nation '
		'from '
			'part, '
			'supplier, '
			'lineitem, '
			'orders, '
			'customer, '
			'nation n1, '
			'nation n2, '
			'region '
		'where '
			'p_partkey = l_partkey '
			'and s_suppkey = l_suppkey '
			'and l_orderkey = o_orderkey '
			'and o_custkey = c_custkey '
			'and c_nationkey = n1.n_nationkey '
			'and n1.n_regionkey = r_regionkey '
			'and r_name = $2 '
			'and s_nationkey = n2.n_nationkey '
			'and o_orderdate between date ''1995-01-01'' and date ''1996-12-31'' '
			'and p_type = $3 '
	') all_nations '
'group by '
	'o_year '
'order by '
	'o_year; ',

'select '
	'o_year, '
	'sum(case '
		'when nation = $1 then volume '
		'else 0 '
	'end) / sum(volume) as mkt_share '
'from '
	'( '
		'select '
			'extract(year from o_orderdate) as o_year, '
			'l_extendedprice * (1 - l_discount) as volume, '
			'n2.n_name as nation '
		'from '
			'part, '
			'supplier, '
			'lineitem, '
			'orders, '
			'customer, '
			'nation n1, '
			'nation n2, '
			'region '
		'where '
			'p_partkey = l_partkey '
			'and s_suppkey = l_suppkey '
			'and l_orderkey = o_orderkey '
			'and o_custkey = c_custkey '
			'and c_nationkey = n1.n_nationkey '
			'and n1.n_regionkey = r_regionkey '
			'and r_name = $2 '
			'and s_nationkey = n2.n_nationkey '
			'and o_orderdate between date ''1995-01-01'' and date ''1996-12-31'' '
			'and l_shipdate > ''1995-01-01'' '
			'and l_shipdate <= (date ''1996-12-31'' + interval ''121'' day(3))::date '
			'and p_type = $3 '
	') all_nations '
'group by '
	'o_year '
'order by '
	'o_year; ', false, 'analyze');

--Q10
select create_query_rule('Q10',
'select '
'	c_custkey, '
'	c_name, '
'	sum(l_extendedprice * (1 - l_discount)) as revenue, '
'	c_acctbal, '
'	n_name, '
'	c_address, '
'	c_phone, '
'	c_comment '
'from '
'	customer, '
'	orders, '
'	lineitem, '
'	nation '
'where '
'	c_custkey = o_custkey '
'	and l_orderkey = o_orderkey '
'	and o_orderdate >= $1::date '
'	and o_orderdate < $2::date + interval ''3'' month '
'	and l_returnflag = ''R'' '
'	and c_nationkey = n_nationkey '
'group by '
'	c_custkey, '
'	c_name, '
'	c_acctbal, '
'	c_phone, '
'	n_name, '
'	c_address, '
'	c_comment '
'order by '
'	revenue desc '
'limit 20; ',

'select '
'	c_custkey, '
'	c_name, '
'	sum(l_extendedprice * (1 - l_discount)) as revenue, '
'	c_acctbal, '
'	n_name, '
'	c_address, '
'	c_phone, '
'	c_comment '
'from '
'	customer, '
'	orders, '
'	lineitem, '
'	nation '
'where '
'	c_custkey = o_custkey '
'	and l_orderkey = o_orderkey '
'	and o_orderdate >= $1::date '
'	and l_shipdate > $1::date '
'	and o_orderdate < $2::date + interval ''3'' month '
'	and l_shipdate <= $2::date + interval ''7'' month '
'	and l_returnflag = ''R'' '
'	and c_nationkey = n_nationkey '
'group by '
'	c_custkey, '
'	c_name, '
'	c_acctbal, '
'	c_phone, '
'	n_name, '
'	c_address, '
'	c_comment '
'order by '
'	revenue desc '
'limit 20; ', false, 'analyze');


--Q12
SELECT create_query_rule('Q12',
'select '
'	l_shipmode, '
'	sum(case '
'		when o_orderpriority = ''1-URGENT'' '
'			or o_orderpriority = ''2-HIGH'' '
'			then 1 '
'		else 0 '
'	end) as high_line_count, '
'	sum(case '
'		when o_orderpriority <> ''1-URGENT'' '
'			and o_orderpriority <> ''2-HIGH'' '
'			then 1 '
'		else 0 '
'	end) as low_line_count '
'from '
'	orders, '
'	lineitem '
'where '
'	o_orderkey = l_orderkey '
'	and l_shipmode in ($1, $2) '
'	and l_commitdate < l_receiptdate '
'	and l_shipdate < l_commitdate '
'	and l_receiptdate >= $3::date '
'	and l_receiptdate < $4::date + interval ''1'' year '
'group by '
'	l_shipmode '
'order by '
'	l_shipmode; ',

'select '
' l_shipmode, '
' sum(case '
'  when o_orderpriority = ''1-URGENT'' '
'   or o_orderpriority = ''2-HIGH'' '
'  then 1 '
'  else 0 '
' end) as high_line_count, '
' sum(case '
'  when o_orderpriority <> ''1-URGENT'' '
'   and o_orderpriority <> ''2-HIGH'' '
'  then 1 '
'  else 0  '
' end) as low_line_count '
'from '
' orders, '
' lineitem  '
'where '
' o_orderkey = l_orderkey '
' and l_shipmode in ($1, $2) '
' and l_commitdate < l_receiptdate '
' and l_shipdate < l_commitdate '
' and l_receiptdate >= $3::date '
' and l_receiptdate < $4::date + interval ''1'' year '
' and l_shipdate <= $4::date + interval ''15'' month '
' and o_orderdate < $4::date + interval ''1'' year '
'group by '
' l_shipmode '
'order by '
' l_shipmode; ', false, 'analyze');

--Q20
select create_query_rule('Q20',
'select '
	's_name, '
	's_address '
'from '
	'supplier, '
	'nation '
'where '
	's_suppkey in ( '
		'select '
			'ps_suppkey '
		'from '
			'partsupp '
		'where '
			'ps_partkey in ( '
				'select '
					'p_partkey '
				'from '
					'part '
				'where '
					'p_name like $1 '
			') '
			'and ps_availqty > ( '
				'select '
					'0.5 * sum(l_quantity) '
				'from '
					'lineitem '
				'where '
					'l_partkey = ps_partkey '
					'and l_suppkey = ps_suppkey '
					'and l_shipdate >= $2::date ' 
					'and l_shipdate < $3::date + interval ''1'' year '
			') '
	') '
	'and s_nationkey = n_nationkey '
	'and n_name = $4 '
'order by '
	's_name; ',

'select  '
 's_name, '
 's_address ' 
'from  '
 'supplier, ' 
 'nation  '
'where  '
 's_suppkey in( ' 
  'select  '
   'ps_suppkey ' 
  'from  '
   'partsupp, ' 
   '(  '
    'select  '
     'sum(l_quantity) as qty_sum, l_partkey, l_suppkey ' 
    'from  '
     'lineitem ' 
    'where  '
     'l_shipdate >= $2::date  '
     'and l_shipdate < $3::date + interval ''1'' year '
    'group by l_partkey, l_suppkey ) g ' 
  'where  '
   'g.l_partkey = ps_partkey '
   'and g.l_suppkey = ps_suppkey '
   'and ps_availqty > 0.5 * g.qty_sum '
   'and ps_partkey in ( select p_partkey from part where p_name like $1 ) ' 
  ') '
 'and s_nationkey = n_nationkey ' 
 'and n_name = $4 '
'order by s_name; ', false, 'analyze');

--Q21
select create_query_rule('Q21',
'select '
'	s_name, '
'	count(*) as numwait '
'from '
'	supplier, '
'	lineitem l1, '
'	orders, ' 
'	nation '
'where '
'	s_suppkey = l1.l_suppkey '
'	and o_orderkey = l1.l_orderkey '
'	and o_orderstatus = ''F'' '
'	and l1.l_receiptdate > l1.l_commitdate '
'	and exists ( '
'		select '
'			* '
'		from '
'			lineitem l2 '
'		where '
'			l2.l_orderkey = l1.l_orderkey '
'			and l2.l_suppkey <> l1.l_suppkey '
'	) '
'	and not exists ( '
'		select '
'			* '
'		from '
'			lineitem l3 '
'		where '
'			l3.l_orderkey = l1.l_orderkey '
'			and l3.l_suppkey <> l1.l_suppkey '
'			and l3.l_receiptdate > l3.l_commitdate '
'	) '
'	and s_nationkey = n_nationkey '
'	and n_name = $1 '
'group by '
'	s_name '
'order by '
'	numwait desc, '
'	s_name '
'limit 100; ',

'select '
' s_name, '
' count(*) as numwait '
'from '
' supplier, '
' lineitem l1, '
' orders, '
' nation '
'where '
' s_suppkey = l1.l_suppkey '
' and o_orderkey = l1.l_orderkey '
' and o_orderstatus = ''F'' '
' and l1.l_receiptdate > l1.l_commitdate '
' and l1.l_linestatus = ''F'' '
' and l1.l_shipdate <= date ''1995-06-17'' '
' and exists ( '
'  select  '
'   * '
'  from '
'   lineitem l2 '
'  where '
'   l2.l_orderkey = l1.l_orderkey  '
'   and l2.l_suppkey <> l1.l_suppkey  '
'   and l2.l_receiptdate <= l2.l_commitdate '
'   and l2.l_linestatus = ''F'' '
'   and l2.l_shipdate <= date ''1995-06-17'' '
' ) '
' and not exists( '
'  select '
'   * '
'  from  '
'   lineitem l3 '
'  where '
'   l3.l_orderkey = l1.l_orderkey '
'   and l3.l_suppkey <> l1.l_suppkey '
'   and l3.l_receiptdate > l3.l_commitdate '
'   and l3.l_linestatus = ''F'' '
'   and l3.l_shipdate <= date ''1995-06-17'' '
' ) '
' and s_nationkey = n_nationkey  '
' and n_name = $1  '
'group by '
' s_name '
'order by '
' numwait desc, '
' s_name ' 
'limit 100; ', false, 'analyze');

create view sys_user_audit_userlog as select audusername,audhost,audtimestamp,audtype from sys_audit_userlog where audusername=upper(CURRENT_USER);
GRANT SELECT ON sys_user_audit_userlog TO PUBLIC;
REVOKE ALL on sys_audit_userlog FROM public;

create INTERNAL function get_audit_userlog() 
RETURNS setof record AS '
DECLARE
rec1 record;
retval record;
rowuserid int;
suseroid text;
BEGIN 
	rowuserid = 1;
	select CAST(USESYSID AS TEXT) into suseroid from SYS_USER where USENAME=current_user;
	FOR rec1 IN SELECT upper(audusername) as name,audhost,to_char(audtimestamp) as audtime from sys_user_audit_userlog where audtype=''s'' LOOP
		SELECT into retval CAST(rowuserid AS TEXT), suseroid, rec1.name, rec1.audhost, rec1.audtime;
		RETURN NEXT retval;
		rowuserid = rowuserid + 1;
	END LOOP;
END;
' LANGUAGE plsql;


CREATE INTERNAL FUNCTION logon_fail_times(uname name, isdel bool) 
RETURNS INT AS '
DECLARE 
	rec1 record;
	scounts int;
	retval int;
	idx		int;
	time1 timestamptz;
	time2 timestamptz;
BEGIN
	retval = 0;
	SELECT count(*) INTO scounts FROM sys_user_audit_userlog where audtype=''s'';
	
	IF scounts IS NULL THEN
		RETURN 0;
	END IF;
	
	idx = 1;
	IF scounts > 1 THEN
		for rec1 IN select audtimestamp from sys_user_audit_userlog where audtype=''s'' order by audtimestamp desc limit 2 LOOP
			IF idx = 1 THEN
					time1 = rec1.audtimestamp;
			ELSE
					time2 = rec1.audtimestamp;
			END IF;
			idx = idx + 1;
  	END LOOP;
  	SELECT count(*) INTO retval FROM sys_user_audit_userlog where audtype!=''s'' and audtimestamp <=time1 and audtimestamp>=time2; 
  	
	ELSIF scounts = 1 THEN
		SELECT count(*) INTO retval FROM sys_user_audit_userlog where audtype!=''s'';
	END IF;
	

	RETURN retval;
END;
' LANGUAGE plsql;

CREATE VIEW sys_lob_metadata AS 
    SELECT 
		lotype,
		loowner,
		lofilenode,
		lotablespace,
		lokind,
		lotuples,
		lofrozenxid,
		loindexoid,
		locreatetime
    FROM sys_catalog.sys_largeobject_metadata;

CREATE VIEW sys_autovac_err_report AS
    SELECT P.database_id, P.relation_id, P.timestamp
    FROM sys_autovac_err_report() AS P
    (database_id oid, relation_id oid, timestamp timestamptz);

--bug#23244
CREATE VIEW sys_instance AS
	SELECT i.name AS name,
			version() AS db_version,
			sys_kingbase_start_time() AS start_time,
			i.status AS status,
			current_setting('log_archive_start') AS archive_mode
	FROM sys_get_instance_info() AS i(name TEXT, status TEXT);

REVOKE ALL ON  sys_catalog.sys_instance FROM PUBLIC;   
GRANT SELECT ON sys_catalog.sys_instance TO PUBLIC;  
--bug#23244
CREATE VIEW sys_session AS
    SELECT 
            sys_stat_get_backend_pid(S.backendid) AS sess_id,
			case current_setting('compatible_level') = 'oracle'
				when true then
					U.rolname
				else
					NULL
				end as curr_sch,
            U.rolname AS usename, 
            sys_stat_get_backend_client_addr(S.backendid) AS client_ip,
            sys_stat_get_backend_start(S.backendid) AS create_start,
			sys_stat_get_backend_appname(S.backendid) AS appname,
            case sys_stat_get_backend_activity(S.backendid) = '<IDLE>'
				when true then
					null
				else
					sys_stat_get_backend_activity(S.backendid)
				end AS current_query,
			case current_query is null
				when true then
					'<IDLE>'
				else
					'<BUSY>'
			end as status
    FROM (SELECT sys_stat_get_backend_idset() AS backendid) AS S,
            sys_authid U
    WHERE sys_stat_get_backend_userid(S.backendid) = U.oid;

REVOKE ALL ON  sys_catalog.sys_session FROM PUBLIC;   
GRANT SELECT ON sys_catalog.sys_session TO PUBLIC;  
--bug#23244
CREATE VIEW sys_tablespace_info AS
	select d.datname as database_name,
			c.spcname as tablespace_name,
			case c.status
				when true then
					'ONLINE'
				else
					'OFFLINE'
				end as status,
			d.MAXSIZE || ' MB' as totle_size,
			d.FREEBLOCKS*current_setting('block_size')/1024/1024 || ' MB' as free_size,
			d.filename as filename
	from sys_file a,
		 sys_database b,
		 sys_tablespace c,
		 sys_alldatafiles d
	where d.DATNAME=b.DATNAME
	  and b.oid=a.datid
	  and a.spcid=c.oid
	  and a.fileid=d.fileid;

REVOKE ALL ON  sys_catalog.sys_tablespace_info FROM PUBLIC;   
GRANT SELECT ON sys_catalog.sys_tablespace_info TO PUBLIC;

--bug#24298
create or replace procedure audit_schema_object(IN object_type char, IN nspname varchar(64), IN object_operations TEXT, IN audit_mode varchar(20), IN audit_condition varchar(20)) AS
declare
	my_object_name varchar(64);
	my_audit_mode varchar(20);
	my_audit_condition varchar(32);
	stmt TEXT;
	on_object varchar(16);
	nspid oid;
	nargs INT;
	proargnum INT;
	argtypes TEXT;
	my_proargtypes TEXT;
	argtype varchar(64);
	mycur refcursor;
begin
	if (length($2)=0) or ($2 is NULL) or (length($3)=0) or ($3 is NULL) then
		raise exception 'Invalid input parameters';
		return;
	end if;

	if (length($4)=0) or ($4 is NULL) then
		my_audit_mode := '';
	else
		my_audit_mode := ' ' || $4;
	end if;

	if (length($5)=0) or ($5 is NULL) then
		my_audit_condition := '';
	else
		my_audit_condition := ' whenever ' || $5;
	end if;

	stmt := 'select oid from sys_namespace where nspname = ' || '''' || $2 || '''';
	execute stmt into nspid;
	if SQL%NOTFOUND then
		raise exception 'schema % dose not exist', $2;
	else
		if $1 = 'r' then
			on_object := ' on ';
			open mycur for select relname from sys_class where relnamespace = nspid and relkind = 'r';
		elsif $1 = 'v' then
			on_object := ' on ';
			open mycur for select relname from sys_class where relnamespace = nspid and relkind = 'v';
		elsif $1 = 'S' then
			on_object := ' on ';
			open mycur for select relname from sys_class where relnamespace = nspid and relkind = 'S';
		elsif $1 = 'f' then
			on_object := ' on function ';
			open mycur for select proname, pronargs, proargtypes from sys_proc where pronamespace = nspid and protype = 'f' and prokind = 'u' and propkgoid = 0;
		elsif $1 = 'p' then
			on_object := ' on procedure ';
			open mycur for select proname, pronargs, proargtypes from sys_proc where pronamespace = nspid and protype = 'p' and prokind = 'u' and propkgoid = 0;
		elsif $1 = 's' then
			on_object := ' on package ';
			open mycur for select pkgname from sys_package where pkgnamespace = nspid and pkgtype = 's';
		else
			raise exception 'audit: invalid schema object type %', $1;
			return;
		end if;

		if ($1='f') or ($1='p') then
			fetch mycur into my_object_name, nargs, argtypes;
		else
			fetch mycur into my_object_name;
		end if;

		while (mycur%FOUND) loop
			if ($1='f') or ($1='p') then
				my_proargtypes := '';
				proargnum := 1;
				while (proargnum <= nargs) loop
					argtype = split_part(argtypes, ' ', proargnum);
					select typname into argtype from sys_type where oid = argtype;
					if proargnum = nargs then
						my_proargtypes := my_proargtypes || argtype;
					else
						my_proargtypes := my_proargtypes || argtype || ',';
					end if;
					proargnum := proargnum + 1;
				end loop;
				stmt := 'audit ' || $3 || on_object || '"' || my_object_name || '"' || '(' || my_proargtypes || ')' || my_audit_mode || my_audit_condition;
				execute stmt;
				fetch mycur into my_object_name, nargs, argtypes;
			else
				stmt := 'audit ' || $3 || on_object || '"' || my_object_name || '"' || my_audit_mode || my_audit_condition;
				execute stmt;
				fetch mycur into my_object_name;
			end if;
		end loop;
		close mycur;
	end if;
end;

create or replace procedure noaudit_schema_object(IN object_type char, IN nspname varchar(64), IN object_operations TEXT, IN audit_condition varchar(20)) AS
declare
	my_object_name varchar(64);
	stmt TEXT;
	my_audit_condition varchar(32);
	on_object varchar(16);
	nspid oid;
	nargs INT;
	proargnum INT;
	argtypes TEXT;
	my_proargtypes TEXT;
	argtype varchar(64);
	mycur refcursor;
begin
	if (length($2)=0) or ($2 is NULL) or (length($3)=0) or ($3 is NULL) then
		raise exception 'Invalid input parameters';
		return;
	end if;

	if (length($4)=0) or ($4 is NULL) then
		my_audit_condition := '';
	else
		my_audit_condition := ' whenever ' || $4;
	end if;

	stmt := 'select oid from sys_namespace where nspname = ' || '''' || $2 || '''';
	execute stmt into nspid;
	if SQL%NOTFOUND then
		raise exception 'schema % dose not exist', $2;
	else
		if $1 = 'r' then
			on_object := ' on ';
			open mycur for select relname from sys_class where relnamespace = nspid and relkind = 'r';
		elsif $1 = 'v' then
			on_object := ' on ';
			open mycur for select relname from sys_class where relnamespace = nspid and relkind = 'v';
		elsif $1 = 'S' then
			on_object := ' on ';
			open mycur for select relname from sys_class where relnamespace = nspid and relkind = 'S';
		elsif $1 = 'f' then
			on_object := ' on function ';
			open mycur for select proname, pronargs, proargtypes from sys_proc where pronamespace = nspid and protype = 'f' and prokind = 'u' and propkgoid = 0;
		elsif $1 = 'p' then
			on_object := ' on procedure ';
			open mycur for select proname, pronargs, proargtypes from sys_proc where pronamespace = nspid and protype = 'p' and prokind = 'u' and propkgoid = 0;
		elsif $1 = 's' then
			on_object := ' on package ';
			open mycur for select pkgname from sys_package where pkgnamespace = nspid and pkgtype = 's';
		else
			raise exception 'noaudit: invalid schema object type %', $1;
			return;
		end if;

		if ($1='f') or ($1='p') then
			fetch mycur into my_object_name, nargs, argtypes;
		else
			fetch mycur into my_object_name;
		end if;

		while (mycur%FOUND) loop
			if ($1='f') or ($1='p') then
				my_proargtypes := '';
				proargnum := 1;
				while (proargnum <= nargs) loop
					argtype = split_part(argtypes, ' ', proargnum);
					select typname into argtype from sys_type where oid = argtype;
					if proargnum = nargs then
						my_proargtypes := my_proargtypes || argtype;
					else
						my_proargtypes := my_proargtypes || argtype || ',';
					end if;
					proargnum := proargnum + 1;
				end loop;
				stmt := 'noaudit ' || $3 || on_object || '"' || my_object_name || '"' || '(' || my_proargtypes || ')' || my_audit_condition;
				execute stmt;
				fetch mycur into my_object_name, nargs, argtypes;
			else
				stmt := 'noaudit ' || $3 || on_object || '"' || my_object_name || '"' || my_audit_condition;
				execute stmt;
				fetch mycur into my_object_name;
			end if;
		end loop;

		close mycur;
	end if;
end;
