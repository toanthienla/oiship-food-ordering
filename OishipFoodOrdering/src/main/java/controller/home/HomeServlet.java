package controller.home;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null || session.getAttribute("userId") == null) {
            // Nếu chưa đăng nhập, hiển thị trang home công khai
            request.getRequestDispatcher("/WEB-INF/views/home/home.jsp").forward(request, response);
            return;
        }

        String role = ((String) session.getAttribute("role")).toLowerCase();
        redirectByRole(response, session, role);
    }

    private void redirectByRole(HttpServletResponse response, HttpSession session, String role) throws IOException {
        switch (role) {
            case "customer":
                response.sendRedirect("customer/dashboard");
                break;
            case "shipper":
                response.sendRedirect("shipper/dashboard");
                break;
            case "restaurant":
                response.sendRedirect("restaurant/dashboard");

            case "admin":
                response.sendRedirect("admin");
                break;
            default:
                session.invalidate();
                response.sendRedirect("login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
