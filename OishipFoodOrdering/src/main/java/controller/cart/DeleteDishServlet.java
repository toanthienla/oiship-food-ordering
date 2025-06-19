///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package controller.cart;
//
//import dao.CartDAO;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
///**
// *
// * @author Phi Yen
// */
//@WebServlet(name = "DeleteDishServlet", urlPatterns = {"/customer/delete-dish"})
//public class DeleteDishServlet extends HttpServlet {
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet DeleteDishServlet</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet DeleteDishServlet at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }
//
//   
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("userId") == null) {
//            // Chưa đăng nhập -> chuyển về trang login
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
//
//        String cartIdStr = request.getParameter("cartID");
//        if (cartIdStr == null || cartIdStr.isEmpty()) {
//            request.setAttribute("error", "Không tìm thấy món để xóa.");
//            request.getRequestDispatcher("/customer/view-cart").forward(request, response);
//            return;
//        }
//
//        try {
//            int cartID = Integer.parseInt(cartIdStr);
//            CartDAO cartDAO = new CartDAO();
//            cartDAO.deleteCartItem(cartID);
//            // Xóa thành công, chuyển về trang giỏ hàng
//            response.sendRedirect(request.getContextPath() + "/customer/view-cart");
//        } catch (NumberFormatException e) {
//            request.setAttribute("error", "Mã giỏ hàng không hợp lệ.");
//            request.getRequestDispatcher("/customer/view-cart").forward(request, response);
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "Lỗi khi xóa món khỏi giỏ hàng.");
//            request.getRequestDispatcher("/customer/view-cart").forward(request, response);
//        }
//
//    }
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
