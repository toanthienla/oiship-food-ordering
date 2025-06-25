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
                + // Confirmed, Out for Delivery, Delivered
                "GROUP BY FORMAT(orderCreatedAt, 'MM/yyyy') "
                + "ORDER BY month ASC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ChartData data = new ChartData(rs.getString("month"), rs.getInt("count"));
                stats.add(data);
                System.out.println("OrderStats: month=" + data.getLabel() + ", count=" + data.getValue());
            }
        } catch (SQLException e) {
            System.err.println("Error fetching order stats: " + e.getMessage());
        }
        System.out.println("OrderStats size: " + stats.size());
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
                System.out.println("DishStats: month=" + data.getLabel() + ", count=" + data.getValue());
            }
        } catch (SQLException e) {
            System.err.println("Error fetching dish stats: " + e.getMessage());
        }
        System.out.println("DishStats size: " + stats.size());
        return stats;
    }

    public List<ChartData> getPaymentStats() {
        List<ChartData> stats = new ArrayList<>();
        String sql = "SELECT FORMAT(o.orderCreatedAt, 'MM/yyyy') AS month, SUM(p.paymentAmount) AS amount "
                + "FROM [Order] o "
                + "JOIN Payment p ON o.orderID = p.FK_Payment_Order "
                + "WHERE o.orderStatus IN (1, 3, 4) "
                + "GROUP BY FORMAT(o.orderCreatedAt, 'MM/yyyy') "
                + "ORDER BY month ASC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ChartData data = new ChartData(rs.getString("month"), rs.getInt("amount"));
                stats.add(data);
                System.out.println("PaymentStats: month=" + data.getLabel() + ", amount=" + data.getValue());
            }
        } catch (SQLException e) {
            System.err.println("Error fetching payment stats: " + e.getMessage());
        }
        System.out.println("PaymentStats size: " + stats.size());
        return stats;
    }

    public List<ChartData> getTotalStats() {
        List<ChartData> stats = new ArrayList<>();
        String sql = "SELECT FORMAT(o.orderCreatedAt, 'MM/yyyy') AS month, "
                + "COALESCE(SUM(o.count), 0) + COALESCE(SUM(od.quantity), 0) + COALESCE(SUM(p.paymentAmount), 0) AS total "
                + "FROM [Order] o "
                + "LEFT JOIN OrderDetail od ON o.orderID = od.FK_OD_Order "
                + "LEFT JOIN Payment p ON o.orderID = p.FK_Payment_Order "
                + "WHERE o.orderStatus IN (1, 3, 4) "
                + "GROUP BY FORMAT(o.orderCreatedAt, 'MM/yyyy') "
                + "ORDER BY month ASC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ChartData data = new ChartData(rs.getString("month"), rs.getInt("total"));
                stats.add(data);
                System.out.println("TotalStats: month=" + data.getLabel() + ", total=" + data.getValue());
            }
        } catch (SQLException e) {
            System.err.println("Error fetching total stats: " + e.getMessage());
        }
        System.out.println("TotalStats size: " + stats.size());
        return stats;
    }
}
