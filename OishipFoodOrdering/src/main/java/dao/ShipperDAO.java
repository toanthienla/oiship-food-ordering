package dao;

import jakarta.servlet.http.Part;
import model.Shipper;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShipperDAO extends DBContext {

    public List<Shipper> getPendingShippers() {
        List<Shipper> list = new ArrayList<>();
        String sql = "SELECT * FROM Shipper WHERE status_id = 2";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapShipper(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Shipper> getAllShippers() {
        List<Shipper> list = new ArrayList<>();
        String sql = "SELECT * FROM Shipper";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapShipper(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Shipper getShipperById(int id) {
        String sql = "SELECT * FROM Shipper WHERE shipper_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapShipper(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertShipper(Shipper s) {
        String sql = "INSERT INTO Shipper (name, email, phone, password, cccd, driver_license, driver_license_image, address, vehicle_info, status_id, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, s.getName());
            stmt.setString(2, s.getEmail());
            stmt.setString(3, s.getPhone());
            stmt.setString(4, s.getPassword());
            stmt.setString(5, s.getCccd());
            stmt.setString(6, s.getDriverLicense());
            stmt.setBytes(7, s.getDriverLicenseImage());
            stmt.setString(8, s.getAddress());
            stmt.setString(9, s.getVehicleInfo());
            stmt.setInt(10, s.getStatusId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateShipper(Shipper s) {
        String sql = "UPDATE Shipper SET name=?, phone=?, address=?, vehicle_info=?, status_id=? WHERE shipper_id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, s.getName());
            stmt.setString(2, s.getPhone());
            stmt.setString(3, s.getAddress());
            stmt.setString(4, s.getVehicleInfo());
            stmt.setInt(5, s.getStatusId());
            stmt.setInt(6, s.getShipperId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteShipper(int id) {
        String sql = "DELETE FROM Shipper WHERE shipper_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int shipperId, int statusId) {
        String sql = "UPDATE Shipper SET status_id = ? WHERE shipper_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, statusId);
            stmt.setInt(2, shipperId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Shipper mapShipper(ResultSet rs) throws SQLException {
        Shipper s = new Shipper();
        s.setShipperId(rs.getInt("shipper_id"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setPhone(rs.getString("phone"));
        s.setPassword(rs.getString("password"));
        s.setCccd(rs.getString("cccd"));
        s.setDriverLicense(rs.getString("driver_license"));
        s.setDriverLicenseImage(rs.getBytes("driver_license_image"));
        s.setAddress(rs.getString("address"));
        s.setVehicleInfo(rs.getString("vehicle_info"));
        s.setStatusId(rs.getInt("status_id"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;

    }

    public Shipper getShipperByEmail(String email) {
        String sql = "SELECT * FROM Shipper WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapShipper(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insertShipperAndReturnId(Shipper shipper, Part licenseImage) {
        String sql = "INSERT INTO Shipper (name, email, phone, password, cccd, driver_license, driver_license_image, address, vehicle_info, status_id, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, shipper.getName());
            stmt.setString(2, shipper.getEmail());
            stmt.setString(3, shipper.getPhone());
            stmt.setString(4, shipper.getPassword());
            stmt.setString(5, shipper.getCccd());
            stmt.setString(6, shipper.getDriverLicense());

            // Đọc ảnh từ Part nếu có
            if (licenseImage != null && licenseImage.getSize() > 0) {
                byte[] imageBytes = licenseImage.getInputStream().readAllBytes();
                stmt.setBytes(7, imageBytes);
            } else {
                stmt.setNull(7, java.sql.Types.VARBINARY);
            }

            stmt.setString(8, shipper.getAddress());
            stmt.setString(9, shipper.getVehicleInfo() != null ? shipper.getVehicleInfo() : "N/A");
            stmt.setInt(10, shipper.getStatusId());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }

        } catch (Exception e) {
            System.err.println("Insert Shipper Error: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    public boolean isEmailOrPhoneExists(String email, String phone) {
        String sql = "SELECT 1 FROM Shipper WHERE email = ? OR phone = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, phone);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // Có kết quả tức là đã tồn tại
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
