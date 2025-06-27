<%@page import="model.Review"%>
<%@page import="model.Dish"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="model.Dish"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Dish Detail</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />

        <style>
            .dish-detail-img {
                max-width: 350px;
                max-height: 350px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.2);
                object-fit: cover;
            }

            .dish-detail-container {
                padding: 30px;
            }

            .star {
                color: #ff6200;
                font-size: 1.3rem;
            }

            .btn-custom {
                background-color: transparent;
                color: #ff6200;
                border: 2px solid #ff6200;
                padding: 10px 20px;
                transition: all 0.3s ease;
                width: 100%;
            }

            .btn-custom:hover {
                background-color: #fff5e6;
                transform: translateY(-2px);
            }

            .btn-custom:active {
                background-color: #ffe0b3;
                transform: translateY(0);
            }

            .quantity-btn {
                background-color: #ff6200;
                color: #fff;
                border: none;
                padding: 0.25rem 0.75rem;
                border-radius: 5px;
                transition: all 0.3s ease;
                font-size: 1rem;
                margin: 0 0.25rem;
                cursor: pointer;
            }

            .quantity-btn:hover {
                background-color: #e65c00;
                transform: translateY(-2px);
            }

            .quantity-btn:active {
                background-color: #d35400;
                transform: translateY(0);
            }
        </style>
    </head>
    <body>
        <div class="dish-detail-container">
            <%
                Dish dish = (Dish) request.getAttribute("dish");
                List<Review> reviews = (List<Review>) request.getAttribute("reviews");

                if (dish == null) {
            %>
            
            <div class="text-center mt-5">
                <a href="home.jsp" class="btn btn-secondary mt-3">Back to Home</a>
            </div>
            <%
            } else {
                String imageUrl = (dish.getImage() != null && !dish.getImage().isEmpty())
                        ? dish.getImage()
                        : "https://via.placeholder.com/600x400";
            %>

            <div class="row g-5">
                <!-- Dish Image -->
                <div class="col-md-6 text-center">
                    <img src="<%= imageUrl%>" alt="<%= dish.getDishName()%>" class="dish-detail-img" />
                </div>

                <!-- Dish Info -->
                <div class="col-md-6">
                    <h2 class="mb-3"><%= dish.getDishName()%></h2>
                    <p><strong>Description:</strong> <%= dish.getDishDescription() != null ? dish.getDishDescription() : "No description."%></p>
                    <p><strong>Ingredients:</strong> <%= dish.getIngredientNames() != null ? dish.getIngredientNames() : "Unknown."%></p>
                    <p><strong>Price:</strong>
                        <span class="text-success fw-bold"><%= dish.getFormattedPrice()%> đ</span>
                    </p>

                    <% if (dish.getAvgRating() != null) {%>
                    <p><strong>Average Rating:</strong> <%= dish.getAvgRating()%>/5
                        <% for (int i = 1; i <= 5; i++) {
                                if (dish.getAvgRating() != null && i <= dish.getAvgRating().intValue()) { %>
                        <i class="fa-solid fa-star star"></i>
                        <% } else { %>
                        <i class="fa-regular fa-star star"></i>
                        <% } %>
                        <% } %>
                    </p>
                    <% }%>

                    <!-- Form Add to Cart -->
                    <form method="post" action="${pageContext.request.contextPath}/customer/add-cart" class="mt-3">
                        <input type="hidden" name="dishID" value="<%= dish.getDishID()%>" />

                        <div class="mb-3 d-flex align-items-center gap-2">
                            <label for="quantityInput" class="form-label mb-0 me-2">Quantity:</label>
                            <!-- Quantity input -->
                            <input type="number" name="quantity" id="quantityInput" value="1" min="1" max="10"
                                   class="form-control text-center" style="width: 80px;" required>
                            <script>
                                function changeQty(delta, event) {
                                    if (event)
                                        event.preventDefault(); // NGĂN hành vi mặc định

                                    const input = document.getElementById("quantityInput");
                                    let value = parseInt(input.value) || 1;
                                    value += delta;
                                    if (value < 1)
                                        value = 1;
                                    input.value = value;
                                }
                            </script>
                        </div>
                        <button type="submit" class="btn-custom">Add to Cart</button>
                    </form>
                </div>
            </div>
                        
                           <!-- Reviews Section -->
            <div class="mt-5">
                <h4>Recent Reviews:</h4>
                <% if (reviews != null && !reviews.isEmpty()) { %>
                <ul class="list-group mt-3">
                    <% for (Review r : reviews) {
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    %>
                    <li class="list-group-item">
                        <strong><%= r.getCustomerName()%></strong>
                        <span class="ms-2 text-warning">
                            <% for (int i = 0; i < r.getRating(); i++) { %>
                            <i class="fa-solid fa-star"  style="color: #ff6200;"></i>
                            <% }%>
                        </span>
                        <small class="text-muted float-end"><%= sdf.format(r.getReviewCreatedAt())%></small>
                        <br />
                        <span><%= r.getComment()%></span>
                    </li>
                    <% } %>
                </ul>
                <% } else { %>
                <p class="text-muted mt-3">No reviews yet for this dish.</p>
                <% } %>
            </div>
            <% }%>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
