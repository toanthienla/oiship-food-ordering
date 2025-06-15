package model;

public class OrderDetail {
    private int ODID;
    private int quantity;
    private Dish dish;

    public OrderDetail() {
    }

    public OrderDetail(int ODID, int quantity, Dish dish) {
        this.ODID = ODID;
        this.quantity = quantity;
        this.dish = dish;
    }

    public int getODID() {
        return ODID;
    }

    public void setODID(int ODID) {
        this.ODID = ODID;
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
}
