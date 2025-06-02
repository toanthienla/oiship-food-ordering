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
        String staffType = null;
        Integer userId = null;
        String userName = null;

        // Set default attributes for home.jsp
        request.setAttribute("isLoggedIn", false);
        request.setAttribute("role", null);
        request.setAttribute("staffType", null);
        request.setAttribute("userId", null);
        request.setAttribute("userName", null);
        request.setAttribute("error", null);

        if (session != null) {
            userId = (Integer) session.getAttribute("userId");
            role = (String) session.getAttribute("role");
            userName = (String) session.getAttribute("userName");
            System.out.println("HomeServlet: session exists, userId=" + userId + ", role=" + role + ", userName=" + userName);
            if ("staff".equalsIgnoreCase(role)) {
                staffType = (String) session.getAttribute("staffType");
            }
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

        if ("staff".equalsIgnoreCase(role)) {
            if (staffType == null) {
                System.out.println("No staffType in session for userId: " + userId);
                session.invalidate();
                request.setAttribute("error", "Invalid account, please try again.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                return;
            }
            System.out.println("Staff userId: " + userId + ", staffType: " + staffType);
            if ("sellerStaff".equals(staffType)) {
                response.sendRedirect(request.getContextPath() + "/seller-staff");
            } else if ("ingredientStaff".equals(staffType)) {
                response.sendRedirect(request.getContextPath() + "/ingredient-staff");
            } else {
                System.out.println("Unknown staffType: " + staffType);
                session.invalidate();
                request.setAttribute("error", "Invalid account, please try again.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/customer");
        }
    }
}
