<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // KHÔNG cần khai báo HttpSession session = request.getSession(false);
    // Session mặc định đã có sẵn trong JSP

    String email = (String) session.getAttribute("oauth_email");
    String name = (String) session.getAttribute("oauth_name");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Google Account Verification</title>
    </head>
    <body>

        <h2>Confirm Your Google Account</h2>

        <% if (email != null && name != null) {%>
        <p><strong>Email:</strong> <%= email%></p>
        <p><strong>Name:</strong> <%= name%></p>

        <form action="verify" method="post">
            <input type="text" name="code" placeholder="Enter verification code" required/>
            <button type="submit">Verify</button>
        </form>
        <% } else { %>
        <p style="color: red;">Session expired or invalid. Please login again.</p>
        <a href="login">Back to Login</a>
        <% } %>

        <% if (request.getAttribute("error") != null) {%>
        <p style="color: red;"><%= request.getAttribute("error")%></p>
        <% }%>

    </body>
</html>
