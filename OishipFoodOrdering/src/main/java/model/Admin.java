package model;

import java.sql.Timestamp;

public class Admin {

    private int adminId;      // Matches accountID in the database
    private String fullName;  // Replaced name with fullName to match database
    private String email;
    private String password;
    private String role;      // Thêm role để khớp với schema
    private Timestamp createdAt;

    // Default Constructor
    public Admin() {
    }

    // Full Constructor
    public Admin(int adminId, String fullName, String email, String password, String role, Timestamp createdAt) {
        this.adminId = adminId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
