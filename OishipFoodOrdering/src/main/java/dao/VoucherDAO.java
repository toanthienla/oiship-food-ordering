package dao;

import model.Voucher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

public class VoucherDAO extends DBContext {

    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Voucher";

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Voucher v = new Voucher(
                        rs.getInt("voucherID"),
                        rs.getString("code"),
                        rs.getString("voucherDescription"),
                        rs.getBigDecimal("discount"),
                        rs.getBigDecimal("maxDiscountValue"),
                        rs.getBigDecimal("minOrderValue"),
                        rs.getTimestamp("startDate").toLocalDateTime(),
                        rs.getTimestamp("endDate").toLocalDateTime(),
                        rs.getInt("usageLimit"),
                        rs.getInt("usedCount"),
                        rs.getInt("active") == 1,
                        rs.getInt("FK_Voucher_Account")
                );
                list.add(v);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void addVoucher(Voucher v) {
        String sql = "INSERT INTO Voucher (code, voucherDescription, discount, maxDiscountValue, minOrderValue, startDate, endDate, usageLimit, active, FK_Voucher_Account) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, v.getCode());
            ps.setString(2, v.getVoucherDescription());
            ps.setBigDecimal(3, v.getDiscount());
            ps.setBigDecimal(4, v.getMaxDiscountValue());
            ps.setBigDecimal(5, v.getMinOrderValue());
            ps.setTimestamp(6, Timestamp.valueOf(v.getStartDate()));
            ps.setTimestamp(7, Timestamp.valueOf(v.getEndDate()));
            ps.setInt(8, v.getUsageLimit());
            ps.setInt(9, v.isActive() ? 1 : 0);
            ps.setInt(10, v.getAccountID());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteVoucher(int voucherID) {
        String sql = "DELETE FROM Voucher WHERE voucherID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateVoucher(Voucher v) {
        String sql = "UPDATE Voucher SET code = ?, voucherDescription = ?, discount = ?, maxDiscountValue = ?, "
                + "minOrderValue = ?, startDate = ?, endDate = ?, usageLimit = ?, usedCount = ?, active = ?, FK_Voucher_Account = ? WHERE voucherID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getVoucherDescription());
            ps.setBigDecimal(3, v.getDiscount());
            ps.setBigDecimal(4, v.getMaxDiscountValue());
            ps.setBigDecimal(5, v.getMinOrderValue());
            ps.setObject(6, v.getStartDate());
            ps.setObject(7, v.getEndDate());
            ps.setInt(8, v.getUsageLimit());
            ps.setInt(9, v.getUsedCount());
            ps.setBoolean(10, v.isActive());
            ps.setInt(11, v.getAccountID());
            ps.setInt(12, v.getVoucherID());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getUsedCountByVoucherId(int voucherId) {
        String sql = "SELECT usedCount FROM Voucher WHERE voucherID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("usedCount");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0; // Default to 0 if not found or on error
    }
}
