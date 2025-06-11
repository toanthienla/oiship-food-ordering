package dao;

import java.math.BigDecimal;
import model.Dish;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DishDAO extends DBContext {

    public List<Dish> getAllDishes() {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT TOP 10\n"
                + "    d.DishID,\n"
                + "    d.DishName,\n"
                + "    d.image,\n"
                + "   CEILING((ISNULL(SUM(i.quantity * i.unitCost), 0) + d.opCost) * (1 + d.interestPercentage / 100) / 10000.0) * 10000 AS totalPrice \n"
                + "FROM \n"
                + "    Dish d\n"
                + "LEFT JOIN \n"
                + "    Ingredient i ON d.DishID = i.FK_Ingredient_Dish\n"
                + "GROUP BY \n"
                + "    d.DishID, d.DishName, d.image, d.opCost, d.interestPercentage\n"
                + "ORDER BY \n"
                + "    d.DishID ASC;";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Dish item = new Dish();
                item.setDishID(rs.getInt("DishID"));
                item.setDishName(rs.getString("DishName"));
                item.setImage(rs.getString("image"));
                item.setTotalPrice(rs.getBigDecimal("totalPrice"));
                dishes.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dishes;
    }

    public Dish getDishById(int dishId) {
      String sql = "SELECT d.DishID, d.DishName, d.image, d.dishDescription, d.stock, " +
                 "CEILING((ISNULL(SUM(i.quantity * i.unitCost), 0) + d.opCost) * (1 + d.interestPercentage / 100) / 10000.0) * 10000 AS totalPrice " +
                 "FROM Dish d " +
                 "LEFT JOIN Ingredient i ON d.DishID = i.FK_Ingredient_Dish " +
                 "WHERE d.DishID = ? " +
                 "GROUP BY d.DishID, d.DishName, d.image, d.dishDescription, d.stock, d.opCost, d.interestPercentage";

    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, dishId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Dish dish = new Dish();
                dish.setDishID(rs.getInt("DishID"));
                dish.setDishName(rs.getString("DishName"));
                dish.setImage(rs.getString("image"));
                dish.setDishDescription(rs.getString("dishDescription"));
                dish.setStock(rs.getInt("stock"));
                dish.setTotalPrice(rs.getBigDecimal("totalPrice"));
                return dish;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

    
    
}
