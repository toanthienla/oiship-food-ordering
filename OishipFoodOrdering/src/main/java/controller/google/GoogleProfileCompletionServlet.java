package controller.google;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.time.Instant;

@WebServlet(name = "GoogleProfileCompletionServlet", urlPatterns = {"/profile-completion"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class GoogleProfileCompletionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        try {
            String role = (session != null) ? (String) session.getAttribute("oauth_role") : null;

            if (role == null || role.isEmpty()) {
                request.setAttribute("error", "Invalid Role or Session Expired.");
                request.getRequestDispatcher("/WEB-INF/views/error/invalid_session.jsp").forward(request, response);
                return;
            }

            request.setAttribute("role", role.toLowerCase());
            request.getRequestDispatcher("/WEB-INF/views/google/profile_completion.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login?error=exception");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        try {
            if (session == null) {
                response.sendRedirect("login");
                return;
            }

            String email = (String) session.getAttribute("oauth_email");
            String sessionRole = (String) session.getAttribute("oauth_role");

            if (email == null || sessionRole == null) {
                response.sendRedirect("login");
                return;
            }

            String role = sessionRole.trim().toLowerCase();

            switch (role) {
                case "customer":
                    handleCustomer(request, response, email);
                    break;
                case "shipper":
                    handleShipper(request, response, email);
                    break;
                case "restaurant":
                case "restaurantmanager":
                    handleRestaurant(request, response, email);
                    break;
                default:
                    handleError(request, response, role, "Unsupported role: " + role);
            }
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, "unknown", "An unexpected error occurred.");
        }
    }

    private void handleCustomer(HttpServletRequest request, HttpServletResponse response, String email)
            throws ServletException, IOException {
        try {
            Account account = extractBasicInfo(request, email, "Customer", "active");
            if (account == null) {
                handleError(request, response, "customer", "All fields are required and passwords must match.");
                return;
            }
            insertAndRedirect(account, request, response, "customer");
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, "customer", "Error while creating customer account.");
        }
    }

    private void handleShipper(HttpServletRequest request, HttpServletResponse response, String email)
            throws ServletException, IOException {
        try {
            Account account = extractBasicInfo(request, email, "Shipper", "pending_approval");
            if (account == null || !handleShipperData(request, account)) {
                handleError(request, response, "shipper", "All shipper fields are required.");
                return;
            }
            insertAndRedirect(account, request, response, "shipper");
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, "shipper", "Error while creating shipper account.");
        }
    }

    private void handleRestaurant(HttpServletRequest request, HttpServletResponse response, String email)
            throws ServletException, IOException {
        try {
            Account account = extractBasicInfo(request, email, "RestaurantManager", "pending_approval");
            if (account == null) {
                handleError(request, response, "restaurant", "All fields are required and passwords must match.");
                return;
            }
            insertAndRedirect(account, request, response, "restaurant");
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, "restaurant", "Error while creating restaurant account.");
        }
    }

    private Account extractBasicInfo(HttpServletRequest request, String email, String role, String status) {
        try {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm_password");

            if (name == null || phone == null || address == null || password == null || confirmPassword == null
                    || !password.equals(confirmPassword) || !phone.matches("0\\d{9}")) {
                return null;
            }

            Account account = new Account();
            account.setEmail(email);
            account.setRole(role);
            account.setAccountCreatedAt(Timestamp.from(Instant.now()));
            account.setPassword(hashPassword(password));
            account.setAccountName(name);
            account.setPhone(phone);
            account.setAddress(address);
            account.setStatus(status);

            return account;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private boolean handleShipperData(HttpServletRequest request, Account account) {
        try {
            String cccd = request.getParameter("cccd");
            String license = request.getParameter("driver_license");
            String numberPlate = request.getParameter("vehicle_info");
            Part licenseImagePart = request.getPart("driver_license_image");

            if (cccd == null || license == null || numberPlate == null || licenseImagePart == null || licenseImagePart.getSize() == 0) {
                return false;
            }

            try (InputStream input = licenseImagePart.getInputStream()) {
                account.setCccd(cccd);
                account.setLicense(license);
                account.setNumberPlate(numberPlate);
                account.setLicenseImage(input.readAllBytes());
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    private void insertAndRedirect(Account account, HttpServletRequest request, HttpServletResponse response, String role)
            throws ServletException, IOException {
        try {
            AccountDAO dao = new AccountDAO();
            int newId = dao.insertAccountAndReturnId(account);

            if (newId > 0) {
                request.getSession().invalidate();
                if ("customer".equals(role)) {
                    HttpSession newSession = request.getSession(true);
                    newSession.setAttribute("userId", newId);
                    newSession.setAttribute("role", role);
                    response.sendRedirect("home");
                } else {
                    request.setAttribute("accountCreated", true);
                    request.getRequestDispatcher("/WEB-INF/views/approval/awaiting_approval.jsp").forward(request, response);
                }
            } else {
                handleError(request, response, role, "Failed to create account. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, role, "Error inserting account into database.");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String role, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.setAttribute("role", role);
        request.getRequestDispatcher("/WEB-INF/views/google/profile_completion.jsp").forward(request, response);
    }

    private String hashPassword(String password) {
        return (password != null) ? BCrypt.hashpw(password, BCrypt.gensalt(12)) : null;
    }
}
