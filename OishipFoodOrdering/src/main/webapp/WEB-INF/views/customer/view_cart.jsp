<%@ page import="java.util.List" %>
<%@ page import="model.Cart" %>
<%@ page import="model.Dish" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">Giỏ hàng của bạn</h2>

    <%
        List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
        if (cartItems != null && !cartItems.isEmpty()) {
    %>
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Hình ảnh</th>
                    <th>Tên món</th>
                    <th>Số lượng</th>
                </tr>
            </thead>
            <tbody>
                <% for (Cart item : cartItems) {
                    Dish dish = item.getDish();
                %>
                    <tr>
                        <td><img src="<%= dish.getImage() %>" width="100" height="80"></td>
                        <td><%= dish.getDishName() %></td>
                        <td><%= item.getQuantity() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <div class="alert alert-warning">Giỏ hàng của bạn hiện chưa có món nào.</div>
    <% } %>

    <% String error = (String) request.getAttribute("error");
       if (error != null) { %>
        <div class="alert alert-danger mt-3"><%= error %></div>
    <% } %>
</div>
</body>
</html>
