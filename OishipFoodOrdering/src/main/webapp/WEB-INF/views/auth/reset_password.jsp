<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String email = (String) session.getAttribute("reset_email");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Khôi phục mật khẩu</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css"/>
    </head>
    <body class="container mt-5">
        <h2>Khôi phục mật khẩu</h2>

        <p>Email tài khoản: <strong><%= email != null ? email : "Không rõ"%></strong></p>

        <form method="post" action="password-recovery" class="mt-4">
            <div class="mb-3">
                <label for="otp" class="form-label">Mã xác nhận (OTP)</label>
                <input type="text" class="form-control" name="otp" required/>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Mật khẩu mới</label>
                <input type="password" class="form-control" name="password" required/>
            </div>
            <div class="mb-3">
                <label for="confirm" class="form-label">Nhập lại mật khẩu</label>
                <input type="password" class="form-control" name="confirm" required/>
            </div>
            <button type="submit" class="btn btn-success">Xác nhận và đặt lại mật khẩu</button>
        </form>

    <c:if test="${not empty error}">
        <div class="alert alert-danger mt-3">${error}</div>
    </c:if>
</body>
</html>
