package dao;

import java.math.BigDecimal;
import model.Order;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Dish;
import model.OrderDetail;

public class OrderDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    public OrderDAO() {
        super();
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, a.fullName AS customerName, v.code AS voucherCode "
                + "FROM [Order] o "
                + "JOIN Customer c ON o.FK_Order_Customer = c.customerID "
                + "JOIN Account a ON c.customerID = a.accountID "
                + "LEFT JOIN Voucher v ON o.FK_Order_Voucher = v.voucherID "
                + "ORDER BY o.orderCreatedAt DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("orderID"));
                order.setAmount(rs.getBigDecimal("amount"));
                order.setOrderStatus(rs.getInt("orderStatus"));
                order.setPaymentStatus(rs.getInt("paymentStatus"));
                order.setOrderCreatedAt(rs.getTimestamp("orderCreatedAt"));
                order.setOrderUpdatedAt(rs.getTimestamp("orderUpdatedAt"));
                order.setVoucherID(rs.getInt("FK_Order_Voucher"));
                order.setCustomerID(rs.getInt("FK_Order_Customer"));
                order.setCustomerName(rs.getString("customerName"));
                order.setVoucherCode(rs.getString("voucherCode"));

                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    //này dùng cho order detail, cẩn thận nhầm ODID và orderID nhé
    public List<OrderDetail> getOrderDetailsByOrderID(int orderID) {
        List<OrderDetail> list = new ArrayList<>();

        String sql = "SELECT od.ODID, od.quantity, "
                + "d.DishID, d.DishName, d.DishDescription, "
                + "o.orderStatus, o.orderCreatedAt, "
                + "c.customerID, a.fullName AS customerName "
                + "FROM OrderDetail od "
                + "JOIN Dish d ON od.FK_OD_Dish = d.DishID "
                + "JOIN [Order] o ON od.FK_OD_Order = o.orderID "
                + "JOIN Customer c ON o.FK_Order_Customer = c.customerID "
                + "JOIN Account a ON c.customerID = a.accountID "
                + "WHERE o.orderID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    detail.setODID(rs.getInt("ODID"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setDishName(rs.getString("DishName"));
                    detail.setDishDescription(rs.getString("DishDescription"));
                    detail.setOrderStatus(rs.getInt("orderStatus"));
                    detail.setCreateAt(rs.getTimestamp("orderCreatedAt"));
                    detail.setCustomerName(rs.getString("customerName"));
                    detail.setOrderId(orderID);
                    list.add(detail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getOrderStatusByOrderId(int orderID) {
        String sql = "SELECT orderStatus FROM [Order] WHERE orderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("orderStatus");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu không tìm thấy
    }

    public boolean updateStatusOrderByOrderId(int orderId, int newStatus) {
        String sql = "UPDATE [Order] SET orderStatus = ?, orderUpdatedAt = GETDATE() WHERE orderID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newStatus);
            ps.setInt(2, orderId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public int insertAnonymousCustomer(String fullName) {
        int generatedID = -1;
        String sql = "INSERT INTO Account(fullName) VALUES (?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, fullName);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedID = rs.getInt(1); // Lấy accountID vừa được tạo
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedID;
    }

    //Các method cần cho staff tạo order
    public int insertOrder(int customerID) {
        String sql = "INSERT INTO [Order] (FK_Order_Customer, orderStatus, paymentStatus, orderCreatedAt) "
                + "OUTPUT INSERTED.orderID VALUES (?, 1, 1, GETDATE())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("orderID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean insertOrderDetail(int orderID, int dishID, int quantity) {
        String sql = "INSERT INTO OrderDetail (FK_OD_Order, FK_OD_Dish, quantity) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            ps.setInt(2, dishID);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Failed to insert OrderDetail:");
            e.printStackTrace();
        }
        return false;
    }

    public int createOrder(int customerId, BigDecimal amount) throws SQLException {
        String sql = "INSERT INTO [Order] (amount, orderStatus, paymentStatus, FK_Order_Customer) VALUES (?, 0, 0, ?)";
        try (
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setBigDecimal(1, amount);
            ps.setInt(2, customerId);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    public void addOrderDetail(int orderId, int dishId, int quantity) throws SQLException {
        String sql = "INSERT INTO OrderDetail (quantity, FK_OD_Order, FK_OD_Dish) VALUES (?, ?, ?)";
        try (
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, orderId);
            ps.setInt(3, dishId);
            ps.executeUpdate();
        }
    }

//   public List<OrderDetail> getOrderHistoryByCustomerId(int customerId) {
//    List<OrderDetail> history = new ArrayList<>();
//    String sql = "SELECT "
//            + "o.orderCreatedAt, d.DishName, od.quantity, o.amount, d.DishImage "
//            + "FROM [Order] o "
//            + "JOIN OrderDetail od ON o.orderID = od.FK_OD_Order "
//            + "JOIN Dish d ON od.FK_OD_Dish = d.DishID "
//            + "WHERE o.FK_Order_Customer = ? "
//            + "ORDER BY o.orderCreatedAt DESC";
//
//    try (PreparedStatement ps = conn.prepareStatement(sql)) {
//        ps.setInt(1, customerId);
//        ResultSet rs = ps.executeQuery();
//        while (rs.next()) {
//            OrderDetail item = new OrderDetail();
//
//            // Set thông tin số lượng
//            item.setQuantity(rs.getInt("quantity"));
//
//            // Tạo và set Dish
//            Dish dish = new Dish();
//            dish.setDishName(rs.getString("DishName"));
//            dish.setImage(rs.getString("DishImage"));
//            item.setDish(dish);
//
//            // Tạo và set Order
//            Order order = new Order();
//            order.setAmount(rs.getBigDecimal("amount"));
//            order.setOrderCreatedAt(rs.getTimestamp("orderCreatedAt"));
//            item.setOrder(order);
//
//            // Thêm vào danh sách
//            history.add(item);
//        }
//    } catch (Exception e) {
//        e.printStackTrace();
//    }
//
//    return history;
//}

    
   public List<Object[]> getOrderHistoryByCustomerId(int customerId) {
    List<Object[]> history = new ArrayList<>();
    String sql = "SELECT o.orderCreatedAt, d.dishName, od.quantity, o.amount, d.DishImage " +
                 "FROM [Order] o " +
                 "JOIN OrderDetail od ON o.orderID = od.FK_OD_Order " +
                 "JOIN Dish d ON od.FK_OD_Dish = d.DishID " +
                 "WHERE o.FK_Order_Customer = ? " +
                 "ORDER BY o.orderCreatedAt DESC";

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Object[] row = new Object[5]; // Tăng lên 5 phần tử
            row[0] = rs.getTimestamp("orderCreatedAt");
            row[1] = rs.getString("dishName");
            row[2] = rs.getInt("quantity");
            row[3] = rs.getBigDecimal("amount");
            row[4] = rs.getString("DishImage"); // Thêm cột ảnh
            history.add(row);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return history;
}

    public static void main(String[] args) {
        //        OrderDAO dao = new OrderDAO();
        //        List<Order> orders = dao.getAllOrders();
        //
        //        if (orders.isEmpty()) {
        //            System.out.println("No orders found.");
        //        } else {
        //            for (Order order : orders) {
        //                System.out.println("Order ID: " + order.getOrderID());
        //                System.out.println("Customer ID: " + order.getCustomerID());
        //                System.out.println("Amount: " + order.getAmount());
        //                System.out.println("Order Status: " + order.getOrderStatus());
        //                System.out.println("Payment Status: " + order.getPaymentStatus());
        //                System.out.println("Created At: " + order.getOrderCreatedAt());
        //                System.out.println("Updated At: " + order.getOrderUpdatedAt());
        //                System.out.println("Voucher ID: " + order.getVoucherID());
        //                System.out.println("-----------");
        //            }
        //        }

        //        OrderDAO dao = new OrderDAO();
        //        int testOrderID = 1; // thay số này bằng orderID bạn muốn test (phải có trong DB)
        //
        //        List<OrderDetail> details = dao.getOrderDetailsByOrderID(testOrderID);
        //
        //        if (details.isEmpty()) {
        //            System.out.println("Không có dữ liệu cho orderID = " + testOrderID);
        //        } else {
        //            for (OrderDetail detail : details) {
        //                System.out.println("ODID: " + detail.getODID());
        //                System.out.println("Dish Name: " + detail.getDishName());
        //                System.out.println("Quantity: " + detail.getQuantity());
        //                System.out.println("Description: " + detail.getDishDescription());
        //                System.out.println("Order Status: " + detail.getOrderStatus());
        //                System.out.println("Customer Name: " + detail.getCustomerName());
        //                System.out.println("Created At: " + detail.getCreateAt());
        //                System.out.println("-----------------------------");
        //            }
        //        }
        //    }
        //        OrderDAO dao = new OrderDAO();
        //        List<Order> orders = dao.getAllOrders();
        //
        //        for (Order o : orders) {
        //            System.out.println("Order ID: " + o.getOrderID());
        //            System.out.println("Customer Name: " + o.getCustomerName());
        //            System.out.println("Voucher Code: " + o.getVoucherCode());
        //            System.out.println("Amount: " + o.getAmount());
        //            System.out.println("Order Status: " + o.getOrderStatus());
        //            System.out.println("Created At: " + o.getOrderCreatedAt());
        //            System.out.println("------");
        //        }
        //    }
        //        OrderDAO dao = new OrderDAO();
        //
        //        int testOrderId = 1;       // Thay bằng ID đơn hàng có thực trong DB
        //        int newStatus = 2;         // Ví dụ: 2 = Preparing
        //
        //        boolean result = dao.updateStatusOrderByOrderId(testOrderId, newStatus);
        //
        //        if (result) {
        //            System.out.println("✅ Update successful for OrderID = " + testOrderId);
        //        } else {
        //            System.out.println("❌ Update failed for OrderID = " + testOrderId);
        //        }
        //        OrderDAO dao = new OrderDAO();
        //
        //        int testOrderID = 1; // Thay bằng orderID có thật trong DB
        //        int status = dao.getOrderStatusByOrderId(testOrderID);
        //
        //        if (status != -1) {
        //            System.out.println("✅ Trạng thái của đơn hàng #" + testOrderID + " là: " + status);
        //        } else {
        //            System.out.println("❌ Không tìm thấy đơn hàng hoặc lỗi xảy ra.");
        //        }
        //    }
        OrderDAO dao = new OrderDAO();

        int orderID = 12;
        int dishID = 3;
        int quantity = 2;

        boolean success = dao.insertOrderDetail(orderID, dishID, quantity);

        if (success) {
            System.out.println("✅ Inserted OrderDetail successfully.");
        } else {
            System.out.println("❌ Failed to insert OrderDetail.");
        }
    }
}
