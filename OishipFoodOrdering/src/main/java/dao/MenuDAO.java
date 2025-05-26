package dao;

import model.Menu;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO extends DBContext {

    public List<Menu> getAllMenus() {
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT * FROM Menu";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Menu menu = new Menu(
                    rs.getInt("menu_id"),
                    rs.getBoolean("available"),
                    rs.getString("category"),
                    rs.getInt("restaurant_manager_id")
                );
                list.add(menu);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Menu getMenuById(int menuId) {
        String sql = "SELECT * FROM Menu WHERE menu_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, menuId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Menu(
                    rs.getInt("menu_id"),
                    rs.getBoolean("available"),
                    rs.getString("category"),
                    rs.getInt("restaurant_manager_id")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertMenu(Menu menu) {
        String sql = "INSERT INTO Menu (available, category, restaurant_manager_id) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, menu.isAvailable());
            stmt.setString(2, menu.getCategory());
            stmt.setInt(3, menu.getRestaurantManagerId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateMenu(Menu menu) {
        String sql = "UPDATE Menu SET available = ?, category = ?, restaurant_manager_id = ? WHERE menu_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, menu.isAvailable());
            stmt.setString(2, menu.getCategory());
            stmt.setInt(3, menu.getRestaurantManagerId());
            stmt.setInt(4, menu.getMenuId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteMenu(int menuId) {
        String sql = "DELETE FROM Menu WHERE menu_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, menuId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
