<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - Oiship</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .navbar-brand { font-weight: bold; color: #ff5733 !important; }
        .dashboard-container { max-width: 800px; margin: 2rem auto; padding: 2rem; background: white; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/dashboard">Oiship</a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="dashboard-container">
        <h3 class="text-center mb-4">Staff Dashboard</h3>
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-danger text-center">${requestScope.error}</div>
        </c:if>
        <c:if test="${not empty requestScope.message}">
            <div class="alert alert-success text-center">${requestScope.message}</div>
        </c:if>

        <h4>Pending Orders</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Amount</th>
                    <th>Delivery Address</th>
                    <th>Delivery Time</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>${order.orderID}</td>
                        <td>${order.amount}</td>
                        <td>${order.deliveryAddress}</td>
                        <td><fmt:formatDate value="${order.deliveryTime}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td>
                            ${order.orderStatus == 0 ? 'Pending' : 
                              order.orderStatus == 1 ? 'Confirmed' : 
                              order.orderStatus == 2 ? 'Preparing' : 
                              order.orderStatus == 3 ? 'Out for Delivery' : 
                              order.orderStatus == 4 ? 'Delivered' : 
                              order.orderStatus == 5 ? 'Cancelled' : 'Failed'}
                        </td>
                        <td>
                            <c:if test="${order.orderStatus == 0}">
                                <a href="${pageContext.request.contextPath}/staff/updateOrderStatus?orderId=${order.orderID}&status=1" class="btn btn-primary btn-sm">Confirm</a>
                                <a href="${pageContext.request.contextPath}/staff/updateOrderStatus?orderId=${order.orderID}&status=5" class="btn btn-danger btn-sm">Cancel</a>
                            </c:if>
                            <c:if test="${order.orderStatus == 1}">
                                <a href="${pageContext.request.contextPath}/staff/updateOrderStatus?orderId=${order.orderID}&status=2" class="btn btn-primary btn-sm">Prepare</a>
                            </c:if>
                            <c:if test="${order.orderStatus == 2}">
                                <a href="${pageContext.request.contextPath}/staff/updateOrderStatus?orderId=${order.orderID}&status=3" class="btn btn-primary btn-sm">Out for Delivery</a>
                            </c:if>
                            <c:if test="${order.orderStatus == 3}">
                                <a href="${pageContext.request.contextPath}/staff/updateOrderStatus?orderId=${order.orderID}&status=4" class="btn btn-primary btn-sm">Delivered</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>