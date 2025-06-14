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

    // Retrieve all dishes
    public List<Dish> getAllDishes() {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT d.DishID, d.DishName, d.image, d.opCost, d.interestPercentage "
                + "FROM Dish d "
                + "ORDER BY d.DishID ASC";

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

                // Get ingredient list & calculate ingredient cost
                List<Ingredient> ingredients = ingredientDAO.getIngredientsByDishId(dishId);
                BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(ingredients);

                // Calculate total price (selling price of dish)
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

    // View dish detail by ID
    public Dish getDishDetailById(int dishId) {
        String sql = "SELECT d.DishID, d.DishName, d.image, d.dishDescription, d.stock,\n"
                + "       d.opCost, d.interestPercentage,\n"
                + "       STUFF((SELECT DISTINCT ', ' + i2.name\n"
                + "              FROM DishIngredient di2\n"
                + "              JOIN Ingredient i2 ON di2.ingredientID = i2.ingredientID\n"
                + "              WHERE di2.dishID = d.DishID\n"
                + "              FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS ingredientNames,\n"
                + "       ROUND(AVG(CAST(r.rating AS FLOAT)), 2) AS avgRating\n"
                + "FROM Dish d\n"
                + "LEFT JOIN OrderDetail od ON od.FK_OD_Dish = d.DishID\n"
                + "LEFT JOIN Review r ON r.FK_Review_OrderDetail = od.ODID\n"
                + "WHERE d.DishID = ?\n"
                + "GROUP BY d.DishID, d.DishName, d.image, d.dishDescription, d.stock, d.opCost, d.interestPercentage";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, dishId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Dish dish = new Dish();
                int dishIdFromDB = rs.getInt("DishID");

                dish.setDishID(dishIdFromDB);
                dish.setDishName(rs.getString("DishName"));
                dish.setImage(rs.getString("image"));
                dish.setDishDescription(rs.getString("dishDescription"));
                dish.setStock(rs.getInt("stock"));
                dish.setIngredientNames(rs.getString("ingredientNames"));
                dish.setAvgRating(rs.getDouble("avgRating"));

                BigDecimal opCost = rs.getBigDecimal("opCost");
                BigDecimal interest = rs.getBigDecimal("interestPercentage");

                // ✅ Get ingredients for the dish
                IngredientDAO dao = new IngredientDAO();
                List<Ingredient> ingredients = dao.getIngredientsByDishId(dishIdFromDB);

                // ✅ Calculate total price using utility
                BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(ingredients);
                BigDecimal totalPrice = TotalPriceCalculator.calculateTotalPrice(opCost, interest, ingredientCost);
                String formatted = TotalPriceCalculator.formatVND(totalPrice);

                dish.setTotalPrice(totalPrice);
                dish.setFormattedPrice(formatted);

                return dish;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Search for dishes by name
    public List<Dish> searchDishByName(String searchQuery) {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT d.DishID, d.DishName, d.image, d.DishDescription, d.stock, d.opCost, d.interestPercentage "
                + "FROM Dish d "
                + "WHERE d.DishName LIKE ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + searchQuery + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Dish dish = new Dish();
                    int dishId = rs.getInt("DishID");

                    dish.setDishID(dishId);
                    dish.setDishName(rs.getString("DishName"));
                    dish.setImage(rs.getString("image"));
                    dish.setDishDescription(rs.getString("DishDescription"));
                    dish.setStock(rs.getInt("stock"));

                    BigDecimal opCost = rs.getBigDecimal("opCost");
                    BigDecimal interest = rs.getBigDecimal("interestPercentage");

                    // Get ingredient list from DAO
                    List<Ingredient> ingredients = new IngredientDAO().getIngredientsByDishId(dishId);
                    BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(ingredients);

                    // Calculate total price
                    BigDecimal totalPrice = TotalPriceCalculator.calculateTotalPrice(opCost, interest, ingredientCost);
                    dish.setTotalPrice(totalPrice);
                    dish.setFormattedPrice(TotalPriceCalculator.formatVND(totalPrice));

                    dishes.add(dish);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dishes;
    }

    // View dishes by category
    public List<Dish> getDishesByCategory(int catId) {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT d.DishID, d.DishName, d.image, d.DishDescription, d.stock, d.opCost, d.interestPercentage "
                + "FROM Dish d "
                + "WHERE d.FK_Dish_Category = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, catId);
            ResultSet rs = stmt.executeQuery();

            IngredientDAO ingredientDAO = new IngredientDAO();

            while (rs.next()) {
                Dish dish = new Dish();
                dish.setDishID(rs.getInt("DishID"));
                dish.setDishName(rs.getString("DishName"));
                dish.setImage(rs.getString("image"));
                dish.setDishDescription(rs.getString("DishDescription"));
                dish.setStock(rs.getInt("stock"));

                BigDecimal opCost = rs.getBigDecimal("opCost");
                BigDecimal interest = rs.getBigDecimal("interestPercentage");

                List<Ingredient> ingredients = ingredientDAO.getIngredientsByDishId(dish.getDishID());
                BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(ingredients);
                BigDecimal totalPrice = TotalPriceCalculator.calculateTotalPrice(opCost, interest, ingredientCost);

                dish.setTotalPrice(totalPrice);
                dish.setFormattedPrice(TotalPriceCalculator.formatVND(totalPrice));

                dishes.add(dish);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dishes;
    }
}
