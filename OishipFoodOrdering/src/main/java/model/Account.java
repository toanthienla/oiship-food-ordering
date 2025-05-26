package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Account {

    private int accountId;
    private String accountName;
    private String email;
    private String phone;
    private String password;
    private String status;
    private String cccd;
    private String license;
    private byte[] licenseImage;
    private String numberPlate;
    private String address;
    private BigDecimal longitude;
    private BigDecimal latitude;
    private Timestamp accountCreatedAt;
    private String role;

    public Account() {
    }

    public Account(int accountId, String accountName, String email, String phone, String password,
                   String status, String cccd, String license, byte[] licenseImage, String numberPlate,
                   String address, BigDecimal longitude, BigDecimal latitude,
                   Timestamp accountCreatedAt, String role) {
        this.accountId = accountId;
        this.accountName = accountName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.status = status;
        this.cccd = cccd;
        this.license = license;
        this.licenseImage = licenseImage;
        this.numberPlate = numberPlate;
        this.address = address;
        this.longitude = longitude;
        this.latitude = latitude;
        this.accountCreatedAt = accountCreatedAt;
        this.role = role;
    }

    // Getters and setters (đã đúng, chỉ cần cập nhật kiểu số)
    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCccd() {
        return cccd;
    }

    public void setCccd(String cccd) {
        this.cccd = cccd;
    }

    public String getLicense() {
        return license;
    }

    public void setLicense(String license) {
        this.license = license;
    }

    public byte[] getLicenseImage() {
        return licenseImage;
    }

    public void setLicenseImage(byte[] licenseImage) {
        this.licenseImage = licenseImage;
    }

    public String getNumberPlate() {
        return numberPlate;
    }

    public void setNumberPlate(String numberPlate) {
        this.numberPlate = numberPlate;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public BigDecimal getLongitude() {
        return longitude;
    }

    public void setLongitude(BigDecimal longitude) {
        this.longitude = longitude;
    }

    public BigDecimal getLatitude() {
        return latitude;
    }

    public void setLatitude(BigDecimal latitude) {
        this.latitude = latitude;
    }

    public Timestamp getAccountCreatedAt() {
        return accountCreatedAt;
    }

    public void setAccountCreatedAt(Timestamp accountCreatedAt) {
        this.accountCreatedAt = accountCreatedAt;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}


