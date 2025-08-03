<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Voucher"%>
<%@page import="model.Cart"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Vouchers - Oiship</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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
            }

            .oiship-navbar {
                background: #fff;
                box-shadow: var(--oiship-shadow);
                border-radius: 0 0 var(--oiship-radius) var(--oiship-radius);
                position: sticky;
                top: 0;
                z-index: 100;
            }
            .oiship-navbar .navbar-brand img {
                height: 42px;
                width: 140px;
                object-fit: contain;
                margin-right: 12px;
                transition: width 0.2s;
            }
            .oiship-navbar .navbar-brand {
                color: var(--oiship-orange) !important;
                font-weight: bold;
                font-size: 1.5rem;
                display: flex;
                align-items: center;
                gap: 6px;
                letter-spacing: 2px;
            }
            .oiship-navbar .nav-link {
                color: #333;
                font-weight: 500;
                margin-right: 8px;
                border-radius: var(--oiship-radius);
                transition: 0.2s;
                padding: 7px 18px;
            }
            .oiship-navbar .nav-link.active,
            .oiship-navbar .nav-link:focus-visible,
            .oiship-navbar .nav-link.show {
                background: var(--oiship-orange-light) !important;
                color: var(--oiship-orange) !important;
                font-weight: 600;
            }
            .oiship-navbar .nav-link:hover:not(.active) {
                background: var(--oiship-orange);
                color: #fff !important;
            }
            .oiship-navbar .badge {
                background: var(--oiship-orange);
                color: #fff;
            }
            .oiship-navbar .dropdown-menu {
                border-radius: var(--oiship-radius);
                box-shadow: var(--oiship-shadow);
            }
            .oiship-navbar .dropdown-item:active {
                background: var(--oiship-orange);
                color: #fff;
            }
            .login-btn {
                background: var(--oiship-orange) !important;
                color: #fff !important;
                border-radius: var(--oiship-radius);
                padding: 7px 22px;
                font-weight: 600;
                border: none;
                transition: background 0.18s;
            }
            .login-btn:hover {
                background: #e65c00 !important;
                color: #fff !important;
            }

            .sidebar {
                width: 250px;
                background-color: #ffffff;
                height: 100vh;
                position: fixed;
                box-shadow: var(--oiship-shadow);
                border-radius: 0 var(--oiship-radius) var(--oiship-radius) 0;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
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

            .sidebar-logo h5 {
                font-weight: 700;
                letter-spacing: 2px;
                margin-bottom: 0;
                text-shadow: 0 1px 2px rgba(255,98,0,0.2);
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

            .main-content {
                margin-left: 250px;
                padding: 20px;
                background: #ffffff;
                min-height: 100vh;
                border-radius: var(--oiship-radius) 0 0 0;
                box-shadow: var(--oiship-shadow);
            }

            .voucher-card {
                border-left: 5px solid var(--oiship-orange);
                box-shadow: var(--oiship-shadow);
                padding: 20px;
                background: linear-gradient(135deg, #ffffff 0%, #fefefe 100%);
                cursor: pointer;
                height: 100%;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                border-radius: var(--oiship-radius);
            }

            .voucher-card::before {
                content: '';
                position: absolute;
                top: 0;
                right: 0;
                width: 40px;
                height: 40px;
                background: var(--oiship-orange-light);
                border-radius: 0 10px 0 40px;
            }

            .voucher-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(255, 98, 0, 0.15);
            }

            .voucher-code {
                font-size: 20px;
                font-weight: bold;
                color: var(--oiship-orange);
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .voucher-discount {
                font-size: 16px;
                margin-top: 8px;
                font-weight: 600;
                color: var(--oiship-dark);
            }

            .voucher-description {
                font-size: 14px;
                margin-top: 8px;
                color: #666;
                line-height: 1.4;
            }

            /* Enhanced Voucher Modal Styles */
            .voucher-modal .modal-content {
                border-radius: 12px;
                border: none;
                box-shadow: 0 8px 32px rgba(0,0,0,0.15);
                overflow: hidden;
            }

            .voucher-modal .modal-header {
                background: linear-gradient(135deg, var(--oiship-orange) 0%, #ff8533 100%);
                color: white;
                border-bottom: none;
                padding: 20px 25px;
            }

            .voucher-modal .modal-title {
                font-weight: 600;
                font-size: 1.25rem;
            }

            .voucher-modal .btn-close {
                filter: brightness(0) invert(1);
                opacity: 0.8;
            }

            .voucher-modal .btn-close:hover {
                opacity: 1;
            }

            .voucher-modal .modal-body {
                padding: 25px;
                background: #fafbfc;
            }

            .voucher-code-display {
                text-align: center;
                margin-bottom: 25px;
                padding: 20px;
                background: white;
                border-radius: 10px;
                border: 2px dashed var(--oiship-orange);
                position: relative;
            }

            .voucher-code-large {
                font-size: 2rem;
                font-weight: bold;
                color: var(--oiship-orange);
                margin-bottom: 10px;
                letter-spacing: 2px;
            }

            .voucher-badge {
                display: inline-block;
                background: var(--oiship-orange);
                color: white;
                padding: 6px 15px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.9rem;
            }

            .voucher-details {
                background: white;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }

            .detail-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 0;
                border-bottom: 1px solid #e9ecef;
            }

            .detail-row:last-child {
                border-bottom: none;
            }

            .detail-label {
                font-weight: 600;
                color: #495057;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .detail-label i {
                color: var(--oiship-orange);
                width: 16px;
            }

            .detail-value {
                color: #6c757d;
                font-weight: 500;
            }

            .voucher-modal .modal-footer {
                background: #f8f9fa;
                border-top: 1px solid #e9ecef;
                padding: 15px 25px;
            }

            /* Notification styles remain the same */
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

            .notification-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(45deg, rgba(255,255,255,0.1) 0%, transparent 100%);
                pointer-events: none;
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
                0%, 50%, 100% {
                    transform: rotate(0deg);
                }
                25% {
                    transform: rotate(-10deg);
                }
                75% {
                    transform: rotate(10deg);
                }
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

            .btn-mark-read::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
                transition: left 0.5s;
            }

            .btn-mark-read:hover::before {
                left: 100%;
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

            .notification-unread {
                position: relative;
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
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

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
                    border-radius: 0;
                }
            }
        </style>
    </head>
    <body>
        <!-- Your existing sidebar -->
        <div class="sidebar">
            <div class="sidebar-content">
                <a href="../home">
                    <i class="fas fa-home me-2"></i> Home
                </a>

                <a href="view-vouchers-list" class="active">
                    <i class="fas fa-tags me-2"></i> Vouchers
                </a>

                <%
                    List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
                    int totalDishes = (cartItems != null) ? cartItems.size() : 0;
                %>

                <a href="${pageContext.request.contextPath}/customer/view-cart" class="cart-link text-decoration-none position-relative me-2">
                    <i class="fas fa-shopping-cart me-2"></i> Cart
                    <% if (totalDishes > 0) {%>
                    <span class="cart-badge">
                        <%= (totalDishes > 7) ? "5+" : totalDishes%>
                    </span>
                    <% }%>
                </a>

                <a href="order">
                    <i class="fas fa-list me-2"></i> Order
                </a>

                <a href="contact">
                    <i class="fas fa-phone me-2"></i> Contact
                </a>
            </div>

            <div class="sidebar-logo">
                <div class="text-center">
                    <img src="../images/logo_1.png" alt="Oiship Logo" class="img-fluid" />
                </div>
            </div>
        </div>

        <div class="main-content">
            <!-- Your existing navbar -->
            <nav class="navbar navbar-expand-lg oiship-navbar mb-3">
                <div class="container-fluid">
                    <div class="d-flex align-items-center ms-auto">
                        <div class="dropdown me-3">
                            <a class="text-decoration-none position-relative dropdown-toggle" href="#" role="button"
                               id="notificationDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-bell fa-lg"></i>
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

                            <!-- Your existing notification modal -->
                            <div class="modal fade" id="notificationModal" tabindex="-1" aria-labelledby="notificationModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                    <div class="modal-content notification-modal-content">
                                        <div class="modal-header notification-header">
                                            <div class="notification-icon">
                                                <i class="fas fa-bell"></i>
                                            </div>
                                            <div class="notification-title-area">
                                                <h5 class="modal-title notification-title" id="modalTitle"></h5>
                                                <span class="notification-timestamp" id="modalTimestamp">2025-08-03 14:59:25</span>
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
                                    Welcome, <span><c:out value="${userName}" default="Guest" /></span>!
                                </div>
                            </a>

                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="../customer/profile">Settings</a></li>
                                <li><a class="dropdown-item" href="../logout">Log out</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </nav>

            <!-- Voucher content with improved modals -->
            <div class="container-fluid" style="padding: 20px;">
                <h3 class="mb-4" style="color: #000000; font-weight: 700">
                    Available Vouchers
                </h3>

                <%
                    List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
                    if (vouchers != null && !vouchers.isEmpty()) {
                        int index = 0;
                %>
                <div class="row mb-4">
                    <%
                        for (Voucher v : vouchers) {
                            String modalId = "voucherModal" + v.getVoucherID();
                    %>
                    <div class="col-md-3 mb-4 d-flex">
                        <div class="voucher-card w-100" data-bs-toggle="modal" data-bs-target="#<%= modalId%>">
                            <div class="voucher-code">
                                <i class="fas fa-tag"></i>
                                <%= v.getCode()%>
                            </div>
                            <div class="voucher-discount">
                                <%= v.getDiscountType().equals("%")
                                        ? "Discount " + v.getDiscount() + "%"
                                        : "Discount ₫" + v.getDiscount()%>
                            </div>
                            <div class="voucher-description"><%= v.getVoucherDescription()%></div>
                        </div>
                    </div>

                    <!-- Improved Voucher Modal -->
                    <div class="modal fade voucher-modal" id="<%= modalId%>" tabindex="-1" aria-labelledby="<%= modalId%>Label" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="<%= modalId%>Label">
                                        <i class="fas fa-ticket-alt me-2"></i>
                                        Voucher Details
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <!-- Voucher Code Display -->
                                    <div class="voucher-code-display">
                                        <div class="voucher-code-large"><%= v.getCode()%></div>
                                        <div class="voucher-badge">
                                            <%= v.getDiscountType().equals("%") ? v.getDiscount() + "% OFF" : "₫" + v.getDiscount() + " OFF"%>
                                        </div>
                                    </div>

                                    <!-- Voucher Details -->
                                    <div class="voucher-details">
                                        <div class="detail-row">
                                            <div class="detail-label">
                                                <i class="fas fa-info-circle"></i>
                                                Description
                                            </div>
                                            <div class="detail-value"><%= v.getVoucherDescription()%></div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-label">
                                                <i class="fas fa-percentage"></i>
                                                Discount Type
                                            </div>
                                            <div class="detail-value">
                                                <%= v.getDiscountType().equals("%") ? "Percentage (" + v.getDiscount() + "%)" : "Fixed Amount (₫" + v.getDiscount() + ")"%>
                                            </div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-label">
                                                <i class="fas fa-coins"></i>
                                                Max Discount Value
                                            </div>
                                            <div class="detail-value">₫<%= v.getMaxDiscountValue()%></div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-label">
                                                <i class="fas fa-shopping-cart"></i>
                                                Min Order Value
                                            </div>
                                            <div class="detail-value">₫<%= v.getMinOrderValue()%></div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-label">
                                                <i class="fas fa-calendar-alt"></i>
                                                Valid From
                                            </div>
                                            <div class="detail-value"><%= v.getStartDate()%></div>
                                        </div>

                                        <div class="detail-row">
                                            <div class="detail-label">
                                                <i class="fas fa-calendar-times"></i>
                                                Valid Until
                                            </div>
                                            <div class="detail-value"><%= v.getEndDate()%></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                        <i class="fas fa-times me-2"></i>Close
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        index++;
                        if (index % 4 == 0 && index != vouchers.size()) {
                    %>
                </div><div class="row mb-4">
                    <%
                            }
                        }
                    %>
                </div>
                <%
                } else {
                %>
                <div class="alert alert-warning">No vouchers available.</div>
                <%
                    }
                %>
            </div>
        </div>

        <!-- Your existing notification scripts -->
        <script>
            // All your existing notification JavaScript code remains the same
            function openNotificationModal(notID, title, description) {
                console.log("Opening notification modal with:", {notID, title, description});

                const notificationDropdown = document.getElementById('notificationDropdown');
                const dropdownInstance = bootstrap.Dropdown.getInstance(notificationDropdown);
                if (dropdownInstance) {
                    dropdownInstance.hide();
                }

                removeModalBackdrops();

                const modalTitle = document.getElementById("modalTitle");
                const modalDescription = document.getElementById("modalDescription");
                const hiddenNotID = document.getElementById("hiddenNotID");

                modalTitle.textContent = title || 'Notification';
                modalDescription.textContent = description || 'No description';
                hiddenNotID.value = notID || '';

                console.log("Hidden input value set to:", hiddenNotID.value);

                resetMarkReadButton();

                setTimeout(() => {
                    const notificationModal = new bootstrap.Modal(document.getElementById('notificationModal'), {
                        backdrop: true,
                        keyboard: true
                    });
                    notificationModal.show();
                }, 150);
            }

            function removeModalBackdrops() {
                const backdrops = document.querySelectorAll('.modal-backdrop');
                backdrops.forEach(backdrop => {
                    console.log("Removing backdrop:", backdrop);
                    backdrop.remove();
                });

                document.body.classList.remove('modal-open');
                document.body.style.overflow = '';
                document.body.style.paddingRight = '';
            }

            document.addEventListener("DOMContentLoaded", function () {
                const markReadBtn = document.getElementById("markReadBtn");
                const hiddenNotID = document.getElementById("hiddenNotID");
                const notificationModal = document.getElementById('notificationModal');

                markReadBtn.addEventListener('click', function (e) {
                    e.preventDefault();

                    const notID = hiddenNotID.value;
                    console.log("Mark read button clicked with notID:", notID);

                    if (!notID || notID.trim() === '' || notID === 'null') {
                        console.error('Error: No valid notification ID found, value is:', notID);
                        alert('Error: No valid notification ID found');
                        return;
                    }

                    showLoadingState();

                    const formData = new FormData();
                    formData.append('notID', notID.trim());

                    console.log("Sending request with notID:", formData.get('notID'));

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
                                console.log("Response received, status:", response.status);
                                console.log("Response content type:", response.headers.get('content-type'));

                                if (!response.ok) {
                                    throw new Error(`HTTP error! status: ${response.status}`);
                                }

                                return response.json();
                            })
                            .then(data => {
                                console.log("Response data:", data);

                                if (data.success) {
                                    showSuccessState();
                                    hideNotificationFromDropdown(notID);
                                    updateNotificationCount();

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

                    setTimeout(() => {
                        removeModalBackdrops();
                    }, 200);
                }

                function hideNotificationFromDropdown(notificationId) {
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

                notificationModal.addEventListener('show.bs.modal', function () {
                    console.log("Modal is showing");
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
                    removeModalBackdrops();
                });

                document.addEventListener('click', function (e) {
                    if (e.target.classList.contains('modal-backdrop')) {
                        console.log("Clicked on backdrop");
                        removeModalBackdrops();
                    }
                });

                window.addEventListener('load', function () {
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
    </body>
</html>