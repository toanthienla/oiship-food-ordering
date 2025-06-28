package dao;

import java.math.BigDecimal;
import model.Dish;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Ingredient;
import utils.TotalPriceCalculator;

public class DishDAO extends DBContext {

    public boolean addDish(Dish dish) {
        String sql = "INSERT INTO Dish (DishName, opCost, interestPercentage, image, DishDescription, stock, isAvailable, FK_Dish_Category) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dish.getDishName());
            ps.setBigDecimal(2, dish.getOpCost());
            ps.setBigDecimal(3, dish.getInterestPercentage());
            ps.setString(4, dish.getImage());
            ps.setString(5, dish.getDishDescription());
            ps.setInt(6, dish.getStock());
            ps.setBoolean(7, dish.isIsAvailable());
            ps.setInt(8, dish.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateDish(Dish dish) {
        String sql = "UPDATE Dish SET DishName=?, opCost=?, interestPercentage=?, image=?, DishDescription=?, stock=?, isAvailable=?, FK_Dish_Category=? "
                + "WHERE DishID=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dish.getDishName());
            ps.setBigDecimal(2, dish.getOpCost());
            ps.setBigDecimal(3, dish.getInterestPercentage());
            ps.setString(4, dish.getImage());
            ps.setString(5, dish.getDishDescription());
            ps.setInt(6, dish.getStock());
            ps.setBoolean(7, dish.isIsAvailable());
            ps.setInt(8, dish.getCategoryId());
            ps.setInt(9, dish.getDishID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Dish getDishById(int id) {
        String sql = "SELECT * FROM Dish WHERE DishID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Dish(
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteDishById(int id) {
        String deleteDishIngredientSql = "DELETE FROM DishIngredient WHERE dishID = ?";
        String deleteDishSql = "DELETE FROM Dish WHERE DishID = ?";

        try {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(deleteDishIngredientSql)) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(deleteDishSql)) {
                ps2.setInt(1, id);
                int rows = ps2.executeUpdate();
                conn.commit();
                return rows > 0;
            }
        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<Dish> getAllDishes() {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT d.DishID, d.DishName, d.image, d.opCost, d.interestPercentage, d.DishDescription, "
                + "d.stock, d.isAvailable, d.FK_Dish_Category, "
                + "c.catName, c.catDescription "
                + "FROM Dish d "
                + "LEFT JOIN Category c ON d.FK_Dish_Category = c.catID "
                + "ORDER BY d.DishID ASC";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            IngredientDAO ingredientDAO = new IngredientDAO();

            while (rs.next()) {
                Dish item = new Dish();
                int dishId = rs.getInt("DishID");

                item.setDishID(dishId);
                item.setDishName(rs.getString("DishName"));
                item.setImage(rs.getString("image"));
                item.setOpCost(rs.getBigDecimal("opCost"));
                item.setInterestPercentage(rs.getBigDecimal("interestPercentage"));
                item.setDishDescription(rs.getString("DishDescription"));
                item.setStock(rs.getInt("stock"));
                item.setIsAvailable(rs.getBoolean("isAvailable"));
                item.setCategoryId(rs.getInt("FK_Dish_Category"));

                List<Ingredient> ingredients = ingredientDAO.getIngredientsByDishId(dishId);
                BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(ingredients);
                BigDecimal totalPrice = TotalPriceCalculator.calculateTotalPrice(
                        item.getOpCost(), item.getInterestPercentage(), ingredientCost);

                item.setTotalPrice(totalPrice);
                item.setFormattedPrice(TotalPriceCalculator.formatVND(totalPrice));
                item.setIngredients(ingredients);

                String catName = rs.getString("catName");
                if (catName != null) {
                    Category category = new Category();
                    category.setCatID(item.getCategoryId());
                    category.setCatName(catName);
                    category.setCatDescription(rs.getString("catDescription"));
                    item.setCategory(category);
                }

                dishes.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dishes;
    }

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
                dish.setDishID(rs.getInt("DishID"));
                dish.setDishName(rs.getString("DishName"));
                dish.setImage(rs.getString("image"));
                dish.setDishDescription(rs.getString("dishDescription"));
                dish.setStock(rs.getInt("stock"));
                dish.setIngredientNames(rs.getString("ingredientNames"));
                dish.setAvgRating(rs.getDouble("avgRating"));

                BigDecimal opCost = rs.getBigDecimal("opCost");
                BigDecimal interest = rs.getBigDecimal("interestPercentage");

                IngredientDAO dao = new IngredientDAO();
                List<Ingredient> ingredients = dao.getIngredientsByDishId(dish.getDishID());

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

    public boolean decreaseStock(int dishId, int quantity) throws SQLException {
        String sql = "UPDATE Dish SET stock = stock - ? WHERE dishID = ? AND stock >= ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, dishId);
            stmt.setInt(3, quantity);
            return stmt.executeUpdate() > 0; // nếu trả về 0 thì tức là không đủ tồn kho
        }
    }

    public int getDishStockByDishId(int dishID) throws SQLException {
        String sql = "SELECT stock FROM Dish WHERE DishID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dishID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock");
            }
        }
        return 0; // Không tìm thấy -> coi như hết hàng
    }

}
