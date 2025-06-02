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
        if (session == null || session.getAttribute("userId") == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            System.out.println("AdminDashboardServlet: Unauthorized access, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("AdminDashboardServlet: Rendering admin dashboard for userId=" + session.getAttribute("userId"));
        request.getRequestDispatcher("/WEB-INF/views/admin/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}