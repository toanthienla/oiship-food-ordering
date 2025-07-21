package controller.auth;

import dao.CustomerDAO;
import dao.OTPDAO;
import dao.SecurityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String verified = request.getParameter("verified");
        if ("true".equals(verified)) {
            processRegistration(request, response);
            return;
        }

        // Check for remember_me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("email".equals(cookie.getName())) {
                    request.setAttribute("email", cookie.getValue());
                    break;
                }
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String rememberMe = request.getParameter("remember_me");

        if (fullName == null || email == null || phone == null || address == null || password == null || confirmPassword == null) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        String hashedPassword = SecurityDAO.hashPassword(password);
        Customer customer = new Customer(0, phone, address);
        CustomerDAO customerDAO = new CustomerDAO();

        try {
            boolean inserted = customerDAO.insertCustomer(customer, fullName, email, hashedPassword);
            if (!inserted) {
                request.setAttribute("error", "Account creation failed, account already exists email or phone please try with another email or phone.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }

            int customerId = customer.getCustomerID();

            // Lưu tạm vào session để xử lý sau khi verify
            HttpSession session = request.getSession(true);
            session.setAttribute("regFullName", fullName);
            session.setAttribute("regEmail", email);
            session.setAttribute("regCustomerId", customerId);

            // Ghi cookie nếu remember_me
            if ("on".equals(rememberMe)) {
                Cookie emailCookie = new Cookie("email", email);
                emailCookie.setMaxAge(30 * 24 * 60 * 60); // 30 ngày
                emailCookie.setPath(request.getContextPath());
                response.addCookie(emailCookie);
            } else {
                Cookie emailCookie = new Cookie("email", "");
                emailCookie.setMaxAge(0);
                emailCookie.setPath(request.getContextPath());
                response.addCookie(emailCookie);
            }

            // Chuyển sang trang verify
            response.sendRedirect("verify?verified=true");

        } catch (RuntimeException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }

    private void processRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("register");
            return;
        }

        String fullName = (String) session.getAttribute("regFullName");
        String email = (String) session.getAttribute("regEmail");
        Integer customerId = (Integer) session.getAttribute("regCustomerId");

        if (fullName == null || email == null || customerId == null) {
            response.sendRedirect("register");
            return;
        }

        // Cập nhật OTP customerId
        OTPDAO otpDAO = new OTPDAO();
        otpDAO.updateOtpCustomerId(email, customerId);

        // Xóa session tạm
        session.removeAttribute("regFullName");
        session.removeAttribute("regEmail");
        session.removeAttribute("regCustomerId");

        // Lưu session đăng nhập
        session.setAttribute("userId", customerId);
        session.setAttribute("role", "customer");
        session.setAttribute("email", email);
        session.setAttribute("userName", fullName);

        response.sendRedirect("home");
    }
}
