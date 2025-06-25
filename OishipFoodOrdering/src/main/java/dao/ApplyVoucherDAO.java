/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Voucher;
import utils.DBContext;

/**
 *
 * @author Phi Yen
 */
public class ApplyVoucherDAO extends DBContext {

   public Voucher getValidVoucher(String code, BigDecimal orderTotal) {
    String sql = "SELECT * FROM Voucher \n"
           + "WHERE code = ? \n"
           + "  AND active = 1 \n"
           + "  AND GETDATE() BETWEEN startDate AND endDate \n"
           + "  AND usageLimit > usedCount \n"
           + "  AND minOrderValue <= ?";

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, code);
        ps.setBigDecimal(2, orderTotal); // ✅ chỉ 2 tham số

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
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return null;
}




    public void increaseUsedCount(int voucherID) {
        String sql = "UPDATE Voucher SET usedCount = usedCount + 1 WHERE voucherID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isVoucherUsable(String code, BigDecimal orderTotal) {
        return getValidVoucher(code, orderTotal) != null;
    }

}
