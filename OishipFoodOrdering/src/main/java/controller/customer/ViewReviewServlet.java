/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dao.ReviewDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Review;

/**
 *
 * @author Phi Yen
 */
@WebServlet(name = "ViewReviewServlet", urlPatterns = {"/customer/view-review"})
public class ViewReviewServlet extends HttpServlet {

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
            out.println("<title>Servlet ViewReviewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewReviewServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

 
        
           @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể redirect hoặc ẩn hoàn toàn tùy bạn
        response.sendRedirect(request.getContextPath() + "/customer/order");
    
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        String odidParam = request.getParameter("orderID");
        if (odidParam == null) {
            response.sendRedirect(request.getContextPath() + "/customer/order");
            return;
        }

        try {
            int odid = Integer.parseInt(odidParam);

            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> review = reviewDAO.getReviewsByOrderId(odid);

            if (review != null) {
                request.setAttribute("reviews", review);
                request.getRequestDispatcher("/WEB-INF/views/customer/view_review.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/order");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customer/order");
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
