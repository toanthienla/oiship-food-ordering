package utils;

import dao.OTPDAO;
import dao.SecurityDAO;
import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Properties;
import java.util.Random;
import java.util.stream.Collectors;

import io.github.cdimascio.dotenv.Dotenv;
import model.OTP;

public class EmailService {

    private static final Dotenv dotenv = Dotenv.configure()
            .filename(".env")
            .load();

    private static final String EMAIL_HOST = dotenv.get("EMAIL_HOST");
    private static final int EMAIL_PORT = Integer.parseInt(dotenv.get("EMAIL_PORT"));
    private static final String EMAIL_NAME = dotenv.get("EMAIL_NAME");
    private static final String EMAIL_APP_PASSWORD = dotenv.get("EMAIL_APP_PASSWORD");

    private static final Properties PROPERTIES = new Properties();

    static {
        PROPERTIES.put("mail.smtp.auth", "true");
        PROPERTIES.put("mail.smtp.starttls.enable", "true");
        PROPERTIES.put("mail.smtp.host", EMAIL_HOST);
        PROPERTIES.put("mail.smtp.port", String.valueOf(EMAIL_PORT));
    }

    /**
     * Tạo và gửi OTP cho email trong quá trình đăng ký
     *
     * @param email Email người nhận
     * @param fullName Tên người nhận
     * @return mảng [plainOTP, hashedOTP]
     * @throws MessagingException Nếu gửi email thất bại
     */
    public static String[] generateAndSendVerificationByEmail(String email, String fullName) throws MessagingException {
        if (email == null || fullName == null) {
            throw new IllegalArgumentException("Email and fullName must not be null");
        }

        String otp = String.format("%06d", new Random().nextInt(999999));
        String hashedOTP = SecurityDAO.hashOTP(otp);

        LocalDateTime createdAt = LocalDateTime.now();
        LocalDateTime expiresAt = createdAt.plusMinutes(5); // Hết hiệu lực sau 5 phút

        // Lưu OTP vào database với customerId = null cho đăng ký mới
        OTPDAO otpDAO = new OTPDAO();
        otpDAO.insertOtpTemp(email, hashedOTP, Timestamp.valueOf(createdAt), Timestamp.valueOf(expiresAt), null);

        String subject = "Welcome to Oiship - Verify Your Account";
        sendVerificationEmail(email, fullName, otp);

        return new String[]{otp, hashedOTP};
    }

    public static void sendEmail(List<String> recipients, String subject, String htmlContent)
            throws MessagingException {
        Session session = Session.getInstance(PROPERTIES, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_NAME, EMAIL_APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(EMAIL_NAME));

        Address[] toAddresses = recipients.stream()
                .map(email -> {
                    try {
                        return new InternetAddress(email);
                    } catch (AddressException e) {
                        throw new RuntimeException("Invalid email address: " + email, e);
                    }
                }).toArray(Address[]::new);

        message.setRecipients(Message.RecipientType.TO, toAddresses);
        message.setSubject(subject);

        MimeBodyPart mimeBodyPart = new MimeBodyPart();
        mimeBodyPart.setContent(htmlContent, "text/html; charset=UTF-8");

        Multipart multipart = new MimeMultipart();
        multipart.addBodyPart(mimeBodyPart);

        message.setContent(multipart);
        Transport.send(message);
    }

    public static String loadTemplate(String path) {
        String realPath = new java.io.File("src/main/webapp/" + path).getAbsolutePath();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(new java.io.FileInputStream(realPath), "UTF-8"))) {
            return reader.lines().collect(Collectors.joining("\n"));
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

  public static void sendVerificationEmail(String to, String name, String code) {
    try {
        String subject = "Welcome to Oiship - Verify Your Account";
        String content = "<!DOCTYPE html>"
                + "<html lang='en'>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<meta name='viewport' content='width=device-width, initial-scale=1.0'>"
                + "<title>Oiship - Email Verification</title>"
                + "<style>"
                + "* { margin: 0; padding: 0; box-sizing: border-box; }"
                + "body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }"
                + ".email-container { background: white; max-width: 600px; width: 100%; border-radius: 20px; box-shadow: 0 20px 40px rgba(255, 107, 53, 0.3); overflow: hidden; position: relative; }"
                + ".header { background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%); padding: 40px 30px; text-align: center; position: relative; overflow: hidden; }"
                + ".header::before { content: ''; position: absolute; top: -50%; left: -50%; width: 200%; height: 200%; background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px); background-size: 20px 20px; animation: float 20s linear infinite; }"
                + "@keyframes float { 0% { transform: translateX(0) translateY(0); } 100% { transform: translateX(-50px) translateY(-50px); } }"
                + ".logo-container { display: flex; align-items: center; justify-content: center; gap: 12px; margin-bottom: 10px; position: relative; z-index: 2; }"
                + ".logo-icon { width: 40px; height: 40px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }"
                + ".food-icon { width: 24px; height: 24px; background: #ff6b35; border-radius: 50%; position: relative; }"
                + ".food-icon::before { content: ''; position: absolute; top: 4px; left: 4px; width: 16px; height: 8px; background: #f7931e; border-radius: 8px 8px 4px 4px; }"
                + ".food-icon::after { content: ''; position: absolute; bottom: 6px; left: 6px; width: 12px; height: 6px; background: #e67e22; border-radius: 6px; }"
                + ".logo-text { font-size: 32px; font-weight: 800; color: white; text-shadow: 0 2px 4px rgba(0,0,0,0.1); }"
                + ".tagline { color: rgba(255,255,255,0.9); font-size: 16px; font-weight: 400; position: relative; z-index: 2; }"
                + ".content { padding: 50px 40px; text-align: center; }"
                + ".welcome-text { font-size: 28px; font-weight: 700; color: #2c3e50; margin-bottom: 20px; line-height: 1.3; }"
                + ".name-highlight { color: #ff6b35; position: relative; }"
                + ".name-highlight::after { content: ''; position: absolute; bottom: -2px; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, #ff6b35, #f7931e); border-radius: 2px; }"
                + ".description { font-size: 18px; color: #7f8c8d; margin-bottom: 30px; line-height: 1.6; }"
                + ".verification-section { margin: 40px 0; }"
                + ".verification-label { font-size: 16px; color: #34495e; margin-bottom: 20px; font-weight: 600; }"
                + ".code-container { background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%); padding: 25px; border-radius: 15px; margin: 20px 0; position: relative; overflow: hidden; }"
                + ".code-container::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: radial-gradient(circle at center, rgba(255,255,255,0.1) 2px, transparent 2px); background-size: 40px 40px; opacity: 0.3; }"
                + ".verification-code { font-size: 36px; font-weight: 800; color: white; letter-spacing: 8px; text-shadow: 0 2px 4px rgba(0,0,0,0.2); position: relative; z-index: 2; font-family: 'Courier New', monospace; }"
                + ".timer-info { background: #fff8f5; border: 2px solid #ffe5d9; border-radius: 12px; padding: 20px; margin: 30px 0; display: flex; align-items: center; justify-content: center; gap: 10px; }"
                + ".timer-icon { width: 20px; height: 20px; border-radius: 50%; background: #ff6b35; position: relative; }"
                + ".timer-icon::before { content: ''; position: absolute; top: 2px; left: 50%; transform: translateX(-50%); width: 2px; height: 8px; background: white; border-radius: 1px; }"
                + ".timer-icon::after { content: ''; position: absolute; top: 6px; left: 50%; transform: translateX(-50%); width: 2px; height: 6px; background: white; border-radius: 1px; transform-origin: bottom; transform: translateX(-50%) rotate(90deg); }"
                + ".timer-text { color: #d35400; font-weight: 600; font-size: 16px; }"
                + ".footer-note { color: #95a5a6; font-size: 14px; line-height: 1.5; margin-top: 30px; }"
                + ".footer { background: #f8f9fa; padding: 30px; text-align: center; border-top: 1px solid #ecf0f1; }"
                + ".footer-signature { font-size: 16px; color: #2c3e50; margin-bottom: 10px; }"
                + ".footer-team { font-weight: 700; color: #ff6b35; }"
                + ".footer-tagline { font-size: 14px; color: #7f8c8d; font-style: italic; margin-top: 15px; }"
                + ".decoration { position: absolute; width: 100px; height: 100px; background: linear-gradient(45deg, #ff6b35, #f7931e); border-radius: 50%; opacity: 0.1; }"
                + ".decoration-1 { top: -50px; right: -50px; }"
                + ".decoration-2 { bottom: -50px; left: -50px; }"
                + "@media (max-width: 600px) {"
                + ".email-container { margin: 10px; border-radius: 15px; }"
                + ".content { padding: 30px 25px; }"
                + ".welcome-text { font-size: 24px; }"
                + ".verification-code { font-size: 28px; letter-spacing: 4px; }"
                + ".header { padding: 30px 20px; }"
                + ".logo-container { flex-direction: column; gap: 8px; }"
                + ".logo-text { font-size: 28px; }"
                + "}"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='email-container'>"
                + "<div class='header'>"
                + "<div class='logo-container'>"
                + "<div class='logo-icon'>"
                + "<div class='food-icon'></div>"
                + "</div>"
                + "<div class='logo-text'>Oiship</div>"
                + "</div>"
                + "<div class='tagline'>Delivering Deliciousness to Your Doorstep</div>"
                + "</div>"
                + "<div class='content'>"
                + "<h1 class='welcome-text'>Welcome <span class='name-highlight'>" + name + "</span>!</h1>"
                + "<p class='description'>We're thrilled to have you join our food delivery community!</p>"
                + "<div class='verification-section'>"
                + "<p class='verification-label'>Please verify your account using the code below:</p>"
                + "<div class='code-container'>"
                + "<div class='verification-code'>" + code + "</div>"
                + "</div>"
                + "</div>"
                + "<div class='timer-info'>"
                + "<div class='timer-icon'></div>"
                + "<span class='timer-text'>This verification code is valid for 5 minutes</span>"
                + "</div>"
                + "<p class='footer-note'>If you didn't sign up for Oiship, please ignore this email.</p>"
                + "</div>"
                + "<div class='footer'>"
                + "<p class='footer-signature'>Best regards,<br><span class='footer-team'>The Oiship Team</span></p>"
                + "<p class='footer-tagline'>Oiship - Delivering Deliciousness to Your Doorstep</p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";
        
        sendEmail(List.of(to), subject, content);
    } catch (Exception e) {
        e.printStackTrace();
    }
}
}