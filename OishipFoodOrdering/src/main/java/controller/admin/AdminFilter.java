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
        boolean isLoggedIn = session != null && session.getAttribute("admin") != null;
        
//        if (isLoggedIn || isLoginPage) {
            chain.doFilter(request, response);
//        } else {
//            res.sendRedirect(contextPath + "/admin/login");
//        }
    }
}
