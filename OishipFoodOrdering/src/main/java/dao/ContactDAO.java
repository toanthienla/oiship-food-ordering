package dao;

import model.Contact;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO extends DBContext {

    public void insertContact(Contact contact) {
        String sql = "INSERT INTO Contact (contact_subject, contact_message, account_id) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, contact.getContactSubject());
            stmt.setString(2, contact.getContactMessage());
            stmt.setInt(3, contact.getAccountId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Contact> getAllContacts() {
        List<Contact> list = new ArrayList<>();
        String sql = "SELECT * FROM Contact";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Contact c = new Contact(
                        rs.getInt("contact_id"),
                        rs.getString("contact_subject"),
                        rs.getString("contact_message"),
                        rs.getInt("account_id")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteContact(int contactId) {
        String sql = "DELETE FROM Contact WHERE contact_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, contactId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Contact getContactById(int contactId) {
        String sql = "SELECT * FROM Contact WHERE contact_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, contactId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Contact(
                        rs.getInt("contact_id"),
                        rs.getString("contact_subject"),
                        rs.getString("contact_message"),
                        rs.getInt("account_id")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateContact(Contact contact) {
        String sql = "UPDATE Contact SET contact_subject = ?, contact_message = ?, account_id = ? WHERE contact_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, contact.getContactSubject());
            stmt.setString(2, contact.getContactMessage());
            stmt.setInt(3, contact.getAccountId());
            stmt.setInt(4, contact.getContactId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
