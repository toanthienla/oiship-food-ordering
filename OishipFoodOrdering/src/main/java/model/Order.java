package model;

import java.sql.Timestamp;

public class Order {

    private int orderId;
    private double amount; // ánh xạ với amount (DECIMAL(10,2))
    private int orderStatus; // ánh xạ với orderStatus (0: Pending, 1: Confirmed, 2: In Delivery, 3: Delivered, 4: Cancelled by User, 5: Cancelled by Staff, 6: Failed, 7: Refunded)
    private Timestamp orderCreatedAt;
    private Timestamp orderUpdatedAt;
    private int voucherId; // FK_Order_Voucher
    private int accountId; // FK_Order_Account
    private int staffId; // FK_Order_Staff
    private String customerName; // Để hiển thị tên khách hàng trong giao diện
    private String status; // Để hiển thị trạng thái dạng chuỗi trong giao diện

    // Constructor mặc định
    public Order() {
    }

    // Constructor đầy đủ
    public Order(int orderId, double amount, int orderStatus, Timestamp orderCreatedAt, Timestamp orderUpdatedAt,
            int voucherId, int accountId, int staffId, String customerName, String status) {
        this.orderId = orderId;
        this.amount = amount;
        this.orderStatus = orderStatus;
        this.orderCreatedAt = orderCreatedAt;
        this.orderUpdatedAt = orderUpdatedAt;
        this.voucherId = voucherId;
        this.accountId = accountId;
        this.staffId = staffId;
        this.customerName = customerName;
        this.status = status;
    }

    // Getters và Setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
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
        // Cập nhật status dạng chuỗi dựa trên orderStatus
        switch (orderStatus) {
            case 0:
                this.status = "Pending";
                break;
            case 1:
                this.status = "Confirmed";
                break;
            case 2:
                this.status = "In Delivery";
                break;
            case 3:
                this.status = "Delivered";
                break;
            case 4:
                this.status = "Cancelled by User";
                break;
            case 5:
                this.status = "Cancelled by Staff";
                break;
            case 6:
                this.status = "Failed";
                break;
            case 7:
                this.status = "Refunded";
                break;
            default:
                this.status = "Unknown";
        }
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

    public int getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Để hỗ trợ giao diện, thêm totalAmount và orderDate (bí danh cho amount và orderCreatedAt)
    public double getTotalAmount() {
        return amount;
    }

    public void setTotalAmount(double totalAmount) {
        this.amount = totalAmount;
    }

    public Timestamp getOrderDate() {
        return orderCreatedAt;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderCreatedAt = orderDate;
    }

    @Override
    public String toString() {
        return "Order{"
                + "orderId=" + orderId
                + ", amount=" + amount
                + ", orderStatus=" + orderStatus
                + ", orderCreatedAt=" + orderCreatedAt
                + ", orderUpdatedAt=" + orderUpdatedAt
                + ", voucherId=" + voucherId
                + ", accountId=" + accountId
                + ", staffId=" + staffId
                + ", customerName='" + customerName + '\''
                + ", status='" + status + '\''
                + '}';
    }
}
