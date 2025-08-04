package controller.customer;

import dao.AccountDAO;
import dao.CartDAO;
import dao.NotificationDAO;
import dao.VoucherDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Cart;
import model.Notification;
import model.Voucher;

@WebServlet(name = "ViewVoucherServlet", urlPatterns = {"/customer/view-vouchers-list"})
public class ViewVoucherServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if the session exists and the user is logged in as a customer
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"customer".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get vouchers
        VoucherDAO voucherDAO = new VoucherDAO();
        List<Voucher> vouchers = voucherDAO.getAllActiveVouchers();
        request.setAttribute("vouchers", vouchers);

        // Get customer information using email stored in session
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

        // Get cart items for the customer
        CartDAO cartDAO = new CartDAO();
        List<Cart> cartItems = null;
        try {
            cartItems = cartDAO.getCartByCustomerId(userId);
        } catch (SQLException ex) {
            Logger.getLogger(ViewVoucherServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Store cart items in session for use in sidebar
        session.setAttribute("cartItems", cartItems);

        // Forward to vouchers page
        request.getRequestDispatcher("/WEB-INF/views/customer/vouchers_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for displaying customer vouchers list with notifications and cart functionality";
    }
}