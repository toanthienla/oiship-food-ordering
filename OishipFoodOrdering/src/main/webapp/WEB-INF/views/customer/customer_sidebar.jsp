<%@ page contentType="text/html;charset=UTF-8" %>
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

<div class="sidebar d-flex flex-column justify-content-between" id="sidebar">
    <div class="sidebar">
        <div class="text-center mb-4">
            <img src="${pageContext.request.contextPath}/images/logo_1.png" alt="Oiship Logo" class="img-fluid" />
            <h5 class="mt-2 text-orange">OISHIP</h5>
        </div>
        <a href="${pageContext.request.contextPath}/home" class="active"><i class="fas fa-home me-2"></i> Home</a>
        <a href="#"><i class="fas fa-tags me-2"></i> Voucher</a>
        <a href="${pageContext.request.contextPath}/customer/view-cart">
            <i class="fas fa-shopping-cart me-2"></i>
            Cart
            <span id="cart-count" class="badge bg-danger ms-1">0</span>
        </a>
        <a href="#"><i class="fas fa-list me-2"></i> Order</a>
        <a href="#contact"><i class="fas fa-phone me-2"></i> Contact</a>
        <a href="#"><i class="fas fa-map-marker-alt me-2"></i> Location</a>
    </div>
</div>
