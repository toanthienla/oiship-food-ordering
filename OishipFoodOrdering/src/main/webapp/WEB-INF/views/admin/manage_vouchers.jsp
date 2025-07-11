<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin - Manage Vouchers</title>

        <!-- Bootstrap & Icons -->
        <link rel="stylesheet" href="../css/bootstrap.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
        <script src="../js/bootstrap.bundle.js"></script>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="../css/sidebar.css" />
        <link rel="stylesheet" href="../css/dashboard.css" />

        <script src="../js/sidebar.js"></script>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="admin_sidebar.jsp" />

        <!-- Main Section -->
        <div class="main" id="main">
            <!-- Topbar -->
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile">
                    <span class="username">Hi, Admin</span>
                </div>
            </div>

            <!-- Content -->
            <div class="content">
                <h1>Manage Vouchers</h1>
                <p>Manage promotional vouchers for your restaurant system.</p>

                <form action="manage-vouchers" method="post" class="row g-3 mt-4" onsubmit="return validateVoucherForm()">
                    <input type="hidden" name="action" value="add" />

                    <!-- Row 1: Code + Active -->
                    <div class="col-md-4">
                        <label class="form-label">Code</label>
                        <input type="text" name="code" class="form-control" required />
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Active</label>
                        <select name="active" class="form-select">
                            <option value="1">Yes</option>
                            <option value="0">No</option>
                        </select>
                    </div>

                    <!-- Row 2: Description -->
                    <div class="col-md-12">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Enter voucher description"></textarea>
                    </div>

                    <!-- Row 3: Discount Type, Discount Value, Max Discount -->
                    <div class="col-md-2">
                        <label class="form-label">Discount Type</label>
                        <select name="discountType" id="discountType" class="form-select" required onchange="toggleMaxDiscountField()">
                            <option value="%">Percentage (%)</option>
                            <option value="VND">Fixed (VND)</option>
                        </select>
                    </div>

                    <!-- Discount Value with dynamic suffix -->
                    <div class="col-md-4">
                        <label class="form-label">Discount Value</label>
                        <div class="input-group">
                            <input type="number" name="discount" step="0.01" class="form-control" required />
                            <span class="input-group-text" id="discountSuffix">%</span>
                        </div>
                    </div>

                    <!-- Max Discount -->
                    <div class="col-md-3" id="maxDiscountGroup">
                        <label class="form-label">Max Discount (VND)</label>
                        <input type="number" name="maxDiscount" id="maxDiscount" step="0.01" class="form-control" />
                    </div>

                    <!-- Row 4: Min Order -->
                    <div class="col-md-3">
                        <label class="form-label">Min Order Value (VND)</label>
                        <input type="number" name="minOrder" step="0.01" class="form-control" required />
                    </div>

                    <!-- Row 5: Start Date, End Date, Usage Limit -->
                    <div class="col-md-4">
                        <label class="form-label">Start Date</label>
                        <input type="date" name="startDate" id="startDate" class="form-control" required />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">End Date</label>
                        <input type="date" name="endDate" id="endDate" class="form-control" required />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Usage Limit</label>
                        <input type="number" name="usageLimit" class="form-control" required />
                    </div>

                    <!-- Submit Button -->
                    <div class="col-12">
                        <button type="submit" class="btn btn-success">Add Voucher</button>
                    </div>
                </form>

                <!-- Alert placeholder -->
                <div id="actionAlert" class="alert mt-3 d-none" role="alert"></div>

                <!-- Existing Vouchers -->
                <!-- Voucher Table -->
                <div class="mt-5">
                    <h4>Existing Vouchers</h4>
                    <div class="col-md-6 mt-3">
                        <div class="d-flex align-items-center">
                            <label class="me-2 fw-semibold mb-0">Search Voucher:</label>
                            <input type="text" id="voucherSearch" class="form-control w-auto" placeholder="Enter voucher code..." />
                        </div>
                    </div>
                    <% List<model.Voucher> vouchers = (List<model.Voucher>) request.getAttribute("vouchers"); %>
                    <% int index = 1;%>

                    <div class="table-responsive mt-3">
                        <table id="voucherTable" class="table table-bordered table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Code</th>
                                    <th>Description</th>
                                    <th>Available</th>
                                    <th>Discount</th>
                                    <th>Used / Limit</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="v" items="${vouchers}">
                                    <tr>
                                        <td><%= index++%></td>
                                        <td>${v.code}</td>
                                        <td>${v.voucherDescription}</td>
                                        <td>
                                            <span class="${v.active ? 'text-success' : 'text-danger'}">
                                                ${v.active ? 'Yes' : 'No'}
                                            </span>
                                        </td>
                                        <td>
                                            ${v.discount}
                                            <c:choose>
                                                <c:when test="${v.discountType == '%'}">%</c:when>
                                                <c:otherwise> VND</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${v.usedCount} / ${v.usageLimit}</td>
                                        <td class="text-center">
                                            <div class="d-flex flex-column gap-1 align-items-center">
                                                <!-- Row 1: Edit and Delete side by side -->
                                                <div class="d-flex gap-1 w-100 justify-content-center">
                                                    <button class="btn btn-sm btn-primary w-50"
                                                            data-id="${v.voucherID}"
                                                            data-code="${v.code}"
                                                            data-description="${v.voucherDescription}"
                                                            data-discount="${v.discount}"
                                                            data-type="${v.discountType}"
                                                            data-max="${v.maxDiscountValue}"
                                                            data-min="${v.minOrderValue}"
                                                            data-start="${v.startDate}"
                                                            data-end="${v.endDate}"
                                                            data-usage="${v.usageLimit}"
                                                            data-active="${v.active ? 1 : 0}"
                                                            onclick="handleEditClick(this); event.stopPropagation();">
                                                        Edit
                                                    </button>

                                                    <form action="manage-vouchers" method="post" class="w-50" onsubmit="return confirmDelete(event);">
                                                        <input type="hidden" name="action" value="delete" />
                                                        <input type="hidden" name="id" value="${v.voucherID}" />
                                                        <button type="submit" class="btn btn-sm btn-danger w-100">Delete</button>
                                                    </form>
                                                </div>

                                                <!-- Row 2: Voucher Terms full width -->
                                                <button class="btn btn-sm btn-secondary w-100"
                                                        onclick="showVoucherTerms(this); event.stopPropagation();"
                                                        data-type="${v.discountType}"
                                                        data-min="${v.minOrderValue}"
                                                        data-max="${v.maxDiscountValue}"
                                                        data-start="${v.startDate}"
                                                        data-end="${v.endDate}">
                                                    Voucher Terms
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Voucher Modal -->
        <div class="modal fade" id="editVoucherModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <form action="manage-vouchers" method="post" class="modal-content">
                    <input type="hidden" name="action" value="edit" />
                    <input type="hidden" id="editID" name="voucherID" />

                    <div class="modal-header">
                        <h5 class="modal-title">Edit Voucher</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <!-- Code -->
                        <div class="mb-2">
                            <label for="editCode" class="form-label">Code</label>
                            <input type="text" class="form-control" id="editCode" name="code" required />
                        </div>

                        <!-- Description -->
                        <div class="mb-2">
                            <label for="editDescription" class="form-label">Description</label>
                            <input type="text" class="form-control" id="editDescription" name="description" />
                        </div>

                        <!-- Discount -->
                        <div class="mb-2">
                            <label for="editDiscount" class="form-label">Discount</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="editDiscount" name="discount" step="0.01" />
                                <span class="input-group-text" id="discountSuffixEdit">%</span>
                            </div>
                        </div>

                        <!-- Discount Type -->
                        <div class="mb-2">
                            <label for="discountTypeEdit" class="form-label">Discount Type</label>
                            <select id="discountTypeEdit" name="discountType" class="form-select" required onchange="toggleMaxDiscountFieldEdit()">
                                <option value="%">Percentage (%)</option>
                                <option value="VND">Fixed (VND)</option>
                            </select>
                        </div>

                        <!-- Max Discount -->
                        <div class="mb-2">
                            <label for="maxDiscountEdit" class="form-label">Max Discount</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="maxDiscountEdit" name="maxDiscount" step="0.01" />
                            </div>
                        </div>

                        <!-- Min Order -->
                        <div class="mb-2">
                            <label for="editMin" class="form-label">Min Order</label>
                            <input type="number" class="form-control" id="editMin" name="minOrder" step="0.01" />
                        </div>

                        <!-- Start Date -->
                        <div class="mb-2">
                            <label for="editStart" class="form-label">Start Date</label>
                            <input type="date" class="form-control" id="editStart" name="startDate" />
                        </div>

                        <!-- End Date -->
                        <div class="mb-2">
                            <label for="editEnd" class="form-label">End Date</label>
                            <input type="date" class="form-control" id="editEnd" name="endDate" />
                        </div>

                        <!-- Usage Limit -->
                        <div class="mb-2">
                            <label for="editUsage" class="form-label">Usage Limit</label>
                            <input type="number" class="form-control" id="editUsage" name="usageLimit" />
                        </div>

                        <!-- Active -->
                        <div class="mb-2">
                            <label for="editActive" class="form-label">Active</label>
                            <select id="editActive" name="active" class="form-select">
                                <option value="1">Yes</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Voucher</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- JavaScript -->
        <script>
            function getParam(name) {
                const urlParams = new URLSearchParams(window.location.search);
                return urlParams.get(name);
            }

            window.addEventListener("DOMContentLoaded", () => {
                const success = getParam("success");
                const alertBox = document.getElementById("actionAlert");

                if (success) {
                    let message = "";
                    let alertClass = "";

                    switch (success) {
                        case "add":
                            message = '<i class="bi bi-check-circle-fill me-2"></i>Voucher added successfully!';
                            alertClass = "alert-success";
                            break;
                        case "false":
                            message = '<i class="bi bi-x-circle-fill me-2"></i>Failed to process voucher. Please try again.';
                            alertClass = "alert-danger";
                            break;
                        case "delete":
                            message = '<i class="bi bi-trash-fill me-2"></i>Voucher deleted successfully.';
                            alertClass = "alert-success";
                            break;
                        case "edit":
                            message = '<i class="bi bi-pencil-square me-2"></i>Voucher updated successfully.';
                            alertClass = "alert-success";
                            break;
                        default:
                            message = '<i class="bi bi-info-circle-fill me-2"></i>Unknown status.';
                            alertClass = "alert-secondary";
                    }

                    alertBox.innerHTML = message;
                    alertBox.classList.remove("d-none");
                    alertBox.classList.add("alert", alertClass, "mt-3");
                    alertBox.setAttribute("role", "alert");

                    // Clean the URL after displaying the alert
                    if (window.history.replaceState) {
                        const url = new URL(window.location);
                        url.searchParams.delete("success");
                        window.history.replaceState({}, document.title, url.pathname);
                    }
                }
            });

            function toggleDescription(item) {
                const desc = item.querySelector('.cat-description');
                if (desc) {
                    desc.style.display = (desc.style.display === 'none' || desc.style.display === '') ? 'block' : 'none';
                }
            }

            function handleEditClick(button) {
                document.getElementById("editID").value = button.dataset.id;
                document.getElementById("editCode").value = button.dataset.code;
                document.getElementById("editDescription").value = button.dataset.description;
                document.getElementById("editDiscount").value = button.dataset.discount;

                // Set discount type
                const typeSelect = document.getElementById("discountTypeEdit");
                typeSelect.value = button.dataset.type;

                // Set max discount
                document.getElementById("maxDiscountEdit").value = button.dataset.max;

                // Set other fields
                document.getElementById("editMin").value = button.dataset.min;
                document.getElementById("editStart").value = button.dataset.start.split("T")[0];
                document.getElementById("editEnd").value = button.dataset.end.split("T")[0];
                document.getElementById("editUsage").value = button.dataset.usage;
                document.getElementById("editActive").value = button.dataset.active;

                // ✅ Trigger the toggle logic based on the selected type
                toggleMaxDiscountFieldEdit();

                // Show modal
                const modal = new bootstrap.Modal(document.getElementById('editVoucherModal'));
                modal.show();
            }

            function confirmDelete(event) {
                const confirmed = confirm("Are you sure you want to delete this voucher?");
                if (!confirmed) {
                    event.preventDefault();
                    return false;
                }
                return true;
            }

            function showVoucherTerms(button) {
                const mainRow = button.closest('tr');
                const nextRow = mainRow.nextElementSibling;

                // Toggle detail row
                if (nextRow && nextRow.classList.contains('voucher-detail-row')) {
                    nextRow.remove();
                    return;
                }

                // Remove any other open detail rows
                document.querySelectorAll('.voucher-detail-row').forEach(function (row) {
                    row.remove();
                });

                const formatDate = function (dateString) {
                    if (!dateString)
                        return 'N/A';
                    const date = new Date(dateString);
                    return isNaN(date) ? 'N/A' : new Intl.DateTimeFormat('vi-VN').format(date);
                };

                const min = Number(button.getAttribute("data-min") || 0).toLocaleString('vi-VN');
                const max = Number(button.getAttribute("data-max") || 0).toLocaleString('vi-VN');
                const start = formatDate(button.getAttribute("data-start") || 'N/A');
                const end = formatDate(button.getAttribute("data-end") || 'N/A');
                const type = button.getAttribute("data-type");

                var html = '';
                html += '<td colspan="10">';
                html += '<div class="p-3 bg-light border">';
                html += '<h6 class="mb-2 fw-semibold">Voucher Terms</h6>';
                html += '<div><span class="fw-normal">Minimum Order Value:</span> ' + min + ' VND</div>';

                if (type === '%') {
                    html += '<div><span class="fw-normal">Maximum Discount Value:</span> ' + max + ' VND</div>';
                }

                html += '<div><span class="fw-normal">Start Date:</span> ' + start + '</div>';
                html += '<div><span class="fw-normal">End Date:</span> ' + end + '</div>';
                html += '</div>';
                html += '</td>';

                var detailRow = document.createElement('tr');
                detailRow.className = 'voucher-detail-row';
                detailRow.innerHTML = html;

                mainRow.parentNode.insertBefore(detailRow, mainRow.nextSibling);
            }

            function removeVietnameseTones(str) {
                return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/đ/g, "d").replace(/Đ/g, "D");
            }

            document.getElementById("voucherSearch").addEventListener("input", function () {
                const searchKeyword = removeVietnameseTones(this.value.trim().toLowerCase());

                const rows = document.querySelectorAll("#voucherTable tbody tr");

                rows.forEach(row => {
                    const codeCell = row.cells[1]?.textContent.trim().toLowerCase() || ""; // Voucher code column
                    const normalizedCode = removeVietnameseTones(codeCell);
                    const matches = normalizedCode.includes(searchKeyword);
                    row.style.display = matches ? "" : "none";
                });
            });

            function validateVoucherForm() {
                const start = new Date(document.getElementById("startDate").value);
                const end = new Date(document.getElementById("endDate").value);
                const discountType = document.getElementById("discountType").value;
                const maxDiscount = document.getElementById("maxDiscount").value;

                if (end < start) {
                    alert("End Date must be the same as or after the Start Date.");
                    return false;
                }

                if (discountType === "%" && (maxDiscount === "" || parseFloat(maxDiscount) <= 0)) {
                    alert("Max Discount (VND) is required and must be greater than 0 when discount type is %.");
                    return false;
                }

                return true;
            }

            function toggleMaxDiscountField() {
                const type = document.getElementById("discountType").value;
                const maxInput = document.getElementById("maxDiscount");
                const suffix = document.getElementById("discountSuffix");

                if (type === "VND") {
                    maxInput.disabled = true;
                    maxInput.value = "";
                    suffix.textContent = "VND";
                } else {
                    maxInput.disabled = false;
                    suffix.textContent = "%";
                }
            }

            function toggleMaxDiscountFieldEdit() {
                const type = document.getElementById("discountTypeEdit").value;
                const maxInput = document.getElementById("maxDiscountEdit");
                const suffix = document.getElementById("discountSuffixEdit");

                if (type === "VND") {
                    maxInput.disabled = true;
                    maxInput.value = "";
                    suffix.textContent = "VND";
                } else {
                    maxInput.disabled = false;
                    suffix.textContent = "%";
                }
            }
        </script>
    </body>
</html>
