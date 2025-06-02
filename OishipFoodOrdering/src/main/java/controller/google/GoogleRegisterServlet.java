package controller.google;

import dao.AccountDAO;
import dao.GoogleOAuthDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.GoogleAccount;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "GoogleRegisterServlet", urlPatterns = {"/google-register"})
public class GoogleRegisterServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(GoogleRegisterServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String state = request.getParameter("state");

        if (code == null || state == null || !state.equals("customer")) {
            response.sendRedirect("login");
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        try {
            String accessToken = GoogleOAuthDAO.getToken(code);
            GoogleAccount googleAccount = GoogleOAuthDAO.getUserInfo(accessToken);

            if (googleAccount == null) {
                request.setAttribute("error", "Failed to get Google account info.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                return;
            }

            String email = googleAccount.getEmail();
            String fullName = googleAccount.getName();

            Account existingAccount = accountDAO.getAccountByEmail(email);

            HttpSession session = request.getSession();

            if (existingAccount != null) {
                if (existingAccount.getStatus() == 1) {
                    session.setAttribute("userId", existingAccount.getAccountID());
                    session.setAttribute("role", existingAccount.getRole().toLowerCase());
                    session.setAttribute("userName", fullName);
                    response.sendRedirect("home");
                    return;
                } else {
                    request.setAttribute("error", "Your account is inactive or banned.");
                    request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                    return;
                }
            }

            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Google authentication failed", e);
            request.setAttribute("error", "Google authentication failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        } finally {
            accountDAO.closeConnection();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Kiểm tra các trường bắt buộc
        if (fullName == null || email == null || phone == null || address == null || password == null || confirmPassword == null) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu khớp nhau
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        try {
            // Kiểm tra email hoặc số điện thoại đã tồn tại
            if (accountDAO.isEmailOrPhoneExists(email, phone)) {
                request.setAttribute("errorMessage", "Email or phone already exists.");
                request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
                return;
            }

            // Mã hóa mật khẩu
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            Account newAccount = new Account(
                    0, fullName, email, phone, hashedPassword, address, 1, "customer", new Timestamp(System.currentTimeMillis())
            );

            int newAccountId = accountDAO.insertAccountAndReturnId(newAccount);

            if (newAccountId > 0) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", newAccountId);
                session.setAttribute("role", "customer");
                session.setAttribute("userName", fullName);
                LOGGER.info("Account created: userId=" + newAccountId + ", email=" + email);
                response.sendRedirect("home");
            } else {
                request.setAttribute("errorMessage", "Failed to create account. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating Google account", e);
            request.setAttribute("errorMessage", "System error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
        } finally {
            accountDAO.closeConnection();
        }
    }
}
