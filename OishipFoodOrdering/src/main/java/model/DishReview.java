package model;

import java.sql.Timestamp;

public class DishReview {
    private int dishReviewId;
    private int rating;
    private String comment;
    private Timestamp dishReviewCreatedAt;
    private int orderDetailId;
    private int customerId;

    public DishReview() {
    }

    public DishReview(int dishReviewId, int rating, String comment, Timestamp dishReviewCreatedAt, int orderDetailId, int customerId) {
        this.dishReviewId = dishReviewId;
        this.rating = rating;
        this.comment = comment;
        this.dishReviewCreatedAt = dishReviewCreatedAt;
        this.orderDetailId = orderDetailId;
        this.customerId = customerId;
    }

    public int getDishReviewId() {
        return dishReviewId;
    }

    public void setDishReviewId(int dishReviewId) {
        this.dishReviewId = dishReviewId;
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

    public Timestamp getDishReviewCreatedAt() {
        return dishReviewCreatedAt;
    }

    public void setDishReviewCreatedAt(Timestamp dishReviewCreatedAt) {
        this.dishReviewCreatedAt = dishReviewCreatedAt;
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
}
