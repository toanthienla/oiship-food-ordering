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
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
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
        response.sendRedirect(request.getContextPath() + "/customer/order");

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String deleteIdParam = request.getParameter("reviewID");
        if (deleteIdParam != null) {
            try {
                int reviewID = Integer.parseInt(deleteIdParam);
                ReviewDAO reviewDAO = new ReviewDAO();
                reviewDAO.deleteReviewById(reviewID);
          
                String orderID = request.getParameter("orderID");
                if (orderID != null) {
                        response.sendRedirect(request.getContextPath() + "/customer/view-review");
                } else {
                    response.sendRedirect(request.getContextPath() + "/customer/order");
                }
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/customer/order");
                return;
            } catch (SQLException ex) {
                Logger.getLogger(ViewReviewServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        String odidParam = request.getParameter("orderID");
        if (odidParam == null) {
            response.sendRedirect(request.getContextPath() + "/customer/order");
            return;
        }

        try {
            int odid = Integer.parseInt(odidParam);

            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> review = reviewDAO.getReviewsByOrderId(odid);

            request.setAttribute("reviews", review);
            request.setAttribute("orderID", odid);

            request.getRequestDispatcher("/WEB-INF/views/customer/view_review.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customer/order");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
