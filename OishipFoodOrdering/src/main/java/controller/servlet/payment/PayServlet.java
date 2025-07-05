package controller.servlet.payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * A custom Servlet for handling HTTP requests.
 */
@WebServlet(name = "PayServlet", value = "/customer/fee")
public class PayServlet extends HttpServlet {
    Logger logger = LoggerFactory.getLogger(PayServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/customer/PayHome.html").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST not supported.");
    }

    @Override
    public void destroy() {
        logger.info("PayServlet destroyed.");
    }
}
