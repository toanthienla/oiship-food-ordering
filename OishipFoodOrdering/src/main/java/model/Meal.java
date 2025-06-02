package model;

public class Meal {

    private int mealID;
    private String mealName;
    private double price;
    private String image;
    private String mealDescription;
    private int stock;
    private int categoryId; // FK_Meal_Category

    // Constructor mặc định
    public Meal() {
    }

    // Constructor đầy đủ
    public Meal(int mealID, String mealName, double price, String image, String mealDescription, int stock, int categoryId) {
        this.mealID = mealID;
        this.mealName = mealName;
        this.price = price;
        this.image = image;
        this.mealDescription = mealDescription;
        this.stock = stock;
        this.categoryId = categoryId;
    }

    // Getters và Setters
    public int getMealID() {
        return mealID;
    }

    public void setMealID(int mealID) {
        this.mealID = mealID;
    }

    public String getMealName() {
        return mealName;
    }

    public void setMealName(String mealName) {
        this.mealName = mealName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getMealDescription() {
        return mealDescription;
    }

    public void setMealDescription(String mealDescription) {
        this.mealDescription = mealDescription;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    @Override
    public String toString() {
        return "Meal{"
                + "mealID=" + mealID
                + ", mealName='" + mealName + '\''
                + ", price=" + price
                + ", image='" + image + '\''
                + ", mealDescription='" + mealDescription + '\''
                + ", stock=" + stock
                + ", categoryId=" + categoryId
                + '}';
    }
}
