package controller.auth;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.OTPDAO;
import dao.SecurityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String verified = request.getParameter("verified");
        if ("true".equals(verified)) {
            processRegistration(request, response);
            return;
        }
        // Check for remember_me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("email".equals(cookie.getName())) {
                    request.setAttribute("email", cookie.getValue());
                    break;
                }
            }
        }
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String rememberMe = request.getParameter("remember_me");

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
        if (accountDAO.findByEmail(email) != null) {
            request.setAttribute("error", "Email already exists.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        String hashedPassword = SecurityDAO.hashPassword(password);
        session.setAttribute("regFullName", fullName);
        session.setAttribute("regEmail", email);
        session.setAttribute("regPhone", phone);
        session.setAttribute("regAddress", address);
        session.setAttribute("regPassword", hashedPassword);

        // Handle remember_me
        if ("on".equals(rememberMe)) {
            Cookie emailCookie = new Cookie("email", email);
            emailCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
            emailCookie.setPath(request.getContextPath());
            response.addCookie(emailCookie);
        } else {
            Cookie emailCookie = new Cookie("email", "");
            emailCookie.setMaxAge(0);
            emailCookie.setPath(request.getContextPath());
            response.addCookie(emailCookie);
        }

        // Chuyển hướng sang verify
        response.sendRedirect("verify?verified=true");
    }

    private void processRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String fullName = (String) session.getAttribute("regFullName");
        String email = (String) session.getAttribute("regEmail");
        String phone = (String) session.getAttribute("regPhone");
        String address = (String) session.getAttribute("regAddress");
        String hashedPassword = (String) session.getAttribute("regPassword");

        if (fullName == null || email == null || hashedPassword == null) {
            response.sendRedirect("register");
            return;
        }

        Customer customer = new Customer(0, phone, address); // customerID set to 0
        CustomerDAO customerDAO = new CustomerDAO();
        if (customerDAO.insertCustomer(customer, fullName, email, hashedPassword)) {
            int accountId = customer.getCustomerID();
            System.out.println("Customer insert result: customerId=" + accountId + ", email=" + email);

            // Cập nhật customerId vào bản ghi OTP
            OTPDAO otpDAO = new OTPDAO();
            otpDAO.updateOtpCustomerId(email, accountId);
            System.out.println("Updated OTP with customerId: " + accountId + " for email: " + email);

            session.removeAttribute("regFullName");
            session.removeAttribute("regEmail");
            session.removeAttribute("regPhone");
            session.removeAttribute("regAddress");
            session.removeAttribute("regPassword");

            session.setAttribute("userId", accountId);
            session.setAttribute("role", "customer");
            session.setAttribute("email", email);
            session.setAttribute("userName", fullName);

            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Account creation failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}
