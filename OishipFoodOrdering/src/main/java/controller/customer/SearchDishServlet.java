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
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Dish;

/**
 *
 * @author Phi Yen
 */
@WebServlet(name = "SearchDishServlet", urlPatterns = {"/customer/search-dish"})
public class SearchDishServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy yêu cầu từ session
        HttpSession session = request.getSession(false);
        String searchQuery = (String) session.getAttribute("searchQuery");  // Lấy searchQuery từ session

        List<Dish> menuItemList = (List<Dish>) session.getAttribute("menuItems");

        if (menuItemList == null) {
            request.setAttribute("message", "Không tìm thấy kết quả nào.");
        }

        // Truyền kết quả vào request
        request.setAttribute("menuItems", menuItemList);
        // Truyền searchQuery vào để hiển thị lại
        request.setAttribute("searchQuery", searchQuery);

        request.getRequestDispatcher("/WEB-INF/views/customer/search_dish.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");

        List<Dish> menuItemResults = new ArrayList<>();

        try {
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {

                DishDAO menuItemDAO = new DishDAO();
                menuItemResults = menuItemDAO.searchDishByName(searchQuery);
            }

            // Lưu yêu cầu( từ khóa tìm kiếm) vào session để sử dụng khi quay lại
            HttpSession session = request.getSession();
            session.setAttribute("searchQuery", searchQuery);

            session.setAttribute("menuItems", menuItemResults);

            // chuyểnđến trang search.jsp
            request.setAttribute("menuItems", menuItemResults);
            request.setAttribute("searchQuery", searchQuery);

            request.getRequestDispatcher("/WEB-INF/views/customer/search_dish.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi khi tìm kiếm nhà hàng và món ăn");
        }

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
