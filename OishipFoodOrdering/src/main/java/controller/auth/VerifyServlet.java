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
import java.io.PrintWriter;

@WebServlet(name = "VerifyServlet", urlPatterns = {"/verify", "/resend"})
public class VerifyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Long expiryMillis = (Long) session.getAttribute("codeExpiryTime");
        if (expiryMillis == null) {
            expiryMillis = System.currentTimeMillis() + 5 * 60 * 1000; // 5 minutes
            session.setAttribute("codeExpiryTime", expiryMillis);
        }

        String verified = request.getParameter("verified");
        System.out.println("doGet - Verified parameter: " + verified);
        if ("true".equals(verified)) {
            String email = (String) session.getAttribute("regEmail");
            String fullName = (String) session.getAttribute("regFullName");

            if (email != null && fullName != null) {
                try {
                    System.out.println("doGet - Sending OTP to: " + email);
                    String[] otpData = EmailService.generateAndSendVerificationByEmail(email, fullName);
                    session.setAttribute("regHashedOTP", otpData[1]);
                    session.setAttribute("codeExpiryTime", System.currentTimeMillis() + 5 * 60 * 1000);
                    System.out.println("doGet - OTP sent to: " + email + ", Hashed OTP: " + otpData[1]);
                } catch (MessagingException e) {
                    System.out.println("doGet - Failed to send OTP to: " + email + ": " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("error", "Failed to send OTP: " + e.getMessage());
                }
            } else {
                System.out.println("doGet - Missing session data: email=" + email + ", fullName=" + fullName);
                request.setAttribute("error", "Session data missing. Please register again.");
            }
        } else {
            System.out.println("doGet - No verified parameter, skipping OTP send");
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        System.out.println("doPost - Handling path: " + path);
        if ("/resend".equals(path)) {
            handleResend(request, response);
        } else {
            handleVerify(request, response);
        }
    }

    private void handleVerify(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String otpInput = request.getParameter("code");
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("regEmail");
        System.out.println("handleVerify - Verifying OTP for email: " + email);

        if (email == null) {
            System.out.println("handleVerify - Session expired, no email found");
            request.setAttribute("error", "Session expired. Please register again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        OTPDAO otpDAO = new OTPDAO();
        OTP otpRecord = otpDAO.getLatestOtpByEmail(email);
        System.out.println("handleVerify - OTP Record: " + (otpRecord != null ? otpRecord.getOtp() : "null"));

        if (otpRecord == null) {
            System.out.println("handleVerify - No valid OTP found for email: " + email);
            request.setAttribute("error", "No valid OTP found. Please request a new code.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        if (otpDAO.isOtpExpired(otpRecord.getOtpExpiresAt()) || otpRecord.getIsUsed() == 1) {
            System.out.println("handleVerify - OTP expired or used for email: " + email);
            request.setAttribute("error", "OTP has expired or already used. Please request a new code.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        System.out.println("handleVerify - OTP Input: " + otpInput + ", Hashed OTP from DB: " + otpRecord.getOtp());
        if (otpInput == null || otpInput.trim().isEmpty() || !SecurityDAO.checkOTP(otpInput.trim(), otpRecord.getOtp())) {
            System.out.println("handleVerify - OTP check failed. Input hashed: " + SecurityDAO.hashOTP(otpInput.trim()));
            request.setAttribute("error", "Invalid OTP. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        System.out.println("handleVerify - OTP verified successfully for email: " + email);
        otpDAO.markOtpAsUsed(email);
        response.sendRedirect("register?verified=true");
    }

    private void handleResend(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        
        try {
            String email = (String) session.getAttribute("regEmail");
            String fullName = (String) session.getAttribute("regFullName");

            System.out.println("handleResend - Resend request for email: " + email + ", fullName: " + fullName);
            
            if (email == null || fullName == null) {
                System.out.println("handleResend - Missing session data: email=" + email + ", fullName=" + fullName);
                out.print("{\"success\": false, \"error\": \"Session data missing. Please register again.\"}");
                return;
            }

            // Rate-limiting: Prevent resend within 60 seconds
            Long lastResendTime = (Long) session.getAttribute("lastResendTime");
            long currentTime = System.currentTimeMillis();
            if (lastResendTime != null && (currentTime - lastResendTime) < 60 * 1000) {
                long remainingTime = 60 - (currentTime - lastResendTime) / 1000;
                System.out.println("handleResend - Rate limit exceeded for email: " + email);
                out.print("{\"success\": false, \"error\": \"Please wait " + remainingTime + " seconds before requesting another code.\"}");
                return;
            }

            // Generate and send new OTP
            String[] otpData = EmailService.generateAndSendVerificationByEmail(email, fullName);
            
            // Update session with new OTP data
            session.setAttribute("regHashedOTP", otpData[1]);
            session.setAttribute("codeExpiryTime", System.currentTimeMillis() + 5 * 60 * 1000);
            session.setAttribute("lastResendTime", currentTime);
            
            System.out.println("handleResend - OTP resent to: " + email + ", Hashed OTP: " + otpData[1]);
            out.print("{\"success\": true, \"message\": \"Verification code sent successfully.\"}");
            
        } catch (MessagingException e) {
            System.out.println("handleResend - Failed to resend OTP: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"Failed to send verification code. Please try again.\"}");
        } catch (Exception e) {
            System.out.println("handleResend - Unexpected error: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"success\": false, \"error\": \"An unexpected error occurred. Please try again.\"}");
        } finally {
            out.flush();
            out.close();
        }
    }
}