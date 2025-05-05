package dao;

import model.ShipperFee;
import model.RestaurantFee;
import model.OrderNotification;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO extends DBContext {

    // SHIPPER FEES
    public boolean insertShipperFee(ShipperFee fee) {
        String sql = "INSERT INTO ShipperFee (shipper_id, order_id, fee_amount, fee_type, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, fee.getShipperId());
            stmt.setInt(2, fee.getOrderId());
            stmt.setDouble(3, fee.getFeeAmount());
            stmt.setString(4, fee.getFeeType());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }

    public List<ShipperFee> getAllShipperFees() {
        List<ShipperFee> list = new ArrayList<>();
        String sql = "SELECT * FROM ShipperFee ORDER BY created_at DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ShipperFee fee = new ShipperFee();
                fee.setFeeId(rs.getInt("fee_id"));
                fee.setShipperId(rs.getInt("shipper_id"));
                fee.setOrderId(rs.getInt("order_id"));
                fee.setFeeAmount(rs.getDouble("fee_amount"));
                fee.setFeeType(rs.getString("fee_type"));
                fee.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(fee);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    // RESTAURANT FEES
    public boolean insertRestaurantFee(RestaurantFee fee) {
        String sql = "INSERT INTO RestaurantFee (restaurantmanager_id, order_id, fee_amount, fee_type, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, fee.getRestaurantId());
            stmt.setInt(2, fee.getOrderId());
            stmt.setDouble(3, fee.getFeeAmount());
            stmt.setString(4, fee.getFeeType());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }

    public List<RestaurantFee> getAllRestaurantFees() {
        List<RestaurantFee> list = new ArrayList<>();
        String sql = "SELECT * FROM RestaurantFee ORDER BY created_at DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                RestaurantFee fee = new RestaurantFee();
                fee.setFeeId(rs.getInt("fee_id"));
                fee.setRestaurantId(rs.getInt("restaurantmanager_id"));
                fee.setOrderId(rs.getInt("order_id"));
                fee.setFeeAmount(rs.getDouble("fee_amount"));
                fee.setFeeType(rs.getString("fee_type"));
                fee.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(fee);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    // ORDER NOTIFICATIONS
    public boolean insertCustomerNotification(OrderNotification notification) {
        String sql = "INSERT INTO OrderNotification (order_id, customer_id, message, notification_type, is_read, created_at) VALUES (?, ?, ?, ?, 0, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notification.getOrderId());
            stmt.setInt(2, notification.getCustomerId());
            stmt.setString(3, notification.getMessage());
            stmt.setString(4, notification.getNotificationType());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }

    public boolean insertShipperNotification(OrderNotification notification) {
        String sql = "INSERT INTO OrderNotification (order_id, shipper_id, message, notification_type, is_read, created_at) VALUES (?, ?, ?, ?, 0, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notification.getOrderId());
            stmt.setInt(2, notification.getShipperId());
            stmt.setString(3, notification.getMessage());
            stmt.setString(4, notification.getNotificationType());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }

    public boolean insertRestaurantNotification(OrderNotification notification) {
        String sql = "INSERT INTO OrderNotification (order_id, restaurantmanager_id, message, notification_type, is_read, created_at) VALUES (?, ?, ?, ?, 0, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notification.getOrderId());
            stmt.setInt(2, notification.getRestaurantManagerId());
            stmt.setString(3, notification.getMessage());
            stmt.setString(4, notification.getNotificationType());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }

    public List<OrderNotification> getCustomerNotifications(int customerId) {
        List<OrderNotification> list = new ArrayList<>();
        String sql = "SELECT * FROM OrderNotification WHERE customer_id = ? ORDER BY created_at DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OrderNotification noti = new OrderNotification();
                noti.setNotificationId(rs.getInt("notification_id"));
                noti.setOrderId(rs.getInt("order_id"));
                noti.setCustomerId(rs.getInt("customer_id"));
                noti.setMessage(rs.getString("message"));
                noti.setNotificationType(rs.getString("notification_type"));
                noti.setRead(rs.getBoolean("is_read"));
                noti.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(noti);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    public boolean markNotificationAsRead(int notificationId) {
        String sql = "UPDATE OrderNotification SET is_read = 1 WHERE notification_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }

    public Double getTotalPaymentForShipper(int shipperId) {
        String sql = "SELECT SUM(fee_amount) AS total FROM ShipperFee WHERE shipper_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, shipperId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
        }
        return 0.0;
    }

    public Double getTotalPaymentForRestaurant(int restaurantManagerId) {
        String sql = "SELECT SUM(fee_amount) AS total FROM RestaurantFee WHERE restaurantmanager_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, restaurantManagerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
        }
        return 0.0;
    }

}
