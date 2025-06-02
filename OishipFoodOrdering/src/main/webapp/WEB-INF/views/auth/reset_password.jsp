<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt lại mật khẩu</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <style>
            body {
                background-color: #f8f9fa;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .reset-container {
                max-width: 400px;
                background: white;
                padding: 2rem;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>
        <div class="reset-container">
            <h3 class="text-center mb-4">Đặt lại mật khẩu</h3>
            <!-- Hiển thị email -->
            <p class="text-center mb-4">Đặt lại mật khẩu cho: <strong>${requestScope.email}</strong></p>
            <!-- Hiển thị lỗi nếu có -->
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger text-center">${requestScope.error}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/password-recovery" method="post" onsubmit="return validateForm()">
                <div class="row gy-3 justify-content-center">
                    <div class="col-12">
                        <div class="form-floating">
                            <input
                                type="text"
                                class="form-control rounded-3"
                                name="otp"
                                id="otp"
                                placeholder="Mã OTP"
                                required
                                />
                            <label for="otp">Mã OTP</label>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="form-floating">
                            <input
                                type="password"
                                class="form-control rounded-3"
                                name="password"
                                id="password"
                                placeholder="Mật khẩu mới"
                                required
                                />
                            <label for="password">Mật khẩu mới</label>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="form-floating">
                            <input
                                type="password"
                                class="form-control rounded-3"
                                name="confirm"
                                id="confirm"
                                placeholder="Xác nhận mật khẩu"
                                required
                                />
                            <label for="confirm">Xác nhận mật khẩu</label>
                        </div>
                    </div>
                    <div class="col-12 text-center">
                        <button class="btn btn-primary w-50 rounded-3 py-2" type="submit">
                            <i class="bi bi-key-fill me-2"></i>Đặt lại mật khẩu
                        </button>
                    </div>
                </div>
            </form>
            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
            </div>
        </div>

        <script>
            function validateForm() {
                const password = document.getElementById("password").value;
                const confirm = document.getElementById("confirm").value;
                if (password !== confirm) {
                    alert("Mật khẩu không khớp!");
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>