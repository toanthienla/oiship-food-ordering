/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Dish;
import utils.DBContext;

/**
 *
 * @author Phi Yen
 */
public class CategoryDAO extends DBContext {
   
    // view list category
    public List<Category> getAllCategories() {
    List<Category> categories = new ArrayList<>();
    String sql = "SELECT catID, catName, catDescription FROM Category";

    try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            Category category = new Category();
            category.setCatID(rs.getInt("catID"));
            category.setCatName(rs.getString("catName"));
            category.setCatDescription(rs.getString("catDescription"));
            categories.add(category);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return categories;
}


}
