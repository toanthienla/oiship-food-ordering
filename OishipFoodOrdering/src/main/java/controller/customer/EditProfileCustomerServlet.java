package controller.customer;

import dao.AccountDAO;
import dao.CustomerProfileDAO;
import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.Notification;

@WebServlet(name = "EditProfileCustomerServlet", urlPatterns = {"/customer/profile/edit-profile"})
public class EditProfileCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if the session exists and the user is logged in as a customer
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"customer".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get customer information using email stored in session
        // int userId = (int) session.getAttribute("userId");
        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.findByEmail((String) session.getAttribute("email"));
        if (account != null) {
            request.setAttribute("account", account);
            request.setAttribute("userName", account.getFullName());
        } else {
            request.setAttribute("error", "Account not found.");
        }
        int userId = account.getAccountID();
        // Refresh remember_me cookie if present
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("email".equals(cookie.getName())) {
                    Cookie emailCookie = new Cookie("email", cookie.getValue());
                    emailCookie.setMaxAge(30 * 24 * 60 * 60);
                    emailCookie.setPath(request.getContextPath());
                    response.addCookie(emailCookie);
                    break;
                }
            }
        }

        NotificationDAO notificationDAO = new NotificationDAO();
        List<Notification> notifications = notificationDAO.getUnreadNotificationsByCustomer(userId);
        request.setAttribute("notifications", notifications);
        String email = (String) session.getAttribute("email");
        
        if (email != null) {
            CustomerProfileDAO cus = new CustomerProfileDAO();
            Customer customer = cus.getCustomerByEmail(email);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_edit_profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = (String) request.getSession().getAttribute("email");

        String newName = request.getParameter("fullName");
        String newPhone = request.getParameter("phone");
        String newAddress = request.getParameter("address");
        if (email != null
                && newName != null && !newName.trim().isEmpty()
                && newPhone != null && !newPhone.trim().isEmpty()
                && newAddress != null && !newAddress.trim().isEmpty()) {

            CustomerProfileDAO cus = new CustomerProfileDAO();
            boolean success = cus.editCustomerInfoByEmail(email, newName, newPhone, newAddress);

            if (success) {
                request.getSession().setAttribute("userName", newName);
                request.setAttribute("message", "Profile updated successfully.");
            } else {
                request.setAttribute("error", "Failed to update profile.");
            }

            Customer updatedCustomer = cus.getCustomerByEmail(email);
            request.setAttribute("customer", updatedCustomer);
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_edit_profile.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_edit_profile.jsp").forward(request, response);
        }
    }
}
