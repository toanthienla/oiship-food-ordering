package dao;

import model.Order;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
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
        OrderDAO dao = new OrderDAO();
        List<Order> orders = dao.getAllOrders();

        for (Order o : orders) {
            System.out.println("Order ID: " + o.getOrderID());
            System.out.println("Customer Name: " + o.getCustomerName());
            System.out.println("Voucher Code: " + o.getVoucherCode());
            System.out.println("Amount: " + o.getAmount());
            System.out.println("Order Status: " + o.getOrderStatus());
            System.out.println("Created At: " + o.getOrderCreatedAt());
            System.out.println("------");
        }
    }
}
