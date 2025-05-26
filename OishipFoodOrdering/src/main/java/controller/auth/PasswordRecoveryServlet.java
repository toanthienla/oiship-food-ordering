package controller.auth;

import dao.AccountDAO;
import dao.OTPDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.OTP;
import org.mindrot.jbcrypt.BCrypt;
import utils.EmailService;

import java.io.IOException;

@WebServlet(name = "PasswordRecoveryServlet", urlPatterns = {"/password-recovery"})
public class PasswordRecoveryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        boolean isResetStage = session != null && session.getAttribute("reset_email") != null;

        if (isResetStage) {
            // Bước 2: Đặt lại mật khẩu
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
        } else {
            // Bước 1: Nhập email để gửi mã xác minh
            request.getRequestDispatcher("/WEB-INF/views/auth/forgot_password.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        boolean isResetStage = session.getAttribute("reset_email") != null;

        if (isResetStage) {
            // Giai đoạn 2: Xử lý đặt lại mật khẩu
            handleResetPassword(request, response, session);
        } else {
            // Giai đoạn 1: Xử lý gửi mã xác minh
            handleSendOtp(request, response, session);
        }
    }

    private void handleSendOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        if (email == null || role == null || email.isBlank()) {
            response.sendRedirect("login?error=missing");
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getAccountByEmailAndRole(email, capitalize(role));

        if (account == null) {
            response.sendRedirect("login?error=email_not_found");
            return;
        }

        String[] otp = EmailService.generateAndSendVerification(email, role.toUpperCase() + " User");

        if (otp == null) {
            response.sendRedirect("login?error=send_failed");
            return;
        }

        new OTPDAO().insertOTP(new OTP(otp[1], otp[0], account.getAccountId()));

        session.setAttribute("reset_email", email);
        session.setAttribute("reset_role", role);
        session.setAttribute("reset_code", otp[0]);

        response.sendRedirect("password-recovery");
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String email = (String) session.getAttribute("reset_email");
        String role = (String) session.getAttribute("reset_role");
        String otpCode = request.getParameter("otp");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");

        // Kiểm tra mã
        String expected = (String) session.getAttribute("reset_code");
        if (otpCode == null || !otpCode.equals(expected)) {
            request.setAttribute("error", "Mã xác nhận không chính xác.");
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
            return;
        }

        if (password == null || confirm == null || !password.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu không khớp.");
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
            return;
        }

        String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
        boolean updated = new AccountDAO().updatePasswordByEmail(email, role, hashed);

        if (updated) {
            session.invalidate();
            response.sendRedirect("login?success=reset");
        } else {
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/auth/reset_password.jsp").forward(request, response);
        }
    }

    private String capitalize(String str) {
        return str == null ? null : str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }
}
