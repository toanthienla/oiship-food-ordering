package dao;

import model.Meal;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MealDAO extends DBContext {

    public List<Meal> getAllMeals() {
        List<Meal> meals = new ArrayList<>();
        String sql = "SELECT * FROM Meal";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Meal meal = new Meal();
                meal.setMealID(rs.getInt("mealID"));
                meal.setMealName(rs.getString("mealName") != null ? rs.getString("mealName") : "");
                meal.setPrice(rs.getDouble("price"));
                meal.setImage(rs.getString("image") != null ? rs.getString("image") : "");
                meal.setMealDescription(rs.getString("mealDescription") != null ? rs.getString("mealDescription") : "");
                meal.setStock(rs.getInt("stock"));
                meal.setCategoryId(rs.getInt("FK_Meal_Category"));
                meals.add(meal);
                System.out.println("Fetched meal: " + meal.getMealName());
            }
        } catch (SQLException e) {
            System.err.println("Error fetching meals: " + e.getMessage());
            e.printStackTrace();
        }
        return meals; // Sửa lỗi: trả về meals thay vì orders
    }
}
