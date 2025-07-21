package controller.staff;

import dao.OrderDAO;
import dao.ReviewDAO;
import dao.StaffDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DashboardStats;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/staff/*")
public class StaffServlet extends HttpServlet {

    private StaffDAO staffDAO;
    private OrderDAO orderDAO;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
        orderDAO = new OrderDAO();
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null
                || !"staff".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        // Get dashboard stats
        try {
            // Today stats
            DashboardStats todayStats = orderDAO.getTodayStats();
            reviewDAO.addReviewStatsToday(todayStats);

            // Month stats
            DashboardStats monthStats = orderDAO.getMonthStats();
            reviewDAO.addReviewStatsMonth(monthStats);

            // All stats
            DashboardStats allStats = orderDAO.getAllStats();
            reviewDAO.addReviewStatsAll(allStats);

            // Set attributes
            request.setAttribute("todayStats", todayStats);
            request.setAttribute("monthStats", monthStats);
            request.setAttribute("allStats", allStats);

        } catch (Exception e) {
            e.printStackTrace();
            // Set default empty stats if error occurs
            request.setAttribute("todayStats", new DashboardStats());
            request.setAttribute("monthStats", new DashboardStats());
            request.setAttribute("allStats", new DashboardStats());
        }

        request.getRequestDispatcher("/WEB-INF/views/staff/staff_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
