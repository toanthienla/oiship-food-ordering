/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Phi Yen
 */
public class Cart {
     private int cartID;
    private int customerID;
    private int dishID;
    private int quantity;
    private Dish dish;

    public Cart() {
    }

    public Cart(int cartID, int customerID, int dishID, int quantity, Dish dish) {
        this.cartID = cartID;
        this.customerID = customerID;
        this.dishID = dishID;
        this.quantity = quantity;
        this.dish = dish;
    }

    public int getCartID() {
        return cartID;
    }

    public void setCartID(int cartID) {
        this.cartID = cartID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getDishID() {
        return dishID;
    }

    public void setDishID(int dishID) {
        this.dishID = dishID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Dish getDish() {
        return dish;
    }

    public void setDish(Dish dish) {
        this.dish = dish;
    }

    @Override
    public String toString() {
        return "Cart{" + "cartID=" + cartID + ", customerID=" + customerID + ", dishID=" + dishID + ", quantity=" + quantity + ", dish=" + dish + '}';
    }

}
