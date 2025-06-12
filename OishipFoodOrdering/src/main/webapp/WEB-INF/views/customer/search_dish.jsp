<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Dish" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Search</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- FontAwesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet" />

    <style>
        body {
            font-family: 'Roboto', sans-serif;
        }

        .navbar {
            transition: all 0.3s ease;
        }

        .navbar .nav-link:hover {
            color: #ff7f50 !important;
        }

        .card:hover {
            transform: translateY(-5px);
            transition: transform 0.3s ease;
        }

        .footer {
            background-color: #343a40;
            color: #fff;
            padding: 40px 0;
        }

        .footer a {
            color: #ccc;
            text-decoration: none;
        }

        .footer a:hover {
            color: #fff;
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: bold;
            color: #333;
            margin-top: 10px;
        }

        .card-body {
            padding: 20px;
        }

        .card-img-top {
            object-fit: cover;
            height: 200px;
        }

        .card {
            min-height: 350px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="#">
            <img src="images/logo_1.png" alt="Logo" class="logo" style="height:40px;" />
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav" aria-controls="mainNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
            </ul>

            <!-- Search form -->
            <form method="POST" action="${pageContext.request.contextPath}/customer/search" class="d-flex me-3" role="search" aria-label="Search form">
                <div class="input-group">
                    <input class="form-control py-2" type="search" name="searchQuery" placeholder="Search" aria-label="Search" />
                    <button class="btn btn-warning" type="submit" aria-label="Search button">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </form>

            <!-- Cart -->
            <ul class="navbar-nav">
                <li class="nav-item position-relative ms-3">
                    <a class="nav-link d-flex align-items-center" href="viewcart" style="position: relative;">
                        <i class="fas fa-shopping-cart fa-lg"></i>
                        <span class="ms-2">Cart</span>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.7rem;">
                            <%= session.getAttribute("cartItemCount") != null ? session.getAttribute("cartItemCount") : 0 %>
                            <span class="visually-hidden">items in cart</span>
                        </span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content -->
<main class="container my-5">
    <%
        List<Dish> menuItems = (List<Dish>) request.getAttribute("menuItems");

        if (menuItems == null || menuItems.isEmpty()) {
    %>
        <div class="alert alert-warning text-center" role="alert">
            No restaurants or dishes found matching your search.
        </div>
    <%
        } else {
    %>
        <h2 class="text-center mb-4">Search Results</h2>

        <!-- Display Menu Items -->
        <h4>Dishes:</h4>
        <div class="row">
            <% for (Dish menuItem : menuItems) { %>
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src="<%= menuItem.getImage()%>" class="card-img-top" alt="<%= menuItem.getDishName()%>" />
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title"><%= menuItem.getDishName() %></h5>
                            <p class="card-text"><%= menuItem.getDishDescription() %></p>
                            <p><strong>Price:</strong> <%= menuItem.getTotalPrice()%> VND</p>
                            <form method="post" action="addCart" class="d-flex align-items-center gap-2 m-0 p-0">
                                <input type="hidden" name="itemId" value="<%= menuItem.getDishID()%>">
                                <input type="number" name="quantity" value="1" min="1" class="form-control form-control-sm" style="width:70px;" required>
                                <button type="submit" class="btn btn-sm btn-success" title="Add to cart">
                                    <i class="fas fa-cart-plus"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <%
        }
    %>
</main>

<!-- Footer -->
<footer class="footer">
    <div class="container text-center">
        <p>&copy; 2025 Culinary Delights. All rights reserved.</p>
    </div>
</footer>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
