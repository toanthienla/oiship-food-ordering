package controller.auth;

import dao.AccountDAO;
import dao.OTPDAO;
import dao.SecurityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.OTP;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

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
        request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String otpInput = request.getParameter("code"); // Thay "otp" thành "code" để khớp với verify.jsp
        HttpSession session = request.getSession();

        // Lấy email từ session
        String email = (String) session.getAttribute("regEmail");
        String hashedOTP = (String) session.getAttribute("regHashedOTP");
        if (email == null || hashedOTP == null) {
            request.setAttribute("error", "Session expired. Please register again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        // Lấy OTP từ database
        OTPDAO otpDAO = new OTPDAO();
        OTP otpRecord = otpDAO.getLatestOtpByEmail(email);
        if (otpRecord == null) {
            request.setAttribute("error", "No valid OTP found. Please register again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        // Kiểm tra OTP hết hạn
        if (otpDAO.isOtpExpired(otpRecord.getOtpExpiresAt()) || otpRecord.getIsUsed() == 1) {
            request.setAttribute("error", "OTP has expired or already used. Please register again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        // So sánh OTP nhập với OTP đã hash
        if (!SecurityDAO.checkOTP(otpInput, hashedOTP)) {
            request.setAttribute("error", "Invalid OTP. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        // Đánh dấu OTP đã sử dụng
        otpDAO.markOtpAsUsed(email);

        // Lấy thông tin user từ session
        String fullName = (String) session.getAttribute("regFullName");
        String phone = (String) session.getAttribute("regPhone");
        String address = (String) session.getAttribute("regAddress");
        String password = (String) session.getAttribute("regPassword");

        if (fullName == null || password == null) {
            response.sendRedirect("register");
            return;
        }

        // Mã hóa mật khẩu và tạo tài khoản
        String hashedPassword = SecurityDAO.hashPassword(password);
        Account account = new Account(
                0, fullName, email, phone, hashedPassword, address, 1, "customer", new Timestamp(System.currentTimeMillis())
        );

        AccountDAO dao = new AccountDAO();
        int accountId;
        accountId = dao.insertAccountAndReturnId(account);

        if (accountId == -1) {
            request.setAttribute("error", "Account creation failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        // Cập nhật FK_OTP_Account
        dao.updateOtpAccountId(email, accountId);

        // Xóa session tạm
        session.removeAttribute("regFullName");
        session.removeAttribute("regEmail");
        session.removeAttribute("regPhone");
        session.removeAttribute("regAddress");
        session.removeAttribute("regPassword");
        session.removeAttribute("regHashedOTP");
        session.removeAttribute("codeExpiryTime");

        // Tạo session đăng nhập
        session.setAttribute("userId", accountId);
        session.setAttribute("role", "customer");
        session.setAttribute("email", email);
        session.setAttribute("userName", fullName);

        // Điều hướng về trang chính
        response.sendRedirect("home");
    }
}
