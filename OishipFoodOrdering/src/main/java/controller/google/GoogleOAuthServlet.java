package controller.google;

import dao.GoogleOAuthDAO;
import dao.VerificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.GoogleAccount;
import org.apache.commons.codec.digest.DigestUtils;
import utils.EmailService;

import java.io.IOException;
import java.util.Random;

@WebServlet(name = "GoogleOAuthServlet", urlPatterns = { "/login-google" })
public class GoogleOAuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        String role = request.getParameter("state"); // customer, shipper, restaurant

        if (code == null || code.isEmpty()) {
            response.sendRedirect("login");
            return;
        }

        try {
            // 1. Get access token from Google using the authorization code
            String accessToken = GoogleOAuthDAO.getToken(code);

            // 2. Get user info from Google using the access token
            GoogleAccount user = GoogleOAuthDAO.getUserInfo(accessToken);

            if (user == null || user.getEmail() == null) {
                response.sendRedirect("login");
                return;
            }

            // 3. Send verification email
            String email = user.getEmail();
            String name = user.getName();
            String verificationCode = String.valueOf(100000 + new Random().nextInt(900000));
            EmailService.sendVerificationEmail(email, name, verificationCode);

            // 4. Save verification code to database
            String hashedCode = DigestUtils.md5Hex(verificationCode);
            VerificationDAO verificationDAO = new VerificationDAO();
            verificationDAO.saveVerificationCodeByEmail(email, hashedCode, verificationCode); // 👈 sửa dòng này nè!

            // 5. Set session attributes
            HttpSession session = request.getSession();
            session.setAttribute("oauth_email", email);
            session.setAttribute("oauth_name", name);
            session.setAttribute("oauth_code", verificationCode);
            session.setAttribute("oauth_role", role);

            // 6. Send redirect to verify page
            response.sendRedirect("verify");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login");
        }
    }
}
