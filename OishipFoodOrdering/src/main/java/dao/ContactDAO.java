package dao;

import model.Contact;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Customer;

public class ContactDAO extends DBContext {

    public List<Contact> getAllContacts() {
        List<Contact> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    c.contactID,\n"
                + "    c.subject,\n"
                + "    c.message,\n"
                + "    c.createAt,\n"
                + "    a.accountID AS customerID,\n"
                + "    a.fullName,\n"
                + "    a.email,\n"
                + "    a.password,\n"
                + "    a.role,\n"
                + "    a.status,\n"
                + "    a.createAt AS accountCreatedAt,\n"
                + "    cu.phone,\n"
                + "    cu.address\n"
                + "FROM Contact c\n"
                + "JOIN Customer cu ON c.FK_Contact_Customer = cu.customerID\n"
                + "JOIN Account a ON cu.customerID = a.accountID";

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customer customer = new Customer(
                        rs.getInt("customerID"),
                        rs.getString("fullName"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getTimestamp("accountCreatedAt"),
                        rs.getInt("status"), // Moved here from Account
                        rs.getString("phone"),
                        rs.getString("address")
                );

                Contact contact = new Contact();
                contact.setContactID(rs.getInt("contactID"));
                contact.setSubject(rs.getString("subject"));
                contact.setMessage(rs.getString("message"));
                contact.setCreateAt(rs.getTimestamp("createAt"));
                contact.setCustomer(customer);

                list.add(contact);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
