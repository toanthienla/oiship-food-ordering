<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Login - Oiship</title>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="css/bootstrap.css" />
        <script src="js/bootstrap.bundle.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
        <style>
            body {
                background: linear-gradient(45deg, #ff6f61, #ffcc5c, #6b48ff, #ff6f61);
                background-size: 400% 400%;
                animation: gradientFlow 15s ease infinite;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                margin: 0;
                padding: 0;
                font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                position: relative;
                overflow: hidden;
            }

            /* Hiệu ứng chuyển động nền */
            @keyframes gradientFlow {
                0% {
                    background-position: 0% 0%;
                }
                50% {
                    background-position: 100% 100%;
                }
                100% {
                    background-position: 0% 0%;
                }
            }

            /* Lớp phủ để làm mờ nền và tăng độ tương phản */
            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.3);
                z-index: 1;
            }

            /* Đảm bảo nội dung nằm trên lớp phủ */
            h1, p, .login-card, a.logo {
                position: relative;
                z-index: 2;
            }

            .logo {
                position: absolute;
                top: 20px;
                left: 20px;
                height: 45px;
                animation: bounceIn 0.8s ease-out;
            }

            h1 {
                margin-top: 80px;
                animation: fadeInDown 1s ease-out;
            }

            p {
                animation: fadeIn 1.2s ease-out;
            }

            .login-card {
                max-width: 900px;
                width: 100%;
                border-radius: 20px;
                background: rgba(255, 255, 255, 0.95);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                animation: zoomIn 0.8s ease-out;
                margin-top: 20px;
            }

            .inner-card {
                box-shadow: none;
                border-radius: 10px;
                padding: 30px;
            }

            .btn-login, .btn-social, .btn-back {
                transition: background 0.3s, box-shadow 0.3s, transform 0.3s;
                padding: 10px;
                border-radius: 5px;
                font-weight: 500;
            }

            .btn-login:hover, .btn-social:hover, .btn-back:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }

            .btn-login {
                background: #007bff;
                border: none;
                color: #ffffff;
            }

            .btn-login:hover {
                background: #0056b3;
            }

            .btn-social {
                background: #dc3545;
                color: #ffffff;
                border: none;
            }

            .btn-social:hover {
                background: #c82333;
            }

            .btn-back {
                background: #6c757d;
                color: #ffffff;
                border: none;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .btn-back:hover {
                background: #5a6268;
            }

            .error-alert {
                animation: fadeIn 0.5s ease-out;
                font-size: 0.9rem;
                margin-top: 20px;
            }

            /* Hiệu ứng động */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes zoomIn {
                from {
                    opacity: 0;
                    transform: scale(0.9);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            @keyframes bounceIn {
                0% {
                    opacity: 0;
                    transform: scale(0.3);
                }
                50% {
                    opacity: 1;
                    transform: scale(1.05);
                }
                70% {
                    transform: scale(0.9);
                }
                100% {
                    transform: scale(1);
                }
            }

            /* Hiệu ứng hover cho input */
            .form-floating input {
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .form-floating input:focus {
                border-color: #007bff;
                box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
            }

            @media (max-width: 576px) {
                .login-card {
                    margin: 10px;
                }
                .inner-card {
                    padding: 20px;
                }
                .logo {
                    top: 10px;
                }
                h1 {
                    margin-top: 60px;
                    font-size: 1.8rem;
                }
                .btn-back {
                    padding: 8px;
                    font-size: 0.9rem;
                }
            }
        </style>
    </head>
    <body>
        <a href="/OishipFoodOrdering">
            <img src="images/logo_1.png" alt="Oiship Logo" class="logo" />
        </a>

        <h1 class="display-5 fw-bold text-white">Welcome to Oiship!</h1>
        <p class="text-white mt-2">Don't have an account? <a href="register" class="text-decoration-none text-white">Sign up</a></p>

        <div class="login-card">
            <div class="m-4 inner-card">
                <div class="row gy-4 justify-content-center align-items-center">
                    <div class="col-12 col-lg-5">
                        <form action="login" method="POST" class="login-form">
                            <div class="form-floating mb-3">
                                <input type="email" class="form-control" name="email" id="email" placeholder="name@example.com" required>
                                <label for="email">Email</label>
                            </div>
                            <div class="form-floating mb-3">
                                <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
                                <label for="password">Password</label>
                            </div>
                            <div class="d-flex justify-content-between mb-3">
                                <div class="form-check">
                                    <input type="checkbox" name="remember_me" class="form-check-input" />
                                    <label class="form-check-label">Remember me</label>
                                </div>
                                <div><a href="#" onclick="submitForgot()" class="text-decoration-none">Forgot password?</a></div>
                            </div>
                            <button class="btn btn-login w-100" type="submit">Login</button>
                        </form>
                    </div>
                    <div class="col-12 col-lg-2 d-flex align-items-center justify-content-center">
                        <span class="text-muted">or</span>
                    </div>
                    <div class="col-12 col-lg-5">
                        <a href="google-init?role=customer" class="btn btn-social w-100 d-flex align-items-center justify-content-center mb-2">
                            <i class="bi bi-google me-2"></i>Sign in with Google
                        </a>
                        <a href="/OishipFoodOrdering" class="btn btn-back w-100 d-flex align-items-center justify-content-center">
                            <i class="bi bi-house-door-fill me-2"></i>Back to Home
                        </a>
                    </div>
                </div>

                <!-- Error or Success alert (only shown when present) -->
                <c:if test="${not empty error or not empty success}">
                    <div class="alert ${not empty error ? 'alert-danger' : 'alert-success'} error-alert mx-4 rounded-3 mt-3">
                        <i class="bi ${not empty error ? 'bi-exclamation-circle' : 'bi-check-circle'} me-2"></i>
                        ${not empty error ? error : success}
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Hidden forgot form -->
        <form id="forgotForm" action="password-recovery" method="POST" style="display:none;">
            <input type="hidden" name="email" id="forgot_email">
        </form>

        <script>
            function submitForgot() {
                const email = document.getElementById("email").value.trim();
                if (!email) {
                    alert("Please enter your email first.");
                    return;
                }
                document.getElementById("forgot_email").value = email;
                document.getElementById("forgotForm").submit();
            }
        </script>
    </body>
</html>