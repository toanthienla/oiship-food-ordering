package model;

import java.math.BigDecimal;

public class MenuDetail {

    private int menuDetailId;
    private String menuDetailName;
    private BigDecimal price;
    private String image;
    private String menuDescription;
    private boolean isAvailable;
    private int restaurantManagerId;
    private int menuId;

    public MenuDetail() {
    }

    public MenuDetail(int menuDetailId, String menuDetailName, BigDecimal price, String image, String menuDescription, boolean isAvailable, int restaurantManagerId, int menuId) {
        this.menuDetailId = menuDetailId;
        this.menuDetailName = menuDetailName;
        this.price = price;
        this.image = image;
        this.menuDescription = menuDescription;
        this.isAvailable = isAvailable;
        this.restaurantManagerId = restaurantManagerId;
        this.menuId = menuId;
    }

    public MenuDetail(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public boolean isIsAvailable() {
        return isAvailable;
    }

    public void setIsAvailable(boolean isAvailable) {
        this.isAvailable = isAvailable;
    }

    // Getters and Setters
    public int getMenuDetailId() {
        return menuDetailId;
    }

    public void setMenuDetailId(int menuDetailId) {
        this.menuDetailId = menuDetailId;
    }

    public String getMenuDetailName() {
        return menuDetailName;
    }

    public void setMenuDetailName(String menuDetailName) {
        this.menuDetailName = menuDetailName;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getMenuDescription() {
        return menuDescription;
    }

    public void setMenuDescription(String menuDescription) {
        this.menuDescription = menuDescription;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    public int getRestaurantManagerId() {
        return restaurantManagerId;
    }

    public void setRestaurantManagerId(int restaurantManagerId) {
        this.restaurantManagerId = restaurantManagerId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }
}
