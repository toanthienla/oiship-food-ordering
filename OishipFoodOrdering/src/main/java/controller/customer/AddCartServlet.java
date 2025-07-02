package controller.customer;

import dao.CartDAO;
import dao.DishDAO;
import model.Cart;
import model.Dish;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AddCart", urlPatterns = {"/customer/add-cart"})
public class AddCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dishId = request.getParameter("dishID");
        request.setAttribute("errorMessage", "GET method is not supported. Please use the form submission.");
        request.getRequestDispatcher("/customer/dish-detail?dishId=" + (dishId != null ? dishId : "")).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dishIdStr = request.getParameter("dishID");
        String quantityStr = request.getParameter("quantity");
        HttpSession session = request.getSession();

        // Check login
        if (session.getAttribute("userId") == null) {
            session.setAttribute("redirectAfterLogin", "/customer/add-cart?dishID=" + dishIdStr);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (dishIdStr == null || quantityStr == null || dishIdStr.trim().isEmpty() || quantityStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Missing dish or quantity data.");
            response.sendRedirect(request.getContextPath() + "/customer/dish-detail?dishId=" + dishIdStr);
            return;
        }

        try {
            int dishID = Integer.parseInt(dishIdStr);
            int quantity = Integer.parseInt(quantityStr);

            if (quantity <= 0) {
                session.setAttribute("errorMessage", "Quantity must be greater than 0.");
                response.sendRedirect(request.getContextPath() + "/customer/dish-detail?dishId=" + dishIdStr);
                return;
            }

            DishDAO dishDAO = new DishDAO();
            Dish dish = dishDAO.getDishById(dishID);

            if (dish == null || !dish.isIsAvailable()) {
                session.setAttribute("errorMessage", "Invalid or unavailable dish.");
                response.sendRedirect(request.getContextPath() + "/customer/dish-detail?dishId=" + dishIdStr);
                return;
            }

            int customerID = (int) session.getAttribute("userId");
            CartDAO cartDAO = new CartDAO();
            Cart existingItem = cartDAO.getCartItem(customerID, dishID);

            if (existingItem != null) {
                cartDAO.updateQuantity(customerID, dishID, existingItem.getQuantity() + quantity);
            } else {
                int stock = dishDAO.getDishStockByDishId(dishID);
                if (quantity > stock) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"error\":\"Số lượng vượt quá tồn kho. Chỉ còn " + stock + " món.\"}");
                    return;
                }
                cartDAO.addToCart(customerID, dishID, quantity);
            }

            Map<String, Object> cartSuccessDetails = new HashMap<>();
            cartSuccessDetails.put("image", dish.getImage() != null ? dish.getImage() : "");
            cartSuccessDetails.put("name", dish.getDishName());
            cartSuccessDetails.put("quantity", quantity);
            cartSuccessDetails.put("price", dish.getFormattedPrice() + " đ");

            session.setAttribute("cartSuccessDetails", cartSuccessDetails);
            response.sendRedirect(request.getContextPath() + "/customer");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid input data.");
            response.sendRedirect(request.getContextPath() + "/customer/dish-detail?dishId=" + dishIdStr);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "System error while adding to cart: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/customer/dish-detail?dishId=" + dishIdStr);
        }
    }
}
