package controller.google;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.GoogleOAuthDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import model.GoogleAccount;
import dao.SecurityDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

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

            Customer existingAccount = accountDAO.getCustomerByEmail(email);

            HttpSession session = request.getSession();

            if (existingAccount != null) {
                if (existingAccount.getStatus() == 1) {
                    session.setAttribute("userId", existingAccount.getCustomerID());
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

            // Lưu email và fullName vào session
            session.setAttribute("regEmail", email);
            session.setAttribute("regFullName", fullName);
            request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Google authentication failed", e);
            request.setAttribute("error", "Google authentication failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Lưu các giá trị vào session để giữ nguyên khi có lỗi
        session.setAttribute("regFullName", fullName);
        session.setAttribute("regEmail", email);
        session.setAttribute("regPhone", phone);
        session.setAttribute("regAddress", address);

        // Kiểm tra các trường bắt buộc
        if (fullName == null || fullName.trim().isEmpty() || phone == null || phone.trim().isEmpty() ||
            address == null || address.trim().isEmpty() || password == null || confirmPassword == null) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu
        if (!password.equals(confirmPassword)) {
            request.setAttribute("passwordError", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        try {
            // Kiểm tra email hoặc phone đã tồn tại
            if (accountDAO.getCustomerByEmail(email) != null || accountDAO.isEmailOrPhoneExists(email, phone)) {
                request.setAttribute("emailPhoneError", "Email or phone already exists.");
                request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
                return;
            }

            String hashedPassword = SecurityDAO.hashPassword(password);

            Customer newCustomer = new Customer(
                    0, fullName, email, hashedPassword, "customer", new Timestamp(System.currentTimeMillis()),
                    1, phone, address
            );

            int accountId = accountDAO.insertAccount(newCustomer);
            if (accountId > 0) {
                newCustomer.setCustomerID(accountId);
                CustomerDAO customerDAO = new CustomerDAO();
                if (customerDAO.insertCustomer(newCustomer)) {
                    session.removeAttribute("regFullName");
                    session.removeAttribute("regEmail");
                    session.removeAttribute("regPhone");
                    session.removeAttribute("regAddress");
                    session.setAttribute("userId", accountId);
                    session.setAttribute("role", "customer");
                    session.setAttribute("userName", fullName);
                    LOGGER.info("Account created: userId=" + accountId + ", email=" + email);
                    response.sendRedirect("home");
                } else {
                    request.setAttribute("errorMessage", "Failed to register customer details.");
                    request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Failed to create account. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating Google account", e);
            request.setAttribute("errorMessage", "System error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/complete_google_register.jsp").forward(request, response);
        }
    }
}