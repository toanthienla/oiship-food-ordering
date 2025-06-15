package model;

import java.math.BigDecimal;
import java.util.List;

public class Dish {

    private int dishID;
    private String dishName;
    private BigDecimal opCost;
    private BigDecimal interestPercentage;
    private String image;
    private String dishDescription;
    private int stock;
    private int categoryId;
    private List<Ingredient> ingredients;

    private BigDecimal totalPrice;
    private String ingredientNames;
    private Double avgRating;
    private String formattedPrice;
    private boolean isAvailable;
    private Category category;

    // Constructors
    public Dish() {
    }

    public Dish(int dishID, String dishName, BigDecimal opCost, BigDecimal interestPercentage, String image, String dishDescription, int stock, int categoryId, List<Ingredient> ingredients, BigDecimal totalPrice, String ingredientNames, Double avgRating, String formattedPrice, boolean isAvailable, Category category) {
        this.dishID = dishID;
        this.dishName = dishName;
        this.opCost = opCost;
        this.interestPercentage = interestPercentage;
        this.image = image;
        this.dishDescription = dishDescription;
        this.stock = stock;
        this.categoryId = categoryId;
        this.ingredients = ingredients;
        this.totalPrice = totalPrice;
        this.ingredientNames = ingredientNames;
        this.avgRating = avgRating;
        this.formattedPrice = formattedPrice;
        this.isAvailable = isAvailable;
        this.category = category;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public boolean isIsAvailable() {
        return isAvailable;
    }

    public void setIsAvailable(boolean isAvailable) {
        this.isAvailable = isAvailable;
    }

    public List<Ingredient> getIngredients() {
        return ingredients;
    }

    public void setIngredients(List<Ingredient> ingredients) {
        this.ingredients = ingredients;
    }

    public String getIngredientNames() {
        return ingredientNames;
    }

    public void setIngredientNames(String ingredientNames) {
        this.ingredientNames = ingredientNames;
    }

    public Double getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(Double avgRating) {
        this.avgRating = avgRating;
    }

    public String getFormattedPrice() {
        return formattedPrice;
    }

    public void setFormattedPrice(String formattedPrice) {
        this.formattedPrice = formattedPrice;
    }

    // Getters and Setters
    public int getDishID() {
        return dishID;
    }

    public void setDishID(int dishID) {
        this.dishID = dishID;
    }

    public String getDishName() {
        return dishName;
    }

    public void setDishName(String dishName) {
        this.dishName = dishName;
    }

    public BigDecimal getOpCost() {
        return opCost;
    }

    public void setOpCost(BigDecimal opCost) {
        this.opCost = opCost;
    }

    public BigDecimal getInterestPercentage() {
        return interestPercentage;
    }

    public void setInterestPercentage(BigDecimal interestPercentage) {
        this.interestPercentage = interestPercentage;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDishDescription() {
        return dishDescription;
    }

    public void setDishDescription(String dishDescription) {
        this.dishDescription = dishDescription;
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

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
}
