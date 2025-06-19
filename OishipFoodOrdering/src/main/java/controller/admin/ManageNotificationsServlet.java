package controller.admin;

import dao.NotificationDAO;
import model.Notification;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/manage-notifications")
public class ManageNotificationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        NotificationDAO dao = new NotificationDAO();

        if ("delete".equals(action) && idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                boolean deleted = dao.deleteNotification(id);
                response.sendRedirect("manage-notifications?success=" + (deleted ? "delete" : "false"));
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect("manage-notifications?success=false");
                return;
            }
        }

        // Fetch notifications and forward to JSP
        List<Notification> list = dao.getAllNotifications();
        request.setAttribute("notifications", list);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage_notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String notIDParam = request.getParameter("notID"); // Only sent in edit form
        String title = request.getParameter("notTitle");
        String description = request.getParameter("notDescription");
//        String accIDParam = request.getParameter("accountID");
        String accIDParam = "1";

        // Validate inputs
        if (title == null || description == null || accIDParam == null || accIDParam.trim().isEmpty()) {
            response.sendRedirect("manage-notifications?success=false");
            return;
        }

        try {
            int accID = Integer.parseInt(accIDParam);
            NotificationDAO dao = new NotificationDAO();

            if (notIDParam != null && !notIDParam.trim().isEmpty()) {
                // Edit existing notification
                int notID = Integer.parseInt(notIDParam);
                Notification noti = new Notification(notID, title, description, accID);
                boolean updated = dao.updateNotification(noti);
                response.sendRedirect("manage-notifications?success=" + (updated ? "edit" : "false"));
            } else {
                // Add new notification
                Notification noti = new Notification(title, description, accID);
                boolean added = dao.addNotification(noti);
                response.sendRedirect("manage-notifications?success=" + (added ? "add" : "false"));
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid ID format: " + e.getMessage());
            response.sendRedirect("manage-notifications?success=false");
        }
    }
}
