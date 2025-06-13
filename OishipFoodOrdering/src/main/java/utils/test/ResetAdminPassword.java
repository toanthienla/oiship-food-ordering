package utils.test;

import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

public class ResetAdminPassword {

    public static void main(String[] args) {
        String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=Oiship;encrypt=false";
        String username = "sa"; // Thay bằng username SQL Server của bạn
        String password = "123456"; // Thay bằng password SQL Server của bạn

        try (Connection conn = DriverManager.getConnection(dbURL, username, password)) {
            // Kết nối Database
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("✅ Connected to DB");

            // Reset admin
            resetAccount(conn, "oiship.team@gmail.com", "admin", "Admin", "admin", "0000000001");
            // Reset staff
            resetAccount(conn, "staff@example.com", "staff", "Staff", "staff", "0000000002");

        } catch (Exception e) {
            System.err.println("❌ Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void resetAccount(Connection conn, String email, String plainPassword, String fullName, String role, String phone) throws SQLException {
        // Băm mật khẩu
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
        System.out.println("🔒 [" + fullName + "] New Hash for '" + plainPassword + "': " + hashedPassword);

        // Thử update mật khẩu
        String updateSql = "UPDATE Account SET [password] = ? WHERE email = ?"; // Loại bỏ [status]
        try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
            stmt.setString(1, hashedPassword);
            stmt.setString(2, email);
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                System.out.println("✅ Cập nhật mật khẩu cho " + fullName + " thành công!");
                System.out.println("_____________________________________________________");
            } else {
                System.out.println("❌ Không tìm thấy tài khoản " + fullName + " với email: " + email + ". Tiến hành insert...");
                System.out.println("___________________________________________________________________________________________");

                // Insert tài khoản mới
                String insertSql = "INSERT INTO Account (fullName, email, phone, [password], [address], [status], [role], createAt) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setString(1, fullName);
                    insertStmt.setString(2, email);
                    insertStmt.setString(3, phone);
                    insertStmt.setString(4, hashedPassword);
                    insertStmt.setString(5, "No address provided"); // Giá trị mặc định nếu không có address
                    insertStmt.setInt(6, 1); // Status active
                    insertStmt.setString(7, role);
                    insertStmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));

                    int rowsInserted = insertStmt.executeUpdate();
                    if (rowsInserted > 0) {
                        System.out.println("✅ Insert tài khoản " + fullName + " thành công!");
                        System.out.println("_____________________________________________________");
                    } else {
                        System.out.println("❌ Insert tài khoản " + fullName + " thất bại!");
                        System.out.println("_____________________________________________________");
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi xử lý tài khoản " + fullName + ": " + e.getMessage());
            e.printStackTrace();
        }
    }
}