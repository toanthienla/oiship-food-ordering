package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;


public class Order {

    public Order(int aInt, BigDecimal bigDecimal, String string, String string1, BigDecimal bigDecimal1, LocalDateTime toLocalDateTime, LocalDateTime toLocalDateTime1, int aInt1, int aInt2, int aInt3, int aInt4) {
    }
    private int orderId;
    private double totalAmount;
    private String paymentMethod;
    private String orderStatus;
    private Double distanceKm;
    private java.sql.Timestamp orderCreatedAt;
    private java.sql.Timestamp orderUpdatedAt;
    private Integer discountId;
    private int customerId;
    private int restaurantManagerId;
    private Integer shipperId;

    // Getters and setters

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public Double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(Double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public Timestamp getOrderCreatedAt() {
        return orderCreatedAt;
    }

    public void setOrderCreatedAt(Timestamp orderCreatedAt) {
        this.orderCreatedAt = orderCreatedAt;
    }

    public Timestamp getOrderUpdatedAt() {
        return orderUpdatedAt;
    }

    public void setOrderUpdatedAt(Timestamp orderUpdatedAt) {
        this.orderUpdatedAt = orderUpdatedAt;
    }

    public Integer getDiscountId() {
        return discountId;
    }

    public void setDiscountId(Integer discountId) {
        this.discountId = discountId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getRestaurantManagerId() {
        return restaurantManagerId;
    }

    public void setRestaurantManagerId(int restaurantManagerId) {
        this.restaurantManagerId = restaurantManagerId;
    }

    public Integer getShipperId() {
        return shipperId;
    }

    public void setShipperId(Integer shipperId) {
        this.shipperId = shipperId;
    }
}
