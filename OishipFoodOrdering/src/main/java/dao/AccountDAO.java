package dao;

import java.sql.Connection;
import model.Account;
import utils.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO extends DBContext {

    public Account getAccountByEmail(String email) {
        String sql = "SELECT * FROM Account WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractAccount(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Account getAccountById(int id) {
        String sql = "SELECT * FROM Account WHERE account_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractAccount(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Account> getAllAccounts() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM Account";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractAccount(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int insertAccountAndReturnId(Account a) {
        String sql = "INSERT INTO Account (account_name, email, phone, password, status, cccd, license, license_image, number_plate, address, longitude, latitude, account_created_at, role) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, a.getAccountName());
            stmt.setString(2, a.getEmail());
            stmt.setString(3, a.getPhone());
            stmt.setString(4, a.getPassword());
            stmt.setString(5, a.getStatus());

            // Nullable fields (depending on role)
            if (a.getCccd() != null && !a.getCccd().isEmpty()) {
                stmt.setString(6, a.getCccd());
            } else {
                stmt.setNull(6, java.sql.Types.NVARCHAR);
            }

            if (a.getLicense() != null && !a.getLicense().isEmpty()) {
                stmt.setString(7, a.getLicense());
            } else {
                stmt.setNull(7, java.sql.Types.NVARCHAR);
            }

            if (a.getLicenseImage() != null) {
                stmt.setBytes(8, a.getLicenseImage());
            } else {
                stmt.setNull(8, java.sql.Types.VARBINARY);
            }

            if (a.getNumberPlate() != null && !a.getNumberPlate().isEmpty()) {
                stmt.setString(9, a.getNumberPlate());
            } else {
                stmt.setNull(9, java.sql.Types.NVARCHAR);
            }

            stmt.setString(10, a.getAddress());

            if (a.getLongitude() != null) {
                stmt.setBigDecimal(11, a.getLongitude());
            } else {
                stmt.setNull(11, java.sql.Types.DECIMAL);
            }

            if (a.getLatitude() != null) {
                stmt.setBigDecimal(12, a.getLatitude());
            } else {
                stmt.setNull(12, java.sql.Types.DECIMAL);
            }

            stmt.setTimestamp(13, a.getAccountCreatedAt());
            stmt.setString(14, a.getRole());

            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public Account getAccountByEmailAndRole(String email, String role) {
        String sql = "SELECT * FROM Account WHERE email = ? AND role = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, role);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractAccount(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isEmailOrPhoneExists(String email, String phone) {
        String sql = "SELECT 1 FROM Account WHERE email = ? OR phone = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, phone);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void updateStatus(int accountId, String newStatus) {
        String sql = "UPDATE Account SET status = ? WHERE account_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, accountId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Account> getAccountsByRole(String role) {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM Account WHERE role = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractAccount(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updatePasswordByEmail(String email, String role, String newPassword) {
        String sql = "UPDATE Account SET password = ? WHERE email = ? AND role = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            stmt.setString(3, role);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Account extractAccount(ResultSet rs) throws Exception {
        return new Account(
                rs.getInt("account_id"),
                rs.getString("account_name"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getString("password"),
                rs.getString("status"),
                rs.getString("cccd"),
                rs.getString("license"),
                rs.getBytes("license_image"),
                rs.getString("number_plate"),
                rs.getString("address"),
                rs.getBigDecimal("longitude"),
                rs.getBigDecimal("latitude"),
                rs.getTimestamp("account_created_at"),
                rs.getString("role")
        );
    }

    private Connection getConnection() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    // Unused legacy methods - optional cleanup
    public void insertAccount(Account a) {
    }

    public void updateAccount(Account a) {
    }

    public void deleteAccountById(int id) {
    }

    public List<Account> getAccountsByRoleAndStatus(String role, String status) {
        return new ArrayList<>();
    }
}
