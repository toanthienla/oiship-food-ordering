<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="model.Dish" %>
<%@ page import="model.Cart" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Your Order - Oiship</title>
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

            /* Order Content Container */
            .order-content {
                padding: 40px 20px;
                background: #ffffff;
            }

            /* Enhanced Order Styles with Perfect Alignment */
            .order-card {
                background: #fff;
                padding: 25px;
                margin-bottom: 30px;
                border-left: 5px solid var(--oiship-orange);
                transition: all 0.3s ease;
                border-radius: 12px;
                border: 1px solid #e9ecef;
            }

            .order-card:hover {
                transform: translateY(-3px);
            }

            .order-header {
                border-bottom: 2px solid var(--oiship-orange-light);
                margin-bottom: 20px;
                padding-bottom: 15px;
            }

            .dish-img {
                width: 70px;
                height: 70px;
                object-fit: cover;
                border-radius: 12px;
                margin-right: 15px;
                border: 2px solid var(--oiship-orange-light);
                background-color: #f9f9f9;
                transition: transform 0.2s ease;
            }

            .dish-img:hover {
                transform: scale(1.1);
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--oiship-orange), #ff8533);
                border: none;
                font-weight: 600;
                padding: 12px 24px;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #e65c00, #e67700);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(255, 98, 0, 0.3);
            }

            .btn-outline-primary {
                border-color: var(--oiship-orange);
                color: var(--oiship-orange);
                font-weight: 600;
                border-radius: 20px;
            }

            .btn-outline-primary:hover {
                background-color: var(--oiship-orange);
                border-color: var(--oiship-orange);
                color: white;
            }

            .btn-outline-secondary {
                border-radius: 20px;
                font-weight: 500;
            }

            .btn-success {
                background: linear-gradient(135deg, #28a745, #20c997);
                border: none;
                font-weight: 600;
                border-radius: 20px;
            }

            .btn-success:hover {
                background: linear-gradient(135deg, #218838, #1fa085);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            }

            .hidden-dish {
                display: none;
            }

            /* Perfect Status Labels and Button Alignment */
            .status-label {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 8px 16px;
                font-size: 0.875rem;
                border-radius: 5px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                height: 31px;
                line-height: 1.2;
                vertical-align: middle;
                min-width: 80px;
            }

            /* Ensure buttons have consistent sizing */
            .btn-sm {
                padding: 8px 16px;
                font-size: 0.875rem;
                font-weight: 600;
                height: 31px;
                line-height: 1.2;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 5px;
            }

            /* Specific styling for the cancel button */
            .btn-danger.btn-sm {
                background: linear-gradient(135deg, #dc3545, #c82333);
                border: none;
                font-weight: 600;
                min-width: 120px;
            }

            .btn-danger.btn-sm:hover {
                background: linear-gradient(135deg, #c82333, #a71e2a);
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
            }

            /* Status label specific colors with consistent dimensions */
            .status-pending {
                background: linear-gradient(135deg, #fff3cd, #ffeaa7);
                color: #856404;
                border: 2px solid #ffc107;
            }

            .status-confirmed {
                background: linear-gradient(135deg, #cfe2ff, #b6d7ff);
                color: #084298;
                border: 2px solid #0d6efd;
            }

            .status-preparing {
                background: linear-gradient(135deg, #d1e7dd, #a3d9a5);
                color: #0f5132;
                border: 2px solid #198754;
            }

            .status-delivery {
                background: linear-gradient(135deg, #cff4fc, #9eeaf9);
                color: #055160;
                border: 2px solid #0dcaf0;
            }

            .status-success {
                background: linear-gradient(135deg, #d4edda, #a7d8aa);
                color: #155724;
                border: 2px solid #28a745;
            }

            .status-danger {
                background: linear-gradient(135deg, #f8d7da, #f1b0b7);
                color: #721c24;
                border: 2px solid #dc3545;
            }

            /* Enhanced container for perfect alignment */
            .status-actions-container {
                display: flex;
                align-items: center;
                gap: 12px;
                flex-wrap: wrap;
            }

            /* Alert Styles */
            .alert {
                border-radius: 10px;
                border: none;
                font-weight: 500;
                margin: 20px;
                animation: slideDown 0.5s ease;
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Enhanced Notification Styles */
            .notification-dropdown-item {
                padding: 12px 16px;
                border-radius: 8px;
                margin: 4px 8px;
                transition: all 0.2s ease;
                cursor: pointer;
                border-left: 3px solid transparent;
                position: relative;
                background: #ffffff;
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

            /* Enhanced Notification Modal */
            .notification-modal-content {
                border-radius: 16px;
                border: none;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
                overflow: hidden;
                animation: notificationSlideIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
                background: #fff;
            }

            @keyframes notificationSlideIn {
                0% {
                    opacity: 0;
                    transform: translateY(-30px) scale(0.95);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            .notification-header {
                background: linear-gradient(135deg, var(--oiship-orange) 0%, #ff8533 100%);
                color: white;
                border: none;
                padding: 20px 25px;
                display: flex;
                align-items: center;
                gap: 15px;
                position: relative;
            }

            .notification-icon {
                width: 50px;
                height: 50px;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                backdrop-filter: blur(10px);
                animation: bellRing 0.5s ease-out;
            }

            @keyframes bellRing {
                0%, 50%, 100% { transform: rotate(0deg); }
                25% { transform: rotate(-10deg); }
                75% { transform: rotate(10deg); }
            }

            .notification-title-area {
                flex: 1;
            }

            .notification-title {
                margin: 0;
                font-size: 1.25rem;
                font-weight: 600;
                line-height: 1.3;
                text-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            .notification-timestamp {
                font-size: 0.85rem;
                opacity: 0.8;
                display: block;
                margin-top: 2px;
            }

            .notification-close {
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                width: 35px;
                height: 35px;
                display: flex;
                align-items: center;
                justify-content: center;
                filter: none;
                opacity: 1;
                transition: all 0.2s ease;
                border: 1px solid rgba(255,255,255,0.3);
            }

            .notification-close:hover {
                background: rgba(255, 255, 255, 0.3);
                transform: rotate(90deg);
            }

            .notification-body {
                padding: 25px;
                background: linear-gradient(135deg, #fafbfc 0%, #f8f9fa 100%);
            }

            .notification-content {
                background: white;
                padding: 20px;
                border-radius: 12px;
                border-left: 4px solid var(--oiship-orange);
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                position: relative;
            }

            .notification-content::before {
                content: '"';
                position: absolute;
                top: 10px;
                left: -2px;
                font-size: 3rem;
                color: var(--oiship-orange);
                opacity: 0.2;
                font-family: serif;
            }

            .notification-description {
                margin: 0;
                line-height: 1.6;
                color: #495057;
                font-size: 1rem;
                padding-left: 30px;
            }

            .notification-actions {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                flex-wrap: wrap;
            }

            .btn-mark-read {
                background: linear-gradient(135deg, #28a745, #20c997);
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 25px;
                font-weight: 600;
                font-size: 0.9rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
                position: relative;
                overflow: hidden;
            }

            .btn-mark-read:hover {
                background: linear-gradient(135deg, #218838, #1fa085);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
                color: white;
            }

            .btn-dismiss {
                background: #6c757d;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 25px;
                font-weight: 600;
                font-size: 0.9rem;
                transition: all 0.3s ease;
            }

            .btn-dismiss:hover {
                background: #5a6268;
                transform: translateY(-2px);
                color: white;
            }

            /* Loading state for mark as read button */
            .btn-mark-read.loading {
                pointer-events: none;
                opacity: 0.7;
            }

            .btn-mark-read.loading .fa-check {
                display: none;
            }

            .btn-mark-read.loading .fa-spinner {
                display: inline-block;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            /* Enhanced page title */
            .page-title {
                font-weight: 700;
                border-radius: 8px;
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

                .order-content {
                    padding: 10px;
                }

                .oiship-navbar {
                    margin: 10px;
                    padding: 0.5rem 1rem;
                }

                .order-card {
                    padding: 20px;
                }

                .dish-img {
                    width: 60px;
                    height: 60px;
                }

                .status-actions-container {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 8px;
                }

                .btn-sm {
                    min-width: 100px;
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

                <a href="${pageContext.request.contextPath}/customer/order" class="active">
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
                                    <div class="notification-dropdown-item notification-unread"
                                         onclick="openNotificationModal(<%= n.getNotID()%>, '<%= n.getNotTitle().replace("'", "\\'")%>', '<%= n.getNotDescription().replace("'", "\\'").replace("\n", "\\n")%>')">
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

                            <!-- Enhanced Notification Modal -->
                            <div class="modal fade" id="notificationModal" tabindex="-1" aria-labelledby="notificationModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                    <div class="modal-content notification-modal-content">
                                        <div class="modal-header notification-header">
                                            <div class="notification-icon">
                                                <i class="fas fa-bell"></i>
                                            </div>
                                            <div class="notification-title-area">
                                                <h5 class="modal-title notification-title" id="modalTitle"></h5>
                                                <span class="notification-timestamp" id="modalTimestamp">2025-07-29 18:01:07</span>
                                            </div>
                                            <button type="button" class="btn-close notification-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>

                                        <div class="modal-body notification-body">
                                            <div class="notification-content">
                                                <p id="modalDescription" class="notification-description"></p>
                                            </div>

                                            <div class="notification-actions">
                                                <input type="hidden" id="hiddenNotID" />
                                                <button type="button" class="btn btn-mark-read" id="markReadBtn">
                                                    <i class="fas fa-check me-2"></i>
                                                    <i class="fas fa-spinner me-2" style="display: none;"></i>
                                                    <span class="btn-text">Mark as Read</span>
                                                </button>
                                                <button type="button" class="btn btn-dismiss" data-bs-dismiss="modal">
                                                    <i class="fas fa-times me-2"></i>
                                                    Dismiss
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="dropdown">
                            <a class="dropdown-toggle text-decoration-none user-account" href="#" role="button"
                               id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user"></i>
                                <div class="welcome-text">
                                    Welcome, <span><c:out value="${userName}"/></span>!
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

            <!-- Order Content -->
            <div class="order-content">
                <!-- Alert Messages -->
                <% if ("true".equals(request.getParameter("cancelSuccess"))) { %>
                <div class="alert alert-success text-center">
                    <i class="fas fa-check-circle me-2"></i>
                    Order has been cancelled successfully.
                </div>
                <% } else if ("true".equals(request.getParameter("cancelFailed"))) { %>
                <div class="alert alert-danger text-center">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    Failed to cancel the order. It may no longer be pending.
                </div>
                <% } %>

                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) {%>
                <div class="alert alert-danger text-center">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <%= error%>
                </div>
                <% }%>

                <div class="container-fluid">
                    <!-- Enhanced Page Title -->
                    <h2 class="page-title mb-4">
                        Your Order
                    </h2>

                    <%
                        List<Order> orderHistory = (List<Order>) request.getAttribute("orderHistory");
                        String[] orderStatusText = (String[]) request.getAttribute("orderStatusText");

                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");
                        int orderIndex = 0;

                        if (orderHistory != null && !orderHistory.isEmpty()) {
                            for (Order order : orderHistory) {
                                int os = order.getOrderStatus();
                                int ps = order.getPaymentStatus();

                                String orderClass = "";
                                switch (os) {
                                    case 0:
                                        orderClass = "status-pending";
                                        break;
                                    case 1:
                                    case 2:
                                        orderClass = "status-confirmed";
                                        break;
                                    case 3:
                                        orderClass = "status-delivery";
                                        break;
                                    case 4:
                                        orderClass = "status-success";
                                        break;
                                    case 5:
                                    case 6:
                                        orderClass = "status-danger";
                                        break;
                                    default:
                                        orderClass = "";
                                }
                    %>
                    <div class="order-card">
                        <div class="order-header">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <h5 class="mb-2">
                                        Order #<%= order.getOrderID()%>
                                    </h5>
                                    <p class="text-muted mb-0">
                                        Date: <%= sdf.format(order.getOrderCreatedAt())%>
                                    </p>
                                </div>
                                <div class="status-actions-container">
                                    <span class="status-label <%= orderClass%>">
                                        <i class="fas fa-info-circle me-1"></i>
                                        <%= orderStatusText[os]%>
                                    </span>
                                    <% if (order.getOrderStatus() == 0) {%>
                                    <form action="<%= request.getContextPath()%>/customer/cancel-order" method="post"
                                          onsubmit="return confirm('Are you sure you want to cancel this order?');" class="d-inline">
                                        <input type="hidden" name="orderID" value="<%= order.getOrderID()%>">
                                        <button type="submit" class="btn btn-danger btn-sm">
                                            <i class="fas fa-times me-1"></i>Cancel Order
                                        </button>
                                    </form>
                                    <% }%>
                                </div>
                            </div>
                        </div>

                        <div id="dishList-<%= orderIndex%>">
                            <%
                                int detailIndex = 0;
                                for (OrderDetail detail : order.getOrderDetails()) {
                                    Dish dish = detail.getDish();
                                    String imageUrl = (dish.getImage() != null && !dish.getImage().isEmpty())
                                            ? dish.getImage()
                                            : "https://via.placeholder.com/600x400";
                                    boolean hidden = detailIndex >= 5;
                            %>
                            <div class="d-flex align-items-center mb-3 dish-item<%= hidden ? " hidden-dish" : ""%>">
                                <img src="<%= imageUrl%>" class="dish-img" alt="<%= dish.getDishName()%>">
                                <div class="flex-grow-1">
                                    <h6 class="mb-2 fw-bold"><%= dish.getDishName()%></h6>
                                    <p class="mb-1 text-muted">
                                        <i class="fas fa-sort-numeric-up me-1"></i>
                                        Quantity: <strong><%= detail.getQuantity()%></strong>
                                    </p>
                                </div>

                                <%-- Review button for delivered orders --%>
                                <% if (order.getOrderStatus() == 4 && !detail.isReviewed()) {%>
                                <button type="button" class="btn btn-outline-primary btn-sm"
                                        id="review-btn-<%= detail.getODID()%>"
                                        data-bs-toggle="modal"
                                        data-bs-target="#reviewModal"
                                        data-odid="<%= detail.getODID()%>"
                                        data-dishname="<%= dish.getDishName()%>">
                                    <i class="fas fa-star me-1"></i>Review
                                </button>
                                <% } else if (detail.isReviewed()) { %>
                                <span class="badge bg-success">
                                    <i class="fas fa-check me-1"></i>Reviewed
                                </span>
                                <% } %>
                            </div>
                            <%
                                    detailIndex++;
                                }
                            %>
                        </div>

                        <% if (order.getOrderDetails().size() > 5) {%>
                        <div class="text-center mt-3">
                            <button class="btn btn-outline-secondary btn-sm" onclick="toggleDishes(<%= orderIndex%>)" id="btn-<%= orderIndex%>">
                                <i class="fas fa-chevron-down me-1"></i>See more
                            </button>
                        </div>
                        <% }%>

                        <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                            <div>
                                <% if (order.getOrderStatus() == 4) {%>
                                <form action="<%= request.getContextPath()%>/customer/view-review" method="post" class="d-inline">
                                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>"/>
                                    <button type="submit" class="btn btn-success btn-sm">
                                        <i class="fas fa-eye me-1"></i>View Reviews
                                    </button>
                                </form>
                                <% } %>
                            </div>
                            <div class="text-end">
                                <h5 class="mb-0 fw-semibold">
                                    Total: <%= String.format("%,.0f", order.getAmount())%> đ
                                </h5>
                            </div>
                        </div>
                    </div>
                    <%
                            orderIndex++;
                        }
                    } else {
                    %>
                    <div class="alert alert-info text-center">
                        <i class="fas fa-shopping-cart fa-3x mb-3 d-block" style="opacity: 0.5;"></i>
                        <h5>You haven't placed any orders yet</h5>
                        <p class="mb-3">Start exploring our delicious menu!</p>
                        <a href="<%= request.getContextPath()%>/customer" class="btn btn-primary">
                            <i class="fas fa-utensils me-2"></i>Browse Menu
                        </a>
                    </div>
                    <% }%>
                </div>
            </div>
        </div>

        <!-- Review Modal -->
        <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form id="reviewForm" method="post" action="${pageContext.request.contextPath}/customer/review" class="modal-content">
                    <div class="modal-header" style="background: linear-gradient(135deg, var(--oiship-orange), #ff8533); color: white;">
                        <h5 class="modal-title" id="reviewModalLabel">
                            <i class="fas fa-star me-2"></i>Review Dish
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="filter: brightness(0) invert(1);"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="odid" id="modalOdid">
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                <i class="fas fa-utensils me-2"></i>Dish:
                            </label>
                            <input type="text" class="form-control" id="modalDishName" name="dishName" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                <i class="fas fa-star me-2"></i>Rating:
                            </label>
                            <select name="rating" class="form-select" required>
                                <option value="">Select rating...</option>
                                <option value="1">⭐ 1 - Poor</option>
                                <option value="2">⭐⭐ 2 - Fair</option>
                                <option value="3">⭐⭐⭐ 3 - Good</option>
                                <option value="4">⭐⭐⭐⭐ 4 - Very Good</option>
                                <option value="5">⭐⭐⭐⭐⭐ 5 - Excellent</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                <i class="fas fa-comment me-2"></i>Comment:
                            </label>
                            <textarea name="comment" class="form-control" rows="4" placeholder="Share your experience with this dish..." required></textarea>
                            <div class="form-text">Maximum 255 characters</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane me-1"></i>Submit Review
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Enhanced Notification Scripts -->
        <script>
            // Global function to open notification modal
            function openNotificationModal(notID, title, description) {
                console.log("Opening notification modal with:", {notID, title, description}); // Debug log

                // First, close any open dropdown
                const notificationDropdown = document.getElementById('notificationDropdown');
                const dropdownInstance = bootstrap.Dropdown.getInstance(notificationDropdown);
                if (dropdownInstance) {
                    dropdownInstance.hide();
                }

                // Remove any existing modal backdrops before opening new modal
                removeModalBackdrops();

                const modalTitle = document.getElementById("modalTitle");
                const modalDescription = document.getElementById("modalDescription");
                const hiddenNotID = document.getElementById("hiddenNotID");

                modalTitle.textContent = title || 'Notification';
                modalDescription.textContent = description || 'No description';
                hiddenNotID.value = notID || '';

                console.log("Hidden input value set to:", hiddenNotID.value); // Debug log

                // Reset button state
                resetMarkReadButton();

                // Wait a bit to ensure dropdown is closed
                setTimeout(() => {
                    // Show the modal
                    const notificationModal = new bootstrap.Modal(document.getElementById('notificationModal'), {
                        backdrop: true,
                        keyboard: true
                    });
                    notificationModal.show();
                }, 150);
            }

            // Function to remove modal backdrops
            function removeModalBackdrops() {
                const backdrops = document.querySelectorAll('.modal-backdrop');
                backdrops.forEach(backdrop => {
                    console.log("Removing backdrop:", backdrop); // Debug log
                    backdrop.remove();
                });
                
                // Reset body styles
                document.body.classList.remove('modal-open');
                document.body.style.overflow = '';
                document.body.style.paddingRight = '';
            }

            document.addEventListener("DOMContentLoaded", function () {
                const markReadBtn = document.getElementById("markReadBtn");
                const hiddenNotID = document.getElementById("hiddenNotID");
                const notificationModal = document.getElementById('notificationModal');

                // Handle mark as read button click
                markReadBtn.addEventListener('click', function (e) {
                    e.preventDefault();

                    const notID = hiddenNotID.value;
                    console.log("Mark read button clicked with notID:", notID); // Debug log

                    if (!notID || notID.trim() === '' || notID === 'null') {
                        console.error('Error: No valid notification ID found, value is:', notID);
                        alert('Error: No valid notification ID found');
                        return;
                    }

                    // Show loading state
                    showLoadingState();

                    // Create form data
                    const formData = new FormData();
                    formData.append('notID', notID.trim());

                    console.log("Sending request with notID:", formData.get('notID')); // Debug log

                    const params = new URLSearchParams();
                    params.append('notID', formData.get('notID'));

                    fetch('${pageContext.request.contextPath}/customer/mark-read', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: params
                    })
                            .then(response => {
                                console.log("Response received, status:", response.status); // Debug log
                                console.log("Response content type:", response.headers.get('content-type')); // Debug log

                                if (!response.ok) {
                                    throw new Error(`HTTP error! status: ${response.status}`);
                                }

                                return response.json();
                            })
                            .then(data => {
                                console.log("Response data:", data); // Debug log

                                if (data.success) {
                                    // Success - show success state
                                    showSuccessState();

                                    // Hide notification from dropdown
                                    hideNotificationFromDropdown(notID);

                                    // Update notification count
                                    updateNotificationCount();

                                    // Close modal properly after delay
                                    setTimeout(() => {
                                        closeModalProperly();
                                    }, 1500);
                                } else {
                                    throw new Error(data.message || 'Failed to mark as read');
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                showErrorState(error.message);
                                // Reset button after error
                                setTimeout(resetMarkReadButton, 3000);
                            });
                });

                function showLoadingState() {
                    markReadBtn.classList.add('loading');
                    markReadBtn.querySelector('.fa-check').style.display = 'none';
                    markReadBtn.querySelector('.fa-spinner').style.display = 'inline-block';
                    markReadBtn.querySelector('.btn-text').textContent = 'Marking as read...';
                    markReadBtn.disabled = true;
                }

                function showSuccessState() {
                    markReadBtn.classList.remove('loading');
                    markReadBtn.querySelector('.fa-spinner').style.display = 'none';
                    markReadBtn.querySelector('.fa-check').style.display = 'inline-block';
                    markReadBtn.querySelector('.btn-text').textContent = 'Marked as Read!';
                    markReadBtn.style.background = 'linear-gradient(135deg, #28a745, #20c997)';
                }

                function showErrorState(message) {
                    markReadBtn.classList.remove('loading');
                    markReadBtn.querySelector('.fa-spinner').style.display = 'none';
                    markReadBtn.querySelector('.fa-check').style.display = 'inline-block';
                    markReadBtn.querySelector('.btn-text').textContent = 'Error: ' + (message || 'Try again');
                    markReadBtn.style.background = 'linear-gradient(135deg, #dc3545, #c82333)';
                }

                function closeModalProperly() {
                    const modalInstance = bootstrap.Modal.getInstance(notificationModal);
                    if (modalInstance) {
                        modalInstance.hide();
                    }
                    
                    // Force cleanup after modal hide
                    setTimeout(() => {
                        removeModalBackdrops();
                    }, 200);
                }

                function hideNotificationFromDropdown(notificationId) {
                    // Find all notification items and remove the one with matching ID
                    const notificationItems = document.querySelectorAll('.notification-dropdown-item');
                    notificationItems.forEach(item => {
                        const onclick = item.getAttribute('onclick');
                        if (onclick && onclick.includes(notificationId)) {
                            const parentLi = item.closest('li');
                            if (parentLi) {
                                parentLi.style.opacity = '0.5';
                                parentLi.style.pointerEvents = 'none';

                                setTimeout(() => {
                                    const nextSibling = parentLi.nextElementSibling;
                                    if (nextSibling && nextSibling.querySelector('.dropdown-divider')) {
                                        nextSibling.remove();
                                    }
                                    parentLi.remove();

                                    // Check if no notifications left
                                    const remainingNotifications = document.querySelectorAll('.notification-dropdown-item').length;
                                    if (remainingNotifications === 0) {
                                        const dropdownMenu = document.querySelector('#notificationDropdown + .dropdown-menu');
                                        if (dropdownMenu) {
                                            dropdownMenu.innerHTML = `
                                            <li class="notification-empty">
                                                <i class="fas fa-bell-slash"></i>
                                                <p class="mb-0">No new notifications</p>
                                            </li>
                                        `;
                                        }
                                    }
                                }, 500);
                            }
                        }
                    });
                }

                function updateNotificationCount() {
                    const countBadge = document.getElementById('notificationBadge');
                    const remainingNotifications = document.querySelectorAll('.notification-dropdown-item').length;

                    if (countBadge) {
                        const newCount = Math.max(0, remainingNotifications - 1);
                        countBadge.textContent = newCount;

                        if (newCount === 0) {
                            countBadge.style.display = 'none';
                        }
                    }
                }

                // Enhanced modal event handlers
                notificationModal.addEventListener('show.bs.modal', function () {
                    console.log("Modal is showing");
                    // Remove any existing backdrops before showing
                    removeModalBackdrops();
                });

                notificationModal.addEventListener('shown.bs.modal', function () {
                    console.log("Modal shown");
                });

                notificationModal.addEventListener('hide.bs.modal', function () {
                    console.log("Modal is hiding");
                });

                notificationModal.addEventListener('hidden.bs.modal', function () {
                    console.log("Modal hidden");
                    // Force cleanup after modal is completely hidden
                    removeModalBackdrops();
                });

                // Handle clicks outside modal to ensure proper cleanup
                document.addEventListener('click', function(e) {
                    if (e.target.classList.contains('modal-backdrop')) {
                        console.log("Clicked on backdrop");
                        removeModalBackdrops();
                    }
                });

                // Cleanup backdrops on page load/reload
                window.addEventListener('load', function() {
                    removeModalBackdrops();
                });
            });

            function resetMarkReadButton() {
                const markReadBtn = document.getElementById("markReadBtn");
                if (markReadBtn) {
                    markReadBtn.classList.remove('loading');
                    markReadBtn.querySelector('.fa-check').style.display = 'inline-block';
                    markReadBtn.querySelector('.fa-spinner').style.display = 'none';
                    markReadBtn.querySelector('.btn-text').textContent = 'Mark as Read';
                    markReadBtn.disabled = false;
                    markReadBtn.style.background = 'linear-gradient(135deg, #28a745, #20c997)';
                }
            }
        </script>

        <script>
            function toggleDishes(index) {
                const list = document.querySelectorAll(`#dishList-${index} .hidden-dish`);
                const btn = document.getElementById(`btn-${index}`);
                
                list.forEach(item => {
                    item.style.display = item.style.display === 'none' ? 'flex' : 'none';
                });
                
                if (btn.textContent.includes('See more')) {
                    btn.innerHTML = '<i class="fas fa-chevron-up me-1"></i>See less';
                } else {
                    btn.innerHTML = '<i class="fas fa-chevron-down me-1"></i>See more';
                }
            }

            // Review Modal Handler
            const reviewModal = document.getElementById('reviewModal');
            reviewModal.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                const odid = button.getAttribute('data-odid');
                const dishName = button.getAttribute('data-dishname');

                document.getElementById('modalOdid').value = odid;
                document.getElementById('modalDishName').value = dishName;
            });

            // Review Form Validation
            const reviewForm = document.querySelector('#reviewModal form');
            reviewForm.addEventListener('submit', function (e) {
                const comment = reviewForm.querySelector('textarea[name="comment"]').value.trim();

                if (comment.length > 255) {
                    e.preventDefault();
                    alert("Comment cannot exceed 255 characters.");
                }
            });

            // Auto-hide alerts
            window.addEventListener("DOMContentLoaded", function () {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    setTimeout(() => {
                        alert.classList.add('fade');
                        setTimeout(() => alert.remove(), 500);
                    }, 3000); // 3 seconds
                });
            });

            // Page loaded confirmation
            console.log("Order History page loaded - 2025-07-29 18:01:07 - User: toanthienla");
        </script>

        <% if ("true".equals(String.valueOf(request.getAttribute("showReviewModal")))) { %>
        <script>
            const reviewModal = new bootstrap.Modal(document.getElementById('reviewModal'));
            reviewModal.show();
            document.getElementById("modalOdid").value = "<%= request.getAttribute("odid") %>";
            document.getElementById("modalDishName").value = "<%= request.getAttribute("dishName") %>";
        </script>
        <% } %>
    </body>
</html>