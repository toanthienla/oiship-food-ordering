package controller.customer;

import dao.AccountDAO;
import dao.CategoryDAO;
import dao.DishDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.Category;
import model.Dish;

import java.io.IOException;
import java.util.List;

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
        request.setAttribute("categories", categories);

        // Get all dishes
        List<Dish> menuItems = null;
        try {
            menuItems = new DishDAO().getAllDishes();
            request.setAttribute("menuItems", menuItems);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load menu items.");
        }

       // int userId = (int) session.getAttribute("userId");
        AccountDAO dao = new AccountDAO();


        // Get customer information using email stored in session
        int userId = (int) session.getAttribute("userId");
        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.findByEmail((String) session.getAttribute("email"));
        if (account != null) {
            request.setAttribute("account", account);
            request.setAttribute("userName", account.getFullName());
        } else {
            request.setAttribute("error", "Account not found.");
        }

        // Refresh remember_me cookie if present
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("email".equals(cookie.getName())) {
                    Cookie emailCookie = new Cookie("email", cookie.getValue());
                    emailCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                    emailCookie.setPath(request.getContextPath());
                    response.addCookie(emailCookie);
                    break;
                }
            }
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
