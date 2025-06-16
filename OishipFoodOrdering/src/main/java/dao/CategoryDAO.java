package dao;

import model.Category;
import utils.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import dao.DishDAO;

public class CategoryDAO extends DBContext {

    public CategoryDAO() {
        super(); // Call DBContext constructor to init DB connection if needed
    }

    public boolean addCategory(Category category) {
        String sql = "INSERT INTO Category (catName, catDescription) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCatName());
            ps.setString(2, category.getCatDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT catID, catName, catDescription FROM Category";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setCatID(rs.getInt("catID"));
                c.setCatName(rs.getString("catName"));
                c.setCatDescription(rs.getString("catDescription"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM Category WHERE catID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Category(
                        rs.getInt("catID"),
                        rs.getString("catName"),
                        rs.getString("catDescription")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCategory(Category category) {
        String sql = "UPDATE Category SET catName = ?, catDescription = ? WHERE catID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCatName());
            ps.setString(2, category.getCatDescription());
            ps.setInt(3, category.getCatID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCategoryById(int catId) {
        String getDishIdsSql = "SELECT DishID FROM Dish WHERE FK_Dish_Category = ?";
        String deleteCategorySql = "DELETE FROM Category WHERE catID = ?";
        DishDAO dishDAO = new DishDAO();

        try {
            conn.setAutoCommit(false); // Start transaction

            // Step 1: Get all dish IDs in this category
            try (PreparedStatement ps = conn.prepareStatement(getDishIdsSql)) {
                ps.setInt(1, catId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int dishId = rs.getInt("DishID");
                        // Reuse existing method
                        if (!dishDAO.deleteDishById(dishId)) {
                            conn.rollback();
                            return false;
                        }
                    }
                }
            }

            // Step 2: Delete the category itself
            int affectedRows;
            try (PreparedStatement ps2 = conn.prepareStatement(deleteCategorySql)) {
                ps2.setInt(1, catId);
                affectedRows = ps2.executeUpdate();
            }

            conn.commit(); // Commit if everything is successful
            return affectedRows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                conn.rollback(); // Rollback on failure
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        return false;
    }
}
