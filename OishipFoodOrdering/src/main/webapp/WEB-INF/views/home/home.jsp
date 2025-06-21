<%@page import="model.Category"%>
<%@page import="model.Dish"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Home - Oiship</title>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
        <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap&libraries=places&v=weekly" async></script>
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
                    font-size: 1rem;
                    padding: 6px 12px;
                    border-radius: 4px;
                    cursor: pointer;
                }

                .pagination-container button:hover {
                    background-color: #eee;
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
        <%-- style home --%>
        <style>

            body {
                font-family: 'Arial', sans-serif;
                background-color: #f8f9fa;
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
            .menu-section, .dish-section, .contact-section {
                background-color: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
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
        </style>
    </head>
    <body>
        <div class="sidebar">
            <div class="text-center mb-4">
                <img src="images/logo_1.png" alt="Oiship Logo" class="img-fluid" />
                <h5 class="mt-2 text-orange">OISHIP</h5>
            </div>
            <a href="#home" class="active"><i class="fas fa-home me-2"></i> Home</a>
            <a href="#menu"><i class="fas fa-utensils me-2"></i> Menu</a>
            <a href="#dishes"><i class="fas fa-drumstick-bite me-2"></i> Dishes</a>

            <a href="#contact"><i class="fas fa-phone me-2"></i> Contact</a>
            <a href="#location"><i class="fas fa-map-marker-alt me-2"></i> Location</a>

            <a href="#"><i class="fas fa-tags me-2"></i> Sale</a>
            <a href="login"><i class="fas fa-shopping-cart me-2"></i> Cart</a>
            <a href="login"><i class="fas fa-list me-2"></i> Order</a>
            <a href="#"><i class="fas fa-map-marker-alt me-2"></i> Location</a>           
            <a href="#contact"><i class="fas fa-phone me-2"></i> Contact</a>          
        </div>

        <div class="main-content">
            <nav class="navbar navbar-light bg-light p-2 mb-3">
                <form method="POST" action="${pageContext.request.contextPath}/customer/search-dish" class="d-flex search-bar" role="search">
                    <input class="form-control me-2" type="search-dish" name="searchQuery" placeholder="Search for dishes..." aria-label="Search" />
                    <button class="btn btn-outline-success" type="submit">Find</button>
                </form>
                <div class="d-flex align-items-center">
                    <div class="notification-bell me-3">
                        <i class="fas fa-bell"></i>
                        <span class="badge rounded-pill">3</span>
                    </div>
                    <div class="dropdown">
                        <a class="dropdown-toggle text-decoration-none" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user"></i>
                            <span>
                                <c:choose>
                                    <c:when test="${isLoggedIn and not empty userName}">
                                        <c:out value="${userName}" />
                                    </c:when>
                                    <c:otherwise>
                                        Guest
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <c:if test="${isLoggedIn}">
                                <li><a class="dropdown-item" href="#">Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Log out</a></li>
                                </c:if>
                                <c:if test="${not isLoggedIn}">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/login">Log in</a></li>
                                </c:if>
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
                    <form action="home/dish" method="post">
                        <input type="hidden" name="catId" value="all">
                        <a href="#"
                           class="btn btn-outline-primary menu-btn <%= (request.getParameter("catId") == null) ? "active" : ""%>">
                            All
                        </a>
                    </form>

                    <%
                        List<Category> categories = (List<Category>) request.getAttribute("categories");
                        if (categories != null) {
                            for (model.Category cat : categories) {
                    %>
                    <form action="home/dish" method="post">
                        <input type="hidden" name="catId" value="<%= cat.getCatID()%>">
                        <button type="submit" class="btn btn-outline-primary menu-btn">
                            <%= cat.getCatName()%>
                        </button>
                    </form>
                    <%
                            }
                        }
                    %>
                </div>
            </div>

            <!-- Dishes Section -->
            <div id="dishes" class="dish-section">
                <h2 class="mb-4">Trending Food</h2>
                <div class="row">
                    <%
                        List<Dish> menuItems = (List<Dish>) request.getAttribute("menuItems");
                        if (menuItems != null && !menuItems.isEmpty()) {
                            for (Dish menuItem : menuItems) {
                                String imageUrl = (menuItem.getImage() != null && !menuItem.getImage().isEmpty())
                                        ? menuItem.getImage()
                                        : "https://via.placeholder.com/300x200";
                    %>

                    <div class="col-md-4 mb-3 dish-item">


                        <!-- FORM 1: Xem chi tiết món -->
                        <form action="home/dish" method="post">
                            <input type="hidden" name="dishID" value="<%= menuItem.getDishID()%>">
                            <button type="submit" class="btn p-0 border-0 text-start w-100" style="background: none;">
                                <div class="card dish-card">
                                    <img src="<%= imageUrl%>" alt="<%= menuItem.getDishName()%>" class="card-img-top">
                                    <div class="card-body">
                                        <h5 class="card-title"><%= menuItem.getDishName()%></h5>
                                        <p class="card-text">Price: <%= menuItem.getFormattedPrice()%>đ</p>
                                    </div>
                                </div>
                            </button>
                        </form>

                        <!-- FORM 2: Add to Cart riêng biệt -->
                        <form method="post" action="${pageContext.request.contextPath}/customer/add-cart">
                            <input type="hidden" name="dishID" value="${menuItem.dishID}" />
                            <input type="hidden" name="quantity" value="1" />
                            <button type="submit" class="btn btn-custom w-100">Add Cart</button>
                        </form> 




                    </div>
                    <%
                        }
                    } else {
                    %>
                    <p class="text-muted">No dishes available to display.</p>
                    <%
                        }
                    %>
                </div>
                <div class="text-end">
                    <a href="menu.jsp" class="btn btn-outline-custom">View All Dishes</a>
                </div>
                <!-- Pagination Controls -->
                <div class="pagination-container">
                    <button id="prevPageBtn" class="page-btn rounded">&laquo;</button>
                    <div id="pageNumbers" class="d-flex gap-2"></div>
                    <button id="nextPageBtn" class="page-btn rounded">&raquo;</button>
                </div>


            </div>
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
          
            <!-- Location Map Section -->
            <div id="location" class="menu-section mt-4">
                <h2 class="mb-4">Location Map</h2>
                <div class="mb-3">
                    <label for="locationInput" class="form-label">Enter Location:</label>
                    <input type="text" class="form-control" id="locationInput" placeholder="Enter an address (e.g., Ho Chi Minh City, Vietnam)">
                    <button class="btn btn-custom mt-2" onclick="getDirections()">Get Directions</button>
                </div>
                <div id="map"></div>
            </div>

            <!-- ... (phần cuối file giữ nguyên) ... -->

            <!-- Thêm vào <head> -->
            <link href="https://api.mapbox.com/mapbox-gl-js/v2.9.1/mapbox-gl.css" rel="stylesheet">
            <link rel="stylesheet" href="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-directions/v4.1.1/mapbox-gl-directions.css" type="text/css">
          
            <style>
                #map {
                    height: 400px;
                    width: 100%;
                    margin-top: 20px;
                    border-radius: 10px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                }
                .mapboxgl-ctrl-geocoder {
                    width: 100%;
                }
            </style>
            <script src="https://api.mapbox.com/mapbox-gl-js/v2.9.1/mapbox-gl.js"></script>
            <script src="https://api.mapbox.com/mapbox-gl-js/plugins/mapbox-gl-directions/v4.1.1/mapbox-gl-directions.js"></script>

            <!-- Thêm vào cuối <body> trước </body> -->
            <script>
                        mapboxgl.accessToken = 'YOUR_MAPBOX_ACCESS_TOKEN'; // Thay bằng token của bạn
                        const map = new mapboxgl.Map({
                            container: 'map',
                            style: 'mapbox://styles/mapbox/streets-v11', // Style mặc định, có thể thay đổi
                            center: [106.7009, 10.7769], // Ho Chi Minh City [lng, lat]
                            zoom: 12
                        });

                        const directions = new MapboxDirections({
                            accessToken: mapboxgl.accessToken,
                            unit: 'metric',
                            profile: 'mapbox/driving', // Hoặc 'walking', 'cycling'
                            controls: {instructions: true}
                        });

                        map.addControl(directions, 'top-left');

                        function getDirections() {
                            const address = document.getElementById('locationInput').value;
                            if (address) {
                                // Sử dụng Geocoder để chuyển đổi địa chỉ thành tọa độ
                                const geocoder = new MapboxGeocoder({
                                    accessToken: mapboxgl.accessToken,
                                    mapboxgl: mapboxgl
                                });

                                geocoder.on('result', (e) => {
                                    const destination = e.result.center; // [lng, lat]
                                    directions.setDestination(destination); // Đặt điểm đến
                                    // Đặt điểm xuất phát mặc định (có thể lấy từ vị trí hiện tại nếu cần)
                                    directions.setOrigin([106.7009, 10.7769]); // Ho Chi Minh City
                                    map.fitBounds(directions.getBounds(), {padding: 50});
                                });

                                geocoder.query(address);
                            } else {
                                alert('Please enter a location.');
                            }
                        }

                        // Thêm control geocoder để hỗ trợ tìm kiếm
                        map.addControl(new MapboxGeocoder({
                            accessToken: mapboxgl.accessToken,
                            mapboxgl: mapboxgl
                        }));
            </script>
        </div>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                document.querySelectorAll('.sidebar a').forEach(anchor => {
                    anchor.addEventListener('click', function (e) {
                        if (this.getAttribute('href').startsWith('#')) {
                            e.preventDefault();
                            const targetId = this.getAttribute('href').substring(1);
                            document.getElementById(targetId).scrollIntoView({behavior: 'smooth'});
                            document.querySelectorAll('.sidebar a').forEach(a => a.classList.remove('active'));
                            this.classList.add('active');
                        }
                    });
                });

                document.querySelectorAll('.dish-card .btn').forEach(button => {
                    button.addEventListener('click', () => {
                        alert('Dish added to cart!');
                    });
                });
            });
        </script>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const menuButtons = document.querySelectorAll('.menu-btn');

                menuButtons.forEach(btn => {
                    btn.addEventListener('click', () => {
                        menuButtons.forEach(b => b.classList.remove('active'));
                        btn.classList.add('active');

                        const category = btn.getAttribute('data-category');
                        filterDishes(category);
                    });
                });

                function filterDishes(category) {
                    const dishes = document.querySelectorAll('.dish-card');
                    dishes.forEach(dish => {
                        if (category === 'all') {
                            dish.parentElement.style.display = 'block';
                        } else {
                            if (dish.getAttribute('data-category') === category) {
                                dish.parentElement.style.display = 'block';
                            } else {
                                dish.parentElement.style.display = 'none';
                            }
                        }
                    });
                }
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
