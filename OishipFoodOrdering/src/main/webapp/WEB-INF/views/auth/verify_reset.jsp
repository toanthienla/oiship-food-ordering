<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Verify Reset Code</title>
    <link rel="stylesheet" href="css/bootstrap.css">
</head>
<body class="container mt-5">
    <h2 class="mb-4">Xác nhận mã đặt lại mật khẩu</h2>

    <%
        String email = (String) session.getAttribute("reset_email");
        if (email == null) {
            email = (String) session.getAttribute("oauth_email");
        }
        String role = (String) session.getAttribute("reset_role");
        if (role == null) {
            role = (String) session.getAttribute("oauth_role");
        }
    %>

    <p>Chúng tôi đã gửi mã xác nhận đến email: <strong><%= email %></strong></p>

    <form action="verify-reset" method="post">
        <div class="mb-3">
            <label for="code" class="form-label">Mã xác nhận (6 chữ số)</label>
            <input type="text" class="form-control" name="code" id="code" required maxlength="6">
        </div>
        <button type="submit" class="btn btn-primary">Xác nhận</button>
    </form>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger mt-3"><%= request.getAttribute("error") %></div>
    <% } %>
</body>
</html>
