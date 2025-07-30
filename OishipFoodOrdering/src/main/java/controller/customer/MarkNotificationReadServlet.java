package controller.customer;

import dao.NotificationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "MarkNotificationReadServlet", urlPatterns = {"/customer/mark-read"})
public class MarkNotificationReadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {
            // Debug: Print request info
            System.out.println("=== REQUEST INFO ===");
            System.out.println("Content Type: " + request.getContentType());
            System.out.println("Method: " + request.getMethod());
            System.out.println("Request URI: " + request.getRequestURI());

            HttpSession session = request.getSession(false);

            if (session == null || session.getAttribute("userId") == null) {
                System.out.println("Session or userId is null");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.write("{\"success\":false,\"message\":\"Not logged in\"}");
                return;
            }

            // Debug: Print all parameters
            System.out.println("=== ALL REQUEST PARAMETERS ===");
            Enumeration<String> parameterNames = request.getParameterNames();
            boolean hasParams = false;
            while (parameterNames.hasMoreElements()) {
                hasParams = true;
                String paramName = parameterNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println("Parameter: '" + paramName + "' = '" + paramValue + "'");
            }

            if (!hasParams) {
                System.out.println("NO PARAMETERS FOUND");
            }
            System.out.println("=== END PARAMETERS ===");

            String notIDStr = request.getParameter("notID");
            System.out.println("Received notID parameter: '" + notIDStr + "'"); // Debug log

            if (notIDStr == null || notIDStr.trim().isEmpty()) {
                System.out.println("Missing or empty notID parameter"); // Debug log
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"success\":false,\"message\":\"Missing notification ID\"}");
                return;
            }

            try {
                int notID = Integer.parseInt(notIDStr.trim());
                int customerID = (int) session.getAttribute("userId");

                System.out.println("Processing - Customer ID: " + customerID + ", Notification ID: " + notID); // Debug log

                NotificationDAO dao = new NotificationDAO();
                boolean success = dao.markAsRead(customerID, notID);

                if (success) {
                    System.out.println("Successfully marked notification as read"); // Debug log
                    response.setStatus(HttpServletResponse.SC_OK);
                    out.write("{\"success\":true,\"message\":\"Notification marked as read\"}");
                } else {
                    System.out.println("Failed to mark notification as read"); // Debug log
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.write("{\"success\":false,\"message\":\"Failed to mark as read\"}");
                }

            } catch (NumberFormatException e) {
                System.out.println("Invalid notification ID format: " + e.getMessage()); // Debug log
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"success\":false,\"message\":\"Invalid notification ID format\"}");
            }

        } catch (Exception e) {
            System.out.println("Unexpected error: " + e.getMessage()); // Debug log
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\":false,\"message\":\"Server error: " + e.getMessage() + "\"}");
        } finally {
            if (out != null) {
                out.flush();
                out.close();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.getWriter().write("{\"success\":false,\"message\":\"GET method not supported\"}");
    }

    @Override
    public String getServletInfo() {
        return "Servlet for marking notifications as read";
    }
}
