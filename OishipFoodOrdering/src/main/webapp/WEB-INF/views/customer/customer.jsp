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
            <a href="#home" class="active"><i class="fas fa-home me-2"></i> Home</a>
            <a href="#menu"><i class="fas fa-utensils me-2"></i> Menu</a>
            <a href="#dishes"><i class="fas fa-drumstick-bite me-2"></i> Dishes</a>
            <a href="#contact"><i class="fas fa-phone me-2"></i> Contact</a>
            <a href="#"><i class="fas fa-map-marker-alt me-2"></i> Location</a>
            <a href="#"><i class="fas fa-tags me-2"></i> Sale</a>
            <a href="customer/view-cart">
                <i class="fas fa-shopping-cart me-2"></i>
                Cart
                <span id="cart-count" class="badge bg-danger ms-1">0</span>
            </a>

            <a href="#"><i class="fas fa-list me-2"></i> Order</a>
        </div>
        <%
            List<Cart> cartItems = (List<Cart>) session.getAttribute("cartItems");
            int cartCount = (cartItems != null) ? cartItems.size() : 0;
        %>

        <a href="add-cart"><i class="fas fa-shopping-cart me-2"></i> Cart (<%= cartCount%>)</a>

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
                        <a class="dropdown-toggle text-decoration-none user-account" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user"></i>
                            <div class="welcome-text">
                                Welcome, <span><c:out value="${userName}" default="Guest" /></span>!
                            </div>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="#">Profile</a></li>
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
                            <input type="hidden" name="dishID" value="<%= menuItem.getDishID()%>" />
                            <input type="hidden" name="quantity" value="1"  />
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
                <div class="d-flex flex-wrap justify-content-center align-items-center mt-4 gap-2">
                    <button id="prevPageBtn" class="btn btn-outline-primary">← Prev</button>
                    <div id="pageNumbers" class="d-flex flex-wrap gap-2"></div>
                    <button id="nextPageBtn" class="btn btn-outline-primary">Next →</button>
                </div>
            </div>
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
                                alert('Đã thêm món vào giỏ hàng!');
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
                                    // KHÔNG cần Content-Type vì fetch sẽ tự thêm đúng loại cho FormData
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
                    for (let i = 1; i <= totalPages; i++) {
                        const btn = document.createElement("button");
                        btn.textContent = i;
                        btn.id = `pageBtn${i}`;
                        btn.className = "btn btn-outline-primary";
                        btn.addEventListener("click", () => {
                            currentPage = i;
                            showPage(currentPage);
                        });
                        pageNumbers.appendChild(btn);
                    }
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