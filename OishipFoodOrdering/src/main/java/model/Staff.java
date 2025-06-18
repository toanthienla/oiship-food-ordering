package model;

import java.sql.Timestamp;

public class Staff extends Account {

    public Staff() {
        super();
        setRole("staff"); // Enforce role = 'staff'
    }

    public Staff(int accountID, String fullName, String email, String password, int status, String role, Timestamp createAt) {
        super(accountID, fullName, email, password, status, "staff", createAt); // Force role = 'staff'
    }

    @Override
    public void setRole(String role) {
        if (!"staff".equals(role)) {
            throw new IllegalArgumentException("Role for Staff must be 'staff'");
        }
        super.setRole(role);
    }
}