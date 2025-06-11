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
                <form action="manage_menu" method="post" class="row g-3 mt-4">
                    <div class="col-md-6">
                        <label for="categoryName" class="form-label">New Category Name</label>
                        <input type="text" class="form-control" id="categoryName" name="categoryName" required placeholder="e.g. Fast food">
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-success">Add Category</button>
                    </div>
                </form>

                <!-- Category List -->
                <div class="mt-5">
                    <h4>Existing Categories</h4>
                    <ul class="list-group mt-3">
                        <div class="list-group-item list-group-item-action d-flex justify-content-between align-items-center"
                             onclick="window.location.href = 'view_category?id=1'" style="cursor: pointer;">
                            <span>Fast food</span>
                            <div>
                                <a href="edit_category?id=1" class="btn btn-sm btn-primary me-2" onclick="event.stopPropagation();">Edit</a>
                                <a href="delete_category?id=1" class="btn btn-sm btn-danger" onclick="event.stopPropagation();">Delete</a>
                            </div>
                        </div>
                        <div class="list-group-item list-group-item-action d-flex justify-content-between align-items-center"
                             onclick="window.location.href = 'view_category?id=1'" style="cursor: pointer;">
                            <span>Fast food</span>
                            <div>
                                <a href="edit_category?id=1" class="btn btn-sm btn-primary me-2" onclick="event.stopPropagation();">Edit</a>
                                <a href="delete_category?id=1" class="btn btn-sm btn-danger" onclick="event.stopPropagation();">Delete</a>
                            </div>
                        </div>
                        <div class="list-group-item list-group-item-action d-flex justify-content-between align-items-center"
                             onclick="window.location.href = 'view_category?id=1'" style="cursor: pointer;">
                            <span>Fast food</span>
                            <div>
                                <a href="edit_category?id=1" class="btn btn-sm btn-primary me-2" onclick="event.stopPropagation();">Edit</a>
                                <a href="delete_category?id=1" class="btn btn-sm btn-danger" onclick="event.stopPropagation();">Delete</a>
                            </div>
                        </div>
                    </ul>
                </div>
            </div>
        </div>
    </body>
</html>