package controller.customer;

import dao.CartDAO;
import dao.CustomerDAO;
import dao.NotificationDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Cart;
import model.Customer;
import model.Dish;
import model.Notification;
import model.Order;
import model.OrderDetail;
import utils.TotalPriceCalculator;

@WebServlet(name = "OrderServlet", urlPatterns = {"/customer/order"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int customerId = (int) session.getAttribute("userId");

        try {
            OrderDAO orderDAO = new OrderDAO(); // ✅ tạo đối tượng DAO
            List<Order> orderList = orderDAO.getAllOrdersWithDetailsByCustomerId(customerId); // ✅ gọi đúng cách
            request.setAttribute("orderHistory", orderList);
            request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể hiển thị giỏ hàng.");
            request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        // Kiểm tra đăng nhập
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy thông tin khách hàng
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerByEmail(email);
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String[] selectedCartIDs = request.getParameterValues("selectedItems");
        if (selectedCartIDs == null || selectedCartIDs.length == 0) {
            request.setAttribute("error", "Please select at least one item to order.");
            request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);
            return;
        }

        try {
            int customerId = customer.getCustomerID();
            CartDAO cartDAO = new CartDAO();
            OrderDAO orderDAO = new OrderDAO();

            List<Cart> selectedCarts = cartDAO.getCartsByIDs(selectedCartIDs);
            BigDecimal grandTotal = BigDecimal.ZERO;

            for (Cart cart : selectedCarts) {
                Dish dish = cart.getDish();
                BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(dish.getIngredients());
                BigDecimal dishPrice = TotalPriceCalculator.calculateTotalPrice(
                        dish.getOpCost(), dish.getInterestPercentage(), ingredientCost);           
                // Tính tổng đơn hàng
                grandTotal = grandTotal.add(dishPrice.multiply(BigDecimal.valueOf(cart.getQuantity())));
                
              ;

            }

            int orderId = orderDAO.createOrder(customerId, grandTotal);

            for (Cart cart : selectedCarts) {
                orderDAO.addOrderDetail(orderId, cart.getDish().getDishID(), cart.getQuantity());
            }

            // cartDAO.deleteCartsByIDs(selectedCartIDs);
            int userId = customer.getCustomerID();
            List<Order> orderHistory = orderDAO.getAllOrdersWithDetailsByCustomerId(userId);

            request.setAttribute("orderHistory", orderHistory);
       

            request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong while placing your order.");
            request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "OrderServlet handles placing orders";
    }
}
