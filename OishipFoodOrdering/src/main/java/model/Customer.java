package model;

import java.sql.Timestamp;

public class Customer {

    private int customerID; // Maps to accountID
    private String fullName;
    private String email;
    private String password;
    private String role;
    private Timestamp accountCreatedAt;
    private int status; // 1 = active, 0 = inactive, -1 = banned
    private String phone;
    private String address;

    public Customer() {}

    // Basic constructor
    public Customer(int customerID, String phone, String address) {
        this.customerID = customerID;
        setPhone(phone);
        setAddress(address);
    }

    // Full constructor for JOIN results (Account + Customer info)
    public Customer(int customerID, String fullName, String email, String password, String role,
                    Timestamp accountCreatedAt, int status, String phone, String address) {
        this.customerID = customerID;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.accountCreatedAt = accountCreatedAt;
        this.status = status;
        setPhone(phone);
        setAddress(address);
    }

    // Getters and Setters
    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        if (fullName != null && fullName.length() > 255) {
            throw new IllegalArgumentException("Full name must not exceed 255 characters");
        }
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        if (email != null && email.length() > 100) {
            throw new IllegalArgumentException("Email must not exceed 100 characters");
        }
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        if (password != null && password.length() > 255) {
            throw new IllegalArgumentException("Password must not exceed 255 characters");
        }
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getAccountCreatedAt() {
        return accountCreatedAt;
    }

    public void setAccountCreatedAt(Timestamp accountCreatedAt) {
        this.accountCreatedAt = accountCreatedAt;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        if (status != 1 && status != 0 && status != -1) {
            throw new IllegalArgumentException("Status must be 1 (active), 0 (inactive), or -1 (banned)");
        }
        this.status = status;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        if (phone != null && phone.length() > 15) {
            throw new IllegalArgumentException("Phone must not exceed 15 characters");
        }
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        if (address != null && address.length() > 255) {
            throw new IllegalArgumentException("Address must not exceed 255 characters");
        }
        this.address = address;
    }
}