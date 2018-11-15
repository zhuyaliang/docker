/*
 * KingbaseES plsql debug plugin. declare types & funcs needed by debugger.
 */
CREATE TYPE breakpoint AS ( func OID,
							linenumber INTEGER,
							targetName TEXT );
CREATE TYPE frame      AS ( lvl INT, targetname TEXT, func OID, linenumber INTEGER, args TEXT ); --notice: change level to lvl
CREATE TYPE var		   AS ( name TEXT,
							varClass char,
							lineNumber INTEGER,
							isUnique bool,
							isConst bool,
							isNotNull bool,
							dtype OID,
							value TEXT );
CREATE TYPE proxyInfo  AS ( serverVersionStr TEXT,
							serverVersionNum INT,
							proxyAPIVer INT,
							serverProcessID INT );
CREATE TYPE targetinfo AS ( target OID,
							schema OID,
							nargs INT,
							argTypes oidvector,
							targetName NAME,
							argModes char[],
							argNames TEXT[],
							targetLang OID,
							fqName TEXT,
							returnsSet BOOL,
							returnType OID,
							isFunc BOOL,
							pkg OID,
							argDefVals TEXT[]
);

CREATE  OR  REPLACE FUNCTION pldbg_get_target_info(signature text, targetType char) returns targetinfo
AS
declare
	tginfo targetinfo ;
BEGIN
		SELECT p.oid AS target,
		pronamespace AS schema,
		pronargs::int4 AS nargs,
		-- The returned argtypes column is of type oidvector, but unlike
		-- proargtypes, it's supposed to include OUT params. So we
		-- essentially have to return proallargtypes, converted to an
		-- oidvector. There is no oid[] -> oidvector cast, so we have to
		-- do it via text.
		proargtypes  	 AS argtypes,
		proname AS targetname,
		proargmodes AS argmodes,
		proargnames AS proargnames,
		prolang AS targetlang,
		quote_ident(nspname) || '.' || quote_ident(proname) AS fqname,
		proretset AS returnsset,
		prorettype AS returntype,
		't'::bool   AS isfunc,
		'0'::oid   AS pkg,
		NULL::text[] AS argdefvals
		FROM sys_proc p, sys_namespace n
		WHERE p.pronamespace = n.oid
									AND p.oid = $1::oid
									AND $2 = 'o'
		into tginfo;
		return tginfo;
END;
-- for backwards-compatibility
CREATE OR REPLACE FUNCTION plpgsql_oid_debug( functionOID OID ) RETURNS INTEGER
AS
BEGIN
	SELECT pldbg_oid_debug($1) ;
END;

