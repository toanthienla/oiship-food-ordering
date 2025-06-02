package contronller.staff;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Order;

@WebServlet(name = "SellerStaffServlet", urlPatterns = {"/seller-staff"})
public class SellerStaffServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"sellerStaff".equals(session.getAttribute("staffType"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/staff/sellerStaff/sellerStaff.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        OrderDAO orderDAO = new OrderDAO();

        if ("process".equals(action)) {
            orderDAO.updateOrderStatus(orderId, 1); // Confirmed
            request.setAttribute("message", "Đơn hàng đã được xử lý.");
        } else if ("complete".equals(action)) {
            orderDAO.updateOrderStatus(orderId, 3); // Delivered
            request.setAttribute("message", "Đơn hàng đã được hoàn thành.");
        }

        // Refresh orders list
        List<Order> orders = orderDAO.getPendingOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/views/staff/sellerStaff.jsp").forward(request, response);
    }
}
