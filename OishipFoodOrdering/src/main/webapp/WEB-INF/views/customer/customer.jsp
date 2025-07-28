<%@page import="java.util.Map"%>
<%@page import="model.Review"%>
<%@page import="model.Cart"%>
<%@page import="java.util.List"%>
<%@page import="model.Category"%>
<%@page import="model.Dish"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Trang Chủ - Oiship</title>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://api.mapbox.com/mapbox-gl-js/v2.16.1/mapbox-gl.css" rel="stylesheet" />
        <!-- Bootstrap JS (modal cần cái này) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <style>
            .modal-backdrop.show {
                opacity: 0.1 !important; /* mặc định là 0.5 */
            }

            body {
                font-family: 'Arial', sans-serif;
                background-color: #f8f9fa;
            }

            .menu-btn {
                border-radius: 30px;
                margin-right: 8px;
                padding: 10px 25px;
                font-weight: 600;
                transition: all 0.3s ease;
            }
            .menu-btn:hover,
            .menu-btn.active {
                background-color: #ff6200 !important;
                color: #fff !important;
                box-shadow: 0 4px 15px rgba(255, 98, 0, 0.5);
            }

            .sidebar {
                width: 250px;
                background-color: #ffffff;
                height: 100vh;
                position: fixed;
                padding-top: 20px;
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            }

            .sidebar a {
                display: block;
                padding: 10px 15px;
                color: #000;
                text-decoration: none;
            }

            .sidebar a:hover,
            .sidebar .active {
                background-color: #ff6200;
                color: #fff !important;
            }

            .main-content {
                margin-left: 250px;
                padding: 20px;

            }

            .hero-section {
                width: 100%;
                height: 400px;
                margin: 0;
                padding: 0;
                border-radius: 10px;
                overflow: hidden;
                margin-bottom: 2rem;
            }

            .carousel-inner img {
                width: 100%;
                height: 400px;
                object-fit: cover;
                border-radius: 10px;
                display: block;
            }



            .btn-custom {
                background-color: #ff6200;
                color: #fff;
                border: none;
                padding: 10px 20px;
                transition: background-color 0.3s ease;
            }

            .btn-custom:hover {
                background-color: #e65c00;
            }

            .menu-section,
            .dish-section,
            .contact-section {
                background-color: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
            }

            .dish-card {
                border: 1px solid #ddd;
                border-radius: 10px;
                overflow: hidden;
                transition: transform 0.3s ease;
            }

            .dish-card:hover {
                transform: translateY(-5px);
            }

            .dish-card img {
                height: 200px;
                object-fit: cover;
                width: 100%;
            }

            .alert {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                min-width: 250px;
            }

            /* --- PHÂN TRANG --- */
            .pagination-container {
                display: flex;
                justify-content: center;
                gap: 8px;
                margin-top: 30px;
                flex-wrap: wrap;
                user-select: none;
            }

            .pagination-container button {
                background-color: transparent;
                border: none;
                color: #666;
                font-size: 1.25rem;
                padding: 10px 18px;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .pagination-container button:hover {
                background-color: #f0f0f0;
                font-weight: bold;
                transform: scale(1.05);
            }

            .pagination-container button.active {
                background-color: #d6692a;
                color: #fff;
                font-weight: bold;
                box-shadow: 0 0 8px rgba(214, 105, 42, 0.4);
            }

            .pagination-container button:disabled {
                color: #aaa;
                cursor: default;
                opacity: 0.5;
            }

            .pagination-dots {
                padding: 10px 18px;
                font-size: 1.2rem;
                color: #888;
            }

            /* --- CATEGORY STYLE --- */
            .menu-section .btn {
                border-radius: 20px;
                padding: 8px 20px;
                font-weight: 500;
                transition: all 0.2s ease;
                white-space: nowrap;
            }

            .menu-section .btn.active,
            .menu-section .btn:hover {
                background-color: #ff6200;
                color: #fff;
                box-shadow: 0 3px 8px rgba(255, 98, 0, 0.3);
            }

            .menu-section .d-flex::-webkit-scrollbar {
                display: none;
            }

            .menu-section .d-flex {
                -ms-overflow-style: none;
                scrollbar-width: none;
            }


            @media (max-width: 768px) {
                .sidebar {
                    width: 100%;
                    height: auto;
                    position: relative;
                }

                .main-content {
                    margin-left: 0;
                }

                .hero-section {
                    height: 300px;
                }

                .hero-section h1 {
                    font-size: 1.8rem;
                }

            }
            .user-account {
                display: flex;
                align-items: center;
                gap: 8px; /* ✅ tạo khoảng cách giữa icon và dòng chữ */
                color: #333;
            }

            .user-account i {
                font-size: 1.2rem;
                color: #ff6200;
            }

            .welcome-text {
                white-space: nowrap;
                font-weight: 500;
                color: #333;
            }
            /* Container chung của dropdown */
            .dropdown .dropdown-toggle {
                color: #ff6200;
                font-weight: 500;
                padding: 8px 12px;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            /* Hover lên nút dropdown */
            .dropdown .dropdown-toggle:hover {
                background-color: #fff0e5;
                color: #e65c00;
                box-shadow: 0 2px 8px rgba(255, 98, 0, 0.3);
            }

            /* Icon hình người */
            .user-account i {
                color: #ff6200;
                font-size: 1.2rem;
            }

            /* Dòng Welcome */
            .welcome-text {
                font-weight: 500;
                color: #333;
                white-space: nowrap;
            }

            /* Giao diện menu xổ xuống */
            .dropdown-menu {
                border-radius: 10px;
                border: none;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                padding: 8px 0;
            }

            /* Mỗi item trong dropdown */
            .dropdown-menu .dropdown-item {
                padding: 10px 20px;
                color: #333;
                transition: all 0.2s ease;
            }

            /* Hover item */
            .dropdown-menu .dropdown-item:hover {
                background-color: #ffe6d5;
                color: #ff6200;
                font-weight: 500;
            }

        </style>

        <style>
            .cart-success-alert {
                position: fixed;
                top: 0;
                left: 50%;
                transform: translate(-50%, -100%);
                z-index: 1000;
                width: 500px; /* Increased width for better balance */
                min-height: 100px; /* Elongated height */
                padding: 15px; /* Increased padding for elegance */
                opacity: 0;
                transition: transform 0.3s ease-in-out, opacity 0.3s ease-in-out;
                /* Removed border-radius and box-shadow */
            }
            .cart-success-alert.show {
                transform: translate(-50%, 20px); /* Slight offset from top for balance */
                opacity: 1;
            }
            .cart-success-alert .alert {
                display: flex;
                justify-content: space-between;
                align-items: center;
                width: 100%;
                height: 100%; /* Fill the container */
                background-color: #d4edda; /* Light green for success */
                border-color: #c3e6cb; /* Matching border */
            }
            .cart-success-alert img {
                width: 60px;
                height: 60px;
                object-fit: cover;
                margin-right: 15px;
            }
            .cart-success-alert .details {
                display: flex;
                flex-grow: 1;
                align-items: center;
                gap: 15px;
                color: #155724; /* Darker text for contrast */
            }
            .notifications {
                position: fixed;
                top: 10px;
                right: 10px;
                z-index: 1000;
            }
            .notification-link {
                display: none;
            }
            .sidebar .position-relative {
                /*display: inline-block;*/
                /*margin-bottom: 10px;*/
            }
            .cart-link {
                position: relative;
                display: inline-block;
            }

            .cart-badge {
                position: absolute;
                top: -3px;
                left: 20px;
                background-color: #c0392b;
                color: white;
                font-size: 12px;
                padding: 2px 6px;
                border-radius: 50%;
                font-weight: bold;
                line-height: 1;
                min-width: 20px;
                text-align: center;
                box-shadow: 0 0 0 2px white;
            }

        </style>
        <style>
            .btn-page {
                border: 1px solid #ccc;
                padding: 5px 12px;
                border-radius: 5px;
                background-color: white;
                color: #333;
                transition: 0.2s;
            }

            .btn-page:hover {
                background-color: #eee;
            }

            .btn-page.active {
                background-color: #fff5e6;
                color: white;
                border-color: #fff5e6;
            }
        </style>

    </style>
</head>
<body>
    <div class="sidebar">
        <div class="text-center mb-4">
            <img src="images/logo_1.png" alt="Oiship Logo" class="img-fluid" />
            <h5 class="mt-2 text-orange">OISHIP</h5>
        </div>

        <a href="customer/view-vouchers-list">
            <i class="fas fa-tags me-2"></i> Vouchers
        </a>

        <%
            List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
            int totalDishes = (cartItems != null) ? cartItems.size() : 0;
        %>

        <!-- Cart with badge -->
        <a href="${pageContext.request.contextPath}/customer/view-cart" class="cart-link text-decoration-none position-relative me-2">
            <i class="fas fa-shopping-cart me-2"></i> Cart
            <% if (totalDishes > 0) {%>
            <span class="cart-badge">
                <%= (totalDishes > 7) ? "5+" : totalDishes%>
            </span>
            <% }%>
        </a>
        <a href="customer/order">
            <i class="fas fa-list me-2"></i> Order
        </a>

        <a href="customer/contact">
            <i class="fas fa-phone me-2"></i> Contact
        </a>

    </div>

    <div class="main-content">
        <nav class="navbar navbar-light bg-light p-2 mb-3">
            <form id="dishSearchForm" class="d-flex search-bar" role="search">
                <input class="form-control me-2" type="text" id="searchQuery" placeholder="Search for dishes..." />
                <button class="btn btn-outline-success" type="submit">Find</button>
            </form>


            <div class="d-flex align-items-center">
                <div class="dropdown me-3">
                    <a class="text-decoration-none position-relative dropdown-toggle" href="#" role="button"
                       id="notificationDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-bell fa-lg"></i>
                        <span class="badge rounded-pill bg-danger position-absolute top-0 start-100 translate-middle">
                            <%= ((List<?>) request.getAttribute("notifications")) != null ? ((List<?>) request.getAttribute("notifications")).size() : 0%>
                        </span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end p-2" aria-labelledby="notificationDropdown" style="min-width: 300px; max-height: 400px; overflow-y: auto;">
                        <%
                            List<?> notifications = (List<?>) request.getAttribute("notifications");
                            if (notifications != null && !notifications.isEmpty()) {
                                for (Object obj : notifications) {
                                    model.Notification n = (model.Notification) obj;
                        %>
                        <li class="mb-1">
                            <a href="#" 
                               class="dropdown-item text-wrap text-decoration-none" 
                               data-bs-toggle="modal" 
                               data-bs-target="#notificationModal"
                               data-title="<%= n.getNotTitle()%>"  
                               data-description="<%= n.getNotDescription()%>" 
                               data-id="<%= n.getNotID()%>">
                                <strong><%= n.getNotTitle()%></strong>
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>

                        <%
                            }
                        } else {
                        %>
                        <li><span class="dropdown-item-text text-muted">No new notifications.</span></li>
                            <%
                                }
                            %>
                    </ul>
                    <!-- Modal Thông Báo -->
                    <div class="modal fade" id="notificationModal" tabindex="-1" aria-labelledby="notificationModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content rounded-4 shadow border-0">
                                <div class="modal-header" style="background-color: #ff6f00; color: white;">
                                    <h5 class="modal-title fw-bold" id="modalTitle"></h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>

                                <form action="${pageContext.request.contextPath}/customer/mark-read" method="post">
                                    <input type="hidden" name="notID" id="hiddenNotID" />
                                    <div class="modal-body">
                                        <p id="modalDescription" style="font-size: 1rem;"></p>
                                        <!-- Input ẩn để gửi notID -->

                                    </div>

                                    <div class="modal-footer bg-light">
                                        <button type="submit" class="btn" style="background-color: #ff6f00; color: white; font-weight: 500;">
                                            Đã đọc
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="dropdown">
                    <a class="dropdown-toggle text-decoration-none user-account" href="#" role="button"
                       id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user"></i>
                        <div class="welcome-text">
                            Welcome, <span><c:out value="${userName}" default="Guest" /></span>!
                        </div>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="customer/profile">Profile</a></li>
                        <li><a class="dropdown-item" href="logout">Log out</a></li>
                        <li><hr class="dropdown-divider"></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!--        <div class="hero-section">
                    <div id="carouselHero" class="carousel slide w-100" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img src="images/panner7.jpg" class="d-block w-100" alt="Slide 1" />
                            </div>
                            <div class="carousel-item">
                                <img src="images/panner8.jpg" class="d-block w-100" alt="Slide 2" />
                            </div>
                            <div class="carousel-item">
                                <img src="images/panner9.jpg" class="d-block w-100" alt="Slide 3" />
                            </div>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#carouselHero" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon"></span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#carouselHero" data-bs-slide="next">
                            <span class="carousel-control-next-icon"></span>
                        </button>
                    </div>
                </div>-->



        <!-- Menu Section -->
        <div id="menu" class="menu-section">
            <h2 class="mb-4">MENU</h2>
            <div class="d-flex flex-wrap gap-2 overflow-auto pb-2" style="scrollbar-width: none;">
                <button class="btn btn-outline-primary menu-btn active" onclick="loadDishesByCategory('all')">All</button>

                <%
                    List<Category> categories = (List<Category>) request.getAttribute("categories");
                    if (categories != null) {
                        for (model.Category cat : categories) {
                %>
                <button class="btn btn-outline-primary menu-btn"
                        onclick="loadDishesByCategory(<%= cat.getCatID()%>)">
                    <%= cat.getCatName()%>
                </button>
                <%
                        }
                    }
                %>
            </div>
        </div>
        <div id="dish-container">
            <jsp:include page="dish_category.jsp" />
        </div>

        <!-- Pagination Controls -->
        <div class="pagination-container">
            <button id="prevPageBtn" class="page-btn rounded">&laquo;</button>
            <div id="pageNumbers" class="d-flex gap-2"></div>
            <button id="nextPageBtn" class="page-btn rounded">&raquo;</button>
        </div>



        <!-- Top Cart Success Alert with Animation -->
        <%
            Map<String, Object> cartSuccessDetails = (Map<String, Object>) session.getAttribute("cartSuccessDetails");
            if (cartSuccessDetails != null) {
                session.removeAttribute("cartSuccessDetails"); // Clear session to avoid repeated display
        %>
        <div class="cart-success-alert" id="cartSuccessAlert">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <img src="<%= cartSuccessDetails.get("image")%>" alt="Dish Image" class="img-fluid">
                <div class="details">
                    <span><strong><%= cartSuccessDetails.get("name")%></strong></span>
                    <span>Quantity: <%= cartSuccessDetails.get("quantity")%></span>
                    <br>
                    <span>has been added to cart!</span>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <%
            }
        %>


        <div id="map" style="height: 400px; width: 100%;"></div>

        <!-- Mapbox JS -->
        <script src="https://api.mapbox.com/mapbox-gl-js/v2.15.0/mapbox-gl.js"></script>
        <script>
                            mapboxgl.accessToken = 'pk.eyJ1Ijoic3RhZmYxIiwiYSI6ImNtYWZndDRjNzAybGUybG44ZWYzdTlsNWQifQ.jSJjwMo8_OQszYjWAAi7iQ';

                            const storeCoordinates = [105.73243159506195, 10.012620837028985]; // [lng, lat]

                            const map = new mapboxgl.Map({
                                container: 'map',
                                style: 'mapbox://styles/mapbox/streets-v11',
                                center: storeCoordinates,
                                zoom: 15
                            });

                            map.on('load', () => {
                                new mapboxgl.Marker()
                                        .setLngLat(storeLocation)
                                        .setPopup(new mapboxgl.Popup().setText('Oiship Store'))
                                        .addTo(map);

                                // Buộc map render lại sau 500ms
                                setTimeout(() => {
                                    map.resize();
                                    map.setCenter(storeLocation); // đảm bảo giữ đúng vị trí
                                }, 500);
                            });

        </script>

</body>

<script>
    // Animate and auto-disappear cart success alert
    document.addEventListener('DOMContentLoaded', function () {
        const alert = document.getElementById('cartSuccessAlert');
        if (alert) {
            // Add show class for animation
            setTimeout(() => alert.classList.add('show'), 10); // Slight delay to trigger transition

            // Auto-disappear after 3 seconds
            setTimeout(() => {
                alert.classList.remove('show');
                setTimeout(() => alert.remove(), 300); // Remove after fade-out
            }, 3000);
        }
    });
</script>
<script>
    function validateQty(input) {
        let qty = parseInt(input.value) || 1;

        let stock = parseInt(input.getAttribute("data-stock"));

        if (qty > 50) {
            alert("The maximum quantity is 50.");
            qty = 50;
        }

        if (qty > stock) {
            alert("Only " + stock + " items in stock.");
            qty = stock;
        }

        if (qty < 1) {
            alert("Quantity must be at least 1.");
            qty = 1;
        }

        input.value = qty;
        const total = qty * price;
        document.getElementById("dishTotalPrice").textContent = total.toLocaleString() + " đ";
    }

    function validateBeforeSubmit() {
        const input = document.getElementById("quantityInput");
        const stock = parseInt(input.getAttribute("data-stock"));

        let qty = parseInt(input.value);

        if (isNaN(qty) || qty < 1) {
            alert("Quantity must be at least 1.");
            input.value = 1;
            return false;
        }

        if (qty > 50) {
            alert("The maximum quantity is 50.");
            input.value = 10;
            return false;
        }

        if (qty > stock) {
            alert("Only " + stock + " items in stock.");
            input.value = stock;
            return false;
        }

        const total = qty * price;
        document.getElementById("dishTotalPrice").textContent = total.toLocaleString() + " đ";
        return true;
    }
</script>

</div>



<!-- 💡 Modal Dish Detail -->
<div class="modal fade" id="dishDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content" id="dishDetailContent">
            <!-- AJAX content goes here -->
        </div>
    </div>
</div>

<script>
    function openDishDetail(dishId) {
        fetch('<%=request.getContextPath()%>/customer/dish-detail', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'dishId=' + dishId
        })
                .then(response => response.text())
                .then(html => {
                    const content = document.getElementById('dishDetailContent');
                    content.innerHTML = html;

                    const modalEl = document.getElementById('dishDetailModal');
                    const dishModal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                    dishModal.show();
                })
                .catch(error => {
                    alert("Failed to load dish detail. Please try again.");
                    console.error('Error loading dish detail:', error);
                });
    }

    document.getElementById('dishDetailModal').addEventListener('hidden.bs.modal', function () {
        document.getElementById('dishDetailContent').innerHTML = '';
    });
</script>



<script>
    function loadDishesByCategory(catId) {
        document.querySelectorAll('.menu-btn').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');

        fetch('<%= request.getContextPath()%>/customer/dish-detail', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'catId=' + catId
        })
                .then(response => response.text())
                .then(html => {
                    document.getElementById('dish-container').innerHTML = html;

                   
                    setupPagination();
                })
                .catch(error => {
                    console.error('Error loading dishes:', error);
                });
    }


</script>      





<script>
    document.addEventListener("DOMContentLoaded", () => {
        const form = document.getElementById("dishSearchForm");
        const input = document.getElementById("searchQuery");
        const dishContainer = document.getElementById("dish-container");

        form.addEventListener("submit", function (event) {
            event.preventDefault();

            const query = input.value.trim();

            fetch("<%=request.getContextPath()%>/customer/search-dish", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: new URLSearchParams({
                    searchQuery: query
                })
            })
                    .then(response => response.text())
                    .then(data => {
                        dishContainer.innerHTML = data;
                    })
                    .catch(error => {
                        console.error("Search error:", error);
                    });
        });
    });
</script>

<script>
    function setupPagination() {
        const itemsPerPage = 15;
        const dishes = Array.from(document.querySelectorAll(".dish-item"));
        const totalPages = Math.ceil(dishes.length / itemsPerPage);
        let currentPage = 1;

        const prevBtn = document.getElementById("prevPageBtn");
        const nextBtn = document.getElementById("nextPageBtn");
        const pageNumbers = document.getElementById("pageNumbers");

       
        function showPage(page) {
            dishes.forEach((item, index) => {
                item.style.display = "none";
            });

            const start = (page - 1) * itemsPerPage;
            const end = start + itemsPerPage;
            dishes.slice(start, end).forEach(item => {
                item.style.display = "block";
            });

           
            document.querySelectorAll("#pageNumbers button").forEach(btn => {
                btn.classList.remove("btn-primary");
                btn.classList.add("btn-outline-primary");
            });

            const activeBtn = document.getElementById(`pageBtn${page}`);
            if (activeBtn) {
                activeBtn.classList.add("btn-primary");
                activeBtn.classList.remove("btn-outline-primary");
            }

            prevBtn.disabled = (page === 1);
            nextBtn.disabled = (page === totalPages);
        }

       
        function createPagination() {
            pageNumbers.innerHTML = "";

            const maxVisible = 5;
            let startPage = Math.max(currentPage - 2, 1);
            let endPage = Math.min(startPage + maxVisible - 1, totalPages);

            if (endPage - startPage < maxVisible - 1) {
                startPage = Math.max(endPage - maxVisible + 1, 1);
            }

            if (startPage > 1) {
                appendPageButton(1);
                if (startPage > 2) {
                    pageNumbers.appendChild(createDots());
                }
            }

            for (let i = startPage; i <= endPage; i++) {
                appendPageButton(i);
            }

            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    pageNumbers.appendChild(createDots());
                }
                appendPageButton(totalPages);
            }
        }

        function appendPageButton(i) {
            const btn = document.createElement("button");
            btn.id = `pageBtn${i}`;
            btn.textContent = i;
            btn.className = "btn-page" + (i === currentPage ? " active" : "");
            btn.addEventListener("click", () => {
                currentPage = i;
                showPage(currentPage);
                createPagination();
            });
            pageNumbers.appendChild(btn);
        }


       
        function createDots() {
            const span = document.createElement("span");
            span.textContent = "...";
            span.className = "pagination-dots";
            return span;
        }

       
        prevBtn.onclick = () => {
            if (currentPage > 1) {
                currentPage--;
                showPage(currentPage);
                createPagination();
            }
        };

        nextBtn.onclick = () => {
            if (currentPage < totalPages) {
                currentPage++;
                showPage(currentPage);
                createPagination();
            }
        };

      
        createPagination();
        showPage(currentPage);
    }

   
    document.addEventListener('DOMContentLoaded', () => {
        setupPagination();
    });
</script>


<script>
    const contextPath = '<%= request.getContextPath()%>';

    const notificationModal = document.getElementById('notificationModal');
    if (notificationModal) {
        notificationModal.addEventListener('show.bs.modal', function (event) {
            const link = event.relatedTarget;
            if (!link)
                return;

            const title = link.getAttribute('data-title');
            const desc = link.getAttribute('data-description');
            const id = link.getAttribute('data-id');

            document.getElementById('modalTitle').textContent = title;
            document.getElementById('modalDescription').textContent = desc;


        });
    }
</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const notificationModal = document.getElementById("notificationModal");
        const modalTitle = document.getElementById("modalTitle");
        const modalDescription = document.getElementById("modalDescription");
        const hiddenNotID = document.getElementById("hiddenNotID");
        notificationModal.addEventListener('show.bs.modal', function (event) {
            const triggerElement = event.relatedTarget;

            const title = triggerElement.getAttribute("data-title");
            const description = triggerElement.getAttribute("data-description");
            const notID = triggerElement.getAttribute("data-id");

            modalTitle.textContent = title;
            modalDescription.textContent = description;
            hiddenNotID.value = notID;
        });
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://api.mapbox.com/mapbox-gl-js/v2.16.1/mapbox-gl.js"></script>
</body>
</html>