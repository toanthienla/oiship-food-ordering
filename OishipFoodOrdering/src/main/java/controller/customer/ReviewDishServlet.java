package controller.customer;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Servlet dùng để hiển thị form đánh giá món ăn.
 */
@WebServlet(name = "ReviewDishServlet", urlPatterns = {"/customer/review"})
public class ReviewDishServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int odid = Integer.parseInt(request.getParameter("odid"));
            String dishName = request.getParameter("dishName");
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int customerId = (int) session.getAttribute("userId");

            // ✅ Gọi DAO để thêm đánh giá
            ReviewDAO dao = new ReviewDAO();
            dao.addReview(odid, customerId, rating, comment);

            // ✅ Chuyển hướng về lại trang lịch sử đơn hàng
            response.sendRedirect(request.getContextPath() + "/customer/order");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to submit review.");
            request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu ai truy cập bằng GET thì redirect về homepage
        response.sendRedirect(request.getContextPath() + "/customer");
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị form đánh giá món ăn thông qua POST";
    }
}
