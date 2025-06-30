package controller.staff;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import controller.admin.*;
import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Order;

/**
 *
 * @author XPS
 */
@WebServlet(urlPatterns = {"/staff/manage-orders"})
public class ManageOrdersServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ManageCategoriesServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageCategoriesServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Gọi DAO để lấy danh sách đơn hàng
        OrderDAO orderDAO = new OrderDAO();
        List<Order> orderList = orderDAO.getAllOrders();

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

        request.setAttribute("orders", orderList);
        request.setAttribute("statusMap", statusMap);
        request.setAttribute("paymentStatusMap", paymentStatusMap);

        // Chuyển tiếp sang JSP để hiển thị
        request.getRequestDispatcher("/WEB-INF/views/staff/manage_orders.jsp").forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String statusStr = request.getParameter("status");
            String paymentStatusStr = request.getParameter("paymentStatus");

            OrderDAO dao = new OrderDAO();
            // Nếu có thay đổi order status
            if (statusStr != null) {
                int newStatus = Integer.parseInt(statusStr);
                dao.updateStatusOrderByOrderId(orderId, newStatus);
            }

            // Nếu có thay đổi payment status
            if (paymentStatusStr != null) {
                int newPaymentStatus = Integer.parseInt(paymentStatusStr);
                dao.updatePaymentStatusByOrderId(orderId, newPaymentStatus);
            }

            // Có thể log kết quả hoặc set attribute để hiển thị
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect về lại danh sách
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
    }// </editor-fold>

}
