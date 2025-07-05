package controller.servlet.payment;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import utils.service.payment.PaymentService;
import utils.service.paymentconfig.PayOSConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.payos.PayOS;
import vn.payos.type.Webhook;
import vn.payos.type.WebhookData;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/customer/payment/payos_transfer_handler"})
public class PaymentServlet extends HttpServlet {

    private final PayOS payOS;
    private final Gson gson = new GsonBuilder().create();
    private final PaymentService paymentService = new PaymentService(); // đã viết DAO ở đây

    public PaymentServlet() {
        this.payOS = PayOSConfig.getPayOS();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        JsonObject responseJson = new JsonObject();

        try {
            StringBuilder jb = new StringBuilder();
            String line;
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null) {
                jb.append(line);
            }

            Webhook webhookBody = gson.fromJson(jb.toString(), Webhook.class);

            WebhookData data = payOS.verifyPaymentWebhookData(webhookBody);
            System.out.println("Webhook received: " + data);

            if ("00".equals(data.getCode())) {
                long orderCode = data.getOrderCode();

                // ✅ Gọi xử lý cập nhật DB: payment_status = 1
                paymentService.payOrder((int) orderCode);
                System.out.println("Payment SUCCESS for order #" + orderCode);
            } else {
                System.out.println("Payment FAILED or CANCELLED: " + data.getCode());
            }

            responseJson.addProperty("error", 0);
            responseJson.addProperty("message", "Webhook handled");
        } catch (Exception e) {
            e.printStackTrace();
            responseJson.addProperty("error", -1);
            responseJson.addProperty("message", "Webhook error: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(responseJson));
    }
}
