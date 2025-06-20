package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        System.out.println("DEBUG: AdminDashboardServlet - Session exists: " + (session != null)
                + ", adminId=" + (session != null ? session.getAttribute("adminId") : "null")
                + ", role=" + (session != null ? session.getAttribute("role") : "null"));

        if (session == null || session.getAttribute("adminId") == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            System.out.println("AdminDashboardServlet: Unauthorized access, redirecting to admin login");
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        System.out.println("AdminDashboardServlet: Rendering admin dashboard for adminId=" + session.getAttribute("adminId"));
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard_admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
