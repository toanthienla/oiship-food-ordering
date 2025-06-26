package controller.admin;

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

@WebServlet("/admin/manage-ingredients")
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
                handleDeleteIngredient(request);
                response.sendRedirect("manage-ingredients");
                return;
            } else if ("deleteDishIngredient".equals(action)) {
                handleDeleteDishIngredient(request, response);
                return; // ✅ Don't redirect again
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<Ingredient> ingredients = ingredientDAO.getAllIngredients();
        List<Dish> dishes = dishDAO.getAllDishes();
        List<DishIngredient> allDishIngredients = dishIngredientDAO.getAllDishIngredients();

        request.setAttribute("ingredients", ingredients);
        request.setAttribute("dishes", dishes);
        request.setAttribute("allDishIngredients", allDishIngredients);

        request.getRequestDispatcher("/WEB-INF/views/admin/manage_ingredients.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    handleAdd(request);
                    break;
                case "update":
                    handleUpdateIngredient(request);
                    break;
                case "updateDishIngredient":
                    handleUpdateDishIngredient(request, response);
                    return;
                default:
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("manage-ingredients");
    }

    private void handleAdd(HttpServletRequest request) {
        try {
            int dishID = Integer.parseInt(request.getParameter("dishID"));
            String ingredientIdParam = request.getParameter("ingredientId");
            BigDecimal quantity = new BigDecimal(request.getParameter("quantity"));
            int ingredientID;

            if (ingredientIdParam == null || ingredientIdParam.isEmpty()) {
                String newName = request.getParameter("newName");
                BigDecimal newCost = new BigDecimal(request.getParameter("newCost"));
                Ingredient newIngredient = new Ingredient();
                newIngredient.setIngredientName(newName);
                newIngredient.setUnitCost(newCost);
                newIngredient.setAccountID(1);
                ingredientID = ingredientDAO.addIngredient(newIngredient);
            } else {
                ingredientID = Integer.parseInt(ingredientIdParam);
            }

            dishIngredientDAO.addIngredientToDish(dishID, ingredientID, quantity);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void handleUpdateIngredient(HttpServletRequest request) {
        try {
            int id = Integer.parseInt(request.getParameter("ingredientId"));
            String name = request.getParameter("ingredientName");
            BigDecimal cost = new BigDecimal(request.getParameter("unitCost"));

            Ingredient ing = new Ingredient();
            ing.setIngredientId(id);
            ing.setIngredientName(name);
            ing.setUnitCost(cost);

            ingredientDAO.updateIngredient(ing);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void handleUpdateDishIngredient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int dishID = Integer.parseInt(request.getParameter("dishID"));
            int ingredientID = Integer.parseInt(request.getParameter("ingredientID"));
            BigDecimal quantity = new BigDecimal(request.getParameter("quantity"));
            dishIngredientDAO.updateDishIngredientQuantity(dishID, ingredientID, quantity);

            response.sendRedirect("manage-ingredients?tab=byDish&dishID=" + dishID);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void handleDeleteIngredient(HttpServletRequest request) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ingredientDAO.deleteIngredientById(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void handleDeleteDishIngredient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int dishID = Integer.parseInt(request.getParameter("dishID"));
            int ingredientID = Integer.parseInt(request.getParameter("ingredientID"));
            dishIngredientDAO.deleteIngredientFromDish(dishID, ingredientID);

            response.sendRedirect("manage-ingredients?tab=byDish&dishID=" + dishID);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
