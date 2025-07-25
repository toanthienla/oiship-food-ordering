package controller.auth;

import dao.AccountDAO;
import dao.SecurityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.Customer;
import model.Staff;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
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

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember_me");

        System.out.println("Login attempt: email=" + email);

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter email and password.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        Object user = accountDAO.getAuthenticatedUser(email, password);

        if (user == null) {
            request.setAttribute("error", "Invalid email or password, please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Login successful
        HttpSession session = request.getSession(true);
        String role;
        int userId;
        String userName;
        String userEmail;

        Account accountInfo = null;
        if (user instanceof Customer) {
            role = "customer";
            userId = ((Customer) user).getCustomerID();
            accountInfo = accountDAO.getAccountById(userId);
        } else if (user instanceof Staff) {
            role = ((Staff) user).getRole();
            userId = ((Staff) user).getAccountID();
            accountInfo = (Staff) user;
        } else {
            request.setAttribute("error", "Only staff and customer accounts are allowed.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Only allow 'staff' and 'customer' roles
        if (!"staff".equalsIgnoreCase(role) && !"customer".equalsIgnoreCase(role)) {
            request.setAttribute("error", "Access denied. Only staff and customer roles are allowed.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Set session attributes
        userName = accountInfo != null ? accountInfo.getFullName() : "Unknown";
        userEmail = accountInfo != null ? accountInfo.getEmail() : email;
        session.setAttribute("userId", userId);
        session.setAttribute("role", role);
        session.setAttribute("userName", userName);
        session.setAttribute("email", userEmail);
        session.setAttribute("account", user);

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

        // Redirect
        if ("staff".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
        } else if ("customer".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
