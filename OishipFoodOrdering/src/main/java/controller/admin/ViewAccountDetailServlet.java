package controller.admin;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;

import java.io.IOException;

@WebServlet(name = "ViewAccountDetailServlet", urlPatterns = {"/view-account-detail"})
public class ViewAccountDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String idParam = request.getParameter("id");

        if (role == null || idParam == null) {
            response.sendRedirect("admin");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("admin");
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getAccountById(id);

        if (account != null && account.getRole().equalsIgnoreCase(role)) {
            request.setAttribute("userDetail", account);
            request.setAttribute("role", role);
            request.getRequestDispatcher("/WEB-INF/views/admin/user-detail.jsp").forward(request, response);
        } else {
            response.sendRedirect("admin");
        }
    }
}
