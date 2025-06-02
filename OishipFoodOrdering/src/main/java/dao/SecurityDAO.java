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



    // Kiểm tra OTP người dùng nhập có khớp mã đã mã hóa không
   public static boolean checkOTP(String inputOTP, String hashedOTPInDB) {
    return hashOTP(inputOTP).equals(hashedOTPInDB);
}

    
    public static String hashOTP(String otp) {
    try {
        MessageDigest md = MessageDigest.getInstance("MD5");
        byte[] hashBytes = md.digest(otp.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    } catch (NoSuchAlgorithmException e) {
        throw new RuntimeException("MD5 algorithm not found");
    }
}

}
