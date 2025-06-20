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
public class CustomerProfileDAO extends DBContext{
    
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

    String sql = "SELECT a.accountID AS customerID, a.fullName, a.email, a.[password], " +
                 "a.role, a.createAt, a.status, c.phone, c.address " +
                 "FROM Account a JOIN Customer c ON a.accountID = c.customerID " +
                 "WHERE a.email = ? AND a.role = 'customer'";

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


}
