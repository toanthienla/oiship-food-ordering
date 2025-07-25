<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Login - Oishop Food</title>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="css/bootstrap.css" />
        <script src="js/bootstrap.bundle.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: linear-gradient(135deg, #FFE4C4 0%, #FFA07A 25%, #FF8C69 50%, #FFB347 75%, #FFDAB9 100%);
                background-size: 300% 300%;
                animation: gradientFlow 12s ease infinite;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                font-family: 'Poppins', sans-serif;
                position: relative;
                overflow: hidden;
            }

            /* Floating particles animation */
            .particles {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                overflow: hidden;
                z-index: 1;
            }

            .particle {
                position: absolute;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 50%;
                animation: float 6s ease-in-out infinite;
            }

            .particle:nth-child(1) { width: 80px; height: 80px; left: 10%; animation-delay: 0s; }
            .particle:nth-child(2) { width: 60px; height: 60px; left: 20%; animation-delay: 2s; }
            .particle:nth-child(3) { width: 100px; height: 100px; left: 35%; animation-delay: 4s; }
            .particle:nth-child(4) { width: 70px; height: 70px; left: 70%; animation-delay: 1s; }
            .particle:nth-child(5) { width: 90px; height: 90px; left: 80%; animation-delay: 3s; }

            /* Background logo text */
            .bg-logo-text {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                font-size: 8rem;
                font-weight: 700;
                color: rgba(255, 255, 255, 0.03);
                user-select: none;
                pointer-events: none;
                z-index: 1;
                animation: logoFloat 8s ease-in-out infinite;
                text-shadow: 0 0 20px rgba(255, 255, 255, 0.05);
            }

            /* Gradient flow animation */
            @keyframes gradientFlow {
                0% { background-position: 0% 50%; }
                50% { background-position: 100% 50%; }
                100% { background-position: 0% 50%; }
            }

            @keyframes float {
                0%, 100% { transform: translateY(0px) rotate(0deg); }
                33% { transform: translateY(-30px) rotate(120deg); }
                66% { transform: translateY(30px) rotate(240deg); }
            }

            @keyframes logoFloat {
                0%, 100% { transform: translate(-50%, -50%) scale(1); opacity: 0.03; }
                50% { transform: translate(-50%, -50%) scale(1.05); opacity: 0.05; }
            }

            /* Logo */
            .logo {
                position: absolute;
                top: 30px;
                left: 30px;
                height: 50px;
                animation: bounceIn 1s ease-out;
                z-index: 10;
                filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1));
            }

            /* Main content */
            h1, p, .login-card, a.logo {
                position: relative;
                z-index: 5;
            }

            h1 {
                margin-top: 40px;
                color: #fff;
                text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                animation: fadeInDown 1.2s ease-out;
                font-weight: 600;
            }

            p {
                color: #fff;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                animation: fadeIn 1.4s ease-out;
                font-weight: 400;
            }

            p a {
                color: #fff;
                text-decoration: underline;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            p a:hover {
                color: #FFE4C4;
                text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
            }

            /* Login card */
            .login-card {
                max-width: 1000px;
                width: 100%;
                border-radius: 25px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                animation: zoomIn 1s ease-out;
                margin-top: 30px;
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .inner-card {
                border-radius: 20px;
                padding: 40px;
            }

            /* Form styling */
            .form-floating input {
                border: 2px solid #FFE4C4;
                border-radius: 12px;
                transition: all 0.3s ease;
                font-weight: 400;
                background: rgba(255, 255, 255, 0.9);
            }

            .form-floating input:focus {
                border-color: #FF8C69;
                box-shadow: 0 0 0 0.2rem rgba(255, 140, 105, 0.25);
                background: #fff;
                transform: translateY(-2px);
            }

            .form-floating label {
                color: #FF8C69;
                font-weight: 500;
            }

            /* Buttons */
            .btn-login {
                background: linear-gradient(135deg, #FF8C69, #FFA07A);
                border: none;
                color: #fff;
                font-weight: 600;
                border-radius: 12px;
                padding: 12px 24px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(255, 140, 105, 0.3);
                position: relative;
                overflow: hidden;
            }

            .btn-login::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }

            .btn-login:hover::before {
                left: 100%;
            }

            .btn-login:hover {
                background: linear-gradient(135deg, #FF7F50, #FF8C69);
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(255, 140, 105, 0.4);
            }

            .btn-social {
                background: linear-gradient(135deg, #FF6347, #FF7F50);
                border: none;
                color: #fff;
                font-weight: 500;
                border-radius: 12px;
                padding: 12px 24px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(255, 99, 71, 0.3);
            }

            .btn-social:hover {
                background: linear-gradient(135deg, #FF4500, #FF6347);
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(255, 99, 71, 0.4);
            }

            .btn-back {
                background: linear-gradient(135deg, #FFB347, #FFA07A);
                border: none;
                color: #fff;
                font-weight: 500;
                border-radius: 12px;
                padding: 12px 24px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(255, 179, 71, 0.3);
            }

            .btn-back:hover {
                background: linear-gradient(135deg, #FF9500, #FFB347);
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(255, 179, 71, 0.4);
            }

            /* Form check */
            .form-check-input:checked {
                background-color: #FF8C69;
                border-color: #FF8C69;
            }

            /* Divider */
            .divider {
                position: relative;
                text-align: center;
                margin: 20px 0;
            }

            .divider::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 1px;
                background: linear-gradient(90deg, transparent, #FFB347, transparent);
            }

            .divider span {
                background: #fff;
                padding: 0 20px;
                color: #FF8C69;
                font-weight: 500;
            }

            /* Alert styling */
            .error-alert {
                animation: slideInUp 0.5s ease-out;
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .alert-danger {
                background: linear-gradient(135deg, #FF6B6B, #FF8E53);
                color: #fff;
            }

            .alert-success {
                background: linear-gradient(135deg, #4ECDC4, #44A08D);
                color: #fff;
            }

            /* Animations */
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            @keyframes fadeInDown {
                from { opacity: 0; transform: translateY(-30px); }
                to { opacity: 1; transform: translateY(0); }
            }

            @keyframes zoomIn {
                from { opacity: 0; transform: scale(0.8); }
                to { opacity: 1; transform: scale(1); }
            }

            @keyframes bounceIn {
                0% { opacity: 0; transform: scale(0.3); }
                50% { opacity: 1; transform: scale(1.05); }
                70% { transform: scale(0.9); }
                100% { transform: scale(1); }
            }

            @keyframes slideInUp {
                from { opacity: 0; transform: translateY(30px); }
                to { opacity: 1; transform: translateY(0); }
            }

            /* Responsive */
            @media (max-width: 768px) {
                .bg-logo-text {
                    font-size: 4rem;
                }
                
                .login-card {
                    margin: 20px;
                }
                
                .inner-card {
                    padding: 30px 20px;
                }
                
                .logo {
                    top: 20px;
                    left: 20px;
                    height: 40px;
                }
                
                h1 {
                    font-size: 2rem;
                    margin-top: 30px;
                }
            }

            @media (max-width: 576px) {
                .bg-logo-text {
                    font-size: 3rem;
                }
                
                .inner-card {
                    padding: 20px 15px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Floating particles -->
        <div class="particles">
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
        </div>

        <!-- Background logo text -->
        <div class="bg-logo-text">OISHOP FOOD</div>

        <a href="/OishipFoodOrdering">
            <img src="images/logov2.png" alt="Oishop Logo" class="logo" />
        </a>

        <h1 class="display-4 fw-bold">Welcome to Oishop Food!</h1>
        <p class="mt-3 fs-5">Don't have an account? <a href="register">Create one now</a></p>

        <div class="login-card">
            <div class="inner-card">
                <div class="row gy-4 justify-content-center align-items-center">
                    <div class="col-12 col-lg-5">
                        <form action="login" method="POST" class="login-form">
                            <div class="form-floating mb-4">
                                <input type="email" class="form-control" name="email" id="email" placeholder="name@example.com" required>
                                <label for="email"><i class="bi bi-envelope me-2"></i>Email Address</label>
                            </div>
                            <div class="form-floating mb-4">
                                <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
                                <label for="password"><i class="bi bi-lock me-2"></i>Password</label>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div class="form-check">
                                    <input type="checkbox" name="remember_me" class="form-check-input" id="remember">
                                    <label class="form-check-label" for="remember">Remember me</label>
                                </div>
                                <a href="#" onclick="submitForgot()" class="text-decoration-none" style="color: #FF8C69; font-weight: 500;">Forgot password?</a>
                            </div>
                            <button class="btn btn-login w-100 fs-6" type="submit">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
                            </button>
                        </form>
                    </div>
                    
                    <div class="col-12 col-lg-2 d-flex align-items-center justify-content-center">
                        <div class="divider w-100">
                            <span>or</span>
                        </div>
                    </div>
                    
                    <div class="col-12 col-lg-5">
                        <a href="google-init?role=customer" class="btn btn-social w-100 d-flex align-items-center justify-content-center mb-3">
                            <i class="bi bi-google me-2"></i>Continue with Google
                        </a>
                        <a href="/OishipFoodOrdering" class="btn btn-back w-100 d-flex align-items-center justify-content-center">
                            <i class="bi bi-house-door-fill me-2"></i>Back to Home
                        </a>
                    </div>
                </div>

                <!-- Error or Success alert -->
                <c:if test="${not empty error or not empty success}">
                    <div class="alert ${not empty error ? 'alert-danger' : 'alert-success'} error-alert mt-4 rounded-3">
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

            // Add loading animation to login button
            document.querySelector('.login-form').addEventListener('submit', function(e) {
                const btn = document.querySelector('.btn-login');
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status"></span>Signing in...';
                btn.disabled = true;
            });

            // Enhanced input focus effects
            document.querySelectorAll('.form-floating input').forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.classList.add('focused');
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.classList.remove('focused');
                });
            });
        </script>
    </body>
</html>