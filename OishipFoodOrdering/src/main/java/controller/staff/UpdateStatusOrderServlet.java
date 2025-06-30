/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.OrderDetail;

/**
 *
 * @author HCT
 */
@WebServlet(name = "UpdateStatusOrderServlet", urlPatterns = {"/staff/manage-orders/update-status"})
public class UpdateStatusOrderServlet extends HttpServlet {

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
            out.println("<title>Servlet UpdateStatusOrderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateStatusOrderServlet at " + request.getContextPath() + "</h1>");
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
        try {
            String orderIDParam = request.getParameter("orderID");

            if (orderIDParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing orderID");
                return;
            }

            int orderID = Integer.parseInt(orderIDParam);
            OrderDAO dao = new OrderDAO();

            int orderStatus = dao.getOrderStatusByOrderId(orderID);
            int paymentStatus = dao.getPaymentStatusByOrderId(orderID);
            List<OrderDetail> details = dao.getOrderDetailsByOrderID(orderID);

            request.setAttribute("orderID", orderID);
            request.setAttribute("orderStatus", orderStatus);
            request.setAttribute("paymentStatus", paymentStatus);
            request.setAttribute("orderDetails", details);

            request.getRequestDispatcher("/WEB-INF/views/staff/order_status_update.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/manage-orders?error=invalidOrderID");
        }

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
            String orderIDParam = request.getParameter("orderID");
            String newStatusParam = request.getParameter("newStatus");
            String newPaymentStatusParam = request.getParameter("newPaymentStatus");

            if (orderIDParam == null || newStatusParam == null || newPaymentStatusParam == null
                    || orderIDParam.trim().isEmpty() || newStatusParam.trim().isEmpty() || newPaymentStatusParam.trim().isEmpty()) {
                request.setAttribute("message", "Error: Missing order ID, status or payment status.");
                request.getRequestDispatcher("/WEB-INF/views/staff/order_status_update.jsp").forward(request, response);
                return;
            }

            int orderID = Integer.parseInt(orderIDParam);
            int newStatus = Integer.parseInt(newStatusParam);
            int newPaymentStatus = Integer.parseInt(newPaymentStatusParam);

            OrderDAO dao = new OrderDAO();
            boolean statusSuccess = dao.updateStatusOrderByOrderId(orderID, newStatus);
            boolean paymentSuccess = dao.updatePaymentStatusByOrderId(orderID, newPaymentStatus);

            // Lấy lại dữ liệu để hiển thị
            int orderStatus = dao.getOrderStatusByOrderId(orderID);
            int paymentStatus = dao.getPaymentStatusByOrderId(orderID);
            List<OrderDetail> details = dao.getOrderDetailsByOrderID(orderID);

            request.setAttribute("orderID", orderID);
            request.setAttribute("orderStatus", orderStatus);
            request.setAttribute("paymentStatus", paymentStatus);
            request.setAttribute("orderDetails", details);

            if (statusSuccess || paymentSuccess) {
                request.setAttribute("message", "Order updated successfully!");
            } else {
                request.setAttribute("message", "No changes were made.");
            }

            response.sendRedirect(request.getContextPath() + "/staff/manage-orders/update-status?orderID=" + orderID);

        } catch (NumberFormatException e) {
            request.setAttribute("message", "Error: Invalid order ID or status format.");
            request.getRequestDispatcher("/WEB-INF/views/staff/order_status_update.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: An unexpected error occurred.");
            request.getRequestDispatcher("/WEB-INF/views/staff/order_status_update.jsp").forward(request, response);
        }
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
