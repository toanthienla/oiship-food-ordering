<%@ page contentType="text/html;charset=UTF-8" %>
<%@page import="model.Dish"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi Tiết Món Ăn</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />

        <%-- style dish detail --%>
        <style>
            .dish-detail-container {
                max-width: 800px;
                margin: 40px auto;
                padding: 20px;
                background: #ffffff;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                border-radius: 10px;
            }
            .dish-detail-img {
                width: 100%;
                height: 300px;
                object-fit: cover;
                border-radius: 10px;
            }
            .btn-orange {
                background-color: #ff6200;
                color: white;
            }
            .btn-orange:hover {
                background-color: #e65c00;
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
            <a href="#" class="active"><i class="fas fa-home me-2"></i> Home</a>
            <a href="#menu"><i class="fas fa-utensils me-2"></i> Menu</a>
            <a href="#dishes"><i class="fas fa-drumstick-bite me-2"></i> Dish</a>
            <a href="#contact"><i class="fas fa-phone me-2"></i> Contact</a>
            <a href="#"><i class="fas fa-map-marker-alt me-2"></i> Location</a>
            <a href="#"><i class="fas fa-tags me-2"></i> Sale</a>
            <a href="#cart"><i class="fas fa-shopping-cart me-2"></i> Cart</a>
            <a href="#"><i class="fas fa-list me-2"></i> Order</a>
        </div>

        <div class="main-content">
            <nav class="navbar navbar-light bg-light p-2 mb-3">
                <form class="d-flex search-bar">
                    <input class="form-control me-2" type="search" placeholder="Tìm kiếm món ăn..." aria-label="Search" />
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
                    <h1>Giao món ngon tận nơi chỉ trong 30 phút!</h1>
                    <p>Khám phá hàng trăm món ăn Việt Nam và quốc tế với đội ngũ giao hàng tận nơi nhanh chóng, đảm bảo chất lượng.</p>
                    <button class="btn btn-custom me-2">Đặt ngay</button>
                    <button class="btn btn-outline-custom me-2">Xem thực đơn</button>
                    <button class="btn btn-outline-custom">Tải ứng dụng</button>
                </div>
            </div>

            <!-- Menu Section -->
            <div id="menu" class="menu-section">
                <h2 class="mb-4">MENU</h2>
                <div class="btn-group" role="group" aria-label="Menu categories">
                    <button type="button" class="btn btn-outline-primary menu-btn active" data-category="all">Tất cả</button>
                    <button type="button" class="btn btn-outline-primary menu-btn" data-category="pho">Phở</button>
                    <button type="button" class="btn btn-outline-primary menu-btn" data-category="com">Cơm</button>
                    <button type="button" class="btn btn-outline-primary menu-btn" data-category="banhmi">Bánh mì</button>
                    <button type="button" class="btn btn-outline-primary menu-btn" data-category="hai-san">Hải sản</button>
                    <button type="button" class="btn btn-outline-primary menu-btn" data-category="do-uong">Đồ uống</button>
                </div>
            </div>
            <%
                Dish dish = (Dish) request.getAttribute("dish");
                if (dish == null) {
            %>
            <div class="text-center mt-5">
                <h3>Không tìm thấy món ăn.</h3>
                <a href="home.jsp" class="btn btn-secondary mt-3">Quay về trang chủ</a>
            </div>
            <%
            } else {
                String imageUrl = (dish.getImage() != null && !dish.getImage().isEmpty())
                        ? dish.getImage()
                        : "https://via.placeholder.com/600x400";
            %>

            <div class="dish-detail-container">
                <img src="<%= imageUrl%>" alt="<%= dish.getDishName()%>" class="dish-detail-img mb-4" />
                <h2><%= dish.getDishName()%></h2>
                <p class="text-muted">Mã món: <%= dish.getDishID()%></p>
                <p><strong>Mô tả:</strong> <%= dish.getDishDescription() != null ? dish.getDishDescription() : "Không có mô tả."%></p>
                <p><strong>Giá:</strong> <%= dish.getTotalPrice().intValue()%> VNĐ</p>
                <p><strong>Tình trạng kho:</strong> <%= dish.getStock() > 0 ? dish.getStock() + " phần" : "Hết hàng"%></p>

                <div class="mt-4">
                    <a href="addToCart?dishId=<%= dish.getDishID()%>" class="btn btn-orange">Đặt ngay</a>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary ms-2">Quay lại</a>
                </div>
            </div>

            <%
                }
            %>
            <!-- Contact Section -->
            <div id="contact" class="contact-section">
                <h2 class="mb-4">Contact</h2>
                <p>Chúng tôi luôn sẵn sàng hỗ trợ bạn! Hãy liên hệ qua thông tin bên dưới hoặc để lại tin nhắn.</p>
                <div class="row">
                    <div class="col-md-6">
                        <p><i class="fas fa-map-marker-alt"></i> Địa chỉ: 27 Huỳnh Phúc Thọ, Quận 1, TP. HCM</p>
                        <p><i class="fas fa-phone"></i> Hotline: 0909 123 456</p>
                        <p><i class="fas fa-envelope"></i> Email: support@oiship.com</p>
                    </div>
                    <div class="col-md-6">
                        <form class="contact-form">
                            <div class="mb-3">
                                <input type="text" class="form-control" placeholder="Họ và tên" required>
                            </div>
                            <div class="mb-3">
                                <input type="email" class="form-control" placeholder="Email" required>
                            </div>
                            <div class="mb-3">
                                <textarea class="form-control" rows="3" placeholder="Tin nhắn" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-custom">Gửi tin nhắn</button>
                        </form>
                    </div>
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
    
    </body>
</html>
