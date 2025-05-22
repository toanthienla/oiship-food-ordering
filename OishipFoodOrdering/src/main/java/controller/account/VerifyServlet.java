package controller.account;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import model.Shipper;
import model.RestaurantManager;
import org.apache.commons.codec.digest.DigestUtils;

import java.io.IOException;

@WebServlet(name = "VerifyServlet", urlPatterns = { "/verify" })
public class VerifyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login");
            return;
        }

        String inputCode = request.getParameter("code");
        if (inputCode == null || inputCode.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the verification code.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        String oauthEmail = (String) session.getAttribute("oauth_email");
        String oauthCode = (String) session.getAttribute("oauth_code");
        String oauthRole = (String) session.getAttribute("oauth_role");

        if (oauthEmail != null && oauthCode != null && oauthRole != null) {
            if (!inputCode.equals(oauthCode)) {
                request.setAttribute("error", "Incorrect verification code.");
                request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
                return;
            }

            session.removeAttribute("oauth_code");

            if ("customer".equals(oauthRole)) {
                CustomerDAO customerDAO = new CustomerDAO();
                Customer c = customerDAO.getCustomerByEmail(oauthEmail);
                if (c != null) {
                    session.setAttribute("role", "customer");
                    session.setAttribute("userId", c.getCustomerId());
                    cleanOAuthSession(session);
                    response.sendRedirect("home");
                } else {
                    response.sendRedirect("customer-profile-completion");
                }

            } else if ("shipper".equals(oauthRole)) {
                ShipperDAO shipperDAO = new ShipperDAO();
                Shipper s = shipperDAO.getShipperByEmail(oauthEmail);
                if (s != null) {
                    session.setAttribute("role", "shipper");
                    session.setAttribute("userId", s.getShipperId());
                    cleanOAuthSession(session);
                    response.sendRedirect("home");
                } else {
                    response.sendRedirect("shipper-profile-completion");
                }

            } else if ("restaurant".equals(oauthRole)) {
                RestaurantManagerDAO restaurantDAO = new RestaurantManagerDAO();
                RestaurantManager r = restaurantDAO.getRestaurantByEmail(oauthEmail);
                if (r != null) {
                    session.setAttribute("role", "restaurant");
                    session.setAttribute("userId", r.getRestaurantId());
                    cleanOAuthSession(session);
                    response.sendRedirect("home");
                } else {
                    response.sendRedirect("restaurantmanager-profile-completion");
                }

            } else {
                response.sendRedirect("login");
            }

            return;
        }

        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        if (role == null || userId == null) {
            response.sendRedirect("login");
            return;
        }

        String hashedCode = DigestUtils.md5Hex(inputCode);
        VerificationDAO verificationDAO = new VerificationDAO();

        if (verificationDAO.verifyCode(role, userId, hashedCode)) {
            UserDAO userDAO = new UserDAO();
            userDAO.updateStatus(role, userId, 1); // 1 = active
            verificationDAO.markCodeAsUsed(role, userId, hashedCode);
            session.removeAttribute("verify_code");
            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Invalid or expired verification code.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
        }
    }

    private void cleanOAuthSession(HttpSession session) {
        session.removeAttribute("oauth_email");
        session.removeAttribute("oauth_name");
        session.removeAttribute("oauth_role");
        session.removeAttribute("oauth_code");
    }

    @Override
    public String getServletInfo() {
        return "Handles email verification for both OAuth and regular signup";
    }
}
