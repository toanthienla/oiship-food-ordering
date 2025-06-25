package model;

import java.sql.Timestamp;

public class Account {

    private int accountID;
    private String fullName;
    private String email;
    private String password;
    private int status; // 1 = active, 0 = inactive, -1 = banned
    private String role; // 'admin', 'staff', 'customer'
    private Timestamp createAt;
    private Customer customer; // Added field for customer details

    public Account() {
    }

    public Account(int accountID, String fullName, String email, String password, int status, String role, Timestamp createAt) {
        this.accountID = accountID;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        setStatus(status); // Use setter to enforce constraints
        setRole(role);     // Use setter to enforce constraints
        this.createAt = createAt;
    }

    // Getters and Setters
    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
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

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        if (status != 1 && status != 0 && status != -1) {
            throw new IllegalArgumentException("Status must be 1 (active), 0 (inactive), or -1 (banned)");
        }
        this.status = status;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        if (role != null && !role.equals("admin") && !role.equals("staff") && !role.equals("customer")) {
            throw new IllegalArgumentException("Role must be 'admin', 'staff', or 'customer'");
        }
        this.role = role;
    }

    public Timestamp getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Timestamp createAt) {
        this.createAt = createAt;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }
}