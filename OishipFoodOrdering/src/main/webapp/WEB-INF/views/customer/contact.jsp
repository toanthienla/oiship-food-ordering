<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cart" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Contact Us - Oiship</title>
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
                --oiship-radius: 4px;
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
                border-radius: 0 var(--oiship-radius) var(--oiship-radius) 0;
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
                border-radius: 0 0 var(--oiship-radius) 0;
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
                border-radius: var(--oiship-radius);
                transition: all 0.2s;
                font-weight: 500;
            }

            .sidebar-content a:hover,
            .sidebar-content .active {
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
                border-radius: 0 0 var(--oiship-radius) var(--oiship-radius);
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
                border-radius: var(--oiship-radius);
                transition: all 0.3s ease;
            }

            .dropdown .dropdown-toggle:hover {
                background-color: var(--oiship-orange-light);
                color: #e65c00;
                box-shadow: var(--oiship-shadow);
            }

            .dropdown-menu {
                border-radius: var(--oiship-radius);
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

            /* Contact Content */
            .contact-content {
                padding: 20px;
                background: #ffffff;
                min-height: calc(100vh - 120px);
            }

            /* Enhanced Contact Container */
            .contact-container {
                max-width: 800px;
                width: 100%;
                padding: 40px;
            }

            /* Enhanced Title */
            .contact-title {
                font-weight: 700;
                margin-bottom: 30px;
                font-size: 2.5rem;
                position: relative;
            }

            .contact-subtitle {
                text-align: center;
                color: #6c757d;
                margin-bottom: 40px;
                font-size: 1.1rem;
                line-height: 1.6;
            }

            /* Form Enhancements */
            .form-group {
                margin-bottom: 25px;
                position: relative;
            }

            .form-label {
                font-weight: 600;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 1rem;
            }

            .form-control {
                border: 2px solid #e9ecef;
                border-radius: 12px;
                padding: 15px 20px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: #fff;
                box-shadow: 0 2px 4px rgba(0,0,0,0.02);
            }

            .form-control:focus {
                border-color: var(--oiship-orange);
                box-shadow: 0 0 0 0.2rem rgba(255, 98, 0, 0.15);
                transform: translateY(-2px);
                background: #fff;
            }

            textarea.form-control {
                min-height: 180px;
                resize: vertical;
            }

            /* Character Counter */
            .char-counter {
                position: absolute;
                bottom: -20px;
                right: 0;
                font-size: 0.85rem;
                color: #6c757d;
                font-weight: 500;
            }

            .char-counter.warning {
                color: #ffc107;
            }

            .char-counter.danger {
                color: #dc3545;
            }

            /* Enhanced Buttons */
            .btn-group-custom {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 40px;
                gap: 20px;
            }

            .btn-primary-custom {
                background: linear-gradient(135deg, var(--oiship-orange), #ff8533);
                border: none;
                color: #fff;
                font-weight: 600;
                padding: 15px 30px;
                border-radius: 5px;
                font-size: 1rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(255, 98, 0, 0.3);
                position: relative;
                overflow: hidden;
            }

            .btn-primary-custom:hover {
                background: linear-gradient(135deg, #e65c00, #e67700);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255, 98, 0, 0.4);
                color: #fff;
            }

            .btn-outline-custom {
                border: 2px solid var(--oiship-orange);
                color: var(--oiship-orange);
                background: #fff;
                font-weight: 600;
                padding: 15px 30px;
                border-radius: 5px;
                font-size: 1rem;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-outline-custom:hover {
                background: var(--oiship-orange-light);
                color: #e65c00;
                transform: translateY(-2px);
                text-decoration: none;
            }

            /* Alert Enhancements */
            .alert-success-custom {
                background: linear-gradient(135deg, #d4edda, #a7d8aa);
                border: none;
                border-left: 5px solid #28a745;
                color: #155724;
                border-radius: 12px;
                padding: 20px;
                margin-top: 30px;
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.1);
                animation: slideInUp 0.5s ease;
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

            /* Notification Styles */
            .notification-dropdown-item {
                padding: 12px 16px;
                border-radius: 8px;
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
                0% { opacity: 1; transform: translateY(-50%) scale(1); }
                50% { opacity: 0.7; transform: translateY(-50%) scale(1.2); }
                100% { opacity: 1; transform: translateY(-50%) scale(1); }
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

            /* Contact Info Section */
            .contact-info {
                background: linear-gradient(135deg, var(--oiship-orange-light), #fff3e0);
                padding: 30px;
                border-radius: 15px;
                margin-top: 40px;
                border: 1px solid #ffe0cc;
            }

            .contact-info h4 {
                color: var(--oiship-orange);
                font-weight: 600;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .contact-info-item {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 15px;
                color: #495057;
            }

            .contact-info-item i {
                color: var(--oiship-orange);
                width: 20px;
                text-align: center;
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
                    background: #ffffff;
                }

                .contact-content {
                    padding: 10px;
                    min-height: auto;
                }

                .contact-container {
                    padding: 25px;
                    margin: 10px;
                }

                .contact-title {
                    font-size: 2rem;
                }

                .btn-group-custom {
                    flex-direction: column;
                    gap: 15px;
                }

                .btn-primary-custom,
                .btn-outline-custom {
                    width: 100%;
                    justify-content: center;
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

                <a href="${pageContext.request.contextPath}/customer/contact" class="active">
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
            <!-- Enhanced Navbar -->
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
                                    Welcome, <span><c:out value="${userName}" default="toanthienla" /></span>!
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

            <!-- Contact Content -->
            <div class="contact-content">
                <div class="contact-container">
                    <h1 class="contact-title">
                        Contact Us
                    </h1>

                    <form action="${pageContext.request.contextPath}/customer/contact" method="post" onsubmit="validateContactForm(event)">
                        <div class="form-group">
                            <label for="subject" class="form-label">
                                <i class="fas fa-tag"></i>
                                Subject
                            </label>
                            <input name="subject" id="subject" class="form-control" rows="2" required 
                                      placeholder="What's this about?" maxlength="255"></input>
                        </div>

                        <div class="form-group">
                            <label for="message" class="form-label">
                                <i class="fas fa-comment-dots"></i>
                                Message
                            </label>
                            <textarea name="message" id="message" class="form-control" rows="6" required 
                                      placeholder="Tell us more about your inquiry..." maxlength="2000"></textarea>
                        </div>

                        <div class="btn-group-custom">
                            <a href="${pageContext.request.contextPath}/customer" class="btn-outline-custom">
                                <i class="fas fa-arrow-left"></i>
                                Back to Menu
                            </a>
                            <button type="submit" class="btn-primary-custom">
                                <i class="fas fa-paper-plane me-2"></i>
                                Send Message
                            </button>
                        </div>
                    </form>

                    <c:if test="${not empty success}">
                        <div class="alert-success-custom">
                            <i class="fas fa-check-circle me-2"></i>
                            ${success}
                        </div>
                    </c:if>

                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Enhanced form validation
            function validateContactForm(event) {
                const subject = document.getElementById("subject").value.trim();
                const message = document.getElementById("message").value.trim();

                if (subject.length > 255) {
                    alert("Subject cannot exceed 255 characters.");
                    event.preventDefault();
                    return false;
                }

                if (message.length > 2000) {
                    alert("Message cannot exceed 2000 characters.");
                    event.preventDefault();
                    return false;
                }

                if (subject.length === 0) {
                    alert("Please enter a subject.");
                    event.preventDefault();
                    return false;
                }

                if (message.length === 0) {
                    alert("Please enter a message.");
                    event.preventDefault();
                    return false;
                }

                return true;
            }

            // Character counters with color coding
            document.addEventListener('DOMContentLoaded', function() {
                const subjectInput = document.getElementById('subject');
                const messageInput = document.getElementById('message');
                const subjectCounter = document.getElementById('subjectCounter');
                const messageCounter = document.getElementById('messageCounter');

                function updateCounter(input, counter, maxLength) {
                    const currentLength = input.value.length;
                    counter.textContent = `${currentLength}/${maxLength}`;
                    
                    // Color coding based on character count
                    counter.classList.remove('warning', 'danger');
                    
                    if (currentLength >= maxLength * 0.9) {
                        counter.classList.add('danger');
                    } else if (currentLength >= maxLength * 0.75) {
                        counter.classList.add('warning');
                    }
                }

                subjectInput.addEventListener('input', function() {
                    updateCounter(this, subjectCounter, 255);
                });

                messageInput.addEventListener('input', function() {
                    updateCounter(this, messageCounter, 2000);
                });

                // Auto-hide success alert
                const successAlert = document.querySelector('.alert-success-custom');
                if (successAlert) {
                    setTimeout(() => {
                        successAlert.style.opacity = '0';
                        successAlert.style.transform = 'translateY(-20px)';
                        setTimeout(() => {
                            successAlert.remove();
                        }, 500);
                    }, 5000);
                }

                // Page loaded confirmation
                console.log("Contact page loaded - 2025-07-29 18:05:50 - User: toanthienla");
            });

            // Enhanced form submission feedback
            document.querySelector('form').addEventListener('submit', function() {
                const submitBtn = document.querySelector('.btn-primary-custom');
                const originalText = submitBtn.innerHTML;
                
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Sending...';
                submitBtn.disabled = true;
                
                // Re-enable button after 3 seconds (in case of errors)
                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }, 3000);
            });
        </script>
    </body>
</html>