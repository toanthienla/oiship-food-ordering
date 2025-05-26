package model;

public class Contact {

    private int contactId;
    private String contactSubject;
    private String contactMessage;
    private int accountId;

    public Contact() {
    }

    public Contact(int contactId, String contactSubject, String contactMessage, int accountId) {
        this.contactId = contactId;
        this.contactSubject = contactSubject;
        this.contactMessage = contactMessage;
        this.accountId = accountId;
    }

    public int getContactId() {
        return contactId;
    }

    public void setContactId(int contactId) {
        this.contactId = contactId;
    }

    public String getContactSubject() {
        return contactSubject;
    }

    public void setContactSubject(String contactSubject) {
        this.contactSubject = contactSubject;
    }

    public String getContactMessage() {
        return contactMessage;
    }

    public void setContactMessage(String contactMessage) {
        this.contactMessage = contactMessage;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
}
