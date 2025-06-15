package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.DishIngredient;
import model.Ingredient;
import utils.DBContext;

public class IngredientDAO extends DBContext {

    public List<Ingredient> getIngredientsByDishId(int dishId) {
    List<Ingredient> ingredients = new ArrayList<>();
    String sql = "SELECT i.ingredientID, i.name, i.unitCost, di.dishID, di.quantity " +
                 "FROM DishIngredient di " +
                 "JOIN Ingredient i ON di.ingredientID = i.ingredientID " +
                 "WHERE di.dishID = ?";

    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, dishId);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Ingredient ing = new Ingredient();
                ing.setIngredientId(rs.getInt("ingredientID"));
                ing.setIngredientName(rs.getString("name"));
                ing.setUnitCost(rs.getBigDecimal("unitCost"));
                ing.setDishId(rs.getInt("dishID"));

                // Tạo DishIngredient và gán vào Ingredient
                DishIngredient di = new DishIngredient();
                di.setDishId(rs.getInt("dishID"));
                di.setIngredientId(rs.getInt("ingredientID"));
                di.setQuantity(rs.getDouble("quantity")); // double vì trong DB là DECIMAL

                List<DishIngredient> dishIngredients = new ArrayList<>();
                dishIngredients.add(di);
                ing.setDishIngredients(dishIngredients);

                ingredients.add(ing);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return ingredients;
}


}
