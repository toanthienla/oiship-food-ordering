package controller.staff; // Sửa từ contronller thành controller

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "InventoryStaffServlet", urlPatterns = {"/ingredient-staff"})
public class IngredientStaffServlet extends HttpServlet { // Đổi tên class thành chuẩn

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null || !"ingredientStaff".equals(session.getAttribute("staffType"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/staff/ingredientStaff/ingredientStaff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle inventory updates (e.g., update stock)
        // Implement as needed
        doGet(request, response);
    }
}
