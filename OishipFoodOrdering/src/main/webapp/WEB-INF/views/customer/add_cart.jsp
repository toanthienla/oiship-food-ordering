<%@ page import="java.util.List" %>
<%@ page import="model.Cart" %>
<%@ page import="model.Dish" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-4">
    <h1 class="mb-4">Giỏ hàng của bạn</h1>
<%
    Dish dish = (Dish) request.getAttribute("addedDish");
    Integer quantity = (Integer) request.getAttribute("quantity");

    if (dish != null && quantity != null) {
%>
<div class="table-responsive">
    <table class="table table-bordered table-striped align-middle">
        <thead class="table-dark">
            <tr>
                <th>Hình ảnh</th>
                <th>Tên món</th>
                <th>Số lượng</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><img src="<%= dish.getImage() %>" alt="Ảnh món ăn" width="100" height="80"></td>
                <td><%= dish.getDishName() %></td>
                <td><%= quantity %></td>
            </tr>
        </tbody>
    </table>
</div>
<% } else { %>
<div class="alert alert-warning" role="alert">
    Giỏ hàng của bạn hiện tại chưa có món nào.
</div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
