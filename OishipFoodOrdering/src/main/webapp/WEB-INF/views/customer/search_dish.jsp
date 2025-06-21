<%@page import="model.Category"%>
<%@page import="model.Dish"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Search Results - Oiship</title>
    <meta charset="UTF-8" />
</head>
<body>
    <div id="dishes" class="dish-section">
        <h2 class="mb-4">Search Results</h2>

        <%
            List<Dish> menuItems = (List<Dish>) request.getAttribute("menuItems");
            if (menuItems == null || menuItems.isEmpty()) {
        %>
        <div class="alert alert-warning text-center" role="alert">
            No dishes found matching your search.
        </div>
        <%
            } else {
        %>
        <div class="row">
            <% for (Dish menuItem : menuItems) {
                String imageUrl = (menuItem.getImage() != null && !menuItem.getImage().isEmpty())
                                    ? menuItem.getImage()
                                    : "https://via.placeholder.com/300x200";
            %>
            <div class="col-md-4 mb-3 dish-item">
                <!-- Card món ăn mở modal -->
                <button class="btn btn-outline-secondary w-100" onclick="openDishDetail(<%= menuItem.getDishID() %>)">
                    <div class="card dish-card">
                        <img src="<%= imageUrl %>" class="card-img-top" alt="<%= menuItem.getDishName() %>">
                        <div class="card-body">
                            <h5 class="card-title"><%= menuItem.getDishName() %></h5>
                            <p class="card-text">Price: <%= menuItem.getFormattedPrice() %> đ</p>
                        </div>
                    </div>
                </button>

                <!-- Add to Cart Form -->
                <form method="post" action="${pageContext.request.contextPath}/customer/add-cart">
                    <input type="hidden" name="dishID" value="<%= menuItem.getDishID() %>" />
                    <input type="hidden" name="quantity" value="1" />
                    <button type="submit" class="btn btn-custom w-100 mt-1">Add Cart</button>
                </form>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
</body>
</html>
