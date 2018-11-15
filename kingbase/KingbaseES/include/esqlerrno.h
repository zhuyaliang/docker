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
    1. ESQL error codes
    
  MODIFIED
    mzli, jhwang, yhdong   2009/05/06 - ESQL standardization    
     
 */

#ifndef _ESQL_ERRNO_H
#define _ESQL_ERRNO_H

#include <errno.h>

/* This is a list of all error codes the embedded SQL program can return */
#define ESQL_NO_ERROR		0
#define ESQL_NOT_FOUND		100

/* system error codes returned by esqllib get the correct number,
 * but are made negative
 */
#define ESQL_OUT_OF_MEMORY	-ENOMEM

/* first we have a set of esql messages, they start at 200 */
#define ESQL_UNSUPPORTED		-200
#define ESQL_TOO_MANY_ARGUMENTS		-201
#define ESQL_TOO_FEW_ARGUMENTS		-202
#define ESQL_TOO_MANY_MATCHES		-203
#define ESQL_INT_FORMAT			-204
#define ESQL_UINT_FORMAT		-205
#define ESQL_FLOAT_FORMAT		-206
#define ESQL_NUMERIC_FORMAT		-207
#define ESQL_INTERVAL_FORMAT		-208
#define ESQL_DATE_FORMAT		-209
#define ESQL_TIMESTAMP_FORMAT		-210
#define ESQL_CONVERT_BOOL		-211
#define ESQL_EMPTY			-212
#define ESQL_MISSING_INDICATOR		-213
#define ESQL_NO_ARRAY			-214
#define ESQL_DATA_NOT_ARRAY		-215
#define ESQL_ARRAY_INSERT		-216
#define ESQL_STR_NOT_FINISH	-217
#define ESQL_FIELD_OVERFLOW	-218

#define ESQL_NO_CONN			-220
#define ESQL_NOT_CONN			-221
#define ESQL_TOO_MANY_CLIENTS	-222

#define ESQL_INVALID_STMT		-230
#define ESQL_INVALID_PARA		-231

/* dynamic SQL related */
#define ESQL_UNKNOWN_DESCRIPTOR		-240
#define ESQL_INVALID_DESCRIPTOR_INDEX	-241
#define ESQL_UNKNOWN_DESCRIPTOR_ITEM	-242
#define ESQL_VAR_NOT_NUMERIC		-243
#define ESQL_VAR_NOT_CHAR		-244
#define ESQL_OUT_OF_DESCRIPTOR_FOR_ARRAY_SIZE -245
#define ESQL_DUPLICATED_DESCRIPTOR		-246

/* bug#11640: support diagnostics */
#define ESQL_UNKNOWN_DIAGNOSTICS_ITEM	-260
#define ESQL_INVALID_CONDITION_NUMBER	-261

/* bug#11499: Client Cursor */
#define ESQL_INVALID_CURSOR_STATE		-280

/* lob operations error */
#define ESQL_LOB_INVALID			-300
#define ESQL_LOB_ON_WR				-301
#define ESQL_LOB_OP_ERROR			-302
#define ESQL_LOB_RW_ERROR			-303
#define ESQL_LOB_LACK_DATA			-304

/* bind operations error */
#define ESQL_BIND_UNSUPPORTED		-320
#define ESQL_UNEQUAL_ARRAY_SIZE_FOR_BIND_INPUT_DESC -321
#define ESQL_DATA_INVALID_DESCRIPTOR	-322

/* finally the backend error messages, they start at 400 */
#define ESQL_SQL			-400
#define ESQL_TRANS			-401
#define ESQL_CONNECT			-402
#define ESQL_DUPLICATE_KEY		-403
#define ESQL_SUBSELECT_NOT_ONE		-404
#define ESQL_UNDEFINED_COLUMN	-405
#define ESQL_UNDEFINED_TABLE	-406
#define ESQL_QUERY_CANCELED		-407
#define ESQL_NOT_NULL_VIOLATION	-408
#define ESQL_NULL_VALUE_NOT_ALLOWED	-409
#define ESQL_NUMERIC_VALUE_OUT_OF_RANGE	-410
#define ESQL_STRING_DATA_RIGHT_TRUNCATION	-411

/* for compatibility we define some different error codes for the same error
 * if adding a new one make sure to not double define it */
#define ESQL_INFORMIX_DUPLICATE_KEY -239
#define ESQL_INFORMIX_SUBSELECT_NOT_ONE -284

/* backend WARNINGs, starting at 600 */
#define ESQL_WARNING_UNRECOGNIZED	   -600
 /* WARNING:  (transaction aborted): queries ignored until END */

 /*
  * WARNING:  current transaction is aborted, queries ignored until end of
  * transaction block
  */
#define ESQL_WARNING_QUERY_IGNORED	   -601
 /* WARNING:  PerformPortalClose: portal "*" not found */
#define ESQL_WARNING_UNKNOWN_PORTAL    -602
 /* WARNING:  BEGIN: already a transaction in progress */
#define ESQL_WARNING_IN_TRANSACTION    -603
 /* WARNING:  AbortTransaction and not in in-progress state */
 /* WARNING:  COMMIT: no transaction in progress */
#define ESQL_WARNING_NO_TRANSACTION    -604
 /* WARNING:  BlankPortalAssignName: portal * already exists */
#define ESQL_WARNING_PORTAL_EXISTS	   -605

#endif   /* !_ESQL_ERRNO_H */
