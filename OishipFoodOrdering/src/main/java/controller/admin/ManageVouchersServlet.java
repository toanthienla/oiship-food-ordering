package controller.admin;

import dao.VoucherDAO;
import model.Voucher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/admin/manage-vouchers")
public class ManageVouchersServlet extends HttpServlet {

    private VoucherDAO voucherDAO;

    @Override
    public void init() {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Voucher> vouchers = voucherDAO.getAllVouchers();
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage_vouchers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String code = request.getParameter("code");
                String description = request.getParameter("voucherDescription");

                // Safe BigDecimal parsing
                String discountStr = request.getParameter("discount");
                BigDecimal discount = (discountStr != null && !discountStr.isEmpty()) ? new BigDecimal(discountStr) : BigDecimal.ZERO;

                String maxDiscountStr = request.getParameter("maxDiscountValue");
                BigDecimal maxDiscount = (maxDiscountStr != null && !maxDiscountStr.isEmpty()) ? new BigDecimal(maxDiscountStr) : BigDecimal.ZERO;

                String minOrderStr = request.getParameter("minOrderValue");
                BigDecimal minOrder = (minOrderStr != null && !minOrderStr.isEmpty()) ? new BigDecimal(minOrderStr) : BigDecimal.ZERO;

                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");

                LocalDateTime start = (startDateStr != null) ? LocalDate.parse(startDateStr).atStartOfDay() : LocalDateTime.now();
                LocalDateTime end = (endDateStr != null) ? LocalDate.parse(endDateStr).atStartOfDay() : LocalDateTime.now().plusDays(7);

                String usageLimitStr = request.getParameter("usageLimit");
                int usageLimit = (usageLimitStr != null && !usageLimitStr.isEmpty()) ? Integer.parseInt(usageLimitStr) : 1;

                boolean active = "1".equals(request.getParameter("active"));

                HttpSession session = request.getSession();
                Integer accountID = (Integer) session.getAttribute("userId");
                if (accountID == null) {
                    accountID = 1; // fallback user
                }

                Voucher v = new Voucher(0, code, description, discount, maxDiscount, minOrder,
                        start, end, usageLimit, 0, active, accountID);

                voucherDAO.addVoucher(v);
                request.setAttribute("message", "Voucher added successfully!");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                voucherDAO.deleteVoucher(id);
                request.setAttribute("message", "Voucher deleted successfully!");
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("voucherID"));
                String code = request.getParameter("code");
                String description = request.getParameter("description");

                String discountStr = request.getParameter("discount");
                BigDecimal discount = (discountStr != null && !discountStr.isEmpty()) ? new BigDecimal(discountStr) : BigDecimal.ZERO;

                String maxDiscountStr = request.getParameter("maxDiscount");
                BigDecimal maxDiscount = (maxDiscountStr != null && !maxDiscountStr.isEmpty()) ? new BigDecimal(maxDiscountStr) : BigDecimal.ZERO;

                String minOrderStr = request.getParameter("minOrder");
                BigDecimal minOrder = (minOrderStr != null && !minOrderStr.isEmpty()) ? new BigDecimal(minOrderStr) : BigDecimal.ZERO;

                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");

                LocalDateTime start = (startDateStr != null && !startDateStr.isEmpty()) ? LocalDate.parse(startDateStr).atStartOfDay() : LocalDateTime.now();
                LocalDateTime end = (endDateStr != null && !endDateStr.isEmpty()) ? LocalDate.parse(endDateStr).atStartOfDay() : LocalDateTime.now().plusDays(7);

                String usageLimitStr = request.getParameter("usageLimit");
                int usageLimit = (usageLimitStr != null && !usageLimitStr.isEmpty()) ? Integer.parseInt(usageLimitStr) : 1;

                String activeStr = request.getParameter("active");
                boolean active = "1".equals(activeStr);

                int usedCount = voucherDAO.getUsedCountByVoucherId(id); // fetch from DB

                HttpSession session = request.getSession();
                Integer accountID = (Integer) session.getAttribute("userId");
                if (accountID == null) {
                    accountID = 1; // fallback
                }

                Voucher updatedVoucher = new Voucher(id, code, description, discount, maxDiscount, minOrder,
                        start, end, usageLimit, usedCount, active, accountID);

                voucherDAO.updateVoucher(updatedVoucher);
                request.setAttribute("message", "Voucher updated successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing the request.");
        }

        List<Voucher> vouchers = voucherDAO.getAllVouchers();
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage_vouchers.jsp").forward(request, response);
    }
}
