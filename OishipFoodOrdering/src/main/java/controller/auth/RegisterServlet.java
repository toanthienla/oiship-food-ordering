package controller.auth;

import dao.AccountDAO;
import dao.OTPDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.EmailService;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Kiểm tra null và mật khẩu khớp
        if (fullName == null || email == null || phone == null || address == null || password == null || confirmPassword == null) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDAO = new AccountDAO();

        // Kiểm tra email/sđt đã tồn tại
        if (accountDAO.isEmailOrPhoneExists(email, phone)) {
            request.setAttribute("error", "Email or phone already exists.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Gửi mã OTP
        String[] otpData;
        try {
            otpData = EmailService.generateAndSendVerificationByEmail(email, fullName);
        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to send OTP. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Lưu thông tin người dùng và OTP vào session
        HttpSession session = request.getSession();
        session.setAttribute("regFullName", fullName);
        session.setAttribute("regEmail", email);
        session.setAttribute("regPhone", phone);
        session.setAttribute("regAddress", address);
        session.setAttribute("regPassword", password);
        session.setAttribute("regHashedOTP", otpData[1]); // Lưu hashedOTP
        session.setAttribute("codeExpiryTime", System.currentTimeMillis() + 5 * 60 * 1000); // 5 phút

        // Chuyển sang trang xác minh OTP
        response.sendRedirect("verify");
    }
}
