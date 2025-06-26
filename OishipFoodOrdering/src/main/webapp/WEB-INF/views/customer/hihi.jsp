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
    <title>Xác nhận đơn hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="container py-4">
    <h2 class="mb-4">Xác nhận đơn hàng</h2>

    <form action="${pageContext.request.contextPath}/customer/order" method="post">
        <input type="hidden" name="action" value="confirm"/>
        <input type="hidden" name="voucherID" id="hiddenVoucherID"/>

        <!-- Danh sách món -->
        <h4 class="mb-3">Món đã chọn</h4>
        <%
            List<Cart> selectedCarts = (List<Cart>) request.getAttribute("selectedCarts");
            BigDecimal grandTotal = (BigDecimal) request.getAttribute("grandTotal");
        %>

        <div class="mb-4">
            <% for (Cart cart : selectedCarts) {
                Dish dish = cart.getDish();
                BigDecimal price = dish.getTotalPrice();
                BigDecimal total = price.multiply(BigDecimal.valueOf(cart.getQuantity()));
            %>
            <div class="d-flex align-items-center mb-3 border p-2 rounded">
                <img src="<%= dish.getImage()%>" width="80" class="me-3">
                <div>
                    <strong><%= dish.getDishName()%></strong><br/>
                    Quantity: <%= cart.getQuantity()%> <br/>
                    Total: <%= String.format("%,.0f", total)%> VND
                </div>
            </div>
            <% } %>
        </div>

        <!-- Mã giảm giá -->
        <div class="mb-4">
            <label class="form-label fw-bold">Mã giảm giá</label>
            <div class="p-2 border rounded bg-light" style="cursor:pointer;" data-bs-toggle="modal" data-bs-target="#voucherModal">
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="mb-0">Chọn mã giảm giá</p>
                        <small class="text-muted" id="voucherStatusText">Chưa áp dụng</small>
                    </div>
                    <i class="bi bi-chevron-right fs-5"></i>
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
                                     onclick="selectVoucher('<%= v.getVoucherID() %>', '<%= v.getCode() %>')">
                                    <div class="fw-bold text-danger"><%= v.getCode() %></div>
                                    <div>
                                        <%= v.getDiscountType().equals("%")
                                                ? ("Giảm " + v.getDiscount() + "%")
                                                : ("Giảm " + String.format("%,.0f", v.getDiscount()) + "đ") %>
                                    </div>
                                    <div class="text-muted"><%= v.getVoucherDescription() %></div>
                                </div>
                            </div>
                            <% }
                            } else { %>
                            <div class="col-12 text-center text-muted">Không có voucher nào khả dụng</div>
                            <% } %>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tổng tiền -->
        <div class="mb-3">
            <div class="d-flex justify-content-between">
                <span>Tổng cộng:</span>
                <span id="totalBefore" data-value="<%= grandTotal %>"><%= String.format("%,.0f", grandTotal) %> VND</span>
            </div>
            <div class="d-flex justify-content-between">
                <span>Giảm giá:</span>
                <span id="discountAmount">- 0 VND</span>
            </div>
            <div class="d-flex justify-content-between fw-bold fs-5">
                <span>Thành tiền:</span>
                <span id="finalAmount"><%= String.format("%,.0f", grandTotal) %> VND</span>
            </div>
        </div>

        <!-- Truyền cartID -->
        <c:forEach var="id" items="${selectedCartIDs}">
            <input type="hidden" name="selectedItems" value="${id}" />
        </c:forEach>

        <!-- Nút xác nhận -->
        <div class="d-grid">
            <button type="submit" class="btn btn-primary">Xác nhận đặt hàng</button>
            <a href="${pageContext.request.contextPath}/customer/view-cart" class="btn btn-outline-secondary mt-2">Quay lại giỏ hàng</a>
        </div>
    </form>

   <script>
  
    const allVouchers = [
        <% for (Voucher v : vouchers) { %>
        {
            voucherID: <%= v.getVoucherID() %>,
            code: "<%= v.getCode() %>",
            discountType: "<%= v.getDiscountType() %>",
            discount: <%= v.getDiscount() %>,
            maxDiscountValue: <%= v.getMaxDiscountValue() != null ? v.getMaxDiscountValue() : "null" %>,
            minOrderValue: <%= v.getMinOrderValue() %>
        },
        <% } %>
    ];

function selectVoucher(voucherID, code) {
    const orderTotal = parseFloat(document.getElementById("totalBefore").getAttribute("data-value"));
    const voucherText = document.getElementById("voucherStatusText");
    const discountText = document.getElementById("discountAmount");
    const finalTotalText = document.getElementById("finalAmount");
    const hiddenInput = document.getElementById("hiddenVoucherID");

    // Tìm voucher theo ID
    const voucher = allVouchers.find(v => v.voucherID == voucherID);

    if (!voucher) {
        alert("Không tìm thấy voucher.");
        return;
    }

    // Kiểm tra điều kiện đơn hàng tối thiểu
    if (orderTotal < voucher.minOrderValue) {
        alert("Đơn hàng chưa đạt giá trị tối thiểu để áp dụng mã này.");
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

    // Gán giá trị vào form + UI
    hiddenInput.value = voucherID;
    voucherText.textContent = "Đã áp dụng: " + code;
    discountText.textContent = "- " + discountAmount.toLocaleString() + " VND";
    finalTotalText.textContent = finalTotal.toLocaleString() + " VND";

    // Đóng modal
    const modal = bootstrap.Modal.getInstance(document.getElementById('voucherModal'));
    modal.hide();
}


</script>
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
                let displayText = "";
                if (name && phone) {
                    displayText = name + "- " + phone;
                } else if (name) {
                    displayText = name;
                } else if (phone) {
                    displayText = phone;
                }
                // ✅ Đảm bảo không hiển thị dấu phẩy nếu chỉ có 1 trong 2 trường
                document.getElementById("displayCustomerText").textContent = displayText;
                //   document.getElementById('displayCustomerText').innerText = `${name} - ${phone}`;

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
                bootstrap.Modal.getInstance(document.getElementById('editCustomerModal')).hide();
            }

            function saveAddress() {
                const address = document.getElementById('modalAddress').value.trim();
                if (!address) {
                    alert('Please enter address.');
                    return;
                }
                document.getElementById('displayAddressText').innerText = address;

                // Gán vào input ẩn để submit form
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
</body>
</html>