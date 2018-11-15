/*
 * PreparedStatement.c
 *
 *		Test the C version of libkci, the Kingbase frontend library.
 *
 *
 * The expected output is:
 *
 *	C1               C2             	C3             
 *	23.5141        123            	aaa            
 *	-32768         -23            	bbb            
 *	32767           -2147483648                  
 *	-1.79E308     2147483647    d              
 *	1.79E308       0              	e               
 *	23.5141        123            	aaa            
 *	-32768         -23            	bbb            
 *	32767           -2147483648                  
 *	-1.79E308     2147483647    d              
 *	1.79E308       0          		e
 *	COUNT          
 *	202000          
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include "../../include/libkci.h"

#define TABLE_ROW		5
#define TABLE_COLUMN	3
#define SQL_MAX_LEN	256
#define SUM_BIND		50
#define SUM_EXECUTE_COUNT	2000


static void
exit_nicely(KCIConnection *conn)
{
	KCIConnectionDestory(conn);
	exit(1);
}

int
main(int argc, char **argv)
{
	KCIConnection	   *conn;
	KCIResult   *res;
	int			nFields;
	int			i,
				j;
				
	/* ����M * N��άָ�����ݴ�����ݵ�ָ��*/			
	char		*values[SUM_EXECUTE_COUNT][TABLE_COLUMN];
	Oid 		types[TABLE_COLUMN] = {0, 0, 0};
	/*�Զ����Ʒ�ʽ���͵����ݳ���bayea���Ͷ�ͳһ���̶��ĳ��ȣ�bytea�������������Ͳ��ø������ݳ��ȣ�ͳһ��0*/
	int		paramLengths[TABLE_COLUMN] = {sizeof(double), sizeof(int), 0}; 
	/*1��ʾ�Զ����Ʒ�ʽ���͵����ݣ�0��ʾ���ַ�����ʽ��������*/
	int		paramFormats[TABLE_COLUMN] = {1, 1, 0};
	/*�ַ�����������*/
	char		*textValues[TABLE_ROW] = {"aaa", "bbb", NULL, "d", "e"};
	/*double��������*/
	double	binaryValues1[TABLE_ROW] = {23.5141, -32768, 32767, -1.79E+308, 1.79E+308};
	/*��������*/
	int		binaryValues2[TABLE_ROW] = {123 , -23 , -2147483648, 2147483647, 0};
	char 	sql[SQL_MAX_LEN] = "insert into T(C1, C2, C3) values($1, $2, $3)";

	/*�õ��������ݵĵ�ַ����Ϊ��������KCI*/
	for(i = 0; i < SUM_EXECUTE_COUNT/TABLE_ROW; i++)
	{
		for(j = 0; j < TABLE_ROW; j++)
		{
			values[i*TABLE_ROW + j][0] = (char*)(&binaryValues1[j]);
			values[i*TABLE_ROW + j][1] = (char*)(&binaryValues2[j]);
			values[i*TABLE_ROW + j][2] = textValues[j];
		}
	}

	/*Connection database*/
	conn = KCIConnectionCreateDeprecated("localhost", "54321", NULL, NULL ,"TEST", "SYSTEM", "MANAGER", "0");

	if (KCIConnectionGetStatus(conn) != CONNECTION_OK)
	{
		fprintf(stderr, "connection to database failed: %s",
				KCIConnectionGetLastError(conn));
		exit_nicely(conn);
	}

	res = KCIStatementExecute(conn, "DROP TABLE T");

	res = KCIStatementExecute(conn, "CREATE TABLE T(C1 FLOAT ,C2 INTEGER ,C3 char(10))");
	if (KCIResultGetStatusCode(res) != EXECUTE_COMMAND_OK)
	{
		fprintf(stderr, "create table failed: %s",
			KCIConnectionGetLastError(conn));
		exit_nicely(conn);
	}

	/*����һ������������ʹ���Prepare������*/
	KCIStatementPrepare(conn, "insert_T", sql, sizeof(types)/sizeof(Oid), types); 
	/*ѭ����ΰ�����*/
	for(i = 0; i < SUM_BIND; i++)
	/*ִ���������ݰ󶨣����͸�������*/
		KCIStatementExecutePrepared(conn, "insert_T", TABLE_COLUMN, SUM_EXECUTE_COUNT, (const char *const *)values, paramLengths, paramFormats, 0); 
	/*ִ����ɣ����͹ر�Prepare������*/
	KCIStatementClosePrepared(conn, "insert_T");

	/*��������������һ����Ҫ�ȴ���Prepare�������ʧ��*/
	KCIStatementExecutePrepared(conn, "insert_T", TABLE_COLUMN, SUM_EXECUTE_COUNT, (const char *const *)values, paramLengths, paramFormats, 0); 

	/*KCI֧�ִ�����ʹ��δ������Prepare*/
	KCIStatementSendWithParams(conn, sql, TABLE_COLUMN, SUM_EXECUTE_COUNT, types, (const char *const *)values, paramLengths , paramFormats ,0);
	for(i = 0; i < SUM_BIND; i++)
		KCIStatementExecutePrepared(conn, "", TABLE_COLUMN, SUM_EXECUTE_COUNT, (const char *const *)values, paramLengths, paramFormats, 0); 
	KCIStatementClosePrepared(conn, "");

	/* �鿴���е�����*/
	res = KCIStatementExecute(conn, "select * from T limit 10");
	if (KCIResultGetStatusCode(res) != EXECUTE_TUPLES_OK)
	{
		fprintf(stderr, "select operation failed: %s",
				KCIConnectionGetLastError(conn));
		exit_nicely(conn);
	}
		
	nFields = KCIResultGetColumnCount(res);
	for (i = 0; i < nFields; i++)
		printf("%-15s", KCIResultGetColumnName(res, i));
	printf("\n");

	/* next, print out the rows */
	for (i = 0; i < KCIResultGetRowCount(res); i++)
	{
		for (j = 0; j < nFields; j++)
			printf("%-15s", KCIResultGetColumnValue(res, i, j));
		printf("\n");
	}
	KCIResultDealloc(res);

	res = KCIStatementExecute(conn, "select count(*) from T");
	nFields = KCIResultGetColumnCount(res);
	for (i = 0; i < nFields; i++)
		printf("%-15s", KCIResultGetColumnName(res, i));
	printf("\n");

	/* next, print out the rows */
	for (i = 0; i < KCIResultGetRowCount(res); i++)
	{
		for (j = 0; j < nFields; j++)
			printf("%-15s", KCIResultGetColumnValue(res, i, j));
		printf("\n");
	}
	KCIResultDealloc(res);
	
	KCIConnectionDestory(conn);

	return 0;
}
