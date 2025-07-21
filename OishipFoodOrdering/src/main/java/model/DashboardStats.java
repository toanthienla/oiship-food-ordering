package model;

public class DashboardStats {
    // Order stats
    private int totalOrders;
    private int pending, confirmed, preparing, delivery, delivered, cancelled, failed;
    
    // Payment stats
    private int unpaid, paid, refunded;
    
    // Review stats
    private int totalReviews;
    private int star1, star2, star3, star4, star5;
    
    // Constructor
    public DashboardStats() {}
    
    // Getters and Setters for all fields...
    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }

    public int getPending() {
        return pending;
    }

    public void setPending(int pending) {
        this.pending = pending;
    }

    public int getConfirmed() {
        return confirmed;
    }

    public void setConfirmed(int confirmed) {
        this.confirmed = confirmed;
    }

    public int getPreparing() {
        return preparing;
    }

    public void setPreparing(int preparing) {
        this.preparing = preparing;
    }

    public int getDelivery() {
        return delivery;
    }

    public void setDelivery(int delivery) {
        this.delivery = delivery;
    }

    public int getDelivered() {
        return delivered;
    }

    public void setDelivered(int delivered) {
        this.delivered = delivered;
    }

    public int getCancelled() {
        return cancelled;
    }

    public void setCancelled(int cancelled) {
        this.cancelled = cancelled;
    }

    public int getFailed() {
        return failed;
    }

    public void setFailed(int failed) {
        this.failed = failed;
    }

    public int getUnpaid() {
        return unpaid;
    }

    public void setUnpaid(int unpaid) {
        this.unpaid = unpaid;
    }

    public int getPaid() {
        return paid;
    }

    public void setPaid(int paid) {
        this.paid = paid;
    }

    public int getRefunded() {
        return refunded;
    }

    public void setRefunded(int refunded) {
        this.refunded = refunded;
    }

    public int getTotalReviews() {
        return totalReviews;
    }

    public void setTotalReviews(int totalReviews) {
        this.totalReviews = totalReviews;
    }

    public int getStar1() {
        return star1;
    }

    public void setStar1(int star1) {
        this.star1 = star1;
    }

    public int getStar2() {
        return star2;
    }

    public void setStar2(int star2) {
        this.star2 = star2;
    }

    public int getStar3() {
        return star3;
    }

    public void setStar3(int star3) {
        this.star3 = star3;
    }

    public int getStar4() {
        return star4;
    }

    public void setStar4(int star4) {
        this.star4 = star4;
    }

    public int getStar5() {
        return star5;
    }

    public void setStar5(int star5) {
        this.star5 = star5;
    }
    
    
}