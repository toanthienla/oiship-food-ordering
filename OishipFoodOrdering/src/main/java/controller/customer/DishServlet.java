package controller.customer;

import dao.CategoryDAO;
import dao.DishDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import model.Category;
import model.Dish;

@WebServlet(name = "DishServlet", urlPatterns = {"/guest/dish"})
public class DishServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DishDAO dishDAO = new DishDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Luôn lấy danh sách category để hiển thị menu
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);

        // Xử lý: nếu có dishId => xem chi tiết món ăn
        String dishIdParam = request.getParameter("dishId");
        if (dishIdParam != null) {
            try {
                int dishId = Integer.parseInt(dishIdParam);
                Dish dish = dishDAO.getDishById(dishId);

                if (dish != null) {
                    request.setAttribute("dish", dish);
                    request.getRequestDispatcher("/WEB-INF/views/customer/dish_detail.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("errorMessage", "Món ăn không tồn tại.");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }

            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID món ăn không hợp lệ.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
        }

        // Nếu có catId => lọc danh sách món ăn theo category
        String catIdParam = request.getParameter("catId");
        List<Dish> menuItems;
        if (catIdParam != null) {
            try {
                int catId = Integer.parseInt(catIdParam);
                menuItems = dishDAO.getDishesByCategory(catId);
            } catch (NumberFormatException e) {
                menuItems = dishDAO.getAllDishes();
            }
        } else {
            menuItems = dishDAO.getAllDishes();
        }

        request.setAttribute("menuItems", menuItems);
        request.getRequestDispatcher("/WEB-INF/views/customer/dish_category.jsp").forward(request, response);
    }
}
