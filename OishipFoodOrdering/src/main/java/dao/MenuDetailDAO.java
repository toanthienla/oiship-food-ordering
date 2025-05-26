package dao;

import model.MenuDetail;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuDetailDAO extends DBContext {

    public List<MenuDetail> getAllMenuDetails() {
        List<MenuDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM MenuDetail";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                MenuDetail m = new MenuDetail(
                        rs.getInt("menu_detail_id"),
                        rs.getString("menu_detail_name"),
                        rs.getBigDecimal("price"),
                        rs.getString("image"),
                        rs.getString("menu_description"),
                        rs.getBoolean("is_available"),
                        rs.getInt("restaurant_manager_id"),
                        rs.getInt("menu_id")
                );
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public MenuDetail getMenuDetailById(int id) {
        String sql = "SELECT * FROM MenuDetail WHERE menu_detail_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new MenuDetail(
                        rs.getInt("menu_detail_id"),
                        rs.getString("menu_detail_name"),
                        rs.getBigDecimal("price"),
                        rs.getString("image"),
                        rs.getString("menu_description"),
                        rs.getBoolean("is_available"),
                        rs.getInt("restaurant_manager_id"),
                        rs.getInt("menu_id")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertMenuDetail(MenuDetail m) {
        String sql = "INSERT INTO MenuDetail (menu_detail_name, price, image, menu_description, is_available, restaurant_manager_id, menu_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, m.getMenuDetailName());
            stmt.setBigDecimal(2, m.getPrice());
            stmt.setString(3, m.getImage());
            stmt.setString(4, m.getMenuDescription());
            stmt.setBoolean(5, m.isAvailable());
            stmt.setInt(6, m.getRestaurantManagerId());
            stmt.setInt(7, m.getMenuId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateMenuDetail(MenuDetail m) {
        String sql = "UPDATE MenuDetail SET menu_detail_name = ?, price = ?, image = ?, menu_description = ?, is_available = ?, restaurant_manager_id = ?, menu_id = ? WHERE menu_detail_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, m.getMenuDetailName());
            stmt.setBigDecimal(2, m.getPrice());
            stmt.setString(3, m.getImage());
            stmt.setString(4, m.getMenuDescription());
            stmt.setBoolean(5, m.isAvailable());
            stmt.setInt(6, m.getRestaurantManagerId());
            stmt.setInt(7, m.getMenuId());
            stmt.setInt(8, m.getMenuDetailId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteMenuDetail(int id) {
        String sql = "DELETE FROM MenuDetail WHERE menu_detail_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
