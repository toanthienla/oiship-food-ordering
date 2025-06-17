package dao;

import model.Customer;
import model.Account;
import model.Staff;
import utils.DBContext;
import java.sql.*;

public class AccountDAO extends DBContext {

    public AccountDAO() {
        super();
    }

    // Existing methods (login, getCustomerByEmail, insertAccount, updatePasswordByEmail, isEmailOrPhoneExists, updateStatus, findById) unchanged

    public Object login(String email, String plainPassword) {
        if (email == null || plainPassword == null) {
            System.out.println("login: email or plainPassword is null, email=" + email);
            return null;
        }
        String sql = "SELECT a.accountID, a.fullName, a.email, a.[password], a.status, a.role, a.createAt, " +
                     "c.phone, c.address " +
                     "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID " +
                     "WHERE a.email = ? AND a.status = 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    if (SecurityDAO.checkPassword(plainPassword, hashedPassword)) {
                        String role = rs.getString("role");
                        if ("customer".equals(role)) {
                            return new Customer(
                                    rs.getInt("accountID"),
                                    rs.getString("phone") != null ? rs.getString("phone") : "",
                                    rs.getString("address") != null ? rs.getString("address") : ""
                            );
                        } else if ("staff".equals(role)) {
                            return new Staff(
                                    rs.getInt("accountID"),
                                    rs.getString("fullName"),
                                    rs.getString("email"),
                                    hashedPassword,
                                    rs.getInt("status"),
                                    role,
                                    rs.getTimestamp("createAt")
                            );
                        } else if ("admin".equals(role)) {
                            return new Account(
                                    rs.getInt("accountID"),
                                    rs.getString("fullName"),
                                    rs.getString("email"),
                                    hashedPassword,
                                    rs.getInt("status"),
                                    role,
                                    rs.getTimestamp("createAt")
                            );
                        }
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
        String sql = "SELECT a.accountID AS customerID, c.phone, c.address " +
                     "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID " +
                     "WHERE a.email = ? AND a.role = 'customer'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("customerID"),
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

    public int insertAccount(Account account) {
        if (account == null || account.getFullName() == null || account.getEmail() == null
                || account.getPassword() == null || account.getRole() == null) {
            System.out.println("insertAccount: Account or required fields are null");
            return -1;
        }
        String sql = "INSERT INTO Account (fullName, email, [password], role, createAt, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, account.getFullName());
            ps.setString(2, account.getEmail());
            ps.setString(3, account.getPassword());
            ps.setString(4, account.getRole());
            ps.setTimestamp(5, account.getCreateAt() != null ? account.getCreateAt() : new Timestamp(System.currentTimeMillis()));
            ps.setInt(6, account.getStatus());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                System.out.println("insertAccount: No rows affected for email: " + account.getEmail());
                return -1;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error inserting account for email " + account.getEmail() + ": " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updatePasswordByEmail(String email, String role, String hashedPassword) {
        if (email == null || hashedPassword == null) {
            System.out.println("updatePasswordByEmail: email or hashedPassword is null, email=" + email + ", role=" + role);
            return false;
        }
        if (role != null && !role.equals("admin") && !role.equals("staff") && !role.equals("customer")) {
            System.out.println("updatePasswordByEmail: Invalid role, role=" + role);
            return false;
        }
        String sql = "UPDATE Account SET [password] = ? WHERE email = ?";
        if (role != null) {
            sql += " AND role = ?";
        }
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            if (role != null) {
                ps.setString(3, role);
            }
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating password for email: " + email + ", role: " + role + ": " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailOrPhoneExists(String email, String phone) {
        if (email == null && phone == null) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID " +
                     "WHERE a.email = ? OR c.phone = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email != null ? email : "");
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

    public boolean updateStatus(int accountID, int status) {
        if (accountID <= 0 || (status != 1 && status != 0 && status != -1)) {
            System.out.println("updateStatus: Invalid accountID or status, accountID=" + accountID + ", status=" + status);
            return false;
        }
        String sql = "UPDATE Account SET status = ? WHERE accountID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, accountID);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating status for accountID " + accountID + ": " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Account findById(int accountID) {
        if (accountID <= 0) {
            System.out.println("findById: Invalid accountID: " + accountID);
            return null;
        }
        String sql = "SELECT accountID, fullName, email, [password], status, role, createAt " +
                     "FROM Account WHERE accountID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getInt("accountID"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getInt("status"),
                            rs.getString("role"),
                            rs.getTimestamp("createAt")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving account by ID: " + accountID + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Account findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            System.out.println("findByEmail: email is null or empty");
            return null;
        }
        String sql = "SELECT accountID, fullName, email, [password], status, role, createAt " +
                     "FROM Account WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getInt("accountID"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getInt("status"),
                            rs.getString("role"),
                            rs.getTimestamp("createAt")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving account by email: " + email + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}