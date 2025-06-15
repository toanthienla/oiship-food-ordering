<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff - Manage Orders</title>

        <!-- Bootstrap 5 CSS & JS -->
        <link rel="stylesheet" href="../css/bootstrap.css" />
        <script src="../js/bootstrap.bundle.js"></script>

        <!--CSS for Sidebar-->
        <link rel="stylesheet" href="../css/sidebar.css" />

        <!--JS for Sidebar-->
        <script src="../js/sidebar.js"></script>

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', sans-serif;
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

            <!-- Content -->
            <div class="content">
                <h2>Manage Orders</h2>

                <table border="1" cellpadding="10" cellspacing="0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Payment</th>
                            <th>Created At</th>
                            <th>Updated At</th>
                            <th>Voucher ID</th>
                            <th>Customer ID</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>${order.orderID}</td>
                                <td>${order.amount}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 0}">Pending</c:when>
                                        <c:when test="${order.orderStatus == 1}">Confirmed</c:when>
                                        <c:when test="${order.orderStatus == 2}">Preparing</c:when>
                                        <c:when test="${order.orderStatus == 3}">Out for Delivery</c:when>
                                        <c:when test="${order.orderStatus == 4}">Delivered</c:when>
                                        <c:when test="${order.orderStatus == 5}">Cancelled</c:when>
                                        <c:when test="${order.orderStatus == 6}">Failed</c:when>
                                        <c:otherwise>Unknown</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.paymentStatus == 0}">Unpaid</c:when>
                                        <c:when test="${order.paymentStatus == 1}">Paid</c:when>
                                        <c:when test="${order.paymentStatus == 2}">Refunded</c:when>
                                        <c:otherwise>Unknown</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${order.orderCreatedAt}</td>
                                <td>${order.orderUpdatedAt}</td>
                                <td>${order.voucherID}</td>
                                <td>${order.customerID}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>


        </div>
    </body>
</html>