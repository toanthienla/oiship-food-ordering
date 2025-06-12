/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Phi Yen
 */
public class Review {
     private int reviewID;
    private int rating;
    private String comment;
    private Timestamp reviewCreatedAt;
    private int orderDetailId;    // FK_Review_OrderDetail
    private int customerId;       // FK_Review_Customer
    private String customerName;  // Tên người đánh giá (join từ Account)

    public Review() {
    }

    public Review(int reviewID, int rating, String comment, Timestamp reviewCreatedAt, int orderDetailId, int customerId, String customerName) {
        this.reviewID = reviewID;
        this.rating = rating;
        this.comment = comment;
        this.reviewCreatedAt = reviewCreatedAt;
        this.orderDetailId = orderDetailId;
        this.customerId = customerId;
        this.customerName = customerName;
    }

    public int getReviewID() {
        return reviewID;
    }

    public void setReviewID(int reviewID) {
        this.reviewID = reviewID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getReviewCreatedAt() {
        return reviewCreatedAt;
    }

    public void setReviewCreatedAt(Timestamp reviewCreatedAt) {
        this.reviewCreatedAt = reviewCreatedAt;
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }



}
