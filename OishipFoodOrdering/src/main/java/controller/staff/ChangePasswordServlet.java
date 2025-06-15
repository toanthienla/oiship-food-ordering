/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.SecurityDAO;
import dao.StaffDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Staff;

/**
 *
 * @author HCT
 */
@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/staff/profile/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ChangePasswordServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePasswordServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/staff/staff_change_password.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
        StaffDAO staffDAO = new StaffDAO();
        Staff staff = staffDAO.getStaffByEmail(email);

        if (staff == null) {
            request.setAttribute("error", "Staff not found.");
            request.getRequestDispatcher("/WEB-INF/views/staff/staff_change_password.jsp").forward(request, response);
            return;
        }

        boolean isCurrentPasswordValid = SecurityDAO.checkPassword(currentPassword, staff.getPassword());
        if (!isCurrentPasswordValid) {
            request.setAttribute("error", "Current password is incorrect.");
            request.getRequestDispatcher("/WEB-INF/views/staff/staff_change_password.jsp").forward(request, response);
            return;
        }

        // Bước 4: So sánh newPassword và confirmPassword
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match.");
            request.getRequestDispatcher("/WEB-INF/views/staff/staff_change_password.jsp").forward(request, response);
            return;
        }

        // Bước 5: Cập nhật mật khẩu mới nếu hợp lệ
        boolean success = staffDAO.changePasswordStaffByEmail(email, newPassword);

        // Bước 6: Thông báo
        if (success) {
            request.setAttribute("message", "Password changed successfully.");
        } else {
            request.setAttribute("error", "Failed to change password. Please try again.");
        }

        request.getRequestDispatcher("/WEB-INF/views/staff/staff_change_password.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
