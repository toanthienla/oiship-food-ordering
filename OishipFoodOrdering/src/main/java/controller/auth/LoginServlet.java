package controller.auth;

import dao.AccountDAO;
import dao.SecurityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
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
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Login attempt: email=" + email);

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            System.out.println("Missing email or password");
            request.setAttribute("error", "Please enter email and password.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        Customer account = accountDAO.login(email, password);

        if (account == null) {
            System.out.println("No account found for email: " + email);
            request.setAttribute("error", "Invalid account, please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Login successful
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", account.getCustomerID());
        session.setAttribute("role", account.getRole());
        session.setAttribute("userName", account.getFullName());
        session.setAttribute("account", account);
        session.setAttribute("email", account.getEmail());
        

        // Debug
        System.out.println("Login successful: email=" + email + ", role=" + account.getRole() + ", userName=" + account.getFullName() + ", userId=" + account.getCustomerID());
        System.out.println("Session set: userId=" + session.getAttribute("userId") + ", role=" + session.getAttribute("role") + ", userName=" + session.getAttribute("userName"));

        // Redirect dựa trên role
        if ("admin".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin");
        } else if ("staff".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
        } else if ("customer".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}