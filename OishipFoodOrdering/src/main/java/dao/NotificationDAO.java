package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Notification;
import utils.DBContext;

public class NotificationDAO extends DBContext {

    public List<Notification> getAllNotifications() {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notification";
        try (PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new Notification(
                        rs.getInt("notID"),
                        rs.getString("notTitle"),
                        rs.getString("notDescription"),
                        rs.getInt("FK_Notification_Account")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addNotification(Notification noti) {
        String insertNotificationSQL = "INSERT INTO Notification (notTitle, notDescription, FK_Notification_Account) VALUES (?, ?, ?)";
        String insertCustomerNotificationSQL
                = "INSERT INTO CustomerNotification (customerID, notID) "
                + "SELECT c.customerID, ? FROM Customer c";

        try (
                PreparedStatement st1 = conn.prepareStatement(insertNotificationSQL, Statement.RETURN_GENERATED_KEYS);) {
            st1.setString(1, noti.getNotTitle());
            st1.setString(2, noti.getNotDescription());
            st1.setInt(3, noti.getAccountID());

            int rows = st1.executeUpdate();
            if (rows == 0) {
                return false;
            }

            // Get the generated notID
            ResultSet generatedKeys = st1.getGeneratedKeys();
            if (generatedKeys.next()) {
                int newNotID = generatedKeys.getInt(1);

                // Now insert into CustomertNotification
                try (PreparedStatement st2 = conn.prepareStatement(insertCustomerNotificationSQL)) {
                    st2.setInt(1, newNotID);
                    st2.executeUpdate(); // no need to check rows, since 0 customers is still valid
                }

                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteNotification(int id) {
        String deleteCustomerNotiSQL = "DELETE FROM CustomerNotification WHERE notID = ?";
        String deleteNotiSQL = "DELETE FROM Notification WHERE notID = ?";
        try {
            conn.setAutoCommit(false); // Start transaction

            try (PreparedStatement st1 = conn.prepareStatement(deleteCustomerNotiSQL); PreparedStatement st2 = conn.prepareStatement(deleteNotiSQL)) {

                st1.setInt(1, id);
                st1.executeUpdate();

                st2.setInt(1, id);
                boolean result = st2.executeUpdate() > 0;

                conn.commit(); // Commit both deletions
                return result;
            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean updateNotification(Notification noti) {
        String sql = "UPDATE Notification SET notTitle = ?, notDescription = ? WHERE notID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, noti.getNotTitle());
            stmt.setString(2, noti.getNotDescription());
            stmt.setInt(3, noti.getNotID());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Notification> getUnreadNotificationsByCustomer(int customerID) {
        List<Notification> list = new ArrayList<>();
        String sql = " SELECT n.*\n"
                + "        FROM Notification n\n"
                + "        JOIN CustomerNotification cn ON n.notID = cn.notID\n"
                + "        WHERE cn.customerID = ? AND cn.isRead = 0\n"
                + "        ORDER BY n.notID DESC ";

        try (
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Notification noti = new Notification();
                noti.setNotID(rs.getInt("notID"));
                noti.setNotTitle(rs.getString("notTitle"));
                noti.setNotDescription(rs.getString("notDescription"));
                noti.setAccountID(rs.getInt("FK_Notification_Account"));
                list.add(noti);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean markAsRead(int customerID, int notID) {
        String sql = "UPDATE CustomerNotification SET isRead = 1 WHERE customerID = ? AND notID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("Executing markAsRead - customerID: " + customerID + ", notID: " + notID); // Debug log

            ps.setInt(1, customerID);
            ps.setInt(2, notID);

            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected); // Debug log

            return rowsAffected > 0;

        } catch (Exception e) {
            System.out.println("Error in markAsRead: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
