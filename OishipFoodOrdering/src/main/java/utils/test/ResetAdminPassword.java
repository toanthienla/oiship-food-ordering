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
        String username = "sa"; // đổi theo SQL Server của em
        String password = "123456"; // đổi password

        try {
            // Kết nối Database
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(dbURL, username, password);
            System.out.println("✅ Connected to DB");

            // Băm lại mật khẩu admin
            String plainPassword = "admin"; // mật khẩu mới muốn đặt
            String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));

            System.out.println("🔒 New Hash: " + hashedPassword);

            // Update mật khẩu mới đã mã hóa
            String sql = "UPDATE Admin SET password = ? WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, hashedPassword);
            stmt.setString(2, "oiship.team@gmail.com"); // đổi email admin cần reset

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("✅ Reset password thành công!");
            } else {
                System.out.println("❌ Không tìm thấy admin này để reset!");
            }

            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
