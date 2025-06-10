package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import org.mindrot.jbcrypt.BCrypt;

public class SecurityDAO {

    // Số vòng băm BCrypt, càng cao thì càng bảo mật nhưng chậm hơn
    private static final int SALT_ROUNDS = 12;

    // Mã hóa mật khẩu
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(SALT_ROUNDS));
    }

    // Kiểm tra mật khẩu nhập vào có khớp với mật khẩu đã mã hóa không
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }

    public static String hashOTP(String plainOTP) {
        if (plainOTP == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(plainOTP.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            System.out.println("Error hashing OTP: " + e.getMessage());
            return null;
        }
    }

    public static boolean checkOTP(String plainOTP, String hashedOTP) {
        if (plainOTP == null || hashedOTP == null) {
            return false;
        }
        String hashedInput = hashOTP(plainOTP.trim());
        System.out.println("Checking OTP - Plain: " + plainOTP + ", Hashed Input: " + hashedInput + ", Stored Hash: " + hashedOTP);
        return hashedInput != null && hashedInput.equals(hashedOTP);
    }



}
