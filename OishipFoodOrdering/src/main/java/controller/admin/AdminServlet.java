package controller.admin;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        AccountDAO accountDAO = new AccountDAO();

        List<Account> customers = accountDAO.getAccountsByRole("Customer");
        List<Account> shippers = accountDAO.getAccountsByRole("Shipper");
        List<Account> restaurants = accountDAO.getAccountsByRole("RestaurantManager");

        request.setAttribute("customers", customers);
        request.setAttribute("shippers", shippers);
        request.setAttribute("restaurants", restaurants);

        request.getRequestDispatcher("/WEB-INF/views/admin/admin.jsp").forward(request, response);
    }
}
