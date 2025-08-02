package controller.staff;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/staff/*")
public class StaffServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
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

        // Get income statistics data (same as admin dashboard)
        try {
            // Year selection from request
            String yearParam = request.getParameter("year");
            int selectedYear;
            List<Integer> availableYears = orderDAO.getAvailableOrderYears(); // get years with orders

            if (yearParam != null) {
                selectedYear = Integer.parseInt(yearParam);
            } else if (!availableYears.isEmpty()) {
                selectedYear = availableYears.get(availableYears.size() - 1); // latest year
            } else {
                selectedYear = java.time.Year.now().getValue();
            }

            // Monthly income as map: month (1-12) -> income
            Map<Integer, Double> monthlyIncomeMap = orderDAO.getMonthlyIncomeMap(selectedYear);

            // Set attributes for JSP (same as admin)
            request.setAttribute("availableYears", availableYears);
            request.setAttribute("selectedYear", selectedYear);
            request.setAttribute("monthlyIncomeMap", monthlyIncomeMap);

        } catch (Exception e) {
            e.printStackTrace();
            // Set default empty data if error occurs
            request.setAttribute("availableYears", List.of());
            request.setAttribute("selectedYear", java.time.Year.now().getValue());
            request.setAttribute("monthlyIncomeMap", Map.of());
        }

        request.getRequestDispatcher("/WEB-INF/views/staff/staff_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
