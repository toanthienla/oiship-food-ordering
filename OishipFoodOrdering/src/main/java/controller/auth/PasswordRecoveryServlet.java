package controller.auth;

import dao.AccountDAO;
import dao.OTPDAO;
import dao.SecurityDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.OTP;
import utils.EmailService;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(name = "PasswordRecoveryServlet", urlPatterns = {"/password-recovery"})
public class PasswordRecoveryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("reset_email") != null) {
            String email = (String) session.getAttribute("reset_email");
            System.out.println("Showing reset password page for email: " + email);
            request.setAttribute("email", email); // Truyền email vào request
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
        } else {
            System.out.println("No reset_email in session, redirecting to login");
            response.sendRedirect("login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        String email = request.getParameter("email");
        String otpCode = request.getParameter("otp");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");

        System.out.println("doPost: email=" + email + ", otp=" + otpCode + ", password=" + (password != null ? "set" : "null") + ", confirm=" + (confirm != null ? "set" : "null"));

        if (otpCode != null && password != null && confirm != null) {
            handleResetPassword(request, response, session);
        } else if (email != null && !email.trim().isEmpty()) {
            handleEmailSubmission(request, response, session, email);
        } else {
            System.out.println("Missing email or reset form data");
            response.sendRedirect("login?error=missing_email");
        }
    }

    private void handleEmailSubmission(HttpServletRequest request, HttpServletResponse response, HttpSession session, String email)
            throws ServletException, IOException {
        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getAccountByEmail(email);
        if (account == null) {
            System.out.println("Email not found: " + email);
            response.sendRedirect("login?error=email_not_found");
            return;
        }

        System.out.println("Found account for email: " + email + ", accountId: " + account.getAccountID());

        // Vô hiệu hóa OTP cũ
        OTPDAO otpDAO = new OTPDAO();
        otpDAO.markOtpAsUsed(email);
        System.out.println("Marked old OTPs as used for email: " + email);

        String[] otpData;
        try {
            otpData = EmailService.generateAndSendVerificationByEmail(email, account.getFullName());
            System.out.println("Generated OTP for email: " + email + ", plainOTP: " + otpData[0] + ", hashedOTP: " + otpData[1]);
        } catch (MessagingException e) {
            System.out.println("Failed to send OTP to: " + email);
            e.printStackTrace();
            response.sendRedirect("login?error=send_failed");
            return;
        }

        String hashedOtp = otpData[1]; // Sử dụng hashed OTP
        otpDAO.insertOtpTemp(email, hashedOtp, LocalDateTime.now(), LocalDateTime.now().plusMinutes(5));

        session.setAttribute("reset_email", email);
        System.out.println("OTP sent and session set for email: " + email);

        response.sendRedirect("password-recovery");
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String email = (String) session.getAttribute("reset_email");
        String otpCode = request.getParameter("otp");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");

        System.out.println("handleResetPassword: email=" + email + ", otp=" + otpCode + ", password=" + (password != null ? "set" : "null"));

        if (email == null) {
            System.out.println("Session expired: no reset_email");
            request.setAttribute("error", "Session expired. Please try again.");
            request.setAttribute("email", email); // Truyền email để hiển thị lại
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
            return;
        }

        OTPDAO otpDAO = new OTPDAO();
        OTP otp = otpDAO.getLatestOtpByEmail(email);
        if (otp == null) {
            System.out.println("No valid OTP for email: " + email);
            request.setAttribute("error", "The verification code is invalid or expired..");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
            return;
        }

        System.out.println("Retrieved OTP for email: " + email + ", hashedOtp: " + otp.getOtp());

        if (otpDAO.isOtpExpired(otp.getOtpExpiresAt())) {
            System.out.println("OTP expired for email: " + email);
            otpDAO.markOtpAsUsed(email);
            session.invalidate();
            request.setAttribute("error", "The verification code is invalid or expired..");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
            return;
        }

        if (otpCode == null || !SecurityDAO.checkOTP(otpCode.trim(), otp.getOtp())) {
            System.out.println("Invalid OTP for email: " + email + ", inputOTP: " + otpCode + ", hashedInput: " + SecurityDAO.hashOTP(otpCode != null ? otpCode.trim() : "") + ", hashedOTP: " + otp.getOtp());
            request.setAttribute("error", "The verification code is invalid or expired..");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
            return;
        }

        if (password == null || confirm == null || !password.equals(confirm)) {
            System.out.println("Password mismatch for email: " + email);
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getAccountByEmail(email);
        if (account == null) {
            System.out.println("Account not found for email: " + email);
            request.setAttribute("error", "Account does not exist.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
            return;
        }

        System.out.println("Attempting password update for email: " + email + ", role: " + account.getRole());
        String hashedPassword = SecurityDAO.hashPassword(password);
        boolean updated = accountDAO.updatePasswordByEmail(email, account.getRole(), hashedPassword);

        if (updated) {
            otpDAO.markOtpAsUsed(email);
            System.out.println("Password updated for email: " + email);
            session.invalidate();
            response.sendRedirect("login?success=reset");
        } else {
            System.out.println("Failed to update password for email: " + email + ", role: " + account.getRole());
            request.setAttribute("error", "System error. Please try again..");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
        }
    }

    private String capitalize(String str) {
        return str == null ? null : str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }
}
