package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import dao.OrderDAO;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        // Set attributes for JSP
        request.setAttribute("availableYears", availableYears);
        request.setAttribute("selectedYear", selectedYear);
        request.setAttribute("monthlyIncomeMap", monthlyIncomeMap);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard_admin.jsp").forward(request, response);
    }
}