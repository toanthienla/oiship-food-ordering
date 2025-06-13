package dao;

import model.Admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DBContext;

public class AdminDAO extends DBContext {

    public AdminDAO() {
        super(); // Gọi constructor của DBContext để khởi tạo kết nối
    }

    public Admin getAdminByEmail(String email) {
        String sql = "SELECT accountID, fullName, email, [password], role, createAt " +
                     "FROM [Account] WHERE email = ? AND role = 'admin'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (email == null || email.trim().isEmpty()) {
                System.out.println("AdminDAO: Invalid email parameter: " + email);
                return null;
            }
            ps.setString(1, email.trim());
            System.out.println("AdminDAO: Executing query: " + sql + " with email: " + email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("accountID"));
                    admin.setFullName(rs.getString("fullName"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPassword(rs.getString("password"));
                    admin.setRole(rs.getString("role")); // Thêm role để xác nhận
                    admin.setCreatedAt(rs.getTimestamp("createAt"));
                    System.out.println("AdminDAO: Found admin for email=" + email + ", adminId=" + admin.getAdminId() + ", fullName=" + admin.getFullName());
                    return admin;
                }
                System.out.println("AdminDAO: No admin found for email=" + email + ". Query executed: " + sql);
            }
        } catch (SQLException e) {
            System.out.println("AdminDAO: Error retrieving admin for email=" + email + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}