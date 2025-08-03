<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="sidebar d-flex flex-column justify-content-between" id="sidebar">
    <div>
        <div class="brand">
            <i class="bi bi-x-lg close-btn" id="closeSidebar"></i>
        </div>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-house-door-fill"></i> Home</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-orders"><i class="bi bi-receipt-cutoff"></i>Orders</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-categories"><i class="bi bi-ui-checks-grid"></i>Categories</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-dishes"><i class="bi bi-card-list"></i>Dishes</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-ingredients"><i class="bi bi-basket"></i>Ingredients</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-reviews"><i class="bi bi-chat-dots"></i>Reviews</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-vouchers"><i class="bi bi-tags"></i>Vouchers</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/contact-requests"><i class="bi bi-envelope"></i>Contact Requests</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/manage-notifications"><i class="bi bi-bell"></i>Notifications</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/accounts"><i class="bi bi-people"></i> Staff & Customers</a>
        <a class="nav-link" href="/OishipFoodOrdering/logout"><i class="bi bi-box-arrow-right"></i>Logout</a>
    </div>

    <div class="text-center p-3">
        <img src="${pageContext.request.contextPath}/images/logo_2.png" alt="Oiship Logo" style="max-width: 120px; height: auto;">
        <p style="font-weight: 500" class="">Admin</p>
    </div>
</div>
