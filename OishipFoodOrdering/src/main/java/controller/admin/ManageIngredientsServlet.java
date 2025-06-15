package controller.admin;

import dao.IngredientDAO;
import model.Ingredient;
import model.DishIngredient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;
import model.Dish;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/admin/manage-ingredients")
public class ManageIngredientsServlet extends HttpServlet {

    private IngredientDAO ingredientDAO;

    @Override
    public void init() throws ServletException {
        ingredientDAO = new IngredientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("getIngredientDetails".equals(action)) {
            handleGetIngredientDetails(request, response);
        } else if ("getIngredientNames".equals(action)) {
            handleGetIngredientNames(request, response);
        } else if ("getDishNames".equals(action)) {
            handleGetDishNames(request, response);
        } else {
            List<Ingredient> ingredients = ingredientDAO.getAllIngredients();
            request.setAttribute("ingredients", ingredients);
            request.setAttribute("dishes", ingredientDAO.getAllDishes());
            request.getRequestDispatcher("/WEB-INF/views/admin/manage_ingredients.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String methodOverride = request.getParameter("_method");
        HttpSession session = request.getSession();

        if ("DELETE".equals(methodOverride)) {
            handleDelete(request, response, session);
        } else if ("add".equals(action)) {
            handleAdd(request, response, session);
        } else if ("update".equals(action)) {
            handleUpdate(request, response, session);
        } else {
            session.setAttribute("errorMessage", "Invalid action.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-ingredients");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        try {
            String ingredientName = request.getParameter("ingredientName").trim();
            String unitCostStr = request.getParameter("unitCost").trim();
            String dishName = request.getParameter("dishName").trim();
            String quantityStr = request.getParameter("quantity").trim();

            if (ingredientName.isEmpty()) {
                throw new IllegalArgumentException("Ingredient name is required.");
            }
            if (unitCostStr.isEmpty()) {
                throw new IllegalArgumentException("Unit cost is required.");
            }

            BigDecimal unitCost = new BigDecimal(unitCostStr);
            if (unitCost.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Unit cost must be positive.");
            }

            Integer dishId = null;
            if (!dishName.isEmpty()) {
                List<Dish> dishes = ingredientDAO.getAllDishes();
                Dish existingDish = dishes.stream().filter(d -> d.getDishName().equals(dishName)).findFirst().orElse(null);
                if (existingDish == null) {
                    dishId = ingredientDAO.addDish(dishName);
                    if (dishId == -1) {
                        throw new IllegalArgumentException("Failed to create new dish.");
                    }
                } else {
                    dishId = existingDish.getDishID();
                }
            }
            Double quantity = (quantityStr.isEmpty()) ? null : Double.parseDouble(quantityStr);
            if (dishId != null && quantity == null) {
                throw new IllegalArgumentException("Quantity is required when a dish is selected.");
            }
            if (quantity != null && quantity <= 0) {
                throw new IllegalArgumentException("Quantity must be positive.");
            }

            Ingredient ingredient = new Ingredient();
            ingredient.setIngredientName(ingredientName);
            ingredient.setUnitCost(unitCost);

            ingredientDAO.addIngredient(ingredient, dishId, quantity);
            session.setAttribute("successMessage", "Ingredient added successfully.");
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid numeric input: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error adding ingredient: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-ingredients");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        try {
            String ingredientIdStr = request.getParameter("ingredientId").trim();
            String ingredientName = request.getParameter("ingredientName").trim();
            String unitCostStr = request.getParameter("unitCost").trim();
            String dishName = request.getParameter("dishName").trim();
            String quantityStr = request.getParameter("quantity").trim();

            if (ingredientIdStr.isEmpty()) {
                throw new IllegalArgumentException("Ingredient ID is required.");
            }
            if (ingredientName.isEmpty()) {
                throw new IllegalArgumentException("Ingredient name is required.");
            }
            if (unitCostStr.isEmpty()) {
                throw new IllegalArgumentException("Unit cost is required.");
            }

            int ingredientId = Integer.parseInt(ingredientIdStr);
            BigDecimal unitCost = new BigDecimal(unitCostStr);
            if (unitCost.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Unit cost must be positive.");
            }

            Integer dishId = null;
            if (!dishName.isEmpty()) {
                List<Dish> dishes = ingredientDAO.getAllDishes();
                Dish existingDish = dishes.stream().filter(d -> d.getDishName().equals(dishName)).findFirst().orElse(null);
                if (existingDish != null) {
                    dishId = existingDish.getDishID();
                }
            }
            Double quantity = (quantityStr.isEmpty()) ? null : Double.parseDouble(quantityStr);
            if (dishId != null && quantity == null) {
                throw new IllegalArgumentException("Quantity is required when a dish is selected.");
            }
            if (quantity != null && quantity <= 0) {
                throw new IllegalArgumentException("Quantity must be positive.");
            }

            Ingredient ingredient = new Ingredient();
            ingredient.setIngredientId(ingredientId);
            ingredient.setIngredientName(ingredientName);
            ingredient.setUnitCost(unitCost);

            ingredientDAO.updateIngredient(ingredient, dishId, quantity);
            session.setAttribute("successMessage", "Ingredient updated successfully.");
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid numeric input: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error updating ingredient: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-ingredients");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        try {
            String ingredientIdStr = request.getParameter("id").trim();
            String dishIdStr = request.getParameter("dishId").trim();

            if (ingredientIdStr.isEmpty()) {
                throw new IllegalArgumentException("Ingredient ID is required.");
            }

            int ingredientId = Integer.parseInt(ingredientIdStr);
            boolean success;

            if (dishIdStr != null && !dishIdStr.isEmpty() && !dishIdStr.equals("0")) {
                int dishId = Integer.parseInt(dishIdStr);
                success = ingredientDAO.deleteDishIngredient(dishId, ingredientId);
                if (success) {
                    session.setAttribute("successMessage", "Ingredient removed from dish successfully.");
                } else {
                    throw new IllegalArgumentException("Failed to remove ingredient from dish. Check database constraints.");
                }
            } else {
                success = ingredientDAO.deleteIngredient(ingredientId);
                if (success) {
                    session.setAttribute("successMessage", "Ingredient deleted successfully.");
                } else {
                    throw new IllegalArgumentException("Failed to delete ingredient. It may be in use or does not exist.");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid numeric input: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            session.setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error deleting ingredient: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-ingredients");
    }

    private void handleGetIngredientDetails(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();

        try {
            String ingredientIdStr = request.getParameter("ingredientId");
            String dishIdStr = request.getParameter("dishId");

            if (ingredientIdStr == null || ingredientIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Ingredient ID is required.");
            }

            int ingredientId = Integer.parseInt(ingredientIdStr);
            Integer dishId = (dishIdStr != null && !dishIdStr.trim().isEmpty() && !dishIdStr.equals("0")) ? Integer.parseInt(dishIdStr) : null;

            Ingredient ingredient = ingredientDAO.getAllIngredients().stream()
                    .filter(i -> i.getIngredientId() == ingredientId)
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException("Ingredient not found."));

            Double quantity = null;
            if (dishId != null) {
                DishIngredient di = ingredientDAO.getDishIngredient(dishId, ingredientId);
                quantity = (di != null) ? di.getQuantity() : null;
            }

            json.put("success", true);
            json.put("ingredientId", ingredient.getIngredientId());
            json.put("ingredientName", ingredient.getIngredientName());
            json.put("unitCost", ingredient.getUnitCost().toString());
            json.put("dishId", dishId != null ? dishId : "");
            json.put("quantity", quantity != null ? quantity : "");
        } catch (NumberFormatException e) {
            json.put("success", false);
            json.put("error", "Invalid numeric input: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            json.put("success", false);
            json.put("error", e.getMessage());
        } catch (Exception e) {
            json.put("success", false);
            json.put("error", "Error fetching ingredient details: " + e.getMessage());
            e.printStackTrace();
        }

        out.print(json.toString());
        out.flush();
    }

    private void handleGetIngredientNames(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();
        try {
            List<String> names = ingredientDAO.getIngredientNames();
            json.put("success", true);
            json.put("names", new JSONArray(names));
        } catch (Exception e) {
            json.put("success", false);
            json.put("error", "Error fetching ingredient names: " + e.getMessage());
            e.printStackTrace();
        }
        out.print(json.toString());
        out.flush();
    }

    private void handleGetDishNames(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();
        try {
            List<String> names = ingredientDAO.getDishNames();
            json.put("success", true);
            json.put("names", new JSONArray(names));
        } catch (Exception e) {
            json.put("success", false);
            json.put("error", "Error fetching dish names: " + e.getMessage());
            e.printStackTrace();
        }
        out.print(json.toString());
        out.flush();
    }
}
