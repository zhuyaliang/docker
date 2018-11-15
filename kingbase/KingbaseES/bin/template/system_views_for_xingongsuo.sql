-- create or replace view sys_stmt_audit_opts
CREATE OR REPLACE VIEW sys_stmt_audit_opts(database_name, user_name, audit_option,
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
	WHERE a.audsetaction NOT BETWEEN 500 AND 502 AND
			(select ((sys_authid.rolsuper='S' AND (u.usesuper = 'N' or a.audsetuser = 0)) or (sys_authid.rolsuper = 'A' AND
					 u.usesuper != 'N')) FROM sys_authid WHERE rolname=getusername())
    ORDER BY user_name, audit_option;

-- create or replace view sys_priv_audit_opts
CREATE OR REPLACE VIEW sys_priv_audit_opts(database_name, user_name, privilege,
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
	WHERE a.audsetaction BETWEEN 500 AND 502 AND 
			(SELECT ((sys_authid.rolsuper='S' AND (u.usesuper = 'N' or a.audsetuser = 0)) or (sys_authid.rolsuper = 'A' AND
					 u.usesuper != 'N')) FROM sys_authid WHERE sys_authid.rolname=getusername())
    ORDER BY user_name, privilege;

-- SYS_AUDIT_TRAIL
CREATE OR REPLACE VIEW sys_audit_trail
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
		 LEFT JOIN sys_authid on a.audusername = sys_authid.rolname where
			(select ((au.rolsuper='S' AND sys_authid.rolsuper = 'N') or (au.rolsuper = 'A' AND
					 sys_authid.rolsuper != 'N')) FROM sys_authid au  WHERE au.rolname=getusername()) 
    ORDER BY a.audtimestamp, a.audsessionid, a.audentryid;

-- create or replace view sys_audit_trail_internal
CREATE or replace VIEW sys_audit_trail_internal
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
		 LEFT JOIN sys_authid on a.audusername = sys_authid.rolname where 
			(select ((au.rolsuper='S' AND sys_authid.rolsuper = 'N') or (au.rolsuper = 'A' AND
					 sys_authid.rolsuper != 'N')) FROM sys_authid au  WHERE au.rolname=getusername())
    ORDER BY a.audtimestamp, a.audsessionid, a.audentryid;

