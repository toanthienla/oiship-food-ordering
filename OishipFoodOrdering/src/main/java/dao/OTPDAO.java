package dao;

import model.OTP;
import utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;

public class OTPDAO extends DBContext {

    public OTPDAO() {
        super();
    }

    public void insertOtpTemp(String email, String hashedOTP, Timestamp createdAt, Timestamp expiresAt, Integer customerId) {
        String sql = "INSERT INTO OTP (otp, otpCreatedAt, otpExpiresAt, isUsed, email, FK_OTP_Customer) VALUES (?, ?, ?, 0, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedOTP);
            ps.setTimestamp(2, createdAt);
            ps.setTimestamp(3, expiresAt);
            ps.setString(4, email);
            ps.setObject(5, customerId, java.sql.Types.INTEGER); // Cho phép null nếu customerId là null
            ps.executeUpdate();
            System.out.println("Inserted OTP for email: " + email + ", customerId: " + (customerId != null ? customerId : "null"));
        } catch (SQLException e) {
            System.out.println("Error inserting OTP for email: " + email + ", customerId: " + (customerId != null ? customerId : "null") + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    public OTP getLatestOtpByEmail(String email) {
        if (email == null) {
            System.out.println("getLatestOtpByEmail: email is null");
            return null;
        }
        String sql = "SELECT TOP 1 * FROM OTP WHERE email = ? AND isUsed = 0 ORDER BY otpCreatedAt DESC"; // Sửa LIMIT 1 thành TOP 1 cho SQL Server
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OTP otp = new OTP();
                    otp.setOtpId(rs.getInt("otpID"));
                    otp.setOtp(rs.getString("otp"));
                    otp.setOtpCreatedAt(rs.getTimestamp("otpCreatedAt").toLocalDateTime());
                    otp.setOtpExpiresAt(rs.getTimestamp("otpExpiresAt").toLocalDateTime());
                    otp.setIsUsed(rs.getInt("isUsed"));
                    otp.setEmail(rs.getString("email"));
                    otp.setCustomerId(rs.getInt("FK_OTP_Customer"));
                    System.out.println("Found OTP for email: " + email + ", OTP: " + otp.getOtp()); // Debug log
                    return otp;
                } else {
                    System.out.println("No OTP found for email: " + email); // Debug log
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving latest OTP for email: " + email + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public void markOtpAsUsed(String email) {
        String sql = "UPDATE OTP SET isUsed = 1 WHERE email = ? AND isUsed = 0"; 
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Marked OTP as used for email: " + email); // Debug log
            } else {
                System.out.println("No OTP found to mark as used for email: " + email); // Debug log
            }
        } catch (SQLException e) {
            System.out.println("Error marking OTP as used for email: " + email + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean isOtpExpired(LocalDateTime expiresAt) {
        if (expiresAt == null) {
            System.out.println("isOtpExpired: expiresAt is null");
            return true;
        }
        return LocalDateTime.now().isAfter(expiresAt);
    }
    
    public boolean updateOtpCustomerId(String email, int customerId) {
        String sql = "UPDATE otp SET customer_id = ?, is_used = 1 WHERE email = ? AND is_used = 0 AND otp_expires_at > ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, customerId);
            pstmt.setString(2, email);
            pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error updating OTP customerId: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
