package controller.customer;

import dao.CategoryDAO;
import dao.DishDAO;
import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import model.Category;
import model.Dish;
import model.Review;

@WebServlet(name = "DishServlet", urlPatterns = {"/home/dish"})
public class DishServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DishDAO dishDAO = new DishDAO();
        ReviewDAO reviewDAO = new ReviewDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Always fetch the category list to display in the menu
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);

        // Logic: if dishId exists => view dish detail
        String dishIdParam = request.getParameter("dishId");
        if (dishIdParam != null) {
            try {
                int dishId = Integer.parseInt(dishIdParam);
                Dish dish = dishDAO.getDishDetailById(dishId);
                List<Review> reviews = reviewDAO.getTop5ReviewsByDishId(dishId);
                if (dish != null) {
                    request.setAttribute("dish", dish);
                    request.setAttribute("reviews", reviews);

                    // Identify customer vs. guest
                    HttpSession session = request.getSession(false);
                    boolean isLoggedIn = false;
                    String userName = "Guest";

                    if (session != null && session.getAttribute("userId") != null
                            && "customer".equals(session.getAttribute("role"))) {
                        isLoggedIn = true;
                        Object name = session.getAttribute("userName"); // or fetch from DB if not set
                        if (name != null) {
                            userName = name.toString();
                        }
                    }

                    request.setAttribute("isLoggedIn", isLoggedIn);
                    request.setAttribute("userName", userName);

                    request.getRequestDispatcher("/WEB-INF/views/customer/dish_detail.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Dish does not exist.");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }

            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid dish ID.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
        }

        // If catId exists => filter dishes by category
        String catIdParam = request.getParameter("catId");
        request.setAttribute("selectedCatId", catIdParam);
        List<Dish> menuItems;
        if (catIdParam != null) {
            try {
                int catId = Integer.parseInt(catIdParam);
                menuItems = dishDAO.getDishesByCategory(catId);
            } catch (NumberFormatException e) {
                menuItems = dishDAO.getAllDishes(); // Fallback to all if invalid catId
            }
        } else {
            menuItems = dishDAO.getAllDishes();
        }

        request.setAttribute("menuItems", menuItems);

        // Check login state and user name
        HttpSession session = request.getSession(false);
        boolean isLoggedIn = false;
        String userName = "Guest";

        if (session != null && session.getAttribute("userId") != null
                && "customer".equals(session.getAttribute("role"))) {
            isLoggedIn = true;
            Object name = session.getAttribute("userName");
            if (name != null) {
                userName = name.toString();
            }
        }

        request.setAttribute("isLoggedIn", isLoggedIn);
        request.setAttribute("userName", userName);

        // Forward to dish category view
        request.getRequestDispatcher("/WEB-INF/views/customer/dish_category.jsp").forward(request, response);
    }
}
