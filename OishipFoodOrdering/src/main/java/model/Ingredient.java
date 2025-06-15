/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.List;

/**
 *
 * @author Phi Yen
 */
public class Ingredient {
    
    private int ingredientId;
    private String ingredientName;
    private BigDecimal unitCost;
    private int fkIngredientAccount;
    private List<DishIngredient> dishIngredients; // Thêm danh sách DishIngredient
    private int dishId;    
    private int accountID; 
    
    public Ingredient() {
    }

    public Ingredient(int ingredientId, String ingredientName, BigDecimal unitCost, int fkIngredientAccount, List<DishIngredient> dishIngredients, int dishId, int accountID) {
        this.ingredientId = ingredientId;
        this.ingredientName = ingredientName;
        this.unitCost = unitCost;
        this.fkIngredientAccount = fkIngredientAccount;
        this.dishIngredients = dishIngredients;
        this.dishId = dishId;
        this.accountID = accountID;
    }

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

    public BigDecimal getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(BigDecimal unitCost) {
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

    public int getDishId() {
        return dishId;
    }

    public void setDishId(int dishId) {
        this.dishId = dishId;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    


}
