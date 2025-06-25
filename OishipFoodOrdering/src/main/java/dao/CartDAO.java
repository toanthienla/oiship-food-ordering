package dao;

import java.math.BigDecimal;
import model.Cart;
import model.Dish;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.DishIngredient;
import model.Ingredient;
import utils.TotalPriceCalculator;

public class CartDAO extends DBContext {

 
//  public List<Cart> getCartByCustomerId(int customerId) throws SQLException {
//    List<Cart> cartItems = new ArrayList<>();
//
//    String sql = "SELECT " +
//                 "c.cartID, c.quantity, c.FK_Cart_Customer, c.FK_Cart_Dish, " +
//                 "d.DishName, d.image, d.opCost, d.interestPercentage " +
//                 "FROM Cart c " +
//                 "JOIN Dish d ON c.FK_Cart_Dish = d.DishID " +
//                 "WHERE c.FK_Cart_Customer = ?";
//
//    try (PreparedStatement ps = conn.prepareStatement(sql)) {
//        ps.setInt(1, customerId);
//        ResultSet rs = ps.executeQuery();
//        while (rs.next()) {
//            Cart cart = new Cart();
//            cart.setCartID(rs.getInt("cartID"));
//            cart.setCustomerID(rs.getInt("FK_Cart_Customer"));
//            cart.setDishID(rs.getInt("FK_Cart_Dish"));
//            cart.setQuantity(rs.getInt("quantity"));
//
//            Dish dish = new Dish();
//            dish.setDishID(rs.getInt("FK_Cart_Dish"));
//            dish.setDishName(rs.getString("DishName"));
//            dish.setImage(rs.getString("image"));
//            dish.setOpCost(rs.getBigDecimal("opCost"));
//            dish.setInterestPercentage(rs.getBigDecimal("interestPercentage"));
//
//            cart.setDish(dish);
//            cartItems.add(cart);
//        }
//    }
//
//    return cartItems;
//}

    public List<Cart> getCartByCustomerId(int customerId) throws SQLException {
    List<Cart> cartItems = new ArrayList<>();

    String sql = "SELECT " +
                 "c.cartID, c.quantity, c.FK_Cart_Customer, c.FK_Cart_Dish, " +
                 "d.DishName, d.image, d.opCost, d.interestPercentage " +
                 "FROM Cart c " +
                 "JOIN Dish d ON c.FK_Cart_Dish = d.DishID " +
                 "WHERE c.FK_Cart_Customer = ?";

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();

        IngredientDAO ingredientDAO = new IngredientDAO();

        while (rs.next()) {
            Cart cart = new Cart();
            cart.setCartID(rs.getInt("cartID"));
            cart.setCustomerID(rs.getInt("FK_Cart_Customer"));
            cart.setDishID(rs.getInt("FK_Cart_Dish"));
            cart.setQuantity(rs.getInt("quantity"));

            Dish dish = new Dish();
            int dishId = rs.getInt("FK_Cart_Dish");

            dish.setDishID(dishId);
            dish.setDishName(rs.getString("DishName"));
            dish.setImage(rs.getString("image"));
            dish.setOpCost(rs.getBigDecimal("opCost"));
            dish.setInterestPercentage(rs.getBigDecimal("interestPercentage"));

            // ✅ Tính giá từ nguyên liệu
            List<Ingredient> ingredients = ingredientDAO.getIngredientsByDishId(dishId);
            BigDecimal ingredientCost = TotalPriceCalculator.calculateIngredientCost(ingredients);
            BigDecimal totalPrice = TotalPriceCalculator.calculateTotalPrice(
                    dish.getOpCost(), dish.getInterestPercentage(), ingredientCost);

            dish.setIngredients(ingredients);
            dish.setTotalPrice(totalPrice);
            dish.setFormattedPrice(TotalPriceCalculator.formatVND(totalPrice));

            cart.setDish(dish);
            cartItems.add(cart);
        }
    }

    return cartItems;
}

    
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
//  phương thức edit quantity nếu đã có cartID
public void updateCartQuantity(int cartID, int quantity) throws SQLException {
    String sql = "UPDATE Cart SET quantity = ? WHERE cartID = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, quantity);
        ps.setInt(2, cartID);
        ps.executeUpdate();
    }
}

public void updateQuantity(int cartID, int quantity) {
    String sql = "UPDATE Cart SET quantity = ? WHERE cartID = ?";
    try (
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, quantity);
        ps.setInt(2, cartID);
        ps.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    }
}

    // Xóa một món trong giỏ hàng   
    public void deleteCartItem(int cartId) throws SQLException {
        String sql = "DELETE FROM Cart WHERE cartID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        }
    }

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
public int getTotalCartItems(int customerId) throws SQLException {
    String sql = "SELECT COUNT(*) AS totalCart FROM Cart WHERE FK_Cart_Customer = ?";
    int totalCart = 0;

    try (PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, customerId);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalCart = rs.getInt("totalCart");
            }
        }
    }

    return totalCart;
}

public List<Cart> getCartsByIDs(String[] cartIDs) throws SQLException {
    List<Cart> carts = new ArrayList<>();

    if (cartIDs == null || cartIDs.length == 0) return carts;

    // Chuẩn bị truy vấn
    StringBuilder sql = new StringBuilder(
        "SELECT c.cartID, c.quantity, c.FK_Cart_Customer, c.FK_Cart_Dish, " +
        "d.DishID, d.DishName, d.image, d.opCost, d.interestPercentage " +
        "FROM Cart c JOIN Dish d ON c.FK_Cart_Dish = d.DishID " +
        "WHERE c.cartID IN ("
    );
    sql.append("?,".repeat(cartIDs.length));
    sql.setLength(sql.length() - 1); // xóa dấu phẩy cuối
    sql.append(")");

    try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        for (int i = 0; i < cartIDs.length; i++) {
            ps.setInt(i + 1, Integer.parseInt(cartIDs[i]));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Cart cart = new Cart();
            cart.setCartID(rs.getInt("cartID"));
            cart.setQuantity(rs.getInt("quantity"));
            cart.setCustomerID(rs.getInt("FK_Cart_Customer"));
            cart.setDishID(rs.getInt("FK_Cart_Dish"));

            Dish dish = new Dish();
            dish.setDishID(rs.getInt("DishID"));
            dish.setDishName(rs.getString("DishName"));
            dish.setImage(rs.getString("image"));
            dish.setOpCost(rs.getBigDecimal("opCost"));
            dish.setInterestPercentage(rs.getBigDecimal("interestPercentage"));

            // Lấy nguyên liệu cho dish
            loadIngredientsForDish(dish);

            cart.setDish(dish);
            carts.add(cart);
        }
    }

    return carts;
}
private void loadIngredientsForDish(Dish dish) throws SQLException {
    List<Ingredient> ingredients = new ArrayList<>();

    String sql = "SELECT i.ingredientID, i.name, i.unitCost, \n" +
"               di.quantity AS usedQuantity\n" +
"        FROM DishIngredient di\n" +
"        JOIN Ingredient i ON di.ingredientID = i.ingredientID\n" +
"        WHERE di.dishID = ?";

    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, dish.getDishID());
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Ingredient ingredient = new Ingredient();
            ingredient.setIngredientId(rs.getInt("ingredientID"));
            ingredient.setIngredientName(rs.getString("name"));
            ingredient.setUnitCost(rs.getBigDecimal("unitCost"));

            DishIngredient di = new DishIngredient();
            di.setDishId(dish.getDishID());
            di.setIngredientId(rs.getInt("ingredientID"));
            di.setQuantity(rs.getBigDecimal("usedQuantity").doubleValue());

            ingredient.setDishIngredients(List.of(di));
            ingredients.add(ingredient);
        }
    }

    dish.setIngredients(ingredients);
}




}
