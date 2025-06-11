package model;

public class Staff extends Account {

    public Staff() {
        super();
    }

    public Staff(int accountID, String fullName, String email, String password, String role, java.util.Date createAt, int status) {
        super(accountID, fullName, email, password, role, createAt, status);
    }

    @Override
    public String toString() {
        return "Staff{"
                + "accountID=" + getAccountID()
                + ", fullName='" + getFullName() + '\''
                + ", email='" + getEmail() + '\''
                + ", role='" + getRole() + '\''
                + '}';
    }
}

