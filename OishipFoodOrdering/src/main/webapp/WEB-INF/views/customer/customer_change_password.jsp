<%@page import="model.Staff"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Cart"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Change Password - Oiship</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <style>
            :root {
                --oiship-orange: #ff6200;
                --oiship-orange-light: #ffeadd;
                --oiship-dark: #232323;
                --oiship-gray: #f8f9fa;
                --oiship-shadow: 0 2px 8px rgba(0,0,0,0.08);
            }

            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: var(--oiship-gray);
                margin: 0;
                padding: 0;
            }

            /* Sidebar Styles */
            .sidebar {
                width: 250px;
                background-color: #ffffff;
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                box-shadow: var(--oiship-shadow);
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                z-index: 1000;
            }

            .sidebar-content {
                padding-top: 20px;
                flex-grow: 1;
            }

            .sidebar-logo {
                padding: 20px;
                border-top: 1px solid #f0f0f0;
            }

            .sidebar-logo img {
                max-width: 120px;
                height: auto;
            }

            .sidebar a {
                display: block;
                padding: 12px 20px;
                color: #333;
                text-decoration: none;
                margin: 4px 8px;
                border-radius: 4px;
                transition: all 0.2s;
                font-weight: 500;
            }

            .sidebar-content a:hover {
                background-color: var(--oiship-orange);
                color: #fff !important;
                transform: translateX(4px);
            }

            .cart-link {
                position: relative;
                display: inline-block;
            }

            .cart-badge {
                position: absolute;
                top: 0px;
                left: 35px;
                background-color: var(--oiship-orange);
                color: white;
                font-size: 12px;
                padding: 2px 6px;
                border-radius: 50%;
                font-weight: bold;
                line-height: 1;
                min-width: 20px;
                text-align: center;
                box-shadow: 0 0 0 2px white;
            }

            /* Main Content */
            .main-content {
                margin-left: 250px;
                padding: 0;
                min-height: 100vh;
                background: #ffffff;
            }

            /* Navbar Styles */
            .oiship-navbar {
                background: #fff;
                box-shadow: var(--oiship-shadow);
                margin: 20px;
                margin-bottom: 0;
            }

            .user-account {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #333;
            }

            .user-account i {
                font-size: 1.2rem;
                color: var(--oiship-orange);
            }

            .welcome-text {
                white-space: nowrap;
                font-weight: 500;
                color: #333;
            }

            .dropdown .dropdown-toggle {
                color: var(--oiship-orange);
                font-weight: 500;
                padding: 8px 12px;
                border-radius: 4px;
                transition: all 0.3s ease;
            }

            .dropdown .dropdown-toggle:hover {
                background-color: var(--oiship-orange-light);
                color: #e65c00;
                box-shadow: var(--oiship-shadow);
            }

            .dropdown-menu {
                border-radius: 4px;
                border: none;
                box-shadow: var(--oiship-shadow);
                padding: 8px 0;
            }

            .dropdown-menu .dropdown-item {
                padding: 10px 20px;
                color: #333;
                transition: all 0.2s ease;
            }

            .dropdown-menu .dropdown-item:hover {
                background-color: var(--oiship-orange-light);
                color: var(--oiship-orange);
                font-weight: 500;
            }

            /* Content Area */
            .content-wrapper {
                padding: 20px;
                min-height: calc(100vh - 120px);
            }

            /* Page Title */
            .page-title {
                color: var(--oiship-dark);
                font-weight: 600;
                font-size: 2rem;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid var(--oiship-orange);
                text-align: left;
            }

            /* Password Form Card */
            .password-form-card {
                background: #fff;
                border: 1px solid #ddd;
                box-shadow: var(--oiship-shadow);
                margin-bottom: 20px;
            }

            .form-header {
                background: var(--oiship-orange);
                color: white;
                padding: 20px;
                text-align: left;
            }

            .form-header h4 {
                margin: 0;
                font-weight: 600;
            }

            .form-body {
                padding: 25px;
            }

            /* Form Styling */
            .form-label {
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
                text-align: left;
            }

            .form-control {
                border: 1px solid #ddd;
                border-radius: 4px;
                padding: 12px;
                font-size: 1rem;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                border-color: var(--oiship-orange);
                box-shadow: 0 0 0 0.25rem rgba(255, 98, 0, 0.25);
            }

            /* Password Validation */
            .password-validation {
                margin-top: 8px;
                font-size: 0.85rem;
                text-align: left;
            }

            .validation-valid {
                color: #28a745;
            }

            .validation-invalid {
                color: #dc3545;
            }

            .validation-neutral {
                color: #666;
            }

            /* Buttons */
            .btn-primary {
                background: var(--oiship-orange);
                border-color: var(--oiship-orange);
                font-weight: 600;
                padding: 10px 25px;
                border-radius: 4px;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background: #e65c00;
                border-color: #e65c00;
                transform: translateY(-1px);
            }

            .btn-primary:disabled {
                background: #6c757d;
                border-color: #6c757d;
                transform: none;
                cursor: not-allowed;
            }

            .btn-secondary {
                background: #6c757d;
                border-color: #6c757d;
                font-weight: 500;
                padding: 10px 25px;
                border-radius: 4px;
                transition: all 0.3s ease;
            }

            .btn-secondary:hover {
                background: #5a6268;
                border-color: #5a6268;
                transform: translateY(-1px);
            }

            /* Alert Messages */
            .alert {
                border-radius: 4px;
                border: none;
                font-weight: 500;
                margin-top: 20px;
            }

            .alert-success {
                background: #d4edda;
                color: #155724;
                border-left: 4px solid #28a745;
            }

            .alert-danger {
                background: #f8d7da;
                color: #721c24;
                border-left: 4px solid #dc3545;
            }

            /* Form Group Styling */
            .form-group {
                margin-bottom: 20px;
                text-align: left;
            }

            .button-group {
                text-align: left;
                margin-top: 25px;
                padding-top: 20px;
                border-top: 1px solid #f0f0f0;
            }

            /* Password Requirements */
            .password-requirements {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 4px;
                padding: 15px;
                margin-top: 15px;
                text-align: left;
            }

            .password-requirements h6 {
                color: var(--oiship-orange);
                margin-bottom: 10px;
                font-weight: 600;
            }

            .requirement-item {
                color: #666;
                font-size: 0.9rem;
                margin-bottom: 5px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .requirement-check {
                color: #28a745;
            }

            .requirement-cross {
                color: #dc3545;
            }

            /* Password Toggle */
            .password-toggle {
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #666;
                cursor: pointer;
                padding: 0;
                font-size: 1rem;
            }

            .password-input-group {
                position: relative;
            }

            /* Last Updated */
            .last-updated {
                color: #666;
                font-size: 0.9rem;
                margin-top: 15px;
                text-align: left;
            }

            /* Notification Styles */
            .notification-dropdown-item {
                padding: 12px 16px;
                border-radius: 4px;
                margin: 4px 8px;
                transition: all 0.2s ease;
                cursor: pointer;
                border-left: 3px solid transparent;
                position: relative;
            }

            .notification-dropdown-item:hover {
                background: var(--oiship-orange-light);
                border-left-color: var(--oiship-orange);
                transform: translateX(4px);
            }

            .notification-dropdown-item .notification-title-small {
                font-weight: 600;
                color: #495057;
                margin-bottom: 2px;
                font-size: 0.9rem;
            }

            .notification-dropdown-item .notification-preview {
                font-size: 0.8rem;
                color: #6c757d;
                margin: 0;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                line-height: 1.3;
            }

            .notification-unread::before {
                content: '';
                position: absolute;
                left: 8px;
                top: 50%;
                transform: translateY(-50%);
                width: 8px;
                height: 8px;
                background: #dc3545;
                border-radius: 50%;
                animation: pulse 2s infinite;
                z-index: 1;
            }

            @keyframes pulse {
                0% {
                    opacity: 1;
                    transform: translateY(-50%) scale(1);
                }
                50% {
                    opacity: 0.7;
                    transform: translateY(-50%) scale(1.2);
                }
                100% {
                    opacity: 1;
                    transform: translateY(-50%) scale(1);
                }
            }

            .notification-empty {
                text-align: center;
                padding: 40px 20px;
                color: #6c757d;
            }

            .notification-empty i {
                font-size: 2.5rem;
                margin-bottom: 15px;
                opacity: 0.5;
            }

            /* Mobile Responsive */
            @media (max-width: 768px) {
                .sidebar {
                    width: 100%;
                    height: auto;
                    position: relative;
                    flex-direction: column;
                }

                .sidebar-content {
                    order: 1;
                }

                .sidebar-logo {
                    order: 2;
                    border-top: none;
                    border-bottom: 1px solid #f0f0f0;
                    padding: 15px;
                }

                .sidebar-logo img {
                    max-width: 80px;
                }

                .main-content {
                    margin-left: 0;
                }

                .content-wrapper {
                    padding: 10px;
                }

                .page-title {
                    font-size: 1.5rem;
                }

                .form-body {
                    padding: 15px;
                }

                .oiship-navbar {
                    margin: 10px;
                    padding: 0.5rem 1rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-content">
                <a href="${pageContext.request.contextPath}/customer">
                    <i class="fas fa-home me-2"></i> Home
                </a>

                <a href="${pageContext.request.contextPath}/customer/view-vouchers-list">
                    <i class="fas fa-tags me-2"></i> Vouchers
                </a>

                <%
                    List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
                    int totalDishes = (cartItems != null) ? cartItems.size() : 0;
                %>

                <!-- Cart with badge -->
                <a href="${pageContext.request.contextPath}/customer/view-cart" class="cart-link text-decoration-none position-relative me-2">
                    <i class="fas fa-shopping-cart me-2"></i> Cart
                    <% if (totalDishes > 0) {%>
                    <span class="cart-badge">
                        <%= (totalDishes > 7) ? "5+" : totalDishes%>
                    </span>
                    <% }%>
                </a>

                <a href="${pageContext.request.contextPath}/customer/order">
                    <i class="fas fa-list me-2"></i> Order
                </a>

                <a href="${pageContext.request.contextPath}/customer/contact">
                    <i class="fas fa-phone me-2"></i> Contact
                </a>
            </div>

            <!-- Logo at bottom -->
            <div class="sidebar-logo">
                <div class="text-center">
                    <img src="${pageContext.request.contextPath}/images/logo_1.png" alt="Oiship Logo" class="img-fluid" />
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg oiship-navbar">
                <div class="container-fluid">
                    <div class="d-flex align-items-center ms-auto">
                        <div class="dropdown me-3">
                            <a class="text-decoration-none position-relative dropdown-toggle" href="#" role="button"
                               id="notificationDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-bell fa-lg" style="color: var(--oiship-orange);"></i>
                                <span class="badge rounded-pill bg-danger position-absolute top-0 start-100 translate-middle" id="notificationBadge">
                                    <%= ((List<?>) request.getAttribute("notifications")) != null ? ((List<?>) request.getAttribute("notifications")).size() : 0%>
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end p-2" aria-labelledby="notificationDropdown" style="min-width: 350px; max-height: 400px; overflow-y: auto;">
                                <%
                                    List<?> notifications = (List<?>) request.getAttribute("notifications");
                                    if (notifications != null && !notifications.isEmpty()) {
                                        for (int i = 0; i < notifications.size(); i++) {
                                            model.Notification n = (model.Notification) notifications.get(i);
                                %>
                                <li>
                                    <div class="notification-dropdown-item notification-unread">
                                        <div class="notification-title-small"><%= n.getNotTitle()%></div>
                                        <p class="notification-preview"><%= n.getNotDescription()%></p>
                                    </div>
                                </li>
                                <% if (i < notifications.size() - 1) { %>
                                <li><hr class="dropdown-divider"></li>
                                    <% } %>
                                    <%
                                        }
                                    } else {
                                    %>
                                <li class="notification-empty">
                                    <i class="fas fa-bell-slash"></i>
                                    <p class="mb-0">No new notifications</p>
                                </li>
                                <%
                                    }
                                %>
                            </ul>
                        </div>

                        <div class="dropdown">
                            <a class="dropdown-toggle text-decoration-none user-account" href="#" role="button"
                               id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user"></i>
                                <div class="welcome-text">
                                    Welcome, <span>toanthienla</span>!
                                </div>
                            </a>

                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/profile">Settings</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Log out</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </nav>

            <!-- Content -->
            <div class="content-wrapper">
                <h1 class="page-title">Change Password</h1>

                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="password-form-card">
                                <div class="form-header">
                                    <h4>
                                        <i class="fas fa-key me-2"></i>
                                        Update Your Password
                                    </h4>
                                </div>

                                <div class="form-body">
                                    <form method="post" action="${pageContext.request.contextPath}/customer/profile/change-password" id="passwordForm">
                                        <div class="form-group">
                                            <label for="currentPassword" class="form-label">
                                                <i class="fas fa-lock me-2"></i>
                                                Current Password
                                            </label>
                                            <div class="password-input-group">
                                                <input type="password" 
                                                       class="form-control" 
                                                       id="currentPassword" 
                                                       name="currentPassword" 
                                                       placeholder="Enter your current password"
                                                       required>
                                                <button type="button" class="password-toggle" onclick="togglePassword('currentPassword')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="newPassword" class="form-label">
                                                <i class="fas fa-plus-circle me-2"></i>
                                                New Password
                                            </label>
                                            <div class="password-input-group">
                                                <input type="password" 
                                                       class="form-control" 
                                                       id="newPassword" 
                                                       name="newPassword" 
                                                       placeholder="Enter your new password"
                                                       required>
                                                <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="confirmPassword" class="form-label">
                                                <i class="fas fa-check-circle me-2"></i>
                                                Confirm New Password
                                            </label>
                                            <div class="password-input-group">
                                                <input type="password" 
                                                       class="form-control" 
                                                       id="confirmPassword" 
                                                       name="confirmPassword" 
                                                       placeholder="Confirm your new password"
                                                       required>
                                                <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            <div id="passwordMatch" class="password-validation"></div>
                                        </div>

                                        <!-- Password Requirements -->
                                        <div class="password-requirements">
                                            <h6>
                                                <i class="fas fa-shield-alt me-2"></i>
                                                Password Requirements
                                            </h6>
                                            <div class="requirement-item" id="lengthCheck">
                                                At least 8 characters
                                            </div>
                                            <div class="requirement-item" id="letterCheck">
                                                Include both letters (a-z, A-Z)
                                            </div>
                                            <div class="requirement-item" id="numberCheck">
                                                Include at least one number (0-9)
                                            </div>
                                        </div>

                                        <div class="button-group">
                                            <button type="submit" class="btn btn-primary me-2" id="submitBtn" disabled>
                                                <i class="fas fa-save me-2"></i>
                                                Change Password
                                            </button>
                                            <a href="${pageContext.request.contextPath}/customer/profile" class="btn btn-secondary">
                                                <i class="fas fa-arrow-left me-2"></i>
                                                Back to Profile
                                            </a>
                                        </div>
                                    </form>

                                    <!-- Alert Messages -->
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            ${error}
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty message}">
                                        <div class="alert alert-success">
                                            <i class="fas fa-check-circle me-2"></i>
                                            ${message}
                                        </div>
                                    </c:if>

                                    <div class="last-updated">
                                        <i class="fas fa-clock me-1"></i>
                                        Last updated: 2025-07-31 07:30:15
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                    document.addEventListener('DOMContentLoaded', function () {
                                                        console.log("Change Password page loaded - 2025-07-31 07:30:15 - User: toanthienla");

                                                        const newPasswordInput = document.getElementById('newPassword');
                                                        const confirmPasswordInput = document.getElementById('confirmPassword');
                                                        const passwordMatchDiv = document.getElementById('passwordMatch');
                                                        const submitBtn = document.getElementById('submitBtn');
                                                        const form = document.getElementById('passwordForm');

                                                        // Password validation elements
                                                        const lengthCheck = document.getElementById('lengthCheck');
                                                        const letterCheck = document.getElementById('letterCheck');
                                                        const numberCheck = document.getElementById('numberCheck');

                                                        // Real-time password validation
                                                        newPasswordInput.addEventListener('input', function () {
                                                            const password = this.value;
                                                            validatePassword(password);
                                                            checkPasswordMatch();
                                                            updateSubmitButton();
                                                        });

                                                        // Password match checker
                                                        confirmPasswordInput.addEventListener('input', function () {
                                                            checkPasswordMatch();
                                                            updateSubmitButton();
                                                        });

                                                        function validatePassword(password) {
                                                            // Check length (at least 8 characters)
                                                            const hasLength = password.length >= 8;
                                                            updateRequirement(lengthCheck, hasLength);

                                                            // Check letters (both uppercase and lowercase)
                                                            const hasLetters = /[a-zA-Z]/.test(password);
                                                            updateRequirement(letterCheck, hasLetters);

                                                            // Check numbers
                                                            const hasNumbers = /[0-9]/.test(password);
                                                            updateRequirement(numberCheck, hasNumbers);

                                                            return hasLength && hasLetters && hasNumbers;
                                                        }

                                                        function updateRequirement(element, isValid) {
                                                            const icon = element.querySelector('i');
                                                            if (isValid) {
                                                                icon.className = 'fas fa-check requirement-check';
                                                                element.style.color = '#28a745';
                                                            } else {
                                                                icon.className = 'fas fa-times requirement-cross';
                                                                element.style.color = '#dc3545';
                                                            }
                                                        }

                                                        function checkPasswordMatch() {
                                                            const newPassword = newPasswordInput.value;
                                                            const confirmPassword = confirmPasswordInput.value;

                                                            if (confirmPassword.length > 0) {
                                                                if (newPassword === confirmPassword) {
                                                                    passwordMatchDiv.innerHTML = '<i class="fas fa-check me-1"></i>Passwords match';
                                                                    passwordMatchDiv.className = 'password-validation validation-valid';
                                                                    return true;
                                                                } else {
                                                                    passwordMatchDiv.innerHTML = '<i class="fas fa-times me-1"></i>Passwords do not match';
                                                                    passwordMatchDiv.className = 'password-validation validation-invalid';
                                                                    return false;
                                                                }
                                                            } else {
                                                                passwordMatchDiv.innerHTML = '';
                                                                return false;
                                                            }
                                                        }

                                                        function updateSubmitButton() {
                                                            const newPassword = newPasswordInput.value;
                                                            const confirmPassword = confirmPasswordInput.value;
                                                            const currentPassword = document.getElementById('currentPassword').value;

                                                            const isPasswordValid = validatePassword(newPassword);
                                                            const isPasswordMatched = newPassword === confirmPassword && confirmPassword.length > 0;
                                                            const hasCurrentPassword = currentPassword.length > 0;

                                                            if (isPasswordValid && isPasswordMatched && hasCurrentPassword) {
                                                                submitBtn.disabled = false;
                                                                submitBtn.style.opacity = '1';
                                                            } else {
                                                                submitBtn.disabled = true;
                                                                submitBtn.style.opacity = '0.6';
                                                            }
                                                        }

                                                        // Current password field listener
                                                        document.getElementById('currentPassword').addEventListener('input', updateSubmitButton);

                                                        // Form validation on submit
                                                        form.addEventListener('submit', function (e) {
                                                            const currentPassword = document.getElementById('currentPassword').value.trim();
                                                            const newPassword = newPasswordInput.value.trim();
                                                            const confirmPassword = confirmPasswordInput.value.trim();

                                                            if (currentPassword.length === 0) {
                                                                e.preventDefault();
                                                                alert('Please enter your current password.');
                                                                return;
                                                            }

                                                            if (!validatePassword(newPassword)) {
                                                                e.preventDefault();
                                                                alert('New password does not meet the requirements. Please check the password requirements below.');
                                                                return;
                                                            }

                                                            if (newPassword !== confirmPassword) {
                                                                e.preventDefault();
                                                                alert('New password and confirmation do not match.');
                                                                return;
                                                            }

                                                            if (currentPassword === newPassword) {
                                                                e.preventDefault();
                                                                alert('New password must be different from current password.');
                                                                return;
                                                            }

                                                            console.log(`Password change submitted by user: toanthienla at 2025-07-31 07:30:15`);
                                                        });
                                                    });

                                                    function togglePassword(inputId) {
                                                        const input = document.getElementById(inputId);
                                                        const toggle = input.nextElementSibling.querySelector('i');

                                                        if (input.type === 'password') {
                                                            input.type = 'text';
                                                            toggle.classList.remove('fa-eye');
                                                            toggle.classList.add('fa-eye-slash');
                                                        } else {
                                                            input.type = 'password';
                                                            toggle.classList.remove('fa-eye-slash');
                                                            toggle.classList.add('fa-eye');
                                                        }
                                                    }
        </script>
    </body>
</html>