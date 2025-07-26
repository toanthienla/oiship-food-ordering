package controller.auth;

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

        System.out.println("doPost - Register attempt: email=" + email + ", fullName=" + fullName);

        if (fullName == null || email == null || phone == null || address == null || password == null || confirmPassword == null) {
            System.out.println("doPost - Missing required fields");
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            System.out.println("doPost - Passwords do not match");
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Store registration data in session
        HttpSession session = request.getSession(true);
        session.setAttribute("regFullName", fullName);
        session.setAttribute("regEmail", email);
        session.setAttribute("regPhone", phone);
        session.setAttribute("regAddress", address);
        session.setAttribute("regHashedPassword", SecurityDAO.hashPassword(password));
        session.setAttribute("regRememberMe", rememberMe);

        System.out.println("doPost - Stored registration data in session, redirecting to verify");

        // Redirect to verify without inserting customer
        response.sendRedirect("verify?verified=true");
    }

    private void processRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("processRegistration - No session found, redirecting to register");
            response.sendRedirect("register");
            return;
        }

        String fullName = (String) session.getAttribute("regFullName");
        String email = (String) session.getAttribute("regEmail");
        String phone = (String) session.getAttribute("regPhone");
        String address = (String) session.getAttribute("regAddress");
        String hashedPassword = (String) session.getAttribute("regHashedPassword");
        String rememberMe = (String) session.getAttribute("regRememberMe");

        if (fullName == null || email == null || phone == null || address == null || hashedPassword == null) {
            System.out.println("processRegistration - Missing session data: email=" + email + ", fullName=" + fullName);
            response.sendRedirect("register");
            return;
        }

        // Insert customer into database
        Customer customer = new Customer(0, phone, address);
        CustomerDAO customerDAO = new CustomerDAO();
        try {
            boolean inserted = customerDAO.insertCustomer(customer, fullName, email, hashedPassword);
            if (!inserted) {
                System.out.println("processRegistration - Account creation failed: email or phone already exists");
                request.setAttribute("error", "Account creation failed: email or phone already exists.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }

            int customerId = customer.getCustomerID();
            System.out.println("processRegistration - Customer inserted: customerId=" + customerId);

            // Update OTP with customerId
            OTPDAO otpDAO = new OTPDAO();
            otpDAO.updateOtpCustomerId(email, customerId);

            // Set remember_me cookie
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

            // Set session for logged-in user
            session.setAttribute("userId", customerId);
            session.setAttribute("role", "customer");
            session.setAttribute("email", email);
            session.setAttribute("userName", fullName);

            // Clean up session
            session.removeAttribute("regFullName");
            session.removeAttribute("regEmail");
            session.removeAttribute("regPhone");
            session.removeAttribute("regAddress");
            session.removeAttribute("regHashedPassword");
            session.removeAttribute("regRememberMe");
            session.removeAttribute("regHashedOTP");
            session.removeAttribute("codeExpiryTime");
            session.removeAttribute("lastResendTime");

            System.out.println("processRegistration - Registration completed, redirecting to home");
            response.sendRedirect("home");
        } catch (RuntimeException e) {
            System.out.println("processRegistration - Error: " + e.getMessage());
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}