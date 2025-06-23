<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="model.Dish" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Your Order History</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <style>
            body {
                background-color: #fff8f2;
                font-family: 'Segoe UI', sans-serif;
            }
            .order-card {
                background: #fff;
                border-radius: 15px;
                padding: 20px;
                margin-bottom: 30px;
                box-shadow: 0 0 12px rgba(255, 138, 61, 0.15);
            }
            .order-header {
                border-bottom: 1px solid #eee;
                margin-bottom: 15px;
            }
            .dish-img {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 10px;
                margin-right: 15px;
            }
            .btn-primary {
                background-color: #ff7a00;
                border: none;
            }
            .btn-primary:hover {
                background-color: #e06600;
                
                }
            
        </style>
        
        <style>
    body {
        background-color: #fff8f2;
        font-family: 'Segoe UI', sans-serif;
    }
    .order-card {
        background: #fff;
        border-radius: 15px;
        padding: 20px;
        margin-bottom: 30px;
        box-shadow: 0 0 12px rgba(255, 138, 61, 0.15);
    }
    .order-header {
        border-bottom: 1px solid #eee;
        margin-bottom: 15px;
    }
    .dish-img {
        width: 60px;
        height: 60px;
        object-fit: cover;
        border-radius: 8px;
        margin-right: 15px;
        border: 1px solid #ddd;
        background-color: #f9f9f9;
    }
    .btn-primary {
        background-color: #ff7a00;
        border: none;
    }
    .btn-primary:hover {
        background-color: #e06600;
    }
</style>

    </head>
    <body>
        <div class="container mt-5">
            <h2 class="text-center mb-4">Your Order History</h2>

            <%
                List<Order> orderHistory = (List<Order>) request.getAttribute("orderHistory");
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");

                if (orderHistory != null && !orderHistory.isEmpty()) {
                    for (Order order : orderHistory) {
            %>
            <div class="order-card">
                <div class="order-header mb-2">
                    <h5>Order ID: <%= order.getOrderID()%></h5>
                    <p class="text-muted">Date: <%= sdf.format(order.getOrderCreatedAt())%></p>
                </div>

                <% for (OrderDetail detail : order.getOrderDetails()) {
                        Dish dish = detail.getDish();
                        String imageUrl = (dish.getImage() != null && !dish.getImage().isEmpty())
                                ? dish.getImage()
                                : "https://via.placeholder.com/600x400";
                %>
                <div class="d-flex align-items-center mb-3">
                    <img src="<%= imageUrl%>" class="dish-img" alt="<%= dish.getDishName()%>">
                    <div>
                        <h6 class="mb-1"><%= dish.getDishName()%></h6>
                        <p class="mb-1">Quantity: <strong><%= detail.getQuantity()%></strong></p>
                      
                    </div>
                </div>
                <% }%>

                <div class="text-end fw-bold">
                    Total: <%= String.format("%,.0f", order.getAmount())%> đ
                </div>
            </div>
            <% }
    } else { %>
            <div class="alert alert-info text-center fs-5">You haven't placed any orders yet.</div>
            <% }%>

            <div class="text-center mt-4">
                <a href="<%= request.getContextPath()%>/customer" class="btn btn-primary px-4 py-2">&laquo; Back to Menu</a>
            </div>
        </div>
    </body>
</html>
