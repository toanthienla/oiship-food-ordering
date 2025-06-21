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

    // Login method
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

    // Get customer by email
    public Customer getCustomerByEmail(String email) {
        if (email == null) {
            System.out.println("getCustomerByEmail: email is null");
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
            System.out.println("Error retrieving customer by email: " + email + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public int addAccoountAtsffAndCustomer(Account account) {
        if (account == null || account.getFullName() == null || account.getEmail() == null
                || account.getPassword() == null || account.getRole() == null) {
            System.out.println("insertAccount: Account or required fields are null");
            return -1;
        }
        String sqlAccount = "INSERT INTO Account (fullName, email, [password], role, createAt, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement psAccount = conn.prepareStatement(sqlAccount, Statement.RETURN_GENERATED_KEYS)) {
            psAccount.setString(1, account.getFullName());
            psAccount.setString(2, account.getEmail());
            psAccount.setString(3, account.getPassword());
            psAccount.setString(4, account.getRole());
            psAccount.setTimestamp(5, account.getCreateAt() != null ? account.getCreateAt() : new Timestamp(System.currentTimeMillis()));
            psAccount.setInt(6, account.getStatus());

            int affectedRows = psAccount.executeUpdate();
            if (affectedRows == 0) {
                System.out.println("insertAccount: No rows affected for email: " + account.getEmail());
                return -1;
            }

            try (ResultSet rs = psAccount.getGeneratedKeys()) {
                if (rs.next()) {
                    int accountID = rs.getInt(1);
                    account.setAccountID(accountID);

                    // Insert into Customer table if role is "customer"
                    if ("customer".equals(account.getRole())) {
                        String sqlCustomer = "INSERT INTO Customer (customerID, phone, address) VALUES (?, ?, ?)";
                        try (PreparedStatement psCustomer = conn.prepareStatement(sqlCustomer)) {
                            psCustomer.setInt(1, accountID);
                            psCustomer.setString(2, ""); // Default phone
                            psCustomer.setString(3, ""); // Default address
                            psCustomer.executeUpdate();
                        }
                    }
                    return accountID;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error inserting account for email " + account.getEmail() + ": " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public int insertAccount(Account account) {
        if (account == null || account.getFullName() == null || account.getEmail() == null
                || account.getPassword() == null || account.getRole() == null) {
            System.out.println("insertAccount: Account or required fields are null");
            return -1;
        }
        String sqlAccount = "INSERT INTO Account (fullName, email, [password], role, createAt, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement psAccount = conn.prepareStatement(sqlAccount, Statement.RETURN_GENERATED_KEYS)) {
            psAccount.setString(1, account.getFullName());
            psAccount.setString(2, account.getEmail());
            psAccount.setString(3, account.getPassword());
            psAccount.setString(4, account.getRole());
            psAccount.setTimestamp(5, account.getCreateAt() != null ? account.getCreateAt() : new Timestamp(System.currentTimeMillis()));
            psAccount.setInt(6, account.getStatus());

            int affectedRows = psAccount.executeUpdate();
            if (affectedRows == 0) {
                System.out.println("insertAccount: No rows affected for email: " + account.getEmail());
                return -1;
            }

            try (ResultSet rs = psAccount.getGeneratedKeys()) {
                if (rs.next()) {
                    int accountID = rs.getInt(1);
                    account.setAccountID(accountID);

                    // Insert into Customer table if role is "customer"
                    if ("customer".equals(account.getRole())) {
                        String sqlCustomer = "INSERT INTO Customer (customerID, phone, address) VALUES (?, ?, ?)";
                        try (PreparedStatement psCustomer = conn.prepareStatement(sqlCustomer)) {
                            psCustomer.setInt(1, accountID);
                            psCustomer.setString(2, ""); // Default phone
                            psCustomer.setString(3, ""); // Default address
                            psCustomer.executeUpdate();
                        }
                    }
                    return accountID;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error inserting account for email " + account.getEmail() + ": " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // Update password by email
    public boolean updatePasswordByEmail(String email, String role, String hashedPassword) {
        if (email == null || hashedPassword == null) {
            System.out.println("updatePasswordByEmail: email or hashedPassword is null, email=" + email + ", role=" + role);
            return false;
        }
        if (role != null && !role.equals("admin") && !role.equals("staff") && !role.equals("customer")) {
            System.out.println("updatePasswordByEmail: Invalid role, role=" + role);
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
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating password for email: " + email + ", role: " + role + ": " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Check if email or phone exists
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

    public boolean updateStatus(int id, int status) {
        if (id <= 0) {
            System.out.println("updateStatus: Invalid ID");
            return false;
        }
        String sql = "UPDATE Account SET status = ? WHERE accountID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, id);

            int affectedRows = ps.executeUpdate();
            System.out.println("updateStatus: Updated status for accountID " + id + " to " + status + ", affected rows: " + affectedRows);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating status for accountID " + id + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Find account by email
    public Account findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            System.out.println("findByEmail: email is null or empty");
            return null;
        }
        String sql = "SELECT accountID, fullName, email, [password], status, role, createAt "
                + "FROM Account WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAccount(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving account by email: " + email + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Find account by ID
    public Account getAccountById(int accountID) {
        if (accountID <= 0) {
            System.out.println("getAccountById: Invalid accountID: " + accountID);
            return null;
        }
        String sql = "SELECT a.accountID, a.fullName, a.email, a.[password], a.status, a.role, a.createAt, "
                + "c.phone, c.address "
                + "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID "
                + "WHERE a.accountID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account account = new Account();
                    account.setAccountID(rs.getInt("accountID"));
                    account.setFullName(rs.getString("fullName"));
                    account.setEmail(rs.getString("email"));
                    account.setPassword(rs.getString("password"));
                    account.setStatus(rs.getInt("status"));
                    account.setRole(rs.getString("role"));
                    account.setCreateAt(rs.getTimestamp("createAt"));

                    // Populate Customer object if role is "customer" and data exists
                    if ("customer".equals(rs.getString("role"))) {
                        Customer customer = new Customer();
                        customer.setCustomerID(rs.getInt("accountID"));
                        String phone = rs.getString("phone");
                        String address = rs.getString("address");
                        customer.setPhone(phone != null ? phone : "");
                        customer.setAddress(address != null ? address : "");
                        account.setCustomer(customer);
                        System.out.println("DEBUG: Account ID: " + account.getAccountID() + ", Phone: " + (phone != null ? phone : "null") + ", Address: " + (address != null ? address : "null") + ", Time: 10:05 PM +07 Wed Jun 18 2025");
                    } else {
                        System.out.println("DEBUG: Account ID: " + account.getAccountID() + " is not a customer, Role: " + rs.getString("role") + ", Time: 10:05 PM +07 Wed Jun 18 2025");
                    }
                    return account;
                } else {
                    System.out.println("DEBUG: No account found for ID: " + accountID + ", Time: 10:05 PM +07 Wed Jun 18 2025");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving account by ID: " + accountID + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Search accounts by role and search term
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
            System.out.println("Error searching accounts for role " + role + " with term " + searchTerm + ": " + e.getMessage());
            e.printStackTrace();
        }
        return accounts;
    }

    public boolean updateAccount(Account account, String department, int accessLevel, String phone, String address, String shippingPreferences) {
        if (account == null || account.getAccountID() <= 0) {
            System.out.println("updateAccount: Invalid account or accountID: " + (account != null ? account.getAccountID() : "null"));
            return false;
        }
        String sqlAccount = "UPDATE Account SET fullName = ?, status = ?, role = ?, createAt = ? WHERE accountID = ?";
        try (Connection conn = getConnection(); PreparedStatement psAccount = conn.prepareStatement(sqlAccount)) {
            psAccount.setString(1, account.getFullName());
            psAccount.setInt(2, account.getStatus());
            psAccount.setString(3, account.getRole());
            psAccount.setTimestamp(4, account.getCreateAt());
            psAccount.setInt(5, account.getAccountID());
            int rowsAccount = psAccount.executeUpdate();

            if ("staff".equals(account.getRole()) && department != null) {
                String sqlStaff = "UPDATE Staff SET department = ?, accessLevel = ? WHERE staffID = ?";
                try (PreparedStatement psStaff = conn.prepareStatement(sqlStaff)) {
                    psStaff.setString(1, department);
                    psStaff.setInt(2, accessLevel);
                    psStaff.setInt(3, account.getAccountID());
                    int rowsStaff = psStaff.executeUpdate();
                    return rowsAccount > 0 && rowsStaff > 0;
                }
            } else if ("customer".equals(account.getRole()) && phone != null) {
                String sqlCustomer = "UPDATE Customer SET phone = ?, address = ?, shippingPreferences = ? WHERE customerID = ?";
                try (PreparedStatement psCustomer = conn.prepareStatement(sqlCustomer)) {
                    psCustomer.setString(1, phone);
                    psCustomer.setString(2, address);
                    psCustomer.setString(3, shippingPreferences);
                    psCustomer.setInt(4, account.getAccountID());
                    int rowsCustomer = psCustomer.executeUpdate();
                    return rowsAccount > 0 && rowsCustomer > 0;
                }
            }
            return rowsAccount > 0;
        } catch (SQLException e) {
            System.out.println("Error updating account ID " + account.getAccountID() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAccount(int id) {
        if (id <= 0) {
            System.out.println("deleteAccount: Invalid ID");
            return false;
        }

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Kiểm tra và xóa bản ghi trong Customer nếu là customer
            String checkCustomerSql = "SELECT role FROM Account WHERE accountID = ?";
            try (PreparedStatement psCheck = conn.prepareStatement(checkCustomerSql)) {
                psCheck.setInt(1, id);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next() && "customer".equals(rs.getString("role"))) {
                        String deleteCustomerSql = "DELETE FROM Customer WHERE customerID = ?";
                        try (PreparedStatement psCustomer = conn.prepareStatement(deleteCustomerSql)) {
                            psCustomer.setInt(1, id);
                            int customerRows = psCustomer.executeUpdate();
                            System.out.println("deleteAccount: Deleted " + customerRows + " rows from Customer for accountID " + id);
                        }
                    }
                }
            }

            // Xóa bản ghi trong Account
            String deleteAccountSql = "DELETE FROM Account WHERE accountID = ?";
            try (PreparedStatement psAccount = conn.prepareStatement(deleteAccountSql)) {
                psAccount.setInt(1, id);
                int affectedRows = psAccount.executeUpdate();
                System.out.println("deleteAccount: Deleted accountID " + id + ", affected rows: " + affectedRows);

                if (affectedRows > 0) {
                    conn.commit(); // Commit transaction nếu thành công
                    return true;
                } else {
                    conn.rollback(); // Rollback nếu không xóa được
                    System.out.println("deleteAccount: No rows affected for accountID " + id);
                    return false;
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException ex) {
                    System.out.println("Error during rollback: " + ex.getMessage());
                }
            }
            System.out.println("Error deleting account with ID " + id + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Khôi phục auto-commit
                    conn.close();
                } catch (SQLException e) {
                    System.out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }

    public Account findById(int accountID) {
        if (accountID <= 0) {
            System.out.println("findById: Invalid accountID: " + accountID);
            return null;
        }
        String sql = "SELECT a.accountID, a.fullName, a.email, a.[password], a.status, a.role, a.createAt, "
                + "c.phone, c.address "
                + "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID "
                + "WHERE a.accountID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account account = new Account();
                    account.setAccountID(rs.getInt("accountID"));
                    account.setFullName(rs.getString("fullName"));
                    account.setEmail(rs.getString("email"));
                    account.setPassword(rs.getString("password"));
                    account.setStatus(rs.getInt("status"));
                    account.setRole(rs.getString("role"));
                    account.setCreateAt(rs.getTimestamp("createAt"));

                    // Populate Customer object if role is "customer"
                    if ("customer".equals(rs.getString("role"))) {
                        Customer customer = new Customer();
                        customer.setCustomerID(rs.getInt("accountID"));
                        customer.setPhone(rs.getString("phone") != null ? rs.getString("phone") : "");
                        customer.setAddress(rs.getString("address") != null ? rs.getString("address") : "");
                        account.setCustomer(customer); // Assuming Account has a setCustomer method
                    }
                    return account;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving account by ID: " + accountID + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // ... (other methods remain unchanged)
    // Helper method to map ResultSet to Account object (updated)
    private Account mapResultSetToAccount(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setAccountID(rs.getInt("accountID"));
        account.setFullName(rs.getString("fullName"));
        account.setEmail(rs.getString("email"));
        account.setPassword(rs.getString("password"));
        account.setStatus(rs.getInt("status"));
        account.setRole(rs.getString("role"));
        account.setCreateAt(rs.getTimestamp("createAt"));

        // Populate Customer object if role is "customer"
        if ("customer".equals(rs.getString("role"))) {
            Customer customer = new Customer();
            customer.setCustomerID(rs.getInt("accountID"));
            customer.setPhone(rs.getString("phone") != null ? rs.getString("phone") : "");
            customer.setAddress(rs.getString("address") != null ? rs.getString("address") : "");
            account.setCustomer(customer); // Assuming Account has a setCustomer method
        }
        return account;
    }

    // Get all customers
    public List<Account> getAllCustomers() {
        List<Account> customers = new ArrayList<>();
        String sql = "SELECT a.accountID, a.fullName, a.email, a.[password], a.status, a.role, a.createAt, "
                + "c.phone, c.address "
                + "FROM Account a LEFT JOIN Customer c ON a.accountID = c.customerID "
                + "WHERE a.role = 'customer' ORDER BY a.accountID";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Account account = new Account();
                    account.setAccountID(rs.getInt("accountID"));
                    account.setFullName(rs.getString("fullName"));
                    account.setEmail(rs.getString("email"));
                    account.setPassword(rs.getString("password"));
                    account.setStatus(rs.getInt("status"));
                    account.setRole(rs.getString("role"));
                    account.setCreateAt(rs.getTimestamp("createAt"));

                    // Populate Customer object
                    Customer customer = new Customer();
                    customer.setCustomerID(rs.getInt("accountID"));
                    customer.setPhone(rs.getString("phone") != null ? rs.getString("phone") : "");
                    customer.setAddress(rs.getString("address") != null ? rs.getString("address") : "");
                    account.setCustomer(customer);

                    customers.add(account);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving all customers: " + e.getMessage());
            e.printStackTrace();
        }
        return customers;
    }

    // Get all staff
    public List<Account> getAllStaff() {
        List<Account> staffList = new ArrayList<>();
        String sql = "SELECT a.accountID, a.fullName, a.email, a.[password], a.status, a.role, a.createAt "
                + "FROM Account a "
                + "WHERE a.role = 'staff' ORDER BY a.accountID";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Account account = new Account();
                    account.setAccountID(rs.getInt("accountID"));
                    account.setFullName(rs.getString("fullName"));
                    account.setEmail(rs.getString("email"));
                    account.setPassword(rs.getString("password"));
                    account.setStatus(rs.getInt("status"));
                    account.setRole(rs.getString("role"));
                    account.setCreateAt(rs.getTimestamp("createAt"));

                    // Assuming Staff table exists with department and accessLevel
                    // If Staff table is not implemented, remove the following block
                    /*
                    Staff staff = new Staff();
                    staff.setAccountID(rs.getInt("accountID"));
                    staff.setDepartment(rs.getString("department") != null ? rs.getString("department") : "");
                    staff.setAccessLevel(rs.getInt("accessLevel"));
                    account.setStaff(staff); // Assuming setStaff method exists
                     */
                    staffList.add(account);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving all staff: " + e.getMessage());
            e.printStackTrace();
        }
        return staffList;
    }

    public boolean isCustomerExists(int customerID) {
        String sql = "SELECT COUNT(*) FROM Customer WHERE customerID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Trả về true nếu có bản ghi
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error checking Customer existence for ID: " + customerID + ", Time: " + new java.util.Date() + ", Error: " + e.getMessage());
        }
        return false; // Trả về false nếu có lỗi hoặc không tìm thấy
    }

    public boolean updateCustomer(Customer customer) {
        if (customer == null || customer.getCustomerID() <= 0 || customer.getPhone() == null || customer.getAddress() == null) {
            System.out.println("updateCustomer: Customer or required fields are null or invalid");
            return false;
        }

        // Kiểm tra xem bản ghi đã tồn tại chưa
        String checkSql = "SELECT COUNT(*) FROM Customer WHERE customerID = ?";
        try (Connection conn = getConnection(); PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
            psCheck.setInt(1, customer.getCustomerID());
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Bản ghi đã tồn tại, thực hiện UPDATE
                    String updateSql = "UPDATE Customer SET phone = ?, address = ? WHERE customerID = ?";
                    try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                        psUpdate.setString(1, customer.getPhone().trim());
                        psUpdate.setString(2, customer.getAddress().trim());
                        psUpdate.setInt(3, customer.getCustomerID());
                        int affectedRows = psUpdate.executeUpdate();
                        System.out.println("updateCustomer: Updated customerID " + customer.getCustomerID() + ", affected rows: " + affectedRows);
                        return affectedRows > 0;
                    }
                } else {
                    // Bản ghi không tồn tại, thực hiện INSERT
                    String insertSql = "INSERT INTO Customer (customerID, phone, address) VALUES (?, ?, ?)";
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                        psInsert.setInt(1, customer.getCustomerID());
                        psInsert.setString(2, customer.getPhone().trim());
                        psInsert.setString(3, customer.getAddress().trim());
                        int affectedRows = psInsert.executeUpdate();
                        System.out.println("updateCustomer: Inserted customerID " + customer.getCustomerID() + ", affected rows: " + affectedRows);
                        return affectedRows > 0;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error updating customer for ID " + customer.getCustomerID() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    


    public List<Account> getAccountsByStatus(String role, int status) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM Account WHERE role = ? AND status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setInt(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    accounts.add(mapAccount(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if ("customer".equals(role)) {
            // Lấy thông tin Customer nếu có
            for (Account account : accounts) {
                account.setCustomer(getCustomerById(account.getAccountID()));
            }
        }
        return accounts;
    }


    public List<Account> searchAccountsByStatus(String role, String keyword, int status) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM Account WHERE role = ? AND status = ? AND (fullName LIKE ? OR email LIKE ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setInt(2, status);
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    accounts.add(mapAccount(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        if ("customer".equals(role)) {
            // Lấy thông tin Customer nếu có
            for (Account account : accounts) {
                account.setCustomer(getCustomerById(account.getAccountID()));
            }
        }
        return accounts;
    }

    private Account mapAccount(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setAccountID(rs.getInt("accountID"));
        account.setFullName(rs.getString("fullName"));
        account.setEmail(rs.getString("email"));
        account.setPassword(rs.getString("password"));
        account.setStatus(rs.getInt("status"));
        account.setRole(rs.getString("role"));
        account.setCreateAt(rs.getTimestamp("createAt"));
        return account;
    }

    private Account mapAccountWithCustomer(ResultSet rs) throws SQLException {
        Account account = mapAccount(rs);
        account.setCustomer(new model.Customer(
            rs.getInt("customerID"),
            rs.getString("phone"),
            rs.getString("address")
        ));
        return account;
    }

    private model.Customer getCustomerById(int id) {
        // Giả định có phương thức riêng để lấy Customer
        String sql = "SELECT * FROM Customer WHERE customerID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new model.Customer(id, rs.getString("phone"), rs.getString("address"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


}
