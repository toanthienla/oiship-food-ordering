package model;

public class Customer {

    private int customerID; // Khóa chính, tham chiếu đến accountID trong Account
    private String phone;
    private String address;

    public Customer() {
    }

    public Customer(int customerID, String phone, String address) {
        this.customerID = customerID;
        setPhone(phone);    // Use setter to enforce constraints
        setAddress(address); // Use setter to enforce constraints
    }

    // Getters and Setters
    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        if (phone != null && phone.length() > 15) {
            throw new IllegalArgumentException("Phone must not exceed 15 characters");
        }
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        if (address != null && address.length() > 255) {
            throw new IllegalArgumentException("Address must not exceed 255 characters");
        }
        this.address = address;
    }
}
