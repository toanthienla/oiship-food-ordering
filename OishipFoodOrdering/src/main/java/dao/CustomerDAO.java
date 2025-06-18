package dao;

import model.Customer;
import model.Account;
import model.Staff;
import utils.DBContext;
import java.sql.*;

public class CustomerDAO extends DBContext {

    public CustomerDAO() {
        super();
    }

    public Object login(String email, String plainPassword) {
        if (email == null || plainPassword == null) {
            System.out.println("login: email or plainPassword is null, email=" + email);
            return null;
        }
        String sql = "SELECT a.accountID, a.fullName, a.email, a.[password], a.status, a.role, a.createAt, " +
                     "c.phone, c.address " +
                     "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID " +
                     "WHERE a.email = ? AND a.status = 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    if (SecurityDAO.checkPassword(plainPassword, hashedPassword)) {
                        String role = rs.getString("role");
                        if ("customer".equals(role)) {
                            return new Customer(
                                    rs.getInt("accountID"),
                                    rs.getString("phone") != null ? rs.getString("phone") : "",
                                    rs.getString("address") != null ? rs.getString("address") : ""
                            );
                        } else if ("staff".equals(role)) {
                            return new Staff(
                                    rs.getInt("accountID"),
                                    rs.getString("fullName"),
                                    rs.getString("email"),
                                    hashedPassword,
                                    rs.getInt("status"),
                                    role,
                                    rs.getTimestamp("createAt")
                            );
                        } else if ("admin".equals(role)) {
                            return new Account(
                                    rs.getInt("accountID"),
                                    rs.getString("fullName"),
                                    rs.getString("email"),
                                    hashedPassword,
                                    rs.getInt("status"),
                                    role,
                                    rs.getTimestamp("createAt")
                            );
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error during login for email: " + email + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Customer getCustomerByEmail(String email) {
        if (email == null) {
            System.out.println("getCustomerByEmail: email is null");
            return null;
        }
        String sql = "SELECT a.accountID AS customerID, c.phone, c.address " +
                     "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID " +
                     "WHERE a.email = ? AND a.role = 'customer'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("customerID"),
                            rs.getString("phone") != null ? rs.getString("phone") : "",
                            rs.getString("address") != null ? rs.getString("address") : ""
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving customer by email: " + email + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertCustomer(Customer customer, String fullName, String email, String hashedPassword) {
        if (customer == null || customer.getPhone() == null || customer.getAddress() == null ||
            fullName == null || email == null || hashedPassword == null) {
            System.out.println("insertCustomer: Customer or required fields are null");
            return false;
        }

        String accountSql = "INSERT INTO Account (fullName, email, [password], role, createAt, status) VALUES (?, ?, ?, ?, ?, ?)";
        String customerSql = "INSERT INTO Customer (customerID, phone, address) VALUES (?, ?, ?)";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Insert into Account
            int customerID;
            try (PreparedStatement psAccount = conn.prepareStatement(accountSql, Statement.RETURN_GENERATED_KEYS)) {
                psAccount.setString(1, fullName);
                psAccount.setString(2, email);
                psAccount.setString(3, hashedPassword);
                psAccount.setString(4, "customer");
                psAccount.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                psAccount.setInt(6, 1);
                int accountRows = psAccount.executeUpdate();
                if (accountRows == 0) {
                    conn.rollback();
                    return false;
                }

                try (ResultSet rs = psAccount.getGeneratedKeys()) {
                    if (rs.next()) {
                        customerID = rs.getInt(1);
                        customer.setCustomerID(customerID); // Update customerID
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            // Insert into Customer
            try (PreparedStatement psCustomer = conn.prepareStatement(customerSql)) {
                psCustomer.setInt(1, customerID);
                psCustomer.setString(2, customer.getPhone());
                psCustomer.setString(3, customer.getAddress());
                int customerRows = psCustomer.executeUpdate();
                if (customerRows > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error inserting customer: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.out.println("Error rolling back: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    public boolean updateCustomer(Customer customer) {
        if (customer == null || customer.getCustomerID() <= 0 || customer.getPhone() == null || customer.getAddress() == null) {
            System.out.println("updateCustomer: Customer, customerID, or required fields are invalid");
            return false;
        }

        String customerSql = "UPDATE Customer SET phone = ?, address = ? WHERE customerID = ?";

        try (Connection conn = getConnection(); PreparedStatement psCustomer = conn.prepareStatement(customerSql)) {
            psCustomer.setString(1, customer.getPhone());
            psCustomer.setString(2, customer.getAddress());
            psCustomer.setInt(3, customer.getCustomerID());
            int customerRows = psCustomer.executeUpdate();
            return customerRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCustomer(int customerID) {
        if (customerID <= 0) {
            System.out.println("deleteCustomer: Invalid customerID: " + customerID);
            return false;
        }

        String customerSql = "DELETE FROM Customer WHERE customerID = ?";
        String accountSql = "DELETE FROM Account WHERE accountID = ? AND role = 'customer'";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Delete from Customer
            try (PreparedStatement psCustomer = conn.prepareStatement(customerSql)) {
                psCustomer.setInt(1, customerID);
                int customerRows = psCustomer.executeUpdate();
                if (customerRows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // Delete from Account
            try (PreparedStatement psAccount = conn.prepareStatement(accountSql)) {
                psAccount.setInt(1, customerID);
                int accountRows = psAccount.executeUpdate();
                if (accountRows > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error deleting customer: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.out.println("Error rolling back: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
}