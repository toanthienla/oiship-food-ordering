    package controller.customer;

    import dao.CartDAO;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.*;
    import java.io.IOException;
    import java.util.List;
    import model.Cart;

    @WebServlet(name = "ViewCartServlet", urlPatterns = {"/customer/view-cart"})
    public class ViewCartServlet extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int customerID = (int) session.getAttribute("userId");

            try {
                CartDAO cartDAO = new CartDAO();
                List<Cart> cartItems = cartDAO.getCartByCustomerId(customerID);

                request.setAttribute("cartItems", cartItems);

                request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Unable to display the cart.");
                request.getRequestDispatcher("/WEB-INF/views/customer/view_cart.jsp").forward(request, response);
            }
        }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            try {
                CartDAO cartDAO = new CartDAO();            
                String cartIdStr = request.getParameter("cartID");
                String quantityStr = request.getParameter("quantity");

                if (cartIdStr != null && quantityStr != null) {
                    int cartID = Integer.parseInt(cartIdStr);
                    int quantity = Integer.parseInt(quantityStr);
                    if (quantity < 1) {
                        quantity = 1;
                    }

                    int stock = cartDAO.getDishStockByCartId(cartID);
                    if (quantity > stock) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.setContentType("application/json");
                        response.getWriter().write("{\"error\":\"Quantity exceeds available stock. Only " + stock + " items left.\"}");
                        return;
                    }

                    cartDAO.updateCartQuantity(cartID, quantity);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"message\":\"Quantity updated successfully.\"}");
                    return;
                }

                if (cartIdStr != null) {
                    int cartID = Integer.parseInt(cartIdStr);
                    cartDAO.deleteCartItem(cartID);
                    response.sendRedirect(request.getContextPath() + "/customer/view-cart");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Failed to process cart operation.\"}");
            }
        }
    }
