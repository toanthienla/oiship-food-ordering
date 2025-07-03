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
                + "v.code AS voucherCode, v.discountType, v.discount "
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
                order.setAddress(rs.getString("address"));
                order.setVoucherCode(rs.getString("voucherCode"));
                order.setDiscountType(rs.getString("discountType"));
                order.setDiscount(rs.getBigDecimal("discount"));

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
                BigDecimal unitPrice = TotalPriceCalculator.calculateTotalPrice(opCost, interestPercentage, ingredientCost);

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
                    generatedID = rs.getInt(1); 
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

//    public int createOrder(int customerId, BigDecimal amount) throws SQLException {
//        String sql = "INSERT INTO [Order] (amount, orderStatus, paymentStatus, FK_Order_Customer) VALUES (?, 0, 0, ?)";
//        try (
//                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//            ps.setBigDecimal(1, amount);
//            ps.setInt(2, customerId);
//            ps.executeUpdate();
//            ResultSet rs = ps.getGeneratedKeys();
//            if (rs.next()) {
//                return rs.getInt(1);
//            }
//        }
//        return -1;
//    }
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

    //for staff
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

    public boolean updatePaymentStatusByOrderId(int orderId, int newPaymentStatus) {
        String sql = "UPDATE [Order] SET paymentStatus = ?, orderUpdatedAt = GETDATE() WHERE orderID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newPaymentStatus);
            ps.setInt(2, orderId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public static void main(String[] args) {

        OrderDAO dao = new OrderDAO();

        int testOrderId = 51;           // 👉 thay bằng orderID thật có trong DB
        int newPaymentStatus = 2;      // 👉 0 = Unpaid, 1 = Paid, 2 = Refunded

        // 1. Trước khi cập nhật
        int oldStatus = dao.getPaymentStatusByOrderId(testOrderId);
        System.out.println("Old Payment Status: " + oldStatus);

        // 2. Cập nhật
        boolean updated = dao.updatePaymentStatusByOrderId(testOrderId, newPaymentStatus);
        System.out.println(updated ? "✅ Payment status updated successfully." : "❌ Update failed.");

        // 3. Kiểm tra lại
        int updatedStatus = dao.getPaymentStatusByOrderId(testOrderId);
        System.out.println("New Payment Status: " + updatedStatus);
    }
}
