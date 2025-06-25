<!<!--customer.jsp>
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

        <!-- Bootstrap JS (modal cần cái này) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <style>
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

            .menu-btn:hover, .menu-btn.active {
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

            .sidebar a:hover, .sidebar .active {
                background-color: #ff6200;
                color: #fff !important;
            }

            .main-content {
                margin-left: 250px;
                padding: 20px;
            }

            .search-bar {
                margin-bottom: 20px;
            }

            .hero-section {
                position: relative;
                background: url('https://via.placeholder.com/800x400') no-repeat center center;
                background-size: cover;
                height: 400px;
                color: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                text-align: center;
                border-radius: 10px;
                overflow: hidden;
                margin-bottom: 2rem;
            }

            .hero-section::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
            }

            .hero-section .content {
                position: relative;
                z-index: 1;
            }

            .hero-section h1 {
                font-size: 2.5rem;
                margin-bottom: 1rem;
            }

            .hero-section p {
                font-size: 1.2rem;
                margin-bottom: 1.5rem;
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

            .btn-outline-custom {
                border-color: #fff;
                color: #fff;
                padding: 10px 20px;
            }

            .btn-outline-custom:hover {
                background-color: #fff;
                color: #ff6200;
            }

            .notification-bell {
                position: relative;
            }

            .notification-bell .badge {
                position: absolute;
                top: -5px;
                right: -10px;
                background-color: #ff6200;
            }

            .user-account {
                display: flex;
                align-items: center;
                padding: 5px 10px;
                border-radius: 20px;
                transition: background 0.3s ease;
            }

            .user-account:hover {
                background-color: #f1f1f1;
            }

            .user-account i {
                font-size: 1.2rem;
                color: #ff6200;
                margin-right: 8px;
            }

            .welcome-text {
                font-weight: 500;
                color: #333;
            }

            .welcome-text span {
                color: #ff6200;
                font-weight: 600;
            }

            .dropdown-menu {
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }

            .dropdown-item:hover {
                background-color: #ff6200;
                color: #fff;
            }

            .menu-section, .dish-section, .contact-section {
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

            .contact-form .form-control {
                margin-bottom: 1rem;
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
                .dish-card img {
                    height: 150px;
                }
            }
            .alert {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                min-width: 250px;
            }

        </style>
        <%-- phân trang --%>
        <style>
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
                font-size: 1.25rem;      /* Tăng cỡ chữ */
                padding: 10px 18px;       /* Tăng khoảng cách trong nút */
                border-radius: 8px;       /* Bo tròn nút nhiều hơn */
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .pagination-container button:hover {
                background-color: #f0f0f0;
                font-weight: bold;
                transform: scale(1.05);   /* Phóng nhẹ khi hover */
            }

            .pagination-container button.active {
                background-color: #d6692a;  /* màu giống nút "Add Cart" */
                color: #fff;
                font-weight: bold;
                box-shadow: 0 0 8px rgba(214, 105, 42, 0.4); /* hiệu ứng bóng */
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

            .pagination-container button:hover {
                background-color: #f2dfd3; /* nhẹ hơn 1 chút để tương phản */
            }

            .pagination-container button.active {
                background-color: #d85c38;
                color: #fff;
            }

            .pagination-container button:disabled {
                color: #aaa;
                cursor: default;
            }

            .pagination-dots {
                padding: 6px 12px;
                color: #888;
            }

        </style>
        <%-- style category --%>
        <style>
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
        </style>
    </head>
    <body>
        <div class="sidebar">
            <div class="text-center mb-4">
                <img src="images/logo_1.png" alt="Oiship Logo" class="img-fluid" />
                <h5 class="mt-2 text-orange">OISHIP</h5>
            </div>
            <a href="customer/view-vouchers-list"><i class="fas fa-tags me-2"></i>Vouchers</a>
            <a href="customer/view-cart">
                <i class="fas fa-shopping-cart me-2"></i>
                Cart
                <span id="cart-count" class="badge bg-danger ms-1">0</span>
            </a>
            <a href="#"><i class="fas fa-list me-2"></i> Order</a>           
            <a href="#contact"><i class="fas fa-phone me-2"></i> Contact</a>

        </div>
        <%
            List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
            int cartCount = (cartItems != null) ? cartItems.size() : 0;
        %>

        <a href="add-cart"><i class="fas fa-shopping-cart me-2"></i> Cart (<%= cartCount%>)</a>

        <div class="main-content">
            <nav class="navbar navbar-light bg-light p-2 mb-3">
                <form id="dishSearchForm" class="d-flex search-bar" role="search">
                    <input class="form-control me-2" type="text" id="searchQuery" placeholder="Search for dishes..." />
                    <button class="btn btn-outline-success" type="submit">Find</button>
                </form>


                <div class="d-flex align-items-center">
                    <div class="notification-bell me-3">
                        <a href="${pageContext.request.contextPath}/customer/view-notification-list" class="text-decoration-none position-relative">
                            <i class="fas fa-bell fa-lg"></i>
                            <span class="badge rounded-pill bg-danger position-absolute top-0 start-100 translate-middle">
                                <%= ((List<?>) request.getAttribute("notifications")) != null ? ((List<?>) request.getAttribute("notifications")).size() : 0%>
                            </span>
                        </a>
                    </div>


                    <div class="dropdown">
                        <a class="dropdown-toggle text-decoration-none user-account" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user"></i>
                            <div class="welcome-text">
                                Welcome, <span><c:out value="${userName}" default="Guest" /></span>!
                            </div>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="customer/profile">Profile</a></li>
                            <li><a class="dropdown-item" href="logout">Log out</a></li>
                        </ul>
                    </div>
                </div>
            </nav>


            <div class="hero-section">
                <div class="content">
                    <h1>Delicious meals delivered in just 30 minutes!</h1>
                    <p>Discover hundreds of Vietnamese and international dishes with fast, reliable delivery service.</p>
                    <button class="btn btn-custom me-2">Order Now</button>
                    <button class="btn btn-outline-custom me-2">View Menu</button>
                    <button class="btn btn-outline-custom">Download App</button>
                </div>
            </div>

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

            <%
                String message = (String) session.getAttribute("message");
                if (message != null) {
            %>
            <div id="successMessage" class="alert alert-success alert-dismissible fade show" role="alert">
                <%= message%>
                <button type="button" class="btn-close" onclick="document.getElementById('successMessage').style.display = 'none';"></button>
            </div>
            <%
                    session.removeAttribute("message"); // Xoá sau khi hiển thị để không bị lặp
                }
            %>



            <!-- Location Map Section -->
            <div id="location" class="menu-section mt-4">
                <h2 class="mb-4">Location Map</h2>
                <div class="mb-3">
                    <label for="locationInput" class="form-label">Enter Location:</label>
                    <input type="text" class="form-control" id="locationInput" placeholder="Enter an address (e.g., Ho Chi Minh City, Vietnam)">
                    <button class="btn btn-custom mt-2" onclick="geocodeAddress()">Search Location</button>
                </div>
                <div id="map"></div>
            </div>

            <!-- ... (phần cuối file giữ nguyên) ... -->

            <!-- Thêm vào <head> -->
            <style>
                #map {
                    height: 400px;
                    width: 100%;
                    margin-top: 20px;
                    border-radius: 10px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }
            </style>
            <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap&libraries=places&v=weekly" async></script>

            <!-- Thêm vào cuối <body> -->
            <script>
                        let map;
                        function initMap() {
                            const defaultLocation = {lat: 10.7769, lng: 106.7009}; // Ho Chi Minh City
                            map = new google.maps.Map(document.getElementById("map"), {
                                center: defaultLocation,
                                zoom: 12,
                            });

                            const input = document.getElementById("locationInput");
                            const searchBox = new google.maps.places.SearchBox(input);

                            map.addListener("bounds_changed", () => {
                                searchBox.setBounds(map.getBounds());
                            });

                            searchBox.addListener("places_changed", () => {
                                const places = searchBox.getPlaces();
                                if (places.length == 0)
                                    return;
                                const place = places[0];
                                if (!place.geometry || !place.geometry.location) {
                                    console.log("No geometry available for this place");
                                    return;
                                }
                                map.setCenter(place.geometry.location);
                                map.setZoom(15);
                                new google.maps.Marker({map, position: place.geometry.location});
                            });
                        }

                        function geocodeAddress() {
                            const geocoder = new google.maps.Geocoder();
                            const address = document.getElementById("locationInput").value;
                            geocoder.geocode({address: address}, (results, status) => {
                                if (status === "OK") {
                                    map.setCenter(results[0].geometry.location);
                                    map.setZoom(15);
                                    new google.maps.Marker({map: map, position: results[0].geometry.location});
                                } else {
                                    alert("Geocode was not successful for the following reason: " + status);
                                }
                            });
                        }
            </script>

        </div>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <!-- 💡 Đặt modal rỗng tại đây -->
        <div class="modal fade" id="dishDetailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content" id="dishDetailContent">
                    <!-- Nội dung chi tiết sẽ được load bằng AJAX -->
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
                                        document.getElementById('dishDetailContent').innerHTML = html;
                                        new bootstrap.Modal(document.getElementById('dishDetailModal')).show();
                                    })
                                    .catch(error => console.error('Error loading dish detail:', error));
                        }
        </script>

        <!-- 💡 xử lí load category -->
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
                        })
                        .catch(error => {
                            console.error('Error loading dishes:', error);
                        });
            }

        </script>      

        <script>
            setTimeout(function () {
                const msg = document.getElementById("successMessage");
                if (msg)
                    msg.style.display = "none";
            }, 3000);
        </script>

        <script>
            document.querySelectorAll(".add-to-cart-btn").forEach(button => {
                button.addEventListener("click", function () {
                    const dishId = this.getAttribute("data-dishid");
                    const formData = new FormData();
                    formData.append("dishId", dishId);
                    formData.append("quantity", "1");

                    fetch("<%=request.getContextPath()%>/customer/add-cart", {
                        method: "POST",
                        headers: {
                            "X-Requested-With": "XMLHttpRequest" // ✅ Được phép

                        },
                        body: formData
                    })
                            .then(res => res.json())
                            .then(data => {
                                if (data.success) {
                                    // ✅ Cập nhật số lượng hiển thị (nếu có)
                                    if (document.getElementById("cart-count")) {
                                        document.getElementById("cart-count").textContent = data.cartCount;
                                    }
                                    alert(data.message);
                                } else if (data.redirect) {
                                    window.location.href = data.redirect;
                                } else {
                                    alert(data.message);
                                }
                            })
                            .catch(err => {
                                alert("Lỗi khi thêm vào giỏ hàng.");
                                console.error(err);
                            });
                });
            });
        </script>

        <script>
            document.addEventListener("DOMContentLoaded", () => {
                const form = document.getElementById("dishSearchForm");
                const input = document.getElementById("searchQuery");
                const dishContainer = document.getElementById("dish-container");

                form.addEventListener("submit", function (event) {
                    event.preventDefault(); // Ngăn form reload

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
            document.addEventListener('DOMContentLoaded', () => {
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

                    // Update active page button
                    document.querySelectorAll("#pageNumbers button").forEach(btn => {
                        btn.classList.remove("btn-primary");
                        btn.classList.add("btn-outline-primary");
                    });
                    const activeBtn = document.querySelector(`#pageBtn${page}`);
                    if (activeBtn) {
                        activeBtn.classList.add("btn-primary");
                        activeBtn.classList.remove("btn-outline-primary");
                    }

                    // Disable prev/next
                    prevBtn.disabled = page === 1;
                    nextBtn.disabled = page === totalPages;
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
                    btn.textContent = i;
                    btn.className = (i === currentPage) ? "active" : "";
                    btn.addEventListener("click", () => {
                        currentPage = i;
                        showPage(currentPage);
                        createPagination();
                    });
                    pageNumbers.appendChild(btn);
                }

                function createDots() {
                    const dots = document.createElement("span");
                    dots.textContent = "...";
                    dots.className = "pagination-dots";
                    return dots;
                }


                prevBtn.addEventListener("click", () => {
                    if (currentPage > 1) {
                        currentPage--;
                        showPage(currentPage);
                    }
                });

                nextBtn.addEventListener("click", () => {
                    if (currentPage < totalPages) {
                        currentPage++;
                        showPage(currentPage);
                    }
                });

                createPagination();
                showPage(currentPage);
            });
        </script>


    </body>
</html>