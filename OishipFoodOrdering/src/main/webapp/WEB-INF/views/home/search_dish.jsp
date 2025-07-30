<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Dish" %>
<%@ page import="model.Category" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    List<Dish> menuItems = (List<Dish>) request.getAttribute("menuItems");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    Integer activeCategoryId = (Integer) request.getAttribute("activeCategoryId");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Search Result - Oiship</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

        <style>
            .pagination-container {
                margin-top: 20px;
            }
            .pagination-dots {
                padding: 0 8px;
                font-weight: bold;
            }
            .dish-card {
                transition: transform 0.2s ease;
            }
            .dish-card:hover {
                transform: scale(1.03);
            }
            .btn-custom {
                background-color: #FF6B00;
                color: white;
            }
            .btn-outline-custom {
                border-color: #FF6B00;
                color: #FF6B00;
            }
            .btn-outline-custom:hover {
                background-color: #FF6B00;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="container my-4">
            <h2 class="mb-4">Trending Food</h2>

            <!-- CATEGORY FILTER BAR -->
            <c:if test="${not empty categories}">
                <div class="mb-4 d-flex flex-wrap gap-2">
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/customer/dish-detail?categoryId=${cat.categoryID}"
                           class="btn ${cat.categoryID == activeCategoryId ? 'btn-custom' : 'btn-outline-custom'}">
                            ${cat.categoryName}
                        </a>
                    </c:forEach>
                </div>
            </c:if>

            <div class="row" id="dishList">
                <% if (menuItems != null && !menuItems.isEmpty()) {
                        for (Dish menuItem : menuItems) {
                            String imageUrl = (menuItem.getImage() != null && !menuItem.getImage().isEmpty())
                                    ? menuItem.getImage()
                                    : "https://via.placeholder.com/300x200";
                %>
                <div class="col-md-4 mb-3 dish-item">
                    <!-- Dish Card -->
                    <button class="btn btn-outline-secondary w-100" onclick="openDishDetail(<%= menuItem.getDishID()%>)">
                        <div class="card dish-card">
                            <img src="<%= imageUrl%>" class="card-img-top" alt="<%= menuItem.getDishName()%>">
                            <div class="card-body">
                                <h5 class="card-title"><%= menuItem.getDishName()%></h5>
                                <p class="card-text">Price: <%= menuItem.getFormattedPrice()%> đ</p>
                            </div>
                        </div>
                    </button>

                </div>
                <% }
        } else { %>
                <p class="text-muted">No dishes found.</p>
                <% }%>
            </div>

            <!-- Link View All -->
            <div class="text-end mt-2">
                <a href="/OishipFoodOrdering/customer" class="btn btn-outline-custom">View All Dishes</a>
            </div>
        </div>

        <script>
            function openDishDetail(dishId) {
                window.location.href = '${pageContext.request.contextPath}/customer/dish-detail?dishId=' + dishId;
            }
        </script>
    </body>
</html>
