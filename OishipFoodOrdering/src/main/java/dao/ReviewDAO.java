/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Review;
import utils.DBContext;

/**
 *
 * @author Phi Yen
 */
public class ReviewDAO extends DBContext {
    
    public List<Review> getTop5ReviewsByDishId(int dishId) {
    List<Review> reviews = new ArrayList<>();
    String sql = "SELECT TOP 5 r.comment, r.rating, r.reviewCreatedAt, a.fullName AS customerName " +
                 "FROM Review r " +
                 "JOIN OrderDetail od ON r.FK_Review_OrderDetail = od.ODID " +
                 "JOIN [Order] o ON o.orderID = od.FK_OD_Order " +
                 "JOIN Customer c ON r.FK_Review_Customer = c.customerID " +
                 "JOIN Account a ON c.customerID = a.accountID " +
                 "WHERE od.FK_OD_Dish = ? " +
                 "ORDER BY r.reviewCreatedAt DESC";

    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, dishId);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Review r = new Review();
            r.setComment(rs.getString("comment"));
            r.setRating(rs.getInt("rating"));
            r.setReviewCreatedAt(rs.getTimestamp("reviewCreatedAt"));
            r.setCustomerName(rs.getString("customerName")); 
            reviews.add(r);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return reviews;
}

}
