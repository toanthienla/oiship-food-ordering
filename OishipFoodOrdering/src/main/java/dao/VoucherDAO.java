package dao;

import java.math.BigDecimal;
import model.Voucher;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
                        rs.getString("discountType"),
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

    public List<Voucher> getAllActiveVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Voucher WHERE active = 1";

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Voucher v = new Voucher(
                        rs.getInt("voucherID"),
                        rs.getString("code"),
                        rs.getString("voucherDescription"),
                        rs.getString("discountType"),
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
        String sql = "INSERT INTO Voucher (code, voucherDescription, discountType, discount, maxDiscountValue, minOrderValue, startDate, endDate, usageLimit, active, FK_Voucher_Account) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getVoucherDescription());
            ps.setString(3, v.getDiscountType());
            ps.setBigDecimal(4, v.getDiscount());
            ps.setBigDecimal(5, v.getMaxDiscountValue());
            ps.setBigDecimal(6, v.getMinOrderValue());
            ps.setTimestamp(7, Timestamp.valueOf(v.getStartDate()));
            ps.setTimestamp(8, Timestamp.valueOf(v.getEndDate()));
            ps.setInt(9, v.getUsageLimit());
            ps.setInt(10, v.isActive() ? 1 : 0);
            ps.setInt(11, v.getAccountID());

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
        String sql = "UPDATE Voucher SET code = ?, voucherDescription = ?, discountType = ?, discount = ?, maxDiscountValue = ?, "
                + "minOrderValue = ?, startDate = ?, endDate = ?, usageLimit = ?, usedCount = ?, active = ?, FK_Voucher_Account = ? WHERE voucherID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getVoucherDescription());
            ps.setString(3, v.getDiscountType());
            ps.setBigDecimal(4, v.getDiscount());
            ps.setBigDecimal(5, v.getMaxDiscountValue());
            ps.setBigDecimal(6, v.getMinOrderValue());
            ps.setTimestamp(7, Timestamp.valueOf(v.getStartDate()));
            ps.setTimestamp(8, Timestamp.valueOf(v.getEndDate()));
            ps.setInt(9, v.getUsageLimit());
            ps.setInt(10, v.getUsedCount());
            ps.setInt(11, v.isActive() ? 1 : 0);
            ps.setInt(12, v.getAccountID());
            ps.setInt(13, v.getVoucherID());
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

        return 0;
    }

    public Voucher getVoucherByCode(String code) {
        String sql = "SELECT * FROM Voucher WHERE code = ?";
        Voucher voucher = null;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                voucher = new Voucher(
                        rs.getInt("voucherID"),
                        rs.getString("code"),
                        rs.getString("voucherDescription"),
                        rs.getString("discountType"),
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return voucher;
    }

    public Voucher findValidVoucher(String code, BigDecimal cartTotal) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public Voucher getValidVoucher(String code, BigDecimal orderTotal, int customerID) {
        String sql = "SELECT * FROM Voucher \n"
                + "        WHERE code = ? \n"
                + "          AND active = 1 \n"
                + "          AND GETDATE() BETWEEN startDate AND endDate \n"
                + "          AND usageLimit > usedCount \n"
                + "          AND minOrderValue <= ?\n"
                + "          AND voucherID IN (\n"
                + "              SELECT voucherID FROM CustomerVoucher WHERE customerID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setBigDecimal(2, orderTotal);
            ps.setInt(3, customerID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Voucher voucher = new Voucher();
                voucher.setVoucherID(rs.getInt("voucherID"));
                voucher.setCode(rs.getString("code"));
                voucher.setVoucherDescription(rs.getString("voucherDescription"));
                voucher.setDiscountType(rs.getString("discountType"));
                voucher.setDiscount(rs.getBigDecimal("discount"));
                voucher.setMaxDiscountValue(rs.getBigDecimal("maxDiscountValue"));
                voucher.setMinOrderValue(rs.getBigDecimal("minOrderValue"));
                voucher.setStartDate(rs.getTimestamp("startDate").toLocalDateTime());
                voucher.setEndDate(rs.getTimestamp("endDate").toLocalDateTime());
                voucher.setUsageLimit(rs.getInt("usageLimit"));
                voucher.setUsedCount(rs.getInt("usedCount"));
                voucher.setActive(rs.getInt("active") == 1); // Chuyển INT → boolean
                voucher.setAccountID(rs.getInt("FK_Voucher_Account"));
                return voucher;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public Voucher getVoucherById(int id) {
        String sql = "SELECT * FROM Voucher WHERE voucherID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Voucher voucher = new Voucher();
                voucher.setVoucherID(rs.getInt("voucherID"));
                voucher.setCode(rs.getString("code"));
                voucher.setVoucherDescription(rs.getString("voucherDescription"));
                voucher.setDiscountType(rs.getString("discountType"));
                voucher.setDiscount(rs.getBigDecimal("discount"));
                voucher.setMaxDiscountValue(rs.getBigDecimal("maxDiscountValue"));
                voucher.setMinOrderValue(rs.getBigDecimal("minOrderValue"));
                voucher.setStartDate(rs.getTimestamp("startDate").toLocalDateTime());
                voucher.setEndDate(rs.getTimestamp("endDate").toLocalDateTime());
                voucher.setUsageLimit(rs.getInt("usageLimit"));
                voucher.setUsedCount(rs.getInt("usedCount"));
                voucher.setActive(rs.getInt("active") == 1);
                voucher.setAccountID(rs.getInt("FK_Voucher_Account"));
                return voucher;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean hasCustomerUsedVoucher(int customerId, int voucherId) {
        String sql = "SELECT 1 FROM CustomerVoucher WHERE customerID = ? AND voucherID = ?";
        try (
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, voucherId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
