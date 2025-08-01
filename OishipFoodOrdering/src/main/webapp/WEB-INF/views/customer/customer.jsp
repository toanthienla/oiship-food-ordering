<%@page import="java.util.Map"%>
<%@page import="model.Review"%>
<%@page import="model.Cart"%>
<%@page import="java.util.List"%>
<%@page import="model.Category"%>
<%@page import="model.Dish"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Home - Oiship</title>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap JS (modal cần cái này) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
                padding: 0.6rem 2rem;
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
            /* Enhanced search bar */
            .search-bar-navbar {
                min-width: 260px;
                margin-right: 18px;
                display: flex;
                align-items: center;
                position: relative;
                max-width: 340px;
                flex: 1;
            }
            .search-bar-navbar .form-control {
                border: 1px solid #ececec;
                background: #fffdfa;
                padding: 8px 44px 8px 16px;
                font-size: 1.05rem;
                box-shadow: none;
                color: #232323;
                transition: box-shadow 0.15s;
            }
            .search-bar-navbar .form-control:focus {
                box-shadow: 0 0 0 2px #ffe5d2;
                border-color: #ffba85;
            }
            .search-bar-navbar .search-btn {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                border: none;
                background: none;
                color: var(--oiship-orange);
                font-size: 1.3rem;
                padding: 0 6px;
                cursor: pointer;
                outline: none;
                transition: color 0.18s;
            }
            .search-bar-navbar .search-btn:hover {
                color: #e65c00;
            }
            .hero-section {
                width: 100%;
                height: 380px;
                margin-bottom: 2rem;
                border-radius: var(--oiship-radius);
                overflow: hidden;
                box-shadow: var(--oiship-shadow);
            }
            .carousel-inner img {
                width: 100%;
                height: 380px;
                object-fit: cover;
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

            .main-content {
                margin-left: 250px;
                padding: 20px;
            }

            .menu-section {
                padding: 20px 40px;
            }
            .menu-section h2 {
                font-weight: 700;
                color: var(--oiship-dark);
            }
            .menu-section .menu-btn {
                border-radius: var(--oiship-radius);
                margin-right: 8px;
                padding: 9px 23px;
                font-weight: 600;
                background: #f3f3f3;
                color: #333;
                border: none;
                transition: all 0.25s;
            }
            .menu-section .menu-btn.active,
            .menu-section .menu-btn:hover {
                background: var(--oiship-orange) !important;
                color: #fff !important;
                box-shadow: 0 2px 12px rgba(255,98,0,0.18);
            }
            .dish-section {
                background: #fff;
                border-radius: var(--oiship-radius);
                box-shadow: var(--oiship-shadow);
                margin-bottom: 1.5rem;
                padding: 1.2rem 1.5rem;
            }

            /* Remove button styles and make it full-width */
            .dish-card-button {
                padding: 0;
                border: none;
                background: none;
                width: 100%;
                text-align: left;
            }
            /* Main card style */
            .dish-card {
                border-radius: 3px !important;
                transition: box-shadow 0.22s ease;
                overflow: hidden;
                background: #fff;
                box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
            }
            /* Hover effect: box shadow only, no transform */
            .dish-card:hover {
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            }
            /* Image styling */
            .dish-card img {
                height: 170px;
                object-fit: cover;
                border-radius: var(--oiship-radius, 3px) var(--oiship-radius, 3px) 0 0;
                width: 100%;
                border-bottom: 1px solid #f3f3f3;
                background-color: #f9f9f9;
            }
            /* Body padding */
            .dish-card .card-body {
                padding: 16px 18px;
            }
            /* Align text to left and style title */
            .dish-card .card-title {
                font-size: 1.15rem;
                font-weight: 600;
                color: #232323;
                margin-bottom: 6px;
                text-align: left;
            }
            /* Text description */
            .dish-card .card-text {
                font-size: 1rem;
                color: #666;
                text-align: left;
            }
            /* Price formatting */
            .dish-card .price {
                font-weight: 700;
                font-size: 1.05rem;
                color: var(--oiship-orange, #ff6600);
                text-align: left;
            }

            .pagination-container {
                display: flex;
                justify-content: center;
                gap: 8px;
                margin-top: 30px;
                flex-wrap: wrap;
                user-select: none;
            }
            .pagination-container button {
                background-color: transparent;
                border: none;
                color: #666;
                font-size: 1.15rem;
                padding: 8px 16px;
                border-radius: var(--oiship-radius);
                cursor: pointer;
                transition: all 0.2s;
            }
            .pagination-container button:hover {
                background: #ffe1ce;
            }
            .pagination-container button.active {
                background: var(--oiship-orange);
                color: #fff;
            }
            .pagination-container button:disabled {
                color: #aaa;
                cursor: default;
            }
            .pagination-dots {
                padding: 8px 12px;
                color: #888;
            }
            .ggmap-container {
                width: 100%;
                display: flex;
                justify-content: center;
                margin-bottom: 2rem;
                background: #fff;
                border-radius: var(--oiship-radius);
                box-shadow: var(--oiship-shadow);
                padding: 1.5rem;
            }
            .ggmap-container iframe {
                width: 100%;
                min-height: 320px;
                max-height: 400px;
                border-radius: var(--oiship-radius);
                box-shadow: var(--oiship-shadow);
                border: 0;
            }
            .custom-modal-content {
                border-radius: 12px;
                background: #fffdfa;
                box-shadow: 0 8px 32px rgba(0,0,0,0.18);
                border: none;
                padding: 0;
                overflow: hidden;
                animation: modalFadeIn 0.35s cubic-bezier(.4,0,.2,1);
            }
            @keyframes modalFadeIn {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .custom-modal-content .modal-header {
                background: #ffeadd;
                border-bottom: 1px solid #ffd6b0;
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;
                padding: 1.2rem 2rem 1.2rem 1.7rem;
            }
            .custom-modal-content .modal-title {
                color: #ff6200;
                font-weight: 700;
                font-size: 1.35rem;
                letter-spacing: 1px;
            }
            .custom-modal-content .modal-body {
                padding: 2rem 2.2rem 1.5rem 2.2rem;
                background: #fffdfa;
                font-size: 1.08rem;
                color: #232323;
            }
            .custom-modal-content .modal-footer {
                background: #fff5e6;
                border-top: 1px solid #ffd6b0;
                border-bottom-left-radius: 12px;
                border-bottom-right-radius: 12px;
                padding: 1rem 2rem;
                justify-content: flex-end;
            }
            .custom-modal-content .btn-close {
                filter: invert(42%) sepia(94%) saturate(1632%) hue-rotate(4deg) brightness(105%) contrast(106%);
                opacity: 0.7;
                transition: opacity 0.18s;
            }
            .custom-modal-content .btn-close:hover {
                opacity: 1;
            }

            /* COMPLETELY DISABLE BACKDROPS */
            .modal-backdrop {
                display: none !important;
                opacity: 0 !important;
                visibility: hidden !important;
            }

            .dropdown-backdrop {
                display: none !important;
            }

            /* Enhanced Notification Modal Styles */
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
                border-left: 4px solid var(--oiship-orange);
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                position: relative;
            }

            .notification-description {
                margin: 0;
                line-height: 1.6;
                color: #495057;
                font-size: 1rem;
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

            /* Enhanced Notification Dropdown */
            .notification-dropdown-item {
                padding: 10px;
                border-radius: 8px;
                margin: 4px 8px;
                transition: all 0.2s ease;
                cursor: pointer;
                border-left: 3px solid transparent;
                position: relative;
            }

            .notification-dropdown-item:hover {
                background: var(--oiship-orange-light);
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

            /* Unread notification indicator */
            .notification-unread {
                position: relative;
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

            .cart-success-alert {
                position: fixed;
                top: 0;
                left: 50%;
                transform: translate(-50%, -100%);
                z-index: 1000;
                width: 800px;
                min-height: 100px;
                padding: 15px;
                opacity: 0;
                transition: transform 0.3s ease-in-out, opacity 0.3s ease-in-out;
            }
            .cart-success-alert.show {
                transform: translate(-50%, 20px);
                opacity: 1;
            }
            .cart-success-alert .alert {
                display: flex;
                justify-content: space-between;
                align-items: center;
                width: 100%;
                height: 100%;
                background-color: #d4edda;
                border-color: #c3e6cb;
                border-radius: var(--oiship-radius);
            }
            .cart-success-alert img {
                width: 60px;
                height: 60px;
                object-fit: cover;
                margin-right: 15px;
                border-radius: var(--oiship-radius);
            }
            .cart-success-alert .details {
                display: flex;
                flex-grow: 1;
                align-items: center;
                gap: 15px;
                color: #155724;
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

            /* Mobile responsive */
            @media (max-width: 768px) {
                .notification-modal-content {
                    margin: 10px;
                }

                .notification-header {
                    padding: 15px 20px;
                }

                .notification-body {
                    padding: 20px;
                }

                .notification-actions {
                    flex-direction: column;
                }

                .btn-mark-read,
                .btn-dismiss {
                    width: 100%;
                }

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
                .menu-section,
                .dish-section {
                    padding: 1rem 0.5rem;
                }
                .hero-section,
                .carousel-inner img {
                    height: 180px;
                }
                .ggmap-container iframe {
                    min-height: 220px;
                }
                .custom-modal-content .modal-body,
                .custom-modal-content .modal-header,
                .custom-modal-content .modal-footer {
                    padding-left: 1rem;
                    padding-right: 1rem;
                }
                .search-bar-navbar {
                    min-width: 120px;
                    margin-right: 5px;
                }
            }

            @media (max-width: 1199px) {
                .hero-section {
                    height: 260px;
                }
                .carousel-inner img {
                    height: 260px;
                }
            }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <div class="sidebar-content">
                <a href="customer" class="active">
                    <i class="fas fa-home me-2"></i> Home
                </a>

                <a href="customer/view-vouchers-list">
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
                <a href="customer/order">
                    <i class="fas fa-list me-2"></i> Order
                </a>

                <a href="customer/contact">
                    <i class="fas fa-phone me-2"></i> Contact
                </a>
            </div>

            <!-- Logo at bottom -->
            <div class="sidebar-logo">
                <div class="text-center">
                    <img src="images/logo_1.png" alt="Oiship Logo" class="img-fluid" />
                </div>
            </div>
        </div>

        <div class="main-content">
            <nav class="navbar navbar-expand-lg oiship-navbar mb-3">
                <div class="container-fluid">
                    <form id="dishSearchForm" class="search-bar-navbar" role="search">
                        <input class="form-control" type="text" id="searchQuery" placeholder="Search for dishes..." />
                        <button class="search-btn" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>

                    <div class="d-flex align-items-center">
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

                            <!-- Enhanced Notification Modal -->
                            <div class="modal" id="notificationModal" tabindex="-1" aria-labelledby="notificationModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                    <div class="modal-content notification-modal-content">
                                        <div class="modal-header notification-header">
                                            <div class="notification-icon">
                                                <i class="fas fa-bell"></i>
                                            </div>
                                            <div class="notification-title-area">
                                                <h5 class="modal-title notification-title" id="modalTitle"></h5>
                                                <span class="notification-timestamp" id="modalTimestamp">2025-07-31 07:39:35</span>
                                            </div>
                                        </div>

                                        <div class="modal-body notification-body">
                                            <div class="notification-content">
                                                <p id="modalDescription" class="notification-description"></p>
                                            </div>

                                            <div class="notification-actions">
                                                <input type="hidden" id="hiddenNotID" />
                                                <button type="button" class="btn btn-mark-read" id="markReadBtn">
                                                    <i class="fas fa-check me-2 text-white"></i>
                                                    <i class="fas fa-spinner me-2" style="display: none;"></i>
                                                    <span class="btn-text text-white">Mark as Read</span>
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
                                <li><a class="dropdown-item" href="customer/profile">Settings</a></li>
                                <li><a class="dropdown-item" href="logout">Log out</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </nav>

            <!-- Menu Section -->
            <div id="menu" class="menu-section">
                <h2 class="mb-4">MENU CATEGORIES</h2>
                <div class="d-flex flex-wrap gap-2 overflow-auto pb-2" style="scrollbar-width: none;">
                    <button class="btn menu-btn active" onclick="loadDishesByCategory('all')" id="allCategoryBtn">All</button>

                    <%
                        List<Category> categories = (List<Category>) request.getAttribute("categories");
                        if (categories != null) {
                            for (model.Category cat : categories) {
                    %>
                    <button class="btn menu-btn"
                            onclick="loadDishesByCategory(<%= cat.getCatID()%>)">
                        <%= cat.getCatName()%>
                    </button>
                    <%
                            }
                        }
                    %>
                </div>
            </div>
            <div id="dish-container">
                <jsp:include page="dish_category.jsp" />
            </div>

            <!-- Pagination Controls -->
            <div class="pagination-container">
                <button id="prevPageBtn" class="page-btn rounded">&laquo;</button>
                <div id="pageNumbers" class="d-flex gap-2"></div>
                <button id="nextPageBtn" class="page-btn rounded">&raquo;</button>
            </div>
            <%
                String errorMessage = (String) session.getAttribute("errorMessage");
                if (errorMessage != null) {
                    session.removeAttribute("errorMessage"); // Clear to avoid repeat
%>

            <div class="cart-success-alert" id="cartSuccessAlert" style="max-width: 400px; margin: 0 auto;">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= errorMessage%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </div>

            <%
                }
            %>


            <!-- Top Cart Success Alert with Animation -->
            <%
                Map<String, Object> cartSuccessDetails = (Map<String, Object>) session.getAttribute("cartSuccessDetails");
                if (cartSuccessDetails != null) {
                    session.removeAttribute("cartSuccessDetails"); // Clear session to avoid repeated display
%>
            <div class="cart-success-alert" id="cartSuccessAlert">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <img src="<%= cartSuccessDetails.get("image")%>" alt="Dish Image" class="img-fluid">
                    <div class="details">
                        <p><strong><%= cartSuccessDetails.get("name")%></strong></p>
                        <p><strong>Quantity:</strong> <%= cartSuccessDetails.get("quantity")%></p>
                        <p>Has been added to cart!</p>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </div>
            <%
                }
            %>

            <!-- Google Maps Section -->
            <div class="ggmap-container mt-5">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3929.0533542569997!2d105.72985667627817!3d10.012451790093571!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31a0890033b0a4d5%3A0x5360c94ba9e67842!2zNjAwIE5ndXnhu4VuIFbEg24gQ-G7qyBO4buRaSBEw6BpLCBBbiBCw6xuaCwgQsOsbmggVGjhu6d5LCBD4bqnbiBUaMahIDkwMDAwMCwgVmlldG5hbQ!5e0!3m2!1sen!2s!4v1753718607908!5m2!1sen!2s" 
                        allowfullscreen="" 
                        loading="lazy" 
                        referrerpolicy="no-referrer-when-downgrade">
                </iframe>
            </div>

        </div>

        <!-- 💡 Modal Dish Detail -->
        <div class="modal" id="dishDetailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content custom-modal-content" id="dishDetailContent">
                    <!-- AJAX content goes here -->
                </div>
            </div>
        </div>

        <script>
            // Animate and auto-disappear cart success alert
            document.addEventListener('DOMContentLoaded', function () {
                console.log("Page loaded - 2025-07-31 07:39:35 - User: toanthienla");

                const alert = document.getElementById('cartSuccessAlert');
                if (alert) {
                    // Add show class for animation
                    setTimeout(() => alert.classList.add('show'), 10); // Slight delay to trigger transition

                    // Auto-disappear after 3 seconds
                    setTimeout(() => {
                        alert.classList.remove('show');
                        setTimeout(() => alert.remove(), 200); // Remove after fade-out
                    }, 2000);
                }
            });
        </script>



        <script>
            function openDishDetail(dishId) {
                fetch('<%=request.getContextPath()%>/customer/dish-detail', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'dishId=' + dishId
                })
                        .then(response => response.text())
                        .then(html => {
                            const content = document.getElementById('dishDetailContent');
                            content.innerHTML = html;

                            const modalEl = document.getElementById('dishDetailModal');
                            const dishModal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                            dishModal.show();
                        })
                        .catch(error => {
                            alert("Failed to load dish detail. Please try again.");
                            console.error('Error loading dish detail:', error);
                        });
            }

            document.getElementById('dishDetailModal').addEventListener('hidden.bs.modal', function () {
                document.getElementById('dishDetailContent').innerHTML = '';
            });
        </script>

        <script>
            function loadDishesByCategory(catId) {
                document.querySelectorAll('.menu-btn').forEach(btn => btn.classList.remove('active'));
                event.target.classList.add('active');

                fetch('<%= request.getContextPath()%>/customer/dish-detail', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'catId=' + catId
                })
                        .then(response => response.text())
                        .then(html => {
                            document.getElementById('dish-container').innerHTML = html;
                            setupPagination();
                        })
                        .catch(error => {
                            console.error('Error loading dishes:', error);
                        });
            }

            // Function to activate All category button
            function activateAllCategory() {
                document.querySelectorAll('.menu-btn').forEach(btn => btn.classList.remove('active'));
                document.getElementById('allCategoryBtn').classList.add('active');
            }
        </script>

        <script>
            document.addEventListener("DOMContentLoaded", () => {
                const form = document.getElementById("dishSearchForm");
                const input = document.getElementById("searchQuery");
                const dishContainer = document.getElementById("dish-container");

                form.addEventListener("submit", function (event) {
                    event.preventDefault();

                    const query = input.value.trim();

                    // Activate All category when searching
                    activateAllCategory();

                    fetch("<%=request.getContextPath()%>/customer/search-dish", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded"
                        },
                        body: new URLSearchParams({
                            searchQuery: query
                        })
                    })
                            .then(response => response.text())
                            .then(data => {
                                dishContainer.innerHTML = data;
                                setupPagination(); // Setup pagination for search results
                            })
                            .catch(error => {
                                console.error("Search error:", error);
                            });
                });
            });
        </script>

        <script>
            function setupPagination() {
                const itemsPerPage = 15;
                const dishes = Array.from(document.querySelectorAll(".dish-item"));
                const totalPages = Math.ceil(dishes.length / itemsPerPage);
                let currentPage = 1;

                const prevBtn = document.getElementById("prevPageBtn");
                const nextBtn = document.getElementById("nextPageBtn");
                const pageNumbers = document.getElementById("pageNumbers");

                function showPage(page) {
                    dishes.forEach((item, index) => {
                        item.style.display = "none";
                    });

                    const start = (page - 1) * itemsPerPage;
                    const end = start + itemsPerPage;
                    dishes.slice(start, end).forEach(item => {
                        item.style.display = "block";
                    });

                    document.querySelectorAll("#pageNumbers button").forEach(btn => {
                        btn.classList.remove("active");
                    });

                    const activeBtn = document.getElementById(`pageBtn${page}`);
                    if (activeBtn) {
                        activeBtn.classList.add("active");
                    }

                    prevBtn.disabled = (page === 1);
                    nextBtn.disabled = (page === totalPages);
                }

                function createPagination() {
                    pageNumbers.innerHTML = "";

                    const maxVisible = 5;
                    let startPage = Math.max(currentPage - 2, 1);
                    let endPage = Math.min(startPage + maxVisible - 1, totalPages);

                    if (endPage - startPage < maxVisible - 1) {
                        startPage = Math.max(endPage - maxVisible + 1, 1);
                    }

                    if (startPage > 1) {
                        appendPageButton(1);
                        if (startPage > 2) {
                            pageNumbers.appendChild(createDots());
                        }
                    }

                    for (let i = startPage; i <= endPage; i++) {
                        appendPageButton(i);
                    }

                    if (endPage < totalPages) {
                        if (endPage < totalPages - 1) {
                            pageNumbers.appendChild(createDots());
                        }
                        appendPageButton(totalPages);
                    }
                }

                function appendPageButton(i) {
                    const btn = document.createElement("button");
                    btn.id = `pageBtn${i}`;
                    btn.textContent = i;
                    btn.className = i === currentPage ? "active" : "";
                    btn.addEventListener("click", () => {
                        currentPage = i;
                        showPage(currentPage);
                        createPagination();
                    });
                    pageNumbers.appendChild(btn);
                }

                function createDots() {
                    const span = document.createElement("span");
                    span.textContent = "...";
                    span.className = "pagination-dots";
                    return span;
                }

                prevBtn.onclick = () => {
                    if (currentPage > 1) {
                        currentPage--;
                        showPage(currentPage);
                        createPagination();
                    }
                };

                nextBtn.onclick = () => {
                    if (currentPage < totalPages) {
                        currentPage++;
                        showPage(currentPage);
                        createPagination();
                    }
                };

                createPagination();
                showPage(currentPage);
            }

            document.addEventListener('DOMContentLoaded', () => {
                setupPagination();
            });
        </script>

        <!-- FIXED NOTIFICATION SCRIPTS WITH NO BACKDROP -->
        <script>
            // Enhanced backdrop removal function
            function removeModalBackdrops() {
                // Remove all types of backdrops
                const backdrops = document.querySelectorAll('.modal-backdrop, .modal-backdrop.show, .modal-backdrop.fade, .dropdown-backdrop');
                backdrops.forEach(backdrop => {
                    console.log("Removing backdrop:", backdrop, "- 2025-07-31 07:39:35 - User: toanthienla");
                    backdrop.remove();
                });

                // Reset body styles completely
                document.body.classList.remove('modal-open');
                document.body.style.overflow = '';
                document.body.style.paddingRight = '';
                document.body.style.marginRight = '';
            }

            // FIXED: Global function to open notification modal WITHOUT BACKDROP
            function openNotificationModal(notID, title, description) {
                console.log("Opening notification modal - 2025-07-31 07:39:35 - User: toanthienla");
                console.log("NotID:", notID, "Title:", title);

                // 1. IMMEDIATELY prevent any backdrop creation
                removeModalBackdrops();

                // 2. Close dropdown WITHOUT backdrop
                const notificationDropdown = document.getElementById('notificationDropdown');
                const dropdownInstance = bootstrap.Dropdown.getInstance(notificationDropdown);
                if (dropdownInstance) {
                    dropdownInstance.hide();
                    // Force remove dropdown classes
                    notificationDropdown.classList.remove('show');
                    const dropdownMenu = notificationDropdown.nextElementSibling;
                    if (dropdownMenu) {
                        dropdownMenu.classList.remove('show');
                    }
                }

                // 3. Force close any existing modals
                const existingModals = document.querySelectorAll('.modal.show');
                existingModals.forEach(modal => {
                    const modalInstance = bootstrap.Modal.getInstance(modal);
                    if (modalInstance)
                        modalInstance.hide();
                });

                // 4. Clean body classes immediately
                document.body.classList.remove('modal-open');
                document.body.style.overflow = '';
                document.body.style.paddingRight = '';

                // 5. Set modal content
                const modalTitle = document.getElementById("modalTitle");
                const modalDescription = document.getElementById("modalDescription");
                const hiddenNotID = document.getElementById("hiddenNotID");

                modalTitle.textContent = title || 'Notification';
                modalDescription.textContent = description || 'No description';
                hiddenNotID.value = notID || '';

                console.log("Hidden input value set to:", hiddenNotID.value);

                // Reset button state
                resetMarkReadButton();

                // 6. Show modal with NO BACKDROP after short delay
                setTimeout(() => {
                    removeModalBackdrops(); // One more cleanup

                    const notificationModal = document.getElementById('notificationModal');

                    // Create modal instance with NO BACKDROP
                    const modalInstance = new bootstrap.Modal(notificationModal, {
                        backdrop: false, // ✅ COMPLETELY DISABLE BACKDROP
                        keyboard: true,
                        focus: true
                    });

                    modalInstance.show();
                    console.log("Modal shown without backdrop - 2025-07-31 07:39:35 - User: toanthienla");
                }, 50); // Minimal delay
            }

            document.addEventListener("DOMContentLoaded", function () {
                console.log("DOM loaded - 2025-07-31 07:39:35 - User: toanthienla");

                const markReadBtn = document.getElementById("markReadBtn");
                const hiddenNotID = document.getElementById("hiddenNotID");
                const notificationModal = document.getElementById('notificationModal');

                // Handle mark as read button click
                markReadBtn.addEventListener('click', function (e) {
                    e.preventDefault();

                    const notID = hiddenNotID.value;
                    console.log("Mark read button clicked with notID:", notID, "- 2025-07-31 07:39:35 - User: toanthienla");

                    if (!notID || notID.trim() === '' || notID === 'null') {
                        console.error('Error: No valid notification ID found, value is:', notID);
                        alert('Error: No valid notification ID found');
                        return;
                    }

                    // Show loading state
                    showLoadingState();

                    const params = new URLSearchParams();
                    params.append('notID', notID.trim());

                    fetch('<%=request.getContextPath()%>/customer/mark-read', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: params
                    })
                            .then(response => {
                                console.log("Response received, status:", response.status, "- 2025-07-31 07:39:35 - User: toanthienla");

                                if (!response.ok) {
                                    throw new Error(`HTTP error! status: ${response.status}`);
                                }

                                return response.json();
                            })
                            .then(data => {
                                console.log("Response data:", data, "- 2025-07-31 07:39:35 - User: toanthienla");

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
                                console.error('Error:', error, "- 2025-07-31 07:39:35 - User: toanthienla");
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
                    }, 100);
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
                    console.log("Modal is showing - 2025-07-31 07:39:35 - User: toanthienla");
                    removeModalBackdrops();
                });

                notificationModal.addEventListener('shown.bs.modal', function () {
                    console.log("Modal shown - 2025-07-31 07:39:35 - User: toanthienla");
                });

                notificationModal.addEventListener('hide.bs.modal', function () {
                    console.log("Modal is hiding - 2025-07-31 07:39:35 - User: toanthienla");
                });

                notificationModal.addEventListener('hidden.bs.modal', function () {
                    console.log("Modal hidden - 2025-07-31 07:39:35 - User: toanthienla");
                    removeModalBackdrops();
                });

                // Cleanup backdrops on page load
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>