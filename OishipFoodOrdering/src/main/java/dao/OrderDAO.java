package dao;

import model.Order;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    public OrderDAO() {
        super();
    }

    public List<Order> getPendingOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.orderID, o.amount, o.orderStatus, o.paymentStatus, o.orderCreatedAt, o.orderUpdatedAt, " +
                     "o.deliveryAddress, o.deliveryTime, o.FK_Order_Customer, o.FK_Order_Voucher, o.FK_Order_Staff " +
                     "FROM [Order] o WHERE o.orderStatus = 0";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("orderID"),
                        rs.getDouble("amount"),
                        rs.getInt("orderStatus"),
                        rs.getInt("paymentStatus"),
                        rs.getTimestamp("orderCreatedAt"),
                        rs.getTimestamp("orderUpdatedAt"),
                        rs.getString("deliveryAddress"),
                        rs.getTimestamp("deliveryTime"),
                        rs.getObject("FK_Order_Voucher") != null ? rs.getInt("FK_Order_Voucher") : null,
                        rs.getInt("FK_Order_Customer"),
                        rs.getObject("FK_Order_Staff") != null ? rs.getInt("FK_Order_Staff") : null
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching pending orders: " + e.getMessage(), e);
            throw e;
        }
        return orders;
    }

    public void updateOrderStatus(int orderId, int status, int staffId) throws SQLException {
        if (status < 0 || status > 6) {
            throw new IllegalArgumentException("Invalid order status: " + status);
        }
        String sql = "UPDATE [Order] SET orderStatus = ?, orderUpdatedAt = GETDATE(), FK_Order_Staff = ? WHERE orderID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, staffId);
            ps.setInt(3, orderId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No order found with ID: " + orderId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating order status for orderId=" + orderId + ": " + e.getMessage(), e);
            throw e;
        }
    }

    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT o.orderID, o.amount, o.orderStatus, o.paymentStatus, o.orderCreatedAt, o.orderUpdatedAt, " +
                     "o.deliveryAddress, o.deliveryTime, o.FK_Order_Customer, o.FK_Order_Voucher, o.FK_Order_Staff " +
                     "FROM [Order] o WHERE o.orderID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Order(
                            rs.getInt("orderID"),
                            rs.getDouble("amount"),
                            rs.getInt("orderStatus"),
                            rs.getInt("paymentStatus"),
                            rs.getTimestamp("orderCreatedAt"),
                            rs.getTimestamp("orderUpdatedAt"),
                            rs.getString("deliveryAddress"),
                            rs.getTimestamp("deliveryTime"),
                            rs.getObject("FK_Order_Voucher") != null ? rs.getInt("FK_Order_Voucher") : null,
                            rs.getInt("FK_Order_Customer"),
                            rs.getObject("FK_Order_Staff") != null ? rs.getInt("FK_Order_Staff") : null
                    );
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching order by ID " + orderId + ": " + e.getMessage(), e);
            throw e;
        }
    }
}