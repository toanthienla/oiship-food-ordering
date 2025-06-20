/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import utils.DBContext;

/**
 *
 * @author Phi Yen
 */
public class CustomerProfileDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(CustomerDAO.class.getName());

    public CustomerProfileDAO() {
        super();
    }

    public Customer getCustomerByEmail(String email) {
        LOGGER.info("Attempting to retrieve customer with email: " + email);

        if (email == null || email.trim().isEmpty()) {
            LOGGER.warning("Invalid email: " + email);
            return null;
        }

        String sql = "SELECT a.accountID AS customerID, a.fullName, a.email, a.[password], "
                + "a.role, a.createAt, a.status, c.phone, c.address "
                + "FROM Account a JOIN Customer c ON a.accountID = c.customerID "
                + "WHERE a.email = ? AND a.role = 'customer'";

        try (
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Customer customer = new Customer(
                            rs.getInt("customerID"),
                            rs.getString("fullName"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getString("role"),
                            rs.getTimestamp("createAt"),
                            rs.getInt("status"),
                            rs.getString("phone"),
                            rs.getString("address")
                    );
                    LOGGER.info("Customer found: " + customer.getFullName());
                    return customer;
                } else {
                    LOGGER.warning("No customer found for email: " + email);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving customer by email: " + e.getMessage(), e);
        }

        return null;
    }

   public boolean editCustomerInfoByEmail(String email, String newName, String newPhone, String newAddress) {
    if (email == null || email.trim().isEmpty() ||
        newName == null || newName.trim().isEmpty() ||
        newPhone == null || newPhone.trim().isEmpty() ||
        newAddress == null || newAddress.trim().isEmpty()) {

        LOGGER.warning("Invalid input: email=" + email + ", name=" + newName + ", phone=" + newPhone + ", address=" + newAddress);
        return false;
    }

    String getAccountIdSQL = "SELECT accountID FROM Account WHERE email = ? AND role = 'customer'";
    String updateAccountSQL = "UPDATE Account SET fullName = ? WHERE accountID = ?";
    String updateCustomerSQL = "UPDATE Customer SET phone = ?, address = ? WHERE customerID = ?";

    try (Connection conn = getConnection();
         PreparedStatement getIdStmt = conn.prepareStatement(getAccountIdSQL)) {

        getIdStmt.setString(1, email);
        ResultSet rs = getIdStmt.executeQuery();

        if (rs.next()) {
            int accountId = rs.getInt("accountID");

            conn.setAutoCommit(false); // bắt đầu transaction

            try (
                PreparedStatement accountStmt = conn.prepareStatement(updateAccountSQL);
                PreparedStatement customerStmt = conn.prepareStatement(updateCustomerSQL)
            ) {
                // Cập nhật Account
                accountStmt.setString(1, newName);
                accountStmt.setInt(2, accountId);
                int rowsAccount = accountStmt.executeUpdate();

                // Cập nhật Customer
                customerStmt.setString(1, newPhone);
                customerStmt.setString(2, newAddress);
                customerStmt.setInt(3, accountId);
                int rowsCustomer = customerStmt.executeUpdate();

                if (rowsAccount > 0 && rowsCustomer > 0) {
                    conn.commit();
                    LOGGER.info("Customer info updated successfully for email: " + email);
                    return true;
                } else {
                    conn.rollback();
                    LOGGER.warning("Update failed for customer with email: " + email);
                }
            } catch (SQLException e) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Error during customer info update transaction: " + e.getMessage(), e);
            } finally {
                conn.setAutoCommit(true);
            }

        } else {
            LOGGER.warning("No account found with email: " + email);
        }

    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Connection error while updating customer info: " + e.getMessage(), e);
    }

    return false;
}

   public boolean changePasswordCustomerByEmail(String email, String newPassword) {
    if (email == null || email.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
        LOGGER.warning("Invalid email or newPassword: email=" + email + ", newPassword=" + newPassword);
        return false;
    }

    String sql = "UPDATE Account SET [password] = ? WHERE email = ? AND role = 'customer'";
    String hashedPassword = SecurityDAO.hashPassword(newPassword); // Hàm hashPassword từ lớp SecurityDAO

    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, hashedPassword);
        ps.setString(2, email);
        int rowsAffected = ps.executeUpdate();

        if (rowsAffected > 0) {
            LOGGER.info("Customer password updated successfully for email: " + email);
            return true;
        } else {
            LOGGER.warning("No customer found or no update for email: " + email);
        }
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error updating customer password for email: " + e.getMessage(), e);
    }

    return false;
}



}
