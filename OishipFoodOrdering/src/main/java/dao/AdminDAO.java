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
        String sql = "SELECT accountID, fullName, email, phone, [password], [address], [status], createAt "
                + "FROM [Account] WHERE email = ? AND [role] = 'admin'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("accountID"));
                    admin.setFullName(rs.getString("fullName"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPhone(rs.getString("phone"));
                    admin.setPassword(rs.getString("password"));
                    admin.setAddress(rs.getString("address"));
                    admin.setStatus(rs.getInt("status"));
                    admin.setCreatedAt(rs.getTimestamp("createAt"));
                    System.out.println("AdminDAO: Found admin for email=" + email + ", adminId=" + admin.getAdminId() + ", status=" + admin.getStatus() + ", fullName=" + admin.getFullName());
                    return admin;
                }
                System.out.println("AdminDAO: No admin found for email=" + email);
            }
        } catch (SQLException e) {
            System.out.println("AdminDAO: Error retrieving admin for email=" + email);
            e.printStackTrace();
        }
        return null;
    }
}
