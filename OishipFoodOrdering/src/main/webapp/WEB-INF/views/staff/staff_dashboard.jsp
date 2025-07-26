<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
    uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib prefix="fmt"
                                                                 uri="http://java.sun.com/jsp/jstl/fmt" %>
    <!DOCTYPE html>
    <html lang="vi">
        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Staff Dashboard - Oiship</title>

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

            <!-- Sidebar JS -->
            <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>

            <!-- Bootstrap Icons -->
            <link
                rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
                />

            <style>
                body {
                    margin: 0;
                    font-family: "Segoe UI", sans-serif;
                    background-color: white;
                    display: flex;
                    min-height: 100vh;
                }

                .main {
                    margin-left: 250px;
                    width: calc(100% - 250px);
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    transition: margin-left 0.3s ease-in-out;
                }

                .topbar {
                    height: 60px;
                    background-color: #fff;
                    display: flex;
                    justify-content: flex-end;
                    align-items: center;
                    padding: 0 30px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                    z-index: 999;
                }

                .topbar .profile {
                    display: flex;
                    align-items: center;
                    gap: 20px;
                    visibility: visible;
                    opacity: 1;
                }

                .topbar .profile i {
                    font-size: 1.3rem;
                    cursor: pointer;
                    color: #2c3e50;
                }

                .topbar .username {
                    font-weight: 400;
                    color: #333;
                }

                .content {
                    padding: 30px;
                    background-color: white;
                    flex-grow: 1;
                }

                .menu-toggle {
                    display: none;
                    font-size: 1.5rem;
                    cursor: pointer;
                    color: #333;
                }

                .wellcome-text {
                    padding: 8px;
                }

                .badge {
                    margin: 2px;
                    font-size: 0.75em;
                }

                .stat-box {
                    background-color: #f8f9fa;
                    transition: all 0.3s ease;
                    min-height: 120px;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                }

                .stat-box:hover {
                    background-color: #fff5f0;
                    transform: translateY(-2px);
                    box-shadow: 0 4px 12px rgba(239, 93, 16, 0.2);
                }

                .stats-section {
                    animation: fadeInUp 0.6s ease-out;
                }

                @keyframes fadeInUp {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .section-title {
                    font-weight: 600;
                    letter-spacing: 1px;
                }

                .payment-status .badge {
                    font-size: 0.9em;
                    padding: 8px 12px;
                }

                .card {
                    border-radius: 15px;
                    overflow: hidden;
                }

                .card-header {
                    border-bottom: 3px solid rgba(255, 255, 255, 0.2);
                }

                .card {
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                }

                .stats-number {
                    font-size: 1.5rem;
                    font-weight: bold;
                    color: #2c3e50;
                }

                @media (max-width: 768px) {
                    .main {
                        margin-left: 0;
                    }

                    .main.sidebar-active {
                        margin-left: 250px;
                    }

                    .menu-toggle {
                        display: block;
                    }

                    .topbar {
                        position: fixed;
                        justify-content: space-between;
                        top: 0;
                        width: 100%;
                        left: 0;
                    }

                    .content {
                        padding-top: 90px;
                    }

                    .topbar .profile {
                        display: flex;
                        visibility: visible;
                        opacity: 1;
                    }

                    .notification-popup {
                        right: 10px;
                        width: 90%;
                        max-width: 300px;
                    }
                }

                @media (max-width: 576px) {
                    .main.sidebar-active {
                        margin-left: 200px;
                    }
                }
            </style>
        </head>
        <body>
            <!-- Sidebar -->
            <jsp:include page="staff_sidebar.jsp" />

            <!-- div.main -->
            <div class="main">
                <div class="topbar">
                    <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                    <div class="profile"><span class="username">Hi, Staff</span></div>
                </div>

                <!--div.content-->
                <div class="dashboard-container content">
                    <h1 class="text-center">Staff Dashboard</h1>

                    <!-- SINGLE TABLE LAYOUT -->
                    <div class="row justify-content-center">
                        <div class="col-lg-10">
                            <div class="card-body p-4">
                                <!-- HÔM NAY -->
                                <div class="stats-section mb-5">
                                    <h5
                                        class="section-title text-center p-3 rounded mb-4"
                                        style="background-color: #ef5d10; color: white"
                                        >
                                        <i class="bi bi-calendar-day"></i> HÔM NAY
                                    </h5>

                                    <div class="row">
                                        <div class="col-md-4 text-center mb-3">
                                            <div
                                                class="stat-box p-3 rounded"
                                                style="border: 2px solid #ef5d10"
                                                >
                                                <h3 class="stats-number" style="color: #ef5d10">
                                                    ${todayStats.totalOrders}
                                                </h3>
                                                <p class="mb-0"><strong>📦 Tổng Đơn Hàng</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-center mb-3">
                                            <div
                                                class="stat-box p-3 rounded"
                                                style="border: 2px solid #ef5d10"
                                                >
                                                <h3 class="stats-number" style="color: #ef5d10">
                                                    ${todayStats.totalReviews}
                                                </h3>
                                                <p class="mb-0"><strong>⭐ Tổng Reviews</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-center mb-3">
                                            <div
                                                class="stat-box p-3 rounded"
                                                style="border: 2px solid #ef5d10"
                                                >
                                                <div class="mb-2">
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Pending: ${todayStats.pending}</span
                                                    >
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Confirmed: ${todayStats.confirmed}</span
                                                    >
                                                </div>
                                                <div class="mb-2">
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Preparing: ${todayStats.preparing}</span
                                                    >
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Delivery: ${todayStats.delivery}</span
                                                    >
                                                </div>
                                                <div>
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Delivered: ${todayStats.delivered}</span
                                                    >
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row mt-3">
                                        <div class="col-md-12 text-center">
                                            <div class="payment-status">
                                                <small class="text-muted d-block mb-2"
                                                       >Payment Status:</small
                                                >
                                                <span
                                                    class="badge me-2"
                                                    style="background-color: #ef5d10"
                                                    >Unpaid: ${todayStats.unpaid}</span
                                                >
                                                <span
                                                    class="badge me-2"
                                                    style="background-color: #ef5d10"
                                                    >Paid: ${todayStats.paid}</span
                                                >
                                                <span class="badge" style="background-color: #ef5d10"
                                                      >Refunded: ${todayStats.refunded}</span
                                                >
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <hr style="border-color: #ef5d10; border-width: 2px" />

                                <!-- THÁNG NÀY -->
                                <div class="stats-section mb-5">
                                    <h5
                                        class="section-title text-center p-3 rounded mb-4"
                                        style="background-color: #ef5d10; color: white"
                                        >
                                        <i class="bi bi-calendar-month"></i> THÁNG NÀY
                                    </h5>

                                    <div class="row">
                                        <div class="col-md-4 text-center mb-3">
                                            <div
                                                class="stat-box p-3 rounded"
                                                style="border: 2px solid #ef5d10"
                                                >
                                                <h3 class="stats-number" style="color: #ef5d10">
                                                    ${monthStats.totalOrders}
                                                </h3>
                                                <p class="mb-0"><strong>📦 Tổng Đơn Hàng</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-center mb-3">
                                            <div
                                                class="stat-box p-3 rounded"
                                                style="border: 2px solid #ef5d10"
                                                >
                                                <h3 class="stats-number" style="color: #ef5d10">
                                                    ${monthStats.totalReviews}
                                                </h3>
                                                <p class="mb-0"><strong>⭐ Tổng Reviews</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-center mb-3">
                                            <div
                                                class="stat-box p-3 rounded"
                                                style="border: 2px solid #ef5d10"
                                                >
                                                <div class="mb-2">
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Pending: ${monthStats.pending}</span
                                                    >
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Confirmed: ${monthStats.confirmed}</span
                                                    >
                                                </div>
                                                <div class="mb-2">
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Preparing: ${monthStats.preparing}</span
                                                    >
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Delivery: ${monthStats.delivery}</span
                                                    >
                                                </div>
                                                <div>
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Delivered: ${monthStats.delivered}</span
                                                    >
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row mt-3">
                                        <div class="col-md-12 text-center">
                                            <div class="payment-status">
                                                <small class="text-muted d-block mb-2"
                                                       >Payment Status:</small
                                                >
                                                <span
                                                    class="badge me-2"
                                                    style="background-color: #ef5d10"
                                                    >Unpaid: ${monthStats.unpaid}</span
                                                >
                                                <span
                                                    class="badge me-2"
                                                    style="background-color: #ef5d10"
                                                    >Paid: ${monthStats.paid}</span
                                                >
                                                <span class="badge" style="background-color: #ef5d10"
                                                      >Refunded: ${monthStats.refunded}</span
                                                >
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <hr style="border-color: #ef5d10; border-width: 2px" />

                                <!-- TẤT CẢ -->
                                <div class="stats-section">
                                    <h5
                                        class="section-title text-center p-3 rounded mb-4"
                                        style="background-color: #ef5d10; color: white"
                                        >
                                        <i class="bi bi-calendar-range"></i> TẤT CẢ
                                    </h5>

                                    <div class="row">
                                        <div class="col-md-4 text-center mb-3">
                                            <div
                                                class="stat-box p-3 rounded"
                                                style="border: 2px solid #ef5d10"
                                                >
                                                <h3 class="stats-number" style="color: #ef5d10">
                                                    ${allStats.totalOrders}
                                                </h3>
                                                <p class="mb-0"><strong>📦 Tổng Đơn Hàng</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-center mb-3">
                                            <div
                                                class="stat-box p-3 rounded"
                                                style="border: 2px solid #ef5d10"
                                                >
                                                <h3 class="stats-number" style="color: #ef5d10">
                                                    ${allStats.totalReviews}
                                                </h3>
                                                <p class="mb-0"><strong>⭐ Tổng Reviews</strong></p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-center mb-3">
                                            <div
                                                class="stat-box p-3 rounded"
                                                style="border: 2px solid #ef5d10"
                                                >
                                                <div class="mb-2">
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Pending: ${allStats.pending}</span
                                                    >
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Confirmed: ${allStats.confirmed}</span
                                                    >
                                                </div>
                                                <div class="mb-2">
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Preparing: ${allStats.preparing}</span
                                                    >
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Delivery: ${allStats.delivery}</span
                                                    >
                                                </div>
                                                <div>
                                                    <span class="badge" style="background-color: #ef5d10"
                                                          >Delivered: ${allStats.delivered}</span
                                                    >
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row mt-3">
                                        <div class="col-md-12 text-center">
                                            <div class="payment-status">
                                                <small class="text-muted d-block mb-2"
                                                       >Payment Status:</small
                                                >
                                                <span
                                                    class="badge me-2"
                                                    style="background-color: #ef5d10"
                                                    >Unpaid: ${allStats.unpaid}</span
                                                >
                                                <span
                                                    class="badge me-2"
                                                    style="background-color: #ef5d10"
                                                    >Paid: ${allStats.paid}</span
                                                >
                                                <span class="badge" style="background-color: #ef5d10"
                                                      >Refunded: ${allStats.refunded}</span
                                                >
                                            </div>
                                        </div>
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
