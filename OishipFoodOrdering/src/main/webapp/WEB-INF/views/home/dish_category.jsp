<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Dish" %>
<%
    List<Dish> menuItems = (List<Dish>) request.getAttribute("menuItems");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách món ăn</title>
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

            <div class="row" id="dishList">
                <% if (menuItems != null && !menuItems.isEmpty()) {
                        for (Dish menuItem : menuItems) {
                            String imageUrl = (menuItem.getImage() != null && !menuItem.getImage().isEmpty())
                                    ? menuItem.getImage()
                                    : "https://via.placeholder.com/300x200";
                %>
                <div class="col-sm-6 col-md-4 mb-3 dish-item">
                    <button class="dish-card-button" onclick="openDishDetail(<%= menuItem.getDishID()%>)">
                        <div class="card dish-card text-start">
                            <img src="<%= imageUrl%>" class="card-img-top" alt="<%= menuItem.getDishName()%>">
                            <div class="card-body">
                                <h5 class="card-title"><%= menuItem.getDishName()%></h5>
                                <p class="card-description text-muted" style="font-size: 0.9rem;"><%= menuItem.getDishDescription()%></p>
                                <p class="card-text price" style="font-weight: 500"><%= menuItem.getFormattedPrice()%> đ</p>
                            </div>
                        </div>
                    </button>
                </div>

                <% }
                } else { %>
                <p class="text-muted">The restaurant is closed.</p>
                <% }%>
            </div>     
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script>
        document.addEventListener("DOMContentLoaded", () => {
            const form = document.getElementById("dishSearchForm");
            const input = document.getElementById("searchQuery");
            const dishContainer = document.getElementById("dishContainer");

            form.addEventListener("submit", function (event) {
                event.preventDefault(); // Ngăn form reload

                const query = input.value.trim();

                fetch("<%=request.getContextPath()%>/customer/search-dish", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: new URLSearchParams({
                        searchQuery: query
                    })
                })
                        .then(response => response.text())
                        .then(data => {
                            dishContainer.innerHTML = data;
                        })
                        .catch(error => {
                            console.error("Search error:", error);
                        });
            });
        });
        </script>
    </body>
</html>
