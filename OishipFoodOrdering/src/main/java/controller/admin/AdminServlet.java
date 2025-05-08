package controller.admin;

import dao.CustomerDAO;
import dao.RestaurantManagerDAO;
import dao.ShipperDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Customer;
import model.RestaurantManager;
import model.Shipper;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        // Load data cho dashboard
        CustomerDAO customerDAO = new CustomerDAO();
        ShipperDAO shipperDAO = new ShipperDAO();
        RestaurantManagerDAO restaurantDAO = new RestaurantManagerDAO();

        List<Customer> customers = customerDAO.getAllCustomers();
        List<Shipper> shippers = shipperDAO.getAllShippers();
        List<RestaurantManager> restaurants = restaurantDAO.getAllRestaurants();

        request.setAttribute("customers", customers);
        request.setAttribute("shippers", shippers);
        request.setAttribute("restaurants", restaurants);

        request.getRequestDispatcher("/WEB-INF/views/admin/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Dashboard Servlet - Load all user roles for management";
    }
}
