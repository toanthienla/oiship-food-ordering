<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Staff Dashboard</title>

    <!-- Bootstrap CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/bootstrap.css"
    />

    <!-- Sidebar CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/sidebar.css"
    />

    <!-- Dashboard CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/dashboard.css"
    />

    <!-- Sidebar JS -->
    <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>

    <!-- Bootstrap Icons -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
    />

    <style>
      .stats-card {
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
        background: white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        transition: transform 0.2s ease-in-out;
        height: 100%;
        width: 100%;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
      }

      .stats-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
      }

      .row {
        display: flex;
        align-items: stretch;
      }

      .col-md-3,
      .col-md-6 {
        display: flex;
      }

      .stats-number {
        font-size: 2rem;
        font-weight: bold;
        color: #495057;
        margin-bottom: 10px;
      }

      .stats-label {
        color: #6c757d;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }

      .section-title {
        color: #495057;
        font-weight: 600;
        margin-bottom: 25px;
        padding-bottom: 10px;
        border-bottom: 2px solid #e9ecef;
      }

      .status-badges .badge {
        margin: 2px;
        font-size: 0.75rem;
        padding: 6px 10px;
      }

      .badge-pending {
        background-color: #ffc107;
        color: #000;
      }
      .badge-confirmed {
        background-color: #17a2b8;
        color: #fff;
      }
      .badge-preparing {
        background-color: #fd7e14;
        color: #fff;
      }
      .badge-delivery {
        background-color: #007bff;
        color: #fff;
      }
      .badge-delivered {
        background-color: #28a745;
        color: #fff;
      }
      .badge-unpaid {
        background-color: #dc3545;
        color: #fff;
      }
      .badge-paid {
        background-color: #28a745;
        color: #fff;
      }
      .badge-refunded {
        background-color: #6c757d;
        color: #fff;
      }

      .icon-large {
        font-size: 1.5rem;
        margin-bottom: 10px;
        color: #6c757d;
      }
    </style>
  </head>
  <body>
    <!-- Sidebar -->
    <jsp:include page="staff_sidebar.jsp" />

    <!-- Main Content -->
    <div class="main" id="main">
      <div class="topbar">
        <i class="bi bi-list menu-toggle" id="menuToggle"></i>
        <div class="profile"><span class="username">Hi, Staff</span></div>
      </div>

      <div class="content">
        <h1>Staff Dashboard</h1>
        <p>Overview of orders, reviews, and system statistics.</p>

        <!-- Today's Statistics -->
        <div class="mb-5">
          <h3 class="section-title">
            <i class="bi bi-calendar-day me-2"></i>Today's Statistics
          </h3>

          <div class="row">
            <div class="col-md-3 mb-3">
              <div class="stats-card text-center">
                <i class="bi bi-box-seam icon-large"></i>
                <div class="stats-number">${todayStats.totalOrders}</div>
                <div class="stats-label">Total Orders</div>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="stats-card text-center">
                <i class="bi bi-star icon-large"></i>
                <div class="stats-number">${todayStats.totalReviews}</div>
                <div class="stats-label">Total Reviews</div>
              </div>
            </div>
            <div class="col-md-6 mb-3">
              <div class="stats-card">
                <div class="stats-label mb-3">Order Status Breakdown</div>
                <div class="status-badges">
                  <span class="badge badge-pending"
                    >Pending: ${todayStats.pending}</span
                  >
                  <span class="badge badge-confirmed"
                    >Confirmed: ${todayStats.confirmed}</span
                  >
                  <span class="badge badge-preparing"
                    >Preparing: ${todayStats.preparing}</span
                  >
                  <span class="badge badge-delivery"
                    >Delivery: ${todayStats.delivery}</span
                  >
                  <span class="badge badge-delivered"
                    >Delivered: ${todayStats.delivered}</span
                  >
                </div>
                <div class="stats-label mt-3 mb-2">Payment Status</div>
                <div class="status-badges">
                  <span class="badge badge-unpaid"
                    >Unpaid: ${todayStats.unpaid}</span
                  >
                  <span class="badge badge-paid">Paid: ${todayStats.paid}</span>
                  <span class="badge badge-refunded"
                    >Refunded: ${todayStats.refunded}</span
                  >
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- This Month's Statistics -->
        <div class="mb-5">
          <h3 class="section-title">
            <i class="bi bi-calendar-month me-2"></i>This Month's Statistics
          </h3>

          <div class="row">
            <div class="col-md-3 mb-3">
              <div class="stats-card text-center">
                <i class="bi bi-box-seam icon-large"></i>
                <div class="stats-number">${monthStats.totalOrders}</div>
                <div class="stats-label">Total Orders</div>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="stats-card text-center">
                <i class="bi bi-star icon-large"></i>
                <div class="stats-number">${monthStats.totalReviews}</div>
                <div class="stats-label">Total Reviews</div>
              </div>
            </div>
            <div class="col-md-6 mb-3">
              <div class="stats-card">
                <div class="stats-label mb-3">Order Status Breakdown</div>
                <div class="status-badges">
                  <span class="badge badge-pending"
                    >Pending: ${monthStats.pending}</span
                  >
                  <span class="badge badge-confirmed"
                    >Confirmed: ${monthStats.confirmed}</span
                  >
                  <span class="badge badge-preparing"
                    >Preparing: ${monthStats.preparing}</span
                  >
                  <span class="badge badge-delivery"
                    >Delivery: ${monthStats.delivery}</span
                  >
                  <span class="badge badge-delivered"
                    >Delivered: ${monthStats.delivered}</span
                  >
                </div>
                <div class="stats-label mt-3 mb-2">Payment Status</div>
                <div class="status-badges">
                  <span class="badge badge-unpaid"
                    >Unpaid: ${monthStats.unpaid}</span
                  >
                  <span class="badge badge-paid">Paid: ${monthStats.paid}</span>
                  <span class="badge badge-refunded"
                    >Refunded: ${monthStats.refunded}</span
                  >
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- All Time Statistics -->
        <div class="mb-5">
          <h3 class="section-title">
            <i class="bi bi-calendar-range me-2"></i>All Time Statistics
          </h3>

          <div class="row">
            <div class="col-md-3 mb-3">
              <div class="stats-card text-center">
                <i class="bi bi-box-seam icon-large"></i>
                <div class="stats-number">${allStats.totalOrders}</div>
                <div class="stats-label">Total Orders</div>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="stats-card text-center">
                <i class="bi bi-star icon-large"></i>
                <div class="stats-number">${allStats.totalReviews}</div>
                <div class="stats-label">Total Reviews</div>
              </div>
            </div>
            <div class="col-md-6 mb-3">
              <div class="stats-card">
                <div class="stats-label mb-3">Order Status Breakdown</div>
                <div class="status-badges">
                  <span class="badge badge-pending"
                    >Pending: ${allStats.pending}</span
                  >
                  <span class="badge badge-confirmed"
                    >Confirmed: ${allStats.confirmed}</span
                  >
                  <span class="badge badge-preparing"
                    >Preparing: ${allStats.preparing}</span
                  >
                  <span class="badge badge-delivery"
                    >Delivery: ${allStats.delivery}</span
                  >
                  <span class="badge badge-delivered"
                    >Delivered: ${allStats.delivered}</span
                  >
                </div>
                <div class="stats-label mt-3 mb-2">Payment Status</div>
                <div class="status-badges">
                  <span class="badge badge-unpaid"
                    >Unpaid: ${allStats.unpaid}</span
                  >
                  <span class="badge badge-paid">Paid: ${allStats.paid}</span>
                  <span class="badge badge-refunded"
                    >Refunded: ${allStats.refunded}</span
                  >
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
