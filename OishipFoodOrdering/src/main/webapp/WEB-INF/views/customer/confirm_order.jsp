<%@page import="model.Customer"%>
<%@page import="java.util.List"%>
<%@page import="model.Voucher"%>
<%@page import="model.Dish"%>
<%@page import="model.Cart"%>
<%@page import="java.math.BigDecimal"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Confirm-Order</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body class="container py-4">

        <h2 class="mb-4">Confirm Order</h2>

        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!-- FORM -->
        <form id="orderForm" action="${pageContext.request.contextPath}/customer/order" method="post">
            <input type="hidden" name="action" value="confirm" />
            <input type="hidden" name="voucherID" id="hiddenVoucherID" />
            <input type="hidden" name="fullname" id="hiddenFullName" value="${customer.fullName}" />
            <input type="hidden" name="phone" id="hiddenPhone" value="${customer.phone}" />
            <input type="hidden" name="address" id="hiddenAddress" value="${customer.address}" />
            <input type="hidden" name="paymentMethod" id="paymentMethod" value="cash" />

            <div class="row">
                <!-- LEFT COLUMN -->
                <div class="col-lg-7">
                    <div class="accordion" id="deliveryAccordion">

                        <!-- DELIVERY INFORMATION -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingDelivery">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseDelivery">
                                    Delivery Information
                                </button>
                            </h2>
                            <div id="collapseDelivery" class="accordion-collapse collapse show" aria-labelledby="headingDelivery">
                                <div class="accordion-body">
                                    <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                                        <div>
                                            <p class="mb-1 fw-bold">Customer Information</p>
                                            <span id="displayCustomerText" onclick="openEditCustomer()" style="cursor:pointer;">
                                                ${customer.fullName} - ${customer.phone}
                                            </span>
                                        </div>
                                        <button type="button" class="btn btn-link text-decoration-none" onclick="openEditCustomer()">
                                            <i class="bi bi-chevron-right fs-4"></i>
                                        </button>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center py-2">
                                        <div>
                                            <p class="mb-1 fw-bold">Address</p>
                                            <span onclick="openEditAddress()" style="cursor:pointer;" id="displayAddressText">
                                                ${customer.address}
                                            </span>
                                        </div>
                                        <button type="button" class="btn btn-link text-decoration-none" onclick="openEditAddress()">
                                            <i class="bi bi-chevron-right fs-4"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- PAYMENT OPTION -->
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingPayment">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePayment" aria-expanded="false" aria-controls="collapsePayment">
                                    Payment Option
                                </button>
                            </h2>
                            <div id="collapsePayment" class="accordion-collapse collapse" aria-labelledby="headingPayment">
                                <div class="accordion-body">
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="radio" name="payment" value="cash" id="paymentCash" checked>
                                        <label class="form-check-label" for="paymentCash">Thanh toán khi nhận hàng</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="payment" value="bank_transfer" id="paymentBankTransfer">
                                        <label class="form-check-label" for="paymentBankTransfer">Chuyển khoản ngân hàng (PayOS)</label>
                                    </div>
                                    <div class="text-danger mt-2" id="errorMsg"></div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- RIGHT COLUMN -->
                <div class="col-lg-5">
                    <h4 class="mb-3">Selected Dishes</h4>
                    <%
                        List<Cart> selectedCarts = (List<Cart>) request.getAttribute("selectedCarts");
                        BigDecimal grandTotal = (BigDecimal) request.getAttribute("grandTotal");
                    %>
                    <div class="mb-4">
                        <% for (Cart cart : selectedCarts) {
                                Dish dish = cart.getDish();
                                BigDecimal price = dish.getTotalPrice();
                                BigDecimal total = price.multiply(BigDecimal.valueOf(cart.getQuantity()));
                                int cartId = cart.getCartID();
                        %>
                        <div class="d-flex align-items-center mb-3 border p-2 rounded cart-item-row">
                            <img src="<%= dish.getImage()%>" width="80" class="me-3" style="border-radius: 8px;">
                            <div class="flex-grow-1">
                                <strong><%= dish.getDishName()%></strong><br/>
                                <div class="d-flex align-items-center gap-2 mt-1">
                                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="updateQuantity(<%= cartId%>, -1)">−</button>
                                    <input type="text" id="qty_<%= cartId%>" value="<%= cart.getQuantity()%>" readonly data-stock="<%= dish.getStock()%>" class="form-control text-center" style="width: 60px;">
                                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="updateQuantity(<%= cartId%>, 1)">+</button>
                                </div>

                                <div class="mt-1">Total: <span class="item-total" data-price="<%= price.intValue()%>"><%= String.format("%,.0f", total)%></span> VND</div>



                            </div>
                        </div>
                        <% }%>
                    </div>

                    <!-- Voucher -->
                    <div class="mb-4">
                        <label class="form-label fw-bold">Discount Code</label>
                        <div class="p-2 border rounded bg-light" style="cursor:pointer;" data-bs-toggle="modal" data-bs-target="#voucherModal">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <p class="mb-0">Choose a discount code</p>
                                    <small class="text-muted" id="voucherStatusText">Not applied</small>
                                </div>
                                <i class="bi bi-chevron-right fs-5"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Summary -->
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Subtotal:</span>
                            <span id="totalBefore" data-value="<%= grandTotal%>"><%= String.format("%,.0f", grandTotal)%> đ</span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span>Discount:</span>
                            <span id="discountAmount">- 0 đ</span>
                        </div>
                        <div class="d-flex justify-content-between fw-bold fs-5">
                            <span>Total Amount:</span>
                            <span id="finalAmount"><%= String.format("%,.0f", grandTotal)%> đ</span>
                        </div>
                    </div>

                    <!-- Hidden cart IDs -->
                    <c:forEach var="id" items="${selectedCartIDs}">
                        <input type="hidden" name="selectedItems" value="${id}" />
                    </c:forEach>

                    <!-- Confirm button -->
                    <div class="d-grid">
                        <button type="button" class="btn btn-primary" onclick="handleSubmit()">Place Order</button>
                        <a href="${pageContext.request.contextPath}/customer/view-cart" class="btn btn-outline-secondary mt-2">Back to Cart</a>
                    </div>
                </div>
            </div>
        </form>

        <!-- SCRIPT xử lý chọn phương thức thanh toán -->
        <script>
            function handleSubmit() {
                const selectedPayment = document.querySelector('input[name="payment"]:checked').value;
                document.getElementById("paymentMethod").value = selectedPayment;
                document.getElementById("orderForm").submit(); // Submit về /customer/order
            }

        </script>



        <!-- Modal chỉnh Customer -->
        <div class="modal fade" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Customer Information</h5>
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

        <!-- Modal chỉnh Address -->
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
                            <textarea class="form-control" id="modalAddress" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-warning" onclick="saveAddress()">Save changes</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal chọn voucher -->
        <div class="modal fade" id="voucherModal" tabindex="-1" aria-labelledby="voucherModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content p-4">
                    <div class="modal-header">
                        <h5 class="modal-title">Chọn mã giảm giá</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <%
                                List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
                                if (vouchers != null && !vouchers.isEmpty()) {
                                    for (Voucher v : vouchers) {
                            %>
                            <div class="col-md-6 mb-3">
                                <div class="border p-3 rounded shadow-sm h-100 voucher-card" style="cursor:pointer;"
                                     onclick="selectVoucher('<%= v.getVoucherID()%>', '<%= v.getCode()%>')">
                                    <div class="fw-bold text-danger"><%= v.getCode()%></div>
                                    <div>
                                        <%= v.getDiscountType().equals("%")
                                                ? ("Giảm " + v.getDiscount() + "%")
                                                : ("Giảm " + String.format("%,.0f", v.getDiscount()) + "đ")%>
                                    </div>
                                    <div class="text-muted"><%= v.getVoucherDescription()%></div>
                                </div>
                            </div>
                            <% }
                            } else { %>
                            <div class="col-12 text-center text-muted">No vouchers available</div>
                            <% } %>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS xử lý modal -->
        <script>
            function openEditCustomer() {
                document.getElementById('modalFullName').value = '${customer.fullName}';
                document.getElementById('modalPhone').value = '${customer.phone}';
                new bootstrap.Modal(document.getElementById('editCustomerModal')).show();
            }

            function openEditAddress() {
                document.getElementById('modalAddress').value = '${customer.address}';
                new bootstrap.Modal(document.getElementById('editAddressModal')).show();
            }

            function saveCustomerInfo() {
                const name = document.getElementById('modalFullName').value.trim();
                const phone = document.getElementById('modalPhone').value.trim();
                if (!name || !phone) {
                    alert('Please enter all information.');
                    return;
                }
                const phoneRegex = /^0(3[2-9]|5[6|8|9]|7[0|6-9]|8[1-5]|9[0-9])\d{7}$/;

                if (!phoneRegex.test(phone)) {
                    alert('Phone number must be 10 digits and start with 0 (e.g. 0901234567).');
                    phoneInput.focus();
                    return;
                }
                let displayText = "";
                if (name && phone) {
                    displayText = name + "- " + phone;
                } else if (name) {
                    displayText = name;
                } else if (phone) {
                    displayText = phoneRegex;
                }

                document.getElementById("displayCustomerText").textContent = displayText;



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
                bootstrap.Modal.getInstance(document.getElementById('editCustomerModal')).hide();
            }

            function saveAddress() {
                const address = document.getElementById('modalAddress').value.trim();
                if (!address) {
                    alert('Please enter address.');
                    return;
                }
                document.getElementById('displayAddressText').innerText = address;


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
                bootstrap.Modal.getInstance(document.getElementById('editAddressModal')).hide();
            }
        </script>


        <script>
            const allVouchers = [
            <% for (Voucher v : vouchers) {%>
                {
                    voucherID: <%= v.getVoucherID()%>,
                    code: "<%= v.getCode()%>",
                    discountType: "<%= v.getDiscountType()%>",
                    discount: <%= v.getDiscount()%>,
                    maxDiscountValue: <%= v.getMaxDiscountValue() != null ? v.getMaxDiscountValue() : "null"%>,
                    minOrderValue: <%= v.getMinOrderValue()%>
                },
            <% }%>
            ];


            function selectVoucher(voucherID, code) {
                const orderTotal = parseFloat(document.getElementById("totalBefore").getAttribute("data-value"));
                const voucherText = document.getElementById("voucherStatusText");
                const discountText = document.getElementById("discountAmount");
                const finalTotalText = document.getElementById("finalAmount");
                const hiddenInput = document.getElementById("hiddenVoucherID");

                const voucher = allVouchers.find(v => v.voucherID == voucherID);

                if (!voucher) {
                    alert("Voucher not found.");
                    return;
                }

                if (orderTotal < voucher.minOrderValue) {
                    alert("Order has not reached minimum value to apply this code.");
                    return;
                }
                let discountAmount = 0;
                if (voucher.discountType === "%") {
                    discountAmount = orderTotal * (voucher.discount / 100);
                    if (voucher.maxDiscountValue !== null && discountAmount > voucher.maxDiscountValue) {
                        discountAmount = voucher.maxDiscountValue;
                    }
                } else {
                    discountAmount = voucher.discount;
                }

                const finalTotal = orderTotal - discountAmount;
             
                hiddenInput.value = voucherID;
                voucherText.textContent = "Applied: " + code;
                discountText.textContent = "- " + discountAmount.toLocaleString() + " đ";
                finalTotalText.textContent = finalTotal.toLocaleString() + " đ";
            
                const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('voucherModal'));
                modal.hide();



            }
        </script>
        <script>
            function validatePhoneNumber() {
                const phoneInput = document.getElementById("modalPhone");
                const phone = phoneInput.value.trim();

                const phoneRegex = /^0\d{9}$/;

                if (!phoneRegex.test(phone)) {
                    alert("Phone number must be 10 digits and start with 0 (e.g. 0901234567).");
                    phoneInput.focus();
                    return false;
                }

                return true;
            }
        </script>
        <script>
            const contextPath = "<%= request.getContextPath()%>";

            function updateQuantity(cartId, delta) {
                const input = document.getElementById("qty_" + cartId);
                const maxStock = parseInt(input.getAttribute("data-stock"));
                let qty = parseInt(input.value);

                if (isNaN(qty))
                    qty = 1;
                qty += delta;

                if (qty > 10) {
                    qty = 10;
                    alert("The maximum quantity for each item is 10.");
                }

                if (qty > maxStock) {
                    qty = maxStock;
                    alert("The quantity exceeds stock: " + maxStock);
                }

                if (qty < 1)
                    qty = 1;

                input.value = qty;
                
                fetch(contextPath + "/customer/view-cart", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
                }).then(() => {
                    const row = input.closest(".cart-item-row");
                    const price = parseInt(row.querySelector(".item-total").getAttribute("data-price"));
                    const total = qty * price;
                    row.querySelector(".item-total").textContent = total.toLocaleString();
                    recalculateTotal();
                });
            }

            function recalculateTotal() {
                let total = 0;
                document.querySelectorAll(".item-total").forEach(el => {
                    const val = el.textContent.replace(/[^\d]/g, "");
                    if (!isNaN(val))
                        total += parseInt(val);
                });
          
                document.getElementById("totalBefore").textContent = total.toLocaleString() + " đ";
                document.getElementById("finalAmount").textContent = total.toLocaleString() + " đ";
                document.getElementById("discountAmount").textContent = "- 0 VND";

            }
        </script>
        <script>
            document.getElementById("orderForm").addEventListener("submit", function (event) {
                let totalQty = 0;

                document.querySelectorAll("input[id^='qty_']").forEach(input => {
                    const qty = parseInt(input.value);
                    if (!isNaN(qty)) {
                        totalQty += qty;
                    }
                });

                if (totalQty > 50) {
                    alert("The total quantity of items in the order must not exceed 50.");

                    event.preventDefault();
                }
            });
        </script>
        <script>
            document.getElementById("orderForm").addEventListener("submit", function (e) {
                const totalBefore = document.getElementById("totalBefore").getAttribute("data-value");
                const amount = parseFloat(totalBefore);

                if (amount > 2000000) {
                    alert("Sorry, orders over 2,000,000 VND are not allowed.");
                    e.preventDefault();

                }
            });
        </script>

    </body>
</html>
