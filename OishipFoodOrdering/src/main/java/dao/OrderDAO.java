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
import model.Ingredient;
import model.OrderDetail;
import utils.TotalPriceCalculator;

public class OrderDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    public OrderDAO() {
        super();
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, a.fullName AS customerName, c.address, "
                + "v.code AS voucherCode, v.discountType, v.discount, "
                + "lastUpdate.fullName AS lastUpdated "
                + "FROM [Order] o "
                + "JOIN Customer c ON o.FK_Order_Customer = c.customerID "
                + "JOIN Account a ON c.customerID = a.accountID "
                + "LEFT JOIN Voucher v ON o.FK_Order_Voucher = v.voucherID "
                + "OUTER APPLY ( "
                + "    SELECT TOP 1 acc.fullName "
                + "    FROM ( "
                + "        SELECT changedByAccountID, changeTime "
                + "        FROM OrderStatusHistory "
                + "        WHERE orderID = o.orderID "
                + "        UNION ALL "
                + "        SELECT changedByAccountID, changeTime "
                + "        FROM PaymentStatusHistory "
                + "        WHERE orderID = o.orderID "
                + "    ) combined "
                + "    JOIN Account acc ON combined.changedByAccountID = acc.accountID "
                + "    ORDER BY combined.changeTime DESC "
                + ") lastUpdate "
                + "ORDER BY o.orderCreatedAt DESC";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

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
                order.setAddress(rs.getString("address"));
                order.setVoucherCode(rs.getString("voucherCode"));
                order.setDiscountType(rs.getString("discountType"));
                order.setDiscount(rs.getBigDecimal("discount"));
                order.setLastUpdated(rs.getString("lastUpdated")); // nullable

                orders.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    public List<OrderDetail> getOrderDetailsByOrderID(int orderID) {
        List<OrderDetail> list = new ArrayList<>();

        String sql = "SELECT od.ODID, od.quantity, "
                + "d.DishID, d.DishName, d.DishDescription, d.image, d.opCost, d.interestPercentage, "
                + "o.orderStatus, o.paymentStatus, o.orderCreatedAt, o.orderUpdatedAt, o.amount, "
                + "c.customerID, a.fullName AS customerName, c.phone, c.address, "
                + "v.code AS voucherCode, v.discount, v.discountType "
                + "FROM OrderDetail od "
                + "JOIN Dish d ON od.FK_OD_Dish = d.DishID "
                + "JOIN [Order] o ON od.FK_OD_Order = o.orderID "
                + "JOIN Customer c ON o.FK_Order_Customer = c.customerID "
                + "JOIN Account a ON c.customerID = a.accountID "
                + "LEFT JOIN Voucher v ON o.FK_Order_Voucher = v.voucherID "
                + "WHERE o.orderID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();

            IngredientDAO ingredientDAO = new IngredientDAO();

            while (rs.next()) {
                OrderDetail detail = new OrderDetail();

                int dishID = rs.getInt("DishID");
                int quantity = rs.getInt("quantity");

                detail.setODID(rs.getInt("ODID"));
                detail.setQuantity(quantity);
                detail.setDishName(rs.getString("DishName"));
                detail.setDishDescription(rs.getString("DishDescription"));
                detail.setDishImage(rs.getString("image"));
                detail.setOrderStatus(rs.getInt("orderStatus"));
                detail.setPaymentStatus(rs.getInt("paymentStatus"));
                detail.setCreateAt(rs.getTimestamp("orderCreatedAt"));
                detail.setUpdateAt(rs.getTimestamp("orderUpdatedAt"));
                detail.setCustomerName(rs.getString("customerName"));
                detail.setPhone(rs.getString("phone"));
                detail.setAddress(rs.getString("address"));
                detail.setOrderId(orderID);
                detail.setVoucherCode(rs.getString("voucherCode"));
                detail.setDiscount(rs.getBigDecimal("discount"));
                detail.setDiscountType(rs.getString("discountType"));
                detail.setAmount(rs.getBigDecimal("amount"));

                // Tính đơn giá
                BigDecimal opCost = rs.getBigDecimal("opCost");
                BigDecimal interestPercentage = rs.getBigDecimal("interestPercentage");
                List<Ingredient> ingredients = ingredientDAO.getIngredientsByDishId(dishID);
                BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(ingredients);
                BigDecimal unitPrice = TotalPriceCalculator.calculateTotalPrice(opCost, interestPercentage,
                        ingredientCost);

                detail.setUnitPrice(unitPrice);

                list.add(detail);
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
        return -1;
    }

    public boolean updateStatusOrderByOrderId(int orderId, int newOrderStatus, int changedByAccountID) {
        String updateSql = "UPDATE [Order] SET orderStatus = ?, orderUpdatedAt = GETDATE() WHERE orderID = ?";
        String logSql = "INSERT INTO OrderStatusHistory (orderID, oldStatus, newStatus, changedByAccountID, changeTime) VALUES (?, ?, ?, ?, GETDATE())";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Lấy trạng thái cũ
            int oldStatus = -1;
            String selectSql = "SELECT orderStatus FROM [Order] WHERE orderID = ?";
            try (PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
                psSelect.setInt(1, orderId);
                ResultSet rs = psSelect.executeQuery();
                if (rs.next()) {
                    oldStatus = rs.getInt("orderStatus");
                } else {
                    return false; // Không tìm thấy đơn
                }
            }

            // Cập nhật trạng thái mới
            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                psUpdate.setInt(1, newOrderStatus);
                psUpdate.setInt(2, orderId);
                psUpdate.executeUpdate();
            }

            // Lưu vào lịch sử
            try (PreparedStatement psLog = conn.prepareStatement(logSql)) {
                psLog.setInt(1, orderId);
                psLog.setInt(2, oldStatus);
                psLog.setInt(3, newOrderStatus);
                psLog.setInt(4, changedByAccountID);
                psLog.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public int insertAnonymousCustomer(String fullName) {
        int generatedID = -1;
        String sql = "INSERT INTO Account(fullName) VALUES (?)";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, fullName);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedID = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedID;
    }

    // Các method cần cho staff tạo order
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

    // public int createOrder(int customerId, BigDecimal amount) throws SQLException
    // {
    // String sql = "INSERT INTO [Order] (amount, orderStatus, paymentStatus,
    // FK_Order_Customer) VALUES (?, 0, 0, ?)";
    // try (
    // PreparedStatement ps = conn.prepareStatement(sql,
    // Statement.RETURN_GENERATED_KEYS)) {
    // ps.setBigDecimal(1, amount);
    // ps.setInt(2, customerId);
    // ps.executeUpdate();
    // ResultSet rs = ps.getGeneratedKeys();
    // if (rs.next()) {
    // return rs.getInt(1);
    // }
    // }
    // return -1;
    // }
    public int createOrder(int customerId, BigDecimal amount, Integer voucherID) {
        String sql = "INSERT INTO [Order](amount, orderStatus, FK_Order_Customer, FK_Order_Voucher) VALUES (?, 0, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setBigDecimal(1, amount);
            ps.setInt(2, customerId);
            if (voucherID != null) {
                ps.setInt(3, voucherID);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
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

    public List<Order> getAllOrdersWithDetailsByCustomerId(int customerId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT orderID, orderCreatedAt, amount, orderStatus, paymentStatus "
                + "FROM [Order] WHERE FK_Order_Customer = ? ORDER BY orderCreatedAt DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("orderID"));
                order.setOrderCreatedAt(rs.getTimestamp("orderCreatedAt"));
                order.setAmount(rs.getBigDecimal("amount"));
                order.setOrderStatus(rs.getInt("orderStatus"));
                order.setPaymentStatus(rs.getInt("paymentStatus"));
                List<OrderDetail> details = getOrderDetailsByOrderId(order.getOrderID());
                order.setOrderDetails(details);

                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT od.ODID, od.quantity, d.DishName, d.image AS DishImage, "
                + "CASE WHEN r.ReviewID IS NOT NULL THEN 1 ELSE 0 END AS isReviewed "
                + "FROM OrderDetail od "
                + "JOIN Dish d ON od.FK_OD_Dish = d.DishID "
                + "LEFT JOIN Review r ON r.FK_Review_OrderDetail = od.ODID "
                + "WHERE od.FK_OD_Order = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setODID(rs.getInt("ODID"));
                detail.setQuantity(rs.getInt("quantity"));

                Dish dish = new Dish();
                dish.setDishName(rs.getString("DishName"));
                dish.setImage(rs.getString("DishImage"));
                detail.setDish(dish);

                boolean isReviewed = rs.getInt("isReviewed") == 1;
                detail.setReviewed(isReviewed);

                details.add(detail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return details;
    }

    public boolean cancelOrder(int orderId) throws SQLException {
        String sql = "UPDATE [Order] SET orderStatus = 5 WHERE orderID = ? AND orderStatus = 0"; // 5 = Hủy
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    public boolean updateOrderAmount(int orderID, BigDecimal amount) {
        String sql = "UPDATE [Order] SET amount = ? WHERE orderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, amount);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // for staff
    public int getPaymentStatusByOrderId(int orderID) {
        String sql = "SELECT paymentStatus FROM [Order] WHERE orderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("paymentStatus");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu không tìm thấy hoặc lỗi
    }

    public boolean updatePaymentStatusByOrderId(int orderId, int newPaymentStatus, int changedByAccountID) {
        String updateSql = "UPDATE [Order] SET paymentStatus = ?, orderUpdatedAt = GETDATE() WHERE orderID = ?";
        String logSql = "INSERT INTO PaymentStatusHistory (orderID, oldStatus, newStatus, changedByAccountID, changeTime) VALUES (?, ?, ?, ?, GETDATE())";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Lấy trạng thái cũ
            int oldStatus = -1;
            String selectSql = "SELECT paymentStatus FROM [Order] WHERE orderID = ?";
            try (PreparedStatement psSelect = conn.prepareStatement(selectSql)) {
                psSelect.setInt(1, orderId);
                ResultSet rs = psSelect.executeQuery();
                if (rs.next()) {
                    oldStatus = rs.getInt("paymentStatus");
                } else {
                    return false; // Không tìm thấy đơn
                }
            }

            // Cập nhật trạng thái mới
            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                psUpdate.setInt(1, newPaymentStatus);
                psUpdate.setInt(2, orderId);
                psUpdate.executeUpdate();
            }

            // Lưu vào lịch sử
            try (PreparedStatement psLog = conn.prepareStatement(logSql)) {
                psLog.setInt(1, orderId);
                psLog.setInt(2, oldStatus);
                psLog.setInt(3, newPaymentStatus);
                psLog.setInt(4, changedByAccountID);
                psLog.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // public static void main(String[] args) {
    //
    // OrderDAO dao = new OrderDAO();
    //
    // int testOrderId = 51; // 👉 thay bằng orderID thật có trong DB
    // int newPaymentStatus = 2; // 👉 0 = Unpaid, 1 = Paid, 2 = Refunded
    //
    // // 1. Trước khi cập nhật
    // int oldStatus = dao.getPaymentStatusByOrderId(testOrderId);
    // System.out.println("Old Payment Status: " + oldStatus);
    //
    // // 2. Cập nhật
    // boolean updated = dao.updatePaymentStatusByOrderId(testOrderId,
    // newPaymentStatus);
    // System.out.println(updated ? "✅ Payment status updated successfully." : "❌
    // Update failed.");
    //
    // // 3. Kiểm tra lại
    // int updatedStatus = dao.getPaymentStatusByOrderId(testOrderId);
    // System.out.println("New Payment Status: " + updatedStatus);
    // }
    // Payment
    public Order findById(int orderId) {
        String sql = "SELECT * FROM [Order] WHERE orderID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrder(rs);
                }
            }

        } catch (SQLException e) {
            logger.error("Error finding Order by ID: " + orderId, e);
        }

        return null;
    }

    public boolean updatePaymentStatus(int orderId, int paymentStatus) {
        String sql = "UPDATE [Order] SET paymentStatus = ? WHERE orderID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, paymentStatus);
            ps.setInt(2, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // ✅ Trả về true nếu update thành công

        } catch (SQLException e) {
            throw new RuntimeException("Failed to update order payment status", e);
        }
    }

    public Order findUnpaidOrderByCustomerId(int customerId) {
        String sql = "SELECT TOP 1 * FROM [Order] WHERE FK_Order_Customer = ? AND paymentStatus = 0 ORDER BY orderCreatedAt DESC";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrder(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding unpaid Order by CustomerID: {}", customerId, e);
        }

        return null;
    }

    public static void main(String[] args) {
        // // Tạo đối tượng DAO
        // OrderDAO dao = new OrderDAO();
        //
        // // Nhập ID khách hàng cần kiểm tra
        // int testCustomerId = 16; // Thay bằng ID thực tế trong DB
        //
        // // Gọi phương thức để lấy đơn hàng chưa thanh toán
        // Order unpaidOrder = dao.findUnpaidOrderByCustomerId(testCustomerId);
        //
        // // In kết quả
        // if (unpaidOrder != null) {
        // System.out.println("===== FOUND UNPAID ORDER =====");
        // System.out.println("Order ID : " + unpaidOrder.getOrderID());
        // System.out.println("Customer ID : " + unpaidOrder.getCustomerID());
        // System.out.println("Amount : " + unpaidOrder.getAmount());
        // System.out.println("Order Status : " + unpaidOrder.getOrderStatus());
        // System.out.println("Payment Status : " + unpaidOrder.getPaymentStatus());
        // System.out.println("Created At : " + unpaidOrder.getOrderCreatedAt());
        // System.out.println("Updated At : " + unpaidOrder.getOrderUpdatedAt());
        // System.out.println("Address : " + unpaidOrder.getAddress());
        // System.out.println("Discount Type : " + unpaidOrder.getDiscountType());
        // System.out.println("Discount : " + unpaidOrder.getDiscount());
        // System.out.println("Voucher Code : " + unpaidOrder.getVoucherCode());
        // System.out.println("Checkout URL : " + unpaidOrder.getCheckoutUrl());
        // } else {
        // System.out.println("No unpaid order found for customer ID: " +
        // testCustomerId);
        // }
        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getAllOrders();

        for (Order order : orders) {
            System.out.println("Order ID: " + order.getOrderID());
            System.out.println("Customer Name: " + order.getCustomerName());
            System.out.println("Address: " + order.getAddress());
            System.out.println("Amount: " + order.getAmount());
            System.out.println("Order Status: " + order.getOrderStatus());
            System.out.println("Payment Status: " + order.getPaymentStatus());
            System.out.println("Voucher Code: " + order.getVoucherCode());
            System.out.println("Discount: " + order.getDiscount());
            System.out.println("Last Updated By: " + order.getLastUpdated());
            System.out.println("=======================================");

        }

    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderID(rs.getInt("orderID"));
        order.setAmount(rs.getBigDecimal("amount"));
        order.setOrderStatus(rs.getInt("orderStatus"));
        order.setPaymentStatus(rs.getInt("paymentStatus"));
        order.setOrderCreatedAt(rs.getTimestamp("orderCreatedAt"));
        order.setOrderUpdatedAt(rs.getTimestamp("orderUpdatedAt"));
        order.setVoucherID(rs.getInt("FK_Order_Voucher")); // foreign key, may be null
        order.setCustomerID(rs.getInt("FK_Order_Customer"));
        order.setCheckoutUrl(rs.getString("checkoutUrl"));
        return order;
    }

    // Logger nếu chưa có
    private static final org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(OrderDAO.class);

    public Order getOrderById(int orderId) {
        Order order = null;
        String sql = "SELECT * FROM [Order] WHERE orderID = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setOrderID(rs.getInt("orderID"));
                    order.setAmount(rs.getBigDecimal("amount"));
                    order.setOrderStatus(rs.getInt("orderStatus"));
                    order.setPaymentStatus(rs.getInt("paymentStatus"));
                    order.setOrderCreatedAt(rs.getTimestamp("orderCreatedAt"));
                    order.setOrderUpdatedAt(rs.getTimestamp("orderUpdatedAt"));
                    order.setCheckoutUrl(rs.getString("getCheckoutUrl"));
                    order.setVoucherID(rs.getInt("voucherID"));
                    order.setCustomerID(rs.getInt("customerID"));
                    order.setAddress(rs.getString("address"));
                    // Nếu cần, có thể join để lấy thêm customerName, voucherCode...
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    public int createPendingOrder(int customerId, int amount) throws SQLException {
        int orderId = -1;
        String sql = "INSERT INTO [Order] (FK_Order_Customer, amount, paymentStatus, createdAt) "
                + "OUTPUT INSERTED.orderID VALUES (?, ?, 0, GETDATE())";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ps.setInt(2, amount);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
        }
        return orderId;
    }

    public void updateCheckoutUrl(int orderId, String url) throws SQLException {
        String sql = "UPDATE [Order] SET checkoutUrl = ? WHERE orderID = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, url);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        }
    }

    public String getCheckoutUrl(int orderId) {
        String sql = "SELECT checkoutUrl FROM [Order] WHERE orderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("checkoutUrl");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving checkout URL from database.", e);
        }
        return null;

    }

    // public int createOrder(Order order, Integer voucherID) throws SQLException {
    // String sql = "INSERT INTO [Order] (amount, orderStatus, paymentStatus,
    // orderCreatedAt, orderUpdatedAt, FK_Order_Customer, FK_Order_Voucher) "
    // + "VALUES (?, ?, ?, GETDATE(), GETDATE(), ?, ?)";
    //
    // try (Connection conn = getConnection(); PreparedStatement ps =
    // conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
    //
    // ps.setBigDecimal(1, order.getAmount());
    // ps.setInt(2, order.getOrderStatus());
    // ps.setInt(3, order.getPaymentStatus());
    // ps.setInt(4, order.getCustomerID());
    //
    // if (voucherID != null) {
    // ps.setInt(5, voucherID);
    // } else {
    // ps.setNull(5, Types.INTEGER);
    // }
    //
    // ps.executeUpdate();
    //
    // try (ResultSet rs = ps.getGeneratedKeys()) {
    // if (rs.next()) {
    // return rs.getInt(1);
    // }
    // }
    // }
    // return -1;
    // }
}
