package dao;

import model.Customer; // Không cần nếu không sử dụng Customer trong StaffDAO
import model.Account;
import model.Staff;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

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
        String sql = "SELECT accountID AS staffID, fullName, email, [password], status, role, createAt "
                + "FROM Account WHERE email = ? AND role = 'staff'";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Staff staff = new Staff(
                            rs.getInt("staffID"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getInt("status"), // Thêm status
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
        if (email == null || email.trim().isEmpty() || newName == null || newName.trim().isEmpty()) {
            LOGGER.warning("Invalid email or newName: email=" + email + ", newName=" + newName);
            return false;
        }
        String sql = "UPDATE Account SET fullName = ? WHERE email = ? AND role = 'staff'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setString(2, email);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Staff name updated successfully for email: " + email);
                return true;
            } else {
                LOGGER.warning("No staff found or no update for email: " + email);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating staff name for email: " + e.getMessage(), e);
        }
        return false;
    }

    public boolean changePasswordStaffByEmail(String email, String newPassword) {
        if (email == null || email.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
            LOGGER.warning("Invalid email or newPassword: email=" + email + ", newPassword=" + newPassword);
            return false;
        }
        String sql = "UPDATE Account SET [password] = ? WHERE email = ? AND role = 'staff'";
        String hashedPassword = SecurityDAO.hashPassword(newPassword); // Giả định SecurityDAO có phương thức này
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Staff password updated successfully for email: " + email);
                return true;
            } else {
                LOGGER.warning("No staff found or no update for email: " + email);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating staff password for email: " + e.getMessage(), e);
        }
        return false;
    }

    public static void main(String[] args) {
        StaffDAO staffDAO = new StaffDAO();
        String email = "staff@example.com";
        String newPassword = "newpass123";

        boolean result = staffDAO.changePasswordStaffByEmail(email, newPassword);

        if (result) {
            System.out.println("Password updated successfully for email: " + email);
            Staff staff = staffDAO.getStaffByEmail(email);
            if (staff != null) {
                System.out.println("Updated Staff Info:");
                System.out.println("Full Name: " + staff.getFullName());
                System.out.println("Email: " + staff.getEmail());
                System.out.println("Role: " + staff.getRole());
                System.out.println("Created At: " + staff.getCreateAt());
                System.out.println("Status: " + staff.getStatus());
            }
        } else {
            System.out.println("Failed to update password for email: " + email);
        }
    }

}
