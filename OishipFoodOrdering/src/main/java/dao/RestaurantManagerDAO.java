package dao;

import model.RestaurantManager;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantManagerDAO extends DBContext {

    public List<RestaurantManager> getAllRestaurants() {
        List<RestaurantManager> list = new ArrayList<>();
        String sql = "SELECT * FROM RestaurantManager";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRestaurant(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public RestaurantManager getRestaurantById(int id) {
        String sql = "SELECT * FROM RestaurantManager WHERE restaurantmanager_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRestaurant(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insertRestaurantAndReturnId(RestaurantManager r) {
        String sql = "INSERT INTO RestaurantManager (name, email, phone, password, address, opening_hours, status_id, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, r.getName());
            stmt.setString(2, r.getEmail());
            stmt.setString(3, r.getPhone());
            stmt.setString(4, r.getPassword());
            stmt.setString(5, r.getAddress());
            stmt.setString(6, r.getOpeningHours()); // NULL nếu bạn muốn để trống
            stmt.setInt(7, r.getStatusId());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // ID mới được sinh ra
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error: " + e.getMessage());
        }
        return -1;
    }

    public boolean updateRestaurant(RestaurantManager r) {
        String sql = "UPDATE RestaurantManager SET name=?, phone=?, address=?, opening_hours=?, cuisine_type=?, status_id=? WHERE restaurantmanager_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, r.getName());
            stmt.setString(2, r.getPhone());
            stmt.setString(3, r.getAddress());
            stmt.setString(4, r.getOpeningHours());
            stmt.setString(5, r.getCuisineType());
            stmt.setInt(6, r.getStatusId());
            stmt.setInt(7, r.getRestaurantId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRestaurant(int id) {
        String sql = "DELETE FROM RestaurantManager WHERE restaurantmanager_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<RestaurantManager> getPendingRestaurants() {
        List<RestaurantManager> list = new ArrayList<>();
        String sql = "SELECT * FROM RestaurantManager WHERE status_id = 2";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRestaurant(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int id, int statusId) {
        String sql = "UPDATE RestaurantManager SET status_id = ? WHERE restaurantmanager_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, statusId);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private RestaurantManager mapRestaurant(ResultSet rs) throws SQLException {
        RestaurantManager r = new RestaurantManager();
        r.setRestaurantId(rs.getInt("restaurantmanager_id"));
        r.setName(rs.getString("name"));
        r.setEmail(rs.getString("email"));
        r.setPhone(rs.getString("phone"));
        r.setPassword(rs.getString("password"));
        r.setAddress(rs.getString("address"));
        r.setOpeningHours(rs.getString("opening_hours"));
        // r.setCuisineType(rs.getString("cuisine_type"));
        r.setStatusId(rs.getInt("status_id"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }

    public RestaurantManager getRestaurantByEmail(String email) {
        String sql = "SELECT * FROM RestaurantManager WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRestaurant(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isEmailOrPhoneExists(String email, String phone) {
        String sql = "SELECT 1 FROM RestaurantManager WHERE email = ? OR phone = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, phone);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        RestaurantManagerDAO dao = new RestaurantManagerDAO();
        List<RestaurantManager> list = dao.getAllRestaurants();
        System.out.println("✅ Total restaurants: " + list.size());
        for (RestaurantManager r : list) {
            System.out.println(r.getName() + " | " + r.getEmail());
        }
    }

}
