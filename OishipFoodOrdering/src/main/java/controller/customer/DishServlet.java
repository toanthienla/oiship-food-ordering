/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dao.DishDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Dish;

/**
 *
 * @author Phi Yen
 */
@WebServlet(name = "DishServlet", urlPatterns = {"/guest/dish"})
public class DishServlet extends HttpServlet {

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
            out.println("<title>Servlet DishServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DishServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        String dishIdParam = request.getParameter("dishId");

        if (dishIdParam != null) {
            try {
                int dishId = Integer.parseInt(dishIdParam);
                DishDAO dao = new DishDAO();
                Dish dish = dao.getDishById(dishId);

                if (dish != null) {
                    request.setAttribute("dish", dish);
                    request.getRequestDispatcher("/WEB-INF/views/customer/dish_detail.jsp").forward(request, response);
                } else {
                    // Dish không tìm thấy
                    request.setAttribute("errorMessage", "Món ăn không tồn tại.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }

            } catch (NumberFormatException e) {
                // ID không hợp lệ
                request.setAttribute("errorMessage", "ID món ăn không hợp lệ.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } else {
            // Thiếu tham số dishId
            request.setAttribute("errorMessage", "Thiếu thông tin món ăn.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
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
