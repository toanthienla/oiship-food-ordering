package dao;

import model.Customer; // Hoặc model.Staff nếu có bảng Staff riêng
import model.Account;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Order;
import model.Staff;

public class StaffDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(StaffDAO.class.getName());

    public StaffDAO() {
        super();
    }

        public Staff getStaffByEmail(String email) {
        LOGGER.info("Attempting to retrieve staff with email: " + email);
        if (email == null || email.trim().isEmpty()) {
            LOGGER.warning("Invalid email: " + email);
            return null;
        }
        String sql = "SELECT accountID AS staffID, fullName, email, [password], role, createAt " +
                     "FROM Account WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Staff staff = new Staff(
                            rs.getInt("staffID"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getString("role"),
                            rs.getTimestamp("createAt")
                    );
                    LOGGER.info("Staff found: " + staff.toString());
                    return staff;
                } else {
                    LOGGER.warning("No staff found for email: " + email);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving staff by email: " + e.getMessage(), e);
        }
        return null;
    }

    public List<Order> getPendingOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT orderID, amount, orderStatus, paymentStatus, orderCreatedAt, orderUpdatedAt, deliveryAddress, deliveryTime "
                + "FROM [Order] WHERE orderStatus = 0";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
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
                        null // FK_Order_Staff
                );
                orders.add(order);
            }
        }
        return orders;
    }

    public void updateOrderStatus(int orderId, int status, int staffId) throws SQLException {
        String sql = "UPDATE [Order] SET orderStatus = ?, orderUpdatedAt = GETDATE(), FK_Order_Staff = ? WHERE orderID = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, status);
            stmt.setInt(2, staffId);
            stmt.setInt(3, orderId);
            stmt.executeUpdate();
        }
    }

        public static void main(String[] args) {
        
//        StaffDAO staffDAO = new StaffDAO();
//        String email = "staff@example.com";
//        Staff staff = staffDAO.getStaffByEmail(email);
//        if (staff != null) {
//            System.out.println("Staff found:");
//            System.out.println("Account ID: " + staff.getAccountID());
//            System.out.println("Full Name: " + staff.getFullName());
//            System.out.println("Email: " + staff.getEmail());
//            System.out.println("Role: " + staff.getRole());
//            System.out.println("Created At: " + staff.getCreateAt());
//            System.out.println("ToString: " + staff.toString());
//        } else {
//            System.out.println("No staff found for email: " + email);
//        }
    }

}


