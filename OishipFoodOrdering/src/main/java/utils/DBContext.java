package utils;

import io.github.cdimascio.dotenv.Dotenv;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    //Connection object 
    protected Connection conn = null;

    /**
     * Constructor method that try to connect to the database. All information
     * about the connection (database name, username, password) are imported
     * through .env file
     */
    public DBContext() {
        try {
            //Load config from .env
            Dotenv dotenv = Dotenv.configure()
                    .filename(".env") // Ensures it looks for .env in the classpath
                    .load();
            String databaseName = dotenv.get("DATABASE_NAME");
            String username = dotenv.get("DATABASE_USERNAME");
            String password = dotenv.get("DATABASE_PASSWORD");

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String dbURL = String.format("jdbc:sqlserver://localhost:1433;"
                    + "databaseName=%s;"
                    + "user=%s;"
                    + "password=%s;"
                    + "encrypt=true;trustServerCertificate=true;", databaseName, username, password);
            conn = DriverManager.getConnection(dbURL);
            
            //Log data for checking
            System.out.println("Connect database successfully!");
            DatabaseMetaData md = conn.getMetaData();
            System.out.println("Driver name: " + md.getDriverName());
            System.out.println("Driver version: " + md.getDriverVersion());
            System.out.println("Product name: " + md.getDatabaseProductName());
            System.out.println("Product version: " + md.getDatabaseProductVersion());
            System.out.println("----");

        } catch (ClassNotFoundException e) {
            System.out.println("Cannot found class for SQL Server Driver");
            System.out.println(e.getMessage());
            Util.logError(String.format("Cannot found class for SQL Server Driver\n%s\n---", e.getMessage()));
        } catch (SQLException e) {
            System.out.println("Fail to connect to SQL server");
            System.out.println(e.getMessage());
            Util.logError(String.format("Fail to connect to SQL server\n%s\n---", e.getMessage()));
        }
    }

    public static void main(String[] args) {
        new DBContext();
    }
}
