package dao;

import model.Payment;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import utils.DBContext;

/**
 * PaymentDAO handles database operations related to the Payment entity.
 */
public class PaymentDAO extends DBContext {

    public PaymentDAO() {
        super();
    }

    public void save(Payment payment) {
        String sql = "INSERT INTO Payment (PaymentTime, IsConfirmed, OrderID, AccountID, AmountPaid) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.from(payment.getPaymentTime())); // Instant → Timestamp
            ps.setBoolean(2, payment.getIsConfirmed());
            ps.setInt(3, payment.getOrderID());
            ps.setInt(4, payment.getAccountID());
            ps.setBigDecimal(5, payment.getAmountPaid());

            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error saving payment", e);
        }
    }

//    public static void main(String[] args) {
//        PaymentDAO paymentDAO = new PaymentDAO();
//        Payment payment = new Payment();
//        payment.setFeeID(new FeeDAO().findById(3)); // Example FeeID
//        payment.setAmountPaid(BigDecimal.valueOf(2000)); // Example amount
//        payment.setPaymentDate(Instant.now());
//        payment.setPaymentStatus(1); // Assuming 1 means successful
//        paymentDAO.save(payment);
//    }
}
