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
    1. Database Connection Control Functions 
    2. Connection Status Functions    
    
  MODIFIED
    mzli, jhwang, yhdong   2009/05/06 - ESQL standardization    
     
 */
 
#ifndef _ESQLLIB_H
#define _ESQLLIB_H

#include "libkci.h"
#include "esqltype.h"
#include "sqlca.h"
#include <string.h>
/* bug#15888:support ORACA */
#include "oraca.h"

#ifndef __cplusplus
#ifndef bool
#define bool char
#endif   /* ndef bool */

#ifndef true
#define true	((bool) 1)
#endif   /* ndef true */
#ifndef false
#define false	((bool) 0)
#endif   /* ndef false */
#endif   /* not C++ */

#ifndef TRUE
#define TRUE	1
#endif   /* TRUE */

#ifndef FALSE
#define FALSE	0
#endif   /* FALSE */

#ifdef __cplusplus
extern		"C"
{
#endif

void		ESQLConnectionInitSqlca(struct sqlca_t * sqlca);
/* bug#15888:support ORACA */
void		ESQLConnectionInitOraca(struct oraca_t * oraca);
bool		ESQLConnectionCheckStatus(int, const char *);
bool		ESQLConnectionSetAutoCommit(int, const char *, const char *);
bool		ESQLConnectionSetConn(int, const char *);
bool		ESQLConnectionCreate(int, int, const char *, const char *, const char *, const char *, int);
bool		ESQLStatementExecute(int, int, int, int, const char *, int,int, const char *,...); /* bug#15883:support in/out descriptor for cursor,statement_type only for cursor status,in preproc for the detail*/
bool		ESQLStatementExecuteTrans(int, const char *, const char *);
bool		ESQLConnectionDestroy(int, const char *);
bool		ESQLStatementPrepare(int, const char *, const char *);
bool		ESQLSatementDeallocate(int, int, const char *);
bool		ESQLStatementDeallocateOne(int, const char *);
bool		ESQLStatementDeallocateAll(int);
char		*ESQLPreparedStatementGetSql(const char *);
char		*ESQLPreparedStatementGetSqlstmt(const char *);

/* bug#11498: support descriptor, ESQLDescribe same as ESQLStatementExecute*/
bool		ESQLDescribe(int, int, int, int, const char *, int, const char *,...);
bool		ESQLDescribeInput(int, int, int, int, const char *, int, const char *,...);

 /* print an error message */
void		ESQLMessagePrint(void);

/* dynamic SQL */

bool		ESQLDescriptorDeallocate(int, const char *);
/* bug#11498: support descriptor */
bool		ESQLDescriptorAllocate(int, int, const char *, int);
bool		ESQLDescriptorGetColumnCount(int, const char *, void *, enum ESQLType vartype);
bool		ESQLDescriptorGetColumn(int, const char *, int,...);
bool		ESQLDescriptorSetRowCount(int, const char *, int);
bool		ESQLDescriptorSetArg(int, int, const char *, int, int,...);

/* dynamic result allocation */
void		ESQLFree(void);

/* updatable cursor */
void		ESQLResetCursor(struct sqlcur_t *);
/* bug#20346: fix g++ compile error */
bool ESQLDeclareCursor(int lineno, const char *connection_name, const char *cursor_name, const char *prepared_name);
bool ESQLOpenCursor(int lineno, const char *connection_name, const char *cursor_name, int is_dynamic_declare);
bool ESQLFetchCursor(int lineno, const char *connection_name, const char *cursor_name, int is_dynamic_declare);
bool ESQLUpdateCursor(int lineno, const char *connection_name, const char *cursor_name, int is_dynamic_declare, struct sqlcur_t *sqlcur);
bool ESQLDeleteCursor(int lineno, const char *connection_name, const char *cursor_name, int is_dynamic_declare, struct sqlcur_t *sqlcur);
bool ESQLCloseCursor(int lineno, const char *connection_name, const char *cursor_name, int is_dynamic_declare);

/* bug#11640: support diagnostics */
bool ESQLGetDiagnosticsStmt(int,...);
bool ESQLGetDiagnosticsException(int lineno, int index,...);
bool ESQLSetDiagnosticsSize(int lineno, int condition_num);

#ifdef __cplusplus
}
#endif

#endif   /* _ESQLLIB_H */
