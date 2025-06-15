package model;

public class Staff extends Account {

    public Staff() {
        super();
    }

    public Staff(int accountID, String fullName, String email, String password, String role, java.util.Date createAt) {
        super(accountID, fullName, email, password, role, createAt);
    }

}

