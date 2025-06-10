package model;

import java.time.LocalDateTime;

public class OTP {
    private int otpId;
    private String otp;
    private LocalDateTime otpCreatedAt;
    private LocalDateTime otpExpiresAt;
    private int isUsed;
    private String email;
    private Integer customerId; // Thay accountId bằng customerId

    // Constructors
    public OTP() {}

    public OTP(String otp, LocalDateTime otpCreatedAt, LocalDateTime otpExpiresAt, int isUsed, String email, Integer customerId) {
        this.otp = otp;
        this.otpCreatedAt = otpCreatedAt;
        this.otpExpiresAt = otpExpiresAt;
        this.isUsed = isUsed;
        this.email = email;
        this.customerId = customerId;
    }

    // Getters and Setters
    public int getOtpId() { return otpId; }
    public void setOtpId(int otpId) { this.otpId = otpId; }
    public String getOtp() { return otp; }
    public void setOtp(String otp) { this.otp = otp; }
    public LocalDateTime getOtpCreatedAt() { return otpCreatedAt; }
    public void setOtpCreatedAt(LocalDateTime otpCreatedAt) { this.otpCreatedAt = otpCreatedAt; }
    public LocalDateTime getOtpExpiresAt() { return otpExpiresAt; }
    public void setOtpExpiresAt(LocalDateTime otpExpiresAt) { this.otpExpiresAt = otpExpiresAt; }
    public int getIsUsed() { return isUsed; }
    public void setIsUsed(int isUsed) { this.isUsed = isUsed; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }
}