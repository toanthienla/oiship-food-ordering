/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

//import controller.staff.*;
import dao.AccountDAO;
import dao.CategoryDAO;
import dao.DishDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.List;
import model.Category;
import model.Dish;

/**
 *
 * @author HCT
 */
@WebServlet(name = "CreateOrderAdminServlet", urlPatterns = {"/admin/manage-orders/create-order"})
public class CreateOrderAdminServlet extends HttpServlet {

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
            out.println("<title>Servlet CreateOrderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateOrderServlet at " + request.getContextPath() + "</h1>");
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
        DishDAO dishDAO = new DishDAO();
        List<Dish> dishes = dishDAO.getAllDishes();

        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("dishes", dishes);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/WEB-INF/views/admin/order_create.jsp").forward(request, response);
    }

    private void loadAndReturn(HttpServletRequest request, HttpServletResponse response,
            String message, DishDAO dishDAO) throws ServletException, IOException {
        List<Dish> dishes = dishDAO.getAllDishes();
        request.setAttribute("dishes", dishes);
        request.setAttribute("error", message);
        request.getRequestDispatcher("/WEB-INF/views/admin/order_create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String customerName = request.getParameter("customerName");

        String message;

        AccountDAO accountDAO = new AccountDAO();
        OrderDAO orderDAO = new OrderDAO();
        DishDAO dishDAO = new DishDAO();

        // Bước 1: Tạo customer ẩn danh
        int customerID = accountDAO.insertAnonymousCustomerAndReturnCustomerID(customerName);
        if (customerID == -1) {
            message = "Failed to create customer.";
            loadAndReturn(request, response, message, dishDAO);
            return;
        }

        // Bước 2: Tạo order
        int orderID = orderDAO.insertOrder(customerID);
        if (orderID == -1) {
            message = "Failed to create order.";
            loadAndReturn(request, response, message, dishDAO);
            return;
        }

        // Bước 3: Xử lý các món ăn và tính amount
        List<Dish> dishes = dishDAO.getAllDishes();
        boolean atLeastOneDish = false;
        BigDecimal amount = BigDecimal.ZERO;

        for (Dish dish : dishes) {
            String quantityParam = request.getParameter("quantity_" + dish.getDishID());
            if (quantityParam != null) {
                try {
                    int quantity = Integer.parseInt(quantityParam);
                    if (quantity > 0) {
                        // Kiểm tra stock còn đủ không
                        if (dish.getStock() < quantity) {
                            message = "Not enough stock for dish: " + dish.getDishName();
                            loadAndReturn(request, response, message, dishDAO);
                            return;
                        }

                        // Tính tiền
                        BigDecimal price = dish.getTotalPrice();
                        BigDecimal lineTotal = price.multiply(BigDecimal.valueOf(quantity));
                        amount = amount.add(lineTotal);

                        // Thêm vào OrderDetail
                        boolean success = orderDAO.insertOrderDetail(orderID, dish.getDishID(), quantity);
                        if (!success) {
                            message = "Failed to insert order detail for dish: " + dish.getDishName();
                            loadAndReturn(request, response, message, dishDAO);
                            return;
                        }

                        // ✅ Trừ stock
                        boolean stockUpdated = dishDAO.updateStockAfterOrder(dish.getDishID(), quantity);
                        if (!stockUpdated) {
                            message = "Failed to update stock for dish: " + dish.getDishName();
                            loadAndReturn(request, response, message, dishDAO);
                            return;
                        }

                        atLeastOneDish = true;
                    }
                } catch (NumberFormatException e) {
                    message = "Invalid quantity format.";
                    loadAndReturn(request, response, message, dishDAO);
                    return;
                }
            }
        }

        if (!atLeastOneDish) {
            message = "Please enter quantity for at least one dish.";
            loadAndReturn(request, response, message, dishDAO);
            return;
        }

        // Cập nhật tổng tiền
        orderDAO.updateOrderAmount(orderID, amount);

        // Thành công
        request.setAttribute("success", "Order created successfully!");
        response.sendRedirect(request.getContextPath() + "/admin/manage-orders"); // hoặc chuyển hướng tới order-detail nếu muốn
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
