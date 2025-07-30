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
        <style>
            :root {
                --oiship-orange: #ff6200;
                --oiship-orange-light: #ffeadd;
                --oiship-dark: #232323;
                --oiship-gray: #f8f9fa;
                --oiship-shadow: 0 2px 8px rgba(0,0,0,0.08);
                --oiship-radius: 4px;
            }
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: var(--oiship-gray);
            }
            .oiship-navbar {
                background: #fff;
                box-shadow: var(--oiship-shadow);
                padding: 0.6rem 2rem;
                border-radius: 0 0 var(--oiship-radius) var(--oiship-radius);
                position: sticky;
                top: 0;
                z-index: 100;
            }
            .oiship-navbar .navbar-brand img {
                height: 42px;
                width: 140px;
                object-fit: contain;
                margin-right: 12px;
                transition: width 0.2s;
            }
            .oiship-navbar .navbar-brand {
                color: var(--oiship-orange) !important;
                font-weight: bold;
                font-size: 1.5rem;
                display: flex;
                align-items: center;
                gap: 6px;
                letter-spacing: 2px;
            }
            .oiship-navbar .nav-link {
                color: #333;
                font-weight: 500;
                margin-right: 8px;
                border-radius: var(--oiship-radius);
                transition: 0.2s;
                padding: 7px 18px;
            }
            .oiship-navbar .nav-link.active,
            .oiship-navbar .nav-link:focus-visible,
            .oiship-navbar .nav-link.show {
                background: var(--oiship-orange-light) !important;
                color: var(--oiship-orange) !important;
                font-weight: 600;
            }
            .oiship-navbar .nav-link:hover:not(.active) {
                background: var(--oiship-orange);
                color: #fff !important;
            }
            .oiship-navbar .badge {
                background: var(--oiship-orange);
                color: #fff;
            }
            .oiship-navbar .dropdown-menu {
                border-radius: var(--oiship-radius);
                box-shadow: var(--oiship-shadow);
            }
            .oiship-navbar .dropdown-item:active {
                background: var(--oiship-orange);
                color: #fff;
            }
            .login-btn {
                background: var(--oiship-orange) !important;
                color: #fff !important;
                border-radius: var(--oiship-radius);
                padding: 7px 22px;
                font-weight: 600;
                border: none;
                transition: background 0.18s;
            }
            .login-btn:hover {
                background: #e65c00 !important;
                color: #fff !important;
            }
            /* Enhanced search bar */
            .search-bar-navbar {
                min-width: 260px;
                margin-right: 18px;
                display: flex;
                align-items: center;
                position: relative;
                max-width: 340px;
                flex: 1;
            }
            .search-bar-navbar .form-control {
                border: 1px solid #ececec;
                border-radius: 32px;
                background: #fffdfa;
                padding: 8px 44px 8px 16px;
                font-size: 1.05rem;
                box-shadow: none;
                color: #232323;
                transition: box-shadow 0.15s;
            }
            .search-bar-navbar .form-control:focus {
                box-shadow: 0 0 0 2px #ffe5d2;
                border-color: #ffba85;
            }
            .search-bar-navbar .search-btn {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                border: none;
                background: none;
                color: var(--oiship-orange);
                font-size: 1.3rem;
                padding: 0 6px;
                cursor: pointer;
                outline: none;
                transition: color 0.18s;
            }
            .search-bar-navbar .search-btn:hover {
                color: #e65c00;
            }
            .hero-section {
                width: 100%;
                height: 380px;
                margin-bottom: 2rem;
                border-radius: var(--oiship-radius);
                overflow: hidden;
                box-shadow: var(--oiship-shadow);
            }
            .carousel-inner img {
                width: 100%;
                height: 380px;
                object-fit: cover;
            }
            .menu-section {
                background: #fff;
                border-radius: var(--oiship-radius);
                box-shadow: var(--oiship-shadow);
                margin-bottom: 1.8rem;
                padding: 1.5rem 1.5rem 0.5rem 1.5rem;
            }
            .menu-section h2 {
                font-weight: 700;
                color: var(--oiship-dark);
            }
            .menu-section .menu-btn {
                border-radius: var(--oiship-radius);
                margin-right: 8px;
                padding: 9px 23px;
                font-weight: 600;
                background: #f3f3f3;
                color: #333;
                border: none;
                transition: all 0.25s;
            }
            .menu-section .menu-btn.active,
            .menu-section .menu-btn:hover {
                background: var(--oiship-orange) !important;
                color: #fff !important;
                box-shadow: 0 2px 12px rgba(255,98,0,0.18);
            }
            .dish-section {
                background: #fff;
                border-radius: var(--oiship-radius);
                box-shadow: var(--oiship-shadow);
                margin-bottom: 1.5rem;
                padding: 1.2rem 1.5rem;
            }
            /* Remove button styles and make it full-width */
            .dish-card-button {
                padding: 0;
                border: none;
                background: none;
                width: 100%;
                text-align: left;
            }
            /* Main card style */
            .dish-card {
                border-radius: 3px !important;
                transition: box-shadow 0.22s ease;
                overflow: hidden;
                background: #fff;
                box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
            }
            /* Hover effect: box shadow only, no transform */
            .dish-card:hover {
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            }
            /* Image styling */
            .dish-card img {
                height: 170px;
                object-fit: cover;
                border-radius: var(--oiship-radius, 3px) var(--oiship-radius, 3px) 0 0;
                width: 100%;
                border-bottom: 1px solid #f3f3f3;
                background-color: #f9f9f9;
            }
            /* Body padding */
            .dish-card .card-body {
                padding: 16px 18px;
            }
            /* Align text to left and style title */
            .dish-card .card-title {
                font-size: 1.15rem;
                font-weight: 600;
                color: #232323;
                margin-bottom: 6px;
                text-align: left;
            }
            /* Text description */
            .dish-card .card-text {
                font-size: 1rem;
                color: #666;
                text-align: left;
            }
            /* Price formatting */
            .dish-card .price {
                font-weight: 700;
                font-size: 1.05rem;
                color: var(--oiship-orange, #ff6600);
                text-align: left;
            }

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
                font-size: 1.15rem;
                padding: 8px 16px;
                border-radius: var(--oiship-radius);
                cursor: pointer;
                transition: all 0.2s;
            }
            .pagination-container button:hover {
                background: #ffe1ce;
            }
            .pagination-container button.active {
                background: var(--oiship-orange);
                color: #fff;
            }
            .pagination-container button:disabled {
                color: #aaa;
                cursor: default;
            }
            .pagination-dots {
                padding: 8px 12px;
                color: #888;
            }
            .ggmap-container {
                width: 100%;
                display: flex;
                justify-content: center;
                margin-bottom: 2rem;
            }
            .ggmap-container iframe {
                width: 100%;
                min-height: 320px;
                max-height: 400px;
                border-radius: var(--oiship-radius);
                box-shadow: var(--oiship-shadow);
                border: 0;
            }
            .custom-modal-content {
                border-radius: 12px;
                background: #fffdfa;
                box-shadow: 0 8px 32px rgba(0,0,0,0.18);
                border: none;
                padding: 0;
                overflow: hidden;
                animation: modalFadeIn 0.35s cubic-bezier(.4,0,.2,1);
            }
            @keyframes modalFadeIn {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .custom-modal-content .modal-header {
                background: #ffeadd;
                border-bottom: 1px solid #ffd6b0;
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;
                padding: 1.2rem 2rem 1.2rem 1.7rem;
            }
            .custom-modal-content .modal-title {
                color: #ff6200;
                font-weight: 700;
                font-size: 1.35rem;
                letter-spacing: 1px;
            }
            .custom-modal-content .modal-body {
                padding: 2rem 2.2rem 1.5rem 2.2rem;
                background: #fffdfa;
                font-size: 1.08rem;
                color: #232323;
            }
            .custom-modal-content .modal-footer {
                background: #fff5e6;
                border-top: 1px solid #ffd6b0;
                border-bottom-left-radius: 12px;
                border-bottom-right-radius: 12px;
                padding: 1rem 2rem;
                justify-content: flex-end;
            }
            .custom-modal-content .btn-close {
                filter: invert(42%) sepia(94%) saturate(1632%) hue-rotate(4deg) brightness(105%) contrast(106%);
                opacity: 0.7;
                transition: opacity 0.18s;
            }
            .custom-modal-content .btn-close:hover {
                opacity: 1;
            }
            @media (max-width: 1199px) {
                .hero-section {
                    height: 260px;
                }
                .carousel-inner img {
                    height: 260px;
                }
                .oiship-navbar .navbar-brand img {
                    width: 110px;
                }
            }
            @media (max-width: 768px) {
                .oiship-navbar {
                    padding: 0.6rem 1rem;
                }
                .menu-section,
                .dish-section {
                    padding: 1rem 0.5rem;
                }
                .hero-section,
                .carousel-inner img {
                    height: 180px;
                }
                .ggmap-container iframe {
                    min-height: 220px;
                }
                .oiship-navbar .navbar-brand img {
                    width: 90px;
                }
                .custom-modal-content .modal-body,
                .custom-modal-content .modal-header,
                .custom-modal-content .modal-footer {
                    padding-left: 1rem;
                    padding-right: 1rem;
                }
                .search-bar-navbar {
                    min-width: 120px;
                    margin-right: 5px;
                }
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg oiship-navbar mb-3">
            <div class="container-fluid align-items-center">
                <a class="navbar-brand d-flex align-items-center" href="#">
                    <img src="images/logo_1.png" alt="Oiship Logo" />
                </a>
                <!-- Search form in navbar -->
                <form id="dishSearchForm" class="search-bar-navbar mx-2" autocomplete="off" role="search">
                    <input class="form-control" type="text" id="searchQuery" placeholder="Search for dishes..." />
                    <button class="search-btn" type="submit" title="Search">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#oishipNavbarNav" aria-controls="oishipNavbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse justify-content-end" id="oishipNavbarNav">
                    <ul class="navbar-nav align-items-center">
                        <!-- Only user dropdown, always shown, no home, no login check -->
                        <c:if test="${not isLoggedIn}">
                            <li class="nav-item ms-2">
                                <a class="nav-link login-btn" href="${pageContext.request.contextPath}/login">
                                    <i class="fas fa-sign-in-alt me-1"></i> Login
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${isLoggedIn}">
                            <li class="nav-item dropdown ms-2">
                                <a class="nav-link dropdown-toggle" href="#" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user"></i>
                                    <span><c:out value="${userName}" /></span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                    <li><a class="dropdown-item" href="#">Profile</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Log out</a></li>
                                </ul>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container-xl px-2 px-md-4">
            <div class="hero-section mb-4">
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
                <h2 class="mb-4">MENU CATEGORIES</h2>
                <div class="d-flex flex-wrap gap-2 overflow-auto pb-2" style="scrollbar-width: none;">
                    <button class="btn menu-btn active" onclick="loadDishesByCategory('all')">All</button>
                    <%
                        List<Category> categories = (List<Category>) request.getAttribute("categories");
                        if (categories != null) {
                            for (model.Category cat : categories) {
                    %>
                    <button class="btn menu-btn" onclick="loadDishesByCategory(<%= cat.getCatID()%>)">
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

            <!-- Google Map Embed -->
            <div class="ggmap-container mt-5">
                <iframe
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3929.0533542569992!2d105.7298566755705!3d10.012451790093596!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31a0890033b0a4d5%3A0x5360c94ba9e67842!2zNjAwIE5ndXnhu4VuIFbEg24gQ-G7qyBO4buRaSBEw6BpLCBBbiBCw6xuaCwgQsOsbmggVGjhu6d5LCBD4bqnbiBUaMahIDkwMDAwMCwgVmlldG5hbQ!5e0!3m2!1sen!2s!4v1753673481462!5m2!1sen!2s"
                    style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade">
                </iframe>
            </div>
        </div>

        <!-- Dish Detail Modal -->
        <div class="modal fade" id="dishDetailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content custom-modal-content" id="dishDetailContent">
                    <!-- AJAX loaded here -->
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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
                        function loadDishesByCategory(catId) {
                            document.querySelectorAll('.menu-btn').forEach(btn => btn.classList.remove('active'));
                            event.target.classList.add('active');
                            document.getElementById("searchQuery").value = '';
                            fetch('<%= request.getContextPath()%>/customer/dish-detail', {
                                method: 'POST',
                                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                body: 'catId=' + catId
                            })
                                    .then(response => response.text())
                                    .then(html => {
                                        document.getElementById('dish-container').innerHTML = html;
                                        setupPagination();
                                    })
                                    .catch(error => console.error('Error loading dishes:', error));
                        }
                        document.addEventListener("DOMContentLoaded", () => {
                            const form = document.getElementById("dishSearchForm");
                            const input = document.getElementById("searchQuery");
                            const dishContainer = document.getElementById("dish-container");

                            // Submit search
                            form.addEventListener("submit", function (event) {
                                event.preventDefault();
                                const query = input.value.trim();
                                if (!query)
                                    return;
                                // Set "All" category active
                                document.querySelectorAll('.menu-btn').forEach(btn => btn.classList.remove('active'));
                                document.querySelector('.menu-btn').classList.add('active');
                                fetch("<%=request.getContextPath()%>/customer/search-dish", {
                                    method: "POST",
                                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                                    body: new URLSearchParams({searchQuery: query})
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
                        if (startPage > 2)
                            pageNumbers.appendChild(createDots());
                    }
                    for (let i = startPage; i <= endPage; i++)
                        appendPageButton(i);
                    if (endPage < totalPages) {
                        if (endPage < totalPages - 1)
                            pageNumbers.appendChild(createDots());
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
    </body>
</html>