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

                <!-- Add Category Form -->
                <form action="manage-categories" method="post" class="row g-3 mt-4">
                    <!-- Category Name -->
                    <div class="col-md-6">
                        <label for="catName" class="form-label">New Category Name</label>
                        <input type="text" class="form-control" id="catName" name="catName" required placeholder="Enter category name">
                    </div>

                    <!-- Category Description -->
                    <div class="col-12">
                        <label for="catDescription" class="form-label">New Category Description</label>
                        <textarea class="form-control" id="catDescription" name="catDescription" rows="3" required placeholder="Describe the category"></textarea>
                    </div>

                    <!-- Submit Button -->
                    <div class="col-12">
                        <button type="submit" class="btn btn-success">Add Category</button>
                    </div>
                </form>

                <!-- Category List -->
                <div class="mt-5">
                    <h4>Existing Categories</h4>
                    <ul class="list-group mt-3 list-group-flush">
                        <% List<model.Category> categories = (List<model.Category>) request.getAttribute("categories"); %>
                        <% int index = 1;%>
                        <c:forEach var="cat" items="${categories}">
                            <div class="list-group-item list-group-item-action d-flex align-items-center" style="cursor: pointer;" onclick="toggleDescription(this)">
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span style="font-weight: 400">
                                            <span class="me-1" style="font-weight: 400;"><%= index++%>.</span>
                                            ${cat.catName}
                                        </span>
                                        <div>
                                            <a href="#" class="btn btn-sm btn-primary me-2" data-id="${cat.catID}" data-name="${cat.catName}" data-description="${cat.catDescription}" onclick="handleEditClick(this); event.stopPropagation();">Edit</a>
                                            <a href="manage-categories?action=delete&id=${cat.catID}" class="btn btn-sm btn-danger" onclick="return confirmDelete(event);">Delete</a>
                                        </div>
                                    </div>
                                    <div class="cat-description text-muted" style="display: none; margin-top: -5px; margin-left: 20px">
                                        Description: ${cat.catDescription}
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </ul>
                </div>
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
//            const params = new URLSearchParams(window.location.search);
//            const success = params.get("success");
//
//            if (success === "false") {
//                alert("Failed to add category. Please try again.");
//            } else if (success === "true") {
//                alert("Success to add category.");
//            }

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
                const confirmed = confirm("Are you sure you want to delete this category?");
                if (!confirmed) {
                    event.preventDefault(); // Stop the link if user cancels
                    return false;
                }
                return true; // Allow link to proceed if confirmed
            }
        </script>
    </body>
</html>