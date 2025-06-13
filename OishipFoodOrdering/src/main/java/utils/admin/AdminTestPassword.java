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
            // Connect to Database
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(dbURL, username, password);
            System.out.println("✅ Database Connected!");

            // Test admin account password
            testAccountPassword(conn, "oiship.team@gmail.com", "admin", "Admin");

        } catch (Exception e) {
            Util.logError(String.format("Test password failed\n%s\n---", e.getMessage()));
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    System.out.println("✅ Database connection closed.");
                } catch (SQLException e) {
                    Util.logError(String.format("Failed to close database connection\n%s\n---", e.getMessage()));
                }
            }
        }
    }

    private static void testAccountPassword(Connection conn, String email, String plainPassword, String accountType) {
        try {
            // Read password from Account table
            String sql = "SELECT [password] FROM Account WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                System.out.println("📦 [" + accountType + "] Password Hash in DB: " + hashedPassword);

                // Check if the plain password matches the stored hash
                boolean matched = BCrypt.checkpw(plainPassword, hashedPassword);
                System.out.println("🔍 [" + accountType + "] Test password '" + plainPassword + "': "
                        + (matched ? "✅ MATCHED!" : "❌ NOT MATCHED!"));
            } else {
                System.out.println("❌ [" + accountType + "] Account not found with email: " + email);
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            Util.logError(String.format("Test password for %s failed\n%s\n---", email, e.getMessage()));
        }
    }
}
