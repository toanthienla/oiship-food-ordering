package dao;

import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Account;
import model.Dish;
import model.Review;
import utils.DBContext;

public class ManageReviewsDAO extends DBContext {

    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.reviewID, r.rating, r.comment, r.reviewCreatedAt, "
                + "o.orderID, d.dishName, c.fullName, ca.catName "
                + "FROM Review r "
                + "JOIN OrderDetail od ON r.FK_Review_OrderDetail = od.ODID "
                + "JOIN [Order] o ON od.FK_OD_Order = o.orderID "
                + "JOIN Dish d ON od.FK_OD_Dish = d.dishID "
                + "JOIN Category ca ON d.FK_Dish_Category = ca.catID "
                + "JOIN Customer cu ON r.FK_Review_Customer = cu.customerID "
                + "JOIN Account c ON cu.customerID = c.accountID "
                + "ORDER BY r.reviewCreatedAt DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewID(rs.getInt("reviewID"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setReviewCreatedAt(rs.getTimestamp("reviewCreatedAt"));
                    r.setOrderId(rs.getInt("orderID"));
                    r.setDishName(rs.getString("dishName"));
                    r.setCustomerName(rs.getString("fullName"));
                    r.setCatName(rs.getString("catName"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // hoặc dùng logger
        }

        return list;
    }

    public boolean deleteReviewById(int reviewId) {
        String sql = "DELETE FROM Review WHERE reviewID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        ManageReviewsDAO dao = new ManageReviewsDAO();
        List<Review> reviews = dao.getAllReviews();

        if (reviews.isEmpty()) {
            System.out.println("No reviews found.");
        } else {
            System.out.println("Reviews retrieved:");
            for (Review r : reviews) {
                System.out.println("-----------------------------------");
                System.out.println("Review ID: " + r.getReviewID());
                System.out.println("Order ID: #" + r.getOrderId());
                System.out.println("Dish Name: " + r.getDishName());
                System.out.println("Category: " + r.getCatName());
                System.out.println("Customer: " + r.getCustomerName());
                System.out.println("Rating: " + r.getRating() + " ★");
                System.out.println("Comment: " + r.getComment());
                System.out.println("Date: " + r.getReviewCreatedAt());
            }
        }
    }
}
