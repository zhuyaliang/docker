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
    1. ESQL types    
    
  MODIFIED
    mzli, jhwang, yhdong   2009/05/06 - ESQL standardization    
     
 */

#ifndef _ESQLTYPE_H
#define _ESQLTYPE_H

/*bug20213 £º¶¨ÒåºêESQL_AUTOTEST */
#define ESQL_AUTOTEST
#include "kingbase-type.h"

#ifdef __cplusplus
extern		"C"
{
#endif

/* add items in the end for this structure, since their values are compared
  * in some functions, and their relative locations can't be changed
  */
enum ESQLType
{
	ESQL_char = 1, ESQL_unsigned_char,
	ESQL_short, ESQL_unsigned_short,
	ESQL_int, ESQL_unsigned_int, ESQL_long, ESQL_unsigned_long,
	ESQL_long_long, ESQL_unsigned_long_long,
	ESQL_bool,
	ESQL_float, ESQL_double,
	ESQL_varchar, ESQL_varchar2,
	ESQL_varchar_std,			/* bug#11566: Varchar in ESQL */
	ESQL_numeric,				/* this is a decimal that stores its digits in
								 * a malloced array */
	ESQL_decimal,				/* this is a decimal that stores its digits in
								 * a fixed array */
	ESQL_date,
	ESQL_timestamp,
	ESQL_interval,
	ESQL_blob,					/* this is a binary large object */
	ESQL_clob,
	ESQL_array,
	ESQL_struct,
	ESQL_union,
	ESQL_descriptor,				/* sql descriptor, no C variable */
	ESQL_char_variable,
	ESQL_const,					/* a constant is needed sometimes */
	ESQL_EOIT,					/* End of insert types. */
	ESQL_EORT,					/* End of result types. */
	ESQL_NO_INDICATOR,			/* no indicator */
	ESQL_EXEPREPARE,			/* bug#11640: support diagnostics:separate EXECUTE IMMEDIATE and EXECUTE prepared_name*/
};

 /* descriptor items */
enum ESQLDescriptorType
{
	ESQLDescriptor_count = 1,
	ESQLDescriptor_data,
	ESQLDescriptor_di_code,
	ESQLDescriptor_di_precision,
	ESQLDescriptor_indicator,
	ESQLDescriptor_key_member,
	ESQLDescriptor_length,
	ESQLDescriptor_name,
	ESQLDescriptor_nullable,
	ESQLDescriptor_octet,
	ESQLDescriptor_precision,
	ESQLDescriptor_ret_length,
	ESQLDescriptor_ret_octet,
	ESQLDescriptor_scale,
	ESQLDescriptor_type,
	ESQLDescriptor_ref_data,
	ESQLDescriptor_ref_indicator,
	ESQLDescriptor_EODT,					/* End of descriptor types. */
	ESQLDescriptor_cardinality,
	/* bug#11498: support descriptor */
	ESQLDescriptor_cs_catalog,
	ESQLDescriptor_cs_schema,
	ESQLDescriptor_cs_name,
	ESQLDescriptor_collation_catalog,
	ESQLDescriptor_collation_schema,
	ESQLDescriptor_collation_name,
	ESQLDescriptor_unnamed,
};

/* bug#11640: support diagnostics.*/
enum ESQLDiagnosticsType
{
	/*statement information item.*/
	ESQLDiagnostics_number = 1,
	ESQLDiagnostics_more,
	ESQLDiagnostics_cmd_function,
	//ESQLDiagnostics_cmd_function_code,
	ESQLDiagnostics_dynamic_function,
	//ESQLDiagnostics_dynamic_function_code,
	ESQLDiagnostics_row_count,
	//ESQLDiagnostics_tran_committed,
	//ESQLDiagnostics_tran_rolled_back,
	//ESQLDiagnostics_tran_active,

	/*condition information item.*/
	ESQLDiagnostics_catalog_name,
	ESQLDiagnostics_class_origin,
	ESQLDiagnostics_column_name,
	ESQLDiagnostics_condition_number,
	ESQLDiagnostics_connection_name,
	ESQLDiagnostics_constraint_catalog,
	ESQLDiagnostics_constraint_name,
	ESQLDiagnostics_constraint_schema,
	ESQLDiagnostics_cursor_name,
	ESQLDiagnostics_message_length,
	ESQLDiagnostics_message_octet_length,
	ESQLDiagnostics_message_text,
	//ESQLDiagnostics_parameter_mode,
	//ESQLDiagnostics_parameter_name,
	//ESQLDiagnostics_parameter_ordinal_position,
	ESQLDiagnostics_returned_sqlstate,
	//ESQLDiagnostics_routine_catalog,
	//ESQLDiagnostics_routine_name,
	//ESQLDiagnostics_routine_schema,
	ESQLDiagnostics_schema_name,
	ESQLDiagnostics_server_name,
	//ESQLDiagnostics_specific_name,
	ESQLDiagnostics_subclass_origin,
	ESQLDiagnostics_table_name,
	//ESQLDiagnostics_trigger_catalog,
	//ESQLDiagnostics_trigger_name,
	//ESQLDiagnostics_trigger_schema,
	ESQLDiagnostics_EODT
};

#define STMT_NULL						-1
#define STMT_UNRECOGNIZED				0
#define STMT_ALLOCATE_DESCRIPTOR		2
#define STMT_ALTER_TABLE				4
#define STMT_CLOSE_CURSOR				9
#define STMT_COMMIT_WORK				14
#define STMT_DEALLOCATE_DESCRIPTOR		15
#define STMT_DELETE_CURSOR				18
#define STMT_DELETE_WHERE				19
#define STMT_DESCRIBE					20
#define STMT_SELECT						21
#define STMT_DROP_TABLE					32
#define STMT_DROP_VIEW					36
#define STMT_DYNAMIC_CLOSE				37
#define STMT_DYNAMIC_DELETE_CURSOR		38
#define STMT_DYNAMIC_FETCH				39
#define STMT_DYNAMIC_OPEN				40
#define STMT_DYNAMIC_UPDATE_CURSOR		42
#define STMT_EXECUTE_IMMEDIATE			43
#define STMT_EXECUTE					44
#define STMT_FETCH						45
#define STMT_GET_DESCRIPTOR				47
#define STMT_GRANT						48
#define STMT_INSERT						50
#define STMT_OPEN						53
#define STMT_PREPARE					56
#define STMT_REVOKE						59
#define STMT_ROLLBACK_WORK				62
#define STMT_SET_DESCRIPTOR				70
#define STMT_SET_TRANSACTION			75
#define STMT_CREATE_TABLE				77
#define STMT_UPDATE_CURSOR				81
#define STMT_UPDATE_WHERE				82
#define STMT_CREATE_VIEW				84

#define IS_SIMPLE_TYPE(type) ((type) >= ESQL_char && (type) <= ESQL_clob)

/* bug#10810 : support updatable cursor */
#define CTID_MAXLEN		10 + 10 + 4
struct sqlcur_t
{
	char			ctid[CTID_MAXLEN];
	unsigned int	xmin;
};

extern struct sqlcur_t sqlcur[];

#ifdef __cplusplus
}
#endif

#endif   /* _ESQLTYPE_H */
