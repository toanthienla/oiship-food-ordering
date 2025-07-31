/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dao.AccountDAO;
import dao.NotificationDAO;
import dao.ReviewDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;
import model.Notification;
import model.Review;
import model.Order;

/**
 *
 * @author Phi Yen
 */
@WebServlet(name = "ViewReviewServlet", urlPatterns = {"/customer/view-review"})
public class ViewReviewServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ViewReviewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewReviewServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/customer/order");

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if the session exists and the user is logged in as a customer
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"customer".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get customer information using email stored in session
        // int userId = (int) session.getAttribute("userId");
        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.findByEmail((String) session.getAttribute("email"));
        if (account != null) {
            request.setAttribute("account", account);
            request.setAttribute("userName", account.getFullName());
        } else {
            request.setAttribute("error", "Account not found.");
        }
        int userId = account.getAccountID();
        // Refresh remember_me cookie if present
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("email".equals(cookie.getName())) {
                    Cookie emailCookie = new Cookie("email", cookie.getValue());
                    emailCookie.setMaxAge(30 * 24 * 60 * 60);
                    emailCookie.setPath(request.getContextPath());
                    response.addCookie(emailCookie);
                    break;
                }
            }
        }

        NotificationDAO notificationDAO = new NotificationDAO();
        List<Notification> notifications = notificationDAO.getUnreadNotificationsByCustomer(userId);
        request.setAttribute("notifications", notifications);
        String email = (String) session.getAttribute("email");
        
        String deleteIdParam = request.getParameter("reviewID");
        if (deleteIdParam != null) {
            try {
                int reviewID = Integer.parseInt(deleteIdParam);
                ReviewDAO reviewDAO = new ReviewDAO();
                reviewDAO.deleteReviewById(reviewID);

                String orderID = request.getParameter("orderID");
                if (orderID != null) {
                    response.sendRedirect(request.getContextPath() + "/customer/view-review?orderID=" + orderID);
                } else {
                    response.sendRedirect(request.getContextPath() + "/customer/order");
                }
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/customer/order");
                return;
            } catch (SQLException ex) {
                Logger.getLogger(ViewReviewServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        String odidParam = request.getParameter("orderID");
        if (odidParam == null) {
            response.sendRedirect(request.getContextPath() + "/customer/order");
            return;
        }

        try {
            int odid = Integer.parseInt(odidParam);

            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> review = reviewDAO.getReviewsByOrderId(odid);

            // Get order details for date information
            OrderDAO orderDAO = new OrderDAO();
            Order orderDetails = orderDAO.getOrderById(odid);
            String orderDate = null;

            if (orderDetails != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");
                orderDate = sdf.format(orderDetails.getOrderCreatedAt());

                System.out.println("ViewReviewServlet - Order ID: " + odid + ", Date: " + orderDate
                        + ", Reviews count: " + (review != null ? review.size() : 0)
                        + " at 2025-07-31 06:32:33 - User: toanthienla");
            } else {
                System.out.println("ViewReviewServlet - Order not found for ID: " + odid
                        + " at 2025-07-31 06:32:33 - User: toanthienla");
            }

            request.setAttribute("reviews", review);
            request.setAttribute("orderID", String.valueOf(odid));
            request.setAttribute("orderDate", orderDate);

            request.getRequestDispatcher("/WEB-INF/views/customer/view_review.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("ViewReviewServlet - Invalid orderID format: " + odidParam
                    + " at 2025-07-31 06:32:33 - User: toanthienla");
            response.sendRedirect(request.getContextPath() + "/customer/order");
        } catch (Exception ex) {
            System.err.println("ViewReviewServlet - Error retrieving reviews for order " + odidParam
                    + " at 2025-07-31 06:32:33 - User: toanthienla: " + ex.getMessage());
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/order");
        }
    }

    @Override
    public String getServletInfo() {
        return "ViewReviewServlet - Updated 2025-07-31 06:32:33 - User: toanthienla";
    }
}
