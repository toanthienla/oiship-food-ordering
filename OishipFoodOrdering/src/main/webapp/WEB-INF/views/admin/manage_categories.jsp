<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin - Manage Account</title>

        <!-- Bootstrap 5 CSS & JS -->
        <link rel="stylesheet" href="../css/bootstrap.css" />
        <script src="../js/bootstrap.bundle.js"></script>

        <!--CSS for Dashboard-->
        <link rel="stylesheet" href="../css/sidebar.css" />
        <!--CSS for Sidebar-->
        <link rel="stylesheet" href="../css/dashboard.css" />

        <!--JS for Sidebar-->
        <script src="../js/sidebar.js"></script>

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

        <style>
        </style>
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
                <h1>Manage Categories</h1>
                <p>Manage your restaurant's menu and menu items.</p>

                <!-- Add Category Button -->
                <div class="mb-4">
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                        <i class="bi bi-plus-circle me-1"></i> Add Category
                    </button>
                </div>

                <!-- Alert placeholder -->
                <div id="actionAlert" class="alert mt-3 d-none" role="alert"></div>

                <!-- Category Table -->
                <div class="mt-2">
                    <h4>Existing Categories</h4>
                    <div class="col-md-6 mt-3">
                        <div class="d-flex align-items-center">
                            <label class="me-2 fw-semibold mb-0">Search Category:</label>
                            <input type="text" id="categorySearch" class="form-control w-auto" placeholder="Enter category name..." />
                        </div>
                    </div>
                    <% List<model.Category> categories = (List<model.Category>) request.getAttribute("categories"); %>
                    <% int index = 1;%>
                    <div class="table-responsive mt-3">
                        <table class="table table-bordered table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-center">#</th>
                                    <th>Category Name</th>
                                    <th>Description</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cat" items="${categories}">
                                    <tr>
                                        <td class="text-center"><%= index++%></td>
                                        <td>${cat.catName}</td>
                                        <td>${cat.catDescription}</td>
                                        <td class="text-center">
                                            <div class="d-flex flex-wrap justify-content-center gap-2">
                                                <button type="button"
                                                        class="btn btn-sm btn-primary px-3"
                                                        data-id="${cat.catID}"
                                                        data-name="${cat.catName}"
                                                        data-description="${cat.catDescription}"
                                                        onclick="handleEditClick(this);">
                                                    Edit
                                                </button>

                                                <a href="manage-categories?action=delete&id=${cat.catID}"
                                                   class="btn btn-sm btn-danger px-3"
                                                   onclick="return confirmDelete(event);">
                                                    Delete
                                                </a>
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

        <!-- Add Category Modal -->
        <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form action="manage-categories" method="post" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCategoryModalLabel">Add New Category</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Category Name -->
                        <div class="mb-3">
                            <label for="catName" class="form-label">Category Name</label>
                            <input type="text" class="form-control" id="catName" name="catName" required placeholder="Enter category name">
                        </div>
                        <!-- Category Description -->
                        <div class="mb-3">
                            <label for="catDescription" class="form-label">Category Description</label>
                            <textarea class="form-control" id="catDescription" name="catDescription" rows="3" required placeholder="Describe the category"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Add Category</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Edit Category Modal -->
        <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form action="manage-categories" method="post" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editCategoryModalLabel">Edit Category</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="editCatID" name="catID" />
                        <div class="mb-3">
                            <label for="editCatName" class="form-label">Category Name</label>
                            <input type="text" class="form-control" id="editCatName" name="catName" required />
                        </div>
                        <div class="mb-3">
                            <label for="editCatDescription" class="form-label">Category Description</label>
                            <textarea class="form-control" id="editCatDescription" name="catDescription" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Category</button>
                    </div>
                </form>
            </div>
        </div>


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
                            message = '<i class="bi bi-check-circle-fill me-2"></i>Category added successfully!';
                            alertClass = "alert-success";
                            break;
                        case "false":
                            message = '<i class="bi bi-x-circle-fill me-2"></i>Failed to process category. Please try again.';
                            alertClass = "alert-danger";
                            break;
                        case "delete":
                            message = '<i class="bi bi-trash-fill me-2"></i>Category deleted successfully.';
                            alertClass = "alert-success";
                            break;
                        case "edit":
                            message = '<i class="bi bi-pencil-square me-2"></i>Category updated successfully.';
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

                    // Clean URL
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
                const id = button.getAttribute('data-id');
                const name = button.getAttribute('data-name');
                const description = button.getAttribute('data-description');

                document.getElementById("editCatID").value = id;
                document.getElementById("editCatName").value = name;
                document.getElementById("editCatDescription").value = description;

                const modal = new bootstrap.Modal(document.getElementById('editCategoryModal'));
                modal.show();
            }

            function confirmDelete(event) {
                const warningMessage = "Are you sure you want to delete this category?\n\n⚠ All dishes under this category will also be permanently deleted.";
                const confirmed = confirm(warningMessage);

                if (!confirmed) {
                    event.preventDefault();
                    return false;
                }
                return true;
            }

            // Search filter for categories
            const categorySearchInput = document.getElementById("categorySearch");

            function removeVietnameseTones(str) {
                return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/đ/g, "d").replace(/Đ/g, "D");
            }

            categorySearchInput.addEventListener("input", function () {
                const searchKeyword = removeVietnameseTones(this.value.trim().toLowerCase());

                const rows = document.querySelectorAll("table tbody tr");

                rows.forEach(row => {
                    const categoryName = row.cells[1].textContent.trim().toLowerCase(); // 2nd cell = Category Name
                    const normalizedCategoryName = removeVietnameseTones(categoryName);

                    const matchesSearch = normalizedCategoryName.includes(searchKeyword);

                    row.style.display = matchesSearch ? "" : "none";
                });
            });
        </script>
    </body>
</html>