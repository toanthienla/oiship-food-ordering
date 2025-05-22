package controller.google;

import dao.ShipperDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Shipper;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.time.Instant;

@WebServlet(name = "ShipperCompleteProfileServlet", urlPatterns = { "/shipper-profile-completion" })
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB
public class ShipperCompleteProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/google/shipper_profile_completion.jsp").forward(request, response);
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
        String cccd = request.getParameter("cccd");
        String driverLicense = request.getParameter("driver_license");
        String vehicleInfo = request.getParameter("vehicle_info");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        Part driverLicenseImagePart = request.getPart("driver_license_image");

        // Validate
        if (phone == null || address == null || cccd == null || driverLicense == null
                || password == null || confirmPassword == null || driverLicenseImagePart == null
                || phone.trim().isEmpty() || address.trim().isEmpty() || cccd.trim().isEmpty()
                || driverLicense.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all fields.");
            request.getRequestDispatcher("/WEB-INF/views/google/shipper_profile_completion.jsp").forward(request,
                    response);
            return;
        }

        if (!phone.matches("0\\d{9}")) {
            request.setAttribute("error", "Phone number must start with 0 and have exactly 10 digits.");
            request.getRequestDispatcher("/WEB-INF/views/google/shipper_profile_completion.jsp").forward(request,
                    response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/google/shipper_profile_completion.jsp").forward(request,
                    response);
            return;
        }

        // Encrypt password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        // Get driver license image bytes
        byte[] driverLicenseImageBytes = null;
        try (InputStream inputStream = driverLicenseImagePart.getInputStream()) {
            driverLicenseImageBytes = inputStream.readAllBytes();
        }

        Shipper shipper = new Shipper();
        shipper.setName(name);
        shipper.setEmail(email);
        shipper.setPhone(phone);
        shipper.setAddress(address);
        shipper.setCccd(cccd);
        shipper.setDriverLicense(driverLicense);
        shipper.setDriverLicenseImage(driverLicenseImageBytes);
        shipper.setVehicleInfo(vehicleInfo);
        shipper.setPassword(hashedPassword);
        shipper.setStatusId(2); // pending
        shipper.setCreatedAt(Timestamp.from(Instant.now()));

        // Save shipper to database
        ShipperDAO shipperDAO = new ShipperDAO();
        boolean success = shipperDAO.insertShipper(shipper);

        if (success) {
            session.invalidate();
            request.getRequestDispatcher("/WEB-INF/views/approval/awaiting_approval.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to create account. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/google/shipper_profile_completion.jsp").forward(request,
                    response);
        }
    }
}
