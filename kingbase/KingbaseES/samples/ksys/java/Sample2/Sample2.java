/*
 * This file shows how to call the JKSYS package comes with KSYS.DLL.
 * 
 * @author wxu	
 */

import com.kingbase.ksys.JKSYS;
import java.sql.*;

public class Sample2
{
    public static void main(String args[])
    {
        try
        {
            // Start up KingbaseES
            JKSYS process = new JKSYS(JKSYS.CM_ALL, "D:/Temp/4.1.6.0452/bin",
                "D:/Temp/4.1.6.0452/data", null, null);
            process.startup();

            // Make sure the server is running.
            int status = process.check();
            if (status == 0)
            {
                System.out.println("The server is running.");
            }
            else
            {
                System.out.println("The server is not running.");
                System.exit(1);
            }

            // Application goes here
            Class.forName("com.kingbase.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:kingbase://localhost:54321/SAMPLES", "SYSTEM", "MANAGER");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("select 1 + 1");
            if (rs.next())
            {
                System.out.println("Result: " + rs.getInt(1));
            }
            else
            {
                System.out.println("Error in rs.next().");
            }

            rs.close();
            stmt.close();
            con.close();

            System.out.println("Now we stop the database server.");

            // Shut down KingbaseES
            process.shutdown(JKSYS.SIGINT);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}
