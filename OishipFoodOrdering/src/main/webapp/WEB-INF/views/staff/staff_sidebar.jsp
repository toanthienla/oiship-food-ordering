<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Sidebar -->
<div class="sidebar d-flex flex-column justify-content-between" id="sidebar">
    <div>
        <div class="brand">
            <i class="bi bi-x-lg close-btn" id="closeSidebar"></i>
        </div>
        <a class="nav-link" href="${pageContext.request.contextPath}/staff/manage-orders"><i class="bi bi-receipt-cutoff"></i>Orders</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/staff/manage-reviews"><i class="bi bi-chat-dots"></i>Reviews</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/staff/manage-dishes"><i class="bi bi-card-list"></i>Dishes</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/staff/manage-ingredients"><i class="bi bi-basket"></i>Ingredients</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/staff/profile"><i class="bi bi-person-circle"></i>Profile</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i>Logout</a>
    </div>

    <div class="text-center p-3">
        <img src="${pageContext.request.contextPath}/images/logo_2.png" alt="Oiship Logo" style="max-width: 120px; height: auto;">
        <p style="font-weight: 500" class="">Staff</p>
    </div>
</div>
