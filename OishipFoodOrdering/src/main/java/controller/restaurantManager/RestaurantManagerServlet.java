// RestaurantManagerServlet.java
package controller.restaurantManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "RestaurantServlet", urlPatterns = {"/restaurant"})
public class RestaurantManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"restaurant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/restaurantManager/restaurantManager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Restaurant Dashboard Servlet";
    }
}
