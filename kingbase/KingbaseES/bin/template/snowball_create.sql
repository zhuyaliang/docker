-- Language-specific snowball dictionaries
-- $PostgreSQL: pgsql/src/backend/snowball/snowball_func.sql.in,v 1.2 2007/09/03 02:30:43 tgl Exp $$

SET search_path = sys_catalog;

CREATE FULLTEXT SEARCH TEMPLATE snowball
	(INIT = dsnowball_init,
	LEXIZE = dsnowball_lexize);

COMMENT ON FULLTEXT SEARCH TEMPLATE snowball IS 'snowball stemmer';

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for danish language
CREATE FULLTEXT SEARCH DICTIONARY danish_stem
	(TEMPLATE = snowball, Language = danish , StopWords="danish");

COMMENT ON FULLTEXT SEARCH DICTIONARY danish_stem IS 'snowball stemmer for danish language';

CREATE FULLTEXT SEARCH CONFIGURATION danish
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION danish IS 'configuration for danish language';

ALTER FULLTEXT SEARCH CONFIGURATION danish ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION danish ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH danish_stem;

ALTER FULLTEXT SEARCH CONFIGURATION danish ADD MAPPING
    FOR word, hword_part, hword
	WITH danish_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for dutch language
CREATE FULLTEXT SEARCH DICTIONARY dutch_stem
	(TEMPLATE = snowball, Language = dutch , StopWords="dutch");

COMMENT ON FULLTEXT SEARCH DICTIONARY dutch_stem IS 'snowball stemmer for dutch language';

CREATE FULLTEXT SEARCH CONFIGURATION dutch
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION dutch IS 'configuration for dutch language';

ALTER FULLTEXT SEARCH CONFIGURATION dutch ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION dutch ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH dutch_stem;

ALTER FULLTEXT SEARCH CONFIGURATION dutch ADD MAPPING
    FOR word, hword_part, hword
	WITH dutch_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for english language
CREATE FULLTEXT SEARCH DICTIONARY english_stem
	(TEMPLATE = snowball, Language = english , StopWords="english");

COMMENT ON FULLTEXT SEARCH DICTIONARY english_stem IS 'snowball stemmer for english language';

CREATE FULLTEXT SEARCH CONFIGURATION english
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION english IS 'configuration for english language';

ALTER FULLTEXT SEARCH CONFIGURATION english ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION english ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH english_stem;

ALTER FULLTEXT SEARCH CONFIGURATION english ADD MAPPING
    FOR word, hword_part, hword
	WITH english_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for finnish language
CREATE FULLTEXT SEARCH DICTIONARY finnish_stem
	(TEMPLATE = snowball, Language = finnish , StopWords="finnish");

COMMENT ON FULLTEXT SEARCH DICTIONARY finnish_stem IS 'snowball stemmer for finnish language';

CREATE FULLTEXT SEARCH CONFIGURATION finnish
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION finnish IS 'configuration for finnish language';

ALTER FULLTEXT SEARCH CONFIGURATION finnish ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION finnish ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH finnish_stem;

ALTER FULLTEXT SEARCH CONFIGURATION finnish ADD MAPPING
    FOR word, hword_part, hword
	WITH finnish_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for french language
CREATE FULLTEXT SEARCH DICTIONARY french_stem
	(TEMPLATE = snowball, Language = french , StopWords="french");

COMMENT ON FULLTEXT SEARCH DICTIONARY french_stem IS 'snowball stemmer for french language';

CREATE FULLTEXT SEARCH CONFIGURATION french
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION french IS 'configuration for french language';

ALTER FULLTEXT SEARCH CONFIGURATION french ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION french ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH french_stem;

ALTER FULLTEXT SEARCH CONFIGURATION french ADD MAPPING
    FOR word, hword_part, hword
	WITH french_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for german language
CREATE FULLTEXT SEARCH DICTIONARY german_stem
	(TEMPLATE = snowball, Language = german , StopWords="german");

COMMENT ON FULLTEXT SEARCH DICTIONARY german_stem IS 'snowball stemmer for german language';

CREATE FULLTEXT SEARCH CONFIGURATION german
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION german IS 'configuration for german language';

ALTER FULLTEXT SEARCH CONFIGURATION german ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION german ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH german_stem;

ALTER FULLTEXT SEARCH CONFIGURATION german ADD MAPPING
    FOR word, hword_part, hword
	WITH german_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for hungarian language
CREATE FULLTEXT SEARCH DICTIONARY hungarian_stem
	(TEMPLATE = snowball, Language = hungarian , StopWords="hungarian");

COMMENT ON FULLTEXT SEARCH DICTIONARY hungarian_stem IS 'snowball stemmer for hungarian language';

CREATE FULLTEXT SEARCH CONFIGURATION hungarian
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION hungarian IS 'configuration for hungarian language';

ALTER FULLTEXT SEARCH CONFIGURATION hungarian ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION hungarian ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH hungarian_stem;

ALTER FULLTEXT SEARCH CONFIGURATION hungarian ADD MAPPING
    FOR word, hword_part, hword
	WITH hungarian_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for italian language
CREATE FULLTEXT SEARCH DICTIONARY italian_stem
	(TEMPLATE = snowball, Language = italian , StopWords="italian");

COMMENT ON FULLTEXT SEARCH DICTIONARY italian_stem IS 'snowball stemmer for italian language';

CREATE FULLTEXT SEARCH CONFIGURATION italian
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION italian IS 'configuration for italian language';

ALTER FULLTEXT SEARCH CONFIGURATION italian ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION italian ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH italian_stem;

ALTER FULLTEXT SEARCH CONFIGURATION italian ADD MAPPING
    FOR word, hword_part, hword
	WITH italian_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for norwegian language
CREATE FULLTEXT SEARCH DICTIONARY norwegian_stem
	(TEMPLATE = snowball, Language = norwegian , StopWords="norwegian");

COMMENT ON FULLTEXT SEARCH DICTIONARY norwegian_stem IS 'snowball stemmer for norwegian language';

CREATE FULLTEXT SEARCH CONFIGURATION norwegian
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION norwegian IS 'configuration for norwegian language';

ALTER FULLTEXT SEARCH CONFIGURATION norwegian ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION norwegian ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH norwegian_stem;

ALTER FULLTEXT SEARCH CONFIGURATION norwegian ADD MAPPING
    FOR word, hword_part, hword
	WITH norwegian_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for portuguese language
CREATE FULLTEXT SEARCH DICTIONARY portuguese_stem
	(TEMPLATE = snowball, Language = portuguese , StopWords="portuguese");

COMMENT ON FULLTEXT SEARCH DICTIONARY portuguese_stem IS 'snowball stemmer for portuguese language';

CREATE FULLTEXT SEARCH CONFIGURATION portuguese
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION portuguese IS 'configuration for portuguese language';

ALTER FULLTEXT SEARCH CONFIGURATION portuguese ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION portuguese ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH portuguese_stem;

ALTER FULLTEXT SEARCH CONFIGURATION portuguese ADD MAPPING
    FOR word, hword_part, hword
	WITH portuguese_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for romanian language
CREATE FULLTEXT SEARCH DICTIONARY romanian_stem
	(TEMPLATE = snowball, Language = romanian );

COMMENT ON FULLTEXT SEARCH DICTIONARY romanian_stem IS 'snowball stemmer for romanian language';

CREATE FULLTEXT SEARCH CONFIGURATION romanian
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION romanian IS 'configuration for romanian language';

ALTER FULLTEXT SEARCH CONFIGURATION romanian ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION romanian ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH romanian_stem;

ALTER FULLTEXT SEARCH CONFIGURATION romanian ADD MAPPING
    FOR word, hword_part, hword
	WITH romanian_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for russian language
CREATE FULLTEXT SEARCH DICTIONARY russian_stem
	(TEMPLATE = snowball, Language = russian , StopWords="russian");

COMMENT ON FULLTEXT SEARCH DICTIONARY russian_stem IS 'snowball stemmer for russian language';

CREATE FULLTEXT SEARCH CONFIGURATION russian
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION russian IS 'configuration for russian language';

ALTER FULLTEXT SEARCH CONFIGURATION russian ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION russian ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH english_stem;

ALTER FULLTEXT SEARCH CONFIGURATION russian ADD MAPPING
    FOR word, hword_part, hword
	WITH russian_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for spanish language
CREATE FULLTEXT SEARCH DICTIONARY spanish_stem
	(TEMPLATE = snowball, Language = spanish , StopWords="spanish");

COMMENT ON FULLTEXT SEARCH DICTIONARY spanish_stem IS 'snowball stemmer for spanish language';

CREATE FULLTEXT SEARCH CONFIGURATION spanish
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION spanish IS 'configuration for spanish language';

ALTER FULLTEXT SEARCH CONFIGURATION spanish ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION spanish ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH spanish_stem;

ALTER FULLTEXT SEARCH CONFIGURATION spanish ADD MAPPING
    FOR word, hword_part, hword
	WITH spanish_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for swedish language
CREATE FULLTEXT SEARCH DICTIONARY swedish_stem
	(TEMPLATE = snowball, Language = swedish , StopWords="swedish");

COMMENT ON FULLTEXT SEARCH DICTIONARY swedish_stem IS 'snowball stemmer for swedish language';

CREATE FULLTEXT SEARCH CONFIGURATION swedish
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION swedish IS 'configuration for swedish language';

ALTER FULLTEXT SEARCH CONFIGURATION swedish ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION swedish ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH swedish_stem;

ALTER FULLTEXT SEARCH CONFIGURATION swedish ADD MAPPING
    FOR word, hword_part, hword
	WITH swedish_stem;

-- $PostgreSQL: pgsql/src/backend/snowball/snowball.sql.in,v 1.6 2007/10/27 16:01:08 tgl Exp $$

-- text search configuration for turkish language
CREATE FULLTEXT SEARCH DICTIONARY turkish_stem
	(TEMPLATE = snowball, Language = turkish , StopWords="turkish");

COMMENT ON FULLTEXT SEARCH DICTIONARY turkish_stem IS 'snowball stemmer for turkish language';

CREATE FULLTEXT SEARCH CONFIGURATION turkish
	(PARSER = default);

COMMENT ON FULLTEXT SEARCH CONFIGURATION turkish IS 'configuration for turkish language';

ALTER FULLTEXT SEARCH CONFIGURATION turkish ADD MAPPING
	FOR email, url, url_path, host, file, version,
	    sfloat, float, int, uint,
	    numword, hword_numpart, numhword
	WITH simple;

ALTER FULLTEXT SEARCH CONFIGURATION turkish ADD MAPPING
    FOR asciiword, hword_asciipart, asciihword
	WITH turkish_stem;

ALTER FULLTEXT SEARCH CONFIGURATION turkish ADD MAPPING
    FOR word, hword_part, hword
	WITH turkish_stem;

