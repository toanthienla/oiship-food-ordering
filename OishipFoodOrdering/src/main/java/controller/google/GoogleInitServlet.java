package controller.google;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/google-init")
public class GoogleInitServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String role = request.getParameter("role");
        if (role == null) {
            response.sendRedirect("login");
            return;
        }

        // Tạo link đến Google OAuth
        String oauthURL = "https://accounts.google.com/o/oauth2/auth"
            + "?scope=email%20profile%20openid"
            + "&redirect_uri=http://localhost:9090/OishipFoodOrdering/google-register"
            + "&response_type=code"
            + "&client_id=867859741686-1u47odeeuukpntrhnroar7694gdajp4t.apps.googleusercontent.com"
            + "&approval_prompt=force"
            + "&state=" + role;

        response.sendRedirect(oauthURL);
    }
}
