package dao;

import model.Account;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;

public class AccountDAO extends DBContext {

    public AccountDAO() {
        super(); // Gọi constructor của DBContext để khởi tạo kết nối
    }

    public void closeConnection() {
        try {
            Connection conn = getConnection();
            if (conn != null && !conn.isClosed()) {
                conn.close();
                // Optionally log the closure
                System.out.println("Database connection closed successfully.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Optionally log the error
            System.err.println("Error closing database connection: " + e.getMessage());
        }
    }

    public boolean isEmailOrPhoneExists(String email, String phone) {
        if (email == null || phone == null) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Account WHERE email = ? OR phone = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, phone);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Account getAccountByEmailAndRole(String email, String role) {
        if (email == null || role == null) {
            return null;
        }
        String sql = "SELECT * FROM Account WHERE email = ? AND role = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Account(
                        rs.getInt("accountID"),
                        rs.getString("fullName"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("password"),
                        rs.getString("address"),
                        rs.getInt("status"),
                        rs.getString("role"),
                        rs.getTimestamp("createAt")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Account getAccountById(int accountId) {
        String sql = "SELECT accountID, fullName, email, phone, [password], [address], [status], [role], createAt FROM [Account] WHERE accountID = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account account = new Account();
                    account.setAccountID(rs.getInt("accountID"));
                    account.setFullName(rs.getString("fullName")); // Changed to setFullName
                    account.setEmail(rs.getString("email"));
                    account.setPhone(rs.getString("phone"));
                    account.setPassword(rs.getString("password"));
                    account.setAddress(rs.getString("address"));
                    account.setStatus(rs.getInt("status")); // Now int
                    account.setRole(rs.getString("role"));
                    account.setCreateAt(rs.getTimestamp("createAt"));
                    System.out.println("Found account for accountId: " + accountId + ", role: " + account.getRole() + ", fullName: " + account.getFullName());
                    return account;
                }
                System.out.println("No account found for accountId: " + accountId);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving account for accountId: " + accountId);
            e.printStackTrace();
        }
        return null;
    }

    public int insertAccountAndReturnId(Account account) {
        if (account == null) {
            return -1;
        }
        String sql = "INSERT INTO Account (fullName, email, password, phone, address, status, role, createAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, account.getFullName());
            ps.setString(2, account.getEmail());
            ps.setString(3, account.getPassword());
            ps.setString(4, account.getPhone());
            ps.setString(5, account.getAddress());
            ps.setInt(6, account.getStatus());
            ps.setString(7, account.getRole());
            ps.setTimestamp(8, account.getCreateAt() != null ? account.getCreateAt() : new Timestamp(System.currentTimeMillis()));

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public boolean updateAccount(Account account) {
        if (account == null) {
            return false;
        }
        String sql = "UPDATE Account SET fullName = ?, password = ?, phone = ?, address = ?, status = ?, role = ? WHERE accountID = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, account.getFullName());
            ps.setString(2, account.getPassword());
            ps.setString(3, account.getPhone());
            ps.setString(4, account.getAddress());
            ps.setInt(5, account.getStatus());
            ps.setString(6, account.getRole());
            ps.setInt(7, account.getAccountID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void updateStatus(int accountId, int status) {
        String sql = "UPDATE Account SET status = ? WHERE accountID = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, accountId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateOtpAccountId(String email, int accountId) {
        String sql = "UPDATE OTP SET FK_OTP_Account = ? WHERE email = ? AND isUsed = 0";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Account getAccountByEmail(String email) {
        if (email == null) {
            System.out.println("getAccountByEmail: email is null");
            return null;
        }
        String sql = "SELECT * FROM Account WHERE email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Account account = new Account();
                account.setAccountID(rs.getInt("accountID"));
                account.setFullName(rs.getString("fullName"));
                account.setEmail(rs.getString("email"));
                account.setPhone(rs.getString("phone"));
                account.setPassword(rs.getString("password"));
                account.setAddress(rs.getString("address"));
                account.setStatus(rs.getInt("status"));
                account.setRole(rs.getString("role"));
                account.setCreateAt(rs.getTimestamp("createAt"));
                System.out.println("Found account for email: " + email + ", role: " + account.getRole());
                return account;
            }
            System.out.println("No account found for email: " + email);
        } catch (SQLException e) {
            System.out.println("Error retrieving account: " + email);
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePasswordByEmail(String email, String role, String hashedPassword) {
        if (email == null || hashedPassword == null) {
            System.out.println("updatePasswordByEmail: email=" + email + ", role=" + role + ", hashedPassword=" + (hashedPassword != null));
            return false;
        }
        // Try updating without role first
        String sql = "UPDATE Account SET password = ? WHERE email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("Updated password for email: " + email + ", rows: " + rows);
                return true;
            }
            System.out.println("No rows updated for email: " + email + " without role condition");
        } catch (SQLException e) {
            System.out.println("Error updating password for email: " + email);
            e.printStackTrace();
        }

        // Fallback with role if needed
        if (role != null) {
            sql = "UPDATE Account SET password = ? WHERE email = ? AND LOWER(role) = LOWER(?)";
            try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
                ps.setString(1, hashedPassword);
                ps.setString(2, email);
                ps.setString(3, role);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    System.out.println("Updated password for email: " + email + ", role: " + role);
                    return true;
                }
                System.out.println("No rows updated for email: " + email + ", role: " + role);
            } catch (SQLException e) {
                System.out.println("Error updating password for email: " + email + ", role: " + role);
                e.printStackTrace();
            }
        }
        return false;
    }

}
