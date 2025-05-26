package controller.user;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "UpdateStatusServlet", urlPatterns = {"/update-status"})
public class AccountStatusUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");

        boolean success = false;

        if (role == null || idStr == null || status == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            AccountDAO dao = new AccountDAO();
            dao.updateStatus(id, status);
            success = true;
        } catch (Exception e) {
            e.printStackTrace();
            success = false;
        }

        if (success) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
