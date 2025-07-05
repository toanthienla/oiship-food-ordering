package controller.servlet.payment;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import dao.OrderDAO;
import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;
import model.Customer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import utils.service.payment.PaymentService;
import utils.service.paymentconfig.PayOSConfig;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;

@WebServlet(name = "CheckoutServlet", urlPatterns = {
    "/customer/payment/create-payment-link",
    "/customer/payment/success",
    "/customer/payment/cancel"
})
public class CheckoutServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(CheckoutServlet.class);
    private final PayOS payOS = PayOSConfig.getPayOS();
    private final Gson gson = new GsonBuilder().create();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = (String) session.getAttribute("email");
        Customer customer = new CustomerDAO().getCustomerByEmail(email);
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String servletPath = request.getServletPath();

        try {
            Order order = orderDAO.findUnpaidOrderByCustomerId(customer.getCustomerID());

            switch (servletPath) {
                case "/customer/payment/success":
                    if (order != null) {
                        new PaymentService().payOrder(order.getOrderID());
                    }
                    request.getRequestDispatcher("/WEB-INF/views/customer/success.jsp").forward(request, response);
                    break;

                case "/customer/payment/cancel":
                    request.getRequestDispatcher("/WEB-INF/views/customer/confirm_order.jsp").forward(request, response);
                    break;

                case "/customer/payment/create-payment-link":
                    if (order == null) {
                        writeJsonResponse(response, buildErrorResponse("Không tìm thấy đơn chưa thanh toán."));
                        return;
                    }

                    if (order.getCheckoutUrl() != null && !order.getCheckoutUrl().isEmpty()) {
                        JsonObject data = new JsonObject();
                        data.addProperty("checkoutUrl", order.getCheckoutUrl());
                        JsonObject resJson = new JsonObject();
                        resJson.addProperty("error", 0);
                        resJson.addProperty("message", "success");
                        resJson.add("data", data);
                        writeJsonResponse(response, resJson);
                        return;
                    }

                    // Tạo mới link PayOS
                    BigDecimal amount = order.getAmount();
                    System.out.println("amount: " + amount);

                    String description = "Order #" + order.getOrderID() + " - Customer: " + customer.getCustomerID();

                    CheckoutResponseData checkoutData = payOS.createPaymentLink(
                            buildPaymentData(amount.intValue(), description, order.getOrderID(), getBaseUrl(request))
                    );

                    // Lưu lại checkoutUrl vào DB
                    orderDAO.updateCheckoutUrl(order.getOrderID(), checkoutData.getCheckoutUrl());

                    JsonObject data = new JsonObject();
                    data.addProperty("checkoutUrl", checkoutData.getCheckoutUrl());
                    JsonObject resJson = new JsonObject();
                    resJson.addProperty("error", 0);
                    resJson.addProperty("message", "success");
                    resJson.add("data", data);
                    writeJsonResponse(response, resJson);
                    break;

                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Tạm thời in log lỗi ra console
            logger.error("Error in GET: ", e);
            writeJsonResponse(response, buildErrorResponse("Đã xảy ra lỗi trong xử lý thanh toán."));
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // POST không hỗ trợ
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    private PaymentData buildPaymentData(int price, String description, int orderId, String baseUrl) {
        return PaymentData.builder()
                .orderCode((long) orderId)
                .amount(price)
                .description(description)
                .returnUrl(baseUrl + "/customer/payment/success")
                .cancelUrl(baseUrl + "/customer/payment/cancel")
                .item(ItemData.builder()
                        .name("Oiship Order #" + orderId)
                        .quantity(1)
                        .price(price)
                        .build())
                .build();
    }

    private String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int port = request.getServerPort();
        String context = request.getContextPath();
        return scheme + "://" + serverName + (port == 80 || port == 443 ? "" : ":" + port) + context;
    }

    private void writeJsonResponse(HttpServletResponse response, JsonObject json) throws IOException {
        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(json));
    }

    private JsonObject buildErrorResponse(String message) {
        JsonObject res = new JsonObject();
        res.addProperty("error", -1);
        res.addProperty("message", message);
        res.add("data", null);
        return res;
    }
}
