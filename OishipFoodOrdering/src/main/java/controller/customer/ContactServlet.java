/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dao.AccountDAO;
import dao.CartDAO;
import dao.ContactDAO;
import dao.NotificationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Account;
import model.Cart;
import model.Notification;

@WebServlet(name = "ContactServlet", urlPatterns = {"/customer/contact"})
public class ContactServlet extends HttpServlet {

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
            out.println("<title>Servlet ContactServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ContactServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if the session exists and the user is logged in as a customer
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"customer".equals(session.getAttribute("role"))) {
            System.out.println("ContactServlet - Unauthorized access attempt at 2025-07-29 18:13:08");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int customerId = (int) session.getAttribute("userId");

        // Get customer information using userId
        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.findByID(customerId);

        if (account != null) {
            request.setAttribute("account", account);
            request.setAttribute("userName", account.getFullName());
            System.out.println("ContactServlet - Found account: " + account.getFullName() + " (ID: " + customerId + ") at 2025-07-29 18:13:08");
        } else {
            request.setAttribute("error", "Account not found for user ID: " + customerId);
            request.setAttribute("userName", "toanthienla"); // Current user fallback
            System.out.println("ContactServlet - Account not found for userId: " + customerId + ", using fallback username: toanthienla");
        }

        // Get notifications for the customer
        NotificationDAO notificationDAO = new NotificationDAO();
        List<Notification> notifications = notificationDAO.getUnreadNotificationsByCustomer(customerId);
        request.setAttribute("notifications", notifications);
        System.out.println("ContactServlet - Notifications count: " + (notifications != null ? notifications.size() : 0) + " for userId: " + customerId);

        // Get cart items for sidebar
        CartDAO cartDAO = new CartDAO();
        try {
            List<Cart> cartItems = cartDAO.getCartByCustomerId(customerId);
            session.setAttribute("cartItems", cartItems);
            System.out.println("ContactServlet - Cart items count: " + (cartItems != null ? cartItems.size() : 0));
        } catch (SQLException ex) {
            System.err.println("ContactServlet - Error getting cart items for sidebar at 2025-07-29 18:13:08: " + ex.getMessage());
            ex.printStackTrace();
        }

        try {
            System.out.println("ContactServlet - Displaying contact page for customer " + customerId + " at 2025-07-29 18:13:08");
            System.out.println("ContactServlet - Current user: toanthienla");
            System.out.println("ContactServlet - Username attribute set to: " + request.getAttribute("userName"));

            request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("ContactServlet - Error displaying contact page for customer " + customerId
                    + " at 2025-07-29 18:13:08: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("error", "Unable to display contact page.");

            // Ensure userName is still set even on error
            if (request.getAttribute("userName") == null) {
                request.setAttribute("userName", "toanthienla");
            }

            // Ensure notifications are still set even on error
            if (request.getAttribute("notifications") == null) {
                request.setAttribute("notifications", new ArrayList<>());
            }

            request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        HttpSession session = request.getSession(false);
        Object userIdObj = session != null ? session.getAttribute("userId") : null;

        if (userIdObj != null && subject != null && message != null) {
            try {
                int customerID = (int) userIdObj;

                ContactDAO dao = new ContactDAO();
                dao.insertContact(customerID, subject, message);

                request.setAttribute("success", "Your message has been sent successfully!");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("success", "Failed to send message. Please try again.");
            }
        } else {
            request.setAttribute("success", "You must be logged in to send a message.");
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/contact.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
