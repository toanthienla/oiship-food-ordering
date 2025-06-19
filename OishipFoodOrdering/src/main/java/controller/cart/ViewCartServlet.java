package controller.cart;

import dao.CartDAO;
import model.Cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewCartServlet", urlPatterns = {"/customer/view-cart"})
public class ViewCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý hiển thị giỏ hàng
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý xóa món trong giỏ hàng
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String cartIdStr = request.getParameter("cartID");
        if (cartIdStr == null || cartIdStr.isEmpty()) {
            request.setAttribute("error", "Không tìm thấy món để xóa.");
            doGet(request, response); // Hiển thị lại giỏ hàng với thông báo lỗi
            return;
        }

        try {
            int cartID = Integer.parseInt(cartIdStr);
            CartDAO cartDAO = new CartDAO();
            cartDAO.deleteCartItem(cartID);
            // Xóa thành công -> redirect về chính trang giỏ hàng để cập nhật
            response.sendRedirect(request.getContextPath() + "/customer/view-cart");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã giỏ hàng không hợp lệ.");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xóa món khỏi giỏ hàng.");
            doGet(request, response);
        }
    }
}
