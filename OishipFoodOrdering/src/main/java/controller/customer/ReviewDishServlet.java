
package controller.customer;

import dao.OrderDAO;
import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Order;

@WebServlet(name = "ReviewDishServlet", urlPatterns = {"/customer/review"})
public class ReviewDishServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int odid = Integer.parseInt(request.getParameter("odid"));
            String dishName = request.getParameter("dishName");
            //  int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int customerId = (int) session.getAttribute("userId");
            int rating = Integer.parseInt(request.getParameter("rating"));
            if (rating < 1 || rating > 5) {
                prepareOrderHistoryForReview(request, customerId);
                request.setAttribute("error", "Rating must be between 1 and 5.");
                request.setAttribute("showReviewModal", true);
                request.setAttribute("odid", odid);
                request.setAttribute("dishName", dishName);
                request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);
                return;
            }

            if (comment != null && comment.length() > 255) {
                prepareOrderHistoryForReview(request, customerId);
                request.setAttribute("error", "Comment cannot exceed 255 characters.");
                request.setAttribute("showReviewModal", true);
                request.setAttribute("odid", odid);
                request.setAttribute("dishName", dishName);
                request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);
                return;
            }

            ReviewDAO dao = new ReviewDAO();
            dao.addReview(odid, customerId, rating, comment);

            response.sendRedirect(request.getContextPath() + "/customer/order");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to submit review.");
            request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);
        }
    }

    private void prepareOrderHistoryForReview(HttpServletRequest request, int customerId) {
        try {
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orderList = orderDAO.getAllOrdersWithDetailsByCustomerId(customerId);
            String[] orderStatusText = {
                "Pending", "Confirmed", "Preparing", "Out for Delivery",
                "Delivered", "Cancelled", "Failed"
            };

            request.setAttribute("orderHistory", orderList);
            request.setAttribute("orderStatusText", orderStatusText);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể hiển thị lịch sử đơn hàng.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/customer");
    }

    @Override
    public String getServletInfo() {
        return "Handles dish review submission";
    }
}
