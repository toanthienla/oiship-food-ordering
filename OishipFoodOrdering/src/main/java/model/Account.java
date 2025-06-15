package model;

// Lớp cha Account
public class Account {
    private int accountID;
    private String fullName;
    private String email;
    private String password;
    private String role;
    private java.util.Date createAt;

    public Account() {
    }

    public Account(int accountID, String fullName, String email, String password, String role, java.util.Date createAt) {
        this.accountID = accountID;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.role = role;
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

    public java.util.Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(java.util.Date createAt) {
        this.createAt = createAt;
    }

}