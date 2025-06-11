package utils;

import io.github.cdimascio.dotenv.Dotenv;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    // Connection object
    protected Connection conn = null;

    public Connection getConnection() {
        try {
            // Kiểm tra nếu kết nối đã bị đóng hoặc null
            if (conn == null || conn.isClosed()) {
                reconnect();
            }
        } catch (SQLException e) {
            System.out.println("Error checking connection status: " + e.getMessage());
            Util.logError("Error checking connection status: " + e.getMessage());
            reconnect(); // Thử tái tạo kết nối
        }
        return conn;
    }

    /**
     * Constructor method that tries to connect to the database. All information
     * about the connection (database name, username, password) are imported
     * through .env file
     */
    public DBContext() {
        reconnect();
    }

    private void reconnect() {
        try {
            // Load config from .env
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

            // Log data for checking
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

    // Phương thức đóng kết nối (chỉ gọi khi cần, không tự động)
    public void closeConnection() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                System.out.println("Database connection closed successfully.");
            }
        } catch (SQLException e) {
            System.out.println("Error closing connection: " + e.getMessage());
            Util.logError("Error closing connection: " + e.getMessage());
        }
    }
}
