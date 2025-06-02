package dao;

import model.OTP;
import utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;

public class OTPDAO extends DBContext {

    public OTPDAO() {
        super();
    }

    public void insertOtpTemp(String email, String hashedOTP, LocalDateTime createdAt, LocalDateTime expiresAt) {
        String sql = "INSERT INTO OTP (otp, otpCreatedAt, otpExpiresAt, isUsed, email) VALUES (?, ?, ?, 0, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, hashedOTP);
            ps.setObject(2, createdAt);
            ps.setObject(3, expiresAt);
            ps.setString(4, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public OTP getLatestOtpByEmail(String email) {
        if (email == null) {
            return null;
        }
        String sql = "SELECT * FROM OTP WHERE email = ? AND isUsed = 0 ORDER BY otpCreatedAt DESC";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                OTP otp = new OTP();
                otp.setOtpId(rs.getInt("otpID"));
                otp.setOtp(rs.getString("otp"));
                otp.setOtpCreatedAt(rs.getObject("otpCreatedAt", LocalDateTime.class));
                otp.setOtpExpiresAt(rs.getObject("otpExpiresAt", LocalDateTime.class));
                otp.setIsUsed(rs.getInt("isUsed"));
                otp.setEmail(rs.getString("email"));
                otp.setAccountId(rs.getInt("FK_OTP_Account"));
                return otp;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void markOtpAsUsed(String email) {
        String sql = "UPDATE OTP SET isUsed = 1 WHERE email = ? AND isUsed = 0";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isOtpExpired(LocalDateTime expiresAt) {
        return expiresAt != null && LocalDateTime.now().isAfter(expiresAt);
    }
}
