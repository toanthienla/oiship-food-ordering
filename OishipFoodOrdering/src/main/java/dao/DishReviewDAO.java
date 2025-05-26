package dao;

import model.DishReview;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DishReviewDAO extends DBContext {

    public List<DishReview> getDishReviewsByOrderDetailId(int orderDetailId) {
        List<DishReview> list = new ArrayList<>();
        String sql = "SELECT * FROM DishReview WHERE order_detail_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderDetailId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRowToReview(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertDishReview(DishReview r) {
        String sql = "INSERT INTO DishReview (rating, comment, dish_review_created_at, order_detail_id, customer_id) VALUES (?, ?, GETDATE(), ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, r.getRating());
            stmt.setString(2, r.getComment());
            stmt.setInt(3, r.getOrderDetailId());
            stmt.setInt(4, r.getCustomerId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateDishReview(DishReview r) {
        String sql = "UPDATE DishReview SET rating = ?, comment = ? WHERE dish_review_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, r.getRating());
            stmt.setString(2, r.getComment());
            stmt.setInt(3, r.getDishReviewId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteDishReview(int id) {
        String sql = "DELETE FROM DishReview WHERE dish_review_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public double getAverageRatingByMenuDetailId(int menuDetailId) {
        String sql
                = "SELECT AVG(rating) AS avg_rating "
                + "FROM DishReview "
                + "WHERE order_detail_id IN ( "
                + "    SELECT order_detail_id FROM OrderDetail WHERE menu_detail_id = ? "
                + ")";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, menuDetailId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private DishReview mapRowToReview(ResultSet rs) throws SQLException {
        return new DishReview(
                rs.getInt("dish_review_id"),
                rs.getInt("rating"),
                rs.getString("comment"),
                rs.getTimestamp("dish_review_created_at"), // ✅ sửa đúng kiểu
                rs.getInt("order_detail_id"),
                rs.getInt("customer_id")
        );
    }
}
