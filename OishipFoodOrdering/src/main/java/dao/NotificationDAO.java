package dao;

import model.Notification;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO extends DBContext {

    public List<Notification> getNotificationsByAccount(int accountId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notification WHERE customer_id = ? OR restaurant_manager_id = ? OR shipper_id = ? ORDER BY notification_id DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountId);
            stmt.setInt(2, accountId);
            stmt.setInt(3, accountId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Notification n = new Notification(
                        rs.getInt("notification_id"),
                        rs.getString("noti_message"),
                        rs.getString("noti_type"),
                        rs.getBoolean("is_read"),
                        rs.getInt("order_id"),
                        rs.getInt("customer_id"),
                        rs.getInt("restaurant_manager_id"),
                        rs.getInt("shipper_id")
                );
                list.add(n);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertNotification(Notification n) {
        String sql = "INSERT INTO Notification (noti_message, noti_type, is_read, order_id, customer_id, restaurant_manager_id, shipper_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, n.getNotiMessage());
            stmt.setString(2, n.getNotiType());
            stmt.setBoolean(3, n.isRead());
            stmt.setInt(4, n.getOrderId());
            stmt.setInt(5, n.getCustomerId());
            stmt.setInt(6, n.getRestaurantManagerId());
            stmt.setInt(7, n.getShipperId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void markAsRead(int notificationId) {
        String sql = "UPDATE Notification SET is_read = 1 WHERE notification_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteNotification(int notificationId) {
        String sql = "DELETE FROM Notification WHERE notification_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
