    package dao;

import model.Customer;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO extends DBContext {
    public boolean insertCustomer(Customer customer) {
        String sql = "INSERT INTO Customer (name, email, phone, password, address, status_id, created_at) VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customer.getName());
            stmt.setString(2, customer.getEmail());
            stmt.setString(3, customer.getPhone());
            stmt.setString(4, customer.getPassword());
            stmt.setString(5, customer.getAddress());
            stmt.setInt(6, customer.getStatusId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Insert Customer Error: " + e.getMessage());
        }
        return false;
    }

    public int insertCustomerAndReturnId(Customer customer) {
        String sql = "INSERT INTO Customer (name, email, phone, password, address, status_id, created_at) VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, customer.getName());
            stmt.setString(2, customer.getEmail());
            stmt.setString(3, customer.getPhone());
            stmt.setString(4, customer.getPassword());
            stmt.setString(5, customer.getAddress());
            stmt.setInt(6, customer.getStatusId());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Insert Customer and Return ID Error: " + e.getMessage());
        }
        return -1;
    }

    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE Customer SET name = ?, phone = ?, address = ?, status_id = ? WHERE customer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customer.getName());
            stmt.setString(2, customer.getPhone());
            stmt.setString(3, customer.getAddress());
            stmt.setInt(4, customer.getStatusId());
            stmt.setInt(5, customer.getCustomerId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update Customer Error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteCustomer(int customerId) {
        String sql = "DELETE FROM Customer WHERE customer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Delete Customer Error: " + e.getMessage());
        }
        return false;
    }

    public Customer getCustomerById(int customerId) {
        String sql = "SELECT * FROM Customer WHERE customer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractCustomer(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Get Customer By ID Error: " + e.getMessage());
        }
        return null;
    }

    public Customer getCustomerByEmail(String email) {
        String sql = "SELECT * FROM Customer WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractCustomer(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Get Customer By Email Error: " + e.getMessage());
        }
        return null;
    }

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(extractCustomer(rs));
            }
        } catch (SQLException e) {
            System.err.println("Get All Customers Error: " + e.getMessage());
        }
        return list;
    }

    public boolean isEmailOrPhoneExists(String email, String phone) {
        String sql = "SELECT 1 FROM Customer WHERE email = ? OR phone = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Check Email or Phone Exists Error: " + e.getMessage());
        }
        return false;
    }

    private Customer extractCustomer(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getInt("customer_id"));
        customer.setName(rs.getString("name"));
        customer.setEmail(rs.getString("email"));
        customer.setPhone(rs.getString("phone"));
        customer.setPassword(rs.getString("password"));
        customer.setAddress(rs.getString("address"));
        customer.setStatusId(rs.getInt("status_id"));
        customer.setCreatedAt(rs.getTimestamp("created_at"));
        return customer;
    }

    public boolean updateStatus(int customerId, int statusId) {
        String sql = "UPDATE Customer SET status_id = ? WHERE customer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, statusId);
            stmt.setInt(2, customerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }

}
