<%@page import="model.Review"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="model.Category"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@page import="model.Dish"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dish Detail</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />

    <style>
        /* Category button styles */
        .menu-section .btn {
            border-radius: 20px;
            padding: 8px 20px;
            font-weight: 500;
            transition: all 0.2s ease;
            white-space: nowrap;
        }
        .menu-section .btn.active,
        .menu-section .btn:hover {
            background-color: #ff6200;
            color: #fff;
            box-shadow: 0 3px 8px rgba(255, 98, 0, 0.3);
        }
        .menu-section .d-flex::-webkit-scrollbar {
            display: none;
        }
        .menu-section .d-flex {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        /* Dish detail styles */
        .dish-detail-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background: #ffffff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        .dish-detail-img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 10px;
        }
        .btn-orange {
            background-color: #ff6200;
            color: white;
        }
        .btn-orange:hover {
            background-color: #e65c00;
        }

        /* Layout and sidebar styles */
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
        .hero-section {
            position: relative;
            background: url('https://via.placeholder.com/800x400') no-repeat center center;
            background-size: cover;
            height: 400px;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 2rem;
        }
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
        }
        .hero-section .content {
            position: relative;
            z-index: 1;
        }
        .hero-section h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }
        .hero-section p {
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
        }
        .btn-custom {
            background-color: #ff6200;
            color: #fff;
            border: none;
            padding: 10px 20px;
            transition: background-color 0.3s ease;
        }
        .btn-custom:hover {
            background-color: #e65c00;
        }
        .btn-outline-custom {
            border-color: #fff;
            color: #fff;
            padding: 10px 20px;
        }
        .btn-outline-custom:hover {
            background-color: #fff;
            color: #ff6200;
        }
        .notification-bell {
            position: relative;
        }
        .notification-bell .badge {
            position: absolute;
            top: -5px;
            right: -10px;
            background-color: #ff6200;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="text-center mb-4">
        <img src="images/logo_1.png" alt="Oiship Logo" class="img-fluid" />
        <h5 class="mt-2 text-orange">OISHIP</h5>
    </div>
    <a href="#" class="active"><i class="fas fa-home me-2"></i> Home</a>
    <a href="#menu"><i class="fas fa-utensils me-2"></i> Menu</a>
    <a href="#dishes"><i class="fas fa-drumstick-bite me-2"></i> Dishes</a>
    <a href="#contact"><i class="fas fa-phone me-2"></i> Contact</a>
    <a href="#"><i class="fas fa-map-marker-alt me-2"></i> Location</a>
    <a href="#"><i class="fas fa-tags me-2"></i> Sale</a>
    <a href="#cart"><i class="fas fa-shopping-cart me-2"></i> Cart</a>
    <a href="#"><i class="fas fa-list me-2"></i> Order</a>
</div>

<div class="main-content">
    <nav class="navbar navbar-light bg-light p-2 mb-3">

        <div class="d-flex align-items-center">
            <div class="notification-bell me-3">
                <i class="fas fa-bell"></i>
                <span class="badge rounded-pill">3</span>
            </div>
            <div class="dropdown">
                <a class="dropdown-toggle text-decoration-none" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user"></i>
                    <span>
                        <c:choose>
                            <c:when test="${isLoggedIn and not empty userName}">
                                <c:out value="${userName}" />
                            </c:when>
                            <c:otherwise>
                                Guest
                            </c:otherwise>
                        </c:choose>
                    </span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                    <c:if test="${isLoggedIn}">
                        <li><a class="dropdown-item" href="#">Profile</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Log out</a></li>
                    </c:if>
                    <c:if test="${not isLoggedIn}">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/login">Log in</a></li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>

   

   

    <!-- Dish Detail -->
    <div id="dishes" class="dish-section">
        <%
            Dish dish = (Dish) request.getAttribute("dish");
            List<Review> reviews = (List<Review>) request.getAttribute("reviews");

            if (dish == null) {
        %>
        <div class="text-center mt-5">
            <h3>Dish not found.</h3>
            <a href="home.jsp" class="btn btn-secondary mt-3">Back to Home</a>
        </div>
        <%
            } else {
                String imageUrl = (dish.getImage() != null && !dish.getImage().isEmpty())
                        ? dish.getImage()
                        : "https://via.placeholder.com/600x400";
        %>
        <div class="dish-detail-container">
            <img src="<%= imageUrl%>" alt="<%= dish.getDishName()%>" class="dish-detail-img mb-4" />
            <h2><%= dish.getDishName()%></h2>
            <p><strong>Description:</strong> <%= dish.getDishDescription() != null ? dish.getDishDescription() : "No description."%></p>
            <p><strong>Ingredients:</strong> <%= dish.getIngredientNames() != null ? dish.getIngredientNames() : "Unknown."%></p>
            <p><strong>Price:</strong> <%= dish.getTotalPrice().intValue()%> VND</p>
            <% if (dish.getAvgRating() != null) { %>
                <p><strong>Average Rating:</strong> <%= dish.getAvgRating()%> /5★</p>
            <% } %>

            <div class="mt-4">
                <a href="addToCart?dishId=<%= dish.getDishID()%>" class="btn btn-orange">Order Now</a>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary ms-2">Back</a>
            </div>
        </div>

        <% if (reviews != null && !reviews.isEmpty()) { %>
        <div class="mt-5">
            <h4>Recent Reviews:</h4>
            <ul class="list-group mt-3">
                <%
                    for (Review r : reviews) {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                %>
                <li class="list-group-item">
                    <strong><%= r.getCustomerName()%></strong> - <%= r.getRating()%> ★ 
                    <small class="text-muted float-end"><%= sdf.format(r.getReviewCreatedAt()) %></small><br />
                    <%= r.getComment()%>
                </li>
                <% } %>
            </ul>
        </div>
        <% } else { %>
            <p class="mt-4 text-muted">No reviews yet for this dish.</p>
        <% } } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('.sidebar a').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    if (this.getAttribute('href').startsWith('#')) {
                        e.preventDefault();
                        const targetId = this.getAttribute('href').substring(1);
                        document.getElementById(targetId).scrollIntoView({ behavior: 'smooth' });
                        document.querySelectorAll('.sidebar a').forEach(a => a.classList.remove('active'));
                        this.classList.add('active');
                    }
                });
            });
        });
    </script>
</div>
</body>
</html>
