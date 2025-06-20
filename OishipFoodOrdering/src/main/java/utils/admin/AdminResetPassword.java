package utils.admin;

import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
import utils.DBContext;

public class AdminResetPassword extends DBContext {

    public static void main(String[] args) {
        AdminResetPassword resetter = new AdminResetPassword();
        Connection conn = null;

        try {
            conn = resetter.getConnection(); // Use DBContext's connection
            System.out.println("✅ Connected to DB. Time: " + new java.util.Date());

            // Reset only admin account
            resetter.resetAdminPassword(conn, "oiship.team@gmail.com", "admin", "Admin User");

        } catch (SQLException e) {
            System.err.println("❌ Database operation failed: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    System.out.println("✅ Database connection closed. Time: " + new java.util.Date());
                } catch (SQLException e) {
                    System.err.println("❌ Error closing connection: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }
    }

    private void resetAdminPassword(Connection conn, String email, String plainPassword, String fullName) throws SQLException {
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
        System.out.println("🔒 [" + fullName + "] New Hash for '" + plainPassword + "': " + hashedPassword);

        String updateSql = "UPDATE [Account] SET [password] = ? WHERE LTRIM(RTRIM(email)) = ? COLLATE SQL_Latin1_General_CP1_CI_AS " +
                          "AND LTRIM(RTRIM(role)) = 'admin' COLLATE SQL_Latin1_General_CP1_CI_AS";
        
        try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
            stmt.setString(1, hashedPassword);
            stmt.setString(2, email.trim());
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                System.out.println("✅ Password reset for " + fullName + " (email: " + email + ") successful! Time: " + new java.util.Date());
            } else {
                System.out.println("❌ Admin account not found with email: " + email + " or not an admin. Time: " + new java.util.Date());
            }
        } catch (SQLException e) {
            System.err.println("❌ Error resetting password for " + email + ": " + e.getMessage());
            e.printStackTrace();
            throw e; // Re-throw to be caught by the caller
        }
    }
}