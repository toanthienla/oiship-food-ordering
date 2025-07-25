package dao;

import model.Dish;
import model.DishIngredient;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import model.Ingredient;
import utils.DBContext;

public class IngredientDAO extends DBContext {

    private static final int DEFAULT_ACCOUNT_ID = 1; // Default to admin account ID
    private static final int DEFAULT_DISH_CATEGORY_ID = 1; // Default category, adjust as needed

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
        if (conn == null) {
            System.err.println("Database connection is null in getAllIngredients.");
            return ingredients;
        }
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                int ingredientId = rs.getInt("ingredientID");
                Ingredient ingredient = new Ingredient(
                        ingredientId,
                        rs.getString("name"),
                        rs.getBigDecimal("unitCost"),
                        rs.getInt("FK_Ingredient_Account"),
                        getDishIngredientsByIngredientId(ingredientId), // Populate dishIngredients
                        0, // Default dishId to 0 if no direct dish association
                        rs.getInt("FK_Ingredient_Account") // Set accountID to match fkIngredientAccount
                );
                ingredients.add(ingredient);
            }
            System.out.println("Fetched " + ingredients.size() + " ingredients.");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching ingredients: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
        return ingredients;
    }

    public List<Dish> getAllDishes() {
        List<Dish> dishes = new ArrayList<>();
        String sql = "SELECT d.DishID, d.DishName, d.opCost, d.interestPercentage, d.[image], d.DishDescription, d.stock, d.FK_Dish_Category, "
                + "AVG(r.rating * 1.0) as avgRating "
                + "FROM Dish d "
                + "LEFT JOIN OrderDetail od ON d.DishID = od.FK_OD_Dish "
                + "LEFT JOIN Review r ON od.ODID = r.FK_Review_OrderDetail "
                + "GROUP BY d.DishID, d.DishName, d.opCost, d.interestPercentage, d.[image], d.DishDescription, d.stock, d.FK_Dish_Category "
                + "ORDER BY d.DishID ASC";
        if (conn == null) {
            System.err.println("Database connection is null in getAllDishes.");
            return dishes;
        }
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                int dishId = rs.getInt("DishID");
                BigDecimal opCost = rs.getBigDecimal("opCost");
                BigDecimal interestPercentage = rs.getBigDecimal("interestPercentage");
                BigDecimal totalPrice = (opCost != null && interestPercentage != null)
                        ? opCost.multiply(BigDecimal.ONE.add(interestPercentage.divide(new BigDecimal("100"), 2, BigDecimal.ROUND_HALF_UP)))
                        : null;

                Dish dish = new Dish(
                        dishId,
                        rs.getString("DishName"),
                        opCost,
                        interestPercentage,
                        rs.getString("image"),
                        rs.getString("DishDescription"),
                        rs.getInt("stock"),
                        rs.getInt("FK_Dish_Category"),
                        totalPrice,
                        getIngredientNamesByDishId(dishId),
                        rs.getDouble("avgRating") != 0 ? rs.getDouble("avgRating") : null,
                        getListIngredientsByDishId(dishId)
                );
                dishes.add(dish);
            }
            System.out.println("Fetched " + dishes.size() + " dishes.");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching dishes: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
        return dishes;
    }

    private String getIngredientNamesByDishId(int dishId) {
        StringBuilder ingredientNames = new StringBuilder();
        String sql = "SELECT i.name FROM Ingredient i JOIN DishIngredient di ON i.ingredientID = di.ingredientID WHERE di.dishID = ?";
        if (conn == null) {
            System.err.println("Database connection is null in getIngredientNamesByDishId for dish ID " + dishId);
            return null;
        }
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, dishId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    if (ingredientNames.length() > 0) {
                        ingredientNames.append(", ");
                    }
                    ingredientNames.append(rs.getString("name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching ingredient names for dish ID " + dishId + ": " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
        return ingredientNames.length() > 0 ? ingredientNames.toString() : null;
    }

    public List<Ingredient> getListIngredientsByDishId(int dishId) {
        List<Ingredient> ingredients = new ArrayList<>();
        String sql = "SELECT i.ingredientID, i.name, i.unitCost, i.FK_Ingredient_Account, di.quantity "
                + "FROM Ingredient i JOIN DishIngredient di ON i.ingredientID = di.ingredientID WHERE di.dishID = ?";
        if (conn == null) {
            System.err.println("Database connection is null in getListIngredientsByDishId for dish ID " + dishId);
            return ingredients;
        }
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, dishId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Ingredient ingredient = new Ingredient(
                            rs.getInt("ingredientID"),
                            rs.getString("name"),
                            rs.getBigDecimal("unitCost"),
                            rs.getInt("FK_Ingredient_Account"),
                            List.of(new DishIngredient(dishId, rs.getInt("ingredientID"), rs.getDouble("quantity"))), // Set dishIngredients
                            dishId, // Set dishId from the query context
                            rs.getInt("FK_Ingredient_Account") // Set accountID to match fkIngredientAccount
                    );
                    ingredients.add(ingredient);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching ingredients for dish ID " + dishId + ": " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
        return ingredients;
    }

    public void addIngredient(Ingredient ingredient, Integer dishId, Double quantity) {
        String sql = "INSERT INTO Ingredient (name, unitCost, FK_Ingredient_Account) VALUES (?, ?, ?)";
        if (conn == null) {
            System.err.println("Database connection is null in addIngredient.");
            return;
        }
        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, ingredient.getIngredientName());
            pstmt.setBigDecimal(2, ingredient.getUnitCost());
            pstmt.setInt(3, DEFAULT_ACCOUNT_ID);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int ingredientId = generatedKeys.getInt(1);
                        ingredient.setIngredientId(ingredientId);
                        if (dishId != null && quantity != null) {
                            addDishIngredient(dishId, ingredientId, quantity);
                            ingredient.setDishId(dishId); // Update dishId after adding relationship
                            ingredient.setDishIngredients(List.of(new DishIngredient(dishId, ingredientId, quantity)));
                        }
                        ingredient.setAccountID(DEFAULT_ACCOUNT_ID); // Set accountID
                    }
                }
                System.out.println("Added ingredient: " + ingredient.getIngredientName() + " (ID: " + ingredient.getIngredientId() + ")");
            } else {
                System.err.println("Failed to add ingredient: " + ingredient.getIngredientName());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error adding ingredient: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
    }

    public void updateIngredient(Ingredient ingredient, Integer dishId, Double quantity) {
        String sql = "UPDATE Ingredient SET name = ?, unitCost = ?, FK_Ingredient_Account = ? WHERE ingredientID = ?";
        if (conn == null) {
            System.err.println("Database connection is null in updateIngredient.");
            return;
        }
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, ingredient.getIngredientName());
            pstmt.setBigDecimal(2, ingredient.getUnitCost());
            pstmt.setInt(3, DEFAULT_ACCOUNT_ID);
            pstmt.setInt(4, ingredient.getIngredientId());
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Updated ingredient ID: " + ingredient.getIngredientId());
                if (dishId != null && quantity != null) {
                    DishIngredient existing = getDishIngredient(dishId, ingredient.getIngredientId());
                    if (existing != null) {
                        updateDishIngredient(new DishIngredient(dishId, ingredient.getIngredientId(), quantity));
                    } else {
                        addDishIngredient(dishId, ingredient.getIngredientId(), quantity);
                    }
                    ingredient.setDishId(dishId); // Update dishId
                    ingredient.setDishIngredients(List.of(new DishIngredient(dishId, ingredient.getIngredientId(), quantity)));
                } else if (dishId != null) {
                    deleteDishIngredient(dishId, ingredient.getIngredientId());
                    ingredient.setDishId(0); // Reset dishId if no relationship
                    ingredient.setDishIngredients(null);
                }
                ingredient.setAccountID(DEFAULT_ACCOUNT_ID); // Update accountID
            } else {
                System.err.println("No rows updated for ingredient ID: " + ingredient.getIngredientId());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error updating ingredient: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
    }

    public boolean deleteIngredient(int ingredientId) {
        return deleteIngredients(List.of(ingredientId));
    }

    public boolean deleteIngredients(List<Integer> ingredientIds) {
        if (ingredientIds == null || ingredientIds.isEmpty()) {
            System.err.println("No ingredient IDs provided for deletion.");
            return false;
        }
        if (conn == null) {
            System.err.println("Database connection is null in deleteIngredients.");
            return false;
        }

        String deleteDishIngredientSql = "DELETE FROM DishIngredient WHERE ingredientID = ?";
        String deleteIngredientSql = "DELETE FROM Ingredient WHERE ingredientID = ?";

        try {
            conn.setAutoCommit(false); // Start transaction

            // Delete all associated DishIngredient records
            try (PreparedStatement pstmtDish = conn.prepareStatement(deleteDishIngredientSql)) {
                for (int id : ingredientIds) {
                    pstmtDish.setInt(1, id);
                    int dishIngredientsDeleted = pstmtDish.executeUpdate();
                    System.out.println("Deleted " + dishIngredientsDeleted + " DishIngredient records for ingredient ID " + id);
                }
            }

            // Delete the Ingredients
            try (PreparedStatement pstmtIng = conn.prepareStatement(deleteIngredientSql)) {
                for (int id : ingredientIds) {
                    pstmtIng.setInt(1, id);
                    int rowsAffected = pstmtIng.executeUpdate();
                    if (rowsAffected > 0) {
                        System.out.println("Deleted ingredient ID: " + id);
                    } else {
                        System.err.println("No ingredient found to delete for ID: " + id + " or still constrained by other foreign keys.");
                    }
                }
            }

            conn.commit(); // Commit transaction
            return true;
        } catch (SQLException e) {
            try {
                conn.rollback(); // Rollback on error
                System.err.println("Error deleting ingredients: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + "). Check for additional foreign key constraints.");
            } catch (SQLException rollbackEx) {
                System.err.println("Rollback failed: " + rollbackEx.getMessage() + " (SQLState: " + rollbackEx.getSQLState() + ", Error Code: " + rollbackEx.getErrorCode() + ")");
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                conn.setAutoCommit(true); // Reset auto-commit
            } catch (SQLException e) {
                System.err.println("Failed to reset auto-commit: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
            }
        }
    }

    public void addDishIngredient(int dishId, int ingredientId, double quantity) {
        String sql = "INSERT INTO DishIngredient (dishID, ingredientID, quantity) VALUES (?, ?, ?)";
        if (conn == null) {
            System.err.println("Database connection is null in addDishIngredient.");
            return;
        }
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
            System.err.println("Error adding DishIngredient relation: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
    }

    public List<DishIngredient> getDishIngredientsByIngredientId(int ingredientId) {
        List<DishIngredient> dishIngredients = new ArrayList<>();
        String sql = "SELECT dishID, ingredientID, quantity FROM DishIngredient WHERE ingredientID = ?";
        if (conn == null) {
            System.err.println("Database connection is null in getDishIngredientsByIngredientId for ingredient ID " + ingredientId);
            return dishIngredients;
        }
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
            System.err.println("Error fetching dish ingredients for ingredient ID " + ingredientId + ": " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
        return dishIngredients;
    }

    public DishIngredient getDishIngredient(int dishId, int ingredientId) {
        String sql = "SELECT dishID, ingredientID, quantity FROM DishIngredient WHERE dishID = ? AND ingredientID = ?";
        if (conn == null) {
            System.err.println("Database connection is null in getDishIngredient for dish ID " + dishId + " and ingredient ID " + ingredientId);
            return null;
        }
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
            System.err.println("Error fetching dish ingredient for dish ID " + dishId + " and ingredient ID " + ingredientId + ": " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
        return null;
    }

    public void updateDishIngredient(DishIngredient dishIngredient) {
        String sql = "UPDATE DishIngredient SET quantity = ? WHERE dishID = ? AND ingredientID = ?";
        if (conn == null) {
            System.err.println("Database connection is null in updateDishIngredient.");
            return;
        }
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
            System.err.println("Error updating DishIngredient: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
    }

    public boolean deleteDishIngredient(int dishId, int ingredientId) {
        String sql = "DELETE FROM DishIngredient WHERE dishID = ? AND ingredientID = ?";
        if (conn == null) {
            System.err.println("Database connection is null in deleteDishIngredient.");
            return false;
        }
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, dishId);
            pstmt.setInt(2, ingredientId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Deleted DishIngredient: DishID " + dishId + " - IngredientID " + ingredientId);
                return true;
            } else {
                System.err.println("No DishIngredient found to delete for DishID " + dishId + " - IngredientID " + ingredientId);
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error deleting DishIngredient: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
            return false;
        }
    }

    public List<String> getIngredientNames() {
        List<String> names = new ArrayList<>();
        String sql = "SELECT DISTINCT name FROM Ingredient";
        if (conn == null) {
            System.err.println("Database connection is null in getIngredientNames.");
            return names;
        }
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                names.add(rs.getString("name"));
            }
            System.out.println("Fetched " + names.size() + " ingredient names for autocomplete.");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching ingredient names: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
        return names;
    }

//    public List<String> getDishNames() {
//        List<String> names = new ArrayList<>();
//        String sql = "SELECT DISTINCT DishName FROM Dish";
//        if (conn == null) {
//            System.err.println("Database connection is null in getDishNames.");
//            return names;
//        }
//        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
//            while (rs.next()) {
//                names.add(rs.getString("DishName"));
//            }
//            System.out.println("Fetched " + names.size() + " dish names for autocomplete.");
//        } catch (SQLException e) {
//            e.printStackTrace();
//            System.err.println("Error fetching dish names: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
//        }
//        return names;
//    }

    public int addDish(String dishName) {
        String sql = "INSERT INTO Dish (DishName, opCost, interestPercentage, FK_Dish_Category) VALUES (?, 0, 0, ?)";
        if (conn == null) {
            System.err.println("Database connection is null in addDish.");
            return -1;
        }
        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, dishName);
            pstmt.setInt(2, DEFAULT_DISH_CATEGORY_ID);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int dishId = generatedKeys.getInt(1);
                        System.out.println("Added new dish: " + dishName + " (ID: " + dishId + ")");
                        return dishId;
                    }
                }
            } else {
                System.err.println("Failed to add dish: " + dishName);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error adding dish: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", Error Code: " + e.getErrorCode() + ")");
        }
        return -1; // Indicate failure
    }

    public List<Ingredient> getIngredientsByDishId(int dishId) {
        List<Ingredient> ingredients = new ArrayList<>();
        String sql = "SELECT i.ingredientID, i.name, i.unitCost, di.dishID, di.quantity "
                + "FROM DishIngredient di "
                + "JOIN Ingredient i ON di.ingredientID = i.ingredientID "
                + "WHERE di.dishID = ?";

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
                    di.setQuantity(rs.getDouble("quantity"));

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

    public int addIngredient(Ingredient ingredient) {
        String sql = "INSERT INTO Ingredient (name, unitCost, FK_Ingredient_Account) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, ingredient.getIngredientName());
            ps.setBigDecimal(2, ingredient.getUnitCost());
            ps.setInt(3, ingredient.getAccountID());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating ingredient failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1); // Return the generated ingredientID
                } else {
                    throw new SQLException("Creating ingredient failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // If failed
    }

    public boolean updateIngredient(Ingredient ingredient) {
        String sql = "UPDATE Ingredient SET name = ?, unitCost = ? WHERE ingredientID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ingredient.getIngredientName());
            ps.setBigDecimal(2, ingredient.getUnitCost());
            ps.setInt(3, ingredient.getIngredientId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteIngredientById(int ingredientId) throws SQLException {
        String deleteDishIngredientSql = "DELETE FROM DishIngredient WHERE ingredientID = ?";
        String deleteIngredientSql = "DELETE FROM Ingredient WHERE ingredientID = ?";

        try (
                PreparedStatement ps1 = conn.prepareStatement(deleteDishIngredientSql); PreparedStatement ps2 = conn.prepareStatement(deleteIngredientSql)) {
            ps1.setInt(1, ingredientId);
            ps1.executeUpdate();

            ps2.setInt(1, ingredientId);
            int affected = ps2.executeUpdate();

            conn.commit();
            return affected > 0;
        } catch (SQLException ex) {
            conn.rollback();
            ex.printStackTrace();
        }
        return false;
    }
}
