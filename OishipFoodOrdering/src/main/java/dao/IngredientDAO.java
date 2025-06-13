package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Ingredient;
import utils.DBContext;


public class IngredientDAO extends DBContext{
  
public List<Ingredient> getIngredientsByDishId(int dishId) {
    List<Ingredient> ingredients = new ArrayList<>();
    String sql = "SELECT i.ingredientID, i.name, di.quantity AS usedQuantity, i.unitCost " +
                 "FROM DishIngredient di " +
                 "JOIN Ingredient i ON di.ingredientID = i.ingredientID " +
                 "WHERE di.dishID = ?";

    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, dishId);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Ingredient ing = new Ingredient();
                ing.setIngredientID(rs.getInt("ingredientID"));
                ing.setName(rs.getString("name"));
                ing.setQuantity(rs.getInt("usedQuantity")); // Số lượng dùng trong món
                ing.setUnitCost(rs.getBigDecimal("unitCost"));
                ingredients.add(ing);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return ingredients;
}

}
