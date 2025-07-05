package utils.service.payment;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dao.CustomerDAO;
import dao.OrderDAO;
import dao.PaymentDAO;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import model.Order;
import model.Payment;
import utils.DBContext;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.Instant;
import vn.payos.type.CheckoutResponseData;

/**
 * PaymentService handles the business logic for processing order payments.
 */
public class PaymentService extends DBContext {
    public static void main(String[] args) {
        PaymentService paymentService = new PaymentService();
        try {
            paymentService.payOrder(13);
            System.out.println("Payment processed successfully.");
        } catch (Exception e) {
            System.err.println("Error processing payment: " + e.getMessage());
        }
    }

    public boolean payOrder(int orderId) {
        OrderDAO orderDAO = new OrderDAO();
        PaymentDAO paymentDAO = new PaymentDAO();
        CustomerDAO customerDAO = new CustomerDAO(); // ✅ Thêm DAO để lấy accountID

        DBContext dbContext = new DBContext();
        try (Connection conn = dbContext.getConnection()) {
            // 1. Tìm đơn hàng
            Order order = orderDAO.findById(orderId);
            if (order == null) {
                throw new IllegalArgumentException("Order not found for ID: " + orderId);
            }

            // 2. Lấy customerId từ đơn hàng
            int customerId = order.getCustomerID();

            // 3. Lấy accountId từ customer
            int accountId = customerDAO.getAccountIdByCustomerId(customerId); // 🔍 Cần hàm này trong CustomerDAO

            // 4. Tạo đối tượng Payment
            Payment payment = new Payment();
            payment.setOrderID(order.getOrderID());
            payment.setAccountID(accountId);
            payment.setPaymentTime(Instant.now());
            payment.setIsConfirmed(true);
            payment.setAmountPaid(order.getAmount());

            // 5. Lưu payment
            paymentDAO.save(payment);

            // 6. Cập nhật trạng thái thanh toán cho đơn hàng
            order.setPaymentStatus(1); // 1 = đã thanh toán
            orderDAO.updatePaymentStatus(orderId, 1);

        } catch (SQLException e) {
            throw new RuntimeException("Error processing payment", e);
        }
        return false;
    }


}
