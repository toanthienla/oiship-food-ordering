<%@page import="model.Staff"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Staff - Change Password</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />

        <!-- Sidebar CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css" />

        <!-- Sidebar JS -->
        <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

        <!-- Tailwind CSS (prefix tw-) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tailwind.css" />

        <style>
            body {
                margin: 0;
                font-family: "Segoe UI", sans-serif;
                background-color: white;
                display: flex;
                min-height: 100vh;
            }

            .main {
                margin-left: 250px;
                width: calc(100% - 250px);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                transition: margin-left 0.3s ease-in-out;
            }

            .topbar {
                height: 60px;
                background-color: #fff;
                display: flex;
                justify-content: flex-end;
                align-items: center;
                padding: 0 30px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                z-index: 999;
            }

            .topbar .profile {
                display: flex;
                align-items: center;
                gap: 20px;
                visibility: visible;
                opacity: 1;
            }

            .topbar .profile i {
                font-size: 1.3rem;
                cursor: pointer;
                color: #2c3e50;
            }

            .topbar .username {
                font-weight: 400;
                color: #333;
            }

            .content {
                padding: 30px;
                background-color: white;
                flex-grow: 1;
            }

            .menu-toggle {
                display: none;
                font-size: 1.5rem;
                cursor: pointer;
                color: #333;
            }

            .wellcome-text{
                padding: 8px;
            }

            @media (max-width: 768px) {
                .main {
                    margin-left: 0;
                }

                .main.sidebar-active {
                    margin-left: 250px;
                }

                .menu-toggle {
                    display: block;
                }

                .topbar {
                    position: fixed;
                    justify-content: space-between;
                    top: 0;
                    width: 100%;
                    left: 0;
                }

                .content {
                    padding-top: 90px;
                }

                .topbar .profile {
                    display: flex;
                    visibility: visible;
                    opacity: 1;
                }

                .notification-popup {
                    right: 10px;
                    width: 90%;
                    max-width: 300px;
                }
            }

            @media (max-width: 576px) {
                .main.sidebar-active {
                    margin-left: 200px;
                }
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <jsp:include page="staff_sidebar.jsp" />

        <div class="main">
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile"><span class="username">Hi, Staff</span></div>
            </div>

            <!-- Profile Content -->
            <div class="content mt-4">
                <div class="container" style="max-width: 600px;">
                    <div class="card shadow border-0">
                        <!-- Header -->
                        <div class="card-header text-white" style="background-color: #EF5D10;">
                            <h4 class="mb-0">
                                <i class="bi bi-shield-lock-fill me-2"></i>Change Password
                            </h4>
                        </div>

                        <!-- Form Body -->
                        <div class="card-body bg-light">
                            <form method="post" action="${pageContext.request.contextPath}/staff/profile/change-password">
                                <!-- Current Password -->
                                <div class="mb-3">
                                    <label for="currentPassword" class="form-label">
                                        <i class="bi bi-lock me-1 text-dark"></i>Current Password
                                    </label>
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                </div>

                                <!-- New Password -->
                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">
                                        <i class="bi bi-key me-1 text-dark"></i>New Password
                                    </label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                </div>

                                <!-- Confirm Password -->
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">
                                        <i class="bi bi-check2-circle me-1 text-dark"></i>Confirm New Password
                                    </label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                </div>

                                <!-- Buttons -->
                                <div class="d-flex justify-content-between">
                                    <button type="submit" class="btn text-white" style="background-color: #EF5D10;">
                                        <i class="bi bi-save me-1"></i>Change Password
                                    </button>
                                    <a href="${pageContext.request.contextPath}/staff/profile" class="btn btn-outline-secondary">
                                        <i class="bi bi-x-circle me-1"></i>Cancel
                                    </a>
                                </div>
                            </form>

                            <!-- Alerts -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger mt-3">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                </div>
                            </c:if>

                            <c:if test="${not empty message}">
                                <div class="alert alert-success mt-3">
                                    <i class="bi bi-check-circle-fill me-2"></i>${message}
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <!-- JS -->
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.js"></script>
    </body>
</html>
