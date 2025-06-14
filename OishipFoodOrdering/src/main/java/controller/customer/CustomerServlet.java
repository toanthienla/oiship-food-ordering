package controller.customer;

import dao.AccountDAO;
import dao.CategoryDAO;
import dao.DishDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;

import java.io.IOException;
import java.util.List;
import model.Category;
import model.Dish;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer"})
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if the session exists and the user is logged in as a customer
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"customer".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get list of categories
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();

        // Store in request scope to send to JSP
        request.setAttribute("categories", categories);

        // Get all dishes to display on the home.jsp page
        List<Dish> menuItems = null;
        try {
            menuItems = new DishDAO().getAllDishes();
            request.setAttribute("menuItems", menuItems);
        } catch (Exception e) {
            e.printStackTrace();
        }

        int userId = (int) session.getAttribute("userId");
        AccountDAO dao = new AccountDAO();

        // Get customer information using email stored in session
        Customer customer = dao.getCustomerByEmail((String) session.getAttribute("email"));
        if (customer != null && "customer".equalsIgnoreCase(customer.getRole())) {
            request.setAttribute("account", customer);
            request.setAttribute("userName", customer.getFullName());
        } else {
            request.setAttribute("error", "Account not found or not a customer.");
        }

        // Forward to customer homepage view
        request.getRequestDispatcher("/WEB-INF/views/customer/customer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
