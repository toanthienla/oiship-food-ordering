package dao;

import model.OrderDetail;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailDAO extends DBContext {

    public void insertOrderDetail(OrderDetail od) {
        String sql = "INSERT INTO OrderDetail (quantity, is_cart, order_id, menu_detail_id, restaurant_manager_id, customer_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, od.getQuantity());
            stmt.setBoolean(2, od.isCart());
            stmt.setInt(3, od.getOrderId());
            stmt.setInt(4, od.getMenuDetailId());
            stmt.setInt(5, od.getRestaurantManagerId());
            stmt.setInt(6, od.getCustomerId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetail WHERE order_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToOrderDetail(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateOrderDetail(OrderDetail od) {
        String sql = "UPDATE OrderDetail SET quantity = ?, is_cart = ?, menu_detail_id = ?, restaurant_manager_id = ?, customer_id = ? WHERE order_detail_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, od.getQuantity());
            stmt.setBoolean(2, od.isCart());
            stmt.setInt(3, od.getMenuDetailId());
            stmt.setInt(4, od.getRestaurantManagerId());
            stmt.setInt(5, od.getCustomerId());
            stmt.setInt(6, od.getOrderDetailId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteOrderDetail(int orderDetailId) {
        String sql = "DELETE FROM OrderDetail WHERE order_detail_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderDetailId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private OrderDetail mapResultSetToOrderDetail(ResultSet rs) throws SQLException {
        return new OrderDetail(
            rs.getInt("order_detail_id"),
            rs.getInt("quantity"),
            rs.getBoolean("is_cart"),
            rs.getInt("order_id"),
            rs.getInt("menu_detail_id"),
            rs.getInt("restaurant_manager_id"),
            rs.getInt("customer_id")
        );
    }
}
