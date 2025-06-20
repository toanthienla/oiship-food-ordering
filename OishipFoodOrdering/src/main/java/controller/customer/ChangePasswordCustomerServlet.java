/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;


import dao.CustomerProfileDAO;
import dao.SecurityDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;



@WebServlet(name = "ChangePasswordCustomerServlet", urlPatterns = {"/customer/profile/change-password"})
public class ChangePasswordCustomerServlet extends HttpServlet {

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/customer/customer_change_password.jsp").forward(request, response);
    }

   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Bước 1: Nhận email từ session
        String email = (String) request.getSession().getAttribute("email");
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Bước 2: Lấy thông tin từ form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Bước 3: Kiểm tra mật khẩu hiện tại có đúng không
        CustomerProfileDAO customer = new CustomerProfileDAO();
       Customer cus = customer.getCustomerByEmail(email);

        if (cus == null) {
            request.setAttribute("error", "Customer not found.");
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_change_password.jsp").forward(request, response);
            return;
        }

        boolean isCurrentPasswordValid = SecurityDAO.checkPassword(currentPassword, cus.getPassword());
        if (!isCurrentPasswordValid) {
            request.setAttribute("error", "Current password is incorrect.");
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_change_password.jsp").forward(request, response);
            return;
        }

        // Bước 4: So sánh newPassword và confirmPassword
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match.");
            request.getRequestDispatcher("/WEB-INF/views/customer/customer_change_password.jsp").forward(request, response);
            return;
        }

        // Bước 5: Cập nhật mật khẩu mới nếu hợp lệ
        boolean success = customer.changePasswordCustomerByEmail(email, newPassword);

        // Bước 6: Thông báo
        if (success) {
            request.setAttribute("message", "Password changed successfully.");
        } else {
            request.setAttribute("error", "Failed to change password. Please try again.");
        }

        request.getRequestDispatcher("/WEB-INF/views/customer/customer_change_password.jsp").forward(request, response);
    }

  
}
