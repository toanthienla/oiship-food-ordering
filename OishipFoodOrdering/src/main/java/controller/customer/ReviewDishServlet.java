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
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int customerId = (int) session.getAttribute("userId");

            if (comment != null && comment.length() > 255) {
                request.setAttribute("error", "Comment cannot exceed 255 characters.");
                
                
                  try {
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orderList = orderDAO.getAllOrdersWithDetailsByCustomerId(customerId);

            String[] orderStatusText = {
                "Pending", "Confirmed", "Preparing", "Out for Delivery",
                "Delivered", "Cancelled", "Failed"
            };

//            String[] paymentStatusText = {
//                "Unpaid", "Paid", "Refunded"
//            };

            request.setAttribute("orderHistory", orderList);
            request.setAttribute("orderStatusText", orderStatusText);
           // request.setAttribute("paymentStatusText", paymentStatusText);

            request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể hiển thị lịch sử đơn hàng.");
            request.getRequestDispatcher("/WEB-INF/views/customer/order_history.jsp").forward(request, response);
        }
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/customer");
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị form đánh giá món ăn thông qua POST";
    }
}
