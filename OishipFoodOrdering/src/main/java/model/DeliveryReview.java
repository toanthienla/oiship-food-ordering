package model;

import java.time.LocalDateTime;

public class DeliveryReview {
    private int deliveryReviewId;
    private int rating;
    private String comment;
    private LocalDateTime createdAt;
    private int orderId;
    private int restaurantManagerId;
    private int shipperId;
    private int customerId;

    public DeliveryReview() {
    }

    public DeliveryReview(int deliveryReviewId, int rating, String comment, LocalDateTime createdAt,
                          int orderId, int restaurantManagerId, int shipperId, int customerId) {
        this.deliveryReviewId = deliveryReviewId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.orderId = orderId;
        this.restaurantManagerId = restaurantManagerId;
        this.shipperId = shipperId;
        this.customerId = customerId;
    }

    public int getDeliveryReviewId() {
        return deliveryReviewId;
    }

    public void setDeliveryReviewId(int deliveryReviewId) {
        this.deliveryReviewId = deliveryReviewId;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getRestaurantManagerId() {
        return restaurantManagerId;
    }

    public void setRestaurantManagerId(int restaurantManagerId) {
        this.restaurantManagerId = restaurantManagerId;
    }

    public int getShipperId() {
        return shipperId;
    }

    public void setShipperId(int shipperId) {
        this.shipperId = shipperId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }
}
