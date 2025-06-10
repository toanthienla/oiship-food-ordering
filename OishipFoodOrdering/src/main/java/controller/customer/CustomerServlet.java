package controller.customer;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;

import java.io.IOException;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer"})
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"customer".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        AccountDAO dao = new AccountDAO();

        Customer customer = dao.getCustomerByEmail((String) session.getAttribute("email")); // Sử dụng email từ session
        if (customer != null && "customer".equalsIgnoreCase(customer.getRole())) {
            request.setAttribute("account", customer);
            request.setAttribute("userName", customer.getFullName());
        } else {
            request.setAttribute("error", "Account not found or not a customer.");
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/customer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}