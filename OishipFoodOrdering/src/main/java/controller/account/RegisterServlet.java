package controller.account;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import model.RestaurantManager;
import model.Shipper;
import org.apache.commons.codec.digest.DigestUtils;
import org.mindrot.jbcrypt.BCrypt;
import utils.EmailService;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
@MultipartConfig(maxFileSize = 2 * 1024 * 1024)
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        if (role == null) {
            request.setAttribute("error", "Role is required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        role = role.toLowerCase();
        if ("customer".equals(role)) {
            handleCustomerRegistration(request, response);
        } else if ("restaurant".equals(role)) {
            handleRestaurantRegistration(request, response);
        } else if ("shipper".equals(role)) {
            handleShipperRegistration(request, response);
        } else {
            request.setAttribute("error", "Invalid role.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }

    private void handleCustomerRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        CustomerDAO customerDAO = new CustomerDAO();
        String error = null;
        int userId = -1;

        if (customerDAO.isEmailOrPhoneExists(email, phone)) {
            error = "Email or phone already exists.";
        } else if (!password.equals(confirmPassword)) {
            error = "Passwords do not match.";
        } else {
            Customer customer = new Customer();
            customer.setName(name);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setAddress(address);
            customer.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            customer.setStatusId(0); // not verified
            customer.setCreatedAt(Timestamp.from(Instant.now()));
            userId = customerDAO.insertCustomerAndReturnId(customer);
        }

        handlePostRegistrationResponse(error, userId, email, name, request, response, "customer");
    }

    private void handleRestaurantRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        RestaurantManagerDAO restaurantDAO = new RestaurantManagerDAO();
        String error = null;
        int userId = -1;

        if (restaurantDAO.isEmailOrPhoneExists(email, phone)) {
            error = "Email or phone already exists.";
        } else if (!password.equals(confirmPassword)) {
            error = "Passwords do not match.";
        } else {
            RestaurantManager restaurant = new RestaurantManager();
            restaurant.setName(name);
            restaurant.setEmail(email);
            restaurant.setPhone(phone);
            restaurant.setAddress(address);
            restaurant.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            restaurant.setStatusId(2); // pending approval
            restaurant.setCreatedAt(Timestamp.from(Instant.now()));
            userId = restaurantDAO.insertRestaurantAndReturnId(restaurant);
        }

        handlePostRegistrationResponse(error, userId, email, name, request, response, "restaurant");
    }

    private void handleShipperRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String cccd = request.getParameter("cccd");
        String driverLicense = request.getParameter("driver_license");
        Part licenseImage = request.getPart("driver_license_image");

        ShipperDAO shipperDAO = new ShipperDAO();
        String error = null;
        int userId = -1;

        if (shipperDAO.isEmailOrPhoneExists(email, phone)) {
            error = "Email or phone already exists.";
        } else if (!password.equals(confirmPassword)) {
            error = "Passwords do not match.";
        } else if (licenseImage == null || licenseImage.getSize() == 0) {
            error = "Driver license image is required.";
        } else {
            Shipper shipper = new Shipper();
            shipper.setName(name);
            shipper.setEmail(email);
            shipper.setPhone(phone);
            shipper.setAddress(address);
            shipper.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            shipper.setCccd(cccd);
            shipper.setDriverLicense(driverLicense);
            shipper.setCreatedAt(Timestamp.from(Instant.now()));
            shipper.setStatusId(2); // pending approval
            userId = shipperDAO.insertShipperAndReturnId(shipper, licenseImage);
        }

        handlePostRegistrationResponse(error, userId, email, name, request, response, "shipper");
    }

    private void handlePostRegistrationResponse(String error, int userId, String email, String name,
                                                HttpServletRequest request, HttpServletResponse response, String role)
            throws ServletException, IOException {

        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        if (userId == -1) {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        String code = String.valueOf(100000 + new java.util.Random().nextInt(900000));
        String hashedCode = DigestUtils.md5Hex(code);

        VerificationDAO verificationDAO = new VerificationDAO();
        verificationDAO.saveVerificationCode(userId, code, hashedCode, role);

        EmailService.sendVerificationEmail(email, name, code);

        HttpSession session = request.getSession();
        session.setAttribute("role", role);
        session.setAttribute("userId", userId);

        response.sendRedirect("verify");
    }

    @Override
    public String getServletInfo() {
        return "Handles registration view and logic";
    }
}
