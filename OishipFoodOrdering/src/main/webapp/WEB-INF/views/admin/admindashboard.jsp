<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Manage Categories</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="css/bootstrap.css"/>
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <!-- Bootstrap JS Bundle -->
        <script src="js/bootstrap.bundle.js"></script>

        <style>
            /* Sidebar Styling */

            .sidebar ul {
                list-style: none; /* Bỏ dấu chấm mặc định */
                padding-left: 0;   /* Xóa thụt lề mặc định */
                margin: 0;
            }

            .sidebar {
                position: fixed;
                top: 0;
                bottom: 0;
                left: 0;
                width: 250px;
                background-color: #f28500;
                color: #fff;
                padding: 20px 0;
                height: 100vh;
                overflow-y: auto;
            }

            .sidebar .nav-link {
                color: #fff;
                padding: 12px 20px;
                font-size: 16px;
                display: flex;
                align-items: center;
                text-decoration: none; /* Bỏ gạch chân */
            }


            .sidebar .nav-link:hover {
                background-color: #e07a00;
                color: #fff;
            }

            .sidebar .nav-link i {
                margin-right: 10px;
            }

            .sidebar-footer {
                padding-top: 20px;
                border-top: 1px solid #fff;
                position: absolute;
                bottom: 20px;
                width: 100%;
                text-align: center;
            }

            /* Main content styling */
            .main-content {
                margin-left: 250px;
                padding: 30px;
                background-color: #f8f9fa;
                min-height: 100vh;
            }

            .category-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px;
                border-bottom: 1px solid #dee2e6;
                background-color: #fff;
                border-radius: 4px;
                margin-bottom: 10px;
            }

            .category-item button {
                margin-left: 10px;
                padding: 4px 12px;
                font-size: 14px;
            }

            .welcome-text {
                font-size: 14px;
                color: #6c757d;
            }
        </style>
    </head>
    <body>

        <!-- Container -->
        <div class="container-fluid">
            <div class="row">

                <!-- Sidebar -->
                <nav class="col-md-2 sidebar p-0">                  
                    <!-- Include sidebar -->
                    <%@ include file="admin_sidebar.jsp" %>
                </nav>

                <!-- Main Content -->
                <main class="col-md-10 main-content">
                    <h2 class="mb-3">Manage Categories</h2>
                    <p class="welcome-text mb-4">Manage your restaurant's menu and menu items.</p>

                    <!-- Add new category -->
                    <div class="mb-4">
                        <h5>New Category Name</h5>
                        <div class="input-group mb-3" style="max-width: 400px;">
                            <input type="text" class="form-control" placeholder="e.g. Fast food">
                            <button class="btn btn-success btn-sm">Add Category</button>
                        </div>
                    </div>

                    <!-- Existing categories -->
                    <div>
                        <h5>Existing Categories</h5>
                        <div class="category-list">
                            <c:forEach var="category" items="${categories}">
                                <div class="category-item">
                                    <span>${category.catName}</span>
                                    <div>
                                        <button class="btn btn-primary btn-sm">Edit</button>
                                        <button class="btn btn-danger btn-sm">Delete</button>
                                    </div>
                                </div>
                            </c:forEach>

                            <!-- Dummy data for testing layout -->
                            <div class="category-item">
                                <span>Fast food</span>
                                <div>
                                    <button class="btn btn-primary btn-sm">Edit</button>
                                    <button class="btn btn-danger btn-sm">Delete</button>
                                </div>
                            </div>
                            <div class="category-item">
                                <span>Beverages</span>
                                <div>
                                    <button class="btn btn-primary btn-sm">Edit</button>
                                    <button class="btn btn-danger btn-sm">Delete</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

    </body>
</html>
