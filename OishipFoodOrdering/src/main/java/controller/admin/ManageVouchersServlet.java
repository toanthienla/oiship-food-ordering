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
        System.out.println("Vouchers: " + vouchers);
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
                String description = request.getParameter("description");
                String discountType = request.getParameter("discountType"); 

                BigDecimal discount = parseBigDecimal(request.getParameter("discount"));
                BigDecimal maxDiscount = parseBigDecimal(request.getParameter("maxDiscount"));
                BigDecimal minOrder = parseBigDecimal(request.getParameter("minOrder"));

                LocalDateTime start = parseDate(request.getParameter("startDate"), LocalDateTime.now());
                LocalDateTime end = parseDate(request.getParameter("endDate"), LocalDateTime.now().plusDays(7));

                int usageLimit = parseInt(request.getParameter("usageLimit"), 1);
                boolean active = "1".equals(request.getParameter("active"));

                HttpSession session = request.getSession();
                Integer accountID = (Integer) session.getAttribute("userId");
                if (accountID == null) accountID = 1;

                Voucher v = new Voucher(0, code, description, discountType, discount, maxDiscount, minOrder,
                        start, end, usageLimit, 0, active, accountID);

                voucherDAO.addVoucher(v);
                response.sendRedirect("manage-vouchers?success=add");
                return;

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                voucherDAO.deleteVoucher(id);
                response.sendRedirect("manage-vouchers?success=delete");
                return;

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("voucherID"));
                String code = request.getParameter("code");
                String description = request.getParameter("description");
                String discountType = request.getParameter("discountType"); 

                BigDecimal discount = parseBigDecimal(request.getParameter("discount"));
                BigDecimal maxDiscount = parseBigDecimal(request.getParameter("maxDiscount"));
                BigDecimal minOrder = parseBigDecimal(request.getParameter("minOrder"));

                LocalDateTime start = parseDate(request.getParameter("startDate"), LocalDateTime.now());
                LocalDateTime end = parseDate(request.getParameter("endDate"), LocalDateTime.now().plusDays(7));

                int usageLimit = parseInt(request.getParameter("usageLimit"), 1);
                boolean active = "1".equals(request.getParameter("active"));
                int usedCount = voucherDAO.getUsedCountByVoucherId(id);

                HttpSession session = request.getSession();
                Integer accountID = (Integer) session.getAttribute("userId");
                if (accountID == null) accountID = 1;

                Voucher updatedVoucher = new Voucher(id, code, description, discountType, discount, maxDiscount, minOrder,
                        start, end, usageLimit, usedCount, active, accountID);

                voucherDAO.updateVoucher(updatedVoucher);
                response.sendRedirect("manage-vouchers?success=edit");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-vouchers?success=false");
        }
    }

    private BigDecimal parseBigDecimal(String str) {
        return (str != null && !str.isEmpty()) ? new BigDecimal(str) : BigDecimal.ZERO;
    }

    private int parseInt(String str, int defaultValue) {
        try {
            return (str != null && !str.isEmpty()) ? Integer.parseInt(str) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private LocalDateTime parseDate(String str, LocalDateTime defaultDate) {
        try {
            return (str != null && !str.isEmpty()) ? LocalDate.parse(str).atStartOfDay() : defaultDate;
        } catch (Exception e) {
            return defaultDate;
        }
    }
}
