package dao;

import java.math.BigDecimal;
import model.DishIngredient;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DishIngredientDAO extends DBContext {

    /**
     * Insert a new record into DishIngredient table
     */
    public boolean addDishIngredient(int dishID, int ingredientID, double quantity) {
        String sql = "INSERT INTO DishIngredient (dishID, ingredientID, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dishID);
            ps.setInt(2, ingredientID);
            ps.setDouble(3, quantity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding DishIngredient: " + e.getMessage());
            return false;
        }
    }

    /**
     * Get all ingredients associated with a given dish
     */
    public List<DishIngredient> getIngredientsByDishID(int dishID) {
        List<DishIngredient> list = new ArrayList<>();
        String sql = "SELECT di.dishID, di.ingredientID, di.quantity, i.name, i.unitCost "
                + "FROM DishIngredient di "
                + "JOIN Ingredient i ON di.ingredientID = i.ingredientID "
                + "WHERE di.dishID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dishID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DishIngredient di = new DishIngredient();
                    di.setDishId(rs.getInt("dishID"));
                    di.setIngredientId(rs.getInt("ingredientID"));
                    di.setQuantity(rs.getDouble("quantity"));
                    di.setIngredientName(rs.getString("name")); // optional helper
                    di.setIngredientCost(rs.getBigDecimal("unitCost")); // optional helper
                    list.add(di);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving ingredients by dishID: " + e.getMessage());
        }
        return list;
    }

    /**
     * Delete all ingredients for a dish (e.g., before update)
     */
    public boolean deleteByDishID(int dishID) {
        String sql = "DELETE FROM DishIngredient WHERE dishID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dishID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting DishIngredient by dishID: " + e.getMessage());
            return false;
        }
    }

    public boolean addIngredientToDish(int dishID, int ingredientID, BigDecimal quantity) {
        String sql = "INSERT INTO DishIngredient (dishID, ingredientID, quantity) VALUES (?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dishID);
            ps.setInt(2, ingredientID);
            ps.setBigDecimal(3, quantity);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<DishIngredient> getAllDishIngredients() {
        List<DishIngredient> list = new ArrayList<>();
        String sql = "SELECT di.dishID, di.ingredientID, di.quantity, i.name AS ingredientName, i.unitCost "
                + "FROM DishIngredient di "
                + "JOIN Ingredient i ON di.ingredientID = i.ingredientID";

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                DishIngredient di = new DishIngredient();
                di.setDishId(rs.getInt("dishID"));
                di.setIngredientId(rs.getInt("ingredientID"));
                di.setQuantity(rs.getDouble("quantity"));
                di.setIngredientName(rs.getString("ingredientName")); // helper field
                di.setIngredientCost(rs.getBigDecimal("unitCost"));   // helper field
                list.add(di);
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving all DishIngredients: " + e.getMessage());
        }

        return list;
    }

    public boolean updateDishIngredientQuantity(int dishId, int ingredientId, BigDecimal newQuantity) {
        String sql = "UPDATE DishIngredient SET quantity = ? WHERE dishID = ? AND ingredientID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBigDecimal(1, newQuantity);
            stmt.setInt(2, dishId);
            stmt.setInt(3, ingredientId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteIngredientFromDish(int dishId, int ingredientId) {
        String sql = "DELETE FROM DishIngredient WHERE dishID = ? AND ingredientID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, dishId);
            stmt.setInt(2, ingredientId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
