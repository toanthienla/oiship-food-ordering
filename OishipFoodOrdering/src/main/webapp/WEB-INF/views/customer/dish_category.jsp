<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Category, model.Dish, java.util.List" %>
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Dish> menuItems = (List<Dish>) request.getAttribute("menuItems");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách món ăn theo danh mục</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container py-4">
    <h2 class="mb-4">Danh sách món ăn</h2>

    <!-- Category Filter -->
    <div class="mb-4 d-flex gap-2 flex-wrap">
        <!-- Nút "Tất cả" -->
        <form method="post" action="dish">
            <button type="submit" class="btn btn-outline-secondary">Tất cả</button>
        </form>

        <% if (categories != null) {
            for (Category cat : categories) {
        %>
        <form method="post" action="dish">
            <input type="hidden" name="catId" value="<%= cat.getCatID() %>">
            <button type="submit" class="btn btn-outline-primary">
                <%= cat.getCatName() %>
            </button>
        </form>
        <% }} %>
    </div>

    <!-- Dish List -->
    <div class="row">
        <% if (menuItems != null && !menuItems.isEmpty()) {
            for (Dish dish : menuItems) {
                String img = (dish.getImage() != null && !dish.getImage().isEmpty())
                        ? dish.getImage()
                        : "https://via.placeholder.com/300x200";
        %>
        <div class="col-md-4 mb-4">
            <form action="dish" method="post">
                <input type="hidden" name="dishId" value="<%= dish.getDishID() %>">
                <button type="submit" class="btn p-0 border-0 w-100 text-start" style="background: none;">
                    <div class="card h-100">
                        <img src="<%= img %>" class="card-img-top" alt="<%= dish.getDishName() %>">
                        <div class="card-body">
                            <h5 class="card-title"><%= dish.getDishName() %></h5>
                            <p class="card-text">Giá: <%= dish.getTotalPrice().intValue() %> VNĐ</p>
                            <p class="card-text"><%= dish.getDishDescription() %></p>
                        </div>
                    </div>
                </button>
            </form>
        </div>
        <% }} else { %>
            <p class="text-muted">Không có món ăn trong danh mục này.</p>
        <% } %>
    </div>
</div>
</body>
</html>
