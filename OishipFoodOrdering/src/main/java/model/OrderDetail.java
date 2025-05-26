package model;

public class OrderDetail {
    private int orderDetailId;
    private int quantity;
    private boolean isCart;
    private int orderId;
    private int menuDetailId;
    private int restaurantManagerId;
    private int customerId;

    public OrderDetail(int orderDetailId, int quantity, boolean isCart, int orderId, int menuDetailId, int restaurantManagerId, int customerId) {
        this.orderDetailId = orderDetailId;
        this.quantity = quantity;
        this.isCart = isCart;
        this.orderId = orderId;
        this.menuDetailId = menuDetailId;
        this.restaurantManagerId = restaurantManagerId;
        this.customerId = customerId;
    }

    public int getOrderDetailId() { return orderDetailId; }
    public int getQuantity() { return quantity; }
    public boolean isCart() { return isCart; }
    public int getOrderId() { return orderId; }
    public int getMenuDetailId() { return menuDetailId; }
    public int getRestaurantManagerId() { return restaurantManagerId; }
    public int getCustomerId() { return customerId; }

    public void setQuantity(int quantity) { this.quantity = quantity; }
    public void setCart(boolean cart) { isCart = cart; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public void setMenuDetailId(int menuDetailId) { this.menuDetailId = menuDetailId; }
    public void setRestaurantManagerId(int restaurantManagerId) { this.restaurantManagerId = restaurantManagerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
}
