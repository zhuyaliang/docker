/* Copyright (c) 2000-2010, BeiJing BaseSoft Information Technilogies Inc..  All rights reserved.  */

/*
  Author:             KingbaseES
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
    1. Sqlda Structures and  Functions.
     
 */

#ifndef KINGBASE_SQLDA_H
#define KINGBASE_SQLDA_H

#ifdef __cplusplus
extern		"C"
{
#endif

struct SQLDA
{
	int		N;		/* Descriptor size in number of entries*/
	char	**V;	/* Ptr to Arr of addresses of main variables */
	int		*L;		/* Ptr to Arr of lengths of buffers */
	short	*T;		/* Ptr to Arr of types of buffers */
	short	**I;	/* Ptr to Arr of addresses of indicator vars */
	int		F;		/* Number of variables found by DESCRIBE */
	char	**S;	/* Ptr to Arr of variable name pointers */
	short	*M;		/* Ptr to Arr of max lengths of var. names */
	short	*C;		/* Ptr to Arr of current lengths of var. names */
	char	**X;	/* Ptr to Arr of ind. var. name pointers */
	short	*Y;		/* Ptr to Arr of max lengths of ind. var. names */
	short	*Z;		/* Ptr to Arr of cur lengths of ind. var. names */
};
 
typedef struct SQLDA SQLDA;
 
SQLDA	*ESQLSQLDAAlloc(unsigned int, unsigned  int, unsigned int);
void	ESQLSQLDAFree(SQLDA *);
void	ESQLNumericGetPrecAndScale(unsigned int *, int *, int *);
void	ESQLColumnNullCheck(unsigned short *, unsigned short *, int *);
void	ESQLSQLDAPassInfo(int, int, int, char *, SQLDA *, char *, bool);
void	ESQLSQLDAFetchRow(int, int, int, char *, char *, SQLDA *);
SQLDA	*sqlald(unsigned int, unsigned  int, unsigned int);
void	sqlclu(SQLDA *);

#ifdef __cplusplus
}
#endif

#endif


