package utils.admin;

import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
import utils.Util;

public class AdminTestPassword {

    public static void main(String[] args) {
        String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=Oiship;encrypt=false";
        String username = "sa";  // Replace with your SQL Server username
        String password = "123456";  // Replace with your SQL Server password

        Connection conn = null;

        try {
            // Load JDBC driver and connect to database
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(dbURL, username, password);
            System.out.println("✅ Database Connected! Time: " + new java.util.Date());

            // Test admin account password
            //testAccountPassword(conn, "oiship.team@gmail.com", "admin", "Admin");
            testAccountPassword(conn, "staff@example.com", "123", "Staff");

        } catch (ClassNotFoundException e) {
            Util.logError("Failed to load SQL Server JDBC driver: " + e.getMessage());
        } catch (SQLException e) {
            Util.logError("Database connection failed: " + e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    System.out.println("✅ Database connection closed. Time: " + new java.util.Date());
                } catch (SQLException e) {
                    Util.logError("Failed to close database connection: " + e.getMessage());
                }
            }
        }
    }

    private static void testAccountPassword(Connection conn, String email, String plainPassword, String accountType) {
        String sql = "SELECT [password] FROM accounts WHERE LTRIM(RTRIM(email)) = ? COLLATE SQL_Latin1_General_CP1_CI_AS " +
                     "AND LTRIM(RTRIM(role)) = 'admin' COLLATE SQL_Latin1_General_CP1_CI_AS";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            stmt.setString(1, email.trim());
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                System.out.println("📦 [" + accountType + "] Password Hash in DB: " + hashedPassword);

                // Check if the plain password matches the stored hash
                boolean matched = BCrypt.checkpw(plainPassword, hashedPassword);
                System.out.println("🔍 [" + accountType + "] Test password '" + plainPassword + "' for email " + email + ": " +
                        (matched ? "✅ MATCHED!" : "❌ NOT MATCHED!") + " Time: " + new java.util.Date());
            } else {
                System.out.println("❌ [" + accountType + "] Account not found with email: " + email + " or not an admin");
            }
        } catch (SQLException e) {
            Util.logError(String.format("Test password for %s failed: %s", email, e.getMessage()));
            System.out.println("❗ [" + accountType + "] Error testing password for email " + email + ": " + e.getMessage());
        }
    }
}