package controller.user;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PendingAccountsServlet", urlPatterns = {"/pending-accounts"})
public class PendingAccountsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = session != null ? (String) session.getAttribute("role") : null;

        if (role == null || !role.equalsIgnoreCase("admin")) {
            response.sendRedirect("login");
            return;
        }

        AccountDAO dao = new AccountDAO();

        List<Account> pendingShippers = dao.getAccountsByRoleAndStatus("Shipper", "pending_approval");
        List<Account> pendingRestaurants = dao.getAccountsByRoleAndStatus("RestaurantManager", "pending_approval");

        request.setAttribute("shippers", pendingShippers);
        request.setAttribute("restaurants", pendingRestaurants);

        request.getRequestDispatcher("/WEB-INF/views/pendingAccounts/admin_pending.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type"); // shipper or restaurant
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");

        if (type == null || idStr == null || status == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            AccountDAO dao = new AccountDAO();
            dao.updateStatus(id, status);
            response.sendRedirect("pending-accounts");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles pending account approvals for admin";
    }
}
