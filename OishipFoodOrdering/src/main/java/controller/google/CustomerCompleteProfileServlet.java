package controller.google;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;

@WebServlet(name = "CustomerCompleteProfileServlet", urlPatterns = {"/customer-profile-completion"})
public class CustomerCompleteProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/google/customer_profile_completion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("Session not found. Redirecting to login.");
            response.sendRedirect("login");
            return;
        }

        String email = (String) session.getAttribute("oauth_email");
        String name = (String) session.getAttribute("oauth_name");

        if (email == null || name == null) {
            System.out.println("OAuth info missing. Redirecting to login.");
            response.sendRedirect("login");
            return;
        }

        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (phone == null || phone.trim().isEmpty()) {
            System.out.println("Validation Error: Phone number is missing.");
            request.setAttribute("error", "Phone number is required.");
            request.getRequestDispatcher("/WEB-INF/views/google/customer_profile_completion.jsp").forward(request, response);
            return;
        }

        if (!phone.matches("0\\d{9}")) {
            System.out.println("Validation Error: Phone number format is invalid. Value: " + phone);
            request.setAttribute("error", "Phone number must start with 0 and be exactly 10 digits.");
            request.getRequestDispatcher("/WEB-INF/views/google/customer_profile_completion.jsp").forward(request, response);
            return;
        }

        if (address == null || address.trim().isEmpty()) {
            System.out.println("Validation Error: Address is missing.");
            request.setAttribute("error", "Address is required.");
            request.getRequestDispatcher("/WEB-INF/views/google/customer_profile_completion.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            System.out.println("Validation Error: Password is missing.");
            request.setAttribute("error", "Password is required.");
            request.getRequestDispatcher("/WEB-INF/views/google/customer_profile_completion.jsp").forward(request, response);
            return;
        }

        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            System.out.println("Validation Error: Confirm Password is missing.");
            request.setAttribute("error", "Confirm password is required.");
            request.getRequestDispatcher("/WEB-INF/views/google/customer_profile_completion.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            System.out.println("Validation Error: Password and Confirm Password do not match.");
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/google/customer_profile_completion.jsp").forward(request, response);
            return;
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        Customer customer = new Customer();
        customer.setName(name);
        customer.setEmail(email);
        customer.setPhone(phone);
        customer.setAddress(address);
        customer.setPassword(hashedPassword);
        customer.setStatusId(1); // Active
        customer.setCreatedAt(Timestamp.from(Instant.now()));

        CustomerDAO customerDAO = new CustomerDAO();
        int newCustomerId = customerDAO.insertCustomerAndReturnId(customer);

        if (newCustomerId > 0) {
            System.out.println("Customer created successfully. ID: " + newCustomerId);

            session.setAttribute("role", "customer");
            session.setAttribute("userId", newCustomerId);

            session.removeAttribute("oauth_email");
            session.removeAttribute("oauth_name");
            session.removeAttribute("oauth_role");

            response.sendRedirect("home");
        } else {
            System.out.println("Error: Failed to insert customer into database.");
            request.setAttribute("error", "Failed to create account. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/google/customer_profile_completion.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles customer profile completion after Google login with detailed validation";
    }
}
