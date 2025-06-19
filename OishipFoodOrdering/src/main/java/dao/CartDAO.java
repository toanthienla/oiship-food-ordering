package dao;

import model.Cart;
import model.Dish;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DBContext {

//    // Lấy tất cả món trong giỏ hàng của một customer
//    public List<Cart> getCartByCustomerId(int customerId) throws SQLException {
//        List<Cart> cartItems = new ArrayList<>();
//        String sql = "SELECT c.cartID, c.quantity, c.FK_Cart_Customer, c.FK_Cart_Dish, " +
//                     "d.DishName, d.image, d.opCost, d.interestPercentage " +
//                     "FROM Cart c " +
//                     "JOIN Dish d ON c.FK_Cart_Dish = d.DishID " +
//                     "WHERE c.FK_Cart_Customer = ?";
//        try (PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, customerId);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                Cart cart = new Cart();
//                cart.setCartID(rs.getInt("cartID"));
//                cart.setCustomerID(rs.getInt("FK_Cart_Customer"));
//                cart.setDishID(rs.getInt("FK_Cart_Dish"));
//                cart.setQuantity(rs.getInt("quantity"));
//
//                // Gắn thông tin món ăn (nếu cần)
//                Dish dish = new Dish();
//                dish.setDishID(rs.getInt("FK_Cart_Dish"));
//                dish.setDishName(rs.getString("DishName"));
//                dish.setImage(rs.getString("image"));
//                dish.setOpCost(rs.getBigDecimal("opCost"));
//                dish.setInterestPercentage(rs.getBigDecimal("interestPercentage"));
//
//                cart.setDish(dish);
//                cartItems.add(cart);
//            }
//        }
//        return cartItems;
//    }

    // Thêm món mới vào giỏ hàng
    public void addToCart(int customerId, int dishId, int quantity) throws SQLException {
        String sql = "INSERT INTO Cart (quantity, FK_Cart_Customer, FK_Cart_Dish) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, customerId);
            ps.setInt(3, dishId);
            ps.executeUpdate();
        }
    }

    // Cập nhật số lượng món trong giỏ hàng
  public void updateQuantity(int customerID, int dishID, int newQuantity) throws SQLException {
        String sql = "UPDATE Cart SET quantity = ? WHERE FK_Cart_Customer = ? AND FK_Cart_Dish = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, customerID);
            ps.setInt(3, dishID);
            ps.executeUpdate();
        }
    }

//    // Xóa một món trong giỏ hàng   
//    public void deleteCartItem(int cartId) throws SQLException {
//        String sql = "DELETE FROM Cart WHERE cartID = ?";
//        try (PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, cartId);
//            ps.executeUpdate();
//        }
//    }

//    // Xóa toàn bộ giỏ hàng của một customer
//    public void deleteCartByCustomerId(int customerId) throws SQLException {
//        String sql = "DELETE FROM Cart WHERE FK_Cart_Customer = ?";
//        try (PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, customerId);
//            ps.executeUpdate();
//        }
//    }

    // Kiểm tra xem một món đã có trong giỏ hàng chưa
    public Cart getCartItem(int customerId, int dishId) throws SQLException {
        String sql = "SELECT * FROM Cart WHERE FK_Cart_Customer = ? AND FK_Cart_Dish = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, dishId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Cart cart = new Cart();
                cart.setCartID(rs.getInt("cartID"));
                cart.setCustomerID(rs.getInt("FK_Cart_Customer"));
                cart.setDishID(rs.getInt("FK_Cart_Dish"));
                cart.setQuantity(rs.getInt("quantity"));
                return cart;
            }
        }
        return null;
    }
//      private boolean isDishAvailable(int dishId) throws SQLException {
//        String sql = "SELECT isAvailable FROM Dish WHERE DishID = ?";
//        try (Connection conn = new DBContext().getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, dishId);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                return rs.getBoolean("isAvailable");
//            }
//            return false; // Dish not found
//        }
//    }
}
