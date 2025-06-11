/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils.test;

import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

public class ResetAdminPassword {

    public static void main(String[] args) {
        String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=Oiship;encrypt=false";
        String username = "sa"; // Thay bằng username SQL Server của bạn
        String password = "123456"; // Thay bằng password SQL Server của bạn

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Kết nối Database
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(dbURL, username, password);
            System.out.println("✅ Connected to DB");

            // Reset admin
            resetAccount(conn, "oiship.team@gmail.com", "admin", "Admin", "admin", "0000000000");
            // Reset inventory staff
            resetAccount(conn, "ingredient@oiship.com", "ingredientstaff", "Staff Ingredient", "staff", "0000000001");
            // Reset seller staff
            resetAccount(conn, "seller@oiship.com", "sellerstaff", "Staff Seller", "staff", "0000000002");
            
            resetAccount(conn, "customer@satff.com", "customer", "Customer", "customer", "0000000003");

        } catch (Exception e) {
            System.err.println("❌ Lỗi: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                    System.out.println("✅ Database connection closed.");
                }
            } catch (SQLException e) {
                System.err.println("❌ Lỗi khi đóng kết nối: " + e.getMessage());
            }
        }
    }

    private static void resetAccount(Connection conn, String email, String plainPassword, String fullName, String role, String phone) throws SQLException {
        // Băm mật khẩu
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
        System.out.println("🔒 [" + fullName + "] New Hash for '" + plainPassword + "': " + hashedPassword);

        // Thử update mật khẩu
        String updateSql = "UPDATE Account SET password = ? WHERE email = ?";
        PreparedStatement stmt = conn.prepareStatement(updateSql);
        stmt.setString(1, hashedPassword);
        stmt.setString(2, email);
        int rowsUpdated = stmt.executeUpdate();

        if (rowsUpdated > 0) {
            System.out.println("✅ Cập nhật mật khẩu cho " + fullName + " thành công!");
            System.out.println("_____________________________________________________");
        } else {
            System.out.println("❌ Không tìm thấy tài khoản " + fullName + " với email: " + email + ". Tiến hành insert...");
            System.out.println("___________________________________________________________________________________________");

            // Insert tài khoản mới
            String insertSql = "INSERT INTO Account (fullName, email, phone, [password], [address], [status], [role], createAt) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertSql);
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, hashedPassword);
            stmt.setString(5, null);
            stmt.setInt(6, 1);
            stmt.setString(7, role);
            stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("✅ Insert tài khoản " + fullName + " thành công!");
                System.out.println("_____________________________________________________");
            } else {
                System.out.println("❌ Insert tài khoản " + fullName + " thất bại!");
                System.out.println("_____________________________________________________");
            }
        }
        stmt.close();
    }
}
