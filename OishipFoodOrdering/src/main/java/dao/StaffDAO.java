package dao;

import model.Customer; // Hoặc model.Staff nếu có bảng Staff riêng
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Order;

public class StaffDAO extends DBContext {
    private static final Logger LOGGER = Logger.getLogger(StaffDAO.class.getName());

    public StaffDAO() {
        super();
    }

    // Phương thức getStaffById để lấy thông tin Staff dựa trên customerID
    public Customer getStaffById(int customerId) {
        if (customerId <= 0) {
            LOGGER.warning("getStaffById: invalid customerId=" + customerId);
            return null;
        }
        String sql = "SELECT customerID, fullName, email, role, createAt, status, phone, address " +
                     "FROM Customer WHERE customerID = ? AND role = 'staff'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("customerID"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            "", // Password không cần lấy
                            rs.getString("role"),
                            rs.getTimestamp("createAt"),
                            rs.getInt("status"),
                            rs.getString("phone") != null ? rs.getString("phone") : "",
                            rs.getString("address") != null ? rs.getString("address") : ""
                    );
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving staff by ID: " + e.getMessage(), e);
        }
        return null;
    }

    public List<Order> getPendingOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT orderID, amount, orderStatus, paymentStatus, orderCreatedAt, orderUpdatedAt, deliveryAddress, deliveryTime " +
                     "FROM [Order] WHERE orderStatus = 0";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
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
                    null, // FK_Order_Voucher
                    null, // FK_Order_Customer
                    null  // FK_Order_Staff
                );
                orders.add(order);
            }
        }
        return orders;
    }

    public void updateOrderStatus(int orderId, int status, int staffId) throws SQLException {
        String sql = "UPDATE [Order] SET orderStatus = ?, orderUpdatedAt = GETDATE(), FK_Order_Staff = ? WHERE orderID = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, status);
            stmt.setInt(2, staffId);
            stmt.setInt(3, orderId);
            stmt.executeUpdate();
        }
    }
    
    
}