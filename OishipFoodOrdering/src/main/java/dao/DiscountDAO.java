package dao;

import model.Discount;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiscountDAO extends DBContext {

    public List<Discount> getAllDiscounts() {
        List<Discount> list = new ArrayList<>();
        String sql = "SELECT * FROM Discount";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRowToDiscount(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Discount getDiscountById(int id) {
        String sql = "SELECT * FROM Discount WHERE discount_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToDiscount(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Discount getDiscountByCode(String code) {
        String sql = "SELECT * FROM Discount WHERE discount_code = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToDiscount(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertDiscount(Discount d) {
        String sql = "INSERT INTO Discount (discount_code, discount_description, discount_type, amount, max_discount_value, min_order_value, start_date, end_date, usage_limit, used_count, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, d.getDiscountCode());
            stmt.setString(2, d.getDiscountDescription());
            stmt.setString(3, d.getDiscountType());
            stmt.setBigDecimal(4, d.getAmount());
            stmt.setBigDecimal(5, d.getMaxDiscountValue());
            stmt.setBigDecimal(6, d.getMinOrderValue());
            stmt.setTimestamp(7, Timestamp.valueOf(d.getStartDate()));
            stmt.setTimestamp(8, Timestamp.valueOf(d.getEndDate()));
            stmt.setInt(9, d.getUsageLimit());
            stmt.setInt(10, d.getUsedCount());
            stmt.setBoolean(11, d.isActive());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateDiscount(Discount d) {
        String sql = "UPDATE Discount SET discount_code = ?, discount_description = ?, discount_type = ?, amount = ?, max_discount_value = ?, min_order_value = ?, start_date = ?, end_date = ?, usage_limit = ?, used_count = ?, is_active = ? " +
                     "WHERE discount_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, d.getDiscountCode());
            stmt.setString(2, d.getDiscountDescription());
            stmt.setString(3, d.getDiscountType());
            stmt.setBigDecimal(4, d.getAmount());
            stmt.setBigDecimal(5, d.getMaxDiscountValue());
            stmt.setBigDecimal(6, d.getMinOrderValue());
            stmt.setTimestamp(7, Timestamp.valueOf(d.getStartDate()));
            stmt.setTimestamp(8, Timestamp.valueOf(d.getEndDate()));
            stmt.setInt(9, d.getUsageLimit());
            stmt.setInt(10, d.getUsedCount());
            stmt.setBoolean(11, d.isActive());
            stmt.setInt(12, d.getDiscountId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteDiscount(int discountId) {
        String sql = "DELETE FROM Discount WHERE discount_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, discountId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Discount mapRowToDiscount(ResultSet rs) throws SQLException {
        return new Discount(
                rs.getInt("discount_id"),
                rs.getString("discount_code"),
                rs.getString("discount_description"),
                rs.getString("discount_type"),
                rs.getBigDecimal("amount"),
                rs.getBigDecimal("max_discount_value"),
                rs.getBigDecimal("min_order_value"),
                rs.getTimestamp("start_date").toLocalDateTime(),
                rs.getTimestamp("end_date").toLocalDateTime(),
                rs.getInt("usage_limit"),
                rs.getInt("used_count"),
                rs.getBoolean("is_active")
        );
    }
}
