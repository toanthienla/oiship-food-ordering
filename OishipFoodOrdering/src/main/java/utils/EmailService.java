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
            String subject = "Verify Your Food Delivery App Account";
            String content = "<h3>Dear " + name + ",</h3>"
                    + "<p>Thank you for registering with our Food Delivery App!</p>"
                    + "<p><strong>Verification Code:</strong> " + code + "</p>"
                    + "<p>This code is valid for 1 minute.</p>"
                    + "<br><p>Best regards,<br>Food Delivery Team</p>";

            sendEmail(List.of(to), subject, content);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
