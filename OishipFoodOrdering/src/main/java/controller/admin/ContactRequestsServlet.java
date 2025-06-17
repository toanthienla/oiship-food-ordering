package controller.admin;

import dao.ContactDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Contact;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/contact-requests")
public class ContactRequestsServlet extends HttpServlet {

    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Contact> contacts = contactDAO.getAllContacts();
        request.setAttribute("contacts", contacts);
        request.getRequestDispatcher("/WEB-INF/views/admin/contact_requests.jsp").forward(request, response);
    }
}
