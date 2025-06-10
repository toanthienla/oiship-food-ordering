package model;

import java.sql.Timestamp;

public class Order {

    private int orderID;
    private double amount;
    private int orderStatus;
    private int paymentStatus;
    private Timestamp orderCreatedAt;
    private Timestamp orderUpdatedAt;
    private String deliveryAddress;
    private Timestamp deliveryTime;
    private Integer fkOrderVoucher; // Sử dụng Integer để cho phép null
    private Integer fkOrderCustomer; // Sử dụng Integer để cho phép null
    private Integer fkOrderStaff;    // Sử dụng Integer để cho phép null

    public Order(int orderID, double amount, int orderStatus, int paymentStatus, Timestamp orderCreatedAt,
            Timestamp orderUpdatedAt, String deliveryAddress, Timestamp deliveryTime,
            Integer fkOrderVoucher, Integer fkOrderCustomer, Integer fkOrderStaff) {
        this.orderID = orderID;
        this.amount = amount;
        this.orderStatus = orderStatus;
        this.paymentStatus = paymentStatus;
        this.orderCreatedAt = orderCreatedAt;
        this.orderUpdatedAt = orderUpdatedAt;
        this.deliveryAddress = deliveryAddress;
        this.deliveryTime = deliveryTime;
        this.fkOrderVoucher = fkOrderVoucher;
        this.fkOrderCustomer = fkOrderCustomer;
        this.fkOrderStaff = fkOrderStaff;
    }

    // Getters and Setters
    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public int getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(int orderStatus) {
        this.orderStatus = orderStatus;
    }

    public int getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(int paymentStatus) {
        this.paymentStatus = paymentStatus;
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

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public Timestamp getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(Timestamp deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public Integer getFkOrderVoucher() {
        return fkOrderVoucher;
    }

    public void setFkOrderVoucher(Integer fkOrderVoucher) {
        this.fkOrderVoucher = fkOrderVoucher;
    }

    public Integer getFkOrderCustomer() {
        return fkOrderCustomer;
    }

    public void setFkOrderCustomer(Integer fkOrderCustomer) {
        this.fkOrderCustomer = fkOrderCustomer;
    }

    public Integer getFkOrderStaff() {
        return fkOrderStaff;
    }

    public void setFkOrderStaff(Integer fkOrderStaff) {
        this.fkOrderStaff = fkOrderStaff;
    }
}
