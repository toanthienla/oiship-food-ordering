package controller.staff;

import dao.CategoryDAO;
import dao.DishDAO;
import model.Category;
import model.Dish;

import java.util.List;
import jakarta.servlet.annotation.WebServlet;
import utils.CloudinaryConfig;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.Comparator;

@WebServlet(urlPatterns = {"/staff/manage-dishes"})
@MultipartConfig
public class ManageDishesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        DishDAO dishDAO = new DishDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        if (action != null && idParam != null) {
            int dishID = Integer.parseInt(idParam);

            if ("delete".equals(action)) {
                boolean deleted = dishDAO.deleteDishById(dishID);
                response.sendRedirect("manage-dishes?success=" + (deleted ? "delete" : "false"));
                return;
            }
        }

        List<Dish> dishes = dishDAO.getAllDishes();
        dishes.sort(Comparator.comparing(d -> d.getCategory().getCatName())); // Sort dishes by category name

        List<Category> categories = categoryDAO.getAllCategories();
        categories.sort(Comparator.comparing(Category::getCatName)); // Sort categories alphabetically by name
        System.out.println("Dishes 1: " + dishes.get(0).toString());
        request.setAttribute("dishes", dishes);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/staff/manage_dishes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // === Extract form data ===
        String dishIDStr = request.getParameter("dishID");
        String name = request.getParameter("dishName");
        String description = request.getParameter("dishDescription");
        String opCostStr = request.getParameter("opCost");
        String interestStr = request.getParameter("interestPercentage");
        String stockStr = request.getParameter("stock");
        String isAvailableStr = request.getParameter("isAvailable");
        String categoryIDStr = request.getParameter("categoryID");

        // === Validate and parse numeric values ===
        BigDecimal opCost = BigDecimal.ZERO;
        BigDecimal interest = BigDecimal.ZERO;
        int stock = 0;
        int categoryID = 0;
        boolean isAvailable = "1".equals(isAvailableStr);

        try {
            opCost = new BigDecimal(opCostStr);
            interest = new BigDecimal(interestStr);
            stock = Integer.parseInt(stockStr);
            categoryID = Integer.parseInt(categoryIDStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("manage-dishes?success=false&error=invalid-input");
            return;
        }

        // === Handle file upload ===
        Part imagePart = request.getPart("image");
        String imageUrl = null;

        if (imagePart != null && imagePart.getSize() > 0) {
            try (InputStream inputStream = imagePart.getInputStream()) {
                String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                imageUrl = CloudinaryConfig.uploadImage(inputStream, fileName);
                System.out.println("ImageUrl: " + imageUrl);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // === Save dish data ===
        DishDAO dishDAO = new DishDAO();
        boolean isSuccess;

        if (dishIDStr != null && !dishIDStr.isEmpty()) {
            try {
                int dishID = Integer.parseInt(dishIDStr);
                Dish existingDish = dishDAO.getDishById(dishID);
                if (existingDish == null) {
                    response.sendRedirect("manage-dishes?success=false&error=dish-not-found");
                    return;
                }

                if (imageUrl == null) {
                    imageUrl = existingDish.getImage(); // retain old image
                }

                Dish updatedDish = new Dish(dishID, name, opCost, interest, imageUrl, description, stock, isAvailable, categoryID);
                boolean updated = dishDAO.updateDish(updatedDish);
                response.sendRedirect("manage-dishes?success=" + (updated ? "edit" : "false"));
                return;

            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("manage-dishes?success=false&error=invalid-dish-id");
                return;
            }
        } else {
            Dish newDish = new Dish(name, opCost, interest, imageUrl, description, stock, isAvailable, categoryID);
            boolean added = dishDAO.addDish(newDish);
            response.sendRedirect("manage-dishes?success=" + (added ? "add" : "false"));
            return;
        }
    }
}
