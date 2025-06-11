package dao;

import model.Customer;
import utils.DBContext;
import java.sql.*;

public class CustomerDAO extends DBContext {

    public CustomerDAO() {
        super();
    }

    public Customer login(String email, String hashedPassword) {
        if (email == null || hashedPassword == null) {
            System.out.println("login: email or hashedPassword is null, email=" + email);
            return null;
        }
        String sql = "SELECT accountID AS customerID, fullName, email, [password], role, createAt, status, phone, address " +
                     "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID " +
                     "WHERE email = ? AND [password] = ? AND (status = 1 OR status IS NULL)"; // NULL cho Staff/Admin
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("customerID"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getString("role"),
                            rs.getTimestamp("createAt"),
                            rs.getInt("status") != 0 ? rs.getInt("status") : 1, // Default status 1 nếu NULL
                            rs.getString("phone") != null ? rs.getString("phone") : "",
                            rs.getString("address") != null ? rs.getString("address") : ""
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error during login for email: " + email + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Customer getCustomerByEmail(String email) {
        if (email == null) {
            System.out.println("getCustomerByEmail: email is null");
            return null;
        }
        String sql = "SELECT accountID AS customerID, fullName, email, [password], role, createAt, status, phone, address " +
                     "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID " +
                     "WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("customerID"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getString("role"),
                            rs.getTimestamp("createAt"),
                            rs.getInt("status") != 0 ? rs.getInt("status") : 1,
                            rs.getString("phone") != null ? rs.getString("phone") : "",
                            rs.getString("address") != null ? rs.getString("address") : ""
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving customer by email: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertCustomer(Customer customer) {
        if (customer == null || customer.getCustomerID() <= 0) {
            return false;
        }
        String sql = "INSERT INTO Customer (customerID, phone, address, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customer.getCustomerID());
            ps.setString(2, customer.getPhone());
            ps.setString(3, customer.getAddress());
            ps.setInt(4, customer.getStatus());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error inserting customer: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }// Các phương thức khác giữ nguyên (getCustomerById, isEmailOrPhoneExists, insertCustomer, updateCustomer, updatePasswordByEmail)
}