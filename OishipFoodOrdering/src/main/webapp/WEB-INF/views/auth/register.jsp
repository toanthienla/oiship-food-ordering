<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - Oiship</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: linear-gradient(135deg, #fff4e6 0%, #ffe0b3 50%, #ffcc80 100%);
                font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                overflow-x: hidden;
                padding: 20px 0;
            }

            /* Animated background particles */
            .background-particles {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                pointer-events: none;
                z-index: 1;
            }

            .particle {
                position: absolute;
                background: rgba(255, 152, 0, 0.1);
                border-radius: 50%;
                animation: float 6s ease-in-out infinite;
            }

            .particle:nth-child(1) { width: 20px; height: 20px; top: 20%; left: 10%; animation-delay: 0s; }
            .particle:nth-child(2) { width: 15px; height: 15px; top: 60%; left: 20%; animation-delay: 2s; }
            .particle:nth-child(3) { width: 25px; height: 25px; top: 30%; left: 80%; animation-delay: 4s; }
            .particle:nth-child(4) { width: 18px; height: 18px; top: 80%; left: 70%; animation-delay: 1s; }
            .particle:nth-child(5) { width: 22px; height: 22px; top: 10%; left: 60%; animation-delay: 3s; }
            .particle:nth-child(6) { width: 16px; height: 16px; top: 40%; left: 90%; animation-delay: 5s; }

            @keyframes float {
                0%, 100% { transform: translateY(0px) scale(1); }
                50% { transform: translateY(-20px) scale(1.1); }
            }

            .logo {
                position: absolute;
                top: 20px;
                left: 30px;
                height: 60px;
                z-index: 10;
                transition: transform 0.3s ease;
            }

            .logo:hover {
                transform: scale(1.05);
            }

            .register-container {
                position: relative;
                z-index: 5;
                animation: slideIn 0.8s ease-out;
                max-width: 900px;
                width: 100%;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .register-header {
                text-align: center;
                margin-bottom: 30px;
                animation: fadeInDown 1s ease-out;
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

            .register-header h1 {
                font-size: 2.5rem;
                color: #e65100;
                margin-bottom: 10px;
                font-weight: 700;
                text-shadow: 0 2px 4px rgba(230, 81, 0, 0.1);
            }

            .register-header p {
                color: #666;
                font-size: 1.1rem;
            }

            .register-header a {
                color: #ff9800;
                text-decoration: none;
                font-weight: 600;
                transition: color 0.3s ease;
            }

            .register-header a:hover {
                color: #f57c00;
                text-decoration: underline;
            }

            .register-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(255, 152, 0, 0.2);
                border: 1px solid rgba(255, 152, 0, 0.1);
                position: relative;
                overflow: hidden;
                animation: scaleIn 0.6s ease-out 0.2s both;
            }

            @keyframes scaleIn {
                from {
                    opacity: 0;
                    transform: scale(0.9);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            .register-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #ff9800, #ff5722, #ff9800);
                background-size: 200% 100%;
                animation: shimmer 2s linear infinite;
            }

            @keyframes shimmer {
                0% { background-position: -200% 0; }
                100% { background-position: 200% 0; }
            }

            .inner-card {
                padding: 40px;
                border: none;
                border-radius: 20px;
                box-shadow: none;
            }

            .form-label {
                color: #e65100;
                font-weight: 600;
                margin-bottom: 8px;
                font-size: 0.95rem;
            }

            .form-control {
                border: 2px solid #ffcc80;
                border-radius: 12px;
                padding: 12px 16px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: rgba(255, 248, 225, 0.8);
                margin-bottom: 5px;
            }

            .form-control:focus {
                border-color: #ff9800;
                box-shadow: 0 0 0 0.2rem rgba(255, 152, 0, 0.25);
                background: white;
                transform: translateY(-1px);
            }

            .form-control:invalid:not(:placeholder-shown) {
                border-color: #f44336;
                box-shadow: 0 0 0 0.2rem rgba(244, 67, 54, 0.25);
            }

            .form-control:valid:not(:placeholder-shown) {
                border-color: #4caf50;
                box-shadow: 0 0 0 0.2rem rgba(76, 175, 80, 0.25);
            }

            .error-message {
                color: #d32f2f;
                font-size: 0.85rem;
                margin-top: 5px;
                margin-bottom: 10px;
                padding: 8px 12px;
                background: rgba(255, 235, 238, 0.8);
                border-radius: 8px;
                border-left: 3px solid #f44336;
                display: none;
                animation: slideInLeft 0.3s ease-out;
            }

            .error-message.show {
                display: block;
            }

            @keyframes slideInLeft {
                from {
                    opacity: 0;
                    transform: translateX(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            .btn {
                padding: 15px 30px;
                border-radius: 12px;
                font-weight: 600;
                font-size: 1.1rem;
                border: none;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .btn::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                transform: translate(-50%, -50%);
                transition: width 0.6s, height 0.6s;
            }

            .btn:hover::before {
                width: 300px;
                height: 300px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #ff9800, #ff5722);
                color: white;
                box-shadow: 0 4px 15px rgba(255, 152, 0, 0.3);
                min-width: 200px;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #f57c00, #e64a19);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255, 152, 0, 0.4);
            }

            .btn-primary:active {
                transform: translateY(0);
                box-shadow: 0 2px 10px rgba(255, 152, 0, 0.3);
            }

            .alert {
                border-radius: 12px;
                border: none;
                padding: 15px 20px;
                margin-top: 25px;
                animation: slideInUp 0.5s ease-out;
            }

            @keyframes slideInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .alert-danger {
                background: linear-gradient(135deg, #ffebee, #ffcdd2);
                color: #c62828;
                border-left: 4px solid #f44336;
            }

            .alert-success {
                background: linear-gradient(135deg, #e8f5e8, #c8e6c9);
                color: #2e7d32;
                border-left: 4px solid #4caf50;
            }

            .loading-spinner {
                display: none;
                width: 20px;
                height: 20px;
                border: 2px solid #ffffff30;
                border-top: 2px solid #ffffff;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin-right: 10px;
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            /* Form field animations */
            .form-group {
                animation: fadeInUp 0.6s ease-out;
                animation-fill-mode: both;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .form-group:nth-child(1) { animation-delay: 0.1s; }
            .form-group:nth-child(2) { animation-delay: 0.2s; }
            .form-group:nth-child(3) { animation-delay: 0.3s; }
            .form-group:nth-child(4) { animation-delay: 0.4s; }
            .form-group:nth-child(5) { animation-delay: 0.5s; }
            .form-group:nth-child(6) { animation-delay: 0.6s; }

            /* Success checkmark */
            .success-checkmark {
                display: none;
                width: 60px;
                height: 60px;
                border-radius: 50%;
                background: #4caf50;
                margin: 10px auto;
                position: relative;
                animation: scaleIn 0.5s ease-out;
            }

            .success-checkmark::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 20px;
                height: 12px;
                border: solid white;
                border-width: 0 0 3px 3px;
                transform: translate(-50%, -60%) rotate(-45deg);
            }

            @media (max-width: 768px) {
                .register-header h1 {
                    font-size: 2rem;
                }
                
                .inner-card {
                    padding: 30px 25px;
                }
                
                .logo {
                    height: 50px;
                    top: 15px;
                    left: 20px;
                }

                .btn-primary {
                    min-width: auto;
                    width: 100%;
                }
            }

            @media (max-width: 576px) {
                body {
                    padding: 10px;
                }
                
                .register-container {
                    margin: 10px;
                }
                
                .inner-card {
                    padding: 25px 20px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Background particles -->
        <div class="background-particles">
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
        </div>

        <a href="/OishipFoodOrdering"><img src="images/logov2.png" alt="Oiship Logo" class="logo"/></a>

        <div class="register-container">
            <div class="register-header">
                <h1><i class="bi bi-person-plus me-3"></i>Join Oiship</h1>
                <p>Already have an account? <a href="login">Sign in here</a></p>
            </div>

            <div class="register-card">
                <div class="inner-card">
                    <form action="register" method="POST" id="registerForm" onsubmit="return validateForm();">
                        <input type="hidden" name="role" value="customer" />
                        <div class="row gy-3">
                            <div class="col-md-6 form-group">
                                <label for="fullName" class="form-label">
                                    <i class="bi bi-person me-2"></i>Full Name
                                </label>
                                <input type="text" class="form-control" name="fullName" id="fullName" 
                                       placeholder="Enter your full name" required maxlength="255" />
                                <div id="errorFullName" class="error-message">
                                    <i class="bi bi-exclamation-circle me-2"></i>
                                    <span>Full name must contain only letters and spaces (minimum 2 characters).</span>
                                </div>
                            </div>
                            
                            <div class="col-md-6 form-group">
                                <label for="email" class="form-label">
                                    <i class="bi bi-envelope me-2"></i>Email Address
                                </label>
                                <input type="email" class="form-control" name="email" id="email" 
                                       placeholder="Enter your email" required maxlength="100" />
                                <div id="errorEmail" class="error-message">
                                    <i class="bi bi-exclamation-circle me-2"></i>
                                    <span>Please enter a valid email address.</span>
                                </div>
                            </div>
                            
                            <div class="col-md-6 form-group">
                                <label for="phone" class="form-label">
                                    <i class="bi bi-telephone me-2"></i>Phone Number
                                </label>
                                <input type="tel" class="form-control" name="phone" id="phone" 
                                       placeholder="0123456789" required maxlength="10" />
                                <div id="errorPhone" class="error-message">
                                    <i class="bi bi-exclamation-circle me-2"></i>
                                    <span>Phone number must be exactly 10 digits and start with 0.</span>
                                </div>
                            </div>
                            
                            <div class="col-md-6 form-group">
                                <label for="address" class="form-label">
                                    <i class="bi bi-house me-2"></i>Address
                                </label>
                                <input type="text" class="form-control" name="address" id="address" 
                                       placeholder="Enter your address" required maxlength="255" />
                                <div id="errorAddress" class="error-message">
                                    <i class="bi bi-exclamation-circle me-2"></i>
                                    <span>Please enter your address.</span>
                                </div>
                            </div>
                            
                            <div class="col-md-6 form-group">
                                <label for="password" class="form-label">
                                    <i class="bi bi-lock me-2"></i>Password
                                </label>
                                <input type="password" class="form-control" name="password" id="password" 
                                       placeholder="Create a strong password" required />
                                <div id="errorPassword" class="error-message">
                                    <i class="bi bi-exclamation-circle me-2"></i>
                                    <span>Password must be at least 8 characters, including letters and numbers.</span>
                                </div>
                            </div>
                            
                            <div class="col-md-6 form-group">
                                <label for="confirmPassword" class="form-label">
                                    <i class="bi bi-lock-fill me-2"></i>Confirm Password
                                </label>
                                <input type="password" class="form-control" name="confirm_password" id="confirmPassword" 
                                       placeholder="Confirm your password" required />
                                <div id="errorConfirmPassword" class="error-message">
                                    <i class="bi bi-exclamation-circle me-2"></i>
                                    <span>Passwords do not match.</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="text-center mt-4">
                            <button class="btn btn-primary" type="submit" id="submitBtn">
                                <span class="loading-spinner" id="loadingSpinner"></span>
                                <i class="bi bi-person-plus me-2" id="submitIcon"></i>
                                <span id="submitText">Create Account</span>
                            </button>
                        </div>
                    </form>

                    <% if (request.getAttribute("error") != null) {%>
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error")%>
                    </div>
                    <% } else if (request.getAttribute("success") != null) {%>
                    <div class="alert alert-success">
                        <i class="bi bi-check-circle me-2"></i>
                        <%= request.getAttribute("success")%>
                    </div>
                    <% }%>

                    <div class="success-checkmark" id="successCheckmark"></div>
                </div>
            </div>
        </div>

        <script>
            // Form validation
            function validateForm() {
                let isValid = true;

                // Clear previous messages and show loading
                document.querySelectorAll('.error-message').forEach(e => e.classList.remove('show'));
                
                const submitBtn = document.getElementById('submitBtn');
                const loadingSpinner = document.getElementById('loadingSpinner');
                const submitIcon = document.getElementById('submitIcon');
                const submitText = document.getElementById('submitText');
                
                loadingSpinner.style.display = 'inline-block';
                submitIcon.style.display = 'none';
                submitText.textContent = 'Creating Account...';
                submitBtn.disabled = true;

                const name = document.getElementById("fullName").value.trim();
                const email = document.getElementById("email").value.trim();
                const phone = document.getElementById("phone").value.trim();
                const address = document.getElementById("address").value.trim();
                const password = document.getElementById("password").value;
                const confirmPassword = document.getElementById("confirmPassword").value;

                const nameRegex = /^[a-zA-ZÀ-ỹ\s]{2,}$/;
                const phoneRegex = /^0\d{9}$/;
                const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

                if (!nameRegex.test(name)) {
                    document.getElementById("errorFullName").classList.add('show');
                    isValid = false;
                }

                if (!email.match(/[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/)) {
                    document.getElementById("errorEmail").classList.add('show');
                    isValid = false;
                }

                if (!phoneRegex.test(phone)) {
                    document.getElementById("errorPhone").classList.add('show');
                    isValid = false;
                }

                if (!address.trim()) {
                    document.getElementById("errorAddress").classList.add('show');
                    isValid = false;
                }

                if (!passwordRegex.test(password)) {
                    document.getElementById("errorPassword").classList.add('show');
                    isValid = false;
                }

                if (password !== confirmPassword) {
                    document.getElementById("errorConfirmPassword").classList.add('show');
                    isValid = false;
                }

                if (!isValid) {
                    // Reset button state if validation fails
                    loadingSpinner.style.display = 'none';
                    submitIcon.style.display = 'inline-block';
                    submitText.textContent = 'Create Account';
                    submitBtn.disabled = false;
                }

                return isValid;
            }

            // Real-time validation
            document.addEventListener('DOMContentLoaded', function() {
                const inputs = document.querySelectorAll('.form-control');
                
                inputs.forEach(input => {
                    input.addEventListener('input', function() {
                        validateField(this);
                    });

                    input.addEventListener('blur', function() {
                        validateField(this);
                    });
                });
            });

            function validateField(field) {
                const fieldId = field.id;
                const value = field.value.trim();
                const errorElement = document.getElementById('error' + fieldId.charAt(0).toUpperCase() + fieldId.slice(1));
                
                let isValid = true;

                switch(fieldId) {
                    case 'fullName':
                        isValid = /^[a-zA-ZÀ-ỹ\s]{2,}$/.test(value);
                        break;
                    case 'email':
                        isValid = /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/.test(value);
                        break;
                    case 'phone':
                        isValid = /^0\d{9}$/.test(value);
                        break;
                    case 'address':
                        isValid = value.length > 0;
                        break;
                    case 'password':
                        isValid = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/.test(field.value);
                        break;
                    case 'confirmPassword':
                        const password = document.getElementById('password').value;
                        isValid = field.value === password;
                        break;
                }

                if (isValid) {
                    errorElement.classList.remove('show');
                    field.classList.remove('is-invalid');
                    field.classList.add('is-valid');
                } else if (value.length > 0) {
                    errorElement.classList.add('show');
                    field.classList.add('is-invalid');
                    field.classList.remove('is-valid');
                } else {
                    errorElement.classList.remove('show');
                    field.classList.remove('is-invalid', 'is-valid');
                }
            }

            // Add interactive effects
            document.querySelectorAll('.form-control').forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'scale(1.02)';
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'scale(1)';
                });
            });
        </script>
    </body>
</html>