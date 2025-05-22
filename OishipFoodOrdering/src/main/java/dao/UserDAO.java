package dao;

import utils.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO extends DBContext {
    /**
     * Get status_id by user (customer, shipper, restaurant)
     */
    public int getStatusId(String role, int userId) {
        String table = null;
        String idColumn = null;

        role = role.toLowerCase();
        if ("customer".equals(role)) {
            table = "Customer";
            idColumn = "customer_id";
        } else if ("shipper".equals(role)) {
            table = "Shipper";
            idColumn = "shipper_id";
        } else if ("restaurant".equals(role)) {
            table = "RestaurantManager";
            idColumn = "restaurantmanager_id";
        } else {
            System.err.println("❌ Invalid role for getStatusId: " + role);
            return -1;
        }

        String sql = "SELECT status_id FROM " + table + " WHERE " + idColumn + " = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("status_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error fetching status_id: " + e.getMessage());
        }
        return -1;
    }

    /*
     * Update status_id by user (customer, shipper, restaurant)
     * 0: inactive, 1: active, 2: blocked
     */
    public boolean updateStatus(String role, int userId, int statusId) {
        String table = null;
        String idColumn = null;

        role = role.toLowerCase();
        if ("customer".equals(role)) {
            table = "Customer";
            idColumn = "customer_id";
        } else if ("shipper".equals(role)) {
            table = "Shipper";
            idColumn = "shipper_id";
        } else if ("restaurant".equals(role)) {
            table = "RestaurantManager";
            idColumn = "restaurantmanager_id";
        } else {
            System.err.println("❌ Invalid role for updateStatus: " + role);
            return false;
        }

        String sql = "UPDATE " + table + " SET status_id = ? WHERE " + idColumn + " = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, statusId);
            stmt.setInt(2, userId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error updating status: " + e.getMessage());
        }
        return false;
    }
}
