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
        <!-- Mapbox CSS -->
        <link href="https://api.mapbox.com/mapbox-gl-js/v2.15.0/mapbox-gl.css" rel="stylesheet" />
        <link href="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v4.7.2/mapbox-gl-geocoder.css" rel="stylesheet" />

    </head>
    <style>
      

        .customer-info-box .title {
            font-weight: bold;
            font-size: 14px;
            color: #555;
        }

        .customer-info-box .value {
            font-size: 16px;
        }

        .customer-info-box .icon {
            font-size: 1.4rem;
            color: #666;
        }


    </style>
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

            <!-- Row chứa 2 cột -->
            <div class="row gx-4 gy-4">
                <!-- LEFT COLUMN -->
                <div class="col-lg-7 d-flex flex-column">
                    <div class="p-4 shadow-sm rounded bg-white h-100">
                        <h5 class="fw-bold mb-3 text-primary">Delivery Information</h5>

                        <!-- Customer Info -->
                        <div class="customer-info-box d-flex justify-content-between align-items-center p-3 mb-3 border rounded" onclick="openEditCustomer()" style="cursor:pointer;">
                            <div>
                                <div class="fw-bold">Customer</div>
                                <div id="displayCustomerText">${customer.fullName} - ${customer.phone}</div>
                                <div id="phoneError" class="text-danger mt-1" style="display: none;">Please enter a valid phone number.</div>
                            </div>
                            <i class="bi bi-pencil-square fs-4 text-secondary"></i>
                        </div>


                        <!-- Address Info -->
                        <div class="customer-info-box d-flex justify-content-between align-items-center p-3 border rounded" onclick="openEditCustomer()" style="cursor:pointer;">
                            <div>
                                <div class="fw-bold">Delivery Address</div>
                                <div id="displayAddressText">${customer.address}</div>
                                <div id="addressError" class="text-danger mt-1" style="display: none;">Please enter your delivery address.</div>
                                <div id="miniMap" style="height: 200px; width: 630px; margin-top: 10px; display: none;"></div>

                            </div>
                            <i class="bi bi-geo-alt fs-4 text-secondary"></i>
                        </div>

                        <!-- Payment Option -->
                        <div class="accordion mt-4" id="deliveryAccordion">
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingPayment">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePayment">
                                        Payment Option
                                    </button>
                                </h2>
                                <div id="collapsePayment" class="accordion-collapse collapse" aria-labelledby="headingPayment">
                                    <div class="accordion-body">
                                        <div class="form-check mb-2">
                                            <input class="form-check-input" type="radio" name="payment" value="cash" id="paymentCash" checked>
                                            <label class="form-check-label" for="paymentCash">Cash on Delivery</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="payment" value="bank_transfer" id="paymentBankTransfer">
                                            <label class="form-check-label" for="paymentBankTransfer">Bank transfer</label>
                                        </div>
                                        <div class="text-danger mt-2" id="errorMsg"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- RIGHT COLUMN -->
                <div class="col-lg-5 d-flex flex-column">
                    <div class="p-4 shadow-sm rounded bg-white h-100">
                        <h5 class="fw-bold mb-3 text-primary">Selected Dishes</h5>

                        <% List<Cart> selectedCarts = (List<Cart>) request.getAttribute("selectedCarts");
                            BigDecimal grandTotal = (BigDecimal) request.getAttribute("grandTotal");
                            for (Cart cart : selectedCarts) {
                                Dish dish = cart.getDish();
                                BigDecimal price = dish.getTotalPrice();
                                BigDecimal total = price.multiply(BigDecimal.valueOf(cart.getQuantity()));
                                int cartId = cart.getCartID();
                        %>
                        <div class="d-flex align-items-center mb-3 border p-2 rounded">
                            <img src="<%= dish.getImage()%>" width="80" class="me-3 rounded">
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

                        <!-- Voucher -->
                        <div class="mb-4 mt-3">
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
                        <div class="d-grid mt-3">
                            <button type="button" class="btn btn-primary" onclick="handleSubmit()">Place Order</button>
                            <a href="${pageContext.request.contextPath}/customer/view-cart" class="btn btn-outline-secondary mt-2">Back to Cart</a>
                        </div>
                    </div>
                </div>
            </div>
        </form>



        <script>
            function handleSubmit() {
                const selectedPayment = document.querySelector('input[name="payment"]:checked').value;
                const address = document.getElementById("hiddenAddress").value.trim();
                const phone = document.getElementById("hiddenPhone").value.trim();

                const addressError = document.getElementById("addressError");
                const phoneError = document.getElementById("phoneError");

                let valid = true;


                if (!address) {
                    addressError.style.display = "block";
                    valid = false;
                } else {
                    addressError.style.display = "none";
                }


                const phoneRegex = /^0\d{9}$/;
                if (!phoneRegex.test(phone)) {
                    phoneError.style.display = "block";
                    valid = false;
                } else {
                    phoneError.style.display = "none";
                }

                if (!valid)
                    return;

                document.getElementById("paymentMethod").value = selectedPayment;
                document.getElementById("orderForm").submit();
            }
        </script>




        <!-- Update Infomation customer -->
        <div class="modal fade" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Customer Info</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">

                        <div class="mb-3">
                            <label for="modalFullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="modalFullName" />
                        </div>

                        <div class="mb-3">
                            <label for="modalPhone" class="form-label">Phone</label>
                            <input type="text" class="form-control" id="modalPhone" />
                        </div>

                        <div class="mb-3">
                            <label for="modalAddress" class="form-label">Address</label>
                            <div id="mapboxAddressInput" class="geocoder"></div> <!-- Chỗ gợi ý địa chỉ -->
                            <input type="hidden" class="form-control" id="modalAddress" /> <!-- ẩn để giữ giá trị chọn -->
                        </div>


                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="saveCustomerInfo()">Save</button>
                    </div>
                </div>
            </div>
        </div>


        <!-- Modal choose voucher -->
        <div class="modal fade" id="voucherModal" tabindex="-1" aria-labelledby="voucherModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content p-4">
                    <div class="modal-header">
                        <h5 class="modal-title">Select voucher</h5>
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
                            <% }%>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Mapbox -->
        <script src="https://api.mapbox.com/mapbox-gl-js/v2.15.0/mapbox-gl.js"></script>
        <script src="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v4.7.2/mapbox-gl-geocoder.min.js"></script>
        <link href="https://api.mapbox.com/mapbox-gl-js/v2.15.0/mapbox-gl.css" rel="stylesheet">
        <link href="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-geocoder/v4.7.2/mapbox-gl-geocoder.css" rel="stylesheet">

        <script>
                                         mapboxgl.accessToken = 'pk.eyJ1Ijoic3RhZmYxIiwiYSI6ImNtYWZndDRjNzAybGUybG44ZWYzdTlsNWQifQ.jSJjwMo8_OQszYjWAAi7iQ';

                                         const geocoder = new MapboxGeocoder({
                                             accessToken: mapboxgl.accessToken,
                                             placeholder: 'Nhập địa chỉ giao hàng...',
                                             mapboxgl: mapboxgl,
                                             marker: false
                                         });

                                         // Gắn vào đúng vị trí mapboxAddressInput
                                         document.getElementById('mapboxAddressInput').appendChild(geocoder.onAdd(new mapboxgl.Map({
                                             container: document.createElement('div'),
                                             style: 'mapbox://styles/mapbox/streets-v11'
                                         })));

                                         // Khi chọn kết quả → gán vào hidden input
                                         geocoder.on('result', function (e) {
                                             const address = e.result.place_name;
                                             document.getElementById('modalAddress').value = address;
                                         });

                                         // Mở modal → gán giá trị ban đầu
                                         function openEditCustomer() {
                                             document.getElementById('modalFullName').value = '${customer.fullName}';
                                             document.getElementById('modalPhone').value = '${customer.phone}';
                                             document.getElementById('modalAddress').value = '${customer.address}';
                                             document.querySelector('.mapboxgl-ctrl-geocoder input').value = '${customer.address}'; // cập nhật gợi ý ban đầu
                                             new bootstrap.Modal(document.getElementById('editCustomerModal')).show();
                                         }

                                         function saveCustomerInfo() {
                                             const name = document.getElementById('modalFullName').value.trim();
                                             const phone = document.getElementById('modalPhone').value.trim();
                                             const address = document.getElementById('modalAddress').value.trim();

                                             if (!name || !phone || !address) {
                                                 alert("Please fill in all fields.");
                                                 return;
                                             }

                                             fetch('${pageContext.request.contextPath}/customer/order', {
                                                 method: 'POST',
                                                 headers: {
                                                     'Content-Type': 'application/x-www-form-urlencoded',
                                                     'X-Requested-With': 'XMLHttpRequest'
                                                 },
                                                 body: new URLSearchParams({
                                                     action: "updateInfo",
                                                     fullName: name,
                                                     phone: phone,
                                                     address: address
                                                 })
                                             })
                                                     .then(res => res.json())
                                                     .then(data => {
                                                         if (data.success) {
                                                             document.getElementById("displayCustomerText").textContent = name + " - " + phone;
                                                             document.getElementById("displayAddressText").textContent = address;
                                                             document.getElementById("hiddenFullName").value = name;
                                                             document.getElementById("hiddenPhone").value = phone;
                                                             document.getElementById("hiddenAddress").value = address;
                                                             bootstrap.Modal.getInstance(document.getElementById('editCustomerModal')).hide();

                                                             // ✅ truyền cả tọa độ nếu có
                                                             showMiniMap(address, selectedCoordinates);
                                                         } else {
                                                             alert("Failed to update customer info.");
                                                         }
                                                     })
                                                     .catch(err => {
                                                         console.error(err);
                                                         alert("Error occurred while updating info.");
                                                     });
                                         }

        </script>
        <!-- Hiển thị bản đồ nhỏ sau khi chọn địa chỉ -->
        <script>
            function showMiniMap(address, coordinates = null) {
                const miniMapDiv = document.getElementById("miniMap");
                miniMapDiv.innerHTML = ""; // xoá bản đồ cũ
                miniMapDiv.style.display = "block";

                if (coordinates) {
                    const [lng, lat] = coordinates;
                    const map = new mapboxgl.Map({
                        container: 'miniMap',
                        style: 'mapbox://styles/mapbox/streets-v11',
                        center: [lng, lat],
                        zoom: 14
                    });
                    new mapboxgl.Marker().setLngLat([lng, lat]).addTo(map);
                    return;
                }

                // fallback nếu không có toạ độ (ít khi dùng tới)
                const encodedAddress = encodeURIComponent(address);
                const geocodingUrl = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodedAddress}.json?access_token=YOUR_TOKEN_HERE`;

                fetch(geocodingUrl)
                        .then(res => res.json())
                        .then(data => {
                            if (data.features && data.features.length > 0) {
                                const [lng, lat] = data.features[0].center;
                                const map = new mapboxgl.Map({
                                    container: 'miniMap',
                                    style: 'mapbox://styles/mapbox/streets-v11',
                                    center: [lng, lat],
                                    zoom: 14
                                });
                                new mapboxgl.Marker().setLngLat([lng, lat]).addTo(map);
                            } else {
                                alert("Could not locate the address on map.");
                                miniMapDiv.style.display = "none";
                            }
                        })
                        .catch(err => {
                            console.error("Geocoding error:", err);
                            alert("Error showing map. Try again.");
                            miniMapDiv.style.display = "none";
                        });
            }


        </script>


        <%
            Customer customer = (Customer) request.getAttribute("customer");
            if (customer != null && customer.getAddress() != null && !customer.getAddress().isEmpty()) {
        %>
        <script>
            geocoder.on('result', function (e) {
                const address = e.result.place_name;
                selectedCoordinates = e.result.geometry.coordinates; // lấy [lng, lat]
                document.getElementById('modalAddress').value = address;
            });

        </script>
        <% } %>







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
