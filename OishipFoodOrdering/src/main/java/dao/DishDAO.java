package dao;

import java.math.BigDecimal;
import model.Dish;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Category;

public class DishDAO extends DBContext {

    // view dish list
    public List<Dish> getAllDishes() {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT "
                + "d.DishID, d.DishName, d.opCost, d.interestPercentage, d.image, "
                + "d.DishDescription, d.stock, d.isAvailable, d.FK_Dish_Category AS categoryID, "
                + "CEILING((ISNULL(SUM(i.quantity * i.unitCost), 0) + d.opCost) * (1 + d.interestPercentage / 100) / 10000.0) * 10000 AS totalPrice "
                + "FROM Dish d "
                + "LEFT JOIN Ingredient i ON d.DishID = i.FK_Ingredient_Dish "
                + "GROUP BY d.DishID, d.DishName, d.opCost, d.interestPercentage, d.image, "
                + "d.DishDescription, d.stock, d.isAvailable, d.FK_Dish_Category "
                + "ORDER BY d.DishID ASC";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            CategoryDAO categoryDAO = new CategoryDAO(); // To get Category details

            while (rs.next()) {
                Dish item = new Dish();
                item.setDishID(rs.getInt("DishID"));
                item.setDishName(rs.getString("DishName"));
                item.setOpCost(rs.getBigDecimal("opCost"));
                item.setInterestPercentage(rs.getBigDecimal("interestPercentage"));
                item.setImage(rs.getString("image"));
                item.setDishDescription(rs.getString("DishDescription"));
                item.setStock(rs.getInt("stock"));
                item.setIsAvailable(rs.getBoolean("isAvailable"));
                item.setTotalPrice(rs.getBigDecimal("totalPrice"));

                // Fetch and set category
                int categoryId = rs.getInt("categoryID");
                Category category = categoryDAO.getCategoryById(categoryId);
                item.setCategory(category);

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
                + "CEILING((ISNULL(SUM(i.quantity * i.unitCost), 0) + d.opCost) * (1 + d.interestPercentage / 100) / 10000.0) * 10000 AS totalPrice, "
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
    // Add new dish

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

    // Update existing dish
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

    // Delete dish
    public boolean deleteDishById(int id) {
        String sql = "DELETE FROM Dish WHERE DishID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Dish getDishById(int dishID) {
        Dish dish = null;
        String sql = "SELECT * FROM Dish WHERE dishID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, dishID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                dish = new Dish(
                        rs.getInt("dishID"),
                        rs.getString("dishName"),
                        rs.getBigDecimal("operatingCost"),
                        rs.getBigDecimal("interestPercentage"),
                        rs.getString("image"),
                        rs.getString("description"),
                        rs.getInt("stock"),
                        rs.getBoolean("isAvailable"),
                        rs.getInt("categoryID")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return dish;
    }
}
