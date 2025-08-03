<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Admin Login - Oishop Food</title>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
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
                align-items: stretch;
                justify-content: center;
                flex-direction: column;
                font-family: 'Poppins', sans-serif;
                position: relative;
                overflow: hidden;
                padding: 20px 0;
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

            /* Admin badge background */
            .admin-badge-bg {
                position: absolute;
                top: 60%;
                right: 15%;
                font-size: 2.5rem;
                font-weight: 600;
                color: rgba(255, 120, 70, 0.1);
                transform: rotate(-15deg);
                user-select: none;
                pointer-events: none;
                z-index: 1;
                animation: adminBadgeFloat 6s ease-in-out infinite;
            }

            /* Animations */
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

            @keyframes adminBadgeFloat {
                0%, 100% { transform: rotate(-15deg) scale(1); opacity: 0.1; }
                50% { transform: rotate(-12deg) scale(1.1); opacity: 0.15; }
            }

            /* Logo */
            .logo {
                position: absolute;
                top: 20px;
                left: 20px;
                height: 45px;
                animation: bounceIn 1s ease-out;
                z-index: 10;
                filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1));
            }

            /* Header container */
            .header-section {
                text-align: center;
                margin-bottom: 20px;
                flex-shrink: 0;
            }

            /* Main content container */
            .main-content {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                width: 100%;
                max-width: 500px;
                margin: 0 auto;
                padding: 0 20px;
            }

            /* Main content */
            h1, p, .login-card, a.logo {
                position: relative;
                z-index: 5;
            }

            h1 {
                color: #fff;
                text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                animation: fadeInDown 1.2s ease-out;
                font-weight: 600;
                margin-bottom: 10px;
                font-size: 2.5rem;
            }

            .admin-subtitle {
                color: #fff;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                animation: fadeIn 1.4s ease-out;
                font-weight: 400;
                margin-bottom: 0;
                font-size: 1.1rem;
                opacity: 0.9;
            }

            .admin-badge {
                display: inline-block;
                background: linear-gradient(135deg, #FF6347, #FF8C69);
                color: white;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                margin-left: 10px;
                box-shadow: 0 2px 8px rgba(255, 99, 71, 0.3);
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.05); }
            }

            /* Login card */
            .login-card {
                width: 100%;
                border-radius: 25px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
                animation: zoomIn 1s ease-out;
                border: 1px solid rgba(255, 255, 255, 0.2);
                flex-shrink: 0;
                position: relative;
                overflow: hidden;
            }

            .login-card::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: linear-gradient(45deg, rgba(255, 140, 105, 0.1), transparent);
                transform: rotate(45deg);
                animation: shimmer 8s infinite linear;
            }

            .inner-card {
                border-radius: 20px;
                padding: 35px;
                position: relative;
                z-index: 2;
            }

            .login-title {
                font-size: 2rem;
                font-weight: 700;
                color: #FF6347;
                text-align: center;
                margin-bottom: 1.5rem;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                animation: fadeIn 1s ease-in;
                position: relative;
            }

            .login-title::after {
                content: '';
                display: block;
                width: 60px;
                height: 3px;
                background: linear-gradient(135deg, #FF8C69, #FFA07A);
                margin: 10px auto 0;
                border-radius: 2px;
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

            /* Admin login button */
            .btn-login {
                background: linear-gradient(135deg, #DC143C, #FF6347);
                border: none;
                color: #fff;
                font-weight: 600;
                border-radius: 12px;
                padding: 12px 24px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(220, 20, 60, 0.3);
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
                background: linear-gradient(135deg, #B22222, #DC143C);
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(220, 20, 60, 0.4);
            }

            .btn-login:active {
                transform: translateY(-1px);
                box-shadow: 0 4px 15px rgba(220, 20, 60, 0.3);
            }

            .btn-login:disabled {
                background: #cccccc;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            .btn-login.loading {
                pointer-events: none;
            }

            .btn-login .spinner-border {
                width: 1rem;
                height: 1rem;
                display: none;
            }

            .btn-login.loading .spinner-border {
                display: inline-block;
            }

            .btn-login.loading .btn-text {
                opacity: 0;
            }

            /* Alert styling */
            .error-alert {
                animation: slideInUp 0.5s ease-out;
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                background: linear-gradient(135deg, #FF6B6B, #FF8E53);
                color: #fff;
                margin-top: 20px;
                font-weight: 500;
            }

            /* Security indicator */
            .security-indicator {
                text-align: center;
                margin-top: 20px;
                padding: 15px;
                background: rgba(255, 140, 105, 0.1);
                border-radius: 10px;
                border-left: 4px solid #FF8C69;
            }

            .security-indicator i {
                color: #FF6347;
                font-size: 1.2rem;
                margin-right: 8px;
            }

            .security-indicator small {
                color: #666;
                font-weight: 500;
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

            @keyframes shimmer {
                0% { transform: translateX(-100%) rotate(45deg); }
                100% { transform: translateX(100%) rotate(45deg); }
            }

            /* Responsive */
            @media (max-width: 768px) {
                body {
                    padding: 15px 0;
                }
                
                .bg-logo-text {
                    font-size: 4rem;
                }
                
                .admin-badge-bg {
                    font-size: 1.8rem;
                }
                
                .main-content {
                    padding: 0 15px;
                }
                
                .logo {
                    top: 15px;
                    left: 15px;
                    height: 40px;
                }
                
                h1 {
                    font-size: 2rem;
                }
                
                .admin-subtitle {
                    font-size: 1rem;
                }
                
                .inner-card {
                    padding: 25px;
                }
                
                .login-title {
                    font-size: 1.6rem;
                }
            }

            @media (max-width: 576px) {
                body {
                    padding: 10px 0;
                }
                
                .bg-logo-text {
                    font-size: 3rem;
                }
                
                .admin-badge-bg {
                    font-size: 1.5rem;
                }
                
                .main-content {
                    padding: 0 10px;
                }
                
                .inner-card {
                    padding: 20px;
                }
                
                h1 {
                    font-size: 1.8rem;
                }
                
                .logo {
                    height: 35px;
                    top: 12px;
                    left: 12px;
                }
                
                .login-title {
                    font-size: 1.4rem;
                }
            }

            @media (min-height: 800px) {
                .header-section {
                    margin-bottom: 30px;
                }
            }

            @media (max-height: 700px) {
                .header-section {
                    margin-bottom: 15px;
                }
                
                h1 {
                    font-size: 2rem;
                }
                
                .admin-subtitle {
                    font-size: 0.95rem;
                }
                
                .inner-card {
                    padding: 25px;
                }
                
                .login-title {
                    font-size: 1.6rem;
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
        <div class="admin-badge-bg">ADMIN</div>

        <a href="/OishipFoodOrdering">
            <img src="../images/logov2.png" alt="Oishop Logo" class="logo" />
        </a>

        <div class="main-content">
            <div class="login-card">
                <div class="inner-card">
                    <h2 class="login-title">Admin Login</h2>
                    <form action="${pageContext.request.contextPath}/admin/login" method="POST" class="login-form" id="loginForm">
                        <div class="form-floating mb-4">
                            <input type="email" class="form-control" name="email" id="email" placeholder="admin@oishop.com" required>
                            <label for="email"><i class="bi bi-person-badge me-2"></i>Admin Email</label>
                        </div>
                        <div class="form-floating mb-4">
                            <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
                            <label for="password"><i class="bi bi-shield-lock me-2"></i>Admin Password</label>
                        </div>
                        <button type="submit" class="btn btn-login w-100 fs-6" id="loginButton">
                            <span class="btn-text">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Access Dashboard
                            </span>
                            <div class="spinner-border text-light" role="status"></div>
                        </button>
                    </form>

                    <div class="security-indicator">
                        <i class="bi bi-shield-check"></i>
                        <small>This is a secure admin area. All activities are logged.</small>
                    </div>

                    <!-- Error alert -->
                    <c:if test="${not empty error and error != ''}">
                        <div class="alert error-alert">
                            <i class="bi bi-exclamation-circle me-2"></i>${error}
                        </div>
                    </c:if>
                </div>
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

            // Enhanced input focus effects
            document.querySelectorAll('.form-floating input').forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.classList.add('focused');
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.classList.remove('focused');
                });
            });

            // Fade-in animation for the logo
            window.addEventListener('load', function () {
                document.querySelector('.logo').style.opacity = '1';
            });

            // Enhanced security check animation
            setTimeout(() => {
                document.querySelector('.security-indicator').style.animation = 'fadeIn 0.5s ease-out';
            }, 1500);
        </script>
    </body>
</html>