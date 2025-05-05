package dao;

import utils.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class VerificationDAO extends DBContext {
    public void saveVerificationCode(int userId, String plainCode, String hashedCode, String role) {
        String idColumn = getIdColumn(role);
        if (idColumn.isEmpty()) {
            return;
        }

        String sql = "INSERT INTO VerificationCode (" + idColumn
                + ", code, plain_code, created_at, expires_at, is_used) "
                + "VALUES (?, ?, ?, GETDATE(), DATEADD(MINUTE, 1, GETDATE()), 0)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, hashedCode);
            stmt.setString(3, plainCode);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean verifyCode(String role, int userId, String hashedCode) {
        String idColumn = getIdColumn(role);
        if (idColumn.isEmpty()) {
            return false;
        }

        String sql = "SELECT 1 FROM VerificationCode "
                + "WHERE " + idColumn + " = ? AND code = ? AND is_used = 0 AND expires_at > GETDATE()";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, hashedCode);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void markCodeAsUsed(String role, int userId, String hashedCode) {
        String idColumn = getIdColumn(role);
        if (idColumn.isEmpty()) {
            return;
        }

        String sql = "UPDATE VerificationCode SET is_used = 1 "
                + "WHERE " + idColumn + " = ? AND code = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, hashedCode);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private String getIdColumn(String role) {
        switch (role) {
            case "customer":
                return "customer_id";
            case "shipper":
                return "shipper_id";
            case "restaurant":
                return "restaurant_id";
            default:
                return "";
        }
    }

    public void saveVerificationCodeByEmail(String email, String hashedCode, String plainCode) {
        String sql = "INSERT INTO VerificationCode (customer_id, code, plain_code, created_at, expires_at, is_used) "
                + "SELECT customer_id, ?, ?, GETDATE(), DATEADD(MINUTE,1,GETDATE()), 0 FROM Customers WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, hashedCode);
            stmt.setString(2, plainCode);
            stmt.setString(3, email);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
