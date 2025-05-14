package controller.google;

import dao.RestaurantManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.RestaurantManager;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;

@WebServlet(name = "RestaurantCompleteProfileServlet", urlPatterns = {"/restaurantmanager-profile-completion"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class RestaurantManagerProfileCompletionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/google/restaurant_complete_profile.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login");
            return;
        }

        String email = (String) session.getAttribute("oauth_email");
        String name = (String) session.getAttribute("oauth_name");

        if (email == null || name == null) {
            response.sendRedirect("login");
            return;
        }

        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String openingHours = request.getParameter("opening_hours");

        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (phone == null || address == null || password == null || confirmPassword == null
                || phone.trim().isEmpty() || address.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("/WEB-INF/views/google/restaurant_complete_profile.jsp").forward(request, response);
            return;
        }

        if (!phone.matches("0\\d{9}")) {
            request.setAttribute("error", "Phone number must start with 0 and be 10 digits.");
            request.getRequestDispatcher("/WEB-INF/views/google/restaurant_complete_profile.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/google/restaurant_complete_profile.jsp").forward(request, response);
            return;
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        RestaurantManager restaurant = new RestaurantManager();
        restaurant.setName(name);
        restaurant.setEmail(email);
        restaurant.setPhone(phone);
        restaurant.setAddress(address);
        restaurant.setOpeningHours(openingHours); // có thể là null hoặc chuỗi trống

        restaurant.setPassword(hashedPassword);
        restaurant.setStatusId(2); // Pending approval
        restaurant.setCreatedAt(Timestamp.from(Instant.now()));

        RestaurantManagerDAO dao = new RestaurantManagerDAO();
        int newId = dao.insertRestaurantAndReturnId(restaurant);

        if (newId > 0) {
            session.invalidate();
            request.getRequestDispatcher("/WEB-INF/views/approval/awaiting_approval.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to create restaurant account. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/google/restaurant_complete_profile.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles restaurant profile completion after Google login";
    }
}
