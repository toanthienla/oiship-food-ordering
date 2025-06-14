package controller.admin;

import dao.IngredientDAO;
import model.Ingredient;
import model.Dish;
import model.DishIngredient;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet to manage ingredients, handling GET, POST, and DELETE requests.
 */
@WebServlet("/admin/manage-ingredients")
public class ManageIngredientsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final IngredientDAO ingredientDAO = new IngredientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Ingredient> ingredients = ingredientDAO.getAllIngredients();
            List<Dish> dishes = ingredientDAO.getAllDishes();
            request.setAttribute("ingredients", ingredients);
            request.setAttribute("dishes", dishes);
            request.setAttribute("dishName", request.getParameter("dishName"));
            request.setAttribute("ingredientName", request.getParameter("ingredientName"));
            request.setAttribute("unitCost", request.getParameter("unitCost"));
            request.setAttribute("quantity", request.getParameter("quantity"));
            request.getRequestDispatcher("/WEB-INF/views/admin/manage_ingredients.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/manage_ingredients.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                String dishIdStr = request.getParameter("dishName");
                String ingredientName = request.getParameter("ingredientName");
                String unitCostStr = request.getParameter("unitCost");
                String quantityStr = request.getParameter("quantity");

                if (unitCostStr == null || unitCostStr.trim().isEmpty() || quantityStr == null || quantityStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Unit cost and quantity are required.");
                }
                if (ingredientName == null || ingredientName.trim().isEmpty()) {
                    throw new IllegalArgumentException("Ingredient name is required.");
                }

                double unitCost = Double.parseDouble(unitCostStr);
                double quantity = Double.parseDouble(quantityStr);

                int dishId = (dishIdStr != null && !dishIdStr.trim().isEmpty() && dishIdStr.matches("\\d+")) ? Integer.parseInt(dishIdStr) : 0;

                Ingredient ingredient = new Ingredient(0, ingredientName.trim(), unitCost, 1); // fkAccount = 1
                ingredientDAO.addIngredient(ingredient);
                int ingredientId = ingredient.getIngredientId();

                if (dishId > 0) {
                    ingredientDAO.addDishIngredient(dishId, ingredientId, quantity);
                }

                request.setAttribute("message", "Ingredient added successfully!");
                doGet(request, response);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("ingredientId"));
                String name = request.getParameter("ingredientName");
                double unitCost = Double.parseDouble(request.getParameter("unitCost"));
                double quantity = Double.parseDouble(request.getParameter("quantity"));
                int dishId = request.getParameter("dishId") != null && request.getParameter("dishId").matches("\\d+") ?
                        Integer.parseInt(request.getParameter("dishId")) : 0;

                Ingredient ingredient = new Ingredient(id, name, unitCost, 1);
                ingredientDAO.updateIngredient(ingredient);

                if (dishId > 0) {
                    DishIngredient existingDi = ingredientDAO.getDishIngredient(dishId, id);
                    if (existingDi != null) {
                        existingDi.setQuantity(quantity);
                        ingredientDAO.updateDishIngredient(existingDi);
                    } else {
                        ingredientDAO.addDishIngredient(dishId, id, quantity);
                    }
                }

                request.setAttribute("message", "Ingredient updated successfully!");
                doGet(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid numeric input: " + e.getMessage());
            doGet(request, response);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            doGet(request, response);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam != null && idParam.matches("\\d+")) {
                int id = Integer.parseInt(idParam);
                ingredientDAO.deleteDishIngredientsByIngredientId(id);
                boolean deleted = ingredientDAO.deleteIngredient(id);
                if (deleted) {
                    response.getWriter().write("{\"success\": true, \"message\": \"Ingredient deleted successfully!\"}");
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.getWriter().write("{\"success\": false, \"error\": \"Failed to delete ingredient.\"}");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
            } else {
                response.getWriter().write("{\"success\": false, \"error\": \"Invalid ingredient ID\"}");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"error\": \"An unexpected error occurred: " + e.getMessage() + "\"}");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}