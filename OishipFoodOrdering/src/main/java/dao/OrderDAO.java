package dao;

import java.math.BigDecimal;
import model.Order;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends DBContext {

    public void insertOrder(Order order) {
        String sql = "INSERT INTO [Order] (total_amount, payment_method, order_status, distance_km, order_created_at, order_updated_at, discount_id, customer_id, restaurant_manager_id, shipper_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setBigDecimal(1, BigDecimal.valueOf(order.getTotalAmount())); // S
            stmt.setString(2, order.getPaymentMethod());
            stmt.setString(3, order.getOrderStatus());
            stmt.setBigDecimal(4, BigDecimal.valueOf(order.getDistanceKm())); // Sửa

            // Xử lý Timestamp cho thời gian tạo và cập nhật
            stmt.setTimestamp(5, order.getOrderCreatedAt() != null ? order.getOrderCreatedAt() : new Timestamp(System.currentTimeMillis()));
            stmt.setTimestamp(6, order.getOrderUpdatedAt() != null ? order.getOrderUpdatedAt() : new Timestamp(System.currentTimeMillis()));

            // Xử lý discount_id nullable
            if (order.getDiscountId() != null) {
                stmt.setInt(7, order.getDiscountId());
            } else {
                stmt.setNull(7, Types.INTEGER);
            }

            stmt.setInt(8, order.getCustomerId());
            stmt.setInt(9, order.getRestaurantManagerId());

            // Xử lý shipper_id nullable
            if (order.getShipperId() != null) {
                stmt.setInt(10, order.getShipperId());
            } else {
                stmt.setNull(10, Types.INTEGER);
            }

            stmt.executeUpdate();

            // Lấy ID auto-generated gán lại vào model
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                order.setOrderId(rs.getInt(1));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE [Order] SET order_status = ?, order_updated_at = GETDATE() WHERE order_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM [Order] WHERE order_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> getOrdersByCustomerId(int customerId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE customer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteOrder(int orderId) {
        String sql = "DELETE FROM [Order] WHERE order_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        return new Order(
                rs.getInt("order_id"),
                rs.getBigDecimal("total_amount"),
                rs.getString("payment_method"),
                rs.getString("order_status"),
                rs.getBigDecimal("distance_km"),
                rs.getTimestamp("order_created_at").toLocalDateTime(),
                rs.getTimestamp("order_updated_at").toLocalDateTime(),
                rs.getInt("discount_id"),
                rs.getInt("customer_id"),
                rs.getInt("restaurant_manager_id"),
                rs.getInt("shipper_id")
        );
    }
}
