package dao;

import model.Staff;
import utils.DBContext;

import java.sql.*;

public class StaffDAO extends DBContext {

    public Staff getStaffById(int accountId) {
        String sql = "SELECT * FROM Staff WHERE staffId = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Staff staff = new Staff();
                staff.setStaffId(rs.getInt("staffId"));
                staff.setStaffType(rs.getString("staffType"));
                System.out.println("Found staff: staffId=" + accountId + ", staffType=" + staff.getStaffType());
                return staff;
            } else {
                System.out.println("No staff record found for accountId: " + accountId);
            }
        } catch (SQLException e) {
            System.out.println("Error in getStaffById for accountId: " + accountId);
            e.printStackTrace();
        }
        return null;
    }
}
