package controller.servlet.payment;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import dao.OrderDAO;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.Order;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;
import vn.payos.type.PaymentLinkData;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import utils.service.paymentconfig.PayOSConfig;

@WebServlet(name = "OrderServlet", urlPatterns = {
        "/customer/order/create",
        "/customer/order/confirm-webhook",
        "/customer/order/get-link"
})
public class OrderServlet extends HttpServlet {

    private final PayOS payOS = PayOSConfig.getPayOS();
    private final Gson gson = new GsonBuilder().create();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        response.setContentType("application/json");
        JsonObject resJson = new JsonObject();

        if ("/customer/order/create".equals(path)) {
            try {
                HttpSession session = request.getSession(false);
                if (session == null || session.getAttribute("email") == null) {
                    throw new Exception("Chưa đăng nhập");
                }

                String email = session.getAttribute("email").toString();
                Account account = new AccountDAO().getAccountByEmail(email);
                if (account == null) throw new Exception("Không tìm thấy tài khoản");

                OrderDAO orderDAO = new OrderDAO();
                Order order = orderDAO.findUnpaidOrderByCustomerId(account.getAccountID());
                if (order == null) throw new Exception("Không có đơn hàng nào chưa thanh toán");

                int price = order.getAmount().intValue();
                if (price <= 0) throw new Exception("Số tiền không hợp lệ");

                ItemData item = ItemData.builder()
                        .name("Thanh toán đơn hàng #" + order.getOrderID())
                        .price(price)
                        .quantity(1)
                        .build();

                String baseUrl = getBaseUrl(request);
                PaymentData paymentData = PaymentData.builder()
                        .orderCode((long)order.getOrderID())
                        .description("Thanh toán đơn hàng #" + order.getOrderID())
                        .amount(price)
                        .item(item)
                        .returnUrl(baseUrl + "/customer/success.jsp")
                        .cancelUrl(baseUrl + "/customer/confirm_order.jsp")
                        .build();

                CheckoutResponseData checkoutData = payOS.createPaymentLink(paymentData);

                resJson.addProperty("error", 0);
                resJson.addProperty("message", "success");
                JsonObject data = new JsonObject();
                data.addProperty("checkoutUrl", checkoutData.getCheckoutUrl());
                resJson.add("data", data);
            } catch (Exception e) {
                resJson = buildErrorResponse(e.getMessage());
            }
            writeJsonResponse(response, resJson);
        } else if ("/customer/order/confirm-webhook".equals(path)) {
            try {
                StringBuilder jb = new StringBuilder();
                String line;
                BufferedReader reader = request.getReader();
                while ((line = reader.readLine()) != null) {
                    jb.append(line);
                }
                Map<String, String> requestBody = gson.fromJson(jb.toString(), HashMap.class);
                String result = payOS.confirmWebhook(requestBody.get("webhookUrl"));
                resJson.addProperty("error", 0);
                resJson.addProperty("message", "ok");
                resJson.add("data", gson.toJsonTree(result));
            } catch (Exception e) {
                resJson = buildErrorResponse(e.getMessage());
            }
            writeJsonResponse(response, resJson);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String path = request.getServletPath();
        response.setContentType("application/json");
        JsonObject resJson = new JsonObject();

        if ("/customer/order/get-link".equals(path)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                PaymentLinkData linkData = payOS.getPaymentLinkInformation((long) orderId);
                resJson.addProperty("error", 0);
                resJson.addProperty("message", "success");
                resJson.add("data", gson.toJsonTree(linkData));
            } catch (Exception e) {
                resJson = buildErrorResponse(e.getMessage());
            }
            writeJsonResponse(response, resJson);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        return scheme + "://" + serverName + ((serverPort == 80 || serverPort == 443) ? "" : ":" + serverPort) + contextPath;
    }

    private void writeJsonResponse(HttpServletResponse response, JsonObject json) throws IOException {
        response.getWriter().write(gson.toJson(json));
    }

    private JsonObject buildErrorResponse(String message) {
        JsonObject json = new JsonObject();
        json.addProperty("error", -1);
        json.addProperty("message", message);
        json.add("data", null);
        return json;
    }
}
