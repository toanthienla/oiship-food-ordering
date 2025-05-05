package model;

import java.sql.Timestamp;

public class RestaurantFee {
    private int feeId;
    private int restaurantId;
    private int orderId;
    private double feeAmount;
    private String feeType;
    private Timestamp createdAt;

    public RestaurantFee(int feeId, int restaurantId, int orderId, double feeAmount, String feeType,
            Timestamp createdAt) {
        this.feeId = feeId;
        this.restaurantId = restaurantId;
        this.orderId = orderId;
        this.feeAmount = feeAmount;
        this.feeType = feeType;
        this.createdAt = createdAt;
    }

    public RestaurantFee() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    // Getters and Setters
    public int getFeeId() {
        return feeId;
    }

    public void setFeeId(int feeId) {
        this.feeId = feeId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public double getFeeAmount() {
        return feeAmount;
    }

    public void setFeeAmount(double feeAmount) {
        this.feeAmount = feeAmount;
    }

    public String getFeeType() {
        return feeType;
    }

    public void setFeeType(String feeType) {
        this.feeType = feeType;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "RestaurantFee{" + "feeId=" + feeId + ", restaurantId=" + restaurantId + ", orderId=" + orderId
                + ", feeAmount=" + feeAmount + ", feeType=" + feeType + ", createdAt=" + createdAt + '}';
    }

}
