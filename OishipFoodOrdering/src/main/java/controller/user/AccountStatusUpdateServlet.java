package controller.user;

import dao.CustomerDAO;
import dao.RestaurantManagerDAO;
import dao.ShipperDAO;
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
        int id = Integer.parseInt(request.getParameter("id"));
        int statusId = Integer.parseInt(request.getParameter("statusId"));

        boolean success = false;

        switch (role) {
            case "customer":
                CustomerDAO customerDAO = new CustomerDAO();
                success = customerDAO.updateStatus(id, statusId);
                break;
            case "shipper":
                ShipperDAO shipperDAO = new ShipperDAO();
                success = shipperDAO.updateStatus(id, statusId);
                break;
            case "restaurant":
                RestaurantManagerDAO restaurantDAO = new RestaurantManagerDAO();
                success = restaurantDAO.updateStatus(id, statusId);
                break;
        }

        if (success) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
