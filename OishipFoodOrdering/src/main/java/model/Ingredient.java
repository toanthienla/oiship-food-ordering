/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;

/**
 *
 * @author Phi Yen
 */
public class Ingredient {
    
    private int ingredientID;
    private String name;
    private int quantity;
    private BigDecimal unitCost;
    private int dishId;    
    private int accountID;  

    public Ingredient() {
    }

    public Ingredient(int ingredientID, String name, int quantity, BigDecimal unitCost, int dishId, int accountID) {
        this.ingredientID = ingredientID;
        this.name = name;
        this.quantity = quantity;
        this.unitCost = unitCost;
        this.dishId = dishId;
        this.accountID = accountID;
    }


    

    public int getIngredientID() {
        return ingredientID;
    }

    public void setIngredientID(int ingredientID) {
        this.ingredientID = ingredientID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(BigDecimal unitCost) {
        this.unitCost = unitCost;
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
