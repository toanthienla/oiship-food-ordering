package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "OtpServlet", urlPatterns = {"/Otpservlet"})
public class OtpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("oauth_code") == null
                || session.getAttribute("codeExpiryTime") == null
                || session.getAttribute("oauth_email") == null
                || session.getAttribute("oauth_role") == null) {

            response.sendRedirect("login");
            return;
        }

        String inputCode = request.getParameter("code");
        if (inputCode == null || inputCode.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the verification code.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        String sessionCode = (String) session.getAttribute("oauth_code");
        long expiryTime = (long) session.getAttribute("codeExpiryTime");
        long currentTime = System.currentTimeMillis();

        if (currentTime > expiryTime) {
            request.setAttribute("error", "Verification code has expired.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        if (!inputCode.equals(sessionCode)) {
            request.setAttribute("error", "Incorrect verification code.");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify.jsp").forward(request, response);
            return;
        }

        // Mã đúng, xóa OTP khỏi session để tránh reuse
        session.removeAttribute("oauth_code");
        session.removeAttribute("codeExpiryTime");

        // Tiếp tục tới trang nhập profile
        response.sendRedirect("profile-completion");
    }

    @Override
    public String getServletInfo() {
        return "OtpServlet - Handles OTP verification from Google login";
    }
}
