/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Account;
import model.Dish;
import model.Review;
import utils.DBContext;

/**
 *
 * @author HCT
 */
public class ManageReviewsDAO extends DBContext {

    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.reviewID, r.rating, r.comment, r.reviewCreatedAt, "
                + "d.dishName, c.fullName "
                + "FROM Review r "
                + "JOIN OrderDetail od ON r.FK_Review_OrderDetail = od.ODID "
                + "JOIN Dish d ON od.FK_OD_Dish = d.dishID "
                + "JOIN Customer cu ON r.FK_Review_Customer = cu.customerID "
                + "JOIN Account c ON cu.customerID = c.accountID";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setReviewID(rs.getInt("reviewID"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setReviewCreatedAt(rs.getTimestamp("reviewCreatedAt"));
                    review.setCustomerName(rs.getString("fullName"));
                    review.setDishName(rs.getString("dishName"));
                    list.add(review);
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
//        ManageReviewsDAO dao = new ManageReviewsDAO();
//        List<Review> reviews = dao.getAllReviews();
//
//        if (reviews.isEmpty()) {
//            System.out.println("Không có đánh giá nào.");
//        } else {
//            for (Review r : reviews) {
//                System.out.println("Review ID: " + r.getReviewID());
//                System.out.println("Rating: " + r.getRating());
//                System.out.println("Comment: " + r.getComment());
//                System.out.println("Created At: " + r.getReviewCreatedAt());
//                System.out.println("Customer Name: " + r.getCustomerName());
//                System.out.println("Dish Name: " + r.getDishName());
//                System.out.println("------------------------------");
//            }
//        }

        ManageReviewsDAO dao = new ManageReviewsDAO();
        int reviewIdToDelete = 3; // Thay ID này bằng ID của review bạn muốn xóa

        boolean deleted = dao.deleteReviewById(reviewIdToDelete);
        if (deleted) {
            System.out.println("Review với ID " + reviewIdToDelete + " đã được xóa thành công.");
        } else {
            System.out.println("Không thể xóa review với ID " + reviewIdToDelete + ".");
        }
    }

}
