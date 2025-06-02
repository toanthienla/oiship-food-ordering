package model;

import java.sql.Timestamp;

public class Account {

    private int accountID;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String address;
    private int status;
    private String role;
    private Timestamp createAt;

    // Constructor không tham số
    public Account() {
    }

    // Constructor đầy đủ
    public Account(int accountID, String fullName, String email, String phone, String password, String address, int status, String role, Timestamp createAt) {
        this.accountID = accountID;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.address = address;
        this.status = status;
        this.role = role;
        this.createAt = createAt;
    }
    // Getter và setter
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Timestamp createAt) {
        this.createAt = createAt;
    }
}
