package controller.auth;

import dao.OTPDAO;
import dao.SecurityDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.OTP;
import utils.EmailService;

import java.io.IOException;

@WebServlet(name = "VerifyServlet", urlPatterns = {"/verify"})
public class VerifyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Long expiryMillis = (Long) session.getAttribute("codeExpiryTime");
        if (expiryMillis == null) {
            expiryMillis = System.currentTimeMillis() + 5 * 60 * 1000; // 5 phút
            session.setAttribute("codeExpiryTime", expiryMillis);
        }

        // Gửi email OTP khi lần đầu vào verify (khi verified=true từ RegisterServlet)
        String verified = request.getParameter("verified");
        System.out.println("Verified parameter in doGet: " + verified); // Debug log
        if ("true".equals(verified)) {
            String email = (String) session.getAttribute("regEmail");
            String fullName = (String) session.getAttribute("regFullName");

            if (email != null && fullName != null) {
                try {
                    System.out.println("Attempting to send OTP to email: " + email); // Debug log
                    String[] otpData = EmailService.generateAndSendVerificationByEmail(email, fullName);
                    session.setAttribute("regHashedOTP", otpData[1]);
                    session.setAttribute("codeExpiryTime", System.currentTimeMillis() + 5 * 60 * 1000);
                    System.out.println("OTP sent successfully to: " + email + ", Hashed OTP: " + otpData[1]); // Debug log
                } catch (MessagingException e) {
                    System.out.println("Failed to send OTP for email: " + email + ": " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("error", "Failed to send OTP. Please try again. Error: " + e.getMessage());
                }
            } else {
                System.out.println("Email or fullName is null in session for verified request");
                request.setAttribute("error", "Session data is missing. Please register again.");
            }
        } else {
            System.out.println("No verified parameter, skipping OTP send");
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String otpInput = request.getParameter("code");
        HttpSession session = request.getSession();

        String email = (String) session.getAttribute("regEmail");
        System.out.println("Verifying OTP for email: " + email);

        if (email == null) {
            request.setAttribute("error", "Session expired. Please register again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        OTPDAO otpDAO = new OTPDAO();
        OTP otpRecord = otpDAO.getLatestOtpByEmail(email);
        System.out.println("OTP Record found: " + (otpRecord != null ? otpRecord.getOtp() : "null"));

        if (otpRecord == null) {
            request.setAttribute("error", "No valid OTP found. Please register again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        if (otpDAO.isOtpExpired(otpRecord.getOtpExpiresAt()) || otpRecord.getIsUsed() == 1) {
            request.setAttribute("error", "OTP has expired or already used. Please register again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        System.out.println("OTP Input: " + otpInput);
        System.out.println("Hashed OTP from DB: " + otpRecord.getOtp());

        if (otpInput == null || otpInput.trim().isEmpty() || !SecurityDAO.checkOTP(otpInput.trim(), otpRecord.getOtp())) {
            System.out.println("OTP check failed - Input hashed: " + SecurityDAO.hashOTP(otpInput.trim()));
            request.setAttribute("error", "Invalid OTP. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        // OTP hợp lệ, đánh dấu đã dùng và chuyển hướng về register để insert
        otpDAO.markOtpAsUsed(email);
        response.sendRedirect("register?verified=true");
    }
}