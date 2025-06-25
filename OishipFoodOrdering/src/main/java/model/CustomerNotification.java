package model;


public class CustomerNotification {
    private int customerID;
    private int notID;
    private boolean isRead; // true = đã đọc, false = chưa đọc

    public CustomerNotification() {
    }

    public CustomerNotification(int customerID, int notID, boolean isRead) {
        this.customerID = customerID;
        this.notID = notID;
        this.isRead = isRead;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getNotID() {
        return notID;
    }

    public void setNotID(int notID) {
        this.notID = notID;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }
}
