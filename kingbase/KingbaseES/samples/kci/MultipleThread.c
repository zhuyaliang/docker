/*
* TestLibkciMultiThread1.c
*
* Before running this, create a database with the following commands
* 
* ./initdb -USYSTEM -WMANAGER -D../test
*
* ./kngbase -D ../test
*
* and create a table, table-name is test in database TEMPLATE2 with the following commands
* 
* ./isql -USYSTEM -WMANAGER -p54321 TEST
*
* CREATE TABLE test (i int);
*
*/

#include <stdio.h>
#include <stdlib.h>

#ifdef WIN32
#include <windows.h>
#include <process.h>

#else
#include <pthread.h>
#include <sys/time.h>
#endif

#include "../../include/libkci.h"

#ifdef WIN32

typedef HANDLE 	pthread_mutex_t;
typedef HANDLE	ThreadHandle;
typedef DWORD	ThreadId;
typedef unsigned		thid_t;

typedef struct KDBThread
{
	ThreadHandle		os_handle;
	thid_t				thid;
} KDBThread;

#else

typedef int			ThreadHandle;
typedef pthread_t	ThreadId;
typedef pthread_t		thid_t;

typedef struct KDBThread
{
	thid_t			os_handle;
} KDBThread;

#define SIGALRM				14

#endif 

static int KDBThreadCreate(KDBThread *tid,
							 void *(*start)(void*),
							 void *arg);
static void KDBSleep(long microsec);
static bool KDBWaitThreadEnd(KDBThread *th);
static void ExitNicely(KCIConnection *conn);
static void ThreadCreate(void);

#define MAX 100
#define SLEEP_TIME1 19000L
#define SLEEP_TIME2 9000L

KDBThread thread[2];
pthread_mutex_t mut;
int number=0;

KCIConnection	   *conn;

void *Thread1()
{
	int i;

	for (i = 0; i < MAX; i++)
	{
		KCIResult   *res;

		printf("thread1: select count=%d...\n", i);              

		res = KCIStatementExecute(conn, "select count(*) from test");

		if (KCIResultGetStatusCode(res) == EXECUTE_TUPLES_OK)
			printf("  result:TableRowCount %-15s \nsucess thread1.\n", KCIResultGetColumnValue(res, 0, 0));
		else
			printf(" faild thread1.\n");
	
		if (res)
			KCIResultDealloc(res);

		KDBSleep(SLEEP_TIME1);
	}              

	printf("thread1 end\n");

	return NULL;
}

void *Thread2()
{
	int i;

	for (i = 0; i < MAX; i++)
	{  
		KCIResult   *res;
		
		printf("thread2: insert count=%d...\n", i);       

		res = KCIStatementExecute(conn, "insert into test values(1)");

		if (KCIResultGetStatusCode(res) == EXECUTE_COMMAND_OK)
			printf("sucess thread2.\n");
		else
			printf("faild thread2.\n");
		if (res)
			KCIResultDealloc(res);

		KDBSleep(SLEEP_TIME2);
	}              
	printf("thread2 end\n");

	return NULL;
}

void ThreadCreate(void)
{
		if(KDBThreadCreate(&thread[0], Thread1, NULL))
	    	printf("create thread 1\n");
		else
			printf("create thread 1 faild\n");

		if(KDBThreadCreate(&thread[1], Thread2, NULL))
			printf("create thread 2\n");
		else
			printf("create thread 2 faild\n");
}

int main()
{
	/* Make a connection to the database */
	conn = KCIConnectionCreateDeprecated("localhost", "54321", NULL, NULL, "TEMPLATE2", "SYSTEM", "MANAGER", "0");

	if (KCIConnectionGetStatus(conn) != CONNECTION_OK)
	{
		fprintf(stderr, "Connection to database failed: %s",
			KCIConnectionGetLastError(conn));
		ExitNicely(conn);
	}

   printf("main process create thread\n");
   ThreadCreate();
   KDBWaitThreadEnd(thread);
   KCIConnectionDestory(conn);
   printf("main process wait thread end execute\n");    
   
   return 0;
}

static bool 
KDBWaitThreadEnd(KDBThread *th)
{

	ThreadHandle hanlde[2];

	hanlde[0]=th[0].os_handle;
	hanlde[1]=th[1].os_handle;
#ifdef WIN32
	WaitForMultipleObjects(2, hanlde, TRUE, INFINITE);
#else
	pthread_join(hanlde[0], NULL);
	pthread_join(hanlde[1], NULL);
#endif
	return true;
}

static int
KDBThreadCreate(KDBThread *th,
				  void *(*start)(void*),
				  void *arg)
{
	int		rc = -1;
#ifdef WIN32
	th->os_handle = (HANDLE)_beginthreadex(NULL,
		0,								
		(unsigned(__stdcall*)(void*)) start,
		arg,			
		0,				
		&th->thid);		

	/* error for returned value 0 */
	if (th->os_handle == (HANDLE) 0)
		th->os_handle = INVALID_HANDLE_VALUE;
	else
		rc = 1;
#else
	rc = pthread_create(&th->os_handle,
		NULL,
		start,
		arg);
#endif
	return rc;
}

static void
KDBSleep(long microsec)
{
	if (microsec > 0)
	{
#ifndef WIN32
		struct timeval delay;

		delay.tv_sec = microsec / 1000000L;
		delay.tv_usec = microsec % 1000000L;
		(void) select(0, NULL, NULL, NULL, &delay);
#else
		SleepEx((microsec < 500 ? 1 : (microsec + 500) / 1000), FALSE);
#endif
	}
}

static void
ExitNicely(KCIConnection *conn)
{
	KCIConnectionDestory(conn);
	exit(1);
}

