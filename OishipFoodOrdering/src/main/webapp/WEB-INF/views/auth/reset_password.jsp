<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt lại mật khẩu - Oishop Food</title>
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
                overflow-x: hidden;
                overflow-y: auto;
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
            h1, p, .reset-card {
                position: relative;
                z-index: 5;
            }

            h1 {
                margin-top: 20px;
                color: #fff;
                text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                animation: fadeInDown 1.2s ease-out;
                font-weight: 600;
                font-size: 2.5rem;
            }

            p {
                color: #fff;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                animation: fadeIn 1.4s ease-out;
                font-weight: 400;
                margin-bottom: 15px;
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

            /* Reset card */
            .reset-card {
                max-width: 450px;
                width: 100%;
                border-radius: 20px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
                animation: zoomIn 1s ease-out;
                margin-top: 15px;
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .inner-card {
                border-radius: 16px;
                padding: 30px 25px;
            }

            /* Form styling */
            .form-floating input {
                border: 2px solid #FFE4C4;
                border-radius: 10px;
                transition: all 0.3s ease;
                font-weight: 400;
                background: rgba(255, 255, 255, 0.9);
                padding: 12px 16px;
                font-size: 1rem;
            }

            .form-floating {
                margin-bottom: 20px;
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
            .btn-reset {
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

            .btn-reset::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }

            .btn-reset:hover::before {
                left: 100%;
            }

            .btn-reset:hover {
                background: linear-gradient(135deg, #FF7F50, #FF8C69);
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(255, 140, 105, 0.4);
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

            /* Email display box */
            .email-display {
                background: linear-gradient(135deg, #FFF8E1, #FFECB3);
                border: 2px solid #FFD180;
                border-radius: 10px;
                padding: 12px;
                text-align: center;
                margin-bottom: 15px;
                animation: fadeIn 1s ease-out;
                font-size: 0.9rem;
            }

            .email-display strong {
                color: #FF8C69;
                font-weight: 600;
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
                
                .reset-card {
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
                
                .form-floating {
                    margin-bottom: 15px;
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
        <div class="bg-logo-text">OISHIP FOOD</div>

        <a href="/OishipFoodOrdering">
            <img src="images/logov2.png" alt="Oishop Logo" class="logo" />
        </a>

        <h1 class="display-4 fw-bold">Reset Password</h1>
        <p class="mt-3 fs-5">Please enter information to reset your password</p>

        <div class="reset-card">
            <div class="inner-card">
                <!-- Hiển thị email -->
                <div class="email-display">
                    <i class="bi bi-envelope-check me-2"></i>
                    Reset password for: <strong>${requestScope.email}</strong>
                </div>

                <!-- Hiển thị lỗi -->
                <c:if test="${not empty requestScope.error}">
                    <div class="alert alert-danger error-alert">
                        <i class="bi bi-exclamation-circle me-2"></i>
                        ${requestScope.error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/password-recovery" method="post" onsubmit="return validateForm()" class="reset-form">
                    <div class="form-floating mb-4">
                        <input type="text" class="form-control" name="otp" id="otp" placeholder="Mã OTP" required>
                        <label for="otp"><i class="bi bi-key me-2"></i>OTP Code</label>
                    </div>
                    
                    <div class="form-floating mb-4">
                        <input type="password" class="form-control" name="password" id="password" placeholder="Mật khẩu mới" required>
                        <label for="password"><i class="bi bi-lock me-2"></i>New Password</label>
                    </div>
                    
                    <div class="form-floating mb-4">
                        <input type="password" class="form-control" name="confirm" id="confirm" placeholder="Xác nhận mật khẩu" required>
                        <label for="confirm"><i class="bi bi-lock-fill me-2"></i>Confirm Password</label>
                    </div>
                    
                    <button class="btn btn-reset w-100 fs-6 mb-3" type="submit">
                        <i class="bi bi-key-fill me-2"></i>Reset Password
                    </button>
                    
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-back w-100 d-flex align-items-center justify-content-center">
                        <i class="bi bi-arrow-left me-2"></i>Back to login
                    </a>
                </form>
            </div>
        </div>

        <script>
            function validateForm() {
                const password = document.getElementById("password").value;
                const confirm = document.getElementById("confirm").value;
                if (password !== confirm) {
                    // Create custom alert
                    const alertDiv = document.createElement('div');
                    alertDiv.className = 'alert alert-danger error-alert mt-3';
                    alertDiv.innerHTML = '<i class="bi bi-exclamation-circle me-2"></i>Passwords do not match!';
                    
                    // Remove existing alerts
                    const existingAlert = document.querySelector('.alert');
                    if (existingAlert && !existingAlert.classList.contains('email-display')) {
                        existingAlert.remove();
                    }
                    
                    // Add new alert
                    document.querySelector('.inner-card').insertBefore(alertDiv, document.querySelector('form'));
                    
                    // Remove alert after 3 seconds
                    setTimeout(() => {
                        alertDiv.remove();
                    }, 3000);
                    
                    return false;
                }
                return true;
            }

            // Add loading animation to reset button
            document.querySelector('.reset-form').addEventListener('submit', function(e) {
                const btn = document.querySelector('.btn-reset');
                if (validateForm()) {
                    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status"></span>Processing...';
                    btn.disabled = true;
                }
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

            // Password strength indicator
            document.getElementById('password').addEventListener('input', function() {
                const password = this.value;
                const strength = getPasswordStrength(password);
                
                // Remove existing indicator
                let indicator = document.querySelector('.password-strength');
                if (indicator) indicator.remove();
                
                if (password.length > 0) {
                    indicator = document.createElement('div');
                    indicator.className = 'password-strength mt-2 small';
                    indicator.innerHTML = `<i class="bi bi-shield-${strength.icon} me-2"></i>${strength.text}`;
                    indicator.style.color = strength.color;
                    this.parentElement.appendChild(indicator);
                }
            });

            function getPasswordStrength(password) {
                if (password.length < 6) {
                    return { icon: 'exclamation', text: 'Password too short', color: '#FF6B6B' };
                } else if (password.length < 8) {
                    return { icon: 'check', text: 'Average Password', color: '#FFB347' };
                } else if (password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)) {
                    return { icon: 'check-all', text: 'Strong password', color: '#4ECDC4' };
                } else {
                    return { icon: 'check', text: 'Pretty good password', color: '#FF8C69' };
                }
            }
        </script>
    </body>
</html>