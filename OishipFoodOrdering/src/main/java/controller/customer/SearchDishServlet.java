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


@WebServlet(name = "SearchDishServlet", urlPatterns = {"/customer/search-dish"})
public class SearchDishServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String searchQuery = (String) session.getAttribute("searchQuery"); 

        List<Dish> menuItemList = (List<Dish>) session.getAttribute("menuItems");

        if (menuItemList == null) {
            request.setAttribute("message", "No results found.");
        }
        request.setAttribute("menuItems", menuItemList);
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

            HttpSession session = request.getSession();
            session.setAttribute("searchQuery", searchQuery);
            session.setAttribute("menuItems", menuItemResults);

            request.setAttribute("menuItems", menuItemResults);
            request.setAttribute("searchQuery", searchQuery);

            if (!menuItemResults.isEmpty()) {
                int activeCategoryId = menuItemResults.get(0).getCategoryId();  
                request.setAttribute("activeCategoryId", activeCategoryId);
            }

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
