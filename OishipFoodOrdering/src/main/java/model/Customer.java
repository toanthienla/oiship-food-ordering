package model;

import java.sql.Timestamp;

public class Customer {

    private int customerId;
    private String name;
    private String email;
    private String phone;
    private String password;
    private String address;
    private int statusId;
    private Timestamp createdAt;

    public Customer() {
    }

    public Customer(int customerId, String name, String email, String phone, String password, String address,
            int statusId, Timestamp createdAt) {
        this.customerId = customerId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.address = address;
        this.statusId = statusId;
        this.createdAt = createdAt;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Customers{" + "customerId=" + customerId + ", name=" + name + ", email=" + email + ", phone=" + phone
                + ", password=" + password + ", address=" + address + ", statusId=" + statusId + ", createdAt="
                + createdAt + '}';
    }

}
