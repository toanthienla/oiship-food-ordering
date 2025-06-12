package dao;

import model.Category;
import utils.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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

    public boolean deleteCategoryById(int id) {
        String sql = "DELETE FROM Category WHERE catID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
