package model;

import java.time.LocalDateTime;

public class OTP {

    private int otpId;
    private String otp;
    private LocalDateTime otpCreatedAt;
    private LocalDateTime otpExpiresAt;
    private int isUsed;
    private int accountId;
    private String email;

    public OTP(int otpId, String otp, LocalDateTime otpCreatedAt, LocalDateTime otpExpiresAt, int isUsed, int accountId, String email) {
        this.otpId = otpId;
        this.otp = otp;
        this.otpCreatedAt = otpCreatedAt;
        this.otpExpiresAt = otpExpiresAt;
        this.isUsed = isUsed;
        this.accountId = accountId;
        this.email = email;
    }

    public OTP() {
    }

    public int getOtpId() {
        return otpId;
    }

    public void setOtpId(int otpId) {
        this.otpId = otpId;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public LocalDateTime getOtpCreatedAt() {
        return otpCreatedAt;
    }

    public void setOtpCreatedAt(LocalDateTime otpCreatedAt) {
        this.otpCreatedAt = otpCreatedAt;
    }

    public LocalDateTime getOtpExpiresAt() {
        return otpExpiresAt;
    }

    public void setOtpExpiresAt(LocalDateTime otpExpiresAt) {
        this.otpExpiresAt = otpExpiresAt;
    }

    public int getIsUsed() {
        return isUsed;
    }

    public void setIsUsed(int isUsed) {
        this.isUsed = isUsed;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
