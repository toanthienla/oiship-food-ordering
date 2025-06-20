package controller.customer;

import dao.CustomerProfileDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import java.io.IOException;

@WebServlet(name = "EditProfileCustomerServlet", urlPatterns = {"/customer/profile/edit-profile"})
public class EditProfileCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = (String) request.getSession().getAttribute("email");
        if (email != null) {
            CustomerProfileDAO cus = new CustomerProfileDAO();
            Customer customer = cus.getCustomerByEmail(email);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_edit_profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = (String) request.getSession().getAttribute("email");

        String newName = request.getParameter("fullName");
        String newPhone = request.getParameter("phone");
        String newAddress = request.getParameter("address");

        if (email != null &&
            newName != null && !newName.trim().isEmpty() &&
            newPhone != null && !newPhone.trim().isEmpty() &&
            newAddress != null && !newAddress.trim().isEmpty()) {

            CustomerProfileDAO cus = new CustomerProfileDAO();
            boolean success = cus.editCustomerInfoByEmail(email, newName, newPhone, newAddress);

            if (success) {
                request.getSession().setAttribute("userName", newName); // Cập nhật tên trên navbar
                request.setAttribute("message", "Profile updated successfully.");
            } else {
                request.setAttribute("error", "Failed to update profile.");
            }

            Customer updatedCustomer = cus.getCustomerByEmail(email);
            request.setAttribute("customer", updatedCustomer);
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_edit_profile.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_edit_profile.jsp").forward(request, response);
        }
    }
}
