package dao;

import model.Order;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Dish;
import model.OrderDetail;

public class OrderDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    public OrderDAO() {
        super();
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM [Order] ORDER BY orderCreatedAt DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("orderID"));
                order.setAmount(rs.getBigDecimal("amount"));
                order.setOrderStatus(rs.getInt("orderStatus"));
                order.setPaymentStatus(rs.getInt("paymentStatus"));
                order.setOrderCreatedAt(rs.getTimestamp("orderCreatedAt"));
                order.setOrderUpdatedAt(rs.getTimestamp("orderUpdatedAt"));
                order.setVoucherID(rs.getInt("FK_Order_Voucher"));
                order.setCustomerID(rs.getInt("FK_Order_Customer"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    

    public static void main(String[] args) {
//        OrderDAO dao = new OrderDAO();
//        List<Order> orders = dao.getAllOrders();
//
//        if (orders.isEmpty()) {
//            System.out.println("No orders found.");
//        } else {
//            for (Order order : orders) {
//                System.out.println("Order ID: " + order.getOrderID());
//                System.out.println("Customer ID: " + order.getCustomerID());
//                System.out.println("Amount: " + order.getAmount());
//                System.out.println("Order Status: " + order.getOrderStatus());
//                System.out.println("Payment Status: " + order.getPaymentStatus());
//                System.out.println("Created At: " + order.getOrderCreatedAt());
//                System.out.println("Updated At: " + order.getOrderUpdatedAt());
//                System.out.println("Voucher ID: " + order.getVoucherID());
//                System.out.println("-----------");
//            }
//        }
    }
}
