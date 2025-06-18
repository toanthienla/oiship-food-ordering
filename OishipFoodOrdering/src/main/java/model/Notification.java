package model;

public class Notification {
    private int notID;
    private String notTitle;
    private String notDescription;
    private int accountID;

    public Notification() {}

    public Notification(int notID, String notTitle, String notDescription, int accountID) {
        this.notID = notID;
        this.notTitle = notTitle;
        this.notDescription = notDescription;
        this.accountID = accountID;
    }

    public Notification(String notTitle, String notDescription, int accountID) {
        this.notTitle = notTitle;
        this.notDescription = notDescription;
        this.accountID = accountID;
    }

    public int getNotID() {
        return notID;
    }

    public void setNotID(int notID) {
        this.notID = notID;
    }

    public String getNotTitle() {
        return notTitle;
    }

    public void setNotTitle(String notTitle) {
        this.notTitle = notTitle;
    }

    public String getNotDescription() {
        return notDescription;
    }

    public void setNotDescription(String notDescription) {
        this.notDescription = notDescription;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    
}
