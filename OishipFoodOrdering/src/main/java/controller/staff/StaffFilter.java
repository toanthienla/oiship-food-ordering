package controller.staff;

import controller.admin.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")
public class StaffFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // Exclude /admin/login from authentication
        boolean isLoginPage = uri.equals(contextPath + "/customer/login");
        HttpSession session = req.getSession(false);
        boolean isLoggedIn = session != null && session.getAttribute("staff") != null;
        
//        if (isLoggedIn || isLoginPage) {
            chain.doFilter(request, response);
//        } else {
//            res.sendRedirect(contextPath + "/admin/login");
//        }
    }
}
