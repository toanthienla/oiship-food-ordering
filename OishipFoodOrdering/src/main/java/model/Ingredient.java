package model;

import java.util.List;

public class Ingredient {

    private int ingredientId;
    private String ingredientName;
    private double unitCost;
    private int fkIngredientAccount;
    private List<DishIngredient> dishIngredients; // Thêm danh sách DishIngredient

    public Ingredient() {
    }

    public Ingredient(int ingredientId, String ingredientName, double unitCost, int fkIngredientAccount) {
        this.ingredientId = ingredientId;
        this.ingredientName = ingredientName;
        this.unitCost = unitCost;
        this.fkIngredientAccount = fkIngredientAccount;
    }

    // Getters and Setters
    public int getIngredientId() {
        return ingredientId;
    }

    public void setIngredientId(int ingredientId) {
        this.ingredientId = ingredientId;
    }

    public String getIngredientName() {
        return ingredientName;
    }

    public void setIngredientName(String ingredientName) {
        this.ingredientName = ingredientName;
    }

    public double getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(double unitCost) {
        this.unitCost = unitCost;
    }

    public int getFkIngredientAccount() {
        return fkIngredientAccount;
    }

    public void setFkIngredientAccount(int fkIngredientAccount) {
        this.fkIngredientAccount = fkIngredientAccount;
    }

    public List<DishIngredient> getDishIngredients() {
        return dishIngredients;
    }

    public void setDishIngredients(List<DishIngredient> dishIngredients) {
        this.dishIngredients = dishIngredients;
    }
}
