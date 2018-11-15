/* Copyright (c) 2000-2009, KingbaseES Corporation.  All rights reserved.  */

/*
  Author:             KingbaseES
  Date:               2009/05/06
  Source documents:   "Functional Specification for KingbaseES Startup and Shutdown interface", 
                      and the header file
 
  NAME

    KSYS - Startup and Shutdown KingbaseES database interface
 
  DESCRIPTION

    This header file contains  some functions for Startup and Shutdown KingbaseES server, and checking the status of the KingbaseES server.

 
  RELATED DOCUMENTS

    [1] KingbaseES Online-help
 
  PUBLIC FUNCTION TYPES
    1. Start the database server with specified data dir and TCP port.
    2. Shutdown the database server.
    3. Check whether the process is the database server.
    4. Check whether the database server is up or not.
    
    
  MODIFIED
    wjzeng,pzzhao,hxli   2009/05/06 - KCI standardization    
     
*/

#ifndef KSYS_H
#define KSYS_H

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#ifdef WIN32
#include <windows.h>
#undef pid_t
typedef int pid_t; 
#else
#include <sys/types.h>
#include <unistd.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Purpose:
 *   Uses these exclusive members of ConnMode to start database server with
 * specified communication mode.
 */
typedef enum ConnMode {
	CM_ALL,					/* TCP/IP and Windows Shared Memory right now */
	CM_TCPIP,				/* TCP/IP */
	CM_SHARED_MEMORY,		/* Windows Shared Memory */
} ConnMode;

/* 
 * Purpose:
 *  Start the database server with specified data dir and TCP port.
 * Arguments:
 *  connMode    - The communication mode.
 *                Refer to enum ConnMode for valid values. Ignores the port
 *                parameter if you specify CM_SHARED_MEMORY with port number simulater.
 *  binDir		- The directory the database server's executable file is in.
 *                Cannot be NULL or an invalid directory.
 *  dataDir		- The data directory to be used.
 *                Cannot be NULL or an invalid directory.
 *  progname	- The executable file's name.
 *                When NULL, then use default file name "kingbase.exe".
 *	port		- TCP port.
 *				  When NULL, then use the port in the configure file.
 * Return value:
 *  >0		- startup successfully.
 *   0		- startup failed.
 */
extern pid_t Startup(ConnMode connMode, const char *binDir, const char *dataDir, const char *progname, const char *port);

/* 
 * Purpose:
 *  Shutdown the database server.
 * Arguments:
 *  pid		- Process ID returned by Startup(). That's the process ID of
 *  		  database server.
 *  mode	- Shutdown mode.
 *				SIGINT	- fast shutdown, send signals to active connections 
 *						  to shutdown. This is the most commonly used option.
 *				SIGQUIT - immediate shutdown, quit the database server process.
 *				SIGTERM - smart shutdown, wait for active connections to disconnect.
 * Return value:
 *   0		- shutdown successfully.
 *  -1		- shutdown failed.
 */
extern int Shutdown(pid_t pid, const char *mode);

/* 
 * Purpose:
 *  Check whether the process is the database server.
 * Arguments:
 *  pid       - Process ID returned by Startup(). That's the process ID
 *  		    of the database server.
 *  dataDir   - The data directory to be used.
 *  progname  - The executable file's name.
 *              When NULL, then use default file name "kingbase.exe". 
 * Return value:
 * -1         - The database server has not started up.
 *  0         - The database server has started up.
 */
extern int Check(const pid_t pid, const char *dataDir, const char *progname);

/* 
 * Purpose:
 *  Check whether the database server is up or not.
 * Arguments:
 *  str      -  The string is a white-separated list of option = value definitions.
 *              Value might be a single value containing no whitespaces or
 *              a single quoted string. If a single quote should appear anywhere in
 *              the value, it must be escaped with a backslash like \'
 *              eg: "host=localhost port=50321 dbname=TEMPLATE1 user=SYSTEM password=MANAGER".
 * Return value:
 * -1         - The database server has not started up.
 *  0         - The database server has started up.
 */
extern int Ping(const char *connectString);

#ifdef __cplusplus
}
#endif

#endif /* KSYS_H */
