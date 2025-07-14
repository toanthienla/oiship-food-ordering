package dao;

import model.ChartData;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TotalChartDAO {

    private Connection getConnection() throws SQLException {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=Oiship;encrypt=true;trustServerCertificate=true";
        return DriverManager.getConnection(url, "sa", "123456");
    }

    public List<ChartData> getOrderStats() {
        List<ChartData> stats = new ArrayList<>();
        String sql = "SELECT FORMAT(orderCreatedAt, 'MM/yyyy') AS month, COUNT(*) AS count "
                + "FROM [Order] "
                + "WHERE orderStatus IN (1, 3, 4) "
                + "GROUP BY FORMAT(orderCreatedAt, 'MM/yyyy') "
                + "ORDER BY month ASC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ChartData data = new ChartData(rs.getString("month"), rs.getInt("count"));
                stats.add(data);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching order stats: " + e.getMessage());
        }
        return stats;
    }

    public List<ChartData> getDishStats() {
        List<ChartData> stats = new ArrayList<>();
        String sql = "SELECT FORMAT(o.orderCreatedAt, 'MM/yyyy') AS month, SUM(od.quantity) AS count "
                + "FROM [Order] o "
                + "JOIN OrderDetail od ON o.orderID = od.FK_OD_Order "
                + "WHERE o.orderStatus IN (1, 3, 4) "
                + "GROUP BY FORMAT(o.orderCreatedAt, 'MM/yyyy') "
                + "ORDER BY month ASC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ChartData data = new ChartData(rs.getString("month"), rs.getInt("count"));
                stats.add(data);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching dish stats: " + e.getMessage());
        }
        return stats;
    }

    public List<ChartData> getPaymentStats() {
        List<ChartData> stats = new ArrayList<>();
        String sql = "SELECT FORMAT(p.PaymentTime, 'MM/yyyy') AS month, SUM(p.AmountPaid) AS amount "
                + "FROM Payment p "
                + "JOIN [Order] o ON o.orderID = p.OrderID "
                + "WHERE o.orderStatus IN (1, 3, 4) "
                + "GROUP BY FORMAT(p.PaymentTime, 'MM/yyyy') "
                + "ORDER BY month ASC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ChartData data = new ChartData(rs.getString("month"), rs.getInt("amount"));
                stats.add(data);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching payment stats: " + e.getMessage());
        }
        return stats;
    }

    public List<ChartData> getTotalStats() {
        List<ChartData> stats = new ArrayList<>();
        String sql = "SELECT FORMAT(o.orderCreatedAt, 'MM/yyyy') AS month, "
                + "SUM(ISNULL(od.quantity, 0) * ISNULL(d.opCost, 0) * (1 + ISNULL(d.interestPercentage, 0)/100)) + ISNULL(SUM(p.AmountPaid), 0) AS total "
                + "FROM [Order] o "
                + "LEFT JOIN OrderDetail od ON o.orderID = od.FK_OD_Order "
                + "LEFT JOIN Dish d ON od.FK_OD_Dish = d.DishID "
                + "LEFT JOIN Payment p ON o.orderID = p.OrderID "
                + "WHERE o.orderStatus IN (1, 3, 4) "
                + "GROUP BY FORMAT(o.orderCreatedAt, 'MM/yyyy') "
                + "ORDER BY month ASC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ChartData data = new ChartData(rs.getString("month"), (int) rs.getDouble("total"));
                stats.add(data);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching total stats: " + e.getMessage());
        }
        return stats;
    }
}
