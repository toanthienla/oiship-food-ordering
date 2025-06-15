/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

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
@WebServlet(name = "EditProfileServlet", urlPatterns = {"/staff/profile/edit-profile"})
public class EditProfileServlet extends HttpServlet {

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
            out.println("<title>Servlet EditProfileServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditProfileServlet at " + request.getContextPath() + "</h1>");
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
        String email = (String) request.getSession().getAttribute("email");
        if (email != null) {
            StaffDAO staffDAO = new StaffDAO();
            Staff staff = staffDAO.getStaffByEmail(email);
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/WEB-INF/views/staff/staff_edit_profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
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
        String email = (String) request.getSession().getAttribute("email");
        String newName = request.getParameter("fullName");

        if (email != null && newName != null && !newName.trim().isEmpty()) {
            StaffDAO staffDAO = new StaffDAO();
            boolean success = staffDAO.editStaffNameByEmail(email, newName);

            if (success) {
                // Cập nhật session luôn nếu thành công
                request.getSession().setAttribute("userName", newName);
                request.setAttribute("message", "Profile updated successfully.");
            } else {
                request.setAttribute("error", "Failed to update profile.");
            }

            // Lấy lại staff mới
            Staff updatedStaff = staffDAO.getStaffByEmail(email);
            request.setAttribute("staff", updatedStaff);
            request.getRequestDispatcher("/WEB-INF/views/staff/staff_edit_profile.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Invalid input.");
            request.getRequestDispatcher("/WEB-INF/views/staff/staff_edit_profile.jsp").forward(request, response);
        }
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
