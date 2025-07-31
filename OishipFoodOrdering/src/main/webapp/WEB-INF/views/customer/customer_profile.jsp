<%@page import="model.Customer"%>
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
        <title>My Profile - Oiship</title>
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

            /* Basic Profile Card */
            .profile-card {
                background: #fff;
                border: 1px solid #ddd;
                box-shadow: var(--oiship-shadow);
                margin-bottom: 20px;
            }

            .profile-header {
                background: var(--oiship-orange);
                color: white;
                padding: 20px;
                text-align: left;
            }

            .profile-header h4 {
                margin: 0;
                font-weight: 600;
            }

            .profile-body {
                padding: 25px;
            }

            /* Basic Info Display */
            .info-table {
                width: 100%;
                margin-bottom: 20px;
            }

            .info-row {
                display: flex;
                padding: 12px 0;
                border-bottom: 1px solid #f0f0f0;
                text-align: left;
            }

            .info-row:last-child {
                border-bottom: none;
            }

            .info-label {
                width: 150px;
                font-weight: 600;
                color: #666;
                flex-shrink: 0;
                text-align: left;
            }

            .info-value {
                color: var(--oiship-dark);
                font-weight: 500;
                text-align: left;
                flex-grow: 1;
            }

            /* Action Buttons */
            .action-buttons {
                text-align: left;
                margin-top: 25px;
                padding-top: 20px;
                border-top: 1px solid #f0f0f0;
            }

            .btn-action {
                padding: 10px 20px;
                margin-right: 10px;
                margin-bottom: 10px;
                font-weight: 500;
                text-decoration: none;
                display: inline-block;
                border-radius: 4px;
                transition: all 0.3s ease;
            }

            .btn-edit {
                background: #28a745;
                color: white;
                border: none;
            }

            .btn-edit:hover {
                background: #218838;
                color: white;
            }

            .btn-password {
                background: #dc3545;
                color: white;
                border: none;
            }

            .btn-password:hover {
                background: #c82333;
                color: white;
            }

            .btn-home {
                background: #6c757d;
                color: white;
                border: none;
            }

            .btn-home:hover {
                background: #5a6268;
                color: white;
            }

            /* Error Alert */
            .error-alert {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
                padding: 20px;
                border-radius: 4px;
                text-align: left;
                margin-bottom: 20px;
            }

            .error-alert h4 {
                margin-top: 0;
                text-align: left;
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

                .profile-body {
                    padding: 15px;
                }

                .info-row {
                    flex-direction: column;
                }

                .info-label {
                    width: auto;
                    margin-bottom: 5px;
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
                                    Welcome, <span><c:out value="${sessionScope.userName}" default="toanthienla" /></span>!
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
                <h1 class="page-title">My Profile</h1>

                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-8">
                            <%
                                Customer customer = (Customer) request.getAttribute("customer");
                                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                if (customer != null) {
                            %>
                            <div class="profile-card">
                                <div class="profile-header">
                                    <h4>Customer Profile</h4>
                                </div>

                                <div class="profile-body">
                                    <div class="info-table">
                                        <div class="info-row">
                                            <div class="info-label">Full Name:</div>
                                            <div class="info-value"><%= customer.getFullName() != null ? customer.getFullName() : "N/A"%></div>
                                        </div>

                                        <div class="info-row">
                                            <div class="info-label">Email:</div>
                                            <div class="info-value"><%= customer.getEmail() != null ? customer.getEmail() : "N/A"%></div>
                                        </div>

                                        <div class="info-row">
                                            <div class="info-label">Phone:</div>
                                            <div class="info-value"><%= customer.getPhone() != null ? customer.getPhone() : "N/A"%></div>
                                        </div>

                                        <div class="info-row">
                                            <div class="info-label">Address:</div>
                                            <div class="info-value"><%= customer.getAddress() != null ? customer.getAddress() : "N/A"%></div>
                                        </div>

                                        <div class="info-row">
                                            <div class="info-label">Created At:</div>
                                            <div class="info-value"><%= customer.getAccountCreatedAt() != null ? dateFormat.format(customer.getAccountCreatedAt()) : "N/A"%></div>
                                        </div>
                                    </div>

                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/customer/profile/edit-profile" class="btn-action btn-edit">
                                            Edit Profile
                                        </a>
                                        <a href="${pageContext.request.contextPath}/customer/profile/change-password" class="btn-action btn-password">
                                            Change Password
                                        </a>
                                        <a href="${pageContext.request.contextPath}/customer" class="btn-action btn-home">
                                            Back to Home
                                        </a>
                                    </div>

                                    <div class="last-updated">
                                        Last updated: 2025-07-31 07:13:54
                                    </div>
                                </div>
                            </div>
                            <% } else { %>
                            <div class="error-alert">
                                <h4>Profile Not Found</h4>
                                <p>No customer profile found. Please contact support if this issue persists.</p>
                                <a href="${pageContext.request.contextPath}/customer" class="btn-action btn-home">
                                    Back to Home
                                </a>
                            </div>
                            <% }%>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                console.log("Customer Profile page loaded - 2025-07-31 07:13:54 - User: toanthienla");

                // Log profile access
                const customerName = '<%= customer != null ? customer.getFullName() : "N/A"%>';
                const customerEmail = '<%= customer != null ? customer.getEmail() : "N/A"%>';
                console.log(`Profile accessed for: ${customerName} (${customerEmail}) by user: toanthienla`);
            });
        </script>
    </body>
</html>