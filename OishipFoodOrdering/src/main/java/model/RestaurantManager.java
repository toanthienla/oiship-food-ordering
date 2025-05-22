package model;

import java.sql.Timestamp;

public class RestaurantManager {

    private int restaurantId;
    private String name;
    private String email;
    private String phone;
    private String password;
    private String address;
    private String openingHours;
    private String cuisineType;
    private int statusId;
    private Timestamp createdAt;

    public RestaurantManager(int restaurantId, String name, String email, String phone, String password, String address,
            String openingHours, String cuisineType, int statusId, Timestamp createdAt) {
        this.restaurantId = restaurantId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.address = address;
        this.openingHours = openingHours;
        this.cuisineType = cuisineType;
        this.statusId = statusId;
        this.createdAt = createdAt;
    }

    public RestaurantManager() {
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getOpeningHours() {
        return openingHours;
    }

    public void setOpeningHours(String openingHours) {
        this.openingHours = openingHours;
    }

    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

}
