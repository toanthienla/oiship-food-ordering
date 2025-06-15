package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Dish;
import model.Category;
import model.Ingredient;
import utils.DBContext;
import utils.TotalPriceCalculator;

public class DishDAO extends DBContext {

    public List<Dish> getAllDishes() {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT "
                + "d.DishID, d.DishName, d.opCost, d.interestPercentage, d.image, "
                + "d.DishDescription, d.stock, d.isAvailable, d.FK_Dish_Category AS categoryID "
                + "FROM Dish d "
                + "ORDER BY d.DishID ASC";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            CategoryDAO categoryDAO = new CategoryDAO();
            IngredientDAO ingredientDAO = new IngredientDAO();

            while (rs.next()) {
                Dish item = new Dish();
                int dishId = rs.getInt("DishID");

                item.setDishID(dishId);
                item.setDishName(rs.getString("DishName"));
                item.setOpCost(rs.getBigDecimal("opCost"));
                item.setInterestPercentage(rs.getBigDecimal("interestPercentage"));
                item.setImage(rs.getString("image"));
                item.setDishDescription(rs.getString("DishDescription"));
                item.setStock(rs.getInt("stock"));
                item.setIsAvailable(rs.getBoolean("isAvailable"));

                // Set category
                int categoryId = rs.getInt("categoryID");
                Category category = categoryDAO.getCategoryById(categoryId);
                item.setCategory(category);

                // Calculate total price
                List<Ingredient> ingredients = ingredientDAO.getIngredientsByDishId(dishId);
                BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(ingredients);
                BigDecimal totalPrice = TotalPriceCalculator.calculateTotalPrice(item.getOpCost(), item.getInterestPercentage(), ingredientCost);
                item.setTotalPrice(totalPrice);
                item.setFormattedPrice(TotalPriceCalculator.formatVND(totalPrice));

                dishes.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dishes;
    }

    public Dish getDishDetailById(int dishId) {
        String sql = "SELECT d.DishID, d.DishName, d.image, d.dishDescription, d.stock, d.opCost, d.interestPercentage, "
                + "STUFF((SELECT DISTINCT ', ' + i2.name FROM Ingredient i2 WHERE i2.FK_Ingredient_Dish = d.DishID FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS ingredientNames, "
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
                dish.setIngredientNames(rs.getString("ingredientNames"));
                dish.setAvgRating(rs.getDouble("avgRating"));

                // Calculate price
                BigDecimal opCost = rs.getBigDecimal("opCost");
                BigDecimal interest = rs.getBigDecimal("interestPercentage");
                List<Ingredient> ingredients = new IngredientDAO().getIngredientsByDishId(dishId);
                BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(ingredients);
                BigDecimal totalPrice = TotalPriceCalculator.calculateTotalPrice(opCost, interest, ingredientCost);

                dish.setTotalPrice(totalPrice);
                dish.setFormattedPrice(TotalPriceCalculator.formatVND(totalPrice));

                return dish;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Dish> searchDishByName(String searchQuery) {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT d.DishID, d.DishName, d.image, d.DishDescription, d.stock, d.opCost, d.interestPercentage "
                + "FROM Dish d WHERE d.DishName LIKE ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + searchQuery + "%");
            ResultSet rs = stmt.executeQuery();

            IngredientDAO ingredientDAO = new IngredientDAO();
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
                List<Ingredient> ingredients = ingredientDAO.getIngredientsByDishId(dishId);
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

    public List<Dish> getDishesByCategory(int catId) {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT d.DishID, d.DishName, d.image, d.DishDescription, d.stock, d.opCost, d.interestPercentage "
                + "FROM Dish d WHERE d.FK_Dish_Category = ?";

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

    public boolean addDish(Dish dish) {
        String sql = "INSERT INTO Dish (DishName, DishDescription, image, opCost, interestPercentage, stock, isAvailable, FK_Dish_Category) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dish.getDishName());
            stmt.setString(2, dish.getDishDescription());
            stmt.setString(3, dish.getImage());
            stmt.setBigDecimal(4, dish.getOpCost());
            stmt.setBigDecimal(5, dish.getInterestPercentage());
            stmt.setInt(6, dish.getStock());
            stmt.setBoolean(7, dish.isAvailable());
            stmt.setInt(8, dish.getCategoryId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateDish(Dish dish) {
        String sql = "UPDATE Dish SET DishName = ?, DishDescription = ?, image = ?, opCost = ?, "
                + "interestPercentage = ?, stock = ?, isAvailable = ?, FK_Dish_Category = ? "
                + "WHERE DishID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dish.getDishName());
            stmt.setString(2, dish.getDishDescription());
            stmt.setString(3, dish.getImage());
            stmt.setBigDecimal(4, dish.getOpCost());
            stmt.setBigDecimal(5, dish.getInterestPercentage());
            stmt.setInt(6, dish.getStock());
            stmt.setBoolean(7, dish.isAvailable());
            stmt.setInt(8, dish.getCategoryId());
            stmt.setInt(9, dish.getDishID());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void deleteDishIngredientsByDishId(int dishID) {
        String sql = "DELETE FROM DishIngredient WHERE dishID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dishID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean deleteDishById(int dishID) {
        // First, delete related DishIngredient records
        deleteDishIngredientsByDishId(dishID);

        String sql = "DELETE FROM Dish WHERE DishID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dishID);
            int rowsAffected = ps.executeUpdate(); 
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false; 
        }
    }

    public Dish getDishById(int dishID) {
        Dish dish = null;
        String sql = "SELECT * FROM Dish WHERE DishID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dishID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                dish = new Dish(
                        rs.getInt("DishID"),
                        rs.getString("DishName"),
                        rs.getBigDecimal("opCost"),
                        rs.getBigDecimal("interestPercentage"),
                        rs.getString("image"),
                        rs.getString("DishDescription"),
                        rs.getInt("stock"),
                        rs.getBoolean("isAvailable"),
                        rs.getInt("FK_Dish_Category")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dish;
    }
}
