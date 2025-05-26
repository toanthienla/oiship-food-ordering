package controller.auth;

import dao.AccountDAO;
import dao.OTPDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.OTP;
import org.mindrot.jbcrypt.BCrypt;
import utils.EmailService;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;

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
            setErrorAndReturn("Role is required.", request, response);
            return;
        }

        role = role.trim().toLowerCase();
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        String cccd = null;
        String license = null;
        String numberPlate = null;
        Part licenseImagePart = null;

        if (role.equals("shipper")) {
            cccd = request.getParameter("cccd");
            license = request.getParameter("driver_license");
            numberPlate = request.getParameter("vehicle_info");
            try {
                licenseImagePart = request.getPart("driver_license_image");
            } catch (IllegalStateException | IOException | ServletException e) {
                // handle gracefully
                licenseImagePart = null;
            }
        }

        AccountDAO accountDAO = new AccountDAO();
        String error = null;

        if (accountDAO.isEmailOrPhoneExists(email, phone)) {
            error = "Email or phone already exists.";
        } else if (!password.equals(confirmPassword)) {
            error = "Passwords do not match.";
        } else if (role.equals("shipper")
                && (cccd == null || cccd.isBlank()
                || license == null || license.isBlank()
                || numberPlate == null || numberPlate.isBlank()
                || licenseImagePart == null || licenseImagePart.getSize() == 0)) {
            error = "Shipper must provide CCCD, driver license, number plate, and image.";
        }

        if (error != null) {
            setErrorAndReturn(error, request, response);
            return;
        }

        Account account = new Account();
        account.setAccountName(name);
        account.setEmail(email);
        account.setPhone(phone);
        account.setAddress(address);
        account.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
        account.setRole(capitalize(role));
        account.setAccountCreatedAt(Timestamp.from(Instant.now()));
        account.setLatitude(null);
        account.setLongitude(null);

        switch (role) {
            case "customer":
                account.setStatus("not_verified");
                break;
            case "shipper":
            case "restaurant":
            case "restaurantmanager":
                account.setStatus("pending_approval");
                break;
            default:
                setErrorAndReturn("Invalid role.", request, response);
                return;
        }

        if (role.equals("shipper")) {
            account.setCccd(cccd);
            account.setLicense(license);
            account.setNumberPlate(numberPlate);

            if (licenseImagePart != null && licenseImagePart.getSize() > 0) {
                try (InputStream input = licenseImagePart.getInputStream()) {
                    account.setLicenseImage(input.readAllBytes());
                }
            }
        }

        int userId = accountDAO.insertAccountAndReturnId(account);
        if (userId == -1) {
            setErrorAndReturn("Registration failed. Please try again.", request, response);
            return;
        }

        // Send OTP
        String[] otp = EmailService.generateAndSendVerification(email, name);
        if (otp != null) {
            OTP otpEntity = new OTP(0, otp[1], otp[0],
                    LocalDateTime.now(),
                    LocalDateTime.now().plusMinutes(5),
                    false,
                    userId
            );
            new OTPDAO().insertOTP(otpEntity);
        }

        HttpSession session = request.getSession();
        session.setAttribute("userId", userId);
        session.setAttribute("role", role);

        response.sendRedirect("verify");
    }

    private void setErrorAndReturn(String message, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    private String capitalize(String str) {
        if (str == null || str.isEmpty()) {
            return str;
        }
        return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }

    @Override
    public String getServletInfo() {
        return "Handles unified registration for Customer, Shipper, and RestaurantManager roles";
    }
}
