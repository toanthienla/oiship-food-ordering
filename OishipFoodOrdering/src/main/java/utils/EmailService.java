package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Properties;
import java.util.stream.Collectors;

import io.github.cdimascio.dotenv.Dotenv;

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

    public static String[] generateAndSendVerification(String to, String name) {
        try {
            // 1. Tạo mã
            String plainCode = String.valueOf(100000 + new java.util.Random().nextInt(900000));
            String hashedCode = org.apache.commons.codec.digest.DigestUtils.md5Hex(plainCode);

            // 2. Gửi mail
            sendVerificationEmail(to, name, plainCode);

            // 3. Trả lại mã (để servlet hoặc DAO lưu vào DB)
            return new String[]{plainCode, hashedCode};
        } catch (Exception e) {
            e.printStackTrace();
            return null; // thất bại
        }
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
                        throw new RuntimeException(e);
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
                    + "<html><body style='font-family: Arial, sans-serif; color: #333;'>"
                    + "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>"
                    + "<h2 style='color: #ff5733;'>Welcome to Oiship, " + name + "!</h2>"
                    + "<p>We're thrilled to have you join our food delivery community!</p>"
                    + "<p>To get started, please verify your account using the code below:</p>"
                    + "<div style='background: #f9f9f9; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; color: #ff5733;'>"
                    + code + "</div>"
                    + "<p style='margin-top: 20px;'>This verification code is valid for <strong>1 minute</strong>.</p>"
                    + "<p>If you didn't sign up for Oiship, please ignore this email.</p>"
                    + "<br><p style='font-size: 14px;'>Best regards,<br><strong>The Oiship Team</strong></p>"
                    + "<p style='font-size: 12px; color: #777;'>Oiship - Delivering Deliciousness to Your Doorstep</p>"
                    + "</div></body></html>";

            sendEmail(List.of(to), subject, content);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
