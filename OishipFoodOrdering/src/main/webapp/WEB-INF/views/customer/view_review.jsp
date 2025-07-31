<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Review" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cart" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");
    String orderID = (String) request.getAttribute("orderID");
    String orderDate = (String) request.getAttribute("orderDate");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Order Reviews - Oiship</title>
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

            /* Content Area */
            .content-wrapper {
                padding: 20px;
                min-height: calc(100vh - 120px);
            }

            .content-container {
                max-width: 800px;
                margin: 0 40px;
            }

            /* Page Title */
            .page-title {
                color: var(--oiship-dark);
                font-weight: 600;
                font-size: 2rem;
                margin-bottom: 10px;
                padding-bottom: 10px;
            }

            /* Order Information Section */
            .order-info {
                background: #fff;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 20px;
                box-shadow: var(--oiship-shadow);
                text-align: left;
                margin-bottom: 20px;
            }

            .order-info h5 {
                color: var(--oiship-orange);
                font-weight: 600;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .order-detail {
                margin-bottom: 8px;
                color: #333;
                font-size: 1rem;
            }

            .order-detail strong {
                color: var(--oiship-dark);
                min-width: 120px;
                display: inline-block;
            }

            .last-updated {
                font-size: 0.9rem;
                color: #666;
                margin-top: 15px;
                padding-top: 15px;
                border-top: 1px solid #eee;
            }

            /* Review Cards */
            .review-card {
                background: #fff;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: var(--oiship-shadow);
            }

            .review-dish {
                font-size: 1.2rem;
                font-weight: 600;
                color: var(--oiship-dark);
                margin-bottom: 10px;
            }

            .review-rating {
                margin-bottom: 10px;
            }

            .stars {
                color: #ffc107;
                margin-right: 10px;
            }

            .rating-text {
                color: #666;
                font-weight: 500;
            }

            .review-comment {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                margin: 15px 0;
                border-left: 3px solid var(--oiship-orange);
            }

            .review-date {
                color: #666;
                font-size: 0.9rem;
                margin-bottom: 15px;
            }

            /* Buttons */
            .btn-delete {
                background: #dc3545;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 4px;
                font-size: 0.9rem;
                cursor: pointer;
                transition: background 0.2s;
            }

            .btn-delete:hover {
                background: #c82333;
            }

            .btn-back {
                background: #6c757d;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                text-decoration: none;
                display: inline-block;
                transition: background 0.2s;
                margin-bottom: 20px;
            }

            .btn-back:hover {
                background: #5a6268;
                color: white;
                text-decoration: none;
            }

            /* No Reviews */
            .no-reviews {
                text-align: center;
                padding: 40px;
                background: #fff;
                border-radius: 8px;
                border: 1px solid #ddd;
            }

            .no-reviews h4 {
                color: var(--oiship-dark);
                margin-bottom: 10px;
            }

            .no-reviews p {
                color: #666;
                margin-bottom: 20px;
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

                .content-container {
                    padding: 10px;
                }

                .page-title {
                    font-size: 1.5rem;
                }

                .review-card {
                    padding: 15px;
                }

                .order-info {
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

            <!-- Content -->
            <div class="content-wrapper">
                <div class="content-container">
                    <h1 class="page-title">Order Reviews</h1>

                    <a href="<%= request.getContextPath()%>/customer/order" class="btn-back">
                        <i class="fas fa-arrow-left"></i> Back to Orders
                    </a>

                    <!-- Basic Order Information -->
                    <div class="order-info">
                        <div class="order-detail">
                            <strong>Order ID:</strong> #<%= orderID != null ? orderID : "N/A"%>
                        </div>
                        <div class="order-detail">
                            <strong>Order Date:</strong> <%= orderDate != null ? orderDate : "N/A"%>
                        </div>
                        <div class="order-detail">
                            <strong>Customer:</strong> toanthienla
                        </div>
                        <div class="last-updated">
                            <i class="fas fa-clock"></i> Last updated: 2025-07-31 06:35:10
                        </div>
                    </div>

                    <%
                        if (reviews != null && !reviews.isEmpty()) {
                            for (Review review : reviews) {
                    %>
                    <div class="review-card">
                        <div class="review-dish">
                            <i class="fas fa-utensils" style="color: var(--oiship-orange); margin-right: 8px;"></i>
                            <%= review.getDishName()%>
                        </div>

                        <div class="review-rating">
                            <span class="stars">
                                <%
                                    int rating = review.getRating();
                                    for (int i = 1; i <= 5; i++) {
                                        if (i <= rating) {
                                %>
                                <i class="fas fa-star"></i>
                                <%
                                } else {
                                %>
                                <i class="far fa-star"></i>
                                <%
                                        }
                                    }
                                %>
                            </span>
                            <span class="rating-text"><%= review.getRating()%> / 5</span>
                        </div>

                        <div class="review-date">
                            <i class="fas fa-calendar" style="margin-right: 5px;"></i>
                            Reviewed on: <%= sdf.format(review.getReviewCreatedAt())%>
                        </div>

                        <div class="review-comment">
                            <%= review.getComment()%>
                        </div>

                        <form action="<%= request.getContextPath()%>/customer/view-review" method="post" 
                              onsubmit="return confirm('Are you sure you want to delete your review for <%= review.getDishName()%>?');" style="text-align: right;">
                            <input type="hidden" name="reviewID" value="<%= review.getReviewID()%>">
                            <input type="hidden" name="orderID" value="<%= orderID%>">
                            <button type="submit" class="btn-delete">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </form>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <div class="no-reviews">
                        <h4>No Reviews for This Order</h4>
                        <p>You haven't submitted any reviews for this order yet.</p>
                        <p><em>Order #<%= orderID != null ? orderID : "N/A"%> • <%= orderDate != null ? orderDate : "N/A"%></em></p>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                  document.addEventListener('DOMContentLoaded', function () {
                                      console.log("Order Reviews page loaded - 2025-07-31 06:35:10 - User: toanthienla");

                                      // Log order information
                                      const orderID = '<%= orderID != null ? orderID : "N/A"%>';
                                      const orderDate = '<%= orderDate != null ? orderDate : "N/A"%>';
                                      const reviewCount = <%= (reviews != null) ? reviews.size() : 0%>;

                                      console.log(`Viewing reviews for Order #${orderID}, Date: ${orderDate}, Total Reviews: ${reviewCount}`);
                                  });
        </script>
    </body>
</html>