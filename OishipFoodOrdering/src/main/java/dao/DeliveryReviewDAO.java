package dao;

import model.DeliveryReview;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DeliveryReviewDAO extends DBContext {

    public List<DeliveryReview> getAllDeliveryReviews() {
        List<DeliveryReview> list = new ArrayList<>();
        String sql = "SELECT * FROM DeliveryReview";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRowToDeliveryReview(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public DeliveryReview getDeliveryReviewById(int id) {
        String sql = "SELECT * FROM DeliveryReview WHERE delivery_review_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToDeliveryReview(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertDeliveryReview(DeliveryReview review) {
        String sql = "INSERT INTO DeliveryReview (rating, comment, created_at, order_id, restaurant_manager_id, shipper_id, customer_id) VALUES (?, ?, GETDATE(), ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getComment());
            stmt.setInt(3, review.getOrderId());
            stmt.setInt(4, review.getRestaurantManagerId());
            stmt.setInt(5, review.getShipperId());
            stmt.setInt(6, review.getCustomerId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateDeliveryReview(DeliveryReview review) {
        String sql = "UPDATE DeliveryReview SET rating = ?, comment = ?, order_id = ?, restaurant_manager_id = ?, shipper_id = ?, customer_id = ? WHERE delivery_review_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getComment());
            stmt.setInt(3, review.getOrderId());
            stmt.setInt(4, review.getRestaurantManagerId());
            stmt.setInt(5, review.getShipperId());
            stmt.setInt(6, review.getCustomerId());
            stmt.setInt(7, review.getDeliveryReviewId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteDeliveryReview(int id) {
        String sql = "DELETE FROM DeliveryReview WHERE delivery_review_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private DeliveryReview mapRowToDeliveryReview(ResultSet rs) throws SQLException {
        return new DeliveryReview(
                rs.getInt("delivery_review_id"),
                rs.getInt("rating"),
                rs.getString("comment"),
                rs.getTimestamp("created_at").toLocalDateTime(),
                rs.getInt("order_id"),
                rs.getInt("restaurant_manager_id"),
                rs.getInt("shipper_id"),
                rs.getInt("customer_id")
        );
    }
}
