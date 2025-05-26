package model;

public class Notification {
    private int notificationId;
    private String notiMessage;
    private String notiType;
    private boolean isRead;
    private int orderId;
    private int customerId;
    private int restaurantManagerId;
    private int shipperId;

    public Notification() {
    }

    public Notification(int notificationId, String notiMessage, String notiType, boolean isRead,
                        int orderId, int customerId, int restaurantManagerId, int shipperId) {
        this.notificationId = notificationId;
        this.notiMessage = notiMessage;
        this.notiType = notiType;
        this.isRead = isRead;
        this.orderId = orderId;
        this.customerId = customerId;
        this.restaurantManagerId = restaurantManagerId;
        this.shipperId = shipperId;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public String getNotiMessage() {
        return notiMessage;
    }

    public void setNotiMessage(String notiMessage) {
        this.notiMessage = notiMessage;
    }

    public String getNotiType() {
        return notiType;
    }

    public void setNotiType(String notiType) {
        this.notiType = notiType;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getRestaurantManagerId() {
        return restaurantManagerId;
    }

    public void setRestaurantManagerId(int restaurantManagerId) {
        this.restaurantManagerId = restaurantManagerId;
    }

    public int getShipperId() {
        return shipperId;
    }

    public void setShipperId(int shipperId) {
        this.shipperId = shipperId;
    }
}
