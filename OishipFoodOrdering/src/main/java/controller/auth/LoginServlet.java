package controller.auth;

import dao.AccountDAO;
import dao.SecurityDAO;
import dao.StaffDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import java.io.IOException;
import model.Staff;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            response.sendRedirect(request.getContextPath() + "/home"); // Sử dụng contextPath để tránh lỗi hard-code
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
        Account account = accountDAO.getAccountByEmail(email);

        if (account == null) {
            System.out.println("Account not found for email: " + email);
            request.setAttribute("error", "Please enter email and password.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        if (!SecurityDAO.checkPassword(password, account.getPassword())) {
            System.out.println("Invalid password for email: " + email);
            request.setAttribute("error", "Invalid account, please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Login successful
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", account.getAccountID());
        session.setAttribute("role", account.getRole());
        session.setAttribute("userName", account.getFullName());
        session.setAttribute("account", account);

        // Debug
        System.out.println("Login successful: email=" + email + ", role=" + account.getRole() + ", userName=" + account.getFullName() + ", userId=" + account.getAccountID());
        System.out.println("Session set: userId=" + session.getAttribute("userId") + ", role=" + session.getAttribute("role") + ", userName=" + session.getAttribute("userName"));

        // For staff, fetch staffType
        if ("staff".equalsIgnoreCase(account.getRole())) {
            StaffDAO staffDAO = new StaffDAO();
            Staff staff = staffDAO.getStaffById(account.getAccountID());
            if (staff != null) {
                session.setAttribute("staffType", staff.getStaffType());
                System.out.println("Staff type set in session: " + staff.getStaffType());
            } else {
                System.out.println("Staff record not found for accountID: " + account.getAccountID());
                session.invalidate();
                request.setAttribute("error", "Invalid account, please try again.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/home"); // Sử dụng contextPath để tránh lỗi hard-code
    }
}