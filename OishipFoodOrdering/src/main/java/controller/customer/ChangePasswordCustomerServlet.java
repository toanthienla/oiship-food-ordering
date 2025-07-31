/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dao.AccountDAO;
import dao.CustomerProfileDAO;
import dao.NotificationDAO;
import dao.SecurityDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Account;
import model.Customer;
import model.Notification;

@WebServlet(name = "ChangePasswordCustomerServlet", urlPatterns = {"/customer/profile/change-password"})
public class ChangePasswordCustomerServlet extends HttpServlet {

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
        
        request.getRequestDispatcher("/WEB-INF/views/customer/customer_change_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = (String) request.getSession().getAttribute("email");
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        CustomerProfileDAO customer = new CustomerProfileDAO();
        Customer cus = customer.getCustomerByEmail(email);

        if (cus == null) {
            request.setAttribute("error", "Customer not found.");
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_change_password.jsp").forward(request, response);
            return;
        }

        boolean isCurrentPasswordValid = SecurityDAO.checkPassword(currentPassword, cus.getPassword());
        if (!isCurrentPasswordValid) {
            request.setAttribute("error", "Current password is incorrect.");
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_change_password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match.");
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_change_password.jsp").forward(request, response);
            return;
        }

        boolean success = customer.changePasswordCustomerByEmail(email, newPassword);

        if (success) {
            request.setAttribute("message", "Password changed successfully.");
        } else {
            request.setAttribute("error", "Failed to change password. Please try again.");
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/customer_change_password.jsp").forward(request, response);
    }

}
