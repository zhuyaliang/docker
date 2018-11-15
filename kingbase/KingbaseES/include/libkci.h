/* Copyright (c) 2000-2009, KingbaseES Corporation.  All rights reserved.  */

/*
  Author:             KingbaseES
  Date:                2009/05/06
  Source documents:   "Functional Specification for KingbaseES call interface", 
                      and the header file
 
  NAME

    KCI - KingbaseES's external C Language interface
 
  DESCRIPTION

    This header file contains C langauge interface to the KingbaseES
    database. 
 
  RELATED DOCUMENTS

    [1] KingbaseES Online-help
 
  PUBLIC FUNCTION TYPES
    1. Database Connection Control Functions 
    2. Connection Status Functions 
    3. Command Execution Functions 
        3.1. Main Functions 
        3.2. Retrieving Query Result Information 
        3.3. Retrieving Result Information for Other Commands 
        3.4. Escaping Strings for Inclusion in SQL Commands 
        3.5. Escaping Binary Strings for Inclusion in SQL Commands 
    4. Asynchronous Command Processing 
    5. Cancelling Queries in Progress 
    6. Functions Associated with the COPY Command
    7. Control Functions 
    8. Largeobject Functions
    9. Miscellaneous Functions 
    
    
  MODIFIED
    wjzeng,pzzhao,hxli  2009/05/06 - KCI standardization    
     
 */

#ifndef LIBKCI_H
#define LIBKCI_H

#ifdef __cplusplus
extern		"C"
{
#endif

#include <stdio.h>

#include "kingbase-type.h"


#ifndef __GNUC__
#define __attribute__(_arg_)
#endif


/*****************************************************************************/
/*                     VARIABLE DEFINITION                                   */
/*****************************************************************************/

typedef enum
{
	/*
	 * Although it is okay to add to this list, values which become unused
	 * should never be removed, nor should constants be redefined - that would
	 * break compatibility with existing code.
	 */
	CONNECTION_OK,
	CONNECTION_BAD,

	/* Non-blocking mode only below here */

	/*
	 * The existence of these should never be relied upon - they should only
	 * be used for user feedback or similar purposes.
	 */
	CONNECTION_STARTED,			/* Waiting for connection to be made.  */
	CONNECTION_MADE,			/* Connection OK; waiting to send.	   */
	CONNECTION_AWAITING_RESPONSE,		/* Waiting for a response from the
										 * kingbase.					*/
	CONNECTION_AUTH_OK,			/* Received authentication; waiting for
								 * backend startup. */
	CONNECTION_SETENV,			/* Negotiating environment. */
	CONNECTION_SSL_STARTUP,		/* Negotiating SSL. */
	CONNECTION_TRAENC_STARTUP,	/*Negotiating the crypto transport*/
	CONNECTION_NEEDED,			/* Internal state: connect() needed */
	CONNECTION_UNKNOWN			/* Timeout or interruption happened */
} KCIConnectionStatus;

typedef enum
{
	POLLING_FAILED = 0,
	POLLING_READING,		/* These two indicate that one may	  */
	POLLING_WRITING,		/* use select before polling again.   */
	POLLING_OK,
	POLLING_ACTIVE		/* unused; keep for awhile for backwards
								 * compatibility */
} KCIPollingStatus;

typedef enum
{
	EXECUTE_EMPTY_QUERY = 0,		/* empty query string was executed */
	EXECUTE_COMMAND_OK,			/* a query command that doesn't return
								 * anything was executed properly by the
								 * backend */
	EXECUTE_TUPLES_OK,			/* a query command that returns tuples was
								 * executed properly by the backend, KCIResult
								 * contains the result tuples */
	EXECUTE_COPY_OUT,				/* Copy Out data transfer in progress */
	EXECUTE_COPY_IN,				/* Copy In data transfer in progress */
	EXECUTE_COPY_BOTH,
	EXECUTE_BAD_RESPONSE,			/* an unexpected response was recv'd from the
								 * backend */
	EXECUTE_NONFATAL_ERROR,		/* notice or warning message */
	EXECUTE_FATAL_ERROR			/* query failed */
} KCIExecuteStatus;

typedef enum
{
	TRANSACTION_IDLE,				/* connection idle */
	TRANSACTION_ACTIVE,				/* command in progress */
	TRANSACTION_INTRANS,			/* idle, within transaction block */
	TRANSACTION_INERROR,			/* idle, within failed transaction */
	TRANSACTION_UNKNOWN				/* cannot determine status */
} KCITransactionStatus;

typedef enum
{
	ERRORS_TERSE,				/* single-line error messages */
	ERRORS_DEFAULT,			/* recommended style */
	ERRORS_VERBOSE			/* all the facts, ma'am */
} KCIErrorVerbosity;

/* KCIConnection encapsulates a connection to the backend.
 * The contents of this struct are not supposed to be known to applications.
 */
typedef struct KCIConnection KCIConnection;

/* KCIResult encapsulates the result of a query (or more precisely, of a single
 * SQL command --- a query string given to KCIStatementSend can contain multiple
 * commands and thus return multiple KCIResult objects).
 * The contents of this struct are not supposed to be known to applications.
 */
typedef struct KCIResult KCIResult;

/* KCICancel encapsulates the information needed to cancel a running
 * query on an existing connection.
 * The contents of this struct are not supposed to be known to applications.
 */
typedef struct KCICancelRequest KCICancelRequest;


/* Print options for KCIResultPrint() */

typedef struct KCIPrintOption
{
	char		header;			/* print output field headings and row count */
	char		align;			/* fill align the fields */
	char		standard;		/* old brain dead format */
	char		html3;			/* output html tables */
	char		expanded;		/* expand tables */
	char		pager;			/* use pager for output if needed */
	char	   *fieldSep;		/* field separator */
	char	   *tableOpt;		/* insert to HTML <table ...> */
	char	   *caption;		/* HTML <caption> */
	char	  **fieldName;		/* null terminated array of replacement field
								 * names */
} KCIPrintOption;


/* ----------------
 * KCIArgBlock -- structure for KCIExecuteFunction() arguments
 * ----------------
 */
typedef struct
{
	int			len;
	int			utype;
	int			aformat;
	union
	{
		int		   *ptr;		/* can't use void (dec compiler barfs)	 */
		int			integer;
		char			ch;
	}			u;
} KCIArgument;

/* define utype */
#define	ISPOINTER		0
#define	ISINT			1
#define	ISCHAR			2

/* ShmOption is used in KCIConnectionCreateDeprecatedAsService both on Windows and Linux. */
typedef struct KCIShmOption
{
	char	useSharedMemory;
	char	*dataDir;
	char	*binDir;
	char	autoStartup;
	char	autoShutdown;
} KCIShmOption;

#define ConnModeIsShm(shm_option)		((shm_option).useSharedMemory)
#define ConnModeIsTcp(shm_option)		(!(shm_option).useSharedMemory)
#define IsAutoStartupMode(shm_option)	((shm_option).autoStartup)
#define IsAutoShutdownMode(shm_option)	((shm_option).autoShutdown)
#define	SQL_NTS		(-3)

#ifdef WIN32

#define MODE_TCPIP	"TCPIP"
#define MODE_SHARED_MEMORY "SHARED_MEMORY"

#define CONNMODE_OPTION_ERROR "--connmode(-m) must be \""MODE_TCPIP"\" or \""MODE_SHARED_MEMORY"\""
#define SHM_OPTION_HELP  "  -m, --connmode           specify mode used to connect to database server,\n" \
				    	 "                           should be \""MODE_TCPIP"\" or \""MODE_SHARED_MEMORY"\"\n" \
						 "  -D, --datadir            specify data directory to startup or connect to\n" \
						 "                           database server\n" \
						 "  -B, --bindir             specify binary directory to startup database server\n" \
						 "  -y, --auto-startup       auto startup database server\n" \
						 "  -Y, --auto-shutdown      auto shutdown database server\n"

#endif /* WIN32 */

/*
 * KCIExpBuffer provides an indefinitely-extensible string data type.
 * It can be used to buffer either ordinary C strings (null-terminated text)
 * or arbitrary binary data.  All storage is allocated with malloc().
 *
 * This module is essentially the same as the backend's StringInfo data type,
 * but it is intended for use in frontend libkci and client applications.
 * Thus, it does not rely on palloc() nor elog().
 *
 * It does rely on vsnprintf(); if configure finds that libc doesn't provide
 * a usable vsnprintf(), then a copy of our own implementation of it will
 * be linked into libkci.
 */

/*-------------------------
 * KCIExpBufferData holds information about an extensible string.
 *		data	is the current buffer for the string (allocated with malloc).
 *		len		is the current string length.  There is guaranteed to be
 *				a terminating '\0' at data[len], although this is not very
 *				useful when the string holds binary data rather than text.
 *		maxlen	is the allocated size in bytes of 'data', i.e. the maximum
 *				string size (including the terminating '\0' char) that we can
 *				currently store in 'data' without having to reallocate
 *				more space.  We must always have maxlen > len.
 *-------------------------
 */
typedef struct KCIExpBufferData
{
	char	   *data;
	size_t		len;
	size_t		maxLen;
} KCIExpBufferData;

typedef KCIExpBufferData *KCIExpBuffer;

/* KCINotify represents the occurrence of a NOTIFY message.
 * Ideally this would be an opaque typedef, but it's so simple that it's
 * unlikely to change.
 */
typedef struct kciNotify
{
	char	   *relname;			/* notification condition name */
	int			be_pid;		/* process ID of notifying server process */
	char	   *extra;			/* notification parameter */
	/* Fields below here are private to libkci; apps should not use 'em */
	struct kciNotify *next;		/* list link */
} KCINotify;

/*------------------------
 * Initial size of the data buffer in a KCIExpBuffer.
 * NB: this must be large enough to hold error messages that might
 * be returned by KCICancelCurrent() or any routine in fe-auth.c.
 *------------------------
 */
#define INITIAL_EXPBUFFER_SIZE	256


typedef void (*KCISigFunc) (int);
/* Function types for notice-handling callbacks */
typedef void (*KCINoticeReceiver) (void *arg, const KCIResult *res);
typedef void (*KCINoticeProcessor) (void *arg, const char *message);


/*------------------ VARIABLE DEFINITION  end -------------------------------*/


/*****************************************************************************/
/*                     FUNCTION DEFINITION                                   */
/*****************************************************************************/

/*------------------ 1. Database Connection Control Functions ---------------*/

/*
 * NAME: KCIConnectionCreate
 *
 * 
 * DESCRIPTION:           
 * Establishes a connection to a kingbaseES server by using connection information
 * in a string.
 *
 * 
 * PARAMETERS: 
 * The conninfo string is a white-separated list of
 *
 *	   option = value
 *
 * definitions. Value might be a single value containing no whitespaces or
 * a single quoted string. If a single quote should appear anywhere in
 * the value, it must be escaped with a backslash like \'
 *  
 *  
 * RETURNS: 
 * Returns a KCIConnection* which is needed for all subsequent libkci calls, or NULL
 * if a memory allocation failed.
 * If the status field of the connection returned is CONNECTION_BAD,
 * then some fields may be null'ed out instead of having valid values.
 *
 * You should call KCIConnectionDestory (if conn is not NULL) regardless of 
 * whether this call succeeded.
 */
extern KCIConnection *KCIConnectionCreate(const char *conninfo);

/*
 * NAME: KCIConnectionStart
 *
 * 
 * DESCRIPTION:           
 * Make a connection to the database server in a nonblocking manner with 
 * with function KCIConnectionPoll.
 *
 * 
 * PARAMETERS: 
 * The conninfo string is  in the same format as described 
 * above for KCIConnectionCreate. 
 * 
 *  
 * RETURNS: 
 * Returns a KCIConnection* conn which is needed for KCIConnectionPoll calls,
 * If conn is null, then libkci has been unable to allocate a new KCIConnection structure.
 * If the status field of the conn returned is CONNECTION_BAD,
 * then KCIConnectionStart failed.
 *
 * You should call KCIConnectionPoll (if conn is not NULL)to accomplish the connect
 * if KCIConnectionStart returns a non-null pointer, you must call KCIConnectionDestory
 * when you are finished with it, in order to dispose of the structure and any associated 
 * memory blocks. 
 * This must be done even if the connection attempt fails or is abandoned. 
 *  
 */
extern KCIConnection *KCIConnectionStart(const char *conninfo);

/*
 * NAME: KCIConnectionPoll
 *
 * 
 * DESCRIPTION:           
 * Make a connection to the database server in a nonblocking manner with 
 * with function KCIConnectionStart.
 *
 * 
 * PARAMETERS: 
 * the KCIConnection * conn which a not NULL value return from KCIConnectionStart;   
 * 
 * 
 * RETURNS: 
 * Returns a KCIPollingStatus* 
 * if last return is
 *  POLLING_READING: wait until the socket is ready to read ,
 *                   then call KCIConnectionPoll again; 
 *  POLLING_WRITING: wait until the socket is ready to write,
 *                   then call KCIConnectionPoll again;   
 * 	POLLING_FAILED = 0 : connect failed;
 *	POLLING_OK     : connect succeed.	 
 * 
 */
extern KCIPollingStatus KCIConnectionPoll(KCIConnection *conn);

/*
 * NAME: KCIConnectionCreateDeprecated
 *
 * 
 * DESCRIPTION:           
 * Makes a new connection to the database server.
 *
 * 
 * PARAMETERS: 
 *  const char *host: host 
 *  const char *port: port
 *  const char *options: options
 *  const char *tty: Ignored (formerly, this specified where to send server debug output). 
 *  const char *dbName: database name
 *  const char *login: login name
 *  const char *pwd: password
 *
 *  
 * RETURNS: 
 * Returns a KCIConnection* which is needed for all subsequent libkci calls, or NULL
 * if a memory allocation failed.
 * If the status field of the connection returned is CONNECTION_BAD,
 * then some fields may be null'ed out instead of having valid values.
 * 
 * If the dbName contains an = sign, it is taken as a conninfo string in exactly
 * the same way as if it had been passed to KCIConnectionCreate, and the remaining parameters 
 * are then applied as above.   
 * 
 */
extern KCIConnection *KCIConnectionCreateDeprecated(const char *host, const char *port,
			 const char *options, const char *tty,
			 const char *dbName,
			 const char *login, const char *pwd,
			const char *comm_compress_encrypt);

/*
 * NAME: KCIConnectionCreateDeprecatedAsService
 *
 *
 * DESCRIPTION:           
 * Makes a new connection to the database server with serviceName.
 *
 * 
 * PARAMETERS: 
 *  const char *host: host 
 *  const char *port: port
 *  const char *options: options
 *  const char *tty: Ignored (formerly, this specified where to send server debug output).
 *  const char *Name: database name
 *  const char *login: login name
 *  const char *pwd: password
 *  const bool haspwd: true, use inputed pwd ; false, use empty string ("") as pwd regardless of input.
 *  const char *configDir:  the directory folder of service_conf
 *  const char *serviceName:  the name of service 
 *  const KCIShmOption *shm_option:  
 *         typedef struct KCIShmOption
 *          {
 *           	char	useSharedMemory;
 *           	char	*dataDir;
 *           	char	*binDir;
 *           	char	autoStartup;
 *           	char	autoShutdown;
 *          } KCIShmOption;           	 	 	 	 	  
 *
 *  
 * RETURNS: 
 * Returns a KCIConnection* which is needed for all subsequent libkci calls, or NULL
 * if a memory allocation failed.
 * If the status field of the connection returned is CONNECTION_BAD,
 * then some fields may be null'ed out instead of having valid values.
 * 
 */
extern KCIConnection *KCIConnectionCreateDeprecatedAsService(const char *host, const char *port,
			 const char *options, const char *tty, const char *dbName,
			 const char *login, const char *pwd, const bool haspwd,
			 const char *configDir, const char *serviceName, const KCIShmOption *shm_option,
			 const char *comm_compress_encrypt);

/*
 * NAME: KCIConnectionDestory
 *
 * 
 * DESCRIPTION:           
 * Closes the connection to the server. Also frees memory used by the KCIConnection object.
 *
 * 
 * PARAMETERS: 
 * KCIConnection* conn : The connection object to send the command through
 *
 *  
 * RETURNS: 
 *  void
 *  Note that even if the server connection attempt fails (as indicated by 
 *  KCIConnectionGetStatus),the application should call KCIConnectionDestory 
 *  to free the memory used by the KCIConnection object. The KCIConnection 
 *  pointer must not be used again after KCIConnectionDestory has been called.
 */
extern void KCIConnectionDestory(KCIConnection *conn);

/*
 * NAME: KCIConnectionRestart
 *        
 *
 * 
 * DESCRIPTION:           
 * Reset the communication channel to the server, in a nonblocking manner.
 *
 * 
 * PARAMETERS: 
 * KCIConnectionRestart:KCIConnection *conn
 *  
 *
 * RETURNS: 
 *  KCIConnectionRestart: int
 *  
 * To initiate a connection reset, call KCIConnectionRestart. 
 * If it returns 0,the reset has failed.
 * If it returns 1, poll the reset using KCIConnectionRepoll
 * in exactly the same way as you would create the connection using KCIConnectionPoll   
 *     
 */
extern int	KCIConnectionRestart(KCIConnection *conn);

/*
 * NAME: KCIConnectionRepoll
 *
 * 
 * DESCRIPTION:           
 * Equal to KCIConnectionPoll
 *
 * 
 * PARAMETERS: 
 * the KCIConnection * conn which a not NULL value return from KCIConnectionStart;   
 * 
 * 
 * RETURNS: 
 * Returns a KCIPollingStatus* 
 * if last return is
 *  POLLING_READING: wait until the socket is ready to read ,
 *                   then call KCIConnectionPoll again; 
 *  POLLING_WRITING: wait until the socket is ready to write,
 *                   then call KCIConnectionPoll again;   
 * 	POLLING_FAILED = 0 : connect failed;
 *	POLLING_OK     : connect succeed.	 
 * 
 */
extern KCIPollingStatus KCIConnectionRepoll(KCIConnection *conn);

/*
 * NAME: KCIConnectionReconnect
 *
 * 
 * DESCRIPTION:           
 * Resets the communication channel to the server,This function will close the 
 * connection to the server and attempt to reestablish a new connection to the 
 * same server, using all the same parameters previously used.
 *
 * 
 * PARAMETERS: 
 * KCIConnection* conn : The connection object to send the command through
 *
 *  
 * RETURNS: 
 * void
 *     
 */
extern void KCIConnectionReconnect(KCIConnection *conn);

#ifdef WIN32

/*
 * NAME: KCIConnectionCreateDeprecated2
 *
 * 
 * DESCRIPTION:           
 * Makes a new connection to the database server in Win32 .
 *
 * 
 * PARAMETERS: 
 *  const char *host : host 
 *  const char *port : port
 *  const char *options : options
 *  const char *tty : Ignored (formerly, this specified where to send server debug output)
 *  const char *dbName : database name
 *  const char *login : login name
 *  const char *pwd : password
 *  const KCIShmOption *shm_option :  
 *         typedef struct KCIShmOption
 *          {
 *           	char	useSharedMemory;
 *           	char	*dataDir;
 *           	char	*binDir;
 *           	char	autoStartup;
 *           	char	autoShutdown;
 *          } KCIShmOption;           	 	 	 	 	  
 *
 *  
 * RETURNS: 
 * Returns a KCIConnection* which is needed for all subsequent libkci calls, or NULL
 * if a memory allocation failed.
 * If the status field of the connection returned is CONNECTION_BAD,
 * then some fields may be null'ed out instead of having valid values.
 * 
 */
extern KCIConnection *KCIConnectionCreateDeprecated2(const char *host, const char *port,
			 const char *options, const char *tty,
			 const char *dbName,
			 const char *login, const char *pwd, const KCIShmOption *shm_option,
			 const char *comm_compress_encrypt);

#endif /* WIN32 */
/*------------------ 1. Database Connection Control Functions  end------------*/

/*-------------------------  2. Connection Status Functions  ----------------*/
/*
 * NAME: KCIConnectionGetDatabase
 *  
 * 
 * DESCRIPTION:           
 * Returns the database name of the connection.
 *
 *
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  char * :the database name of the connection.   
 *     
 */
extern char *KCIConnectionGetDatabase(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetUser
 *  
 * 
 * DESCRIPTION:           
 * Returns the user name of the connection. 
 *
 *
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  char * : the user name of the connection.   
 *     
 */
extern char *KCIConnectionGetUser(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetZipLevel
 *  
 * 
 * DESCRIPTION:           
 * Returns the zip level of the connection. 
 *
 *
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  int : the zip level of the connection.   
 *     
 */
extern int KCIConnectionGetZipLevel(const KCIConnection *conn);


/*
 * NAME: KCIConnectionGetZipEncrypt
 *  
 * 
 * DESCRIPTION:           
 * Returns the zip encrypt of the connection. 
 *
 *
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  bool: the zip encrypt of the connection.   
 *     
 */
extern bool KCIConnectionGetZipEncrypt(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetPassword
 *  
 * 
 * DESCRIPTION:           
 * Returns the password of the connection. 
 *
 * 
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  char *:the password of the connection   
 *     
 */
extern char *KCIConnectionGetPassword(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetHost
 *  
 * 
 * DESCRIPTION:           
 * Returns the server host name of the connection. 
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  char *:the server host name of the connection   
 *     
 */
extern char *KCIConnectionGetHost(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetPort
 *  
 * 
 * DESCRIPTION:           
 * Returns the port of the connection. 
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  char *:the port of the connection   
 *     
 */
extern char *KCIConnectionGetPort(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetConfigdir
 *  
 * 
 * DESCRIPTION:           
 * Returns the config directory of database. 
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  char *: the directory path of the database   
 *     
 */
extern char *KCIConnectionGetConfigdir(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetServicename
 *  
 * 
 * DESCRIPTION:           
 * Returns the Servicename. 
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  char *: the Servicename of session   
 *     
 */
extern char *KCIConnectionGetServicename(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetStatus
 *  
 * 
 * DESCRIPTION:           
 * Returns the status of the connection. 
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  KCIConnectionStatus : 
 *    CONNECTION_OK  : connect succeed;
 *    CONNECTION_BAD : connect failed.  
 * See the entry for KCIConnectionStart and KCIConnectionPoll with regards to other 
 * status codes that might be seen.     
 *  
 */
extern KCIConnectionStatus KCIConnectionGetStatus(const KCIConnection *conn);


/*
 * NAME: KCIConnectionGetStatusSync
 *  
 * 
 * DESCRIPTION:           
 * Returns the status of the connection SYNCHRONOUSLY. 
 * KCIConnectionStatus returns the status of LAST CALL on the specified connections, 
 * but KCIConnectionGetStatusSync will check the connections imediately.
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 *	int timeoutMillisecond: time out in millisecond. 
 *          Nagative value(-1) means no time out.
 *          Values little than 100ms not allowed. 
 *  
 * RETURNS: 
 *  KCIConnectionStatus : 
 *    CONNECTION_OK  : connect succeed;
 *    CONNECTION_BAD : connect failed. 
 *    CONNECTION_UNKNOWN : failed to test connection before timeout.  
 * See the entry for KCIConnectionStart and KCIConnectionPoll with regards to other 
 * status codes that might be seen.     
 *  
 */
extern KCIConnectionStatus KCIConnectionGetStatusSync(KCIConnection *conn, int timeoutMillisecond);

/*
 * NAME: KCIConnectionGetTransactionStatus
 *  
 * 
 * DESCRIPTION:           
 * Returns the current in-transaction status of the server. 
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  KCITransactionStatus : 
 * 	    TRANSACTION_IDLE     : currently idle
 *		TRANSACTION_ACTIVE   : a command is in progress 
 *		TRANSACTION_INTRANS  : idle, in a valid transaction block  
 *		TRANSACTION_INERROR : idle, in a failed transaction block 
 *		TRANSACTION_UNKNOWN : cannot determine status    
 * 
 * TRANSACTION_ACTIVE is reported only when a query has been sent to the server and 
 * not yet completed   
 *  
 */
extern KCITransactionStatus KCIConnectionGetTransactionStatus(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetParameterValue
 *  
 * 
 * DESCRIPTION:           
 * Looks up a current parameter setting of the server. 
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 *  const char *paramName :  the paraName that you want to look up.  
 * 
 *  
 * RETURNS: 
 *  const char* : the detailed information of the paramName  
 *  
 */
extern const char *KCIConnectionGetParameterValue(const KCIConnection *conn,
				  const char *paramName);

/*
 * NAME: KCIConnectionGetServerVersion
 *  
 *
 * DESCRIPTION:           
 * Returns an integer representing the backend version. 
 *
 *  
 * PARAMETERS: 
 *  const KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  int : if execute succeed the number is formed by converting the major, minor,
 *        and revision numbers into two-decimal-digit numbers and appending them 
 *        together, eg 4.1.2 return 40102; Zero is returned if the connection is bad. 
 *          
 */
extern int  KCIConnectionGetServerVersion(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetLastError
 *  
 *
 * DESCRIPTION:           
 * Returns the error message most recently generated by an operation on the connection. 
 *
 *  
 * PARAMETERS: 
 *  const KCIConnection *conn : The connection object to send the command throughs
 * 
 *  
 * RETURNS: 
 *  char * : the error message. 
 *          
 */
extern char *  KCIConnectionGetLastError(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetSocket
 *  
 *
 * DESCRIPTION:           
 * Obtains the file descriptor number of the connection socket to the server. 
 *
 *  
 * PARAMETERS: 
 *  const KCIConnection *conn : The connection object to send the command through 
 * 
 *  
 * RETURNS: 
 *  int : >=0   A valid descriptor;
 *        -1  no server connection is currently open.  
 *          
 */
extern int	KCIConnectionGetSocket(const KCIConnection *conn);



/*
 * NAME: KCIConnectionGetCommandLineOptions
 *  
 * 
 * DESCRIPTION:           
 * Returns the command-line options passed in the connection request. 
 *
 *  
 * PARAMETERS: 
 *  const KCIConnection *conn : The connection object to send the command through 
 * 
 *  
 * RETURNS: 
 *  char * : saves the command-line options.
 *  
 *          
 */
extern char *KCIConnectionGetCommandLineOptions(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetProtocolVersion
 *  
 * 
 * DESCRIPTION:           
 * Returns the frontend/backend protocol being used. 
 *
 *  
 * PARAMETERS: 
 *  const KCIConnection *conn : The connection object to send the command through 
 * 
 *  
 * RETURNS: 
 *  int :the version now used
 *  Applications might wish to use this to determine whether certain features are supported.
 *          
 */
extern int	KCIConnectionGetProtocolVersion(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetBackendPid
 *  
 * 
 * DESCRIPTION:           
 *  Returns the process ID (PID) of the backend server process handling this connection.
 *
 *  
 * PARAMETERS: 
 *  const KCIConnection *conn : The connection object to send the command through 
 * 
 *  
 * RETURNS: 
 *  int :the number of PID
 * 
 * The backend PID is useful for debugging purposes and for comparison to NOTIFY
 * messages (which include the PID of the notifying backend process). Note that 
 * the PID belongs to a process executing on the database server host, not the 
 * local host!  
 *          
 */
extern int	KCIConnectionGetBackendPid(const KCIConnection *conn);

/*------------------ 2. Connection Status Functions  end -------------------*/

/*------------------ 3. Command Execution Functions ----------------------*/

/*------------------ 3.1. Main Functions ---------------------------------*/

/*
 * NAME: KCIStatementExecute
 *  
 *
 * DESCRIPTION:           
 * Submits a command to the server and waits for the result. 
 *
 *  
 * PARAMETERS: 
 *  const KCIConnection *conn : The connection object to send the command through
 *  const char *query:  the SQL command     
 * 
 *  
 * RETURNS: 
 *  KCIResult *: NULL, exectue failed; 
 *              not NULL, the result needed.                
 *          
 */
extern KCIResult *KCIStatementExecute(KCIConnection *conn, const char *query);

extern KCIResult *KCIStatementExecuteTables(KCIConnection 	*conn,
														const char	*CatalogName,
														short 			Catalog_len,
														const char	*SchemaName,
														short 			Schema_len,
														const char	*TableName,
														short			Table_len,
														const char	*TableType,
														short			Type_len );
extern KCIResult *KCIStatementExecutePrimaryKeys(KCIConnection	*conn, 
																const char	*CatalogName,
																short		Catalog_len,
																const char	*SchemaName,
																short		Schema_len,
																const char	*TableName,
																short		Table_len );
extern KCIResult *KCIStatementExecuteForeignKeys(KCIConnection *conn, 
																const char	*PKCatalogName,
																short		PKCatalog_len,
																const char	*PKSchemaName,
																short		PKSchema_len,
																const char	*PKTableName,
																short		PKTable_len,
																const char	*FKCatalogName,
																short		FKCatalog_len,
																const char	*FKSchemaName,
																short		FKSchema_len,
																const char	*FKTableName,
																short		FKTable_len );
extern KCIResult *KCIStatementExecuteColumns(KCIConnection *conn,
														const char	*CatalogName,
														short		Catalog_len,
														const char	*SchemaName,
														short		Schema_len,
														const char	*TableName,
														short		Table_len,
														const char	*ColumnName,
														short		Column_len );

/*
 * NAME: KCIStatementExecuteWithParams
 *  
 *
 * DESCRIPTION:           
 * Submits a command to the server and waits for the result, with the ability to
 * pass parameters separately from the SQL command text. 
 * 
 *  
 * PARAMETERS: 
 *  KCIConnection *conn   :  The connection object to send the command through
 *  const char   *command :  The SQL command string to be executed. If parameters
 *                           are used, they are referred to in the command string 
 *                           as $1, $2, etc
 *  int paramNumPerGroup : number of params per group; it is the length of the arrays
 *              paramTypes[], paramValues[], paramLengths[], and paramFormats[].
 *              (The array pointers can be NULL when nParams is zero.)
 *  int numGroups : number of group 
 *  const Oid *paramTypes : Specifies, by OID, the data types to be assigned to 
 *                       the parameter symbols. If paramTypes is NULL, or any 
 *                       particular element in the array is zero, the server
 *                       infers a data type for the parameter symbol in the 
 *                       same way it would do for an untyped literal string.
 *  const char * const *paramValues : Specifies the actual values of the parameters.
 *                               A null pointer in this array means the 
 *                               corresponding parameter is null; otherwise
 *                               the pointer points to a zero-terminated text
 *                               string (for text format) or binary data in 
 *                               the format expected by the server (for binary format). 
 *  const int *paramLengths : Specifies the actual data lengths of binary-format parameters. 
 *  const int *paramFormats : Specifies whether parameters are textor binary 
 *  int resultFormat :  Specify zero to obtain results in text format, or one to obtain results 
 *                  in binary format  
 * 
 *  
 * RETURNS: 
 *  KCIResult *: NULL, exectue failed; 
 *            not NULL, execute succeed.                
 *          
 */
extern KCIResult *KCIStatementExecuteWithParams(KCIConnection *conn,
			 const char *command,
			 int paramNumPerGroup,
			 int numGroups,
			 const Oid *paramTypes,
			 const char *const * paramValues,
			 const int *paramLengths,
			 const int *paramFormats,
			 int resultFormat);

/*
 * NAME: KCIStatementPrepare
 *  
 *
 * DESCRIPTION:           
 * Submits a request to create a prepared statement with the given parameters, 
 * and waits for completion. KCIStatementPrepare creates a prepared statement for later 
 * execution with KCIStatementExecutePrepared.
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn   :  The connection object to send the command through
 *  const char   *stmtName :  The prepared statment name;
 *  const char   *query :  a string which include SQL command used to create prepared
 *                         statement.   
 *  int nParams : number of params
 *  const Oid *paramTypes: Specifies, by OID, 
 * 
 *  
 * RETURNS: 
 *  KCIResult *: NULL, exectue failed; 
 *              not NULL, execute succeed, maybe lack of memory or can't send the
 *              command.                 
 *          
 */
extern KCIResult *KCIStatementPrepare(KCIConnection *conn, const char *stmtName,
		  const char *query, int nParams,
		  const Oid *paramTypes);

/*
 * NAME: KCIStatementSendClosePrepared
 *  
 *
 * DESCRIPTION:           
 *		Submits a request to close a prepared statement WITHOUT waiting for the result(s).
 *
 * PARAMETERS: 
 *  KCIConnection *conn   :  The connection object to send the command through
 *  const char   *stmtName :  The prepared statment name;
 *  
 * RETURNS: 
 *  int :	0, exectue failed; 
 *		1, execute succeed.            
 *          
 */
extern int KCIStatementSendClosePrepared(KCIConnection *conn, const char *stmtName);

/*
 * NAME: KCIStatementClosePrepare
 *  
 *
 * DESCRIPTION:           
 * Submits a request to close a prepared statement
 *
 * PARAMETERS: 
 *  KCIConnection *conn   :  The connection object to send the command through
 *  const char   *stmtName :  The prepared statment name;
 *  
 * RETURNS: 
 *  int :	0, exectue failed; 
 *		1, execute succeed.            
 *          
 */
extern int KCIStatementClosePrepared(KCIConnection *conn, const char *stmtName);
/*
 * NAME: KCIStatementExecutePrepared
 *  
 *
 * DESCRIPTION:           
 * Sends a request to execute a prepared statement with given parameters, and 
 * waits for the result.
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn   :  The connection object to send the command through
 *  const char   *stmtName : The name of the prepared statment which was created
 *                           in KCIStatementPrepare;
 *  int paramNumPerGroup : number of params per group
 *  int numGroups : number of group 
 *  const char *const * paramValues : Specifies the actual values of the parameters.
 *                               A null pointer in this array means the 
 *                               corresponding parameter is null; otherwise
 *                               the pointer points to a zero-terminated text
 *                               string (for text format) or binary data in 
 *                               the format expected by the server (for binary format). 
 *  const int *paramLengths : Specifies the actual data lengths of binary-format parameters.
 *	const int *paramFormats : Specifies whether parameters are textor binary 
 *	int resultFormat : Specify zero to obtain results in text format, or one to obtain results 
 *                     in binary format
 *  
 * RETURNS: 
 *  KCIResult *: NULL, exectue failed; 
 *              not NULL, execute succeed, maybe lack of memory or can't send the
 *              command.                 
 *          
 */
extern KCIResult *KCIStatementExecutePrepared(KCIConnection *conn,
			   const char *stmtName,
			   int paramNumPerGroup,
			   int numGroups,
			   const char *const * paramValues,
			   const int *paramLengths,
			   const int *paramFormats,
			   int resultFormat);

/*
 * NAME: KCIResultGetStatusCode
 *  
 * 
 * DESCRIPTION:           
 * Returns the result status of the command.  
 *   
 *    
 * PARAMETERS:
 *  const KCIResult *res £º specified the query result 
 *                            
 *  
 * RETURNS: 
 *  KCIExecuteStatus : 
 	EXECUTE_EMPTY_QUERY = 0 : 		empty query string was executed 
	EXECUTE_COMMAND_OK :    	    a query command that doesn't return
								    anything was executed properly by the
								    backend 
	EXECUTE_TUPLES_OK : 		     a query command that returns tuples was
								     executed properly by the backend, KCIResult
								     contains the result tuples 
	EXECUTE_COPY_OUT :				 Copy Out data transfer in progress 
	EXECUTE_COPY_IN :				 Copy In data transfer in progress 
	EXECUTE_BAD_RESPONSE :			 an unexpected response was recv'd from the
								     backend 
	EXECUTE_NONFATAL_ERROR :	     notice or warning message 
	EXECUTE_FATAL_ERROR :		     query failed 
 *          
 */
extern KCIExecuteStatus KCIResultGetStatusCode(const KCIResult *res);

/*
 * NAME: KCIResultGetStatusCode
 *  
 * 
 * DESCRIPTION:           
 * Converts the enumerated type returned by KCIResultGetStatusCode into a string constant 
 * describing the status code. The caller should not free the result.   
 *   
 *    
 * PARAMETERS:
 *  KCIExecuteStatus status : the status of the connection
 *                            
 *  
 * RETURNS: 
 *  char * : saves the string constant which is used to describe the status code
 *                     
 *          
 */
extern char *KCIResultGetStatusString(KCIExecuteStatus status);

/*
 * NAME: KCIResultGetErrorString
 *  
 * 
 * DESCRIPTION:           
 * Returns the error message associated with the command, or an empty string if 
 * there was no error.
 *   
 *    
 * PARAMETERS:
 *  KCIExecuteStatus status  ;
 *                            
 *  
 * RETURNS: 
 *  char * : the error messages, empty if there is no error.
 *                     
 *  use KCIConnectionGetLastError when you want to know the status from the latest
 *  operation on the connection.
 *  
 *  
 */
extern char *KCIResultGetErrorString(const KCIResult *res);

/*
 * NAME: KCIResultGetErrorField
 *  
 * 
 * DESCRIPTION:           
 * Returns an individual field of an error report.
 *   
 *    
 * PARAMETERS:
 *  KCIExecuteStatus status  ;
 *  int fieldcode  : fieldcode is an error field identifier; NULL is returned if the KCIResult is not an error or warning result, 
 *                   or does not include the specified field. 
 *   the values of fieldcode
 *   KCI_SEVERITY : The severity; the field contents are ERROR, FATAL, or PANIC ,
 *                      or WARNING, NOTICE, DEBUG, INFO, or LOG (in a notice message),
 *                      or a localized translation of one of these. Always present. 
 *
 *   KCI_SQLSTATE : The SQLSTATE code for the error. The SQLSTATE code identifies 
 *	                    the type of error that has occurred; it can be used by front-end 
 *						applications to perform specific operations (such as error 
 *						handling) in response to a particular database error. 
 *						This field is not localizable, and is always present. 
 *
 *   KCI_MESSAGE_PRIMARY : The primary human-readable error message (typically 
 *	                           one line). Always present.
 *	                          
 *   KCI_MESSAGE_DETAIL : Detail: an optional secondary error message carrying
 *	                          more detail about the problem. Might run to multiple lines. 
 *
 *   KCI_MESSAGE_HINT : Hint: an optional suggestion what to do about the problem. 
 *	                        This is intended to differ from detail in that it offers 
 *							advice (potentially inappropriate) rather than hard facts. 
 *							Might run to multiple lines. 
 *
 *   KCI_STATEMENT_POSITION :  A string containing a decimal integer indicating 
 *	                               an error cursor position as an index into the original 
 *								   statement string. The first character has index 1, 
 *								   and positions are measured in characters not bytes. 
 *
 *   KCI_INTERNAL_POSITION :  This is defined the same as the KCI_STATEMENT_POSITION 
 *	                              field, but it is used when the cursor position refers to
 *								  an internally generated command rather than the one
 *								  submitted by the client. The KCI_INTERNAL_QUERY field
 *								  will always appear when this field appears. 
 *
 *   KCI_INTERNAL_QUERY : The text of a failed internally-generated command. 
 *                             This could be, for example, 
 *
 *   KCI_CONTEXT : An indication of the context in which the error occurred. 
 *                     Presently this includes a call stack traceback of active procedural
 *				       language functions and internally-generated queries. The trace is one 
 *				       entry per line, most recent first. 
 *
 *   KCI_SOURCE_FILE : The file name of the source-code location where the error was reported. 
 *
 *   KCI_SOURCE_LINE : The line number of the source-code location where the error was reported. 
 *
 *   KCI_SOURCE_FUNCTION : The name of the source-code function reporting the error
 *                            
 *  
 * RETURNS: 
 *  char * : the error messages, empty if there is no error.
 *
 *  
 *  Note that error fields are only available from KCIResult objects, not KCIConnection
 *  objects
 */
extern char *KCIResultGetErrorField(const KCIResult *res, int fieldcode);

/*
 * NAME: KCIStatementDescribePrepared
 *  
 * 
 * DESCRIPTION:           
 * Submits a request to obtain information about the specified prepared statement,
 * and waits for completion. 
 *  
 *    
 * PARAMETERS:
 *  KCIConnection *conn : The connection object to send the command through
 *  const char   *stmt : The name of the prepared statment which was created
 *                           before,if the stmt is "" or NULL ,it refered to unname 
 *                           statement. 
 *  
 * RETURNS: 
 *  KCIResult * : NULL, exectue failed; 
 *            not NULL, execute succeed, maybe lack of memory or can't send the
 *            command.                 
 *          
 */
extern KCIResult *KCIStatementDescribePrepared(KCIConnection *conn, const char *stmt);

/*
 * NAME: KCICursorDescribe
 *  
 * 
 * DESCRIPTION:           
 * Submits a request to obtain information about the specified portal, and waits for completion. 
 *   
 *    
 * PARAMETERS:
 *  KCIConnection *conn   : The connection object to send the command through
 *  const char   *portal  : The name of the prepared portal which was created
 *                           before,if the stmt is "" or NULL ,it refered to unname 
 *                           portal. 
 *                            
 *  
 * RETURNS: 
 *  KCIResult * : NULL, exectue failed; 
 *              not NULL, execute succeed, maybe lack of memory or can't send the
 *              command.                 
 *          
 */
extern KCIResult *KCICursorDescribe(KCIConnection *conn, const char *portal);

/*
 * NAME: KCIResultDealloc
 *  
 * 
 * DESCRIPTION:           
 * Frees the storage associated with a KCIResult. Every command result should be 
 * freed via KCIResultDealloc when it is no longer needed
 *   
 *    
 * PARAMETERS:
 * KCIResult *res;
 *                            
 *  
 * RETURNS: 
 *  void 
 *  
 *  To get rid of the KCIResult, you must call KCIResultDealloc. Failure to do 
 *  this will result in memory leaks in your application
 */
extern void KCIResultDealloc(KCIResult *res);

/*------------------ 3.1. Main Functions   end---------------------------------*/

/*------------------ 3.2. Retrieving Query Result Information---------------------*/

/*
 * NAME: KCIResultGetRowCount
 *  
 * 
 * DESCRIPTION:           
 * Returns the number of rows (tuples) in the query result. Because it returns 
 * an integer result, large result sets might overflow the return value on 32-bit 
 * perating systems.
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query
 *                            
 *  
 * RETURNS: 
 *  int :  the number of rows (tuples) in the query result.
 *  
 */
extern int	KCIResultGetRowCount(const KCIResult *res);

/*
 * NAME: KCIResultGetColumnCount
 *  
 *
 * DESCRIPTION:           
 * Returns the number of columns (fields) in each row of the query result.
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query
 *                            
 *  
 * RETURNS: 
 *  int :  the number of columns(fields) in each row of the query result.
 *  
 */
extern int	KCIResultGetColumnCount(const KCIResult *res);

/*
 * NAME: KCIResultIsBinary
 *  
 * 
 * DESCRIPTION:           
 * Returns the format of data which KCIResult contains   
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query ;
 *  
 * 
 * RETURNS: 
 *  int : 0 text 
 *        1 binary
 *     
 *  This function is deprecated (except for its use in connection with COPY),
 *  because it is possible for a single KCIResult to contain text data in some 
 *  columns and binary data in others  
 */
extern int	KCIResultIsBinary(const KCIResult *res);

/*
 * NAME: KCIResultGetColumnName
 *  
 * 
 * DESCRIPTION:           
 * Returns the column name associated with the given column number. 
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query ;
 * int field_num  : the column number start at 0.                           
 *  
 * 
 * RETURNS: 
 *  char * :  the column name associated with the given column number.
 *            NULL is returned if the column number is out of range 
 *  
 * It will be freed when the associated KCIResult handle is passed to KCIResultDealloc.  
 */
extern char *KCIResultGetColumnName(const KCIResult *res, int field_num);

/*
 * NAME: KCIResultGetColumnNo
 *  
 * 
 * DESCRIPTION:           
 * Returns the column number associated with the given column name. 
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query ;
 * const char *field_name  : the column name in table.                           
 *  
 * 
 * RETURNS: 
 *  int :  the number of columns(fields) in each row of the query result.
 *         -1 if the given name does not match any column. 
 *   
 */
extern int	KCIResultGetColumnNo(const KCIResult *res, const char *field_name);

/*
 * NAME: KCIResultGetRelationOidOfColumn
 *  
 * 
 * DESCRIPTION:           
 * Returns the OID of the table from which the given column was fetched. 
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query ;
 * int field_num  : the column number start at 0.                            
 *  
 * 
 * RETURNS: 
 *  Oid : the internal OID number of the type,query the system table sys_class to get the object of Oid. 
 *   
 */
extern Oid	KCIResultGetRelationOidOfColumn(const KCIResult *res, int field_num);

/*
 * NAME: KCIResultGetColumnNoInRelation
 *  
 * 
 * DESCRIPTION:           
 * Returns the column number (within its table) of the column making up the specified
 * query result column.
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query ;
 * int field_num  : the column number start at 0.                            
 *  
 * 
 * RETURNS: 
 *  int :  the column number of result. 
 *   
 */
extern int	KCIResultGetColumnNoInRelation(const KCIResult *res, int field_num);

/*
 * NAME: KCIResultGetColumnFormat
 *  
 * 
 * DESCRIPTION:           
 * Returns the format code indicating the format of the given column.
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query ;
 * int field_num  : the column number start at 0.                            
 *  
 * 
 * RETURNS: 
 *  int :  0  text 
 *         1  binary 
 *   
 */
extern int	KCIResultGetColumnFormat(const KCIResult *res, int field_num);

/*
 * NAME: KCIResultGetColumnType
 *  
 * 
 * DESCRIPTION:           
 * Returns the data type associated with the given column number.  
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query ;
 * int field_num  : the column number start at 0.                            
 *  
 * 
 * RETURNS: 
 *  Oid :  the internal OID number of the type
 *          
 *   
 */
extern Oid	KCIResultGetColumnType(const KCIResult *res, int field_num);
            
/*
 * NAME: KCIResultGetColumnLength
 *  
 * 
 * DESCRIPTION:           
 * Returns the size in bytes of the column associated with the given column number.   
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query ;
 * int field_num  : the column number start at 0.                            
 *  
 * 
 * RETURNS: 
 *  int : the space allocated for this column in a database row
 *        A negative value indicates the data type is variable-length. 
 *     
 */
extern int	KCIResultGetColumnLength(const KCIResult *res, int field_num);

/*
 * NAME: KCIResultGetColumnTypmod
 *  
 * 
 * DESCRIPTION:           
 * Returns the type modifier of the column associated with the given column number.   
 *   
 *    
 * PARAMETERS:
 * KCIResult *res : the result of query ;
 * int field_num  : the column number start at 0.                            
 *  
 * 
 * RETURNS: 
 *  int : Most data types do not use modifiers, in which case the value is always -1
 *     
 * The interpretation of modifier values is type-specific; they typically indicate 
 * precision or size limits. The value -1 is used to indicate ¡°no information available¡±. 
 * Most data types do not use modifiers, in which case the value is always -1. 
 *      
 */
extern int	KCIResultGetColumnTypmod(const KCIResult *res, int field_num);

/*
 * NAME: KCIResultGetColumnValue
 *  
 * 
 * DESCRIPTION:           
 * Returns a single field value of one row of a KCIResult.   
 *   
 *    
 * PARAMETERS:
 *  KCIResult *res : the result of query ;
 *  int tup_num  : row number start at 0;
 *  int field_num  : column number start at 0;
 * 
 * RETURNS: 
 *  char * : For data in text format, the value returned by KCIResultGetColumnValue is
 *            a null-terminated character string representation of the field value,
 *         For data in binary format, the value is in the binary representation 
 *            determined by the data type's typsend and typreceive functions. 
 *     
 */
extern char *KCIResultGetColumnValue(const KCIResult *res, int tup_num, int field_num);

/*
 * NAME: KCIResultGetColumnValueLength
 *  
 * 
 * DESCRIPTION:           
 * Returns the actual length of a field value in bytes.    
 *   
 *    
 * PARAMETERS:
 *  KCIResult *res : the result of query ;
 *  int tup_num    : row number start at 0;
 *  int field_num  : column number start at 0;
 * 
 * RETURNS: 
 *  int :  actual data length for the particular data value           
 *         For text data format this is the same as strlen(), 
 *         For binary format this is essential information.        
 */

extern int	KCIResultGetColumnValueLength(const KCIResult *res, int tup_num, int field_num);

/*
 * NAME: KCIResultColumnIsNull
 *  
 * 
 * DESCRIPTION:           
 * Tests a field for a null value.   
 *   
 *    
 * PARAMETERS:
 *  KCIResult *res : the result of query ;
 *  int tup_num    : row number start at 0;
 *  int field_num  : column number start at 0;
 * 
 * RETURNS: 
 *  int :  0 not-null
 *         1 null  
 *     
 */
extern int	KCIResultColumnIsNull(const KCIResult *res, int tup_num, int field_num);

/*
 * NAME: KCIResultGetParamCount
 *  
 * 
 * DESCRIPTION:           
 * Returns the number of parameters of a prepared statement.    
 *   
 *    
 * PARAMETERS:
 *  KCIResult *res : the result of query ;
 *   
 * 
 * RETURNS: 
 *  int : the number of parameters of a prepared statement.        
 *  
 * This function is only useful when inspecting the result of KCIStatementDescribePrepared. 
 * For other types of queries it will return zero.
 *      
 */
extern int	KCIResultGetParamCount(const KCIResult *res);

/*
 * NAME: KCIResultGetParamType
 *  
 * 
 * DESCRIPTION:           
 * Returns the data type of the indicated statement parameter.    
 *   
 *    
 * PARAMETERS:
 *  KCIResult *res : the result of query ;
 *  int param_num  : Parameter numbers start at 0. 
 * 
 * RETURNS: 
 *  Oid : the internal OID number of the type.      
 *  
 * This function is only useful when inspecting the result of KCIStatementDescribePrepared. 
 * For other types of queries it will return zero.
 *      
 */
extern Oid	KCIResultGetParamType(const KCIResult *res, int param_num);

/*
 * NAME: KCIResultPrint
 *  
 * 
 * DESCRIPTION:           
 * Prints out all the rows and, optionally, the column names to the specified output stream.     
 *   
 *    
 * PARAMETERS:
 *   FILE *fout     :   output stream
 *   KCIResult *res : the result of query ;
 *   KCIPrintOption *ps  :  printOptions.
 * 
 * RETURNS: 
 *  void      
 *  
 * This function was formerly used by isql to print query results, but this is 
 * no longer the case. Note that it assumes all the data is in text format. 
 *      
 */
extern void
KCIResultPrint(FILE *fout,				/* output stream */
		const KCIResult *res,
		const KCIPrintOption *ps);	/* option structure */
/*------------------ 3.2. Retrieving Query Result Information end-----------------*/

/*------------------ 3.3. Retrieving Result Information for Other Commands --------*/

/*
 * NAME: KCIResultGetCommandStatus
 *  
 * 
 * DESCRIPTION:           
 * Returns the command status tag from the SQL command that generated the KCIResult.      
 *   
 *    
 * PARAMETERS:
 *   KCIResult *res : the result of query ;
 * 
 *
 * RETURNS: 
 *  char *: the name of command, include additional data such as the number of rows processed.       
 *  
 * The caller should not free the result directly. It will be freed when the associated 
 *  KCIResult handle is passed to KCIResultDealloc.   
 *      
 */
extern char *KCIResultGetCommandStatus(KCIResult *res);

/*
 * NAME: KCIResultGetAffectedCount
 *  
 * 
 * DESCRIPTION:           
 * Returns the number of rows affected by the SQL command.
 *   
 *    
 * PARAMETERS:
 *   KCIResult *res : the result of query ;
 * 
 *
 * RETURNS: 
 *  char * : a string containing the number of rows affected by the SQL statement
 *          that generated the KCIResult.       
 *  
 * This function can only be used following the execution of an INSERT, UPDATE,
 * DELETE, MOVE, FETCH, or COPY statement, or an EXECUTE of a prepared query 
 * that contains an INSERT, UPDATE, or DELETE statement. If the command that 
 * generated the KCIResult was anything else, KCIResultGetAffectedCount returns 
 * an empty string.
 * The caller should not free the return value directly. It will be freed when 
 * the associated KCIResult handle is passed to KCIResultDealloc.
 *      
 */
extern char *KCIResultGetAffectedCount(KCIResult *res);

/*
 * NAME: KCIResultInsertRowOid
 *  
 * 	
 * DESCRIPTION:           
 * Returns a string with the OID of the inserted row.
 *   
 *    
 * PARAMETERS:
 *   KCIResult *res : the result of query ;
 * 
 * 
 * RETURNS: 
 *   Oid : the internal OID number of the type.
 *     
 *  if the SQL command was an INSERT that inserted exactly one row into a table 
 *  that has OIDs, or a EXECUTE of a prepared query containing a suitable INSERT
 *  statement.
 *  Otherwise, this function returns InvalidOid. This function will also return 
 *  InvalidOid if the table affected by the INSERT statement does not contain OIDs.    
 */
extern Oid	KCIResultInsertRowOid(const KCIResult *res);	/* new and improved */

/*
 * NAME: KKCIResultInsertRowOidStr
 *
 *  
 * DESCRIPTION:           
 *  Returns a string with the OID of the inserted row.
 *
 *  
 * PARAMETERS: 
 *  const KCIResult *res : the result set of the operation on connection.
 * 
 *  
 * RETURNS: 
 *  char *: saves the OID of the inserted row.
 *   
 * if the SQL command was an INSERT that inserted exactly one row, or a EXECUTE 
 * of a prepared statement consisting of a suitable INSERT. (The string will be 
 * 0 if the INSERT did not insert exactly one row, or if the target table does 
 * not have OIDs.) If the command was not an INSERT, returns an empty string.  
 *          
 */
extern char *KCIResultInsertRowOidStr(const KCIResult *res); 

/*------------------ 3.3. Retrieving Result Information for Other Commands end ----*/

/*------------------ 3.4. Escaping Strings for Inclusion in SQL Commands ----------*/

/*
 * NAME: KCIEscapeStringEx
 *  
 *	
 * DESCRIPTION:           
 * This function escapes a string for use within an SQL command,writes an escaped
 * version of the from string to the to buffer.
 *   
 *    
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   char *to            : saves the escaped version of from string             
 *   const char *from    : the original version of SQL command. 
 *   size_t length       : gives the number of bytes in from string.
 *   int *error          : saves the error message if not NULL.
 *   
 *  
 * RETURNS: 
 *   size_t : the number of bytes written to to, not including the terminating zero byte. 
 * Behavior is likewise undefined if the to and from strings overlap. 
 *     
 */
extern size_t KCIEscapeStringEx(KCIConnection *conn,
				   char *to, const char *from, size_t length,
				   int *error);


/*
 * NAME: KCIEscapeString
 *  
 * 	
 * DESCRIPTION:           
 * KCIEscapeString is an older, deprecated version of KCIEscapeStringEx; the 
 * difference is that it does not take conn or error parameters.
 *   
 *    
 * PARAMETERS:
 *   char *to            : saves the escaped version of from string             
 *   const char *from    : the original version of SQL command. 
 *   size_t length       : gives the number of bytes in from string.
 *   encoding            : client encoding id
 *   std_strings         : whether choose the standard-conforming-strings.
 *                           
 *  
 * RETURNS: 
 *   size_t : the number of bytes written to to, not including the terminating zero byte. 
 *
 * KCIEscapeString can be used safely in single-threaded client programs that work 
 * with only one KingbaseES connection at a time (in this case it can find out what 
 * it needs to know ¡°behind the scenes¡±). In other contexts it is a security hazard 
 * and should be avoided in favor of KCIEscapeStringEx.  
 *     
 */
extern size_t KCIEscapeString(char *to, const char *from, size_t length, int encoding, bool std_strings);

/*------------------ 3.4. Escaping Strings for Inclusion in SQL Commands end-------*/

/*------------------ 3.5. Escaping Binary Strings for Inclusion in SQL Commands-----*/
/*
 * NAME: KCIEscapeBytea
 *  
 *
 * DESCRIPTION:           
 * KCIEscapeBytea is an older, deprecated version of KCIEscapeByteaEx, escapes 
 * binary data for use within an SQL command with the type bytea. 
 * As with KCIEscapeString , this is only used when inserting data directly into 
 * an SQL command string.  *
 *   
 *    
 * PARAMETERS:          
 *   const unsigned char *from : points to the first byte of the string that is to be escaped  
 *   size_t from_length : gives the number of bytes in this binary string.
 *   size_t *to_length : specifies the length of escaped byte string.
 *   
 *  
 * RETURNS: 
 *   unsigned char * : an escaped version of the from parameter binary string in 
 *                     memory allocated with malloc().  
 *     
 */
extern unsigned char *KCIEscapeBytea(const unsigned char *from, size_t from_length,
			  size_t *to_length);

			  
/*
 * NAME: KCIEscapeByteaEx
 *
 *  
 * DESCRIPTION:           
 *  Escapes binary data for use within an SQL command with the type bytea. As 
 *  with KCIEscapeStringEx, this is only used when inserting data directly into 
 *  an SQL command string.
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 *	const unsigned char *from : the binary sting that will be escaped. 
 *	size_t from_length : the length of  from 
 *	size_t *to_length :  the length of the escaped string
 * 
 *  
 * RETURNS: 
 *  unsigned char * : the escaped string.
 * 
 * KCIEscapeByteaEx returns an escaped version of the from parameter binary string 
 * in memory allocated with malloc(). This memory must be freed using KCIFree() 
 * when the result is no longer needed. The return string has all special characters 
 * replaced so that they can be properly processed by the KingbaseES string literal 
 * parser, and the bytea input function. A terminating zero byte is also added. 
 * The single quotes that must surround KingbaseES string literals are not part 
 * of the result string. 

 * On error, a NULL pointer is returned, and a suitable error message is stored in 
 * the conn object. Currently, the only possible error is insufficient memory for 
 * the result string.
 *          
 */			  
extern unsigned char *KCIEscapeByteaEx(KCIConnection *conn,
				  const unsigned char *from, size_t from_length,
				  size_t *to_length);			  

/*---------------- 3.5. Escaping Binary Strings for Inclusion in SQL Commands end --*/

/*------------------ 4. Asynchronous Command Processing ----------------------*/

/* Interface for multiple-result or asynchronous queries */
/*
 * NAME: KCIStatementSend
 *  
 * 
 * DESCRIPTION: 
 * Submits a command to the server without waiting for the result(s).
 *   
 *    
 * PARAMETERS:          
 *   KCIConnection *conn : The connection object to send the command through 
 *   const char *query   : query command
 *   
 *  
 * RETURNS: 
 *   int : 1 if the command was successfully dispatched
 *       0 if the command was not successfully dispatched     
 *  
 * After successfully calling KCIStatementSend, call KCIConnectionFetchResult one
 * or more times to obtain the results. KCIStatementSend cannot be called again 
 * (on the same connection) until KCIConnectionFetchResult has returned a null 
 * pointer, indicating that the command is done.
 *  
 */
extern int	KCIStatementSend(KCIConnection *conn, const char *query);

/*
 * NAME: KCIStatementSendWithParams
 *  
 *
 * DESCRIPTION:           
 * Submits a command and separate parameters to the server without waiting for the result(s). 
 *   
 *    
 * PARAMETERS:          
 *  KCIConnection *conn    : The connection object to send the command through
 *  const char   *command  : The SQL command string to be executed. If parameters
 *                           are used, they are referred to in the command string 
 *                           as $1, $2, etc
 *  int paramNumPerGroup : number of params per group; it is the length of the arrays
 *              paramTypes[], paramValues[], paramLengths[], and paramFormats[].
 *              (The array pointers can be NULL when nParams is zero.)
 *  int numGroups : number of group  
 *  const Oid *paramTypes : Specifies, by OID, the data types to be assigned to 
 *                       the parameter symbols. If paramTypes is NULL, or any 
 *                       particular element in the array is zero, the server
 *                       infers a data type for the parameter symbol in the 
 *                       same way it would do for an untyped literal string.
 *  const char * const *paramValues : Specifies the actual values of the parameters.
 *                               A null pointer in this array means the 
 *                               corresponding parameter is null; otherwise
 *                               the pointer points to a zero-terminated text
 *                               string (for text format) or binary data in 
 *                               the format expected by the server (for binary format). 
 *  const int *paramLengths : Specifies the actual data lengths of binary-format parameters. 
 *  const int *paramFormats : Specifies whether parameters are textor binary 
 *  int resultFormat :  Specify zero to obtain results in text format, or one to obtain results 
 *                  in binary format 
 *   
 *  
 * RETURNS: 
 *   int : 1 if the command was successfully dispatched
 *       0 if the command was not successfully dispatched 
 *  
 */
extern int KCIStatementSendWithParams(KCIConnection *conn,
				  const char *command,
				  int paramNumPerGroup,
				  int numGroups,
				  const Oid *paramTypes,
				  const char *const * paramValues,
				  const int *paramLengths,
				  const int *paramFormats,
				  int resultFormat);

/*
 * NAME: KCIStatementSendPrepare
 *
 *
 * DESCRIPTION:           
 * Sends a request to create a prepared statement with the given parameters, 
 * without waiting for completion. 
 *   
 *    
 * PARAMETERS:          
 *  KCIConnection *conn    :  The connection object to send the command through
 *  const char   *stmtName :  The prepared statment name;
 *  const char   *query    : a string which include SQL command used to create prepared
 *                         statement.   
 *  int nParams : number of params
 *  const Oid *paramTypes : Specifies, by OID, 
 *   
 *  
 * RETURNS: 
 *   int :  1 if it was able to dispatch the request
 *          0 if it was unable to dispatch the request 
 *  
 * After a successful call, call KCIConnectionFetchResult to determine whether 
 * the server successfully created the prepared statement.   
 * 
 */
extern int KCIStatementSendPrepare(KCIConnection *conn, const char *stmtName,
			  const char *query, int nParams,
			  const Oid *paramTypes);

/*
 * NAME: KCIStatementSendExecutePrepared
 *
 * 
 * DESCRIPTION:           
 * Sends a request to create a prepared statement with the given parameters, 
 * without waiting for completion. 
 *   
 *    
 * PARAMETERS:          
 *  KCIConnection *conn    :  The connection object to send the command through
 *  const char   *stmtName  :  The SQL command string to be executed. If parameters
 *                           are used, they are referred to in the command string 
 *                           as $1, $2, etc
 *  int paramNumPerGroup : The number of parameters per group; it is the length of the arrays
 *              paramTypes[], paramValues[], paramLengths[], and paramFormats[].
 *              (The array pointers can be NULL when nParams is zero.) 
 *  int numGroups : number of group 
 *  const char * const *paramValues : Specifies the actual values of the parameters.
 *                               A null pointer in this array means the 
 *                               corresponding parameter is null; otherwise
 *                               the pointer points to a zero-terminated text
 *                               string (for text format) or binary data in 
 *                               the format expected by the server (for binary format). 
 *  const int *paramLengths : Specifies the actual data lengths of binary-format parameters. 
 *  const int *paramFormats : Specifies whether parameters are text or binary 
 *  int resultFormat :  Specify zero to obtain results in text format, or one to obtain results 
 *                  in binary format 
 *  
 *  
 * RETURNS: 
 *   int : 1 if the command was successfully dispatched
 *         0 if the command was not successfully dispatched 
 *  
 *  
 * This is similar to KCIStatementSendWithParams, but the command to be executed is specified 
 * by naming a previously-prepared statement, instead of giving a query string. 
 * 
 */
extern int KCIStatementSendExecutePrepared(KCIConnection *conn,
					const char *stmtName,
					int paramNumPerGroup,
					int numGroups,
					const char *const * paramValues,
					const int *paramLengths,
					const int *paramFormats,
					int resultFormat);

/*
 *
 * The same as KCIStatementSendExecutePrepared
 * if the content of string contain '\0',you should be useing this interface  
 *
 */

extern int KCIStatementExecutePreparedWithZero(KCIConnection *conn,
									const char *stmtName,
									int paramNumPerGroup,
									int numGroups,
									const char *const * paramValues,
									const int *paramLength,
									const int *paramFormats,
									const int *paramVarlena,
									int resultFormat);

/*
 * NAME: KCIStatementSendDescribePrepared
 *
 * 
 * DESCRIPTION:           
 * Submits a request to obtain information about the specified prepared statement,
 * without waiting for completion.
 *   
 *    
 * PARAMETERS:          
 *  KCIConnection *conn :  The connection object to send the command through
 *  const char *stmt  : The name of the prepared statment which was created
 *                      before,if the stmt is "" or NULL ,it refered to unname 
 *                      statement. 
 *  
 *  
 * RETURNS: 
 *  int : 1 if it was able to dispatch the request
 *      0 if it was unable to dispatch the request 
 *  
 * This is an asynchronous version of KCIStatementDescribePrepared,  After a successful
 * call, call KCIConnectionFetchResult to obtain the results. The function's parameters 
 * are handled identically to KCICursorDescribe.
 * 
 */
extern int	KCIStatementSendDescribePrepared(KCIConnection *conn, const char *stmt);

/*
 * NAME: KCIConnectionFetchResult
 *
 * 
 * DESCRIPTION:           
 * Waits for the next result from a prior KCIStatementSend, KCIStatementSendWithParams, 
 * KCIStatementSendPrepare,or KCIStatementSendExecutePrepared  call, and returns it.
 *   
 *    
 * PARAMETERS:          
 *  KCIConnection *conn :  The connection object to send the command through
 *   
 *  
 * RETURNS: 
 *   KCIResult * : NULL the command is complete and there will be no more results
 *                NOT NULL should be processed using the same KCIResult accessor functions 
 *                         previously described 
 *  
 * This function must be called repeatedly until it returns a null pointer, indicating 
 * that the command is done.
 * Don't forget to free each result object with KCIResultDealloc when done with it.
 * Note that KCIConnectionFetchResult will block only if a command is active and 
 * the necessary response data has not yet been read by KCIConnectionForceRead
 * 
 */
extern KCIResult *KCIConnectionFetchResult(KCIConnection *conn);

/*
 * NAME: KCIConnectionIsBusy
 *
 * 
 * DESCRIPTION:           
 * Return the status of  connection. 
 *   
 *    
 * PARAMETERS:          
 *  KCIConnection *conn :  The connection object to send the command through
 *   
 *  
 * RETURNS: 
 *   int : 1 if a command is busy
 *       0 indicates that KCIConnectionFetchResult can be called with assurance 
 *         of not blocking.
 * 
 */
extern int	KCIConnectionIsBusy(KCIConnection *conn);

/*
 * NAME: KCIConnectionSetNonBlocking
 *
 * 
 * DESCRIPTION:           
 * Sets the nonblocking status of the connection.
 *   
 *    
 * PARAMETERS:          
 *  KCIConnection *conn :  The connection object to send the command through
 *  int arg           :  1 sets the state of the connection to nonblocking 
 *                       0 sets the state of the connection to blocking 
 *
 *
 * RETURNS: 
 *  int : 0 setting succeed
 *     -1 setting error.
 * 
 * 
 */
extern int	KCIConnectionSetNonBlocking(KCIConnection *conn, int arg);

/*
 * NAME: KCIConnectionFlush
 *
 * 
 * DESCRIPTION:           
 * Attempts to flush any queued output data to the server.
 *   
 *    
 * PARAMETERS:          
 *  KCIConnection *conn :  The connection object to send the command through
 *
 *
 * RETURNS: 
 *   int : 0   if flush succeed
 *      -1  if flush failed for some reason.
 *       1  if it was unable to send all the data in the send queue yet
 *           (this case can only occur if the connection is nonblocking).  
 * 
 * After sending any command or data on a nonblocking connection, call KCIConnectionFlush. 
 * If it returns 1, wait for the socket to be write-ready and call it again; repeat
 * until it returns 0. Once KCIConnectionFlush returns 0, wait for the socket to be 
 * read-ready and then read the response as described above.  
 */
extern int	KCIConnectionFlush(KCIConnection *conn);

/*
 * NAME: KCIConnectionIsNonBlocking
 *
 * 
 * DESCRIPTION:           
 * Returns the blocking status of the database connection.
 *
 * 
 * PARAMETERS: 
 *   KCIConnection *conn : The connection object to send the command through        	 	 	 	 	  
 *
 *  
 * RETURNS: 
 *   int : 1 if the connection is set to nonblocking mode 
 *       0 if blocking. 
 * 
 */
extern int	KCIConnectionIsNonBlocking(const KCIConnection *conn);

/*
 * NAME: KCICursorSendDescribe
 *
 * 
 * DESCRIPTION:           
 * Submits a request to obtain information about the specified portal, without 
 * waiting for completion
 *
 * 
 * PARAMETERS: 
 *   KCIConnection *conn :  The connection object to send the command through 
 *   const char *portal :   port    	 	 	 	 	  
 *
 *  
 * RETURNS: 
 * int : 1 if it was able to dispatch the request, 
 *    0 if not. 
 * 
 */
extern int	KCICursorSendDescribe(KCIConnection *conn, const char *portal);

/*
 * NAME: KCIConnectionForceRead
 *
 *  
 * DESCRIPTION:           
 *  If input is available from the server, consume it. 
 *   
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through.
 * 
 *  
 * RETURNS: 
 *      0 return: some kind of trouble
 *      1 return: no problem 
 * 
 * Note that the result does not say whether any input data was actually collected.
 * After calling KCIConnectionForceRead, the application can check KCIConnectionIsBusy 
 * and/or KCIGetNextNotification to see if their state has changed.
 * KCIConnectionForceRead can be called even if the application is not prepared to deal
 * with a result or notification just yet. The function will read available data 
 * and save it in a buffer, thereby causing a select() read-ready indication to
 * go away. The application can thus use KCIConnectionForceRead to clear the select() 
 * condition immediately, and then examine the results at leisure.
 *  
 */ 
extern int	KCIConnectionForceRead(KCIConnection *conn);

/*
 * NAME: KCIGetNextNotification
 *
 * 
 * DESCRIPTION:           
 *   libkci applications submit LISTEN and UNLISTEN commands as ordinary SQL commands. 
 *   The arrival of NOTIFY messages can subsequently be detected by calling KCIGetNextNotification. 
 *
 *   The function KCIGetNextNotification returns the next notification from a list of unhandled  
 *   notification messages received from the server. It returns a null pointer if there are no pending
 *   notifications. Once a notification is returned from KCIGetNextNotification, it is considered  
 *   handled and will be removed from the list of notifications. 
 *
 *   
 *    
 * PARAMETERS:
 *  KCIConnection *conn : The connection object to send the command through
 *  
 *  				
 * 
 * RETURNS: 
 *   KCINotify * : returns the next notification from a list of unhandled notification messages
 *   received from the server.
 */
extern KCINotify *KCIGetNextNotification(KCIConnection *conn);

/*
 * NAME: KCISetNoticeReceiver
 *
 * 
 * DESCRIPTION:           
 *   The function KCISetNoticeReceiver sets or examines the current notice receiver 
 *   for a connection object. 
 *
 *   
 * PARAMETERS:
 *  KCIConnection *conn : The connection object to send the command through
 *  KCINoticeReceiver proc :	function of KCINoticeReceiver
 *  void *arg :arguments of KCINoticeReceiver
 *
 *
 * 
 * RETURNS: 
 *   KCINoticeReceiver : returns the previous notice receiver and sets the new value
 *
 */
extern KCINoticeReceiver KCISetNoticeReceiver(KCIConnection *conn,
					KCINoticeReceiver proc,
					void *arg);

/*
 * NAME: KCISetNoticeProcessor
 *
 * 
 * DESCRIPTION:           
 *   The function KCISetNoticeReceiver sets or examines the 
 *   current notice processor. 
 *
 *   
 * PARAMETERS:
 *  KCIConnection *conn : returns the next notification from a list of unhandled notification messages
 *  received from the server.
 *  KCINoticeProcessor proc :function of KCINoticeProcessor
 *  void *arg :arguments of KCINoticeProcessor
 *
 *
 * 
 * RETURNS: 
 *   KCINoticeProcessor : returns the processor function pointer and sets the new value
 *
 */
extern KCINoticeProcessor KCISetNoticeProcessor(KCIConnection *conn,
					 KCINoticeProcessor proc,
					 void *arg);

/*------------------ 4. Asynchronous Command Processing end-------------------*/

/*------------------ 5. Cancelling Queries in Progress --------------------------*/

/*
 * NAME: KCICancelAlloc
 *
 * 
 * DESCRIPTION:           
 * Creates a data structure containing the information needed to cancel a command
 * issued through a particular database connection.
 *   
 *    
 * PARAMETERS:          
 *   KCIConnection *conn :  The connection object to send the command through
 *
 * RETURNS: 
 *   KCICancelRequest :  NULL if conn is NULL                          
 *  
 * 
 * The KCICancelRequest object is an opaque structure that is not meant to be accessed 
 * directly by the application; it can only be passed to KCICancelDealloc or KCICancelSend. 
 */
extern KCICancelRequest *KCICancelAlloc(KCIConnection *conn);

/*
 * NAME: KCICancelDealloc
 *
 * 
 * DESCRIPTION:           
 * Frees a data structure created by KCICancelAlloc. 
 *   
 *    
 * PARAMETERS:          
 *  KCICancelRequest *cancel :  points to a KCICancelRequest object created by KCICancelAlloc 
 *   
 * 
 * RETURNS: 
 *   void                           
 *
 */
extern void KCICancelDealloc(KCICancelRequest *cancel);

/*
 * NAME: KCICancelSend
 *
 * 
 * DESCRIPTION:           
 * Requests that the server abandon processing of the current command. 
 *   
 *    
 * PARAMETERS:          
 *  KCICancelRequest *cancel : The KCICancelRequest object created by KCICancelAlloc 
 *  char *errbuf :  a char array of size errbufsize (the recommended size is 256 bytes),
 *                  saves some error messages.  
 *  int errbufsize : the size of errbuf
 *  
 *  
 * RETURNS: 
 *  int : 1 if the cancel request was successfully dispatched                            
 *         0 if  the cancel request was not successfully dispatched
 */
extern int	KCICancelSend(KCICancelRequest *cancel, char *errbuf, int errbufsize);

/*
 * NAME: KCICancelCurrent
 *  
 * 
 * DESCRIPTION:           
 * Requests that the server abandon processing of the current command. 
 *
 *  
 * PARAMETERS: 
 *  const KCIConnection *conn : The connection object to send the command through 
 * 
 *  
 * RETURNS: 
 *  int : 1 if the cancel request was successfully dispatched                            
 *        0 if  the cancel request was not successfully dispatched 
 * 
 * KCICancelCurrent is a deprecated variant of KCICancelSend. It operates directly on 
 * the KCIConnection object, and in case of failure stores the error message in the 
 * KCIConnection object (whence it can be retrieved by KCIConnectionGetLastError).
 * Although the functionality is the same, this approach creates hazards for multiple-thread 
 * programs and signal  handlers, since it is possible that overwriting the KCIConnection's
 * error message will mess up the operation currently in progress on the connection.
 *         
 */
extern int	KCICancelCurrent(KCIConnection *conn);

/*------------------ 5. Cancelling Queries in Progress end-----------------------*/

/*------------------ 6.  Functions Associated with the COPY Command ------------*/

/*------------------6.1. Functions for Sending COPY Data -----------------------*/

/*
 * NAME: KCICopySendData
 *
 * 
 * DESCRIPTION:           
 *   Sends data to the server during COPY_IN state.  
 *   
 *    
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *	 const char *buffer : saves the copy data which will send to server 
 *	 int nbytes : the length of buffer.
 *	 
 *	 
 * RETURNS: 
 *   int : 1 if the data was sent                            
 *       0 it was not sent because the attempt would block 
 *      -1 if an error occurred
 *    
 */
extern int	KCICopySendData(KCIConnection *conn, const char *buffer, int nbytes);

/*
 * NAME: KCICopySendEOF
 *
 * 
 * DESCRIPTION:           
 *   Sends end-of-data indication to the server during COPY_IN state.  
 *   
 *    
 * PARAMETERS:
 *   KCIConnection *conn: The connection object to send the command through
 *	 const char *errormsg : saves the error message 
 *	 
 *	 
 * RETURNS: 
 *   int : 1   if the termination data was sent                            
 *       0  if it was not sent because the attempt would block  
 *      -1  if an error occurred
 *          
 * After successfully calling KCICopySendEOF, call KCIConnectionFetchResult to 
 * obtain the final result status of the COPY command. One can wait for this result
 * to be available  in the usual way. Then return to normal operation.
 * 
 */
extern int	KCICopySendEOF(KCIConnection *conn, const char *errormsg);

/*------------------ 6.1. Functions for Sending COPY Data  end--------------------*/

/*------------------ 6.2. Functions for Receiving COPY Data ----------------------*/

/*
 * NAME: KCICopyReceiveData
 *
 * 
 * DESCRIPTION:           
 *   Receives data from the server during COPY_OUT state.   
 *   
 *    
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *	 char **buffer : a chunk of memory to hold the data, must not NULL,
 *	             *buffer is set to point to the allocated memory, or
 *	             to NULL in cases where no buffer is returned. 
 *	    
 *	 int async :   true (not zero) : KCICopyReceiveData will not block waiting
 *	           for input; it will return zero if the COPY is still in progress	           
 *             but no complete row is available. (In this case wait for read-ready
 *	           and then call KCIConnectionForceRead before calling KCICopyReceiveData again.) 
 *	           false (zero) : KCICopyReceiveData will block until data
 *	           is available or the operation completes.
 *	 
 * 
 * RETURNS: 
 *   int : the number of data bytes in the row when a row is successfully returned.                            
 *       0  indicates that the COPY is still in progress, but no row is yet available 
 *            (this is only possible when async is true).   
 *      -1  indicates that the COPY is done.
 *      -2  indicates that an error occurred.   
 *
 */
 extern int	KCICopyReceiveData(KCIConnection *conn, char **buffer, int async);

/*------------------ 6.2. Functions for Receiving COPY Data  end ------------------*/

/*------------------ 6.3. Obsolete Functions for COPY ---------------------------*/

/*
 * NAME: KCICopySync
 *
 * 
 * DESCRIPTION:           
 *   Synchronizes with the server.   
 *   
 *    
 * PARAMETERS:
 *   KCIConnection *conn  : The connection object to send the command through
 *	 
 * 
 * RETURNS: 
 *   int :  0 the server is ready to receive the next SQL command. 
 *         nonzero  the operation is failed.
 *
 */
extern int	KCICopySync(KCIConnection *conn);

/*
 * NAME: KCICopyReadLine
 *
 *  
 * DESCRIPTION:           
 *  Reads a newline-terminated line of characters (transmitted by the server) into
 * a buffer string of size length; This function copies up to length-1 characters into the buffer and converts 
 * the terminating newline into a zero byte. KCICopyReadLine returns EOF at the end of
 * input, 0 if the entire line has been read, and 1 if the buffer is full but the
 * terminating newline has not yet been read.
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 *	char *string : the buffer string to be written in. 
 *	int length : the size of string. 
 * 
 *  
 * RETURNS: 
 *  int : return the number of characters written into string. 
 * 
 * Note that the application must check to see if a new line consists of the two 
 * characters \., which indicates that the server has finished sending the results
 * of the COPY command. If the application might receive lines that are more than 
 * length-1 characters long, care is needed to be sure it recognizes the \. line 
 * correctly (and does not, for example, mistake the end of a long data line for a
 * terminator line).
 *  
 */
extern int	KCICopyReadLine(KCIConnection *conn, char *string, int length);

/*
 * NAME: KCICopyWriteLine
 *
 *   
 * DESCRIPTION:           
 *  Sends a null-terminated string to the server. 
 *   
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through.
 *	char *string : the string that will send to server. 
 * 
 *  
 * RETURNS: 
 *  Returns 0 if OK and EOF if unable to send the string. 
 *
 * The COPY data stream sent by a series of calls to KCICopyWriteLine has the same 
 * format as that returned by KCICopyReadLineAsync, except that applications are not
 * obliged to send exactly one data row per KCICopyWriteLine call; it is okay to send a
 * partial line or multiple lines per call.
 *  
 */
extern int	KCICopyWriteLine(KCIConnection *conn, const char *string);

/*------------------ 6.3. Obsolete Functions for COPY end ------------------------*/

/*------------------ 6 Functions Associated with the COPY Command ---------------*/

/*------------------ 7. Large Object  function-----------------------------------*/

/*
 * NAME: KCILobCreate
 *
 * 
 * DESCRIPTION:           
 *   creates a new large object.
 *   
 *    
 * PARAMETERS:
 *  KCIConnection *conn : The connection object to send the command through
 *	Oid lobjId : The OID to be assigned can be specified by lobjId
 *	char lobtype :  
 *  				
 * 
 * RETURNS: 
 *   Oid  : the OID that was assigned to the new large object
 *   
 */
 extern Oid KCILobCreate(KCIConnection *conn, Oid lobjId, char lobtype);

/*
 * NAME: KCILobOpen
 *
 * 
 * DESCRIPTION:           
 *   To open an existing large object for reading or writing.
 *   
 *    
 * PARAMETERS:
 *  KCIConnection *conn : The connection object to send the command through
 *	Oid lobjId : the OID of the large object to open
 *	int mode : reading (INV_READ), writing (INV_WRITE), or both  
 *  				
 * 
 * RETURNS: 
 *   int : large object descriptor ( lo_read, lo_write, lo_lseek, lo_tell, and lo_close)
 *       -1 if executes failed. 
 *   
 */ 
extern int KCILobOpen(KCIConnection *conn, Oid lobjId, int mode);

/*
 * NAME: KCILobClose
 *
 * 
 * DESCRIPTION:           
 *   close a large object descriptor
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *	 int fd £ºa large object descriptor returned by KCILobOpen  
 *  				
 * 
 * RETURNS: 
 *   int : 0 if succeed 
 *       negative value if failed. 
 *   
 */
extern int KCILobClose(KCIConnection *conn, int fd);

/*
 * NAME: KCILobDrop
 *
 * 
 * DESCRIPTION:           
 *   To remove a large object from the database   
 *    
 * 
 * PARAMETERS:
 *  KCIConnection *conn : The connection object to send the command through
 *	Oid lobjId : the Oid of the large object to be removed    
 *  				
 * 
 * RETURNS: 
 *   int : 1 if succeed 
 *      -1 if failed. 
 *   
 */
extern int KCILobDrop(KCIConnection *conn, Oid lobjId);

/*
 * NAME: KCIBlobRead
 *
 * 
 * DESCRIPTION:           
 *   To read a Blob object from the database   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd :   the file descriptor 
 *   char *buf :  the buffer for saving the large object
 *   size_t len : the length of buffer
 *  				
 * 
 * RETURNS: 
 *   int  :  the number of bytes actually if executes succeed
 *           negative value if failed. 
 *   
 */
extern int KCIBlobRead(KCIConnection *conn, int fd, char *buf, size_t len);

extern int KCIBlobDirectRead(KCIConnection *conn, Oid lobjId, char *buf, size_t len);

/*
 * NAME: KCIBlobImport
 *
 * 
 * DESCRIPTION:           
 *   Import a Blob object to  database   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   char *filename :  the name of the Blob object
 *  				
 * 
 * RETURNS: 
 *   Oid  :  the OID that was assigned to the new large object if succeed.
 *           InvalidOid (zero) on failure 
 *   
 */
extern Oid KCIBlobImport(KCIConnection *conn, const char *filename);

/*
 * NAME: KCIBlobExport
 *
 * 
 * DESCRIPTION:           
 *   Export a Blob object from  database   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   Oid lobjId :  specifies the OID of the large object to export 
 *   char *filename :  tspecifies the operating system name of the file
 *  				
 * 
 * RETURNS: 
 *   int  :  1 on success, -1 on failure. 
 *   
 */
extern int KCIBlobExport(KCIConnection *conn, Oid lobjId, const char *filename);

/*
 * NAME: KCIBlobWrite
 *
 * 
 * DESCRIPTION:           
 *   Write to a Blob object    
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the file descriptor of Blob object
 *   const char *buf :  saves the data to be written
 *   size_t len  : the length of bytes to be written
 *  				
 * 
 * RETURNS: 
 *   int  :  the number of bytes actually written 
 *           negative values if faile  
 *   
 */
extern int KCIBlobWrite(KCIConnection *conn, int fd, const char *buf, size_t len);

/*
 * NAME: KCIBlobSeek
 *
 * 
 * DESCRIPTION:           
 *   Change the current read or write location associated with a large object descriptor   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the large object descriptor
 *   int offset :  specified the new location  
 *   int whence :   SEEK_SET (seek from object start), 
 *               SEEK_CUR (seek from current position), 
 *               SEEK_END (seek from object end).
 *  				
 * 
 * RETURNS: 
 *   int : the new location
 *       -1 if error  
 *   
 */
extern int KCIBlobSeek(KCIConnection *conn, int fd, int offset, int whence);

/*
 * NAME: KCIBlobTell
 *
 * 
 * DESCRIPTION:           
 *   Obtain the current read or write location of a large object descriptor   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the large object descriptor  
 *  				
 * 
 * RETURNS: 
 *   int : the new location of the large object descriptor if succeed
 *       negative value if error  
 *   
 */
extern int KCIBlobTell(KCIConnection *conn, int fd);

/*
 * NAME: KCIBlobPosition
 *
 * 
 * DESCRIPTION:           
 *   Find the specified string at the specified position in the open Blob object.   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the large object descriptor  
 *   char *searchstr : the specified string which will be searched in Blob object 
 *   int searchlen : the length of search string. 
 *   int lstart : the start position
 *  				
 * 
 * RETURNS: 
 *   int : the location  of the large object descriptor
 *       negative value if error  
 *   
 */
extern int KCIBlobPosition(KCIConnection *conn, int fd, char *searchstr, int searchlen, int lstart);

/*
 * NAME: KCIBlobPositionLob
 *
 * 
 * DESCRIPTION:           
 *   Find the specified Blob object fd2 at the specified position in the 
 *   open Blob object fd.   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the large object descriptor
 *   int fd2 : the large object descriptor 
 *   int lstart : the start position
 *  				
 * 
 * RETURNS: 
 *   int : the location of the large object descriptor if succeed
 *       -1 if error  
 *   
 */
extern int KCIBlobPositionLob(KCIConnection *conn, int fd, int fd2, int lstart);

/*
 * NAME: KCIBlobTruncate
 *
 * 
 * DESCRIPTION:           
 *   Truncate a large object with a given length.  
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the large object descriptor
 *   int len : the length of truncation
 *  				
 * 
 * RETURNS: 
 *   int : 0 if succeed
 *       -1 values if error  
 *   
 */
extern int KCIBlobTruncate(KCIConnection *conn, int fd, int len);

/*
 * NAME: KCIClobImport
 *
 * 
 * DESCRIPTION:           
 *   Import a Clob object to a database.  
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   char *filename :  the name of the Clob object
 *   const char *encoding : the used encoding 
 *  				
 * 
 * RETURNS: 
 *   Oid  : the OID that was assigned to the new large object if succeed.
 *          InvalidOid (zero) on failure  
 *   
 */
extern Oid KCIClobImport (KCIConnection *conn, const char *filename, const char *encoding);

/*
 * NAME: KCIClobExport
 *
 * 
 * DESCRIPTION:           
 *   Export a Clob object from a database.  
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   char *filename :  the filename of the exported Clob object, for examples: "/home/usr/MyPhoto.jpg" 
 *   Oid lobjId :  specifies the OID of the large object to export  
 *   const char *encoding : the encoding you want to use
 *  				
 * 
 * RETURNS: 
 *     int : 1 on success, -1 on failure. 
 *          
 *   
 */
extern int KCIClobExport (KCIConnection *conn, Oid lobjId, const char *filename, const char *encoding);

/*
 * NAME: KCIClobWrite
 *
 * 
 * DESCRIPTION:           
 *   Write to  a Clob object.   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the file descriptor of Clob object
 *   const char *buf : saves the data to be written
 *   size_t len : the length of bytes to be written
 * 
 * 
 * RETURNS: 
 *   int  :  the number of bytes actually written 
 *           negative values if failed  
 *   
 */
extern int KCIClobWrite (KCIConnection *conn, int fd, char *buf, size_t len);

/*
 * NAME: KCIClobRead
 *
 * 
 * DESCRIPTION:           
 *   To read a Clob object from the database.   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd :   the file descriptor 
 *   char *buf :  the buffer for saving the large object
 *   size_t len : the length of buffer
 * 
 * 
 * RETURNS: 
 *   int : the number of bytes actually if executes succeed
 *       negative value if failed. 
 *   
 */
extern int KCIClobRead(KCIConnection *conn, int fd, char *buf, size_t len);

extern int KCIClobDirectRead(KCIConnection *conn, Oid lobjId, char *buf, size_t len);
/*
 * NAME: KCIClobSeek
 *
 * 
 * DESCRIPTION:           
 *   Change the current read or write location associated with a large object descriptor .   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the large object descriptor
 *   int offset :  specified the new location  
 *   int whence :   SEEK_SET (seek from object start), 
 *               SEEK_CUR (seek from current position), 
 *               SEEK_END (seek from object end).
 * 
 * 
 * RETURNS: 
 *   int : the new location
 *       -1 if error  
 *   
 */
extern int KCIClobSeek(KCIConnection *conn, int fd, int offset, int whence);

/*
 * NAME: KCIClobTell
 *
 * 
 * DESCRIPTION:           
 *   Obtain the current read or write location of a large object descriptor   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the large object descriptor  
 *  				
 * 
 * RETURNS: 
 *   int : the new location of the large object descriptor if succeed
 *       negative value if error  
 *   
 */ 
extern int KCIClobTell(KCIConnection *conn, int fd);

/*
 * NAME: KCIClobPosition
 *
 * 
 * DESCRIPTION:           
 *   Find the specified string at the specified position in the open Clob object.   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the large object descriptor  
 *   char *searchstr : the specified string which will be searched in Clob object 
 *   int searchlen : the length of search string. 
 *   int lstart : the start position
 *  				
 * 
 * RETURNS: 
 *   int : the location of the large object descriptor
 *       negative value if error  
 *   
 */
extern int KCIClobPosition(KCIConnection *conn, int fd, char *searchstr, int searchlen, int lstart);

/*
 * NAME: KCIClobPositionLob
 *
 * 
 * DESCRIPTION:           
 *   Find the specified Clob object fd2 at the specified position in the 
 *   open Clob object fd.   
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the large object descriptor
 *   int fd2 : the large object descriptor 
 *   int lstart : the start position
 *  				
 * 
 * RETURNS: 
 *   int : the location of the large object descriptor if succeed
 *       -1 if error  
 *   
 */
extern int KCIClobPositionLob(KCIConnection *conn, int fd, int fd2, int lstart);

/*
 * NAME: KCIClobTruncate
 *
 * 
 * DESCRIPTION:           
 *   Truncate a large object with a given length.  
 *    
 * 
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *   int fd : the large object descriptor
 *   int len : the length of truncation
 *  				
 * 
 * RETURNS: 
 *   int : the location of the large object descriptor  if succeed
 *       -1 values if error  
 *   
 */
extern int KCIClobTruncate(KCIConnection *conn, int fd, int len);


/*------------------ 7. Large Object end --------------------------------------*/

/*------------------ 8. Control Functions--------------------------------------*/

/*
 * NAME: KCIConnectionGetClientEncoding
 *
 * 
 * DESCRIPTION:           
 *   Returns the client encoding. 
 *   
 *    
 * PARAMETERS:
 *   KCIConnection *conn  : The connection object to send the command through
 *	 
 * 
 * RETURNS: 
 *   int : the encoding ID
 *
 */
extern int	KCIConnectionGetClientEncoding(const KCIConnection *conn);

/*
 * NAME: KCIConnectionGetClientEncoding
 *
 * 
 * DESCRIPTION:           
 *   Sets the client encoding. 
 *   
 *    
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *	 const char *encoding : the encoding you want to use
 * 
 * 
 * RETURNS: 
 *   int :  0 sets encoding successd
 *          otherwise  failed.
 *          
 * The current encoding for this connection can be determined by using 
 * KCIConnectionGetClientEncoding.   
 *
 */ 
extern int	KCIConnectionSetClientEncoding(KCIConnection *conn, const char *encoding);

/*
 * NAME: KCISetVerbosity
 *
 * 
 * DESCRIPTION:           
 *   Determines the verbosity of messages returned by KCIConnectionGetLastError
 *   and KCIResultGetErrorString. 
 *   
 *    
 * PARAMETERS:
 *   KCIConnection *conn : The connection object to send the command through
 *	 KCIErrorVerbosity verbosity : 
 *  				typedef enum
 *					{
 *						ERRORS_TERSE,			 
 *						ERRORS_DEFAULT,			 
 *						ERRORS_VERBOSE			 
 *					} KCIErrorVerbosity;
 *
 * 
 * RETURNS: 
 *   returning the connection's previous setting. 
 *   KCIErrorVerbosity : ERRORS_TERSE mode returned messages include severity,
 *                                          primary text, and position only;
 *                       ERRORS_DEFAULT	   the above plus any detail, hint, or 
 *                                         context fields 	
 *                       ERRORS_VERBOSE    available fields
 *
 *
 */
extern KCIErrorVerbosity KCISetVerbosity(KCIConnection *conn, KCIErrorVerbosity verbosity);

/*
 * NAME: KCISetLogFile
 *
 *  
 * DESCRIPTION:           
 *  Enables tracing of the client/server communication to a debugging file stream.
 *
 *  
 * PARAMETERS: 
 *  const KCIConnection *conn : The connection object to send the command through
 *  logfilename : the name of logfile.
 *  mode : file access mode.   
 * 
 *  
 * RETURNS: 
 *  int : file descriptor of logfile
 * 
 * On Windows, if the libkci library and an application are compiled with different 
 * flags, this function call will crash the application because the internal 
 * representation of the FILE pointers differ. Specifically, multithreaded/single-threaded,
 * release/debug, and static/dynamic flags should be the same for the library and
 * all applications using that library.
 *          
 */
extern int KCISetLogFile(KCIConnection *conn, const char *logfilename, const char * mode);

/*
 * NAME: KCIResetLogFile
 *
 * 
 * DESCRIPTION:           
 *  Disables tracing started by KCISetLogFile.
 *
 *  
 * PARAMETERS: 
 *  KCIConnection *conn : The connection object to send the command through
 * 
 *  
 * RETURNS: 
 *  int : 1 disabled succeed
 *        0 disabled failed
 *          
 */
extern int KCIResetLogFile(KCIConnection *conn);


/*------------------ 8. Control Functions end-----------------------------------*/


/*------------------ 9. Miscellaneous Functions--------------------------------*/

/*
 * NAME: KCIEncrypt
 *
 * 
 * DESCRIPTION:           
 *   Prepares the encrypted form of a KingbaseES password, This function is intended 
 *   to be used by client applications that wish to send commands like ALTER USER joe 
 *   PASSWORD 'pwd'.
 *   
 *    
 * PARAMETERS:
 *  const char *passwd : the cleartext password
 *  const char *user : the SQL name of the user it is for
 *  				
 * 
 * RETURNS: 
 *   char * : a string allocated by malloc, or NULL if out of memory£¬the new 
 *            password.
 *
 */
extern char *KCIEncrypt(const char *passwd, const char *user);

/*
 * NAME: KCIResultCreate
 *
 * 
 * DESCRIPTION:           
 *   Constructs an empty KCIResult object with the given status.
 *   
 *    
 * PARAMETERS:
 *  KCIConnection *conn : The connection object to send the command through
 *	KCIExecuteStatus status : the status of execution
 *  				
 * 
 * RETURNS: 
 *   KCIResult * : NULL if memory could not be allocated
 *                 pointer to a KCIResult. 
 *
 * If conn is not null and status indicates an error, the current error message 
 * of the specified connection is copied into the KCIResult.
 * Also, if conn is not null, any event procedures registered in the connection 
 * are copied into the KCIResult.  
 */
extern KCIResult *KCIResultCreate(KCIConnection *conn, KCIExecuteStatus status);

/*
 * NAME: KCIFree
 *
 * 
 * DESCRIPTION:  
 *  Frees memory allocated by libkci. 
 *     
 * 
 * PARAMETERS: 
 *   void *ptr : pointer to the memory needed free 
 * 
 * 
 * RETURNS: 
 *   void 
 * On non-Microsoft Windows platforms, this function is the same as the standard
 * library function free().
 */

extern void KCIFree(void *ptr);
/*
 * NAME: KCIResultPrintEx
 *
 * DESCRIPTION:           
 * Format results of a query for printing,really old printing routines.
 *
 * 
 * PARAMETERS: 
 *  FILE *fp : where to send the output 
 *  int fillAlign : pad the fields with spaces
 *	const char *fieldSep :	field separator 
 *	int printHeader : specified whether print the attributes name 
 *	int quiet : whether to print the summary result.	 	 	 	 	  
 *
 *  
 * RETURNS: 
 *   void 
 * 
 */
extern void
KCIResultPrintEx(const KCIResult *res,
				FILE *fp,		       /* where to send the output */
				int fillAlign,	       /* pad the fields with spaces */
				const char *fieldSep,  /* field separator */
				int printHeader,	   /* display headers? */
				int quiet);

/*
 * NAME: KCIResultPrintEx1
 *
 * DESCRIPTION:           
 * Format results of a query for printing,really old printing routines.
 *
 * 
 * PARAMETERS: 
 *  const KCIResult *res : the result of query
 *  FILE *fout : where to send the output 
 *  int printAttName :  print attribute names 
 *	int terseOutput : delimiter bars 
 *	int width : width of column, if 0, use variable width 	 	 	  
 *
 *  
 * RETURNS: 
 *   void 
 * 
 */
extern void
KCIResultPrintEx1(const KCIResult *res,
			  FILE *fout,		/* output stream */
			  int printAttName, /* print attribute names */
			  int terseOutput,	/* delimiter bars */
			  int width);		/* width of column, if 0, use variable width */

/*
 * NAME: KCIGetStringByteLength
 *
 * 
 * DESCRIPTION:           
 *  Determine length of multibyte encoded char at *s 
 *
 * 
 * PARAMETERS: 
 *  const char *s: where to send the output 
 *  int encoding : the id of encoding.
 *
 *  
 * RETURNS: 
 *   int : the length of bytes of encoded string s.  
 * 
 */
extern int	KCIGetStringByteLength(const char *s, int encoding);

/*
 * NAME: KCIGetStringDisplayLength
 *
 * 
 * DESCRIPTION:           
 *  Determine display length of multibyte encoded char at *s 
 *
 * 
 * PARAMETERS: 
 *  const char *s: where to send the output 
 *  int encoding : the id of encoding.
 *
 *  
 * RETURNS: 
 *   int : the length of bytes of encoded string s.  
 * 
 */
extern int	KCIGetStringDisplayLength(const char *s, int encoding);

/*
 * NAME: KCIGetEnvEncoding
 *
 * 
 * DESCRIPTION:           
 *  Get encoding id from environment variable KINGBASE_CLIENTENCODING
 *
 * 
 * PARAMETERS: 
 *  void 
 *
 *  
 * RETURNS: 
 *   int : encodeing id.
 * 
 */
extern int	KCIGetEnvEncoding(void);

#ifdef WIN32

/*
 * NAME: KCIIsRemoteHost
 *
 * 
 * DESCRIPTION:  
 *  Return whether the host is a remote process
 *     
 * 
 * PARAMETERS: 
 *  const char * host : the name of host 
 * 
 * 
 * RETURNS: 
 *   bool : true is remote host
 *          false isn't remote host 
 * 
 */
extern bool KCIIsRemoteHost(const char *host);

#endif

/*
 * NAME: KCISignal
 *
 * 
 * DESCRIPTION:  
 *  Supply a interface to use the kcisigfunc func to 
 *  complement the signal   
 *     
 * 
 * PARAMETERS: 
 *   int signo : the ID of signal
 *   kcisigfunc func : the function pointer of kcisigfunc 
 * 
 * 
 * RETURNS: 
 *   kcisigfunc : the pointer to the function to complement the signal 
 * 
 */
extern KCISigFunc KCISignal(int signo, KCISigFunc func);

/*
 * NAME: KCIStringCreate
 *
 * 
 * DESCRIPTION:           
 *  create a KCIExpBuffer object initially
 *
 * 
 * PARAMETERS: 
 *  void
 *
 *  
 * RETURNS: 
 *   KCIExpBuffer :  if Initialization succeed return a valid KCIExpBuffer pointer
 *                   else NULL            
 * 
 */ 
extern KCIExpBuffer KCIStringCreate(void);

/*
 * NAME: KCIStringInitialize
 *
 * 
 * DESCRIPTION:           
 * init KCIExpBufferData, Initialize a KCIExpBufferData struct (with previously undefined contents)
 * to describe an empty string.
 *
 * 
 * PARAMETERS: 
 *  KCIExpBuffer str : the KCIExpBuffer that will be initlized
 *
 *  
 * RETURNS: 
 *   void 
 * 
 */ 
extern void KCIStringInitialize(KCIExpBuffer str);
extern void KCIStringInitializeCustom(KCIExpBuffer str, size_t size);
extern KCIExpBuffer KCIStringCreateCustom(size_t size);

/*------------------------
 * To destroy a KCIExpBuffer, use either:
 *
 * KCIStringDestory(str);
 *		free()s both the data buffer and the KCIExpBufferData.
 *		This is the inverse of KCIStringCreate().
 *
 * KCIStringFreeData(str)
 *		free()s the data buffer but not the KCIExpBufferData itself.
 *		This is the inverse of KCIStringInitialize().
 *
 * NOTE: some routines build up a string using KCIExpBuffer, and then
 * release the KCIExpBufferData but return the data string itself to their
 * caller.	
 * At that point the data string looks like a plain malloc'd
 * string.
 */
extern void KCIStringDestory(KCIExpBuffer str);
extern void KCIStringFreeData(KCIExpBuffer str);

/*
 * NAME: KCIStringDestory, KCIStringFreeData
 *
 * 
 * DESCRIPTION:  
 *  To destroy a KCIExpBuffer
 *  KCIStringDestory(str)    
 *      free()s both the data buffer and the KCIExpBufferData.
 *		This is the inverse of KCIStringCreate().
 *KCIStringFreeData(str) 
 *      free()s the data buffer but not the KCIExpBufferData itself.
 *		This is the inverse of KCIStringInitialize().	 
 * 
 * PARAMETERS: 
 *  KCIExpBuffer str : the KCIExpBuffer will be operated.
 *
 *  
 * RETURNS: 
 *   void 
 * 
 */ 
extern void KCIStringResetData(KCIExpBuffer str);

/*
 * NAME: KCIStringEnlarge
 *
 * 
 * DESCRIPTION:  
 *  enlarge KCIExpBufferData
 *   
 * 
 * PARAMETERS: 
 *  KCIExpBuffer str : the KCIExpBuffer will be operated.
 *  size_t needed  : the additional space. 
 *  
 * 
 * RETURNS: 
 *   int : Returns 1 if OK, 0 if failed to enlarge buffer
 * 
 * Make sure there is enough space for 'needed' more bytes in the buffer
 * ('needed' does not include the terminating null). 
 */
extern int KCIStringEnlarge(KCIExpBuffer str, size_t needed);

/*
 * NAME: KCIStringPrintfFormat
 *
 * 
 * DESCRIPTION:  
 *  print KCIExpBufferData in certain format
 *   
 * 
 * PARAMETERS: 
 *  KCIExpBuffer str : the KCIExpBuffer which saves the  result;
 *  const char *fmt  : Format text data under the control of fmt (an sprintf-like format string) 
 *  ... :  the argument list
 * 
 * 
 * RETURNS: 
 *   void
 * 
 * More space is allocated to str if necessary.
 * This is a convenience routine that does the same thing as
 * KCIStringResetData() followed by KCIStringAppendFormat().
 */
extern void
KCIStringPrintfFormat(KCIExpBuffer str, const char *fmt,...)

/* This extension allows gcc to check the format string */
__attribute__((format(printf, 2, 3)));

/*
 * NAME: KCIStringAppendFormat
 *
 *
 * DESCRIPTION:  
 *  append KCIExpBufferData 
 *   
 * 
 * PARAMETERS: 
 *  KCIExpBuffer str : the KCIExpBuffer which saves the  result;
 *  const char *fmt  : Format text data under the control of fmt (an sprintf-like format string) 
 *  ... :  the argument list
 * 
 * 
 * RETURNS: 
 *   void
 * 
 * More space is allocated to str if necessary.  This is sort of like a combination of sprintf and
 * strcat.
 */
extern void
KCIStringAppendFormat(KCIExpBuffer str, const char *fmt,...)

/* This extension allows gcc to check the format string */
__attribute__((format(printf, 2, 3)));

/*
 * NAME: KCIStringAppendCString
 *
 * 
 * DESCRIPTION:  
 *  append KCIExpBufferData ,Append the given string to a KCIExpBuffer, allocating more space 
 *   
 * 
 * PARAMETERS: 
 *  KCIExpBuffer str : the KCIExpBuffer which adds the data string;
 *  const char *data : the data to be appended.  
 * 
 * 
 * RETURNS: 
 *   void
 *
 */
extern void KCIStringAppendCString(KCIExpBuffer str, const char *data);

/*
 * NAME: KCIStringAppendChar
 *
 * 
 * DESCRIPTION:  
 *  append KCIExpBufferData,Append a single byte to str.
 *   
 * 
 * PARAMETERS: 
 *  KCIExpBuffer str : the KCIExpBuffer which adds the char ch;
 *  char ch : the char to be appended.  
 * 
 * 
 * RETURNS: 
 *   void
 * 
 * Like KCIStringAppendFormat(str, "%c", ch) but much faster.
 */
extern void KCIStringAppendChar(KCIExpBuffer str, char ch);

/*
 * NAME: KCIStringAppend
 *
 * 
 * DESCRIPTION:  
 *  append KCIExpBufferData,Append arbitrary binary data to a KCIExpBuffer, 
 *  allocating more space if necessary.
 *   
 * 
 * PARAMETERS: 
 *  KCIExpBuffer str : the KCIExpBuffer which adds the char ch
 *  const char *data : the binary data  to be appended 
 *  size_t datalen : the length of data 
 * 
 * 
 * RETURNS: 
 *   void
 * 
 */
extern void KCIStringAppend(KCIExpBuffer str,const char *data, size_t datalen);


extern void KCICommCompressEncryptSet(KCIConnection *conn, const char *comm_compress_encrypt);

/*
 *for the crypto transport define the pointers
 */
#ifdef TRAENC
extern int InitTransportEncrypt(const char* cryptotransportdll);
extern void CloseTransportEncrypt(void);
#endif

#ifdef USE_CER
extern void StoreClientcertDir(const char *clientcertdir);
#endif

#ifdef TRAENC
extern void SetEnableCryptoTransport(const bool enable);
#endif

/* large object access by dblink */
extern int KCIDBLinkLobOpen(KCIConnection *conn, Oid lobjId, int mode);
extern int KCIDBLinkClobRead(KCIConnection *conn, int fd, char *buf, size_t len);
extern int KCIDBLinkClobTell(KCIConnection *conn, int fd);
extern int KCIDBLinkClobSeek(KCIConnection *conn, int fd, int offset, int whence);
extern int KCIDBLinkLobClose(KCIConnection *conn, int fd);
extern int KCIDBLinkBlobRead(KCIConnection *conn, int fd, char *buf, size_t len);
extern int KCIDBLinkBlobTell(KCIConnection *conn, int fd);
extern int KCIDBLinkBlobSeek(KCIConnection *conn, int fd, int offset, int whence);

/*------------------9. Miscellaneous Functions end ----------------------------*/

/*------------------ FUNCTION DEFINITION  end -------------------------------*/

#ifdef __cplusplus
}
#endif

#endif   /* LIBKCI_H */
