<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Admin Login - Oiship</title>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
        <style>
            body {
                background: linear-gradient(135deg, rgba(0, 123, 255, 0.8), rgba(255, 255, 255, 0.5)),
                    url('images/background.jpg') no-repeat center center fixed;
                background-size: cover;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                margin: 0;
                padding: 0;
                font-family: 'Poppins', sans-serif;
                overflow: hidden;
            }

            .logo {
                position: absolute;
                top: 30px;
                left: 30px;
                height: 50px;
                transition: transform 0.3s ease;
            }

            .logo:hover {
                transform: scale(1.1);
            }

            .login-container {
                max-width: 450px;
                width: 100%;
                padding: 0 15px;
                animation: slideUp 0.8s ease-out forwards;
            }

            .login-card {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
                padding: 2.5rem;
                position: relative;
                overflow: hidden;
                backdrop-filter: blur(5px);
            }

            .login-card::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: linear-gradient(45deg, rgba(0, 123, 255, 0.1), transparent);
                transform: rotate(45deg);
                animation: shimmer 6s infinite linear;
            }

            .login-title {
                font-size: 2rem;
                font-weight: 700;
                color: #1a1a1a;
                text-align: center;
                margin-bottom: 1.5rem;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                animation: fadeIn 1s ease-in;
            }

            .form-floating input {
                border-radius: 8px;
                border: 1px solid #ced4da;
                transition: all 0.3s ease;
            }

            .form-floating input:focus {
                border-color: #007bff;
                box-shadow: 0 0 10px rgba(0, 123, 255, 0.2);
                transform: scale(1.02);
            }

            .form-floating label {
                color: #555;
                transition: all 0.3s ease;
            }

            .btn-login {
                background: #007bff;
                border: none;
                padding: 12px;
                border-radius: 8px;
                font-weight: 600;
                position: relative;
                overflow: hidden;
                transition: all 0.3s ease;
            }

            .btn-login:hover {
                background: #0056b3;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 123, 255, 0.4);
            }

            .btn-login:active {
                transform: translateY(0);
                box-shadow: 0 2px 5px rgba(0, 123, 255, 0.2);
            }

            .btn-login:disabled {
                background: #cccccc;
                cursor: not-allowed;
            }

            .btn-login .spinner-border {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                display: none;
            }

            .btn-login.loading .spinner-border {
                display: inline-block;
            }

            .btn-login.loading span {
                visibility: hidden;
            }

            .error-alert {
                animation: shake 0.5s ease;
                font-size: 0.9rem;
                background: #f8d7da;
                color: #721c24;
                border-radius: 8px;
                padding: 10px;
                margin-top: 1rem;
                display: flex;
                align-items: center;
            }

            /* Animations */
            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes shake {
                0%, 100% {
                    transform: translateX(0);
                }
                10%, 30%, 50%, 70%, 90% {
                    transform: translateX(-5px);
                }
                20%, 40%, 60%, 80% {
                    transform: translateX(5px);
                }
            }

            @keyframes shimmer {
                0% {
                    transform: translateX(-100%) rotate(45deg);
                }
                100% {
                    transform: translateX(100%) rotate(45deg);
                }
            }

            @media (max-width: 576px) {
                .login-container {
                    padding: 0 10px;
                }
                .login-card {
                    padding: 1.5rem;
                }
                .login-title {
                    font-size: 1.5rem;
                }
                .logo {
                    top: 20px;
                    left: 20px;
                    height: 40px;
                }
            }
        </style>
    </head>
    <body>
        <a href="/OishipFoodOrdering">
            <img src="images/logo_1.png" alt="Oiship Logo" class="logo" />
        </a>

        <div class="login-container">
            <div class="login-card">
                <h1 class="login-title">Admin Login</h1>
                <form action="${pageContext.request.contextPath}/admin/login" method="POST" class="login-form" id="loginForm">
                    <div class="form-floating mb-3">
                        <input type="email" class="form-control" name="email" id="email" placeholder="name@example.com" required>
                        <label for="email">Email</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
                        <label for="password">Password</label>
                    </div>
                    <button type="submit" class="btn btn-login w-100" id="loginButton">
                        <span>Login</span>
                        <div class="spinner-border spinner-border-sm text-light" role="status"></div>
                    </button>
                </form>

                <!-- Error alert -->
                <c:if test="${not empty error and error != ''}">
                    <div class="alert alert-danger error-alert">
                        <i class="bi bi-exclamation-circle me-2"></i>${error}
                    </div>
                </c:if>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Add loading effect on form submission
            document.getElementById('loginForm').addEventListener('submit', function (e) {
                const loginButton = document.getElementById('loginButton');
                loginButton.classList.add('loading');
                loginButton.disabled = true;
            });

            // Fade-in animation for the logo
            window.addEventListener('load', function () {
                document.querySelector('.logo').style.opacity = '1';
            });
        </script>
    </body>
</html>