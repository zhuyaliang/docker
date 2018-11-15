/**
 * KSYS.DLL assume the caller is in package: com.kingbase.ksys.
 * If the package mismatch, JNI call will failed.
 * 
 * @ author wxu
 */
package com.kingbase.ksys;

public class JKSYS
{
    /*
     * JNI stuff goes here.
     */

    private native int Startup(int connMode, String binDir, String dataDir,
            String progname, String port);

    private native int Shutdown(int pid, String mode);

    private native int Ping(String connectString);

    private native int Check(int pid, String dataDir, String progname);

    public static final int    CM_ALL           = 0;        /* TCP/IP and Windows Shared Memory right now */
    public static final int    CM_TCPIP         = 1;        /* TCP/IP */
    public static final int    CM_SHARED_MEMORY = 2;        /* Windows Shared Memory */

    public static final String SIGINT           = "SIGINT"; /* fast shutdown, send signals to active connections to shutdown. This is the most commonly used option. */
    public static final String SIGQUIT          = "SIGQUIT"; /* immediate shutdown, quit the database server process. */
    public static final String SIGTERM          = "SIGTERM"; /* smart shutdown, wait for active connections to disconnect.*/

    static
    {
        System.loadLibrary("kci");
        System.loadLibrary("ksys");
    }

    private int                pid;
    private int                connMode;
    private String             binDir;
    private String             dataDir;
    private String             port;
    private String             progname;

    public JKSYS(int connMode, String binDir, String dataDir, String progname,
            String port)
    {
        this.connMode = connMode;
        this.binDir = binDir;
        this.dataDir = dataDir;
        this.progname = progname;
        this.port = port;
        this.pid = 0;
    }

    public void startup() throws Exception
    {
        pid = Startup(connMode, binDir, dataDir, progname, port);
        if (pid == 0)
        {
            throw new Exception("Error occurres when starting KingbaseES!");
        }
    }

    public void shutdown(String mode) throws Exception
    {
        int result = Shutdown(pid, mode);
        if (result != 0)
        {
            throw new Exception("Error occurres when shutting down KingbaseES!");
        }
    }

    public int check() throws Exception
    {
        return Check(pid, dataDir, progname);
    }

    public int ping(String connectString) throws Exception
    {
        return Ping(connectString);
    }
}
