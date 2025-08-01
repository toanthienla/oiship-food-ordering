<%@page import="model.Customer"%>
<%@page import="java.util.List"%>
<%@page import="model.Voucher"%>
<%@page import="model.Dish"%>
<%@page import="model.Cart"%>
<%@page import="java.math.BigDecimal"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Confirm Order - Oiship</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <!-- Mapbox CSS -->
        <link href="https://api.mapbox.com/mapbox-gl-js/v2.15.0/mapbox-gl.css" rel="stylesheet" />
        <link href="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v4.7.2/mapbox-gl-geocoder.css" rel="stylesheet" />
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

            /* Page Title */
            .page-title {
                color: var(--oiship-dark);
                font-weight: 600;
                font-size: 2rem;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid var(--oiship-orange);
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .page-title i {
                color: var(--oiship-orange);
            }

            /* Enhanced Form Styles */
            .form-section {
                background: #fff;
                border-radius: 8px;
                padding: 25px;
                margin-bottom: 20px;
                box-shadow: var(--oiship-shadow);
                border: 1px solid #e9ecef;
            }

            .section-title {
                color: var(--oiship-orange);
                font-weight: 600;
                font-size: 1.1rem;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .customer-info-box {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .customer-info-box:hover {
                border-color: var(--oiship-orange);
                background: var(--oiship-orange-light);
                transform: translateY(-2px);
                box-shadow: var(--oiship-shadow);
            }

            .customer-info-box .title {
                font-weight: bold;
                font-size: 14px;
                color: #555;
            }

            .customer-info-box .value {
                font-size: 16px;
                color: var(--oiship-dark);
            }

            .customer-info-box .icon {
                font-size: 1.4rem;
                color: var(--oiship-orange);
            }

            /* Cart Item Styles */
            .cart-item-row {
                background: #fff;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                transition: all 0.3s ease;
            }

            .cart-item-row:hover {
                border-color: var(--oiship-orange);
                box-shadow: var(--oiship-shadow);
            }

            .cart-item-row img {
                border-radius: 8px;
                border: 2px solid var(--oiship-orange-light);
            }

            /* Enhanced Buttons */
            .btn-primary {
                background: linear-gradient(135deg, var(--oiship-orange), #ff8533);
                border: none;
                font-weight: 600;
                padding: 12px 30px;
                border-radius: 25px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(255, 98, 0, 0.3);
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #e65c00, #e67700);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255, 98, 0, 0.4);
            }

            .btn-outline-secondary {
                border-color: var(--oiship-orange);
                color: var(--oiship-orange);
                font-weight: 500;
                border-radius: 20px;
                transition: all 0.3s ease;
            }

            .btn-outline-secondary:hover {
                background-color: var(--oiship-orange);
                border-color: var(--oiship-orange);
                color: white;
            }

            /* Voucher Styles */
            .voucher-card {
                transition: all 0.3s ease;
                border: 1px solid #e9ecef;
                cursor: pointer;
            }

            .voucher-card:hover {
                border-color: var(--oiship-orange);
                background: var(--oiship-orange-light);
                transform: translateY(-2px);
                box-shadow: var(--oiship-shadow);
            }

            /* Accordion Styles */
            .accordion-button {
                background: var(--oiship-orange-light);
                color: var(--oiship-dark);
                font-weight: 600;
            }

            .accordion-button:not(.collapsed) {
                background: var(--oiship-orange);
                color: white;
            }

            .accordion-button:focus {
                box-shadow: 0 0 0 0.25rem rgba(255, 98, 0, 0.25);
            }

            /* Mini Map Styles */
            #miniMap {
                border-radius: 8px;
                border: 2px solid var(--oiship-orange-light);
                overflow: hidden;
            }

            /* Summary Section */
            .order-summary {
                background: linear-gradient(135deg, var(--oiship-orange-light), #fff8f0);
                border: 1px solid var(--oiship-orange);
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .summary-row {
                display: flex;
                justify-content: between;
                margin-bottom: 8px;
                padding: 5px 0;
            }

            .summary-row.total {
                border-top: 2px solid var(--oiship-orange);
                padding-top: 10px;
                margin-top: 10px;
                font-weight: 600;
                font-size: 1.1rem;
                color: var(--oiship-dark);
            }

            /* Error Styles */
            .error-message {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
                padding: 8px 12px;
                border-radius: 4px;
                font-size: 0.875rem;
                margin-top: 5px;
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

                .page-title {
                    font-size: 1.5rem;
                }

                .form-section {
                    padding: 15px;
                }

                #miniMap {
                    width: 100% !important;
                    height: 150px !important;
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
                <h1 class="page-title">
                    <i class="fas fa-check-circle"></i>
                    Confirm Order
                </h1>

                <!-- FORM -->
                <form id="orderForm" action="${pageContext.request.contextPath}/customer/order" method="post">
                    <input type="hidden" name="action" value="confirm" />
                    <input type="hidden" name="voucherID" id="hiddenVoucherID" />
                    <input type="hidden" name="fullname" id="hiddenFullName" value="${customer.fullName}" />
                    <input type="hidden" name="phone" id="hiddenPhone" value="${customer.phone}" />
                    <input type="hidden" name="address" id="hiddenAddress" value="${customer.address}" />
                    <input type="hidden" name="paymentMethod" id="paymentMethod" value="cash" />

                    <!-- Row chứa 2 cột -->
                    <div class="row gx-4 gy-4">
                        <!-- LEFT COLUMN -->
                        <div class="col-lg-7 d-flex flex-column">
                            <div class="form-section">
                                <h5 class="section-title">
                                    <i class="fas fa-truck"></i>
                                    Delivery Information
                                </h5>

                                <!-- Customer Info -->
                                <div class="customer-info-box d-flex justify-content-between align-items-center" onclick="openEditCustomer()">
                                    <div>
                                        <div class="title">Customer</div>
                                        <div class="value" id="displayCustomerText">${customer.fullName} - ${customer.phone}</div>
                                        <div id="phoneError" class="error-message" style="display: none;">Please enter a valid phone number.</div>
                                    </div>
                                    <i class="fas fa-edit icon"></i>
                                </div>

                                <!-- Address Info -->
                                <div class="customer-info-box d-flex justify-content-between align-items-center" onclick="openEditCustomer()">
                                    <div style="width: 100%;">
                                        <div class="title">Delivery Address</div>
                                        <div class="value" id="displayAddressText">${customer.address}</div>
                                        <div id="addressError" class="error-message" style="display: none;">Please enter your delivery address.</div>
                                        <div id="miniMap" style="height: 200px; width: 100%; margin-top: 10px; display: none;"></div>
                                    </div>
                                </div>

                                <!-- Payment Option - Auto Expanded -->
                                <div class="accordion mt-4" id="deliveryAccordion">
                                    <div class="accordion-item">
                                        <h2 class="accordion-header" id="headingPayment">
                                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePayment" aria-expanded="true" aria-controls="collapsePayment">
                                                <i class="fas fa-credit-card me-2"></i>
                                                Payment Option
                                            </button>
                                        </h2>
                                        <div id="collapsePayment" class="accordion-collapse collapse show" aria-labelledby="headingPayment" data-bs-parent="#deliveryAccordion">
                                            <div class="accordion-body">
                                                <div class="form-check mb-2">
                                                    <input class="form-check-input" type="radio" name="payment" value="cash" id="paymentCash" checked>
                                                    <label class="form-check-label" for="paymentCash">
                                                        <i class="fas fa-money-bill-wave me-2"></i>
                                                        Cash on Delivery
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="payment" value="bank_transfer" id="paymentBankTransfer">
                                                    <label class="form-check-label" for="paymentBankTransfer">
                                                        <i class="fas fa-university me-2"></i>
                                                        Bank Transfer
                                                    </label>
                                                </div>
                                                <div class="text-danger mt-2" id="errorMsg"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- RIGHT COLUMN -->
                        <div class="col-lg-5 d-flex flex-column">
                            <div class="form-section">
                                <h5 class="section-title">
                                    <i class="fas fa-utensils"></i>
                                    Selected Dishes
                                </h5>

                                <% List<Cart> selectedCarts = (List<Cart>) request.getAttribute("selectedCarts");
                                    BigDecimal grandTotal = (BigDecimal) request.getAttribute("grandTotal");
                                    for (Cart cart : selectedCarts) {
                                        Dish dish = cart.getDish();
                                        BigDecimal price = dish.getTotalPrice();
                                        BigDecimal total = price.multiply(BigDecimal.valueOf(cart.getQuantity()));
                                        int cartId = cart.getCartID();
                                %>
                                <div class="cart-item-row d-flex align-items-center">
                                    <img src="<%= dish.getImage()%>" width="80" class="me-3">
                                    <div class="flex-grow-1">
                                        <strong><%= dish.getDishName()%></strong><br/>

                                        <!-- Nút tăng giảm -->
                                        <div class="d-flex align-items-center gap-2 mt-2">
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="updateQuantity(<%= cartId%>, -1)">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <input type="text" id="qty_<%= cartId%>" value="<%= cart.getQuantity()%>" 
                                                   data-stock="<%= dish.getStock()%>"
                                                   class="form-control text-center" style="width: 60px;"
                                                   oninput="manualUpdate(<%= cartId%>)">
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="updateQuantity(<%= cartId%>, 1)">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>

                                        <!-- Tổng tiền theo món -->
                                        <div class="mt-2">
                                            <strong>Total: <span class="item-total" data-price="<%= price.intValue()%>"><%= String.format("%,.0f", total)%></span> đ</strong>
                                        </div>
                                    </div>
                                </div>
                                <% }%>

                                <!-- Voucher -->
                                <div class="mb-4 mt-4">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-ticket-alt me-2"></i>
                                        Discount Code
                                    </label>
                                    <div class="customer-info-box" data-bs-toggle="modal" data-bs-target="#voucherModal">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="title">Choose a discount code</div>
                                                <small class="text-muted" id="voucherStatusText">Not applied</small>
                                            </div>
                                            <i class="fas fa-chevron-right icon"></i>
                                        </div>
                                    </div>
                                </div>

                                <!-- Summary -->
                                <div class="order-summary">
                                    <div class="summary-row d-flex justify-content-between">
                                        <span>Subtotal:</span>
                                        <span id="totalBefore" data-value="<%= grandTotal%>"><%= String.format("%,.0f", grandTotal)%> đ</span>
                                    </div>
                                    <div class="summary-row d-flex justify-content-between">
                                        <span>Discount:</span>
                                        <span id="discountAmount">- 0 đ</span>
                                    </div>
                                    <div class="summary-row total d-flex justify-content-between">
                                        <span>Total Amount:</span>
                                        <span id="finalAmount"><%= String.format("%,.0f", grandTotal)%> đ</span>
                                    </div>
                                </div>

                                <!-- Hidden cart IDs -->
                                <c:forEach var="id" items="${selectedCartIDs}">
                                    <input type="hidden" name="selectedItems" value="${id}" />
                                </c:forEach>

                                <!-- Confirm button -->
                                <div class="d-grid mt-3">
                                    <button type="button" class="btn btn-primary" onclick="handleSubmit()">
                                        <i class="fas fa-check me-2"></i>
                                        Place Order
                                    </button>
                                    <a href="${pageContext.request.contextPath}/customer/view-cart" class="btn btn-outline-secondary mt-2">
                                        <i class="fas fa-arrow-left me-2"></i>
                                        Back to Cart
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Update Information customer Modal -->
        <div class="modal fade" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            Edit Customer Info
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="modalFullName" class="form-label">
                                Full Name
                            </label>
                            <input type="text" class="form-control" id="modalFullName" />
                        </div>

                        <div class="mb-3">
                            <label for="modalPhone" class="form-label">
                                Phone
                            </label>
                            <input type="text" class="form-control" id="modalPhone" />
                        </div>

                        <div class="mb-3">
                            <label for="modalAddress" class="form-label">
                                Address
                            </label>
                            <div id="mapboxAddressInput" class="geocoder"></div>
                            <input type="hidden" class="form-control" id="modalAddress" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>
                            Cancel
                        </button>
                        <button type="button" class="btn btn-primary" onclick="saveCustomerInfo()">
                            <i class="fas fa-save me-2"></i>
                            Save
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal choose voucher -->
        <div class="modal fade" id="voucherModal" tabindex="-1" aria-labelledby="voucherModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content p-4">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-ticket-alt me-2"></i>
                            Select Voucher
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <%
                                List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
                                if (vouchers != null && !vouchers.isEmpty()) {
                                    for (Voucher v : vouchers) {
                            %>
                            <div class="col-md-6 mb-3">
                                <div class="voucher-card border p-3 rounded shadow-sm h-100"
                                     onclick="selectVoucher('<%= v.getVoucherID()%>', '<%= v.getCode()%>')">
                                    <div class="fw-bold text-danger">
                                        <i class="fas fa-tag me-2"></i>
                                        <%= v.getCode()%>
                                    </div>
                                    <div class="mt-2">
                                        <%= v.getDiscountType().equals("%")
                                                ? ("Giảm " + v.getDiscount() + "%")
                                                : ("Giảm " + String.format("%,.0f", v.getDiscount()) + "đ")%>
                                    </div>
                                    <div class="text-muted mt-1"><%= v.getVoucherDescription()%></div>
                                </div>
                            </div>
                            <% }
                            } else { %>
                            <div class="col-12 text-center text-muted">
                                <i class="fas fa-ticket-alt fa-3x mb-3"></i>
                                <p>No vouchers available</p>
                            </div>
                            <% }%>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>
                            Close
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Mapbox -->
        <script src="https://api.mapbox.com/mapbox-gl-js/v2.15.0/mapbox-gl.js"></script>
        <script src="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v4.7.2/mapbox-gl-geocoder.min.js"></script>

        <script>
                                         function manualUpdate(cartId) {
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
        if (!data.success) {
            if (data.error) {
                alert(data.error);
            }

            let correctedQty = qty;

            if (data.validQuantity !== undefined) {
                correctedQty = data.validQuantity;
                input.value = correctedQty;
            } else if (data.maxStock !== undefined) {
                correctedQty = data.maxStock;
                input.value = correctedQty;
            }

           
            return fetch(contextPath + "/customer/view-cart", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(correctedQty)
            })
            .then(() => {
                
                const row = input.closest(".cart-item-row");
                const price = parseInt(row.querySelector(".item-total").getAttribute("data-price"));
                const total = correctedQty * price;
                row.querySelector(".item-total").textContent = total.toLocaleString();
                recalculateTotal();
            });
        } else {
          
            const row = input.closest(".cart-item-row");
            const price = parseInt(row.querySelector(".item-total").getAttribute("data-price"));
            const updatedQty = parseInt(input.value);
            const total = updatedQty * price;
            row.querySelector(".item-total").textContent = total.toLocaleString();
            recalculateTotal();
        }
    })
    .catch(error => {
        console.error("Error updating cart quantity:", error);
        alert("An unexpected error occurred.");
    });
}



                                         function handleSubmit() {
                                             const selectedPayment = document.querySelector('input[name="payment"]:checked').value;
                                             const address = document.getElementById("hiddenAddress").value.trim();
                                             const phone = document.getElementById("hiddenPhone").value.trim();

                                             const addressError = document.getElementById("addressError");
                                             const phoneError = document.getElementById("phoneError");

                                             let valid = true;

                                             if (!address) {
                                                 addressError.style.display = "block";
                                                 valid = false;
                                             } else {
                                                 addressError.style.display = "none";
                                             }

                                             const phoneRegex = /^0\d{9}$/;
                                             if (!phoneRegex.test(phone)) {
                                                 phoneError.style.display = "block";
                                                 valid = false;
                                             } else {
                                                 phoneError.style.display = "none";
                                             }

                                             if (!valid)
                                                 return;

                                             document.getElementById("paymentMethod").value = selectedPayment;
                                             document.getElementById("orderForm").submit();
                                         }

                                         // Mapbox configuration
                                         mapboxgl.accessToken = 'pk.eyJ1Ijoic3RhZmYxIiwiYSI6ImNtYWZndDRjNzAybGUybG44ZWYzdTlsNWQifQ.jSJjwMo8_OQszYjWAAi7iQ';

                                         const geocoder = new MapboxGeocoder({
                                             accessToken: mapboxgl.accessToken,
                                             placeholder: 'Nhập địa chỉ giao hàng...',
                                             mapboxgl: mapboxgl,
                                             marker: false
                                         });

                                         document.getElementById('mapboxAddressInput').appendChild(geocoder.onAdd(new mapboxgl.Map({
                                             container: document.createElement('div'),
                                             style: 'mapbox://styles/mapbox/streets-v11'
                                         })));

                                         geocoder.on('result', function (e) {
                                             const address = e.result.place_name;
                                             selectedCoordinates = e.result.geometry.coordinates;
                                             document.getElementById('modalAddress').value = address;
                                         });

                                         function openEditCustomer() {
                                             document.getElementById('modalFullName').value = '${customer.fullName}';
                                             document.getElementById('modalPhone').value = '${customer.phone}';
                                             document.getElementById('modalAddress').value = '${customer.address}';
                                             document.querySelector('.mapboxgl-ctrl-geocoder input').value = '${customer.address}';
                                             new bootstrap.Modal(document.getElementById('editCustomerModal')).show();
                                         }

                                         function saveCustomerInfo() {
                                             const name = document.getElementById('modalFullName').value.trim();
                                             const phone = document.getElementById('modalPhone').value.trim();
                                             const address = document.getElementById('modalAddress').value.trim();

                                             if (!name || !phone || !address) {
                                                 alert("Please fill in all fields.");
                                                 return;
                                             }

                                             fetch('${pageContext.request.contextPath}/customer/order', {
                                                 method: 'POST',
                                                 headers: {
                                                     'Content-Type': 'application/x-www-form-urlencoded',
                                                     'X-Requested-With': 'XMLHttpRequest'
                                                 },
                                                 body: new URLSearchParams({
                                                     action: "updateInfo",
                                                     fullName: name,
                                                     phone: phone,
                                                     address: address
                                                 })
                                             })
                                                     .then(res => res.json())
                                                     .then(data => {
                                                         if (data.success) {
                                                             document.getElementById("displayCustomerText").textContent = name + " - " + phone;
                                                             document.getElementById("displayAddressText").textContent = address;
                                                             document.getElementById("hiddenFullName").value = name;
                                                             document.getElementById("hiddenPhone").value = phone;
                                                             document.getElementById("hiddenAddress").value = address;
                                                             bootstrap.Modal.getInstance(document.getElementById('editCustomerModal')).hide();
                                                             showMiniMap(address, selectedCoordinates);
                                                         } else {
                                                             alert("Failed to update customer info.");
                                                         }
                                                     })
                                                     .catch(err => {
                                                         console.error(err);
                                                         alert("Error occurred while updating info.");
                                                     });
                                         }

                                         function showMiniMap(address, coordinates = null) {
                                             const miniMapDiv = document.getElementById("miniMap");
                                             miniMapDiv.innerHTML = "";
                                             miniMapDiv.style.display = "block";

                                             if (coordinates) {
                                                 const [lng, lat] = coordinates;
                                                 const map = new mapboxgl.Map({
                                                     container: 'miniMap',
                                                     style: 'mapbox://styles/mapbox/streets-v11',
                                                     center: [lng, lat],
                                                     zoom: 14
                                                 });
                                                 new mapboxgl.Marker().setLngLat([lng, lat]).addTo(map);
                                                 return;
                                         }
                                         }

                                         // Voucher functionality
                                         const allVouchers = [
            <% for (Voucher v : vouchers) {%>
                                             {
                                                 voucherID: <%= v.getVoucherID()%>,
                                                 code: "<%= v.getCode()%>",
                                                 discountType: "<%= v.getDiscountType()%>",
                                                 discount: <%= v.getDiscount()%>,
                                                 maxDiscountValue: <%= v.getMaxDiscountValue() != null ? v.getMaxDiscountValue() : "null"%>,
                                                 minOrderValue: <%= v.getMinOrderValue()%>
                                             },
            <% }%>
                                         ];

                                         function selectVoucher(voucherID, code) {
                                             const orderTotal = parseFloat(document.getElementById("totalBefore").getAttribute("data-value"));
                                             const voucherText = document.getElementById("voucherStatusText");
                                             const discountText = document.getElementById("discountAmount");
                                             const finalTotalText = document.getElementById("finalAmount");
                                             const hiddenInput = document.getElementById("hiddenVoucherID");

                                             const voucher = allVouchers.find(v => v.voucherID == voucherID);

                                             if (!voucher) {
                                                 alert("Voucher not found.");
                                                 return;
                                             }

                                             if (orderTotal < voucher.minOrderValue) {
                                                 alert("Order has not reached minimum value to apply this code.");
                                                 return;
                                             }

                                             let discountAmount = 0;
                                             if (voucher.discountType === "%") {
                                                 discountAmount = orderTotal * (voucher.discount / 100);
                                                 if (voucher.maxDiscountValue !== null && discountAmount > voucher.maxDiscountValue) {
                                                     discountAmount = voucher.maxDiscountValue;
                                                 }
                                             } else {
                                                 discountAmount = voucher.discount;
                                             }

                                             const finalTotal = orderTotal - discountAmount;

                                             hiddenInput.value = voucherID;
                                             voucherText.textContent = "Applied: " + code;
                                             discountText.textContent = "- " + discountAmount.toLocaleString() + " đ";
                                             finalTotalText.textContent = finalTotal.toLocaleString() + " đ";

                                             const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('voucherModal'));
                                             modal.hide();
                                         }



                                         function recalculateTotal() {
                                             let total = 0;
                                             document.querySelectorAll(".item-total").forEach(el => {
                                                 const val = el.textContent.replace(/[^\d]/g, "");
                                                 if (!isNaN(val))
                                                     total += parseInt(val);
                                             });

                                             document.getElementById("totalBefore").textContent = total.toLocaleString() + " đ";
                                             document.getElementById("finalAmount").textContent = total.toLocaleString() + " đ";
                                             document.getElementById("discountAmount").textContent = "- 0 đ";
                                         }

                                         // Validation
                                         document.getElementById("orderForm").addEventListener("submit", function (event) {
                                             let totalQty = 0;
                                             document.querySelectorAll("input[id^='qty_']").forEach(input => {
                                                 const qty = parseInt(input.value);
                                                 if (!isNaN(qty))
                                                     totalQty += qty;
                                             });

                                             if (totalQty > 50) {
                                                 alert("The total quantity of items in the order must not exceed 50.");
                                                 event.preventDefault();
                                             }
                                         });

                                         document.getElementById("orderForm").addEventListener("submit", function (e) {
                                             const totalBefore = document.getElementById("totalBefore").getAttribute("data-value");
                                             const amount = parseFloat(totalBefore);

                                             if (amount > 2000000) {
                                                 alert("Sorry, orders over 2,000,000 VND are not allowed.");
                                                 e.preventDefault();
                                             }
                                         });

                                         // Page loaded confirmation
                                         console.log("Confirm Order page loaded - 2025-07-31 06:47:52 - User: toanthienla");
        </script>
    </body>
</html>