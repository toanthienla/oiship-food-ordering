package controller.admin;

import dao.AdminDAO;
import dao.SecurityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Admin;

import java.io.IOException;

@WebServlet(name = "LoginAdminServlet", urlPatterns = {"/admin/login"})
public class LoginAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/login_admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Admin login attempt: email=" + email + ", time=" + new java.util.Date());

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            System.out.println("Admin login failed: Missing or empty email or password");
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login_admin.jsp").forward(request, response);
            return;
        }

        AdminDAO adminDAO = new AdminDAO();
        Admin admin = adminDAO.getAdminByEmail(email.trim());
        System.out.println("DEBUG: Admin found - " + (admin != null ? "Yes, ID: " + admin.getAdminId() : "No"));

        if (admin == null) {
            System.out.println("Admin login failed: No admin found for email=" + email);
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login_admin.jsp").forward(request, response);
            return;
        }

        if (!SecurityDAO.checkPassword(password, admin.getPassword())) {
            System.out.println("DEBUG: Password check failed for email=" + email + ", hashed password=" + admin.getPassword());
            System.out.println("Admin login failed: Invalid password for email=" + email);
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login_admin.jsp").forward(request, response);
            return;
        }

        // Login successful
        HttpSession session = request.getSession(true);
        session.setAttribute("adminId", admin.getAdminId());
        session.setAttribute("role", "admin");
        session.setAttribute("userName", admin.getFullName());
        System.out.println("DEBUG: Session after login - adminId=" + session.getAttribute("adminId") +
                ", role=" + session.getAttribute("role") + ", userName=" + session.getAttribute("userName"));
        System.out.println("Admin login successful: email=" + email + ", adminId=" + admin.getAdminId()
                + ", role=admin, userName=" + admin.getFullName()
                + ", time=" + new java.util.Date());

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}