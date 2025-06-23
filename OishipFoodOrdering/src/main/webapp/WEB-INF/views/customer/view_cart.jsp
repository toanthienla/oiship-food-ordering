<%@ page import="java.util.List" %>
<%@ page import="model.Cart" %>
<%@ page import="model.Dish" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Your Cart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <style>
            body {
                background-color: #fffaf3;
                font-family: 'Segoe UI', sans-serif;
            }
            .container {
                background-color: #fff3e0;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            h2 {
                color: #ff6600;
            }
            .table {
                background-color: #ffffff;
                border-radius: 10px;
                overflow: hidden;
            }
            .table th {
                background-color: #ff6600;
                color: white;
            }
            .btn-outline-secondary {
                border-color: #ff6600;
                color: #ff6600;
            }
            .btn-outline-secondary:hover {
                background-color: #ff6600;
                color: white;
            }
            .btn-danger {
                background-color: #ff4d4d;
                border: none;
            }
            .btn-danger:hover {
                background-color: #cc0000;
            }
            .btn-custom-back {
                background-color: #ffa500;
                color: white;
                border: none;
            }
            .btn-custom-back:hover {
                background-color: #ff8800;
            }
            .alert-warning {
                background-color: #fff3cd;
                border-color: #ffeeba;
                color: #856404;
            }
            .img-thumbnail {
                border-radius: 8px;
            }
            input[type="checkbox"].item-checkbox,
            input[type="checkbox"]#selectAll {
                width: 20px;
                height: 20px;
                accent-color: #ff6600;
                cursor: pointer;
            }
            th input[type="checkbox"],
            td input[type="checkbox"] {
                transform: scale(1.2);
            }
            td:first-child, th:first-child {
                width: 60px;
            }
            .table td, .table th {
                vertical-align: middle;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="mb-4">Your Cart</h2>

            <%
                List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
                String error = (String) request.getAttribute("error");
            %>

            <% if (error != null) {%>
            <div class="alert alert-danger"><%= error%></div>
            <% } %>

            <% if (cartItems != null && !cartItems.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-bordered align-middle text-center">
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>
                            <th>Image</th>
                            <th>Dish Name</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Cart item : cartItems) {
                                Dish dish = item.getDish();
                                BigDecimal unitPrice = dish.getTotalPrice();
                                int quantity = item.getQuantity();
                                BigDecimal itemTotal = unitPrice.multiply(BigDecimal.valueOf(quantity));
                        %>
                        <tr>
                            <td><input type="checkbox" class="item-checkbox" value="<%= item.getCartID()%>"></td>
                            <td><img src="<%= dish.getImage()%>" width="100" height="80" class="img-thumbnail"></td>
                            <td><%= dish.getDishName()%></td>
                            <td>
                                <div class="d-flex justify-content-center align-items-center gap-2">
                                    <button class="btn btn-outline-secondary btn-sm" onclick="updateQuantity(<%= item.getCartID()%>, -1)">−</button>
                                    <input type="text" id="qty_<%= item.getCartID()%>" value="<%= quantity%>" readonly class="form-control text-center" style="width: 60px;">
                                    <button class="btn btn-outline-secondary btn-sm" onclick="updateQuantity(<%= item.getCartID()%>, 1)">+</button>
                                </div>
                            </td>
                            <td class="item-total" data-price="<%= unitPrice.intValue()%>"><%= String.format("%,.0f", itemTotal)%> đ</td>
                            <td>
                                <form action="<%= request.getContextPath()%>/customer/view-cart" method="post" onsubmit="return confirm('Are you sure you want to remove this item?');">
                                    <input type="hidden" name="cartID" value="<%= item.getCartID()%>">
                                    <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="alert alert-warning text-center">Your cart is currently empty.</div>
            <% }%>

            <form action="<%= request.getContextPath()%>/customer/order" method="post" id="orderForm">
                <div class="d-flex justify-content-between mt-4">
                    <a href="<%= request.getContextPath()%>/customer" class="btn btn-custom-back">&laquo; Back to Menu</a>
                    <button type="button" class="btn btn-success text-white" onclick="prepareCheckoutModal()" data-bs-toggle="modal" data-bs-target="#checkoutModal">
                        <i class="fa-solid fa-cart-shopping me-1"></i> Order Now
                    </button>
                </div>
            </form>

            <!-- Modal xác nhận -->
            <div class="modal fade" id="checkoutModal" tabindex="-1" aria-labelledby="checkoutModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title">Xác nhận đơn hàng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div id="checkoutSummary"></div>
                            <div class="text-end fw-bold mt-3">Tổng cộng: <span id="totalAmount">0</span> đ</div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Quay lại</button>
                            <button type="submit" class="btn btn-success" form="orderForm">Xác nhận đặt hàng</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
    const contextPath = "<%= request.getContextPath()%>";

    function updateQuantity(cartId, delta) {
        const input = document.getElementById("qty_" + cartId);
        let qty = parseInt(input.value);
        qty = isNaN(qty) ? 1 : qty + delta;
        qty = Math.max(1, qty);
        input.value = qty;

        fetch(contextPath + "/customer/view-cart", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: `cartID=${cartId}&quantity=${qty}`
        }).then(() => {
            const row = input.closest("tr");
            const price = parseInt(row.querySelector(".item-total").getAttribute("data-price"));
            const total = qty * price;
            row.querySelector(".item-total").textContent = total.toLocaleString() + " đ";
        });
    }

    function prepareCheckoutModal() {
        const checkedItems = document.querySelectorAll('.item-checkbox:checked');
        let summaryHTML = '';
        let total = 0;

        if (checkedItems.length === 0) {
            summaryHTML = '<div class="alert alert-warning text-center">Bạn chưa chọn món nào.</div>';
        } else {
            checkedItems.forEach(cb => {
                const row = cb.closest('tr');
                const image = row.querySelector('img').src;
                const name = row.cells[2].textContent;
                const quantity = parseInt(row.querySelector('input[type="text"]').value);
                const unitPrice = parseInt(row.querySelector('.item-total').getAttribute('data-price'));
                const itemTotal = quantity * unitPrice;
                total += itemTotal;
                summaryHTML += `
                    <div class="d-flex align-items-center mb-3">
                        <img src="${image}" class="img-thumbnail me-3" style="width: 80px; height: 80px;">
                        <div>
                            <h6 class="mb-1">${name}</h6>
                            <p class="mb-0">Số lượng: <strong>${quantity}</strong></p>
                            <p class="mb-0">Tạm tính: ${itemTotal.toLocaleString()} đ</p>
                        </div>
                    </div>`;
            });
        }

        document.getElementById('checkoutSummary').innerHTML = summaryHTML;
        document.getElementById('totalAmount').textContent = total.toLocaleString();

        // Clear old hidden inputs
        document.querySelectorAll('#orderForm input[name="selectedItems"]').forEach(e => e.remove());

        // Add new hidden inputs
        checkedItems.forEach(cb => {
            const hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = 'selectedItems';
            hidden.value = cb.value;
            document.getElementById('orderForm').appendChild(hidden);
        });
    }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
