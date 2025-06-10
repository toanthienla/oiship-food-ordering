package model;

import java.sql.Timestamp;

public class Customer {
    private int customerID;
    private String fullName;
    private String email;
    private String password;
    private String role;
    private Timestamp createAt;
    private int status;
    private String phone;
    private String address;

    public Customer() {}

    public Customer(int customerID, String fullName, String email, String password, String role, Timestamp createAt,
                    int status, String phone, String address) {
        this.customerID = customerID;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.createAt = createAt;
        this.status = status;
        this.phone = phone;
        this.address = address;
    }

    // Getters and Setters
    public int getCustomerID() { return customerID; }
    public void setCustomerID(int customerID) { this.customerID = customerID; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Timestamp getCreateAt() { return createAt; }
    public void setCreateAt(Timestamp createAt) { this.createAt = createAt; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}