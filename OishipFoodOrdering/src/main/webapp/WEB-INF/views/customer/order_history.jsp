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
            .hidden-dish {
                display: none;
            }
            .status-label {
                display: inline-block;
                padding: 4px 10px;
                font-size: 0.875rem;
                border-radius: 20px;
                font-weight: 500;
            }
            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }
            .status-confirmed {
                background-color: #cfe2ff;
                color: #084298;
            }
            .status-preparing {
                background-color: #d1e7dd;
                color: #0f5132;
            }
            .status-delivery {
                background-color: #cff4fc;
                color: #055160;
            }
            .status-success {
                background-color: #d4edda;
                color: #155724;
            }
            .status-danger {
                background-color: #f8d7da;
                color: #721c24;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="text-center mb-4">Your Order History</h2>

            <%
                List<Order> orderHistory = (List<Order>) request.getAttribute("orderHistory");
                String[] orderStatusText = (String[]) request.getAttribute("orderStatusText");
                String[] paymentStatusText = (String[]) request.getAttribute("paymentStatusText");

                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");
                int orderIndex = 0;

                if (orderHistory != null && !orderHistory.isEmpty()) {
                    for (Order order : orderHistory) {
                        int os = order.getOrderStatus();
                        int ps = order.getPaymentStatus();

                        // Xác định màu class cho trạng thái
                        String orderClass = "";
                        switch (os) {
                            case 0:
                                orderClass = "status-pending";
                                break;
                            case 1:
                            case 2:
                                orderClass = "status-confirmed";
                                break;
                            case 3:
                                orderClass = "status-delivery";
                                break;
                            case 4:
                                orderClass = "status-success";
                                break;
                            case 5:
                            case 6:
                                orderClass = "status-danger";
                                break;
                            default:
                                orderClass = "";
                        }

            %>
            <div class="order-card">
                <div class="order-header mb-2">
                    <h5>Order ID: <%= order.getOrderID()%></h5>
                    <p class="text-muted">Date: <%= sdf.format(order.getOrderCreatedAt())%></p>
                    <span class="status-label <%= orderClass%>">
                        Status: <%= orderStatusText[os]%>
                    </span>
                    <span class="status-label status-confirmed ms-2">
                        Payment: <%= paymentStatusText[ps]%>
                    </span>
                </div>

                <div id="dishList-<%= orderIndex%>">
                    <%
                        int detailIndex = 0;
                        for (OrderDetail detail : order.getOrderDetails()) {
                            Dish dish = detail.getDish();
                            String imageUrl = (dish.getImage() != null && !dish.getImage().isEmpty())
                                    ? dish.getImage()
                                    : "https://via.placeholder.com/600x400";
                            boolean hidden = detailIndex >= 5;
                    %>
                    <div class="d-flex align-items-center mb-3 dish-item<%= hidden ? " hidden-dish" : ""%>">
                        <img src="<%= imageUrl%>" class="dish-img" alt="<%= dish.getDishName()%>">
                        <div class="flex-grow-1">
                            <h6 class="mb-1"><%= dish.getDishName()%></h6>
                            <p class="mb-1">Quantity: <strong><%= detail.getQuantity()%></strong></p>
                        </div>

                        <%-- ✅ Nếu đơn đã giao, hiển thị nút Review --%>
                        <% if (order.getOrderStatus() == 4) {%>
                        <!-- Thay phần nút Review bằng: -->
                        <button type="button"
                                class="btn btn-outline-primary btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#reviewModal"
                                data-odid="<%= detail.getODID()%>"
                                data-dishname="<%= dish.getDishName()%>">
                            Review
                        </button>

                        <% } %>
                    </div>

                    <%
                            detailIndex++;
                        }
                    %>
                </div>

                <% if (order.getOrderDetails().size() > 5) {%>
                <div class="text-center mt-2">
                    <button class="btn btn-sm btn-outline-secondary" onclick="toggleDishes(<%= orderIndex%>)" id="btn-<%= orderIndex%>">See more</button>
                </div>
                <% }%>

                <div class="text-end fw-bold mt-3">
                    Total: <%= String.format("%,.0f", order.getAmount())%> đ
                </div>
                <% if (order.getOrderStatus() == 4) {%>
                <form action="<%= request.getContextPath()%>/customer/view-review" method="post">

                    <input type="hidden" name="orderID" value="<%= order.getOrderID()%>"/>
                    <button type="submit" class="btn btn-success btn-sm mt-2">View Review</button>
                </form>
                <% } %>


            </div>
            <%
                    orderIndex++;
                }
            } else {
            %>
            <div class="alert alert-info text-center fs-5">You haven't placed any orders yet.</div>
            <% }%>

            <div class="text-center mt-4">
                <a href="<%= request.getContextPath()%>/customer" class="btn btn-primary px-4 py-2">&laquo; Back to Menu</a>
            </div>
        </div>
        <!-- Review Modal -->
        <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" action="${pageContext.request.contextPath}/customer/review" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="reviewModalLabel">Review Dish</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="odid" id="modalOdid">
                        <div class="mb-3">
                            <label class="form-label">Dish:</label>
                            <input type="text" class="form-control" id="modalDishName" name="dishName" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Rating:</label>
                            <input type="number" name="rating" min="1" max="5" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Comment:</label>
                            <textarea name="comment" class="form-control" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Submit Review</button>
                    </div>
                </form>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                        function toggleDishes(index) {
                            const list = document.querySelectorAll(`#dishList-${index} .hidden-dish`);
                            const btn = document.getElementById(`btn-${index}`);
                            list.forEach(item => {
                                item.style.display = item.style.display === 'none' ? 'flex' : 'none';
                            });
                            btn.textContent = btn.textContent === 'See more' ? 'See less' : 'See more';
                        }

                        // Khi modal mở: lấy dữ liệu từ nút đã bấm và gán vào input
                        const reviewModal = document.getElementById('reviewModal');
                        reviewModal.addEventListener('show.bs.modal', function (event) {
                            const button = event.relatedTarget;
                            const odid = button.getAttribute('data-odid');
                            const dishName = button.getAttribute('data-dishname');

                            document.getElementById('modalOdid').value = odid;
                            document.getElementById('modalDishName').value = dishName;
                        });
        </script>


    </body>
</html>
