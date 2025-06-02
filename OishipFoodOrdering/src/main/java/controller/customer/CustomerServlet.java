package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import dao.AccountDAO;

import java.io.IOException;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer"})
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"customer".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        AccountDAO dao = new AccountDAO();

        Account account = dao.getAccountById(userId);
        if (account != null) {
            request.setAttribute("account", account);
            request.setAttribute("userName", account.getFullName()); // Updated to getFullName
        } else {
            request.setAttribute("error", "Account not found.");
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/customer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}