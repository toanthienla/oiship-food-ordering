package dao;

import java.math.BigDecimal;
import model.Dish;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Ingredient;
import utils.TotalPriceCalculator;

public class DishDAO extends DBContext {
public List<Dish> getAllDishes() {
    List<Dish> dishes = new ArrayList<>();
    String sql = "SELECT d.DishID, d.DishName, d.image, d.opCost, d.interestPercentage " +
                 "FROM Dish d " +
                 "ORDER BY d.DishID ASC";

    try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
        IngredientDAO ingredientDAO = new IngredientDAO();

        while (rs.next()) {
            Dish item = new Dish();
            int dishId = rs.getInt("DishID");
            item.setDishID(dishId);
            item.setDishName(rs.getString("DishName"));
            item.setImage(rs.getString("image"));

            BigDecimal opCost = rs.getBigDecimal("opCost");
            BigDecimal interest = rs.getBigDecimal("interestPercentage");

            // ✅ Lấy danh sách nguyên liệu & tính ingredientCost từ util
            List<Ingredient> ingredients = ingredientDAO.getIngredientsByDishId(dishId);
            BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(ingredients);

            // ✅ Tính totalPrice từ util
            BigDecimal totalPrice = TotalPriceCalculator.calculateTotalPrice(opCost, interest, ingredientCost);
            item.setTotalPrice(totalPrice);
            item.setFormattedPrice(TotalPriceCalculator.formatVND(totalPrice));

            dishes.add(item);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return dishes;
}

// view dish detail
    public Dish getDishDetailById(int dishId) {
        String sql = "SELECT d.DishID, d.DishName, d.image, d.dishDescription, d.stock, "
                + "CEILING((ISNULL(SUM(i.quantity * i.unitCost), 0) + d.opCost) * (1 + d.interestPercentage / 100) / 1000.0) * 1000 AS totalPrice, "
                + "STUFF((SELECT DISTINCT ', ' + i2.name "
                + "       FROM Ingredient i2 WHERE i2.FK_Ingredient_Dish = d.DishID FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS ingredientNames, "
                + "ROUND(AVG(CAST(r.rating AS FLOAT)), 2) AS avgRating "
                + "FROM Dish d "
                + "LEFT JOIN Ingredient i ON d.DishID = i.FK_Ingredient_Dish "
                + "LEFT JOIN OrderDetail od ON od.FK_OD_Dish = d.DishID "
                + "LEFT JOIN Review r ON r.FK_Review_OrderDetail = od.ODID "
                + "WHERE d.DishID = ? "
                + "GROUP BY d.DishID, d.DishName, d.image, d.dishDescription, d.stock, d.opCost, d.interestPercentage";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, dishId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Dish dish = new Dish();
                dish.setDishID(rs.getInt("DishID"));
                dish.setDishName(rs.getString("DishName"));
                dish.setImage(rs.getString("image"));
                dish.setDishDescription(rs.getString("dishDescription"));
                dish.setStock(rs.getInt("stock"));
                dish.setTotalPrice(rs.getBigDecimal("totalPrice"));
                dish.setIngredientNames(rs.getString("ingredientNames"));
                dish.setAvgRating(rs.getDouble("avgRating"));
                return dish;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // search dish
    public List<Dish> searchDishByName(String searchQuery) {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT d.DishID, d.DishName, d.image, d.DishDescription, d.stock, "
                + "CEILING((ISNULL(SUM(i.quantity * i.unitCost), 0) + d.opCost) * (1 + d.interestPercentage / 100) / 10000.0) * 10000 AS totalPrice "
                + "FROM Dish d "
                + "LEFT JOIN Ingredient i ON d.DishID = i.FK_Ingredient_Dish "
                + "WHERE d.DishName LIKE ? "
                + "GROUP BY d.DishID, d.DishName, d.image, d.DishDescription, d.stock, d.opCost, d.interestPercentage";

        try (
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + searchQuery + "%"); // Gán tham số tìm kiếm

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Dish dish = new Dish();
                    dish.setDishID(rs.getInt("DishID"));
                    dish.setDishName(rs.getString("DishName"));
                    dish.setImage(rs.getString("image"));
                    dish.setDishDescription(rs.getString("DishDescription"));
                    dish.setStock(rs.getInt("stock"));
                    dish.setTotalPrice(rs.getBigDecimal("totalPrice"));

                    dishes.add(dish);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dishes;
    }

    // view dish theo category
    public List<Dish> getDishesByCategory(int catId) {
        List<Dish> dishes = new ArrayList<>();
        String sql = "	SELECT d.DishID, d.DishName, d.image, d.DishDescription, d.stock, \n"
                + "               \n"
                + "			 CEILING((ISNULL(SUM(i.quantity * i.unitCost), 0) + d.opCost) * (1 + d.interestPercentage / 100) / 10000.0) * 10000 AS totalPrice\n"
                + "                 FROM Dish d \n"
                + "                 LEFT JOIN Ingredient i ON d.DishID = i.FK_Ingredient_Dish \n"
                + "                 WHERE d.FK_Dish_Category = ?\n"
                + "                 GROUP BY d.DishID, d.DishName, d.image, d.DishDescription, d.stock, d.opCost, d.interestPercentage";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, catId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Dish dish = new Dish();
                dish.setDishID(rs.getInt("DishID"));
                dish.setDishName(rs.getString("DishName"));
                dish.setImage(rs.getString("image"));
                dish.setDishDescription(rs.getString("DishDescription"));
                dish.setStock(rs.getInt("stock"));
                dish.setTotalPrice(rs.getBigDecimal("totalPrice"));
                dishes.add(dish);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dishes;
    }

}
