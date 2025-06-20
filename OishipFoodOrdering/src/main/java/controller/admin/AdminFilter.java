package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // Exclude /admin/login from authentication
        boolean isLoginPage = uri.equals(contextPath + "/admin/login");
        HttpSession session = req.getSession(false);
        boolean isLoggedIn = session != null && "admin".equals(session.getAttribute("role")); // Check role
        
        System.out.println("DEBUG: Filter - URI=" + uri + ", isLoginPage=" + isLoginPage + ", isLoggedIn=" + isLoggedIn +
                ", role=" + (session != null ? session.getAttribute("role") : "null"));

        if (isLoggedIn || isLoginPage) {
            chain.doFilter(request, response);
        } else {
            System.out.println("DEBUG: Redirecting to /admin/login due to unauthorized access");
            res.sendRedirect(contextPath + "/admin/login");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}