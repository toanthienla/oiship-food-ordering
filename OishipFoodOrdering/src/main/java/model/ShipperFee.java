package model;

import java.sql.Timestamp;

public class ShipperFee {

    private int feeId;
    private int shipperId;
    private int orderId;
    private double feeAmount;
    private String feeType;
    private Timestamp createdAt;

    public ShipperFee(int feeId, int shipperId, int orderId, double feeAmount, String feeType, Timestamp createdAt) {
        this.feeId = feeId;
        this.shipperId = shipperId;
        this.orderId = orderId;
        this.feeAmount = feeAmount;
        this.feeType = feeType;
        this.createdAt = createdAt;
    }

    public ShipperFee() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
                                                                       // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    // Getters and Setters
    public int getFeeId() {
        return feeId;
    }

    public void setFeeId(int feeId) {
        this.feeId = feeId;
    }

    public int getShipperId() {
        return shipperId;
    }

    public void setShipperId(int shipperId) {
        this.shipperId = shipperId;
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
        return "ShipperFee{" + "feeId=" + feeId + ", shipperId=" + shipperId + ", orderId=" + orderId + ", feeAmount="
                + feeAmount + ", feeType=" + feeType + ", createdAt=" + createdAt + '}';
    }

}
