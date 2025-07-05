package model;

import java.math.BigDecimal;
import java.time.Instant;

/**
 * Represents a payment record for an order.
 */
public class Payment {

    private int id; // Corresponds to PaymentID in DB
    private Instant paymentTime; // DATETIME2 in DB
    private boolean isConfirmed; // BIT in DB
    private int orderID; // FK to Order(orderID)
    private int accountID; // FK to Account(accountID)
    private BigDecimal amountPaid; // DECIMAL(18,2)

    /**
     * Gets the payment ID.
     * @return payment ID.
     */
    public int getId() {
        return id;
    }

    /**
     * Sets the payment ID.
     * @param id the payment ID.
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * Gets the payment time.
     * @return the payment time as Instant.
     */
    public Instant getPaymentTime() {
        return paymentTime;
    }

    /**
     * Sets the payment time.
     * @param paymentTime the payment time as Instant.
     */
    public void setPaymentTime(Instant paymentTime) {
        this.paymentTime = paymentTime;
    }

    /**
     * Checks if the payment is confirmed.
     * @return true if confirmed, false otherwise.
     */
    public boolean getIsConfirmed() {
        return isConfirmed;
    }

    /**
     * Sets the payment confirmation status.
     * @param isConfirmed true if confirmed, false otherwise.
     */
    public void setIsConfirmed(boolean isConfirmed) {
        this.isConfirmed = isConfirmed;
    }

    /**
     * Gets the order ID related to this payment.
     * @return the order ID.
     */
    public int getOrderID() {
        return orderID;
    }

    /**
     * Sets the order ID related to this payment.
     * @param orderID the order ID.
     */
    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    /**
     * Gets the account ID that made the payment.
     * @return the account ID.
     */
    public int getAccountID() {
        return accountID;
    }

    /**
     * Sets the account ID that made the payment.
     * @param accountID the account ID.
     */
    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    /**
     * Gets the amount paid.
     * @return the amount paid as BigDecimal.
     */
    public BigDecimal getAmountPaid() {
        return amountPaid;
    }

    /**
     * Sets the amount paid.
     * @param amountPaid the amount paid as BigDecimal.
     */
    public void setAmountPaid(BigDecimal amountPaid) {
        this.amountPaid = amountPaid;
    }
}
