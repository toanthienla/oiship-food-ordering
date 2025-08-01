<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cart" %>
<%@ page import="model.Dish" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Your Cart - Oiship</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
                background: var(--oiship-gray);
            }

            /* Navbar Styles */
            .oiship-navbar {
                background: #fff;
                box-shadow: var(--oiship-shadow);
                border-radius: 0 0 var(--oiship-radius) var(--oiship-radius);
                position: sticky;
                top: 0;
                z-index: 100;
                margin: 20px;
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

            /* Cart Container */
            .cart-container {
                border-radius: 12px;
                padding: 20px 40px;
                animation: fadeInUp 0.5s ease;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .cart-title {
                font-weight: 700;
                margin-bottom: 30px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .cart-title i {
                font-size: 2rem;
            }

            /* Table Styles */
            .table {
                border-radius: var(--oiship-radius);
                overflow: hidden;
                box-shadow: var(--oiship-shadow);
            }

            .table th {
                background: linear-gradient(135deg, var(--oiship-orange) 0%, #ff8533 100%);
                color: white;
                border: none;
                font-weight: 600;
                padding: 15px;
            }

            .table td {
                padding: 15px;
                vertical-align: middle;
                border-color: #f0f0f0;
            }

            .table tbody tr {
                transition: all 0.2s ease;
            }

            .table tbody tr:hover {
                background-color: var(--oiship-orange-light);
                transform: scale(1.01);
            }

            .img-thumbnail {
                border-radius: 8px;
                border: 2px solid var(--oiship-orange-light);
                transition: transform 0.2s ease;
            }

            .img-thumbnail:hover {
                transform: scale(1.1);
            }

            /* Button Styles */
            .btn-outline-secondary {
                border-color: var(--oiship-orange);
                color: var(--oiship-orange);
                font-weight: 600;
            }

            .btn-outline-secondary:hover {
                background-color: var(--oiship-orange);
                color: white;
                border-color: var(--oiship-orange);
            }

            .btn-danger {
                background: linear-gradient(135deg, #dc3545, #c82333);
                border: none;
                font-weight: 600;
            }

            .btn-danger:hover {
                background: linear-gradient(135deg, #c82333, #a71e2a);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
            }

            .btn-custom-back {
                background: linear-gradient(135deg, #ffa500, #ff8800);
                color: white;
                border: none;
                font-weight: 600;
                padding: 12px 24px;
            }

            .btn-custom-back:hover {
                background: linear-gradient(135deg, #ff8800, #e67700);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(255, 165, 0, 0.3);
            }

            .btn-success {
                background: linear-gradient(135deg, #28a745, #20c997);
                border: none;
                font-weight: 600;
                padding: 12px 24px;
            }

            .btn-success:hover {
                background: linear-gradient(135deg, #218838, #1fa085);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            }

            /* Checkbox Styles */
            input[type="checkbox"].item-checkbox,
            input[type="checkbox"]#selectAll {
                width: 20px;
                height: 20px;
                accent-color: var(--oiship-orange);
                cursor: pointer;
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
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Alert Styles */
            .alert {
                border-radius: var(--oiship-radius);
                border: none;
                font-weight: 500;
            }

            .alert-danger {
                background: linear-gradient(135deg, #f8d7da, #f5c6cb);
                color: #721c24;
            }

            .alert-warning {
                background: linear-gradient(135deg, #fff3cd, #ffeaa7);
                color: #856404;
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

                .cart-container {
                    margin: 10px;
                    padding: 20px;
                }

                .table-responsive {
                    font-size: 0.9rem;
                }

                .oiship-navbar {
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
                    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
                    int totalDishes = (cartItems != null) ? cartItems.size() : 0;
                %>

                <!-- Cart with badge -->
                <a href="${pageContext.request.contextPath}/customer/view-cart" class="cart-link text-decoration-none position-relative me-2 active">
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
                                                <span class="notification-timestamp" id="modalTimestamp">2025-07-29 14:42:13</span>
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
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/profile">Settings</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Log out</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </nav>

            <!-- Cart Container -->
            <div class="cart-container">
                <h2 class="cart-title">
                    <!--<i class="fas fa-shopping-cart"></i>-->
                    Your Cart
                </h2>

                <%
                    String error = (String) request.getAttribute("error");
                %>

                <% if (error != null) {%>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <%= error%>
                </div>
                <% } %>

                <% if (cartItems != null && !cartItems.isEmpty()) {
                        BigDecimal grandTotal = BigDecimal.ZERO;
                %>
                <div class="table-responsive">
                    <table class="table table-bordered text-center align-middle">
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>
                                <th><i class="fas fa-image me-2"></i>Image</th>
                                <th><i class="fas fa-utensils me-2"></i>Dish</th>
                                <th><i class="fas fa-sort-numeric-up me-2"></i>Quantity</th>
                                <th><i class="fas fa-dollar-sign me-2"></i>Total</th>
                                <th><i class="fas fa-cog me-2"></i>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Cart item : cartItems) {
                                    Dish dish = item.getDish();
                                    int quantity = item.getQuantity();
                                    BigDecimal unitPrice = dish.getTotalPrice();
                                    BigDecimal itemTotal = unitPrice.multiply(BigDecimal.valueOf(quantity));
                                    int stock = dish.getStock();

                                    if (stock > 0) {
                                        grandTotal = grandTotal.add(itemTotal);
                                    }
                            %>
                            <tr>                            
                                <td>
                                    <input type="checkbox"
                                           class="item-checkbox"
                                           value="<%= item.getCartID()%>"
                                           <%= (stock == 0) ? "disabled" : ""%> />
                                </td>                           
                                <td><img src="<%= dish.getImage()%>" width="90" class="img-thumbnail"></td>   
                                <td>
                                    <div class="fw-bold text-start"><%= dish.getDishName()%></div>
                                    <small class="text-muted">Price: <%= dish.getFormattedPrice()%> đ</small>
                                </td>

                                <td>
                                    <% if (stock == 0) { %>
                                    <span class="text-danger fw-semibold">
                                        <i class="fas fa-exclamation-triangle me-1"></i>
                                        Out of stock – please choose another dish
                                    </span>
                                    <% } else {%>
                                    <div class="d-flex justify-content-center align-items-center gap-2">
                                        <button class="btn btn-outline-secondary btn-sm"
                                                onclick="updateQuantity(<%= item.getCartID()%>, -1)">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                        <input type="number"
                                               id="qty_<%= item.getCartID()%>"
                                               data-stock="<%= stock%>"
                                               data-name="<%= dish.getDishName()%>"
                                               value="<%= quantity%>"

                                               required
                                               class="form-control text-center"
                                               style="width: 60px;"
                                               oninput="handleManualQuantityChange(<%= item.getCartID()%>)"
                                               >


                                        <button class="btn btn-outline-secondary btn-sm"
                                                onclick="updateQuantity(<%= item.getCartID()%>, 1)">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </div>
                                    <% }%>
                                </td>                          
                                <td class="item-total" data-price="<%= unitPrice.intValue()%>">
                                    <% if (stock > 0) {%>
                                    <span class="fw-bold text-success">
                                        <%= String.format("%,.0f", itemTotal)%> đ
                                    </span>
                                    <% } else { %>
                                    <span class="text-muted fst-italic">-</span>
                                    <% }%>
                                </td>                          
                                <td>
                                    <form action="<%= request.getContextPath()%>/customer/view-cart"
                                          method="post"
                                          onsubmit="return confirm('Are you sure you want to remove this item?');">
                                        <input type="hidden" name="cartID" value="<%= item.getCartID()%>">
                                        <button type="submit" class="btn btn-danger btn-sm">
                                            <i class="fas fa-trash me-1"></i>Remove
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="alert alert-warning text-center">
                    <i class="fas fa-shopping-cart fa-3x mb-3 d-block" style="opacity: 0.5;"></i>
                    <h5>Your cart is currently empty</h5>
                    <p class="mb-0">Add some delicious dishes to get started!</p>
                </div>
                <% }%>

                <form action="${pageContext.request.contextPath}/customer/order" method="post" id="orderForm">
                    <div class="d-flex justify-content-between mt-4">
                        <a href="<%= request.getContextPath()%>/customer" class="btn btn-custom-back">
                            <i class="fas fa-arrow-left me-2"></i>Back to Menu
                        </a>
                        <button type="submit" class="btn btn-success text-white" onclick="return prepareOrder(event)">
                            <i class="fas fa-shopping-cart me-2"></i>Order Now
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <!-- Cart Functionality Scripts -->
        <script>
            function handleManualQuantityChange(cartId) {
                const input = document.getElementById("qty_" + cartId);
                let value = input.value;
                if (!/^\d+$/.test(value))
                    return;

                updateQuantity(cartId, 0);
            }

            const contextPath = "<%= request.getContextPath()%>";           
            function updateQuantity(cartId, delta) {
    const input = document.getElementById("qty_" + cartId);
    const maxStock = parseInt(input.getAttribute("data-stock"));
    let qty = parseInt(input.value);
    qty += delta;
    input.value = qty;

    fetch(contextPath + "/customer/view-cart", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
    })
    .then(response => response.json())
    .then(data => {
        const row = input.closest("tr");
        const price = parseInt(row.querySelector(".item-total").getAttribute("data-price"));
        let finalQty = qty;

        if (data.success) {
            // Thành công: cập nhật tổng
            const total = qty * price;
            row.querySelector(".item-total").innerHTML = '<span class="fw-bold text-success">' + total.toLocaleString() + ' đ</span>';
            recalculateGrandTotal();
        } else {
            // Bị lỗi: backend trả về validQuantity hoặc maxStock
            if (data.error) alert(data.error);

            if (data.validQuantity !== undefined) {
                finalQty = data.validQuantity;
                input.value = finalQty;
            } else if (data.maxStock !== undefined) {
                finalQty = data.maxStock;
                input.value = finalQty;
            } else {
                // Trường hợp lỗi khác
                return;
            }

            // ✅ Gửi lại request để cập nhật lại DB với số lượng đã được chỉnh
            fetch(contextPath + "/customer/view-cart", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(finalQty)
            })
            .then(() => {
                const total = finalQty * price;
                row.querySelector(".item-total").innerHTML = '<span class="fw-bold text-success">' + total.toLocaleString() + ' đ</span>';
                recalculateGrandTotal();
            });
        }
    })
    .catch(error => {
        console.error("Fetch error:", error);
        alert("An unexpected error occurred. Please try again.");
    });
}




            function recalculateGrandTotal() {
                let total = 0;
                document.querySelectorAll(".item-total").forEach(el => {
                    const text = el.textContent.replace(/[^\d]/g, '');
                    if (!isNaN(text))
                        total += parseInt(text);
                });
                // Optional: Display grand total
                // document.getElementById("grandTotalAmount").textContent = total.toLocaleString() + " đ";
            }

            async function prepareOrder(event) {
                event.preventDefault();

                const checkedItems = document.querySelectorAll('.item-checkbox:checked');
                if (checkedItems.length === 0) {
                    alert("Please select at least one dish to place the order.");
                    return false;
                }

                let isValid = true;
                let totalQty = 0;

                for (const cb of checkedItems) {
                    const cartId = cb.value;
                    const qtyInput = document.getElementById("qty_" + cartId);
                    let qty = parseInt(qtyInput.value);
                    const maxStock = parseInt(qtyInput.getAttribute("data-stock"));
                    const dishName = qtyInput.getAttribute("data-name");

                    if (isNaN(qty) || qty < 1) {
                        alert("The quantity for " + dishName + " is invalid.");
                        qty = 1;
                        qtyInput.value = qty;
                        isValid = false;

                        await fetch(contextPath + "/customer/view-cart", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
                        });

                    } else if (qty > maxStock) {
                        alert("Only " + maxStock + " in stock for " + dishName);
                        qty = maxStock;
                        qtyInput.value = qty;
                        isValid = false;
                        await fetch(contextPath + "/customer/view-cart", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
                        });
                    } else if (qty > 50) {
                        alert("Maximum quantity is 50.");
                        qty = 10;
                        qtyInput.value = qty;
                        isValid = false;
                        await fetch(contextPath + "/customer/view-cart", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
                        });
                    }

                    totalQty += qty;
                }

                if (totalQty > 50) {
                    alert("Total quantity must not exceed 50.");
                    isValid = false;
                }

                if (!isValid) {
                    return false;
                }

                const promises = [];

                checkedItems.forEach(cb => {
                    const cartId = cb.value;
                    const qty = document.getElementById("qty_" + cartId).value;

                    const promise = fetch(contextPath + "/customer/view-cart", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                        body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
                    });

                    promises.push(promise);
                });

                try {
                    await Promise.all(promises);
                } catch (err) {
                    alert("Failed to update quantities. Please try again.");
                    return false;
                }

                const form = document.getElementById('orderForm');
                form.querySelectorAll('input[name="selectedItems"]').forEach(e => e.remove());

                checkedItems.forEach(cb => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'selectedItems';
                    input.value = cb.value;
                    form.appendChild(input);
                });

                form.submit();
                return true;
            }

            function toggleAll(source) {
                const checkboxes = document.querySelectorAll('.item-checkbox:not(:disabled)');
                checkboxes.forEach(cb => cb.checked = source.checked);
            }
        </script>
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
                document.addEventListener('click', function (e) {
                    if (e.target.classList.contains('modal-backdrop')) {
                        console.log("Clicked on backdrop");
                        removeModalBackdrops();
                    }
                });

                // Cleanup backdrops on page load/reload
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