<%@page import="model.Dish"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Search Result - Oiship</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
        }
        .sidebar {
            width: 250px;
            background-color: #ffffff;
            height: 100vh;
            position: fixed;
            padding-top: 20px;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        }
        .sidebar a {
            display: block;
            padding: 10px 15px;
            color: #000;
            text-decoration: none;
        }
        .sidebar a:hover, .sidebar .active {
            background-color: #ff6200;
            color: #fff !important;
        }
        .main-content {
            margin-left: 250px;
            padding: 20px;
        }
        .dish-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        .dish-card:hover {
            transform: translateY(-5px);
        }
        .dish-card img {
            height: 200px;
            object-fit: cover;
            width: 100%;
        }
        .btn-custom {
            background-color: #ff6200;
            color: #fff;
            border: none;
            padding: 8px 16px;
            transition: background-color 0.3s ease;
        }
        .btn-custom:hover {
            background-color: #e65c00;
        }
        .footer {
            margin-top: 40px;
            padding: 20px;
            background: #fff;
            text-align: center;
            box-shadow: 0 -1px 6px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="text-center mb-4">
        <img src="images/logo_1.png" alt="Oiship Logo" class="img-fluid" />
        <h5 class="mt-2 text-orange">OISHIP</h5>
    </div>
    <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home me-2"></i> Home</a>
    <a href="#menu"><i class="fas fa-utensils me-2"></i> Menu</a>
    <a href="#dishes" class="active"><i class="fas fa-drumstick-bite me-2"></i> Dishes</a>
    <a href="#contact"><i class="fas fa-phone me-2"></i> Contact</a>
    <a href="#"><i class="fas fa-map-marker-alt me-2"></i> Location</a>
    <a href="#"><i class="fas fa-tags me-2"></i> Sale</a>
    <a href="#cart"><i class="fas fa-shopping-cart me-2"></i> Cart</a>
    <a href="#"><i class="fas fa-list me-2"></i> Order</a>
</div>

<!-- Main Content -->
<div class="main-content">
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
               String imageUrl = (menuItem.getImage() != null && !menuItem.getImage().isEmpty()) ? menuItem.getImage() : "https://via.placeholder.com/300x200";
        %>
        <div class="col-md-4 mb-4">
            <form action="${pageContext.request.contextPath}/home/dish" method="post">
                <input type="hidden" name="dishId" value="<%= menuItem.getDishID() %>">
                <button type="submit" class="btn p-0 border-0 text-start w-100" style="background: none;">
                    <div class="card dish-card h-100">
                        <img src="<%= imageUrl %>" class="card-img-top" alt="<%= menuItem.getDishName() %>">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title"><%= menuItem.getDishName() %></h5>
                            <p class="card-text"><%= menuItem.getDishDescription() %></p>
                            <p><strong>Price:</strong> <%= menuItem.getFormattedPrice() %> đ</p>
                            <div class="mt-auto">
                                <a href="addToCart?dishId=<%= menuItem.getDishID() %>" class="btn btn-custom w-100" type="button">
                                    Add Cart
                                </a>
                            </div>
                        </div>
                    </div>
                </button>
            </form>
        </div>
        <% } %>
    </div>
    <% } %>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
