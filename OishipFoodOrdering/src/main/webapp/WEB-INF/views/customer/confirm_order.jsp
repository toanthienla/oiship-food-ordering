<%@ page import="model.Cart" %>
<%@ page import="model.Dish" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Voucher" %>

<html>
    <head>
        <title>Confirm Order</title>
        <!-- Thêm vào phần <head> -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <style>
            body {
                background-color: #fffaf3;
                font-family: 'Segoe UI', sans-serif;
            }
            .section-title {
                font-weight: bold;
                color: #ff6600;
            }
            .accordion-button:not(.collapsed) {
                background-color: #fff3e0;
                color: #ff6600;
            }
            .cart-item img {
                width: 70px;
                height: 70px;
                object-fit: cover;
                border-radius: 8px;
            }
            .order-summary {
                background: #fff3e0;
                padding: 20px;
                border-radius: 10px;
            }
            .btn-confirm {
                background-color: #ff6600;
                color: white;
            }
            .btn-confirm:hover {
                background-color: #e65c00;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <form action="${pageContext.request.contextPath}/customer/order" method="post">
                <input type="hidden" name="action" value="confirm" />
                <input type="hidden" name="voucher" id="hiddenVoucher" />
                <%
                    List<Cart> selectedCarts = (List<Cart>) request.getAttribute("selectedCarts");
                    BigDecimal grandTotal = (BigDecimal) request.getAttribute("grandTotal");
                    String[] selectedIDs = (String[]) request.getAttribute("selectedCartIDs");

                    for (String id : selectedIDs) {
                %>
                <input type="hidden" name="selectedItems" value="<%= id%>">
                <% }%>

                <div class="row">
                    <!-- LEFT SIDE -->
                    <div class="col-md-7">

                        <div class="accordion" id="deliveryAccordion">


                            <!-- Accordion: Delivery Information -->
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingDelivery">
                                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseDelivery">
                                        Delivery information
                                    </button>
                                </h2>
                                <div id="collapseDelivery" class="accordion-collapse collapse show" data-bs-parent="#deliveryAccordion">
                                    <div class="accordion-body">

                                        <!-- Customer Info Row -->
                                        <div class="d-flex justify-content-between align-items-center py-2 border-bottom">

                                            <div>
                                                <p class="mb-1 fw-bold">Customer information</p>
                                                <p class="mb-0 text-muted" id="displayCustomerText">No contact information provided</p>

                                            </div>
                                            <button type="button" class="btn btn-link text-decoration-none" data-bs-toggle="modal" data-bs-target="#editCustomerModal">
                                                <i class="bi bi-chevron-right fs-4"></i>
                                            </button>
                                        </div>

                                        <!-- Address Row -->
                                        <div class="d-flex justify-content-between align-items-center py-2">
                                            <div>
                                                <p class="mb-1 fw-bold">Address</p>
                                                <p class="mb-0 text-muted" id="displayAddressText">No shipping address selected</p>
                                            </div>
                                            <button type="button" class="btn btn-link text-decoration-none" data-bs-toggle="modal" data-bs-target="#editAddressModal">
                                                <i class="bi bi-chevron-right fs-4"></i>
                                            </button>
                                        </div>

                                    </div>
                                </div>
                            </div>





                            <!-- Modal chỉnh thông tin -->
                            <div class="modal fade" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Edit customer information</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label class="form-label">Full name</label>
                                                <input type="text" class="form-control" id="modalFullName" placeholder="e.g. Nguyen Van A">
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Phone number</label>
                                                <input type="text" class="form-control" id="modalPhone" placeholder="e.g. 0923473282">
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                            <button type="button" class="btn btn-warning" onclick="saveCustomerInfo()">Save changes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Modal chỉnh địa chỉ -->
                            <div class="modal fade" id="editAddressModal" tabindex="-1" aria-labelledby="editAddressModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Edit Address</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label class="form-label">Address</label>
                                                <textarea class="form-control" id="modalAddress" placeholder="e.g. 123 Le Loi, District 1, Ho Chi Minh City" rows="3"></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                            <button type="button" class="btn btn-warning" onclick="saveAddress()">Save changes</button>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            <!-- Payment -->
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingPayment">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePayment">
                                        Payment Option
                                    </button>
                                </h2>
                                <div id="collapsePayment" class="accordion-collapse collapse" data-bs-parent="#deliveryAccordion">
                                    <div class="accordion-body">
                                        <div class="form-check mb-2">
                                            <input class="form-check-input" type="radio" name="payment" value="cash" id="cash" checked>
                                            <label class="form-check-label" for="cash">Pay with Cash</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="payment" value="bank" id="bank">
                                            <label class="form-check-label" for="bank">Bank Transfer</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- RIGHT SIDE -->
                    <!-- RIGHT SIDE -->
                    <div class="col-md-5">
                        <div class="order-summary">
                            <h5 class="mb-3">Cart Summary (<%= selectedCarts.size()%> items)</h5>

                            <%

                                BigDecimal discount = BigDecimal.ZERO; // giả định chưa có giảm giá
                                BigDecimal orderValue = grandTotal; // tổng tiền giỏ
                                BigDecimal finalTotal = orderValue.subtract(discount);
                            %>

                            <% for (Cart cart : selectedCarts) {
                                    Dish dish = cart.getDish();
                                    BigDecimal price = dish.getTotalPrice();
                                    BigDecimal total = price.multiply(BigDecimal.valueOf(cart.getQuantity()));
                            %>
                            <div class="d-flex align-items-center mb-3 cart-item">
                                <img src="<%= dish.getImage()%>" class="me-3">
                                <div>
                                    <strong><%= dish.getDishName()%></strong><br/>
                                    Quantity: <%= cart.getQuantity()%> <br/>
                                    Total: <%= String.format("%,.0f", total)%> đ
                                </div>
                            </div>
                            <% }%>

                            <hr/>

                            <!-- Discount Section -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">Discount</label>
                                <div class="p-2 rounded" style="background-color: #fff0e6; cursor: pointer;" data-bs-toggle="modal" data-bs-target="#voucherModal">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <p class="mb-0">Select a voucher</p>
                                            <small class="text-muted" id="voucherStatusText">No voucher applied</small>
                                        </div>
                                        <i class="bi bi-chevron-right fs-5 text-primary"></i>
                                    </div>
                                </div>
                            </div>
                            <!-- Voucher Modal -->
                            <div class="modal fade" id="voucherModal" tabindex="-1" aria-labelledby="voucherModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                    <div class="modal-content rounded-4 p-3" style="background-color: #fef7f1;">
                                        <div class="modal-header border-0">
                                            <h5 class="modal-title fw-bold">Vouchers</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Voucher Code Input -->
                                            <div class="mb-3">
                                                <label class="form-label">Voucher code</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="bi bi-tag"></i></span>
                                                    <input type="text" class="form-control" id="voucherCodeInput" placeholder="Enter voucher code">
                                                    <button class="btn btn-warning" onclick="applyVoucher()">Apply</button>
                                                </div>
                                            </div>

                                            <!-- Available Vouchers -->
                                            <label class="form-label">Available vouchers</label>
                                            <div id="availableVouchers" class="row">
                                                <%
                                                    List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
                                                    if (vouchers != null && !vouchers.isEmpty()) {
                                                        for (model.Voucher v : vouchers) {
                                                %>
                                                <div class="col-md-6 mb-3">
                                                    <div class="voucher-card p-3 border rounded shadow-sm h-100" style="cursor:pointer;" onclick="selectVoucher('<%= v.getCode()%>')">
                                                        <div class="voucher-code fw-bold text-danger mb-1"><%= v.getCode()%></div>
                                                        <div class="voucher-discount mb-1">
                                                            <%= v.getDiscountType().equals("%")
                                                                    ? "Discount " + v.getDiscount() + "%"
                                                                    : "Discount ₫" + v.getDiscount()%>
                                                        </div>
                                                        <div class="voucher-description text-muted"><%= v.getVoucherDescription()%></div>
                                                    </div>
                                                </div>
                                                <%
                                                    }
                                                } else {
                                                %>
                                                <div class="col-12 text-center text-muted">No vouchers available</div>
                                                <%
                                                    }
                                                %>
                                            </div>

                                        </div>
                                        <div class="modal-footer border-0">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            <!-- Price Summary -->
                            <div class="mb-2 d-flex justify-content-between">
                                <span>Order value</span>
                                <span><%= String.format("%,.0f", orderValue)%> VND</span>
                            </div>
                            <div class="mb-2 d-flex justify-content-between">
                                <span>Discount</span>
                                <span>- <%= String.format("%,.0f", discount)%> VND</span>
                            </div>

                            <hr/>
                            <div class="mb-3 d-flex justify-content-between fw-bold fs-5">
                                <span>Grand Total</span>
                                <span><%= String.format("%,.0f", finalTotal)%> VND</span>
                            </div>

                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-confirm">Place Order</button>
                                <a href="${pageContext.request.contextPath}/customer/view-cart" class="btn btn-secondary mt-2">Back to Cart</a>
                            </div>
                        </div>
                    </div>

                </div>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                        function selectVoucher(code) {
                                                            document.getElementById("voucherCodeInput").value = code;
                                                            applyVoucher(); // auto apply luôn
                                                        }


        </script>


        <script>
            function saveCustomerInfo() {
                const name = document.getElementById("modalFullName").value.trim();
                const phone = document.getElementById("modalPhone").value.trim();

                if (name === "" && phone === "") {
                    alert("Please fill out name or phone.");
                    return;
                }

                let displayText = "";
                if (name && phone) {
                    displayText = name + ", " + phone;
                } else if (name) {
                    displayText = name;
                } else if (phone) {
                    displayText = phone;
                }

                // ✅ Đảm bảo không hiển thị dấu phẩy nếu chỉ có 1 trong 2 trường
                document.getElementById("displayCustomerText").textContent = displayText;

                // Gán vào input ẩn để submit form
                let form = document.querySelector("form");

                let hiddenName = document.getElementById("hiddenFullName");
                let hiddenPhone = document.getElementById("hiddenPhone");

                if (!hiddenName) {
                    hiddenName = document.createElement("input");
                    hiddenName.type = "hidden";
                    hiddenName.name = "fullname";
                    hiddenName.id = "hiddenFullName";
                    form.appendChild(hiddenName);
                }

                if (!hiddenPhone) {
                    hiddenPhone = document.createElement("input");
                    hiddenPhone.type = "hidden";
                    hiddenPhone.name = "phone";
                    hiddenPhone.id = "hiddenPhone";
                    form.appendChild(hiddenPhone);
                }

                hiddenName.value = name;
                hiddenPhone.value = phone;

                // Đóng modal
                const modal = bootstrap.Modal.getInstance(document.getElementById("editCustomerModal"));
                modal.hide();
            }



        </script>
        <script>
            function saveAddress() {
                const address = document.getElementById("modalAddress").value.trim();

                if (address === "") {
                    alert("Please enter your address.");
                    return;
                }

                // Gán vào phần hiển thị tóm tắt
                document.getElementById("displayAddressText").textContent = address;

                // Gán vào input ẩn
                let form = document.querySelector("form");
                let hiddenAddress = document.getElementById("hiddenAddress");

                if (!hiddenAddress) {
                    hiddenAddress = document.createElement("input");
                    hiddenAddress.type = "hidden";
                    hiddenAddress.name = "address";
                    hiddenAddress.id = "hiddenAddress";
                    form.appendChild(hiddenAddress);
                }

                hiddenAddress.value = address;

                const modal = bootstrap.Modal.getInstance(document.getElementById("editAddressModal"));
                modal.hide();
            }

        </script>
        <script>
            function applyVoucher() {
                const code = document.getElementById("voucherCodeInput").value.trim();

                if (code === "") {
                    alert("Please enter a voucher code.");
                    return;
                }

                // Cập nhật text voucher + input hidden (nếu cần submit)
                document.getElementById("voucherStatusText").textContent = "Voucher: " + code;
                document.getElementById("hiddenVoucher").value = code;
                // Gắn vào form input ẩn nếu muốn gửi về server
                const form = document.querySelector("form");
                let hiddenVoucher = document.getElementById("hiddenVoucher");

                if (!hiddenVoucher) {
                    hiddenVoucher = document.createElement("input");
                    hiddenVoucher.type = "hidden";
                    hiddenVoucher.name = "voucher";
                    hiddenVoucher.id = "hiddenVoucher";
                    form.appendChild(hiddenVoucher);
                }

                hiddenVoucher.value = code;

                // Đóng modal
                const modal = bootstrap.Modal.getInstance(document.getElementById("voucherModal"));
                modal.hide();
            }


        </script>

    </body>
</html>
