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

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', sans-serif;
                background-color: white;
                display: flex;
                min-height: 100vh;
            }

            .sidebar {
                width: 250px;
                height: 100vh;
                background-color: #EF5D10;
                color: #fff;
                display: flex;
                flex-direction: column;
                position: fixed;
                left: 0;
                top: 0;
                box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease-in-out;
                z-index: 1000;
            }

            .sidebar .brand {
                padding: 30px;
                text-align: center;
            }

            .sidebar .close-btn {
                position: absolute;
                right: 15px;
                top: 15px;
                color: #fff;
                cursor: pointer;
                display: none;
            }

            .sidebar .nav-link {
                color: #fff;
                padding: 15px 20px;
                font-size: 1rem;
                display: flex;
                align-items: center;
                transition: background 0.3s;
                text-decoration: none;
            }

            .sidebar .nav-link i {
                margin-right: 12px;
                font-size: 1.2rem;
            }

            .sidebar .nav-link:hover,
            .sidebar .nav-link.active {
                background-color: #d94f0f;
                text-decoration: none;
            }

            .main {
                margin-left: 250px;
                width: calc(100% - 250px);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                transition: margin-left 0.3s ease-in-out;
            }


            .topbar {
                height: 60px;
                background-color: #fff;
                display: flex;
                justify-content: flex-end;
                align-items: center;
                padding: 0 30px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                z-index: 999;
            }

            .topbar .profile {
                display: flex;
                align-items: center;
                gap: 20px;
                visibility: visible;
                opacity: 1;
            }

            .topbar .profile i {
                font-size: 1.3rem;
                cursor: pointer;
                color: #2c3e50;
            }

            .topbar .username {
                font-weight: 400;
                color: #333;
            }

            .content {
                padding: 30px;
                background-color: white;
                flex-grow: 1;
            }

            .menu-toggle {
                display: none;
                font-size: 1.5rem;
                cursor: pointer;
                color: #333;
            }

            .icon-with-dot {
                position: relative;
                display: inline-block;
            }
            .icon-with-dot .dot {
                position: absolute;
                top: 0;
                right: -2px;
                width: 8px;
                height: 8px;
                background: #e74c3c;
                border-radius: 50%;
            }

            /* Notification Popup Styles */
            .notification-popup {
                position: absolute;
                top: 60px;
                right: 20px;
                width: 300px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                z-index: 1000;
                display: none;
                max-height: 400px;
                overflow-y: auto;
            }

            .notification-popup.active {
                display: block;
            }

            .notification-header {
                padding: 15px;
                border-bottom: 1px solid #e0e0e0;
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #f8f9fa;
                border-top-left-radius: 8px;
                border-top-right-radius: 8px;
            }

            .notification-header h5 {
                margin: 0;
                font-size: 1.1rem;
                color: #333;
            }

            .notification-header .close-notif {
                cursor: pointer;
                font-size: 1rem;
                color: #333;
            }

            .notification-list {
                padding: 0;
                margin: 0;
                list-style: none;
            }

            .notification-item {
                padding: 15px;
                border-bottom: 1px solid #e0e0e0;
                display: flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
                transition: background 0.2s;
            }

            .notification-item:hover {
                background-color: #f1f1f1;
            }

            .notification-item i {
                color: #EF5D10;
                font-size: 1.2rem;
            }

            .notification-item p {
                margin: 0;
                font-size: 0.9rem;
                color: #333;
            }

            .notification-item .time {
                font-size: 0.8rem;
                color: #777;
            }

            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }

                .sidebar.active {
                    transform: translateX(0);
                }

                .sidebar .close-btn {
                    display: block;
                }

                .main {
                    margin-left: 0;
                }

                .main.sidebar-active {
                    margin-left: 250px;
                }

                .menu-toggle {
                    display: block;
                }

                .topbar {
                    position: fixed;
                    justify-content: space-between;
                    top: 0;
                    width: 100%;
                    left: 0;
                }

                .content {
                    padding-top: 90px;
                }

                .topbar .profile {
                    display: flex;
                    visibility: visible;
                    opacity: 1;
                }

                .notification-popup {
                    right: 10px;
                    width: 90%;
                    max-width: 300px;
                }
            }

            @media (max-width: 576px) {
                .sidebar {
                    width: 200px;
                }

                .main.sidebar-active {
                    margin-left: 200px;
                }
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <div class="sidebar d-flex flex-column justify-content-between" id="sidebar">
            <div>
                <div class="brand">
                    <i class="bi bi-x-lg close-btn" id="closeSidebar"></i>
                </div>
                <a class="nav-link active" href=""><i class="bi bi-card-list"></i> Manage Categories</a>
                <a class="nav-link" href="manage_order"><i class="bi bi-receipt-cutoff"></i> Manage Order</a>
                <a class="nav-link" href="view_revenue"><i class="bi bi-bar-chart-line"></i> View Revenue</a>
                <a class="nav-link" href="customer_feedback"><i class="bi bi-chat-dots"></i> Customer Feedback</a>
                <a class="nav-link" href="manage_promotion"><i class="bi bi-tags"></i> Manage Promotion</a>
                <a class="nav-link" href="profile"><i class="bi bi-person-circle"></i> Profile</a>
                <a class="nav-link" href="/OishipFoodOrdering/logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
            </div>

            <!-- Logo at bottom -->
            <div class="text-center p-3">
                <img src="../images/logo_2.png" alt="Oiship Logo" style="max-width: 120px; height: auto;">
                <p style="font-weight: 500" class="">Admin</p>
            </div>
        </div>

        <!-- Main Section -->
        <div class="main" id="main">
            <!-- Topbar -->
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile">
                    <span class="username">Hi, Toan La</span>
                    <span class="icon-with-dot">
                        <i class="bi bi-bell-fill" id="notificationIcon"></i>
                        <span class="dot"></span>
                    </span>
                </div>
            </div>

            <!-- Notification Popup -->
            <div class="notification-popup" id="notificationPopup">
                <div class="notification-header">
                    <h5>Notifications</h5>
                    <i class="bi bi-x-lg close-notif" id="closeNotification"></i>
                </div>
                <ul class="notification-list">
                    <li class="notification-item">
                        <i class="bi bi-receipt-cutoff"></i>
                        <div>
                            <p>New order #1234 received!</p>
                            <span class="time">10 minutes ago</span>
                        </div>
                    </li>
                    <li class="notification-item">
                        <i class="bi bi-star-fill"></i>
                        <div>
                            <p>New customer feedback received.</p>
                            <span class="time">1 hour ago</span>
                        </div>
                    </li>
                    <li class="notification-item">
                        <i class="bi bi-tags"></i>
                        <div>
                            <p>Promotion "Summer Deal" expired.</p>
                            <span class="time">2 hours ago</span>
                        </div>
                    </li>
                </ul>
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

        <script>
            const sidebar = document.getElementById('sidebar');
            const main = document.getElementById('main');
            const menuToggle = document.getElementById('menuToggle');
            const closeSidebar = document.getElementById('closeSidebar');
            const notificationIcon = document.getElementById('notificationIcon');
            const notificationPopup = document.getElementById('notificationPopup');
            const closeNotification = document.getElementById('closeNotification');

            function toggleSidebar() {
                sidebar.classList.toggle('active');
                main.classList.toggle('sidebar-active');
            }

            function closeSidebarFunc() {
                sidebar.classList.remove('active');
                main.classList.remove('sidebar-active');
            }

            function toggleNotification() {
                notificationPopup.classList.toggle('active');
            }

            function closeNotificationFunc() {
                notificationPopup.classList.remove('active');
            }

            menuToggle.addEventListener('click', toggleSidebar);
            closeSidebar.addEventListener('click', closeSidebarFunc);
            notificationIcon.addEventListener('click', (e) => {
                e.stopPropagation();
                toggleNotification();
            });
            closeNotification.addEventListener('click', closeNotificationFunc);

            document.addEventListener('click', function (event) {
                if (window.innerWidth <= 768 && sidebar.classList.contains('active')) {
                    if (!sidebar.contains(event.target) && !menuToggle.contains(event.target)) {
                        closeSidebarFunc();
                    }
                }
                if (!notificationPopup.contains(event.target) && !notificationIcon.contains(event.target)) {
                    closeNotificationFunc();
                }
            });
        </script>
    </body>
</html>