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

                <!-- Filter Dropdown -->
                <div class="mt-5">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <h4>Existing Dishes by Category</h4>
                        </div>
                        <div class="col-md-6">
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

                    <ul class="list-group list-group-flush" id="dishList">
                        <c:set var="prevCat" value="" />
                        <% int index = 1;%>
                        <c:forEach var="dish" items="${dishes}">
                            <li class="list-group-item list-group-item-action dish-item" data-category="${dish.category.catName}" style="cursor: pointer;" onclick="toggleDescription(this)">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span style="font-weight: 400">
                                        <span class="me-1" style="font-weight: 400;"><%= index++%>.</span>
                                        ${dish.dishName}
                                        (Available: 
                                        <span class="${dish.isAvailable ? 'text-success' : 'text-danger'}">
                                            ${dish.isAvailable ? 'Yes' : 'No'})
                                        </span>
                                    </span>
                                    <div>
                                        <a href="#" class="btn btn-sm btn-primary me-2"
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
                                        </a>
                                        <a href="manage-dishes?action=delete&id=${dish.dishID}"
                                           class="btn btn-sm btn-danger"
                                           onclick="return confirmDelete(event);">
                                            Delete
                                        </a>
                                    </div>
                                </div>

                                <!-- Description Section -->
                                <div class="cat-description text-muted" style="display: none; margin-left: 20px; margin-top: 5px">
                                    <div class="d-flex align-items-center gap-3 flex-wrap">
                                        <img src="${dish.image}" alt="${dish.dishName}" style="height: 160px; border-radius: 1.5px;" />
                                        <div>
                                            <div style="font-weight: 400">Total price: ...</div>
                                            <div style="font-weight: 400">Ingredient price: ...</div>
                                            <div style="font-weight: 400">
                                            <div style="font-weight: 400">Net profit: ...</div>
                                                Cost: <fmt:formatNumber value="${dish.opCost}" type="number" groupingUsed="true" />đ
                                            </div>
                                            <div style="font-weight: 400">Interest: ${dish.interestPercentage}%</div>
                                            <div style="font-weight: 400">Stock: ${dish.stock}</div>
                                            <div style="font-weight: 400">Description: ${dish.dishDescription}</div>
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
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
//                const params = new URLSearchParams(window.location.search);
//                const success = params.get("success");
//
//                if (success === "false") {
//                    alert("Failed to add category. Please try again.");
//                } else if (success === "true") {
//                    alert("Success to add dish.");
//                }

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
                document.addEventListener('DOMContentLoaded', () => {
                    const filterSelect = document.getElementById('categoryFilter');
                    const dishes = document.querySelectorAll('.dish-item');
                    const headers = document.querySelectorAll('.category-header');

                    const filterDishes = () => {
                        const selected = filterSelect.value;

                        dishes.forEach(dish => {
                            const match = selected === 'all' || dish.dataset.category === selected;
                            dish.style.display = match ? 'block' : 'none';
                        });

                        headers.forEach(header => {
                            const category = header.dataset.category;
                            const hasVisible = Array.from(dishes).some(dish =>
                                dish.dataset.category === category && dish.style.display !== 'none'
                            );
                            header.style.display = hasVisible ? 'block' : 'none';
                        });
                    };

                    filterSelect.addEventListener('change', filterDishes);
                    filterDishes(); // Run on page load
                });
            </script>
    </body>
</html>
