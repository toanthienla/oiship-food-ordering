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
        <title>Staff Manage Orders - Order Detail</title>

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
            <div class="content container mt-4">
                <h2>Order Details</h2>

                <c:if test="${empty orderDetails}">
                    <div class="alert alert-info">No details available for this order.</div>
                </c:if>

                <c:if test="${not empty orderDetails}">
                    <!-- THÔNG TIN CHUNG CỦA ĐƠN HÀNG -->
                    <div class="border rounded p-3 mb-4 bg-light">
                        <p><strong>Customer:</strong> ${orderDetails[0].customerName}</p>
                        <p><strong>Order Created At:</strong>
                            <fmt:formatDate value="${orderDetails[0].createAt}" pattern="dd-MM-yyyy HH:mm:ss" />
                        </p>
                        <p><strong>Status:</strong>
                            <c:choose>
                                <c:when test="${orderDetails[0].orderStatus == 0}">Pending</c:when>
                                <c:when test="${orderDetails[0].orderStatus == 1}">Confirmed</c:when>
                                <c:when test="${orderDetails[0].orderStatus == 2}">Preparing</c:when>
                                <c:when test="${orderDetails[0].orderStatus == 3}">Out for Delivery</c:when>
                                <c:when test="${orderDetails[0].orderStatus == 4}">Delivered</c:when>
                                <c:when test="${orderDetails[0].orderStatus == 5}">Cancelled</c:when>
                                <c:when test="${orderDetails[0].orderStatus == 6}">Failed</c:when>
                                <c:otherwise>Unknown</c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <!-- BẢNG CHI TIẾT MÓN ĂN -->
                    <table class="table table-bordered table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Dish</th>
                                <th>Image</th>
                                <th>Description</th>
                                <th>Quantity</th>
                                <th>Cost (VNĐ)</th>

                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="totalCost" value="0" />
                            <c:forEach var="detail" items="${orderDetails}">
                                <tr>
                                    <td>${detail.dishName}</td>
                                    <td>
                                        <img src="${detail.dishImage}" width="80" height="60"/>

                                    </td>
                                    <td>${detail.dishDescription}</td>
                                    <td>${detail.quantity}</td>
                                    <td>
                                        ... VNĐ
                                    </td>

                                </tr>

                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- TỔNG TIỀN + NÚT UPDATE -->
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <h5>
                            Total Cost: 
                            ... VNĐ
                        </h5>
                        <a class="btn btn-success"
                           href="${pageContext.request.contextPath}/staff/manage-orders/update-status?orderID=${orderDetails[0].orderId}">
                            Update Order Status
                        </a>
                    </div>
                </c:if>
            </div>

        </div>
        <!-- JS -->
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.js"></script>
    </body>
</html>
