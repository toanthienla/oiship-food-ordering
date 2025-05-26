package dao;

import model.OTP;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OTPDAO extends DBContext {

    public void insertOTP(OTP otp) {
        String sql = "INSERT INTO OTP (code, plain_code, created_at, expires_at, is_used, account_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, otp.getCode());
            stmt.setString(2, otp.getPlainCode());
            stmt.setTimestamp(3, Timestamp.valueOf(otp.getCreatedAt()));
            stmt.setTimestamp(4, Timestamp.valueOf(otp.getExpiresAt()));
            stmt.setBoolean(5, otp.isUsed());
            stmt.setInt(6, otp.getAccountId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public OTP getValidOTP(int accountId, String hashedCode) {
        String sql = "SELECT * FROM OTP WHERE account_id = ? AND code = ? AND is_used = 0 AND expires_at > GETDATE()";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountId);
            stmt.setString(2, hashedCode);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new OTP(
                        rs.getInt("verification_id"),
                        rs.getString("code"),
                        rs.getString("plain_code"),
                        rs.getTimestamp("created_at").toLocalDateTime(),
                        rs.getTimestamp("expires_at").toLocalDateTime(),
                        rs.getBoolean("is_used"),
                        rs.getInt("account_id")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void markOtpAsUsed(int verificationId) {
        String sql = "UPDATE OTP SET is_used = 1 WHERE verification_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, verificationId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteExpiredOTPs() {
        String sql = "DELETE FROM OTP WHERE expires_at < GETDATE() OR is_used = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<OTP> getAllOTPs() {
        List<OTP> list = new ArrayList<>();
        String sql = "SELECT * FROM OTP";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new OTP(
                        rs.getInt("verification_id"),
                        rs.getString("code"),
                        rs.getString("plain_code"),
                        rs.getTimestamp("created_at").toLocalDateTime(),
                        rs.getTimestamp("expires_at").toLocalDateTime(),
                        rs.getBoolean("is_used"),
                        rs.getInt("account_id")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
