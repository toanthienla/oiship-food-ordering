package controller.home;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = null;
        Integer userId = null;
        String userName = null;

        // Set default attributes for home.jsp
        request.setAttribute("isLoggedIn", false);
        request.setAttribute("role", null);
        request.setAttribute("userId", null);
        request.setAttribute("userName", null);
        request.setAttribute("error", null);

        if (session != null) {
            userId = (Integer) session.getAttribute("userId");
            role = (String) session.getAttribute("role");
            userName = (String) session.getAttribute("userName");
            System.out.println("HomeServlet: session exists, userId=" + userId + ", role=" + role + ", userName=" + userName);
        } else {
            System.out.println("HomeServlet: No session exists");
        }

        if (userId == null || role == null) {
            System.out.println("HomeServlet: User not logged in or session invalid");
            request.setAttribute("isLoggedIn", false);
            request.getRequestDispatcher("/WEB-INF/views/home/home.jsp").forward(request, response);
            return;
        }

        // Set attributes for logged-in user
        request.setAttribute("isLoggedIn", true);
        request.setAttribute("role", role);
        request.setAttribute("userId", userId);
        request.setAttribute("userName", userName != null ? userName : "Unknown");
        System.out.println("HomeServlet: Setting attributes - isLoggedIn=true, userName=" + userName);

        // Redirect based on role
        if ("staff".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/staff"); // Redirect to a generic staff page
        } else {
            response.sendRedirect(request.getContextPath() + "/customer");
        }
    }
}