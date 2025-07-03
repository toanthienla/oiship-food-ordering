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
            .img-thumbnail {
                border-radius: 8px;
            }
            input[type="checkbox"].item-checkbox,
            input[type="checkbox"]#selectAll {
                width: 20px;
                height: 20px;
                accent-color: #ff6600;
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

            <% if (cartItems != null && !cartItems.isEmpty()) {
                    BigDecimal grandTotal = BigDecimal.ZERO;
            %>
            <div class="table-responsive">
                <table class="table table-bordered text-center align-middle">
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>
                            <th>Image</th>
                            <th>Dish</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Cart item : cartItems) {
                                Dish dish = item.getDish();
                                int quantity = item.getQuantity();
                                BigDecimal unitPrice = dish.getTotalPrice();
                                BigDecimal itemTotal = unitPrice.multiply(BigDecimal.valueOf(quantity));
                                int stock = dish.getStock();

                                if (stock > 0) {
                                    grandTotal = grandTotal.add(itemTotal);
                                }
                        %>
                        <tr>                            
                            <td>
                                <input type="checkbox"
                                       class="item-checkbox"
                                       value="<%= item.getCartID()%>"
                                       <%= (stock == 0) ? "disabled" : ""%> />
                            </td>                           
                            <td><img src="<%= dish.getImage()%>" width="90" class="img-thumbnail"></td>   
                            <td>
                                <%= dish.getDishName()%><br>
                                <small class="text-muted">Price: <%= dish.getFormattedPrice()%> đ</small>
                            </td>

                            <td>
                                <% if (stock == 0) { %>
                                <span class="text-danger fw-semibold">Out of stock – please choose another dish</span>
                                <% } else {%>
                                <div class="d-flex justify-content-center align-items-center gap-2">
                                    <button class="btn btn-outline-secondary btn-sm"
                                            onclick="updateQuantity(<%= item.getCartID()%>, -1)">−</button>
                                    <input type="text"
                                           id="qty_<%= item.getCartID()%>"
                                           data-stock="<%= stock%>"
                                           data-name="<%= dish.getDishName()%>"
                                           value="<%= quantity%>"
                                           readonly
                                           class="form-control text-center"
                                           style="width: 60px;">
                                    <button class="btn btn-outline-secondary btn-sm"
                                            onclick="updateQuantity(<%= item.getCartID()%>, 1)">+</button>
                                </div>
                                <% }%>
                            </td>                          
                            <td class="item-total" data-price="<%= unitPrice.intValue()%>">
                                <% if (stock > 0) {%>
                                <%= String.format("%,.0f", itemTotal)%> đ
                                <% } else { %>
                                <span class="text-muted fst-italic">-</span>
                                <% }%>
                            </td>                          
                            <td>
                                <form action="<%= request.getContextPath()%>/customer/view-cart"
                                      method="post"
                                      onsubmit="return confirm('Are you sure you want to remove this item?');">
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

            <form action="${pageContext.request.contextPath}/customer/order" method="post" id="orderForm">
                <div class="d-flex justify-content-between mt-4">
                    <a href="<%= request.getContextPath()%>/customer" class="btn btn-custom-back">&laquo; Back to Menu</a>
                    <button type="submit" class="btn btn-success text-white" onclick="return prepareOrder(event)">
                        <i class="fa-solid fa-cart-shopping me-1"></i> Order Now
                    </button>
                </div>
            </form>
        </div>

        <script>
            const contextPath = "<%= request.getContextPath()%>";

            function updateQuantity(cartId, delta) {

                const input = document.getElementById("qty_" + cartId);
                const maxStock = parseInt(input.getAttribute("data-stock"));
                let qty = parseInt(input.value);

                qty += delta;
                if (qty > 10) {
                    qty = 10;
                    alert("The maximum quantity is 10.");
                }
                if (qty > maxStock) {
                    qty = maxStock;
                    alert("Only " + maxStock + " items in stock.");
                }
                if (qty < 1)
                    qty = 1;

                input.value = qty;

                fetch(contextPath + "/customer/view-cart", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
                }).then(() => {
                    const row = input.closest("tr");
                    const price = parseInt(row.querySelector(".item-total").getAttribute("data-price"));
                    const total = qty * price;
                    row.querySelector(".item-total").textContent = total.toLocaleString() + " đ";

                    recalculateGrandTotal();
                });
            }

            function recalculateGrandTotal() {
                let total = 0;
                document.querySelectorAll(".item-total").forEach(el => {
                    const text = el.textContent.replace(/[^\d]/g, '');
                    if (!isNaN(text))
                        total += parseInt(text);
                });
                // Optional: Hiển thị grand total
                // document.getElementById("grandTotalAmount").textContent = total.toLocaleString() + " đ";
            }

            async function prepareOrder(event) {
                event.preventDefault();

                const checkedItems = document.querySelectorAll('.item-checkbox:checked');
                if (checkedItems.length === 0) {
                    alert("Please select at least one dish to place the order.");
                    return false;
                }

                let isValid = true;
                let totalQty = 0;

                for (const cb of checkedItems) {
                    const cartId = cb.value;
                    const qtyInput = document.getElementById("qty_" + cartId);
                    let qty = parseInt(qtyInput.value);
                    const maxStock = parseInt(qtyInput.getAttribute("data-stock"));
                    const dishName = qtyInput.getAttribute("data-name");

                    if (isNaN(qty) || qty < 1) {
                        alert("The quantity for " + dishName + " is invalid.");
                        qty = 1;
                        qtyInput.value = qty;
                        isValid = false;

                        await fetch(contextPath + "/customer/view-cart", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
                        });

                    } else if (qty > maxStock) {
                        alert("Only " + maxStock + " in stock for " + dishName);
                        qty = maxStock;
                        qtyInput.value = qty;
                        isValid = false;
                        await fetch(contextPath + "/customer/view-cart", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
                        });
                    } else if (qty > 10) {
                        alert("Maximum quantity is 10.");
                        qty = 10;
                        qtyInput.value = qty;
                        isValid = false;
                        await fetch(contextPath + "/customer/view-cart", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
                        });
                    }

                    totalQty += qty;
                }

                if (totalQty > 50) {
                    alert("Total quantity must not exceed 50.");
                    isValid = false;
                }

                if (!isValid) {
                    return false;
                }


                const promises = [];

                checkedItems.forEach(cb => {
                    const cartId = cb.value;
                    const qty = document.getElementById("qty_" + cartId).value;

                    const promise = fetch(contextPath + "/customer/view-cart", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                        body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
                    });


                    promises.push(promise);
                });

                try {
                    await Promise.all(promises);
                } catch (err) {
                    alert("Failed to update quantities. Please try again.");
                    return false;
                }

                const form = document.getElementById('orderForm');
                form.querySelectorAll('input[name="selectedItems"]').forEach(e => e.remove());

                checkedItems.forEach(cb => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'selectedItems';
                    input.value = cb.value;
                    form.appendChild(input);
                });


                form.submit();
                return true;
            }

            function toggleAll(source) {
                const checkboxes = document.querySelectorAll('.item-checkbox:not(:disabled)');
                checkboxes.forEach(cb => cb.checked = source.checked);
            }

        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
