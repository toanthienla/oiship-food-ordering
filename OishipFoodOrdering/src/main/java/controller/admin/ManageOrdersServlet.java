package controller.admin;

import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Order;

@WebServlet(urlPatterns = { "/admin/manage-orders" })
public class ManageOrdersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get order list
        OrderDAO orderDAO = new OrderDAO();
        List<Order> orderList = orderDAO.getAllOrders();

        // Create a map to store order income
        Map<Integer, String> orderIncomeMap = new HashMap<>();
        Map<Integer, BigDecimal> orderIncomeRawMap = new HashMap<>();
        
        // Calculate income for each order
        for (Order order : orderList) {
            int orderId = order.getOrderID();
            
            // Get formatted income for display
            String formattedIncome = orderDAO.getFormattedOrderIncome(orderId);
            orderIncomeMap.put(orderId, formattedIncome);
            
            // Get raw income value for calculations if needed
            BigDecimal rawIncome = orderDAO.getOrderIncomeByOrderId(orderId);
            orderIncomeRawMap.put(orderId, rawIncome);
        }

        // Status maps
        Map<Integer, String> statusMap = new LinkedHashMap<>();
        statusMap.put(0, "Pending");
        statusMap.put(1, "Confirmed");
        statusMap.put(2, "Preparing");
        statusMap.put(3, "Out for Delivery");
        statusMap.put(4, "Delivered");
        statusMap.put(5, "Cancelled");
        statusMap.put(6, "Failed");

        Map<Integer, String> paymentStatusMap = new LinkedHashMap<>();
        paymentStatusMap.put(0, "Unpaid");
        paymentStatusMap.put(1, "Paid");
        paymentStatusMap.put(2, "Refunded");

        // Set attributes
        request.setAttribute("orders", orderList);
        request.setAttribute("statusMap", statusMap);
        request.setAttribute("paymentStatusMap", paymentStatusMap);
        request.setAttribute("orderIncomeMap", orderIncomeMap);
        request.setAttribute("orderIncomeRawMap", orderIncomeRawMap);

        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/views/admin/manage_orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String statusStr = request.getParameter("status");
            String paymentStatusStr = request.getParameter("paymentStatus");

            Integer accountID = (Integer) request.getSession().getAttribute("userId");

            if (accountID == null) {
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }

            OrderDAO dao = new OrderDAO();
            
            // Update order status if provided
            if (statusStr != null) {
                int newStatus = Integer.parseInt(statusStr);
                dao.updateStatusOrderByOrderId(orderId, newStatus, accountID);
            }

            // Update payment status if provided
            if (paymentStatusStr != null) {
                int newPaymentStatus = Integer.parseInt(paymentStatusStr);
                dao.updatePaymentStatusByOrderId(orderId, newPaymentStatus, accountID);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to the list
        response.sendRedirect(request.getContextPath() + "/admin/manage-orders");
    }
}