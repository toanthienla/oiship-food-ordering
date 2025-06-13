package utils.admin;

import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

public class AdminResetPassword {

    public static void main(String[] args) {
        String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=Oiship;encrypt=false";
        String username = "sa"; // Replace with your SQL Server username
        String password = "123456"; // Replace with your SQL Server password

        Connection conn = null;

        try {
            // Connect to DB
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(dbURL, username, password);
            System.out.println("✅ Connected to DB");

            // Reset only admin account
            resetAccount(conn, "oiship.team@gmail.com", "admin", "Admin", "admin");

        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                    System.out.println("✅ Database connection closed.");
                }
            } catch (SQLException e) {
                System.err.println("❌ Error closing connection: " + e.getMessage());
            }
        }
    }

    private static void resetAccount(Connection conn, String email, String plainPassword, String fullName, String role) throws SQLException {
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
        System.out.println("🔒 [" + fullName + "] New Hash for '" + plainPassword + "': " + hashedPassword);

        String updateSql = "UPDATE Account SET password = ? WHERE email = ?";
        PreparedStatement stmt = conn.prepareStatement(updateSql);
        stmt.setString(1, hashedPassword);
        stmt.setString(2, email);
        int rowsUpdated = stmt.executeUpdate();

        if (rowsUpdated > 0) {
            System.out.println("✅ Password reset for " + fullName + " successful!");
        } else {
            System.out.println("❌ Admin account not found with email: " + email);
        }
        stmt.close();
    }
}
