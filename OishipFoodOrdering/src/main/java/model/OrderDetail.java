package model;

import java.util.Date;

public class OrderDetail {

    private int ODID; //Order Detail id
    private int quantity;
    private Dish dish;
    private String DishName;
    private int OrderStatus;
    private int OrderId; //Order id
    private String customerName;
    private Date createAt;
    private String dishDescription;
    private Order order;

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

    public String getDishName() {
        return DishName;
    }

    public void setDishName(String DishName) {
        this.DishName = DishName;
    }

    public int getOrderStatus() {
        return OrderStatus;
    }

    public void setOrderStatus(int OrderStatus) {
        this.OrderStatus = OrderStatus;
    }

    public int getOrderId() {
        return OrderId;
    }

    public void setOrderId(int OrderId) {
        this.OrderId = OrderId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public String getDishDescription() {
        return dishDescription;
    }

    public void setDishDescription(String dishDescription) {
        this.dishDescription = dishDescription;
    }

// Getter Setter cho order
public Order getOrder() {
    return order;
}

public void setOrder(Order order) {
    this.order = order;
}
}
