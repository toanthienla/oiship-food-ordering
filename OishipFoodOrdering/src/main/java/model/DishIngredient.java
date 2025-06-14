package model;

public class DishIngredient {

    private int dishId;
    private int ingredientId;
    private double quantity;
    private Dish dish; // Tham chiếu đến Dish (tùy chọn, để lấy dishName)

    public DishIngredient() {
    }

    public DishIngredient(int dishId, int ingredientId, double quantity) {
        this.dishId = dishId;
        this.ingredientId = ingredientId;
        this.quantity = quantity;
    }

    // Getters and Setters
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
}
