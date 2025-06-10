package controller.auth;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.OTPDAO;
import dao.SecurityDAO;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import utils.EmailService;

import java.io.IOException;
import java.sql.Timestamp;

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
        if (accountDAO.getCustomerByEmail(email) != null) {
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

        // Chuyển hướng sang verify với verified=true
        response.sendRedirect("verify?verified=true");
    }

    private void processRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String fullName = (String) session.getAttribute("regFullName");
        String email = (String) session.getAttribute("regEmail");
        String phone = (String) session.getAttribute("regPhone");
        String address = (String) session.getAttribute("regAddress");
        String password = (String) session.getAttribute("regPassword");

        if (fullName == null || email == null || password == null) {
            response.sendRedirect("register");
            return;
        }

        Customer customer = new Customer(
                0, fullName, email, password, "customer", new Timestamp(System.currentTimeMillis()),
                1, phone, address
        );

        AccountDAO accountDAO = new AccountDAO();
        int accountId = accountDAO.insertAccount(customer);
        System.out.println("Account insert result: " + accountId);
        if (accountId > 0) {
            customer.setCustomerID(accountId);
            CustomerDAO customerDAO = new CustomerDAO();
            if (customerDAO.insertCustomer(customer)) {
                if (customer.getStatus() == 1) {
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
                    request.setAttribute("error", "Account status is not active (status != 1).");
                    request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Failed to register customer details.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Account creation failed. Please try again. Check database constraints or connection.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}