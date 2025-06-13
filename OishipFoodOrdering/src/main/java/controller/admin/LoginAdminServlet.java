package controller.admin;

import dao.AdminDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Admin;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet(name = "LoginAdminServlet", urlPatterns = {"/admin/login"})
public class LoginAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Xóa session cũ
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/login_admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Đảm bảo mã hóa UTF-8

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Admin login attempt: email=" + email + ", password length=" + (password != null ? password.length() : 0));

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            System.out.println("Admin login failed: Missing email or password");
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login_admin.jsp").forward(request, response);
            return;
        }

        AdminDAO adminDAO = new AdminDAO();
        Admin admin = adminDAO.getAdminByEmail(email.trim());

        if (admin == null) {
            System.out.println("Admin login failed: No admin found for email=" + email);
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login_admin.jsp").forward(request, response);
            return;
        }

        System.out.println("Admin found: email=" + admin.getEmail() + ", hashed password=" + (admin.getPassword() != null ? admin.getPassword().substring(0, 10) + "..." : "null"));
        if (!BCrypt.checkpw(password, admin.getPassword())) {
            System.out.println("Admin login failed: Invalid password for email=" + email + ", input hash=" + BCrypt.hashpw(password, BCrypt.gensalt(12)).substring(0, 10) + "...");
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/WEB-INF/views/admin/login_admin.jsp").forward(request, response);
            return;
        }

        // Login successful
        HttpSession session = request.getSession(true);
        session.setAttribute("admin", admin);
        session.setAttribute("role", admin.getRole()); // Sử dụng role từ model
        session.setAttribute("userId", admin.getAdminId());
        session.setAttribute("userName", admin.getFullName());
        System.out.println("Admin login successful: email=" + email + ", adminId=" + admin.getAdminId() + ", role=" + admin.getRole() + ", userName=" + admin.getFullName());

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}