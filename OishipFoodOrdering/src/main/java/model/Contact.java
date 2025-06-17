package model;

import java.sql.Timestamp;

public class Contact {

    private int contactID;
    private String subject;
    private String message;
    private int customerID;
    private Customer customer;
    private Timestamp createAt;

    public Contact() {
    }

    public Contact(String subject, String message, int customerID) {
        this.subject = subject;
        this.message = message;
        this.customerID = customerID;
    }

    public Contact(int contactID, String subject, String message, int customerID) {
        this.contactID = contactID;
        this.subject = subject;
        this.message = message;
        this.customerID = customerID;
    }

    // Getters and Setters
    public int getContactID() {
        return contactID;
    }

    public void setContactID(int contactID) {
        this.contactID = contactID;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Timestamp getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Timestamp createAt) {
        this.createAt = createAt;
    }
}
