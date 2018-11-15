/*
 * testlibkci.c
 *
 *		Test the C version of libkci, the Kingbase frontend library.
 */
#include <stdio.h>
#include <stdlib.h>
#include "../../include/libkci.h"

static void
exit_nicely(KCIConnection *conn)
{
	KCIConnectionDestory(conn);
	exit(1);
}

int
main(int argc, char **argv)
{
	const char *conninfo;
	KCIConnection	   *conn;
	KCIResult   *res;
	int			nFields;
	int			i,
				j;

	/*
	 * If the user supplies a parameter on the command line, use it as the
	 * conninfo string; otherwise default to setting dbname=TEMPLATE2 and using
	 * environment variables or defaults for all other connection parameters.
	 */
	if (argc > 1)
		conninfo = argv[1];
	else
		conninfo = "dbname = TEMPLATE2";

	/* Make a connection to the database */
	conn = KCIConnectionCreate(conninfo);

	/* Check to see that the backend connection was successfully made */
	if (KCIConnectionGetStatus(conn) != CONNECTION_OK)
	{
		fprintf(stderr, "Connection to database failed: %s",
				KCIConnectionGetLastError(conn));
		exit_nicely(conn);
	}

	/*
	 * Our test case here involves using a cursor, for which we must be inside
	 * a transaction block.  We could do the whole thing with a single
	 * KCIStatementExecute() of "select * from sys_database", but that's too trivial to make
	 * a good example.
	 */

	/* Start a transaction block */
	res = KCIStatementExecute(conn, "BEGIN");
	if (KCIResultGetStatusCode(res) != EXECUTE_COMMAND_OK)
	{
		fprintf(stderr, "BEGIN command failed: %s", KCIConnectionGetLastError(conn));
		KCIResultDealloc(res);
		exit_nicely(conn);
	}

	/*
	 * Should clear KCIResult whenever it is no longer needed to avoid memory
	 * leaks
	 */
	KCIResultDealloc(res);

	/*
	 * Fetch rows from sys_database, the system catalog of databases
	 */
	res = KCIStatementExecute(conn, "DECLARE myportal CURSOR FOR select * from sys_database");
	if (KCIResultGetStatusCode(res) != EXECUTE_COMMAND_OK)
	{
		fprintf(stderr, "DECLARE CURSOR failed: %s", KCIConnectionGetLastError(conn));
		KCIResultDealloc(res);
		exit_nicely(conn);
	}
	KCIResultDealloc(res);

	res = KCIStatementExecute(conn, "FETCH ALL in myportal");
	if (KCIResultGetStatusCode(res) != EXECUTE_TUPLES_OK)
	{
		fprintf(stderr, "FETCH ALL failed: %s", KCIConnectionGetLastError(conn));
		KCIResultDealloc(res);
		exit_nicely(conn);
	}

	/* first, print out the attribute names */
	nFields = KCIResultGetColumnCount(res);
	for (i = 0; i < nFields; i++)
		printf("%-15s", KCIResultGetColumnName(res, i));
	printf("\n\n");

	/* next, print out the rows */
	for (i = 0; i < KCIResultGetRowCount(res); i++)
	{
		for (j = 0; j < nFields; j++)
			printf("%-15s", KCIResultGetColumnValue(res, i, j));
		printf("\n");
	}

	KCIResultDealloc(res);

	/* close the portal ... we don't bother to check for errors ... */
	res = KCIStatementExecute(conn, "CLOSE myportal");
	KCIResultDealloc(res);

	/* end the transaction */
	res = KCIStatementExecute(conn, "END");
	KCIResultDealloc(res);

	/* close the connection to the database and cleanup */
	KCIConnectionDestory(conn);

	return 0;
}
