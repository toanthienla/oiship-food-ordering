package controller.customer;

import dao.CartDAO;
import dao.CustomerDAO;
import dao.NotificationDAO;
import dao.OrderDAO;
import dao.VoucherDAO;
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
import model.Voucher;
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
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orderList = orderDAO.getAllOrdersWithDetailsByCustomerId(customerId);

            // ✅ Chuẩn bị mô tả trạng thái để hiển thị đẹp ở JSP
            String[] orderStatusText = {
                "Pending", "Confirmed", "Preparing", "Out for Delivery",
                "Delivered", "Cancelled", "Failed"
            };

            String[] paymentStatusText = {
                "Unpaid", "Paid", "Refunded"
            };

            request.setAttribute("orderHistory", orderList);
            request.setAttribute("orderStatusText", orderStatusText);
            request.setAttribute("paymentStatusText", paymentStatusText);

            request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể hiển thị lịch sử đơn hàng.");
            request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerByEmail(email);
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("confirm".equals(action)) {
            // Giai đoạn 2: xác nhận -> lưu đơn hàng
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
                    grandTotal = grandTotal.add(dishPrice.multiply(BigDecimal.valueOf(cart.getQuantity())));
                }

                int orderId = orderDAO.createOrder(customer.getCustomerID(), grandTotal);
                for (Cart cart : selectedCarts) {
                    orderDAO.addOrderDetail(orderId, cart.getDish().getDishID(), cart.getQuantity());
                }

                // Optionally: xóa cart
                // cartDAO.deleteCartsByIDs(selectedCartIDs);
                request.setAttribute("message", "Đặt hàng thành công!");
                response.sendRedirect(request.getContextPath() + "/customer/order");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Có lỗi xảy ra khi xác nhận đơn hàng.");
                request.getRequestDispatcher("/WEB-INF/views/customer/confirm_order.jsp").forward(request, response);
            }

        } else {

            // Giai đoạn 1: chuẩn bị xác nhận
            String[] selectedCartIDs = request.getParameterValues("selectedItems");
            if (selectedCartIDs == null || selectedCartIDs.length == 0) {
                request.setAttribute("error", "Please select at least one item to order.");
                request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);
                return;
            }

            try {
                CartDAO cartDAO = new CartDAO();
                List<Cart> selectedCarts = cartDAO.getCartsByIDs(selectedCartIDs);
                BigDecimal grandTotal = BigDecimal.ZERO;

                for (Cart cart : selectedCarts) {
                    Dish dish = cart.getDish();
                    BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(dish.getIngredients());
                    BigDecimal dishPrice = TotalPriceCalculator.calculateTotalPrice(
                            dish.getOpCost(), dish.getInterestPercentage(), ingredientCost);
                    BigDecimal itemTotal = dishPrice.multiply(BigDecimal.valueOf(cart.getQuantity()));
                    cart.getDish().setTotalPrice(dishPrice); // lưu lại để JSP dùng
                    grandTotal = grandTotal.add(itemTotal);
                }
                VoucherDAO voucherDAO = new VoucherDAO();
                List<Voucher> vouchers = voucherDAO.getAllVouchers();
                request.setAttribute("selectedCarts", selectedCarts);
                request.setAttribute("grandTotal", grandTotal);
                request.setAttribute("selectedCartIDs", selectedCartIDs);
                request.setAttribute("vouchers", vouchers);
                request.getRequestDispatcher("/WEB-INF/views/customer/confirm_order.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Không thể xử lý đơn hàng.");
                request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "OrderServlet handles placing orders";
    }
}
