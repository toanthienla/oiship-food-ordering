package dao;

import model.Customer;
import utils.DBContext;
import java.sql.*;

public class AccountDAO extends DBContext {

    public AccountDAO() {
        super();
    }

    public Customer login(String email, String plainPassword) {
        if (email == null || plainPassword == null) {
            System.out.println("login: email or plainPassword is null, email=" + email);
            return null;
        }
        String sql = "SELECT accountID AS customerID, fullName, a.email, [password], role, createAt, c.status, c.phone, c.address " +
                     "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID " +
                     "WHERE a.email = ? AND (c.status = 1 OR c.status IS NULL)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    if (SecurityDAO.checkPassword(plainPassword, hashedPassword)) {
                        return new Customer(
                                rs.getInt("customerID"),
                                rs.getString("fullName"),
                                rs.getString("email"),
                                hashedPassword,
                                rs.getString("role"),
                                rs.getTimestamp("createAt"),
                                rs.getInt("status") != 0 ? rs.getInt("status") : 1,
                                rs.getString("phone") != null ? rs.getString("phone") : "",
                                rs.getString("address") != null ? rs.getString("address") : ""
                        );
                    }
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
        String sql = "SELECT accountID AS customerID, fullName, a.email, [password], role, createAt, c.status, c.phone, c.address " +
                     "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID " +
                     "WHERE a.email = ?";
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
            System.out.println("Error retrieving account by email: " + email + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public int insertAccount(Customer customer) {
        if (customer == null) {
            return -1;
        }
        String sql = "INSERT INTO Account (fullName, email, [password], role, createAt) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPassword());
            ps.setString(4, customer.getRole());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error inserting account: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updatePasswordByEmail(String email, String role, String hashedPassword) {
        if (email == null || hashedPassword == null) {
            System.out.println("updatePasswordByEmail: email or hashedPassword is null, email=" + email + ", role=" + role);
            return false;
        }
        String sql = "UPDATE Account SET [password] = ? WHERE email = ?";
        if (role != null) {
            sql += " AND role = ?";
        }
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            if (role != null) {
                ps.setString(3, role);
            }
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating password for email: " + email + ", role: " + role);
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailOrPhoneExists(String email, String phone) {
        if (email == null && phone == null) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID WHERE a.email = ? OR c.phone = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, phone != null ? phone : "");
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking email or phone existence: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}