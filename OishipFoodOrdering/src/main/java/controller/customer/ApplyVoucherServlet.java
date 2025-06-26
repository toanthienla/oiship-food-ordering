package controller.customer;

import dao.ApplyVoucherDAO;
import model.Voucher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;

import org.json.JSONObject;

@WebServlet(name = "ApplyVoucherServlet", urlPatterns = {"/customer/apply-voucher"})
public class ApplyVoucherServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ request
        String code = request.getParameter("voucher");
        String orderTotalStr = request.getParameter("orderTotal");

        HttpSession session = request.getSession(false);
        Integer customerID = (Integer) session.getAttribute("userId");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject result = new JSONObject();

        try {
            BigDecimal orderTotal = new BigDecimal(orderTotalStr);

            ApplyVoucherDAO voucherDAO = new ApplyVoucherDAO();
            Voucher voucher = voucherDAO.getValidVoucher(code, orderTotal);

            if (voucher == null) {
                result.put("success", false);
                result.put("message", "Voucher không hợp lệ hoặc không đủ điều kiện.");
            } else {
                BigDecimal discountAmount;

                if ("%".equals(voucher.getDiscountType())) {
                    discountAmount = orderTotal.multiply(voucher.getDiscount().divide(new BigDecimal(100)));
                } else {
                    discountAmount = voucher.getDiscount();
                }

                // Giới hạn giảm tối đa
                if (voucher.getMaxDiscountValue() != null) {
                    discountAmount = discountAmount.min(voucher.getMaxDiscountValue());
                }

                BigDecimal discountedTotal = orderTotal.subtract(discountAmount);

                // Đáp ứng cho JS
                result.put("success", true);
                result.put("message", "Áp dụng mã giảm giá thành công!");
                result.put("discountAmount", discountAmount);
                result.put("discountedTotal", discountedTotal);
                result.put("voucherID", voucher.getVoucherID());
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi khi áp dụng voucher.");
        }

        out.print(result.toString());
        out.flush();
    }

    @Override
    public String getServletInfo() {
        return "Xử lý áp dụng mã giảm giá với kiểm tra điều kiện phía server";
    }
}
