package dao;

import model.Customer;
import model.Account;
import model.Staff;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO extends DBContext {

    public AccountDAO() {
        super();
    }

    // ===================== AUTHENTICATION =====================
    public Object login(String email, String plainPassword) {
        if (email == null || plainPassword == null) {
            System.out.println("login: email or plainPassword is null, email=" + email);
            return null;
        }

        String sql = "SELECT a.accountID, a.fullName, a.email, a.[password], a.status, a.role, a.createAt, "
                + "c.phone, c.address "
                + "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID "
                + "WHERE a.email = ? AND a.status = 1";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    if (SecurityDAO.checkPassword(plainPassword, hashedPassword)) {
                        String role = rs.getString("role");
                        switch (role) {
                            case "customer":
                                return new Customer(
                                        rs.getInt("accountID"),
                                        rs.getString("phone") != null ? rs.getString("phone") : "",
                                        rs.getString("address") != null ? rs.getString("address") : ""
                                );
                            case "staff":
                                return new Staff(
                                        rs.getInt("accountID"),
                                        rs.getString("fullName"),
                                        rs.getString("email"),
                                        hashedPassword,
                                        rs.getInt("status"),
                                        role,
                                        rs.getTimestamp("createAt")
                                );
                            case "admin":
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

    // ===================== CREATE =====================
    public int insertAccount(Account account) {
        if (account == null || account.getFullName() == null || account.getEmail() == null
                || account.getPassword() == null || account.getRole() == null) {
            System.out.println("insertAccount: Account or required fields are null");
            return -1;
        }

        String sql = "INSERT INTO Account (fullName, email, [password], role, createAt, status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, account.getFullName());
            ps.setString(2, account.getEmail());
            ps.setString(3, account.getPassword());
            ps.setString(4, account.getRole());
            ps.setTimestamp(5, account.getCreateAt() != null ? account.getCreateAt() : new Timestamp(System.currentTimeMillis()));
            ps.setInt(6, account.getStatus());

            int affected = ps.executeUpdate();
            if (affected == 0) {
                return -1;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int accountId = rs.getInt(1);
                    account.setAccountID(accountId);

                    if ("customer".equals(account.getRole())) {
                        String sqlCustomer = "INSERT INTO Customer (customerID, phone, address) VALUES (?, ?, ?)";
                        try (PreparedStatement psCustomer = conn.prepareStatement(sqlCustomer)) {
                            psCustomer.setInt(1, accountId);
                            psCustomer.setString(2, "");
                            psCustomer.setString(3, "");
                            psCustomer.executeUpdate();
                        }
                    }

                    return accountId;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error inserting account: " + e.getMessage());
            e.printStackTrace();
        }

        return -1;
    }

    public int insertAnonymousCustomerAndReturnCustomerID(String fullName) {
        String sqlAccount = "INSERT INTO Account (fullName, email) OUTPUT INSERTED.accountID VALUES (?, ?)";
        String sqlCustomer = "INSERT INTO Customer (customerID) VALUES (?)";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            String fakeEmail = "anon_" + System.currentTimeMillis() + "@anon.com";

            try (PreparedStatement ps = conn.prepareStatement(sqlAccount)) {
                ps.setString(1, fullName);
                ps.setString(2, fakeEmail);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int accountId = rs.getInt("accountID");

                        try (PreparedStatement psCustomer = conn.prepareStatement(sqlCustomer)) {
                            psCustomer.setInt(1, accountId);
                            psCustomer.executeUpdate();
                        }

                        conn.commit();
                        return accountId;
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    public boolean isEmailOrPhoneExists(String email, String phone) {
        if (email == null && phone == null) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID "
                + "WHERE a.email = ? OR c.phone = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email != null ? email : "");
            ps.setString(2, phone != null ? phone : "");
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking email or phone existence: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ===================== READ =====================
    public Account findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }

        String sql = "SELECT * FROM Account WHERE email = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAccount(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public Account getAccountById(int accountId) {
        if (accountId <= 0) {
            return null;
        }

        String sql = "SELECT a.accountID, a.fullName, a.email, a.[password], a.status, a.role, a.createAt, "
                + "c.phone, c.address "
                + "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID "
                + "WHERE a.accountID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAccount(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public Customer getCustomerByEmail(String email) {
        if (email == null) {
            return null;
        }

        String sql = "SELECT a.accountID AS customerID, c.phone, c.address "
                + "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID "
                + "WHERE a.email = ? AND a.role = 'customer'";

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
            e.printStackTrace();
        }

        return null;
    }

    public List<Account> getAllCustomers() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT a.*, c.phone, c.address "
                + "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID "
                + "WHERE a.role = 'customer' ORDER BY a.accountID";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToAccount(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Account> getAllStaff() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM Account WHERE role = 'staff' ORDER BY accountID";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToAccount(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Account> searchAccounts(String role, String searchTerm) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM Account WHERE role = ? AND (fullName LIKE ? OR email LIKE ?) ORDER BY accountID";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            stmt.setString(2, "%" + searchTerm + "%");
            stmt.setString(3, "%" + searchTerm + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    accounts.add(mapResultSetToAccount(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return accounts;
    }

    // ===================== UPDATE =====================
    public boolean updatePasswordByEmail(String email, String role, String hashedPassword) {
        if (email == null || hashedPassword == null) {
            return false;
        }

        String sql = "UPDATE Account SET [password] = ? WHERE email = ?";
        if (role != null) {
            sql += " AND role = ?";
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            if (role != null) {
                ps.setString(3, role);
            }

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateStatus(int accountId, int status) {
        if (accountId <= 0 || (status != 0 && status != 1 && status != 2)) {
            return false;
        }

        String sql = "UPDATE Account SET status = ? WHERE accountID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateAccount(Account account, String department, int accessLevel, String phone, String address, String shippingPreferences) {
        if (account == null || account.getAccountID() <= 0) {
            return false;
        }

        String sqlAccount = "UPDATE Account SET fullName = ?, status = ?, role = ?, createAt = ? WHERE accountID = ?";

        try (Connection conn = getConnection(); PreparedStatement psAccount = conn.prepareStatement(sqlAccount)) {
            psAccount.setString(1, account.getFullName());
            psAccount.setInt(2, account.getStatus());
            psAccount.setString(3, account.getRole());
            psAccount.setTimestamp(4, account.getCreateAt());
            psAccount.setInt(5, account.getAccountID());

            int affectedAccount = psAccount.executeUpdate();

            if ("staff".equals(account.getRole())) {
                String sqlStaff = "UPDATE Staff SET department = ?, accessLevel = ? WHERE staffID = ?";
                try (PreparedStatement psStaff = conn.prepareStatement(sqlStaff)) {
                    psStaff.setString(1, department);
                    psStaff.setInt(2, accessLevel);
                    psStaff.setInt(3, account.getAccountID());
                    return affectedAccount > 0 && psStaff.executeUpdate() > 0;
                }
            } else if ("customer".equals(account.getRole())) {
                String sqlCustomer = "UPDATE Customer SET phone = ?, address = ?, shippingPreferences = ? WHERE customerID = ?";
                try (PreparedStatement psCustomer = conn.prepareStatement(sqlCustomer)) {
                    psCustomer.setString(1, phone);
                    psCustomer.setString(2, address);
                    psCustomer.setString(3, shippingPreferences);
                    psCustomer.setInt(4, account.getAccountID());
                    return affectedAccount > 0 && psCustomer.executeUpdate() > 0;
                }
            }

            return affectedAccount > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== DELETE =====================
    public boolean deleteAccount(int id) {
        if (id <= 0) {
            return false;
        }

        String sql = "DELETE FROM Account WHERE accountID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== HELPER =====================
    private Account mapResultSetToAccount(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setAccountID(rs.getInt("accountID"));
        account.setFullName(rs.getString("fullName"));
        account.setEmail(rs.getString("email"));
        account.setPassword(rs.getString("password"));
        account.setStatus(rs.getInt("status"));
        account.setRole(rs.getString("role"));
        account.setCreateAt(rs.getTimestamp("createAt"));

        if ("customer".equals(account.getRole())) {
            Customer customer = new Customer();
            customer.setCustomerID(account.getAccountID());
            customer.setPhone(rs.getString("phone") != null ? rs.getString("phone") : "");
            customer.setAddress(rs.getString("address") != null ? rs.getString("address") : "");
            account.setCustomer(customer);
        }

        return account;
    }

    // ===================== TEST =====================
    public static void main(String[] args) {
        AccountDAO dao = new AccountDAO();
        String name = "Nguyễn Văn A";
        int id = dao.insertAnonymousCustomerAndReturnCustomerID(name);
        if (id != -1) {
            System.out.println("✅ Anonymous customer inserted. ID: " + id);
        } else {
            System.out.println("❌ Failed to insert anonymous customer.");
        }
    }
}
