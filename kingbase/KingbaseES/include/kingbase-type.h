/* Copyright (c) 2000-2009, KingbaseES Corporation.  All rights reserved.  */

/*
  Author:             KingbaseES
  Date:                2009/05/06
  Source documents:   "KingbaseES base data type", 
                      and the header file
 
  DESCRIPTION

    This header file contains C language base date type in KingbaseES
    database. 
 
  RELATED DOCUMENTS

    [1] KingbaseES Online-help
 
  PUBLIC FUNCTION TYPES
  define bool
  define Oid
  define Read/write mode flags for inversion (large object)
  define Identifiers of error message fields.
  
  MODIFIED
    wjzeng,pzzhao,hxli   2009/05/06 - KCI standardization    
     
*/



#ifndef KINGBASE_TYPE_H
#define KINGBASE_TYPE_H

#ifndef __cplusplus

#include "kingbase-config.h"

#ifndef bool
typedef char bool;
#endif

#ifndef true
#define true	((bool) 1)
#endif

#ifndef false
#define false	((bool) 0)
#endif
#endif   /* not C++ */


typedef unsigned int Oid;

#ifdef __cplusplus
#define InvalidOid		(Oid(0))
#else
#define InvalidOid		((Oid) 0)
#endif

/*
 *	Read/write mode flags for inversion (large object) calls
 */

#define INV_WRITE		0x00020000
#define INV_READ		0x00040000

/*
 * Identifiers of error message fields.  Kept here to keep common
 * between frontend and backend, and also to export them to libkci
 * applications.
 */
#define KDB_SEVERITY		'S'
#define KDB_SQLSTATE		'C'
#define KDB_MESSAGE_PRIMARY 'M'
#define KDB_MESSAGE_DETAIL	'D'
#define KDB_MESSAGE_HINT	'H'
#define KDB_STATEMENT_POSITION 'P'
#define KDB_INTERNAL_POSITION 'p'
#define KDB_INTERNAL_QUERY	'q'
#define KDB_CONTEXT			'W'
#define KDB_SOURCE_FILE		'F'
#define KDB_SOURCE_LINE		'L'
#define KDB_SOURCE_FUNCTION 'R'

#ifndef ESQL_AUTOTEST
/*
 * intN
 *		Signed integer, EXACTLY N BITS IN SIZE,
 *		used for numerical computations and the
 *		frontend/backend protocol.
 */
#ifndef HAVE_INT8
typedef signed char int8;		/* == 8 bits */
typedef signed short int16;		/* == 16 bits */
typedef signed int int32;		/* == 32 bits */
#endif   /* not HAVE_INT8 */

/*
 * uintN
 *		Unsigned integer, EXACTLY N BITS IN SIZE,
 *		used for numerical computations and the
 *		frontend/backend protocol.
 */
#ifndef HAVE_UINT8
typedef unsigned char uint8;	/* == 8 bits */
typedef unsigned short uint16;	/* == 16 bits */
typedef unsigned int uint32;	/* == 32 bits */
#endif   /* not HAVE_UINT8 */

/*
 * 64-bit integers
 */
#ifdef HAVE_LONG_INT_64
/* Plain "long int" fits, use it */

#ifndef HAVE_INT64
typedef long int int64;
#endif
#ifndef HAVE_UINT64
typedef unsigned long int uint64;
#endif
#elif defined(HAVE_LONG_LONG_INT_64)
/* We have working support for "long long int", use that */

#ifndef HAVE_INT64
typedef long long int int64;
#endif
#ifndef HAVE_UINT64
typedef unsigned long long int uint64;
#endif
#else							/* not HAVE_LONG_INT_64 and not
								 * HAVE_LONG_LONG_INT_64 */

/* Won't actually work, but fall back to long int so that code compiles */
#ifndef HAVE_INT64
typedef long int int64;
#endif
#ifndef HAVE_UINT64
typedef unsigned long int uint64;
#endif

#define INT64_IS_BUSTED
#endif   /* not HAVE_LONG_INT_64 and not
								 * HAVE_LONG_LONG_INT_64 */
#if defined(_AIX) 
typedef signed short int16;
typedef signed int int32;
#endif

/*
 * Common Kingbase datatype names (as used in the catalogs)
 */
typedef int16 int2;
typedef int32 int4;
typedef float float4;
typedef double float8;

/*-------------------------------------------------------------------------
 *		Support for verifying backend compatibility of loaded modules
 *
 * We require dynamically-loaded modules to include the macro call
 *		SYS_EXTERNAL_MODULE;
 * so that we can check for obvious incompatibility, such as being compiled
 * for a different major Kingbase version.
 *
 * To compile with versions of Kingbase that do not support this,
 * you may put an #ifdef/#endif test around it.  Note that in a multiple-
 * source-file module, the macro call should only appear once.
 *
 * The specific items included in the magic block are intended to be ones that
 * are custom-configurable and especially likely to break dynamically loaded
 * modules if they were compiled with other values.  Also, the length field
 * can be used to detect definition changes.
 *
 * Note: we compare magic blocks with memcmp(), so there had better not be
 * any alignment pad bytes in them.
 *-------------------------------------------------------------------------
 */

/*
 * Maximum number of arguments to a function.
 *
 * The minimum value is 8 (index cost estimation uses 8-argument functions).
 * The maximum possible value is around 600 (limited by index tuple size in
 * pg_proc's index; BLCKSZ larger than 8K would allow more).  Values larger
 * than needed will waste memory and processing time, but do not directly
 * cost disk space.
 *
 * Changing this does not require an initdb, but it does require a full
 * backend recompile (including any user-defined C functions).
 */
#define FUNC_MAX_ARGS		100

/*
 * Maximum number of columns in an index.  There is little point in making
 * this anything but a multiple of 32, because the main cost is associated
 * with index tuple header size (see access/itup.h).
 *
 * Changing this requires an initdb.
 */
#define INDEX_MAX_KEYS		32
#define CLUSTER_MAX_KEYS	32

/*
 * NAMEDATALEN is the max length for system identifiers (e.g. table names,
 * attribute names, function names, etc).  It must be a multiple of
 * sizeof(int) (typically 4).
 *
 * NOTE that databases with different NAMEDATALEN's cannot interoperate!
 */
#define FUNNAMEDATALEN 64

/* defines for dynamic linking on Win32 platform */
#ifdef WIN32
#define DLL_IMPORT __declspec (dllimport)
#else
#define DLL_IMPORT
#endif

/* Definition of the magic block structure */
typedef struct
{
	int			len;			/* sizeof(this struct) */
	int			version;		/* Kingbase major version */
	int			funcmaxargs;	/* FUNC_MAX_ARGS */
	int			indexmaxkeys;	/* INDEX_MAX_KEYS */
	int			namedatalen;	/* NAMEDATALEN */
	int			float4byval;	/* FLOAT4PASSBYVAL */
	int			float8byval;	/* FLOAT8PASSBYVAL */
} magic_struct;

/* The actual data block contents */
#define SYS_EXTERNAL_MODULE_DATA \
{ \
	sizeof(magic_struct), \
	KINGBASE_VERSION_NUM / 100, \
	FUNC_MAX_ARGS, \
	INDEX_MAX_KEYS, \
	FUNNAMEDATALEN, \
	FLOAT4PASSBYVAL, \
	FLOAT8PASSBYVAL \
}

/*
 * Declare the module magic function.It needs to be a function as the dlsym
 * in the backend is only guaranteed to work on functions, not data
 */
typedef const magic_struct *(*ModuleMagicFunction) (void);

#define MAGIC_FUNCTION_NAME sys_external_func
#define MAGIC_FUNCTION_NAME_STRING "sys_external_func"

#define SYS_EXTERNAL_MODULE \
extern DLL_IMPORT const magic_struct *MAGIC_FUNCTION_NAME(void); \
const magic_struct * \
MAGIC_FUNCTION_NAME(void) \
{ \
	static const magic_struct sys_external_data = SYS_EXTERNAL_MODULE_DATA; \
	return &sys_external_data; \
} \
extern int no_such_variable
#endif

#endif   /* LIBKCI_TYPE_H */

