/*
 * testlibkci4.c
 *		this test program shows to use LIBKCI to make multiple backend
 * connections
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include "../../include/libkci.h"

static void
exit_nicely(KCIConnection *conn1, KCIConnection *conn2)
{
	if (conn1)
		KCIConnectionDestory(conn1);
	if (conn2)
		KCIConnectionDestory(conn2);
	exit(1);
}

static void
check_conn(KCIConnection *conn, const char *dbName)
{
	/* check to see that the backend connection was successfully made */
	if (KCIConnectionGetStatus(conn) != CONNECTION_OK)
	{
		fprintf(stderr, "Connection to database \"%s\" failed: %s",
				dbName, KCIConnectionGetLastError(conn));
		exit(1);
	}
}

int
main(int argc, char **argv)
{
	char	   *host,
			   *port,
			   *options,
			   *tty;
	char	   *dbName1,
			   *dbName2;
	char	   *tblName;
	int			nFields;
	int			i,
				j;

	KCIConnection	   *conn1,
			   *conn2;

	/*
	 * KCIResult   *res1, *res2;
	 */
	KCIResult   *res1;

	if (argc != 4)
	{
		fprintf(stderr, "usage: %s tableName dbName1 dbName2\n", argv[0]);
		fprintf(stderr, "      compares two tables in two databases\n");
		exit(1);
	}
	tblName = argv[1];
	dbName1 = argv[2];
	dbName2 = argv[3];


	/*
	 * begin, by setting the parameters for a backend connection if the
	 * parameters are null, then the system will try to use reasonable
	 * defaults by looking up environment variables or, failing that, using
	 * hardwired constants
	 */
	host = NULL;				/* host name of the backend server */
	port = NULL;				/* port of the backend server */
	options = NULL;			/* special options to start up the backend
								 * server */
	tty = NULL;				/* debugging tty for the backend server */

	/* make a connection to the database */
	conn1 = KCIConnectionCreateDeprecated(host, port, options, tty, dbName1, NULL, NULL, "0");
	check_conn(conn1, dbName1);

	conn2 = KCIConnectionCreateDeprecated(host, port, options, tty, dbName2, NULL, NULL, "0");
	check_conn(conn2, dbName2);

	/* start a transaction block */
	res1 = KCIStatementExecute(conn1, "BEGIN");
	if (KCIResultGetStatusCode(res1) != EXECUTE_COMMAND_OK)
	{
		fprintf(stderr, "BEGIN command failed\n");
		KCIResultDealloc(res1);
		exit_nicely(conn1, conn2);
	}

	/*
	 * make sure to KCIResultDealloc() a KCIResult whenever it is no longer needed to
	 * avoid memory leaks
	 */
	KCIResultDealloc(res1);

	/*
	 * fetch instances from the sys_database, the system catalog of databases
	 */
	res1 = KCIStatementExecute(conn1, "DECLARE myportal CURSOR FOR select * from sys_database");
	if (KCIResultGetStatusCode(res1) != EXECUTE_COMMAND_OK)
	{
		fprintf(stderr, "DECLARE CURSOR command failed\n");
		KCIResultDealloc(res1);
		exit_nicely(conn1, conn2);
	}
	KCIResultDealloc(res1);

	res1 = KCIStatementExecute(conn1, "FETCH ALL in myportal");
	if (KCIResultGetStatusCode(res1) != EXECUTE_TUPLES_OK)
	{
		fprintf(stderr, "FETCH ALL command didn't return tuples properly\n");
		KCIResultDealloc(res1);
		exit_nicely(conn1, conn2);
	}

	/* first, print out the attribute names */
	nFields = KCIResultGetColumnCount(res1);
	for (i = 0; i < nFields; i++)
		printf("%-15s", KCIResultGetColumnName(res1, i));
	printf("\n\n");

	/* next, print out the instances */
	for (i = 0; i < KCIResultGetRowCount(res1); i++)
	{
		for (j = 0; j < nFields; j++)
			printf("%-15s", KCIResultGetColumnValue(res1, i, j));
		printf("\n");
	}

	KCIResultDealloc(res1);

	/* close the portal */
	res1 = KCIStatementExecute(conn1, "CLOSE myportal");
	KCIResultDealloc(res1);

	/* end the transaction */
	res1 = KCIStatementExecute(conn1, "END");
	KCIResultDealloc(res1);

	/* close the connections to the database and cleanup */
	KCIConnectionDestory(conn1);
	KCIConnectionDestory(conn2);

/*	 fclose(debug); */
	return 0;
}
