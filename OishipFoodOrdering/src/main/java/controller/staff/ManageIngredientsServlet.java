package controller.staff;

import dao.DishDAO;
import dao.DishIngredientDAO;
import dao.IngredientDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Dish;
import model.DishIngredient;
import model.Ingredient;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/staff/manage-ingredients")
public class ManageIngredientsServlet extends HttpServlet {

    private final IngredientDAO ingredientDAO = new IngredientDAO();
    private final DishDAO dishDAO = new DishDAO();
    private final DishIngredientDAO dishIngredientDAO = new DishIngredientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                boolean deleted = handleDeleteIngredient(request);
                response.sendRedirect("manage-ingredients?success=" + (deleted ? "delete" : "false"));
                return;
            } else if ("deleteDishIngredient".equals(action)) {
                handleDeleteDishIngredient(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-ingredients?success=false");
            return;
        }

        List<Ingredient> ingredients = ingredientDAO.getAllIngredients();
        List<Dish> dishes = dishDAO.getAllDishes();
        List<DishIngredient> allDishIngredients = dishIngredientDAO.getAllDishIngredients();

        request.setAttribute("ingredients", ingredients);
        request.setAttribute("dishes", dishes);
        request.setAttribute("allDishIngredients", allDishIngredients);

        request.getRequestDispatcher("/WEB-INF/views/staff/manage_ingredients.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("manage-ingredients?success=false");
            return;
        }

        try {
            switch (action) {
                case "add":
                    boolean added = handleAdd(request);
                    response.sendRedirect("manage-ingredients?success=" + (added ? "add" : "exists"));
                    return;
                case "update":
                    boolean updated = handleUpdateIngredient(request);
                    response.sendRedirect("manage-ingredients?success=" + (updated ? "edit" : "false"));
                    return;
                case "updateDishIngredient":
                    handleUpdateDishIngredient(request, response);
                    return;
                default:
                    response.sendRedirect("manage-ingredients?success=false");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-ingredients?success=false");
        }
    }

    private boolean handleAdd(HttpServletRequest request) {
        try {
            int dishID = Integer.parseInt(request.getParameter("dishID"));
            String ingredientIdParam = request.getParameter("ingredientId");
            BigDecimal quantity = new BigDecimal(request.getParameter("quantity"));
            int ingredientID;

            if (ingredientIdParam == null || ingredientIdParam.isEmpty()) {
                String newName = request.getParameter("newName");
                BigDecimal newCost = new BigDecimal(request.getParameter("newCost"));

                // Check if ingredient name already exists
                List<Ingredient> existingIngredients = ingredientDAO.getAllIngredients();
                boolean nameExists = existingIngredients.stream()
                        .anyMatch(i -> i.getIngredientName().equalsIgnoreCase(newName.trim()));

                if (nameExists) {
                    // Redirect with error param
                    return false; // Trigger ?success=exists in redirect
                }

                Ingredient newIngredient = new Ingredient();
                newIngredient.setIngredientName(newName);
                newIngredient.setUnitCost(newCost);
                newIngredient.setAccountID(1); // Placeholder

                ingredientID = ingredientDAO.addIngredient(newIngredient);
            } else {
                ingredientID = Integer.parseInt(ingredientIdParam);
            }

            dishIngredientDAO.addIngredientToDish(dishID, ingredientID, quantity);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean handleUpdateIngredient(HttpServletRequest request) {
        try {
            int id = Integer.parseInt(request.getParameter("ingredientId"));
            String name = request.getParameter("ingredientName");
            BigDecimal cost = new BigDecimal(request.getParameter("unitCost"));

            Ingredient ing = new Ingredient();
            ing.setIngredientId(id);
            ing.setIngredientName(name);
            ing.setUnitCost(cost);

            return ingredientDAO.updateIngredient(ing);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void handleUpdateDishIngredient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int dishID = Integer.parseInt(request.getParameter("dishID"));
            int ingredientID = Integer.parseInt(request.getParameter("ingredientID"));
            BigDecimal quantity = new BigDecimal(request.getParameter("quantity"));

            dishIngredientDAO.updateDishIngredientQuantity(dishID, ingredientID, quantity);

            response.sendRedirect("manage-ingredients?tab=byDish&dishID=" + dishID + "&success=dishEdit");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-ingredients?tab=byDish&success=false");
        }
    }

    private boolean handleDeleteIngredient(HttpServletRequest request) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            return ingredientDAO.deleteIngredientById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void handleDeleteDishIngredient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int dishID = Integer.parseInt(request.getParameter("dishID"));
            int ingredientID = Integer.parseInt(request.getParameter("ingredientID"));

            dishIngredientDAO.deleteIngredientFromDish(dishID, ingredientID);

            response.sendRedirect("manage-ingredients?tab=byDish&dishID=" + dishID + "&success=dishDelete");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage-ingredients?tab=byDish&success=false");
        }
    }
}
