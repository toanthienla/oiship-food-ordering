<%@page import="java.util.List"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fmt:setLocale value="vi_VN" />
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

                <!-- Add Dish Button -->
                <div class="mb-4">
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addDishModal">
                        <i class="bi bi-plus-circle me-1"></i> Add Dish
                    </button>
                </div>

                <!-- Alert placeholder -->
                <div id="actionAlert" class="alert mt-3 d-none" role="alert"></div>

                <!-- Dish Filter and Table -->
                <div class="mt-2">
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
                                    <th class="text-center">#</th>
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
                                        <td class="text-center"><%= index++%></td>
                                        <td>${dish.dishName}</td>
                                        <td>${dish.category.catName}</td>
                                        <td>${dish.formattedPrice} đ</td>
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
                                                <button class="btn btn-sm btn-secondary w-100 mt-1"
                                                        onclick="showDishDetail(this); event.stopPropagation();"
                                                        data-id="${dish.dishID}"
                                                        data-cost="${dish.opCost}"
                                                        data-formattedCost="${dish.formattedOpCost}"
                                                        data-interest="${dish.interestPercentage}"
                                                        data-formattedProfit="${dish.formattedProfit}"
                                                        data-formattedIngredientsPrice="${dish.formattedIngredientsPrice}"
                                                        data-image="${dish.image}"
                                                        data-name="${dish.dishName}"
                                                        data-categoryname="${dish.category.catName}">
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

            <!-- Add Dish Modal -->
            <div class="modal fade" id="addDishModal" tabindex="-1" aria-labelledby="addDishModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="manage-dishes" method="post" enctype="multipart/form-data" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addDishModalLabel">Add New Dish</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-2">
                                <label class="form-label">Dish Name</label>
                                <input type="text" class="form-control" name="dishName" required />
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Operation Cost (VND)</label>
                                <input type="number" step="1000" class="form-control" name="opCost" required />
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Interest (%)</label>
                                <input type="number" step="0.01" class="form-control" name="interestPercentage" required />
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Image Upload</label>
                                <input type="file" class="form-control" name="image" id="addDishImageInput" accept="image/*" required />
                                <div id="addDishImagePreviewBox" class="mt-2" style="display:none;">
                                    <img id="addDishImagePreview" src="" alt="Preview" style="max-width: 100%; height: auto; border-radius: 8px" />
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="dishDescription" rows="2" required></textarea>
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Stock</label>
                                <input type="number" class="form-control" name="stock" min="0" value="0" required />
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Available?</label>
                                <select class="form-select" name="isAvailable">
                                    <option value="1">Yes</option>
                                    <option value="0" selected>No</option>
                                </select>
                            </div>
                            <div class="mb-2">
                                <label class="form-label">Category</label>
                                <select class="form-select" name="categoryID" required>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.catID}">${cat.catName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-success">Add Dish</button>
                        </div>
                    </form>
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

            <!-- Cost Detail Modal -->
            <div class="modal fade" id="costDetailModal" tabindex="-1" aria-labelledby="costDetailModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="costDetailModalLabel">Dish Cost Details</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="d-flex align-items-center mb-3">
                                <img id="modalDishImage" src="" alt="Dish Image" style="max-height: 80px; width: 120px; object-fit: cover; border-radius: 6px; margin-right: 16px;" />
                                <div>
                                    <div class="fw-bold fs-5" id="modalDishName"></div>
                                    <div class="text-muted" id="modalDishCategory"></div>
                                </div>
                            </div>
                            <div><span class="fw-normal">Operation Cost:</span> <span id="modalOpCost"></span> VND</div>
                            <div><span class="fw-normal">Ingredients Price:</span> <span id="modalIngredientsPrice"></span> VND</div>
                            <div><span class="fw-normal">Interest Percentage:</span> <span id="modalInterest"></span> %</div>
                            <div><span class="fw-normal">Profit:</span> <span id="modalProfit"></span> VND</div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
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

                // Cost detail popup logic with dish image, name, category
                function showDishDetail(button) {
                    // Set cost details
                    document.getElementById('modalOpCost').textContent = button.getAttribute('data-formattedCost') || button.getAttribute('data-cost') || "0";
                    document.getElementById('modalIngredientsPrice').textContent = button.getAttribute('data-formattedIngredientsPrice') || "0";
                    document.getElementById('modalInterest').textContent = button.getAttribute('data-interest') || "0";
                    document.getElementById('modalProfit').textContent = button.getAttribute('data-formattedProfit') || "0";

                    // Set dish image, name, category
                    document.getElementById('modalDishImage').src = button.getAttribute('data-image');
                    document.getElementById('modalDishName').textContent = button.getAttribute('data-name');
                    document.getElementById('modalDishCategory').textContent = "Category: " + button.getAttribute('data-categoryname');

                    // Show modal
                    var modal = new bootstrap.Modal(document.getElementById('costDetailModal'));
                    modal.show();
                }

                // Preview image before adding dish
                document.getElementById('addDishImageInput').addEventListener('change', function (event) {
                    const input = event.target;
                    const box = document.getElementById('addDishImagePreviewBox');
                    const img = document.getElementById('addDishImagePreview');

                    if (input.files && input.files[0]) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            img.src = e.target.result;
                            box.style.display = 'block';
                        };
                        reader.readAsDataURL(input.files[0]);
                    } else {
                        img.src = '';
                        box.style.display = 'none';
                    }
                });

                // Preview image before editing dish
                function previewNewImage(event) {
                    const input = event.target;
                    const img = document.getElementById('editDishImagePreview');
                    if (input.files && input.files[0]) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            img.src = e.target.result;
                        };
                        reader.readAsDataURL(input.files[0]);
                    }
                }
            </script>
    </body>
</html>