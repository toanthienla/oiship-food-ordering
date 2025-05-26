package controller.google;

import dao.AccountDAO;
import dao.GoogleOAuthDAO;
import dao.OTPDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Account;
import model.GoogleAccount;
import model.OTP;
import utils.EmailService;

import java.io.IOException;

@WebServlet(name = "GoogleOAuthServlet", urlPatterns = {"/login-google"})
public class GoogleOAuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String resend = request.getParameter("resend");

        if ("true".equalsIgnoreCase(resend)) {
            handleResendOtp(request, response, session);
            return;
        }

        String code = request.getParameter("code");
        String roleParam = request.getParameter("state");

        if (code == null || roleParam == null) {
            response.sendRedirect("login?error=oauth_missing_data");
            return;
        }

        try {
            String token = GoogleOAuthDAO.getToken(code);
            GoogleAccount user = GoogleOAuthDAO.getUserInfo(token);

            if (user == null || user.getEmail() == null) {
                response.sendRedirect("login?error=invalid_google_account");
                return;
            }

            // Normalize role to match DB values
            String normalizedRole = normalizeRoleName(roleParam);
            if (normalizedRole == null) {
                response.sendRedirect("login?error=invalid_role");
                return;
            }

            session.setAttribute("oauth_email", user.getEmail());
            session.setAttribute("oauth_name", user.getName());
            session.setAttribute("oauth_role", normalizedRole);

            AccountDAO accountDAO = new AccountDAO();
            Account existing = accountDAO.getAccountByEmailAndRole(user.getEmail(), normalizedRole);

            if (existing == null) {
                sendOtp(session, response, user.getEmail(), user.getName());
                return;
            }

            session.setAttribute("userId", existing.getAccountId());
            session.setAttribute("role", normalizedRole);

            if ("pending_approval".equalsIgnoreCase(existing.getStatus())) {
                request.getRequestDispatcher("/WEB-INF/views/approval/awaiting_approval.jsp").forward(request, response);
            } else {
                response.sendRedirect("home");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login?error=oauth_exception");
        }
    }

    private void sendOtp(HttpSession session, HttpServletResponse response, String email, String name) throws IOException {
        String[] otp = EmailService.generateAndSendVerification(email, name);

        if (otp != null) {
            OTP otpModel = new OTP(otp[1], otp[0], 0);
            new OTPDAO().insertOTP(otpModel);

            session.setAttribute("oauth_code", otp[0]);
            session.setAttribute("codeExpiryTime", System.currentTimeMillis() + 60 * 1000);

            response.sendRedirect("Otpservlet");
        } else {
            response.sendRedirect("login?error=otp_send_failed");
        }
    }

    private void handleResendOtp(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        String email = (String) session.getAttribute("oauth_email");
        String name = (String) session.getAttribute("oauth_name");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (email == null || name == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Session expired\"}");
            return;
        }

        String[] otp = EmailService.generateAndSendVerification(email, name);

        if (otp != null) {
            OTP otpModel = new OTP(otp[1], otp[0], 0);
            new OTPDAO().insertOTP(otpModel);

            session.setAttribute("oauth_code", otp[0]);
            session.setAttribute("codeExpiryTime", System.currentTimeMillis() + 60 * 1000);

            response.getWriter().write("{\"success\": true}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Failed to resend email\"}");
        }
    }

    // Converts frontend role parameter to DB-friendly format
    private String normalizeRoleName(String role) {
        if (role == null) {
            return null;
        }

        switch (role.toLowerCase()) {
            case "customer":
                return "Customer";
            case "shipper":
                return "Shipper";
            case "restaurant":
            case "restaurantmanager":
                return "RestaurantManager";
            case "admin":
                return "Admin";
            default:
                return null;
        }
    }
}
