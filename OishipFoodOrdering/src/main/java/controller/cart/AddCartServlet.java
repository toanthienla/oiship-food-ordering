package controller.cart;

import dao.CartDAO;
import dao.DishDAO;
import model.Cart;
import model.Dish;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "AddCart", urlPatterns = {"/customer/add-cart"})
public class AddCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dishIdStr = request.getParameter("dishID");

        if (dishIdStr == null || dishIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Bạn chưa chọn món ăn nào.");
            request.getRequestDispatcher("/WEB-INF/views/customer/add_cart.jsp").forward(request, response);
            return;
        }

        try {
            int dishID = Integer.parseInt(dishIdStr);
            DishDAO dishDAO = new DishDAO();
            Dish dish = dishDAO.getDishById(dishID);

            if (dish == null || !dish.isIsAvailable()) {
                request.setAttribute("error", "Món ăn không tồn tại hoặc hiện không có sẵn.");
            } else {
                request.setAttribute("addedDish", dish);
                request.setAttribute("quantity", 1); // Mặc định 1 khi chỉ mới GET
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã món ăn không hợp lệ.");
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/add_cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dishIdStr = request.getParameter("dishID");
        String quantityStr = request.getParameter("quantity");
        HttpSession session = request.getSession();

       // Kiểm tra đăng nhập
        if (session.getAttribute("userId") == null) {
            session.setAttribute("redirectAfterLogin", "/customer/add-cart?dishID=" + dishIdStr);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
 
        // Kiểm tra thiếu dữ liệu
        if (dishIdStr == null || quantityStr == null || dishIdStr.trim().isEmpty() || quantityStr.trim().isEmpty()) {
            request.setAttribute("error", "Thiếu dữ liệu món ăn hoặc số lượng.");
            request.getRequestDispatcher("/WEB-INF/views/customer/add_cart.jsp").forward(request, response);
            return;
        }

        try {
            int dishID = Integer.parseInt(dishIdStr);
            int quantity = Integer.parseInt(quantityStr);

            if (quantity <= 0) {
                request.setAttribute("error", "Số lượng phải lớn hơn 0.");
                request.getRequestDispatcher("/WEB-INF/views/customer/add_cart.jsp").forward(request, response);
                return;
            }

            DishDAO dishDAO = new DishDAO();
            Dish dish = dishDAO.getDishById(dishID);

            if (dish == null || !dish.isIsAvailable()) {
                request.setAttribute("error", "Món ăn không hợp lệ hoặc đã ngưng bán.");
                request.getRequestDispatcher("/WEB-INF/views/customer/add_cart.jsp").forward(request, response);
                return;
            }

            int customerID = (int) session.getAttribute("userId");
            CartDAO cartDAO = new CartDAO();
            Cart existing = cartDAO.getCartItem(customerID, dishID);

            if (existing != null) {
                cartDAO.updateQuantity(customerID, dishID, existing.getQuantity() + quantity);
            } else {
                cartDAO.addToCart(customerID, dishID, quantity);
            }

            request.setAttribute("addedDish", dish);
            request.setAttribute("quantity", quantity);
            request.getRequestDispatcher("/WEB-INF/views/customer/add_cart.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu nhập không hợp lệ.");
            request.getRequestDispatcher("/WEB-INF/views/customer/add_cart.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống khi thêm vào giỏ hàng.");
            request.getRequestDispatcher("/WEB-INF/views/customer/add_cart.jsp").forward(request, response);
        }
    }
}