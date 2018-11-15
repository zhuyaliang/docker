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
    1. Lob Operation Functions    
    
  MODIFIED
    mzli, jhwang, yhdong   2009/05/06 - ESQL standardization    
     
 */

#ifndef KBTYPES_LOB
#define KBTYPES_LOB

typedef enum ESQLLobStatus
{
	LO_OPEN,
	LO_READ,
	LO_WRITE,
	LO_CLOSED
}ESQLLobStatus;

typedef enum ESQLWtOption
{
	WT_ONE,
	WT_FIRST,
	WT_NEXT,
	WT_LAST
} ESQLWtOption;

typedef struct
{
	Oid		lobId;
	int		fd;
	ESQLLobStatus	status;
	int		opLen;			/* read/write length */
} ESQLLobLocator;

#ifdef __cplusplus
extern		"C"
{
#endif

typedef ESQLLobLocator ESQLBlobLocator;
/* bug#15365: Support clob operation */
typedef ESQLLobLocator ESQLClobLocator;

extern void ESQLLobLocatorAlloc(int, ESQLLobLocator **);
extern void ESQLLobLocatorDealloc(int, ESQLLobLocator *);
extern void ESQLBlobGetLength(int, const char *, ESQLBlobLocator *, unsigned int *);
extern void ESQLBlobRead(int, const char *, ESQLBlobLocator*, char*, int, int *, int);
extern void ESQLBlobWrite(int, const char *, ESQLBlobLocator*, char*, int, int *, int, ESQLWtOption);

/* bug#15365: Support clob operation */
extern void ESQLClobGetLength(int, const char *, ESQLClobLocator *, unsigned int *);
extern void ESQLClobRead(int, const char *, ESQLClobLocator*, char*, int, int *, int);
extern void ESQLClobWrite(int, const char *, ESQLClobLocator*, char*, int, int *, int, ESQLWtOption);

#ifdef __cplusplus
}
#endif

#endif   /* KBTYPES_LOB */
