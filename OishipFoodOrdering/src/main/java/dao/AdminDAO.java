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
        String sql = "SELECT accountID, fullName, email, password, createAt " // Removed brackets from password
                + "FROM Account " // Changed to lowercase 'accounts'
                + "WHERE LTRIM(RTRIM(email)) = ? COLLATE SQL_Latin1_General_CP1_CI_AS "
                + "AND LTRIM(RTRIM(role)) = 'admin' COLLATE SQL_Latin1_General_CP1_CI_AS";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("accountID"));
                    admin.setFullName(rs.getString("fullName"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPassword(rs.getString("password"));
                    admin.setCreatedAt(rs.getTimestamp("createAt"));

                    System.out.println("✅ AdminDAO: Found admin: " + admin.getEmail());
                    return admin;
                } else {
                    System.out.println("❌ AdminDAO: No admin found for email=" + email);
                }
            }
        } catch (SQLException e) {
            System.out.println("❗ AdminDAO: Error retrieving admin for email=" + email + ": " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
}
