<%@page import="java.util.List"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fmt:setLocale value="vi_VN" />
<fmt:formatNumber value="${dish.opCost}" type="number" groupingUsed="true" />
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin - Manage Dishes</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Bootstrap -->
        <link rel="stylesheet" href="../css/bootstrap.css">
        <script src="../js/bootstrap.bundle.js"></script>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="../css/sidebar.css">
        <link rel="stylesheet" href="../css/dashboard.css">
        <script src="../js/sidebar.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

    </head>
    <body>

        <!-- Sidebar -->
        <jsp:include page="admin_sidebar.jsp" />

        <!-- Main Content -->
        <div class="main" id="main">
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile"><span class="username">Hi, Admin</span></div>
            </div>

            <div class="content">
                <h1>Manage Dishes</h1>
                <p>Add, view, and manage your restaurant's dishes.</p>

                <!-- Add Dish Form -->
                <form action="manage-dishes" method="post" enctype="multipart/form-data" class="row g-3 mt-4">
                    <div class="col-md-5">
                        <label class="form-label">Dish Name</label>
                        <input type="text" class="form-control" name="dishName" placeholder="Enter dish name" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Operation Cost (VND)</label>
                        <input type="number"
                               class="form-control"
                               name="opCost"
                               id="opCost"
                               placeholder="e.g. 50000"
                               min="0"
                               required />
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Interest (%)</label>
                        <input type="number"
                               step="0.01"
                               class="form-control"
                               name="interestPercentage"
                               id="interestPercentage"
                               placeholder="e.g. 10.5"
                               min="0"
                               required />
                    </div>

                    <div class="col-12">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="dishDescription" rows="2" placeholder="Describe the dish" required></textarea>
                    </div>

                    <div class="col-md-5">
                        <label class="form-label">Image Upload</label>
                        <input type="file" class="form-control" name="image" accept="image/*" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Stock</label>
                        <input type="number" class="form-control" name="stock" min="0" value="0" required>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Available?</label>
                        <select class="form-select" name="isAvailable">
                            <option value="0" selected>No</option>
                            <option value="1">Yes</option>
                        </select>
                    </div>

                    <div class="col-md-5">
                        <label class="form-label">Category</label>
                        <select class="form-select" name="categoryID" required>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.catID}">${cat.catName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-12">
                        <button type="submit" class="btn btn-success">Add Dish</button>
                    </div>
                </form>

                <!-- Alert placeholder -->
                <div id="actionAlert" class="alert mt-3 d-none" role="alert"></div>

                <!-- Dish Filter and Table -->
                <div class="mt-5">
                    <div class="row mb-3">
                        <div class="col-md-12">
                            <h4>Existing Dishes by Category</h4>
                        </div>
                        <div class="col-md-6 mt-3">
                            <div class="d-flex align-items-center">
                                <label class="me-2 fw-semibold mb-0">Search Dish:</label>
                                <input type="text" id="dishSearch" class="form-control w-auto" placeholder="Enter dish name..." />
                            </div>
                        </div>
                        <div class="col-md-6 mt-3">
                            <div class="d-flex align-items-center justify-content-md-end mt-2 mt-md-0">
                                <label class="me-2 fw-semibold mb-0">Filter by Category:</label>
                                <select id="categoryFilter" class="form-select w-auto">
                                    <option value="all">All</option> 
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.catName}">${cat.catName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <% int index = 1;%>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle" id="dishTable">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Dish Name</th>
                                    <th>Category</th>
                                    <th>Total price</th>
                                    <th>Available</th>
                                    <th>Stock</th>
                                    <!--<th>Op Cost (đ)</th>-->
                                    <!--<th>Interest (%)</th>-->
                                    <th>Description</th>
                                    <th>Image</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="dish" items="${dishes}">
                                    <tr data-category="${dish.category.catName}">
                                        <td><%= index++%></td>
                                        <td>${dish.dishName}</td>
                                        <td>${dish.category.catName}</td>
                                        <td>...</td>
                                        <td>
                                            <span class="${dish.isAvailable ? 'text-success' : 'text-danger'}">
                                                ${dish.isAvailable ? 'Yes' : 'No'}
                                            </span>
                                        </td>
                                        <td>${dish.stock}</td>
                                        <!--<td><fmt:formatNumber value="${dish.opCost}" type="number" groupingUsed="true" /></td>-->
                                        <!--<td>${dish.interestPercentage}</td>-->
                                        <td style="max-width: 200px;">${dish.dishDescription}</td>
                                        <td class="align-middle">
                                            <img src="${dish.image}" alt="${dish.dishName}" class="img-fluid" style="max-height: 80px; width: 120px; object-fit: cover; border-radius: 1px" />
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex flex-column gap-1 align-items-center">
                                                <!-- Row 1: Edit and Delete side by side -->
                                                <div class="d-flex gap-1 w-100 justify-content-center">
                                                    <button class="btn btn-sm btn-primary w-50"
                                                            onclick="handleEditDish(this); event.stopPropagation();"
                                                            data-id="${dish.dishID}"
                                                            data-name="${dish.dishName}"
                                                            data-cost="${dish.opCost}"
                                                            data-interest="${dish.interestPercentage}"
                                                            data-description="${dish.dishDescription}"
                                                            data-stock="${dish.stock}"
                                                            data-available="${dish.isAvailable}"
                                                            data-image="${dish.image}"
                                                            data-category="${dish.category.catID}">
                                                        Edit
                                                    </button>
                                                    <a href="manage-dishes?action=delete&id=${dish.dishID}"
                                                       class="btn btn-sm btn-danger w-50"
                                                       onclick="return confirmDelete(event);">
                                                        Delete
                                                    </a>
                                                </div>

                                                <!-- Row 2: Cost Detail full width -->
                                                <button class="btn btn-sm btn-secondary w-100"
                                                        onclick="showDishDetail(this); event.stopPropagation();"
                                                        data-id="${dish.dishID}"
                                                        data-cost="${dish.opCost}"
                                                        data-interest="${dish.interestPercentage}">
                                                    Cost Detail
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

            <!-- Edit Dish Modal -->
            <div class="modal fade" id="editDishModal" tabindex="-1" aria-labelledby="editDishModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="manage-dishes" method="post" enctype="multipart/form-data" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Edit Dish</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" id="editDishID" name="dishID" />

                            <div class="mb-2">
                                <label class="form-label">Dish Name</label>
                                <input type="text" class="form-control" id="editDishName" name="dishName" required />
                            </div>

                            <div class="mb-2">
                                <label class="form-label">Operation Cost (VND)</label>
                                <input type="number" step="1000" class="form-control" id="editOpCost" name="opCost" required>
                            </div>

                            <div class="mb-2">
                                <label class="form-label">Interest (%)</label>
                                <input type="number" step="0.01" class="form-control" id="editInterest" name="interestPercentage" required />
                            </div>

                            <div class="mb-2">
                                <label class="form-label">Current Image</label>
                                <div class="mb-2">
                                    <img id="editDishImagePreview" 
                                         src="" 
                                         alt="Current Dish Image" 
                                         style="max-width: 100%; height: auto; border-radius: 8px" />
                                </div>

                                <label for="editDishImageInput" class="form-label">Upload New Image</label>
                                <input type="file" 
                                       class="form-control mt-1" 
                                       id="editDishImageInput" 
                                       name="image" 
                                       accept="image/*" 
                                       onchange="previewNewImage(event)" />
                            </div>

                            <div class="mb-2">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" id="editDescription" name="dishDescription" rows="2" required></textarea>
                            </div>

                            <div class="mb-2">
                                <label class="form-label">Stock</label>
                                <input type="number" class="form-control" id="editStock" name="stock" required/>
                            </div>

                            <div class="mb-2">
                                <label class="form-label">Available?</label>
                                <select class="form-select" id="editAvailable" name="isAvailable">
                                    <option value="1">Yes</option>
                                    <option value="0">No</option>
                                </select>
                            </div>

                            <div class="mb-2">
                                <label class="form-label">Category</label>
                                <select class="form-select" id="editCategory" name="categoryID">
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.catID}">${cat.catName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Update Dish</button>
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
                                message = '<i class="bi bi-check-circle-fill me-2"></i>Dish added successfully!';
                                alertClass = "alert-success";
                                break;
                            case "false":
                                message = '<i class="bi bi-x-circle-fill me-2"></i>Failed to process dish. Please try again.';
                                alertClass = "alert-danger";
                                break;
                            case "delete":
                                message = '<i class="bi bi-trash-fill me-2"></i>Dish deleted successfully.';
                                alertClass = "alert-success";
                                break;
                            case "edit":
                                message = '<i class="bi bi-pencil-square me-2"></i>Dish updated successfully.';
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
                    desc.style.display = (desc.style.display === 'none' || desc.style.display === '') ? 'block' : 'none';
                }

                function confirmDelete(event) {
                    if (!confirm("Are you sure you want to delete this dish?")) {
                        event.preventDefault();
                        return false;
                    }
                    return true;
                }

                function handleEditDish(button) {
                    document.getElementById('editDishID').value = button.getAttribute('data-id');
                    document.getElementById('editDishName').value = button.getAttribute('data-name');
                    document.getElementById('editOpCost').value = button.getAttribute('data-cost');
                    document.getElementById('editInterest').value = button.getAttribute('data-interest');
                    document.getElementById('editDescription').value = button.getAttribute('data-description');
                    document.getElementById('editStock').value = button.getAttribute('data-stock');
                    document.getElementById('editAvailable').value = button.getAttribute('data-available') === "1" ? "1" : "0";
                    document.getElementById('editCategory').value = button.getAttribute('data-category');

                    // Show the current image
                    const imagePath = button.getAttribute('data-image');
                    document.getElementById('editDishImagePreview').src = imagePath;

                    new bootstrap.Modal(document.getElementById('editDishModal')).show();
                }

                // Filter logic
                document.getElementById("categoryFilter").addEventListener("change", function () {
                    const selectedCategory = this.value;
                    const rows = document.querySelectorAll("#dishTable tbody tr");

                    rows.forEach(row => {
                        const rowCategory = row.getAttribute("data-category");
                        if (selectedCategory === "all" || rowCategory === selectedCategory) {
                            row.style.display = "";
                        } else {
                            row.style.display = "none";
                        }
                    });
                });

                // Search logic
                const categoryFilter = document.getElementById("categoryFilter");
                const searchInput = document.getElementById("dishSearch");
                function removeVietnameseTones(str) {
                    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/đ/g, "d").replace(/Đ/g, "D");
                }

                function filterDishes() {
                    const selectedCategory = categoryFilter.value.toLowerCase();
                    const searchKeyword = removeVietnameseTones(searchInput.value.trim().toLowerCase());

                    const rows = document.querySelectorAll("#dishTable tbody tr");

                    rows.forEach(row => {
                        const category = row.getAttribute("data-category")?.toLowerCase() || "";
                        const dishName = row.cells[1].textContent.toLowerCase();
                        const normalizedDishName = removeVietnameseTones(dishName);

                        const matchesCategory = selectedCategory === "all" || category === selectedCategory;
                        const matchesSearch = normalizedDishName.includes(searchKeyword);

                        row.style.display = matchesCategory && matchesSearch ? "" : "none";
                    });
                }

                categoryFilter.addEventListener("change", filterDishes);
                searchInput.addEventListener("input", filterDishes);

                function showDishDetail(button) {
                    const mainRow = button.closest('tr');
                    const nextRow = mainRow.nextElementSibling;

                    // If next row is already the detail row, toggle (remove it)
                    if (nextRow && nextRow.classList.contains('dish-detail-row')) {
                        nextRow.remove();
                        return;
                    }

                    // Remove other existing detail rows
                    document.querySelectorAll('.dish-detail-row').forEach(row => row.remove());

                    // Get data
                    const opCost = Number(button.getAttribute("data-cost") || 0).toLocaleString('vi-VN');
                    const interest = button.getAttribute("data-interest") || "0";

                    // Create new row
                    const newRow = document.createElement('tr');
                    newRow.classList.add('dish-detail-row');
                    newRow.innerHTML =
                            '<td colspan="10">' +
                            '<div class="p-3 bg-light border">' +
                            '<h6 class="mb-2 fw-semibold">Dish Cost Details</h6>' +
                            '<div><span class="fw-normal">Operation Cost:</span> ' + opCost + ' VND</div>' +
                            '<div><span class="fw-normal">Ingredient Price:</span> ' + `...` + ' VND</div>' +
                            '<div><span class="fw-normal">Interest Percentage:</span> ' + interest + ' %</div>' +
                            '<div><span class="fw-normal">Net Profit:</span> ' + `...` + ' VND</div>' +
                            '</div>' +
                            '</td>';

                    // Insert new detail row
                    mainRow.parentNode.insertBefore(newRow, mainRow.nextSibling);
                }
            </script>
    </body>
</html>
