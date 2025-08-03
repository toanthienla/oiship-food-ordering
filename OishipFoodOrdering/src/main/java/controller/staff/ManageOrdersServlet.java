package controller.staff;

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

/**
 *
 * @author XPS
 */
@WebServlet(urlPatterns = { "/staff/manage-orders" })
public class ManageOrdersServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ManageOrdersServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageOrdersServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get order list
        OrderDAO orderDAO = new OrderDAO();
        List<Order> orderList = orderDAO.getAllOrders();

        // Create a map to store order profits
        Map<Integer, String> orderProfitMap = new HashMap<>();
        Map<Integer, BigDecimal> orderProfitRawMap = new HashMap<>();
        
        // Calculate profit for each order
        for (Order order : orderList) {
            int orderId = order.getOrderID();
            
            // Get formatted profit for display
            String formattedProfit = orderDAO.getFormattedOrderProfit(orderId);
            orderProfitMap.put(orderId, formattedProfit);
            
            // Get raw profit value for calculations if needed
            BigDecimal rawProfit = orderDAO.getOrderProfitByOrderId(orderId);
            orderProfitRawMap.put(orderId, rawProfit);
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

        // Map cho trạng thái thanh toán
        Map<Integer, String> paymentStatusMap = new LinkedHashMap<>();
        paymentStatusMap.put(0, "Unpaid");
        paymentStatusMap.put(1, "Paid");
        paymentStatusMap.put(2, "Refunded");

        // Set attributes
        request.setAttribute("orders", orderList);
        request.setAttribute("statusMap", statusMap);
        request.setAttribute("paymentStatusMap", paymentStatusMap);
        request.setAttribute("orderProfitMap", orderProfitMap);
        request.setAttribute("orderProfitRawMap", orderProfitRawMap);

        // Chuyển tiếp sang JSP để hiển thị
        request.getRequestDispatcher("/WEB-INF/views/staff/manage_orders.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String statusStr = request.getParameter("status");
            String paymentStatusStr = request.getParameter("paymentStatus");

            Integer accountID = (Integer) request.getSession().getAttribute("userId");

            if (accountID == null) {
                response.sendRedirect(request.getContextPath() + "/login");
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
        response.sendRedirect(request.getContextPath() + "/staff/manage-orders");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}