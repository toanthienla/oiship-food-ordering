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
        <link href="https://api.mapbox.com/mapbox-gl-js/v2.16.1/mapbox-gl.css" rel="stylesheet" />
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
    </head>
    <body>
        <div class="sidebar">
            <div class="text-center mb-4">
                <img src="images/logo_1.png" alt="Oiship Logo" class="img-fluid" />
                <h5 class="mt-2 text-orange">OISHIP</h5>
            </div>
            <a href="#home" class="active"><i class="fas fa-home me-2"></i> Home</a>               
            <a href="customer/view-cart"><i class="fas fa-shopping-cart me-2"></i> Cart</a>          
            <a href="login"><i class="fas fa-list me-2"></i> Order</a>                 
            <a href="#contact"><i class="fas fa-phone me-2"></i> Contact</a>          
        </div>

        <div class="main-content">
            <nav class="navbar navbar-light bg-light p-2 mb-3">
                <form id="dishSearchForm" class="d-flex search-bar" role="search">
                    <input class="form-control me-2" type="text" id="searchQuery" placeholder="Search for dishes..." />
                    <button class="btn btn-outline-success" type="submit">Find</button>
                </form>
                <div class="d-flex align-items-center">
                    <div class="notification-bell me-3">
                        <i class="fas fa-bell"></i>
                        <span class="badge rounded-pill"></span>
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

            <!-- Pagination Controls -->
            <div class="pagination-container">
                <button id="prevPageBtn" class="page-btn rounded">&laquo;</button>
                <div id="pageNumbers" class="d-flex gap-2"></div>
                <button id="nextPageBtn" class="page-btn rounded">&raquo;</button>
            </div>
        </div>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://api.mapbox.com/mapbox-gl-js/v2.16.1/mapbox-gl.js"></script>
</body>
</html>
