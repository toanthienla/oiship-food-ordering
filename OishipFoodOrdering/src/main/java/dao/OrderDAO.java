package dao;

import model.Order;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends DBContext {

    public List<Order> getPendingOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.orderID, a.fullName AS customerName, o.amount, o.orderCreatedAt, o.orderStatus "
                + "FROM [Order] o JOIN Account a ON o.FK_Order_Account = a.accountID "
                + "WHERE o.orderStatus = 0"; // Pending
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("orderID"));
                order.setCustomerName(rs.getString("customerName") != null ? rs.getString("customerName") : "Unknown");
                order.setAmount(rs.getDouble("amount")); // Sử dụng setAmount thay vì setTotalAmount để nhất quán
                order.setOrderCreatedAt(rs.getTimestamp("orderCreatedAt"));
                order.setOrderStatus(rs.getInt("orderStatus")); // Sử dụng setOrderStatus để cập nhật status chuỗi
                orders.add(order);
                System.out.println("Fetched order: ID=" + order.getOrderId() + ", Customer=" + order.getCustomerName());
            }
        } catch (SQLException e) {
            System.err.println("Error fetching pending orders: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    public void updateOrderStatus(int orderId, int status) {
        String sql = "UPDATE [Order] SET orderStatus = ?, orderUpdatedAt = GETDATE() WHERE orderID = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, orderId);
            int rowsAffected = ps.executeUpdate();
            System.out.println("Updated order status: orderId=" + orderId + ", newStatus=" + status + ", rowsAffected=" + rowsAffected);
        } catch (SQLException e) {
            System.err.println("Error updating order status for orderId=" + orderId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }
}
