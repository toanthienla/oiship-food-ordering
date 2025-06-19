package controller.cart;

import dao.CartDAO;
import dao.DishDAO;
import model.Cart;
import model.Dish;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewCart", urlPatterns = {"/customer/view-cart"})
public class ViewCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int customerID = (int) session.getAttribute("userId");

        try {
            CartDAO cartDAO = new CartDAO();
            List<Cart> cartItems = cartDAO.getCartByCustomerId(customerID);

            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể hiển thị giỏ hàng.");
            request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);
        }
    }
}
