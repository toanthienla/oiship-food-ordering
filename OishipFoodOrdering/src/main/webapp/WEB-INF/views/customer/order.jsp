<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body {
            background-color: #fff8f2;
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            max-width: 900px;
            margin: auto;
        }
        .card {
            margin-bottom: 20px;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(255, 138, 61, 0.1);
            border: none;
        }
        .card-img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 12px;
        }
        .card-body h5 {
            color: #ff7a00;
        }
        .btn-primary {
            background-color: #ff7a00;
            border: none;
        }
        .btn-primary:hover {
            background-color: #e06600;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center mb-4">Your Order History</h2>

    <%
        List<Object[]> orderHistory = (List<Object[]>) request.getAttribute("orderHistory");
        if (orderHistory != null && !orderHistory.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");
            for (Object[] row : orderHistory) {
                Timestamp orderDate = (Timestamp) row[0];
                String dishName = (String) row[1];
                Integer quantity = (Integer) row[2];
                BigDecimal amount = (BigDecimal) row[3];
                String image = row.length > 4 ? (String) row[4] : "img/default.png"; // Nếu có ảnh
    %>
    <div class="card p-3 d-flex flex-row align-items-center">
        <img src="<%= request.getContextPath() + "/" + image %>" alt="Dish Image" class="card-img me-3">
        <div class="card-body">
            <h5 class="card-title mb-1"><%= dishName %></h5>
            <p class="mb-1">Quantity: <strong><%= quantity %></strong></p>
            <p class="mb-1">Total: <strong><%= String.format("%,.0f", amount) %> đ</strong></p>
            <small class="text-muted">Ordered at: <%= sdf.format(orderDate) %></small>
        </div>
    </div>
    <% } } else { %>
    <div class="alert alert-info text-center fs-5">You haven't ordered anything yet.</div>
    <% } %>

    <div class="text-center mt-4">
        <a href="<%= request.getContextPath() %>/customer" class="btn btn-primary px-4 py-2">
            &laquo; Back to Menu
        </a>
    </div>
</div>
</body>
</html>
