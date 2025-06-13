<%@ page contentType="text/html;charset=UTF-8" %>

<!-- Danh sách menu sidebar -->
<ul class="nav flex-column">
    <li class="nav-item">
        <a class="nav-link" href="manage-order">
            <i class="bi bi-receipt-cutoff"></i> Orders
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="manage-reviews">
            <i class="bi bi-chat-dots"></i> Dish Reviews
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="manage-dishes">
            <i class="bi bi-card-list"></i> Dishes
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="manage-ingredients">
            <i class="bi bi-basket"></i> Ingredients
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="manage-customers">
            <i class="bi bi-people"></i> Staff & Customers
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="manage-vouchers">
            <i class="bi bi-tags"></i> Vouchers
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="manage-categories">
            <i class="bi bi-ui-checks-grid"></i> Categories
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="manage-notifications">
            <i class="bi bi-bell"></i> Notifications
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="contact-requests">
            <i class="bi bi-envelope"></i> Contact Requests
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="view-revenue">
            <i class="bi bi-bar-chart-line"></i> Income Statistics
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="profile">
            <i class="bi bi-person-circle"></i> Profile
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="/OishipFoodOrdering/logout">
            <i class="bi bi-box-arrow-right"></i> Logout
        </a>
    </li>
</ul>

<!-- Footer logo -->
<div class="sidebar-footer text-center mt-4">
    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" width="80">

    <p class="mt-2">Oiship Admin</p>
</div>
