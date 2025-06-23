package controller.customer;

import dao.DishDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Dish;

/**
 * Servlet responsible for searching dishes by name. Author: Phi Yen
 */
@WebServlet(name = "SearchDishServlet", urlPatterns = {"/customer/search-dish"})
public class SearchDishServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the search query and results from session
        HttpSession session = request.getSession(false);
        String searchQuery = (String) session.getAttribute("searchQuery");  // Retrieve searchQuery from session

        List<Dish> menuItemList = (List<Dish>) session.getAttribute("menuItems");

        if (menuItemList == null) {
            request.setAttribute("message", "No results found.");
        }

        // Pass results to the request
        request.setAttribute("menuItems", menuItemList);
        // Pass the search query back to display in the input
        request.setAttribute("searchQuery", searchQuery);

        request.getRequestDispatcher("/WEB-INF/views/customer/search_dish.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchQuery = request.getParameter("searchQuery");
        List<Dish> menuItemResults = new ArrayList<>();

        try {
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                DishDAO menuItemDAO = new DishDAO();
                menuItemResults = menuItemDAO.searchDishByName(searchQuery);
            }

            // Save the search query to session for use on return
            HttpSession session = request.getSession();
            session.setAttribute("searchQuery", searchQuery);
            session.setAttribute("menuItems", menuItemResults);

            // Gửi danh sách món ăn về request
            request.setAttribute("menuItems", menuItemResults);
            request.setAttribute("searchQuery", searchQuery);

            // ✨ NEW: Gửi category ID active nếu có món ăn
            if (!menuItemResults.isEmpty()) {
                int activeCategoryId = menuItemResults.get(0).getCategoryId();  // <-- Dish cần có getCategoryID()
                request.setAttribute("activeCategoryId", activeCategoryId);
            }

            // Forward
            request.getRequestDispatcher("/WEB-INF/views/customer/search_dish.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error while searching for restaurants and dishes.");
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles dish search functionality for customers.";
    }
}
