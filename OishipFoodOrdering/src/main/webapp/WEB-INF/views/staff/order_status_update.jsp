<%@page import="model.Staff"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Staff Manage Orders - Update Status</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />



        <!-- Sidebar CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css" />

        <!-- Sidebar JS -->
        <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />


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

            /*style timeline*/
            .timeline {
                display: flex;
                justify-content: space-between;
                margin: 40px 0;
                position: relative;
            }

            .timeline::before {
                content: "";
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 4px;
                background: #dee2e6;
                z-index: 0;
            }

            .status-step {
                text-align: center;
                position: relative;
                z-index: 1;
            }

            .status-dot {
                width: 20px;
                height: 20px;
                background: #dee2e6;
                border-radius: 50%;
                margin: 0 auto 10px;
                border: 2px solid #6c757d;
            }

            .active {
                background: red;
                border-color: darkred;
            }

            .status-label {
                font-weight: 500;
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
            <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
                <div class="container-fluid">
                    <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/dashboard">Oiship</a>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav ms-auto">
                            <li class="wellcome-text">Welcome, <span><c:out value="${sessionScope.userName}" /></span>!</li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
            <!--Content -->
            <div class="content">
                <div class="container mt-5">
                    <h2 class="text-center mb-4">Update Order Status - Order #${orderID}</h2>

                    <!-- Timeline -->
                    <div class="timeline">
                        <c:forEach var="i" begin="0" end="6">
                            <div class="status-step">
                                <div class="status-dot ${orderStatus == i ? 'active' : ''}"></div>
                                <div class="status-label">
                                    <c:choose>
                                        <c:when test="${i == 0}">Pending</c:when>
                                        <c:when test="${i == 1}">Confirmed</c:when>
                                        <c:when test="${i == 2}">Preparing</c:when>
                                        <c:when test="${i == 3}">Out for Delivery</c:when>
                                        <c:when test="${i == 4}">Delivered</c:when>
                                        <c:when test="${i == 5}">Cancelled</c:when>
                                        <c:when test="${i == 6}">Failed</c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Update Form -->
                    <form action="${pageContext.request.contextPath}/staff/manage-orders/update-status" method="post" class="text-center">
                        <input type="hidden" name="orderID" value="${orderID}">
                        <div class="mb-3">
                            <label class="fw-semibold">Select new status:</label>
                            <select name="newStatus" class="form-select w-50 mx-auto" required>
                                <option disabled selected value="">-- Choose status --</option>
                                <option value="0">Pending</option>
                                <option value="1">Confirmed</option>
                                <option value="2">Preparing</option>
                                <option value="3">Out for Delivery</option>
                                <option value="4">Delivered</option>
                                <option value="5">Cancelled</option>
                                <option value="6">Failed</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Update</button>
                        <a href="${pageContext.request.contextPath}/staff/manage-orders/order-detail?orderID=${orderID}" class="btn btn-secondary">Back</a>
                    </form>

                    <!-- Success/Error Message -->
                    <c:if test="${not empty message}">
                        <script>
            alert("${message}");
                        </script>
                    </c:if>
                </div>
            </div>





        </div>


        <!-- JS -->
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.js"></script>
    </body>
</html>
