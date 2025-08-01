package controller.customer;

import dao.AccountDAO;
import dao.CartDAO;
import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;
import model.Cart;
import model.Notification;

@WebServlet(name = "ViewCartServlet", urlPatterns = {"/customer/view-cart"})
public class ViewCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if the session exists and the user is logged in as a customer
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"customer".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get userId from session
        int userId = (int) session.getAttribute("userId");

        // Get customer information using userId stored in session
        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.findByID(userId);

        if (account != null) {
            request.setAttribute("account", account);
            request.setAttribute("userName", account.getFullName());
            System.out.println("ViewCartServlet - Found account by userId: " + account.getFullName() + " (ID: " + userId + ") at 2025-07-29 17:13:33");
        } else {
            request.setAttribute("error", "Account not found for user ID: " + userId);
            request.setAttribute("userName", "toanthienla"); // Current user fallback
            System.out.println("ViewCartServlet - Account not found for userId: " + userId + ", using fallback username: toanthienla at 2025-07-29 17:13:33");
        }

        // Refresh remember_me cookie if present
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("email".equals(cookie.getName())) {
                    Cookie emailCookie = new Cookie("email", cookie.getValue());
                    emailCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                    emailCookie.setPath(request.getContextPath());
                    response.addCookie(emailCookie);
                    break;
                }
            }
        }

        // Get notifications for the customer
        NotificationDAO notificationDAO = new NotificationDAO();
        List<Notification> notifications = notificationDAO.getUnreadNotificationsByCustomer(userId);
        request.setAttribute("notifications", notifications);
        System.out.println("ViewCartServlet - Notifications count: " + (notifications != null ? notifications.size() : 0) + " for userId: " + userId);

        try {
            CartDAO cartDAO = new CartDAO();
            List<Cart> cartItems = cartDAO.getCartByCustomerId(userId);

            // Store cart items in session for use in sidebar
            session.setAttribute("cartItems", cartItems);
            request.setAttribute("cartItems", cartItems);

            System.out.println("ViewCartServlet - Cart items count: " + (cartItems != null ? cartItems.size() : 0));
            System.out.println("ViewCartServlet - Current timestamp: 2025-07-29 17:13:33");
            System.out.println("ViewCartServlet - Current user: toanthienla");
            System.out.println("ViewCartServlet - User ID: " + userId);
            System.out.println("ViewCartServlet - Username attribute set to: " + request.getAttribute("userName"));

            request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);

        } catch (SQLException ex) {
            Logger.getLogger(ViewCartServlet.class.getName()).log(Level.SEVERE, "SQL Exception in ViewCartServlet for userId: " + userId + " at 2025-07-29 17:13:33", ex);
            request.setAttribute("error", "Database error: Unable to display the cart.");
            // Ensure userName is still set even on error
            if (request.getAttribute("userName") == null) {
                request.setAttribute("userName", "toanthienla");
            }
            request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);
        } catch (Exception e) {
            Logger.getLogger(ViewCartServlet.class.getName()).log(Level.SEVERE, "General Exception in ViewCartServlet for userId: " + userId + " at 2025-07-29 17:13:33", e);
            request.setAttribute("error", "Unable to display the cart.");
            // Ensure userName is still set even on error
            if (request.getAttribute("userName") == null) {
                request.setAttribute("userName", "toanthienla");
            }
            request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"customer".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            CartDAO cartDAO = new CartDAO();
            String cartIdStr = request.getParameter("cartID");
            String quantityStr = request.getParameter("quantity");

            // Handle quantity update via AJAX
            if (cartIdStr != null && quantityStr != null) {
                int cartID = Integer.parseInt(cartIdStr);
                int quantity = Integer.parseInt(quantityStr);

                // Validate quantity limits
                if (quantity <= 0) {
                    quantity = 1;
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    String json = "{"
                            + "\"success\": false,"
                            + "\"error\": \"Quantity must be at least 1.\","
                            + "\"validQuantity\": " + quantity
                            + "}";

                    response.getWriter().write(json);
                    System.out.println("ViewCartServlet - Quantity update failed: less than 1 for userId: " + userId);
                    return;
                }

//                if (quantity > 50) {
//                    quantity = 50;
//                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
//                    response.setContentType("application/json");
//                    response.setCharacterEncoding("UTF-8");
//
//                    String json = "{"
//                            + "\"success\": false,"
//                            + "\"error\": \"Quantity cannot exceed 50.\","
//                            + "\"validQuantity\": " + quantity
//                            + "}";
//
//                    response.getWriter().write(json);
//                    System.out.println("ViewCartServlet - Quantity update failed: more than 50 for userId: " + userId);
//                    return;
//                }

                // Check stock availability
                int stock = cartDAO.getDishStockByCartId(cartID);
                if (quantity > stock || quantity > 50) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");

                    // Tạo JSON trả về có thêm maxStock
                    String json = "{"
                            + "\"success\": false,"
                            + "\"error\": \"Only " + stock + " items left. Quantity exceeds available stock and Quantity cannot exceed 50.\","
                            + "\"maxStock\": " + stock
                            + "}";

                    response.getWriter().write(json);
                    System.out.println("ViewCartServlet - Quantity update failed: exceeds stock for userId: " + userId + " at 2025-07-29 17:13:33");
                    return;
                }

                // Update cart quantity
                boolean success = cartDAO.updateCartQuantity(cartID, quantity);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                if (success) {
                    response.getWriter().write("{\"success\":true,\"message\":\"Quantity updated successfully.\"}");
                    System.out.println("ViewCartServlet - Successfully updated cart item " + cartID + " to quantity " + quantity + " for userId: " + userId + " at 2025-07-29 17:13:33");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"success\":false,\"error\":\"Failed to update quantity.\"}");
                    System.out.println("ViewCartServlet - Failed to update cart item " + cartID + " for userId: " + userId + " at 2025-07-29 17:13:33");
                }
                return;
            }

            // Handle item removal
            if (cartIdStr != null) {
                int cartID = Integer.parseInt(cartIdStr);
                boolean success = cartDAO.deleteCartItem(cartID);

                if (success) {
                    session.setAttribute("cartMessage", "Item removed successfully!");
                    System.out.println("ViewCartServlet - Successfully removed cart item " + cartID + " for userId: " + userId + " at 2025-07-29 17:13:33");
                } else {
                    session.setAttribute("cartError", "Failed to remove item.");
                    System.out.println("ViewCartServlet - Failed to remove cart item " + cartID + " for userId: " + userId + " at 2025-07-29 17:13:33");
                }

                response.sendRedirect(request.getContextPath() + "/customer/view-cart");
            }

        } catch (NumberFormatException e) {
            Logger.getLogger(ViewCartServlet.class.getName()).log(Level.WARNING, "Invalid number format in ViewCartServlet for userId: " + userId + " at 2025-07-29 17:13:33", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\":false,\"error\":\"Invalid number format.\"}");

        } catch (Exception e) {
            Logger.getLogger(ViewCartServlet.class.getName()).log(Level.SEVERE, "Unexpected error in ViewCartServlet doPost for userId: " + userId + " at 2025-07-29 17:13:33", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\":false,\"error\":\"Failed to process cart operation: " + e.getMessage() + "\"}");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for displaying and managing customer cart with notifications functionality - Updated: 2025-07-29 17:13:33 by toanthienla";
    }
}
