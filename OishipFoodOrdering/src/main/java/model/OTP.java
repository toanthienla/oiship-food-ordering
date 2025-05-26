package model;

import java.time.LocalDateTime;

public class OTP {

    private int verificationId;
    private String code;
    private String plainCode;
    private LocalDateTime createdAt;
    private LocalDateTime expiresAt;
    private boolean isUsed;
    private int accountId;

    // ✅ Constructor đầy đủ dùng cho việc lấy từ DB
    public OTP(int verificationId, String code, String plainCode, LocalDateTime createdAt,
            LocalDateTime expiresAt, boolean isUsed, int accountId) {
        this.verificationId = verificationId;
        this.code = code;
        this.plainCode = plainCode;
        this.createdAt = createdAt;
        this.expiresAt = expiresAt;
        this.isUsed = isUsed;
        this.accountId = accountId;
    }

    // ✅ Constructor dùng khi tạo OTP mới (ví dụ trong register/forgot password)
    public OTP(String hashedCode, String plainCode, int accountId) {
        this.code = hashedCode;
        this.plainCode = plainCode;
        this.accountId = accountId;
        this.createdAt = LocalDateTime.now();
        this.expiresAt = LocalDateTime.now().plusMinutes(5);
        this.isUsed = false;
    }

    // Getters and Setters
    public int getVerificationId() {
        return verificationId;
    }

    public void setVerificationId(int verificationId) {
        this.verificationId = verificationId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getPlainCode() {
        return plainCode;
    }

    public void setPlainCode(String plainCode) {
        this.plainCode = plainCode;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isUsed() {
        return isUsed;
    }

    public void setUsed(boolean used) {
        isUsed = used;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
}
