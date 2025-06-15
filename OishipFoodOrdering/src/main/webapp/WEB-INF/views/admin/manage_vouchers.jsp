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

                <form action="manage-vouchers" method="post" class="row g-3 mt-4">
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

                    <!-- Row 3: Discount, Max Discount, Min Order -->
                    <div class="col-md-4">
                        <label class="form-label">Discount (%)</label>
                        <input type="number" name="discount" step="0.01" class="form-control" required />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Max Discount (VND)</label>
                        <input type="number" name="maxDiscount" step="0.01" class="form-control" required />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Min Order Value (VND)</label>
                        <input type="number" name="minOrder" step="0.01" class="form-control" required />
                    </div>

                    <!-- Row 4: Start Date, End Date, Usage Limit -->
                    <div class="col-md-4">
                        <label class="form-label">Start Date</label>
                        <input type="date" name="startDate" class="form-control" required />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">End Date</label>
                        <input type="date" name="endDate" class="form-control" required />
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

                <!-- Existing Vouchers -->
                <div class="mt-5">
                    <h4>Existing Vouchers</h4>
                    <ul class="list-group mt-3 list-group-flush">
                        <% List<model.Voucher> vouchers = (List<model.Voucher>) request.getAttribute("vouchers");%>
                        <% int index = 1;%>
                        <c:forEach var="v" items="${vouchers}">
                            <div class="list-group-item list-group-item-action"
                                 style="cursor: pointer;" onclick="toggleDescription(this)">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span style="font-weight: 400">
                                        <span class="me-1" style="font-weight: 400;"><%= index++%>.</span>
                                        ${v.code}
                                        (Available: 
                                        <span class="${v.active ? 'text-success' : 'text-danger'}">
                                            ${v.active ? 'Yes' : 'No'})
                                        </span>
                                    </span>
                                    <div>
                                        <!-- Edit Button -->
                                        <a href="#" class="btn btn-sm btn-primary me-2"
                                           data-id="${v.voucherID}"
                                           data-code="${v.code}"
                                           data-description="${v.voucherDescription}"
                                           data-discount="${v.discount}"
                                           data-max="${v.maxDiscountValue}"
                                           data-min="${v.minOrderValue}"
                                           data-start="${v.startDate}"
                                           data-end="${v.endDate}"
                                           data-usage="${v.usageLimit}"
                                           data-active="${v.active ? 1 : 0}"
                                           onclick="handleEditClick(this); event.stopPropagation();">
                                            Edit
                                        </a>
                                        <!-- Delete Button -->
                                        <form action="manage-vouchers" method="post" style="display:inline;" onsubmit="return confirmDelete(event);">
                                            <input type="hidden" name="action" value="delete" />
                                            <input type="hidden" name="id" value="${v.voucherID}" />
                                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                        </form>
                                    </div>
                                </div>
                                <div class="cat-description text-muted" style="display: none; margin-top: -5px; margin-left: 20px">
                                    Description: ${v.voucherDescription}<br />
                                    Discount: ${v.discount}% | Max: ${v.maxDiscountValue} | Min Order: ${v.minOrderValue}<br />
                                    Start: ${v.startDate} | End: ${v.endDate}<br />
                                    Limit: ${v.usageLimit}, Used: ${v.usedCount}
                                </div>
                            </div>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Edit Voucher Modal -->
        <div class="modal fade" id="editVoucherModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <form action="manage-vouchers" method="post" class="modal-content">
                    <input type="hidden" name="action" value="edit" />
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Voucher</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="edit" />
                        <input type="hidden" id="editID" name="voucherID" />
                        <div class="mb-2"><label>Code</label><input type="text" class="form-control" id="editCode" name="code" required /></div>
                        <div class="mb-2"><label>Description</label><input type="text" class="form-control" id="editDescription" name="description" /></div>
                        <div class="mb-2"><label>Discount</label><input type="number" class="form-control" id="editDiscount" name="discount" step="0.01" /></div>
                        <div class="mb-2"><label>Max Discount</label><input type="number" class="form-control" id="editMax" name="maxDiscount" step="0.01" /></div>
                        <div class="mb-2"><label>Min Order</label><input type="number" class="form-control" id="editMin" name="minOrder" step="0.01" /></div>
                        <div class="mb-2"><label>Start Date</label><input type="date" class="form-control" id="editStart" name="startDate" /></div>
                        <div class="mb-2"><label>End Date</label><input type="date" class="form-control" id="editEnd" name="endDate" /></div>
                        <div class="mb-2"><label>Usage Limit</label><input type="number" class="form-control" id="editUsage" name="usageLimit" /></div>
                        <div class="mb-2">
                            <label>Active</label>
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
                document.getElementById("editMax").value = button.dataset.max;
                document.getElementById("editMin").value = button.dataset.min;
                document.getElementById("editStart").value = button.dataset.start.split("T")[0];
                document.getElementById("editEnd").value = button.dataset.end.split("T")[0];
                document.getElementById("editUsage").value = button.dataset.usage;
                document.getElementById("editActive").value = button.dataset.active;

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
        </script>
    </body>
</html>
