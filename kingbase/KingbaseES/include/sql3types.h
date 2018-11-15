/* Copyright (c) 2000-2009, KingbaseES Corporation.  All rights reserved.  */

/*
  Author:             KingbaseES
  Date:               2009/05/06
  Source documents:   "Functional Specification for KingbaseES call interface", 
                      and the header file
 
  NAME

    ESQL - KingbaseES's Embedded SQL Language interface
 
  DESCRIPTION

    This header file contains Embedded SQL langauge interface to the KingbaseES
    database. 
 
  RELATED DOCUMENTS

    [1] KingbaseES Online-help
 
  PUBLIC FUNCTION TYPES
    1. Dynamic SQL types
    
  MODIFIED
    mzli, jhwang, yhdong   2009/05/06 - ESQL standardization    
     
 */

#ifndef _ESQL_SQL3TYPES_H
#define _ESQL_SQL3TYPES_H

/* SQL3 dynamic type codes */

enum
{
	SQL3_CHARACTER = 1,
	SQL3_NUMERIC,
	SQL3_DECIMAL,
	SQL3_INTEGER,
	SQL3_SMALLINT,
	SQL3_FLOAT,
	SQL3_REAL,
	SQL3_DOUBLE, /* bug#20612 Support DOUBLE type, distinguish between REAL and FLOAT and DOUBLE type */
	SQL3_BIGINT, /* compatible with oracle */ /* bug#20612 before SQL3_BIGINT= 8,after SQL3_DOUBLE =8 */
	/* bug#11498: support descriptor */
#ifdef ESQL_COMPAT_ORACLE
	SQL3_DATE_TIME_TIMESTAMP = 12,		/* compatible with oracle */
	SQL3_INTERVAL,
	SQL3_CHARACTER_VARYING,
#else
	SQL3_DATE_TIME_TIMESTAMP, 		
	SQL3_INTERVAL,
	SQL3_CHARACTER_VARYING = 12,
#endif
	SQL3_ENUMERATED,
	SQL3_BIT,
	SQL3_BIT_VARYING,
	SQL3_BOOLEAN,
	SQL3_abstract,
	SQL3_TINYINT,
	/* the rest is xLOB stuff */
	/*bug#15365: support clob blob in descriptor*/
	SQL3_BLOB = 30,
	SQL3_CLOB = 40
};

enum
{
	SQL3_DDT_DATE = 1,
	SQL3_DDT_TIME,
	SQL3_DDT_TIMESTAMP,
	SQL3_DDT_TIME_WITH_TIME_ZONE,
	SQL3_DDT_TIMESTAMP_WITH_TIME_ZONE,

	SQL3_DDT_ILLEGAL			/* not a datetime data type (not part of
								 * standard) */
};

/* bug#11498: support descriptor */
enum
{
	SQL3_DDT_INTERVAL_YEAR = 1,
	SQL3_DDT_INTERVAL_MONTH,
	SQL3_DDT_INTERVAL_DAY,
	SQL3_DDT_INTERVAL_HOUR,
	SQL3_DDT_INTERVAL_MINUTE,
	SQL3_DDT_INTERVAL_SECOND,
	SQL3_DDT_INTERVAL_YEAR_TO_MONTH,
	SQL3_DDT_INTERVAL_DAY_TO_HOUR,
	SQL3_DDT_INTERVAL_DAY_TO_MINUTE,
	SQL3_DDT_INTERVAL_DAY_TO_SECOND,
	SQL3_DDT_INTERVAL_HOUR_TO_MINUTE,
	SQL3_DDT_INTERVAL_HOUR_TO_SECOND,
	SQL3_DDT_INTERVAL_MINUTE_TO_SECOND
};

#endif   /* !_ESQL_SQL3TYPES_H */
