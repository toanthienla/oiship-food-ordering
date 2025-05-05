package controller.user;

import dao.RestaurantManagerDAO;
import dao.ShipperDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.RestaurantManager;
import model.Shipper;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PendingAccountsServlet", urlPatterns = {"/pending-accounts"})
public class PendingAccountsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        // Lấy danh sách các tài khoản đang chờ duyệt
        ShipperDAO shipperDAO = new ShipperDAO();
        RestaurantManagerDAO restaurantDAO = new RestaurantManagerDAO();

        List<Shipper> pendingShippers = shipperDAO.getPendingShippers(); // status_id = 2
        List<RestaurantManager> pendingRestaurants = restaurantDAO.getPendingRestaurants(); // status_id = 2

        request.setAttribute("shippers", pendingShippers);
        request.setAttribute("restaurants", pendingRestaurants);

        // Forward tới trang JSP hiển thị danh sách
        request.getRequestDispatcher("/WEB-INF/views/pendingAccounts/admin_pending.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type"); // shipper or restaurant
        int id = Integer.parseInt(request.getParameter("id"));
        int newStatus = Integer.parseInt(request.getParameter("status"));

        if ("shipper".equalsIgnoreCase(type)) {
            new ShipperDAO().updateStatus(id, newStatus);
        } else if ("restaurant".equalsIgnoreCase(type)) {
            new RestaurantManagerDAO().updateStatus(id, newStatus);
        }

        // Sau khi duyệt, load lại trang
        response.sendRedirect("pending-accounts");
    }

    @Override
    public String getServletInfo() {
        return "Handles pending account approvals for admin";
    }
}
