package controller.admin;

import dao.CategoryDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Category;

@WebServlet(urlPatterns = {"/admin/manage-categories"})
public class ManageCategoriesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        CategoryDAO dao = new CategoryDAO();

        if (action != null && idParam != null) {
            int id = Integer.parseInt(idParam);

            switch (action) {
                case "delete":
                    boolean deleted = dao.deleteCategoryById(id);
                    response.sendRedirect("manage-categories?success=" + (deleted ? "delete" : "false"));
                    return;
            }
        }

        // Default behavior - list all categories
        List<Category> categories = dao.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/manage_categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String catIDStr = request.getParameter("catID");
        String catName = request.getParameter("catName");
        String catDescription = request.getParameter("catDescription");

        CategoryDAO dao = new CategoryDAO();

        String status;

        if (catIDStr != null && !catIDStr.isEmpty()) {
            // Update existing category
            int catID = Integer.parseInt(catIDStr);
            Category updated = new Category(catID, catName, catDescription);
            status = dao.updateCategory(updated) ? "edit" : "false";
        } else {
            // Add new category
            Category newCat = new Category(catName, catDescription);
            status = dao.addCategory(newCat) ? "add" : "false";
        }

        response.sendRedirect("manage-categories?success=" + status);
    }
}
