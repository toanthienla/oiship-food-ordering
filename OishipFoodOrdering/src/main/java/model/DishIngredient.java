package model;

import model.Dish;
import java.math.BigDecimal;

public class DishIngredient {

    private int dishId;
    private int ingredientId;
    private double quantity;
    private Dish dish; // Optional, for displaying dish name
    private String ingredientName; // Helper for display
    private BigDecimal ingredientCost; // Helper for display

    public DishIngredient() {}

    public DishIngredient(int dishId, int ingredientId, double quantity) {
        this.dishId = dishId;
        this.ingredientId = ingredientId;
        this.quantity = quantity;
    }

    // Getters and setters
    public int getDishId() {
        return dishId;
    }

    public void setDishId(int dishId) {
        this.dishId = dishId;
    }

    public int getIngredientId() {
        return ingredientId;
    }

    public void setIngredientId(int ingredientId) {
        this.ingredientId = ingredientId;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public Dish getDish() {
        return dish;
    }

    public void setDish(Dish dish) {
        this.dish = dish;
    }

    public String getIngredientName() {
        return ingredientName;
    }

    public void setIngredientName(String ingredientName) {
        this.ingredientName = ingredientName;
    }

    public BigDecimal getIngredientCost() {
        return ingredientCost;
    }

    public void setIngredientCost(BigDecimal ingredientCost) {
        this.ingredientCost = ingredientCost;
    }

    @Override
    public String toString() {
        return "DishIngredient{" + "dishId=" + dishId + ", ingredientId=" + ingredientId + ", quantity=" + quantity + ", dish=" + dish + ", ingredientName=" + ingredientName + ", ingredientCost=" + ingredientCost + '}';
    }
}