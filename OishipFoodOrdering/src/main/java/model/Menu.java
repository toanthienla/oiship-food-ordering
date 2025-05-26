package model;

public class Menu {
    private int menuId;
    private boolean available;
    private String category;
    private int restaurantManagerId;

    public Menu() {
    }

    public Menu(int menuId, boolean available, String category, int restaurantManagerId) {
        this.menuId = menuId;
        this.available = available;
        this.category = category;
        this.restaurantManagerId = restaurantManagerId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getRestaurantManagerId() {
        return restaurantManagerId;
    }

    public void setRestaurantManagerId(int restaurantManagerId) {
        this.restaurantManagerId = restaurantManagerId;
    }
}
