package dao;

import model.Ingredient;
import model.Dish;
import model.DishIngredient;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

public class IngredientDAO extends DBContext {

    public IngredientDAO() {
        super();
        if (conn == null) {
            System.err.println("Connection is null in IngredientDAO constructor. Check DBContext configuration.");
        } else {
            System.out.println("Connection established successfully in IngredientDAO.");
        }
    }

    public List<Ingredient> getAllIngredients() {
        List<Ingredient> ingredients = new ArrayList<>();
        String sql = "SELECT ingredientID, name, unitCost, FK_Ingredient_Account FROM Ingredient";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Ingredient ingredient = new Ingredient(
                        rs.getInt("ingredientID"),
                        rs.getString("name"),
                        rs.getDouble("unitCost"),
                        rs.getInt("FK_Ingredient_Account")
                );
                ingredient.setDishIngredients(getDishIngredientsByIngredientId(ingredient.getIngredientId()));
                ingredients.add(ingredient);
            }
            System.out.println("Fetched " + ingredients.size() + " ingredients.");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching ingredients: " + e.getMessage());
        }
        return ingredients;
    }

    public List<Dish> getAllDishes() {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT DishID, DishName FROM Dish ORDER BY DishID ASC";
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Dish dish = new Dish(
                        rs.getInt("DishID"),
                        rs.getString("DishName"),
                        null, null, null, null, 0, 0, null, null, null, null
                );
                dishes.add(dish);
            }
            System.out.println("Fetched " + dishes.size() + " dishes.");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching dishes: " + e.getMessage());
        }
        return dishes;
    }

    public List<Ingredient> getIngredientsByDishId(int dishId) {
        List<Ingredient> ingredients = new ArrayList<>();
        String sql = "SELECT i.ingredientID, i.name, i.unitCost, i.FK_Ingredient_Account "
                + "FROM Ingredient i "
                + "JOIN DishIngredient di ON i.ingredientID = di.ingredientID "
                + "WHERE di.dishID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, dishId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Ingredient ingredient = new Ingredient(
                            rs.getInt("ingredientID"),
                            rs.getString("name"),
                            rs.getDouble("unitCost"),
                            rs.getInt("FK_Ingredient_Account")
                    );
                    ingredients.add(ingredient);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching ingredients for dish ID " + dishId + ": " + e.getMessage());
        }
        return ingredients;
    }

    public void addIngredient(Ingredient ingredient) {
        String sql = "INSERT INTO Ingredient (name, unitCost, FK_Ingredient_Account) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, ingredient.getIngredientName());
            pstmt.setDouble(2, ingredient.getUnitCost());
            pstmt.setInt(3, ingredient.getFkIngredientAccount());
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        ingredient.setIngredientId(generatedKeys.getInt(1));
                    }
                }
                System.out.println("Added ingredient: " + ingredient.getIngredientName() + " (ID: " + ingredient.getIngredientId() + ")");
            } else {
                System.err.println("Failed to add ingredient: " + ingredient.getIngredientName());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error adding ingredient: " + e.getMessage());
        }
    }

    public void updateIngredient(Ingredient ingredient) {
        String sql = "UPDATE Ingredient SET name = ?, unitCost = ?, FK_Ingredient_Account = ? WHERE ingredientID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, ingredient.getIngredientName());
            pstmt.setDouble(2, ingredient.getUnitCost());
            pstmt.setInt(3, ingredient.getFkIngredientAccount());
            pstmt.setInt(4, ingredient.getIngredientId());
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Updated ingredient ID: " + ingredient.getIngredientId());
            } else {
                System.err.println("No rows updated for ingredient ID: " + ingredient.getIngredientId());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error updating ingredient: " + e.getMessage());
        }
    }

    public boolean deleteIngredient(int ingredientId) {
        String sql = "DELETE FROM Ingredient WHERE ingredientID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, ingredientId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error deleting ingredient: " + e.getMessage());
            return false;
        }
    }

    public void addDishIngredient(int dishId, int ingredientId, double quantity) {
        String sql = "INSERT INTO DishIngredient (dishID, ingredientID, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, dishId);
            pstmt.setInt(2, ingredientId);
            pstmt.setDouble(3, quantity);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Added relation: DishID " + dishId + " - IngredientID " + ingredientId);
            } else {
                System.err.println("Failed to add relation: DishID " + dishId + " - IngredientID " + ingredientId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error adding DishIngredient relation: " + e.getMessage());
        }
    }

    public List<DishIngredient> getDishIngredientsByIngredientId(int ingredientId) {
        List<DishIngredient> dishIngredients = new ArrayList<>();
        String sql = "SELECT dishID, ingredientID, quantity FROM DishIngredient WHERE ingredientID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, ingredientId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    DishIngredient di = new DishIngredient(
                            rs.getInt("dishID"),
                            rs.getInt("ingredientID"),
                            rs.getDouble("quantity")
                    );
                    dishIngredients.add(di);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching dish ingredients for ingredient ID " + ingredientId + ": " + e.getMessage());
        }
        return dishIngredients;
    }

    public DishIngredient getDishIngredient(int dishId, int ingredientId) {
        String sql = "SELECT dishID, ingredientID, quantity FROM DishIngredient WHERE dishID = ? AND ingredientID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, dishId);
            pstmt.setInt(2, ingredientId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new DishIngredient(
                            rs.getInt("dishID"),
                            rs.getInt("ingredientID"),
                            rs.getDouble("quantity")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching dish ingredient for dish ID " + dishId + " and ingredient ID " + ingredientId + ": " + e.getMessage());
        }
        return null;
    }

    public void updateDishIngredient(DishIngredient dishIngredient) {
        String sql = "UPDATE DishIngredient SET quantity = ? WHERE dishID = ? AND ingredientID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDouble(1, dishIngredient.getQuantity());
            pstmt.setInt(2, dishIngredient.getDishId());
            pstmt.setInt(3, dishIngredient.getIngredientId());
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Updated DishIngredient: DishID " + dishIngredient.getDishId() + " - IngredientID " + dishIngredient.getIngredientId());
            } else {
                System.err.println("No DishIngredient updated for DishID " + dishIngredient.getDishId() + " - IngredientID " + dishIngredient.getIngredientId());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error updating DishIngredient: " + e.getMessage());
        }
    }

    public void deleteDishIngredientsByIngredientId(int ingredientId) {
        String sql = "DELETE FROM DishIngredient WHERE ingredientID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, ingredientId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Deleted " + rowsAffected + " DishIngredient relations for ingredient ID: " + ingredientId);
            } else {
                System.err.println("No DishIngredient relations found to delete for ingredient ID: " + ingredientId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error deleting DishIngredient relations: " + e.getMessage());
        }
    }
}
