/*-------------------------------------------------------------------------
 *
 * testlibkci2.c
 *	  test using large objects with libkci
 *
 *
 *-------------------------------------------------------------------------
 */
#ifdef WIN32
#include <io.h>
#endif
#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#ifndef WIN32
#include <unistd.h>
#endif
#include "../../include/libkci.h"


#define BUFSIZE			1024
#define LOB_BLOB	  'B'	
#define LOB_CLOB	  'C'	

static void
pickout_clob(KCIConnection *conn, int lobj_fd, int start, int len)
{
	char	   *buf;
	int			nbytes;
	int			tellpos;

	KCIClobSeek(conn, lobj_fd, start, SEEK_SET);
	buf = malloc(len*4 + 1);

	nbytes = KCIClobRead(conn, lobj_fd, buf, len);
	buf[nbytes] = '\0';
	fprintf(stderr, ">>> %s\n", buf);

	free(buf);
	tellpos = KCIClobTell(conn, lobj_fd);
	fprintf(stderr, "clob_tell %d\n", tellpos);
}

static void
overwrite_clob(KCIConnection *conn, int lobj_fd, int start, int len)
{
	char	   *buf;
	int			nbytes;
	int			i;

	KCIClobSeek(conn, lobj_fd, start, SEEK_SET);
	buf = malloc(len + 1);

	for (i = 0; i < len; i++)
		buf[i] = 'X';
	buf[i] = '\0';

	nbytes = KCIClobWrite(conn, lobj_fd, buf, len);
	if (nbytes <= 0)
		fprintf(stderr, "\nWRITE FAILED!\n");

	free(buf);
	fprintf(stderr, "ok\n");
}

static void
trunpos_clob(KCIConnection *conn, int	lobj_fd, int start, char *search)
{
	int			slen, result;

	slen = 2;

	result = KCIClobPositionLob(conn, lobj_fd, lobj_fd, start);
	fprintf(stderr, "clob_positionlob from %d\n", start);
	fprintf(stderr, ">>> %d, should be 0\n", result);

	result = KCIClobPosition(conn, lobj_fd, search, slen, start);
	fprintf(stderr, "search \"XX\" in large object from %d\n",start);
	fprintf(stderr, ">>> %d\n",result);

	fprintf(stderr, "\nclob_truncate %d\n", result);
	KCIClobTruncate(conn, lobj_fd, result);
}

static void
pickout(KCIConnection *conn, int lobj_fd, int start, int len)
{
	char	   *buf;
	int			nbytes;

	KCIBlobSeek(conn, lobj_fd, start, SEEK_SET);
	buf = malloc(len + 1);

	nbytes = KCIBlobRead(conn, lobj_fd, buf, len);
	buf[nbytes] = '\0';
	fprintf(stderr, ">>> %s\n", buf);

	free(buf);
	fprintf(stderr, "blob_tell %d\n", KCIBlobTell(conn, lobj_fd));
}

static void
overwrite(KCIConnection *conn, int lobj_fd, int start, int len)
{
	char	   *buf;
	int			nbytes;
	int			i;

	KCIBlobSeek(conn, lobj_fd, start, SEEK_SET);
	buf = malloc(len + 1);

	for (i = 0; i < len; i++)
		buf[i] = 'X';
	buf[i] = '\0';

	nbytes = KCIBlobWrite(conn, lobj_fd, buf, len);
	if (nbytes <= 0)
		fprintf(stderr, "\nWRITE FAILED!\n");

	free(buf);
	fprintf(stderr, "ok\n");
}

static void
trunpos(KCIConnection *conn, int lobj_fd, int start, char *search)
{
	int			slen, result;

	slen = 2;

	result = KCIBlobPositionLob(conn, lobj_fd, lobj_fd, start);
	fprintf(stderr, "blob_positionlob from %d\n", start);
	fprintf(stderr, ">>> %d, should be 0\n", result);

	result = KCIBlobPosition(conn, lobj_fd, search, slen, start);
	fprintf(stderr, "search \"XX\" in large object from %d\n",start);
	fprintf(stderr, ">>> %d\n",result);

	fprintf(stderr, "blob_truncate %d\n", result);
	KCIBlobTruncate(conn, lobj_fd, result);
}

static void
exit_nicely(KCIConnection *conn)
{
	KCIConnectionDestory(conn);
	exit(1);
}

static int
testlo_blob(char *in_filename, char *out_filename,
				char	*database)
{
	Oid			lobjOid;
	int			lobj_fd;
	KCIConnection	   *conn;
	KCIResult   *res;

	/*
	 * set up the connection
	 */
	conn = KCIConnectionCreateDeprecated(NULL, NULL, NULL, NULL, database, NULL, NULL, "0");

	/* check to see that the backend connection was successfully made */
	if (KCIConnectionGetStatus(conn) != CONNECTION_OK)
	{
		fprintf(stderr, "Connection to database failed: %s",
				KCIConnectionGetLastError(conn));
		exit_nicely(conn);
	}

	res = KCIStatementExecute(conn, "begin");
	KCIResultDealloc(res);

	printf("create blob 20000 and drop it\n");
	lobjOid = KCILobCreate(conn, 20000, LOB_BLOB);
	if (KCILobDrop(conn, 20000))
			fprintf(stderr, "%s\n", KCIConnectionGetLastError(conn));

	printf("ok\nimporting file \"%s\" ...\n", in_filename);
	lobjOid = KCIBlobImport(conn, in_filename); 
	if (lobjOid == 0)
		fprintf(stderr, "%s\n", KCIConnectionGetLastError(conn));
	else
	{
		printf("\tas large object %u.\n", lobjOid);

		printf("opening large object\n");
		lobj_fd = KCILobOpen(conn, lobjOid, INV_WRITE);
		if (lobj_fd < 0)
			fprintf(stderr, "can't open large object %u", lobjOid);

		printf("ok\npicking out bytes 0-10 of the large object\n");
		pickout(conn, lobj_fd, 0, 10);

		printf("overwriting bytes 10-20 of the large object with X's\n");
		overwrite(conn, lobj_fd, 10, 20);

		printf("truncating the large object with XX's position\n");
		trunpos(conn, lobj_fd, 0, "XX"); 

		printf("closing large object\n");
		KCILobClose(conn, lobj_fd);

		printf("ok\nexporting large object to file \"%s\" ...\n", out_filename);
		KCIBlobExport(conn, lobjOid, out_filename); 
		
		if (KCILobDrop(conn, lobjOid))
			fprintf(stderr, "%s\n", KCIConnectionGetLastError(conn));
	}


	res = KCIStatementExecute(conn, "end");
	KCIResultDealloc(res);
	KCIConnectionDestory(conn);
	return 0;
}

int
testlo_clob(char *in_filename, char *out_filename,
				char	*database, const char *encoding)
{
	Oid			lobjOid;
	int			lobj_fd;
	KCIConnection	   *conn;
	KCIResult   *res;

	/*
	 * set up the connection
	 */
	conn = KCIConnectionCreateDeprecated(NULL, NULL, NULL, NULL, database, NULL, NULL, "0");
	
	/* check to see that the backend connection was successfully made */
	if (KCIConnectionGetStatus(conn) != CONNECTION_OK)
	{
		fprintf(stderr, "Connection to database failed: %s",
				KCIConnectionGetLastError(conn));
		exit_nicely(conn);
	}

	res = KCIStatementExecute(conn, "begin;");
	KCIResultDealloc(res);

	printf("\ncreate clob 20000 and drop it\n");
	lobjOid = KCILobCreate(conn, 20000, LOB_CLOB);
	if (KCILobDrop(conn, 20000))
			fprintf(stderr, "%s\n", KCIConnectionGetLastError(conn));

	printf("ok\nimporting file \"%s\" ...\n", in_filename);
	lobjOid = KCIClobImport(conn, in_filename, encoding); 
	if (lobjOid == 0)
		fprintf(stderr, "%s\n", KCIConnectionGetLastError(conn));
	else
	{
		printf("\tas large object %u.\n", lobjOid);

		printf("opening large object\n");
		lobj_fd = KCILobOpen(conn, lobjOid, INV_WRITE);
		if (lobj_fd < 0)
			fprintf(stderr, "can't open large object %u", lobjOid);

		printf("ok\npicking out characters 0-10 of the large object\n");
		pickout_clob(conn, lobj_fd, 0, 10);

		printf("overwriting characters 10-20 of the large object with X's\n");
		overwrite_clob(conn, lobj_fd, 10, 20);

		printf("truncate the large object with XX's position\n");
		trunpos_clob(conn, lobj_fd, 0, "XX"); 

		printf("closing large object\n");
		KCILobClose(conn, lobj_fd);

		printf("ok\nexporting large object to file \"%s\" ...\n", out_filename);
		KCIClobExport(conn, lobjOid, out_filename, encoding); 

		if (KCILobDrop(conn, lobjOid))
			fprintf(stderr, "%s\n", KCIConnectionGetLastError(conn));
	}

	res = KCIStatementExecute(conn, "end");
	KCIResultDealloc(res);
	KCIConnectionDestory(conn);
	return 0;
}

int
main(int argc, char **argv)
{
	char	   *in_filename, *out_filename;
	char	   *database;
	const char *encoding;
	int	result1, result2;

	if (argc < 4)
	{
		fprintf(stderr, "Usage: %s database_name in_filename out_filename encoding\n",
				argv[0]);
		exit(1);
	}

	database = argv[1];
	in_filename = argv[2];
	out_filename = argv[3];
	encoding = argv[4];

	/*
	 * test blob & clob
	 */
	if (!encoding)
		result1= testlo_blob(in_filename, out_filename, database);
	else
		result2= testlo_clob(in_filename, out_filename, database, encoding);
	
	return 0;
}
