package controller.staff;

import dao.StaffDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/staff/*")
public class StaffServlet extends HttpServlet {
    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null || !"staff".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String path = request.getPathInfo();
        if (path == null || path.equals("/dashboard")) {
            try {
                List<model.Order> orders = staffDAO.getPendingOrders();
                request.setAttribute("orders", orders);
                request.getRequestDispatcher("/WEB-INF/views/staff/staffDashboard.jsp").forward(request, response);
            } catch (SQLException e) {
                request.setAttribute("error", "Error fetching orders: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/staff/staffDashboard.jsp").forward(request, response);
            }
        } else if (path.equals("/updateOrderStatus")) {
            String orderIdStr = request.getParameter("orderId");
            String statusStr = request.getParameter("status");
            if (orderIdStr != null && statusStr != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr);
                    int status = Integer.parseInt(statusStr);
                    HttpSession sessionStaff = request.getSession();
                    int staffId = (int) sessionStaff.getAttribute("accountID"); // Lấy accountID của Staff
                    staffDAO.updateOrderStatus(orderId, status, staffId);
                    response.sendRedirect(request.getContextPath() + "/staff/dashboard");
                } catch (NumberFormatException | SQLException e) {
                    response.sendRedirect(request.getContextPath() + "/staff/dashboard?error=Invalid input");
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}