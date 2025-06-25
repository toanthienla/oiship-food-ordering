package controller.admin;

import dao.TotalChartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        System.out.println("DEBUG: AdminDashboardServlet - Session exists: " + (session != null)
                + ", adminId=" + (session != null ? session.getAttribute("adminId") : "null")
                + ", role=" + (session != null ? session.getAttribute("role") : "null"));

        // Kiểm tra phiên
        if (session == null || session.getAttribute("adminId") == null || !"admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
            System.out.println("AdminDashboardServlet: Unauthorized access, redirecting to admin login");
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Lấy dữ liệu thống kê từ DAO
        TotalChartDAO dao = new TotalChartDAO();
        List<model.ChartData> orderStats = dao.getOrderStats();
        List<model.ChartData> dishStats = dao.getDishStats();
        List<model.ChartData> paymentStats = dao.getPaymentStats();
        List<model.ChartData> totalStats = dao.getTotalStats();

        // Debug log
        System.out.println("OrderStats size: " + (orderStats != null ? orderStats.size() : 0));
        System.out.println("DishStats size: " + (dishStats != null ? dishStats.size() : 0));
        System.out.println("PaymentStats size: " + (paymentStats != null ? paymentStats.size() : 0));
        System.out.println("TotalStats size: " + (totalStats != null ? totalStats.size() : 0));
        for (model.ChartData data : orderStats) {
            System.out.println("OrderStats: month=" + data.getLabel() + ", count=" + data.getValue());
        }
        for (model.ChartData data : dishStats) {
            System.out.println("DishStats: month=" + data.getLabel() + ", count=" + data.getValue());
        }
        for (model.ChartData data : paymentStats) {
            System.out.println("PaymentStats: month=" + data.getLabel() + ", amount=" + data.getValue());
        }
        for (model.ChartData data : totalStats) {
            System.out.println("TotalStats: month=" + data.getLabel() + ", total=" + data.getValue());
        }

        // Truyền dữ liệu vào request
        request.setAttribute("orderStats", orderStats != null ? orderStats : new ArrayList<>());
        request.setAttribute("dishStats", dishStats != null ? dishStats : new ArrayList<>());
        request.setAttribute("paymentStats", paymentStats != null ? paymentStats : new ArrayList<>());
        request.setAttribute("totalStats", totalStats != null ? totalStats : new ArrayList<>());

        // Forward tới JSP
        System.out.println("AdminDashboardServlet: Rendering admin dashboard for adminId=" + session.getAttribute("adminId"));
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard_admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Xử lý POST giống GET (nếu cần, có thể mở rộng)
    }
}
