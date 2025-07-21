package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Date;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        boolean isLoginPage = uri.equals(contextPath + "/admin/login");
        boolean isDeleteCustomer = uri.equals(contextPath + "/admin/deleteCustomer");
        boolean isDeleteStaff = uri.equals(contextPath + "/admin/deleteStaff");
        HttpSession session = req.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        boolean isLoggedIn = session != null && "admin".equals(role);

        // Debug logging
        System.out.println("DEBUG: AdminFilter - URI=" + uri + ", isLoginPage=" + isLoginPage
                + ", isDeleteCustomer=" + isDeleteCustomer + ", isDeleteStaff=" + isDeleteStaff
                + ", isLoggedIn=" + isLoggedIn + ", role=" + (role != null ? role : "null")
                + ", time=" + new Date());

        try {
            if (isLoginPage || isDeleteCustomer || isDeleteStaff || isLoggedIn) {
                chain.doFilter(request, response);
            } else {
                System.out.println("DEBUG: Redirecting to /admin/login due to unauthorized access at " + new Date());
                res.sendRedirect(contextPath + "/admin/login");
            }
        } catch (Exception e) {
            System.out.println("ERROR: AdminFilter failed to process request for URI=" + uri
                    + ", error=" + e.getMessage() + ", time=" + new Date());
            e.printStackTrace();
            res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal Server Error");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AdminFilter initialized at " + new Date());
    }

    @Override
    public void destroy() {
        System.out.println("AdminFilter destroyed at " + new Date());
    }
}