package dao;

import model.Customer; // Hoặc model.Staff nếu có bảng Staff riêng
import model.Account;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Order;
import model.Staff;

public class StaffDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(StaffDAO.class.getName());

    public StaffDAO() {
        super();
    }

    public Staff getStaffByEmail(String email) {
        LOGGER.info("Attempting to retrieve staff with email: " + email);
        if (email == null || email.trim().isEmpty()) {
            LOGGER.warning("Invalid email: " + email);
            return null;
        }
        String sql = "SELECT accountID AS staffID, fullName, email, [password], role, createAt "
                + "FROM Account WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Staff staff = new Staff(
                            rs.getInt("staffID"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getString("role"),
                            rs.getTimestamp("createAt")
                    );
                    LOGGER.info("Staff found: " + staff.toString());
                    return staff;
                } else {
                    LOGGER.warning("No staff found for email: " + email);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving staff by email: " + e.getMessage(), e);
        }
        return null;
    }

    public boolean editStaffNameByEmail(String email, String newName) {
        String sql = "UPDATE Account SET fullName = ? WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean changePasswordStaffByEmail(String email, String newPassword) {
        String sql = "UPDATE Account SET password = ? WHERE email = ?";
        String hashedPassword = SecurityDAO.hashPassword(newPassword);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    

    public static void main(String[] args) {

//        StaffDAO staffDAO = new StaffDAO();
//
//        String email = "staff@example.com";
//        String newName = "Han Nguyen";
//
//        boolean updated = staffDAO.editStaffNameByEmail(email, newName);
//        if (updated) {
//            System.out.println("Name updated successfully.");
//        } else {
//            System.out.println("Failed to update name.");
//        }
//
//        // Confirm change
//        Staff staff = staffDAO.getStaffByEmail(email);
//        if (staff != null) {
//            System.out.println("Updated Staff Info:");
//            System.out.println("Full Name: " + staff.getFullName());
//            System.out.println("Email: " + staff.getEmail());
//            System.out.println("Role: " + staff.getRole());
//            System.out.println("Created At: " + staff.getCreateAt());
//        } else {
//            System.out.println("No staff found for email: " + email);
//        }
        StaffDAO staffDAO = new StaffDAO();
        String email = "staff@example.com";
        String newPassword = "newpass123";

        boolean result = staffDAO.changePasswordStaffByEmail(email, newPassword);

        if (result) {
            System.out.println("Password updated successfully for email: " + email);
        } else {
            System.out.println("Failed to update password for email: " + email);
        }
    }

}
