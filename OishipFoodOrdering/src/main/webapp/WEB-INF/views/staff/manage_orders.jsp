<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff - Manage Orders</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />

        <!-- Sidebar CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css" />

        <!-- Sidebar JS -->
        <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', sans-serif;
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

            .wellcome-text{
                padding: 8px;
            }

            .truncate {
                max-width: 180px;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .bg-purple-light {
                background-color: #e6ccff !important;  /* Tím nhạt */
                color: #000 !important;                /* Chữ đen */
                border: 1px solid #d6b3ff !important;  /* Viền tím nhạt */
            }

            /* Profit styling */
            .profit-amount {
                color: #28a745;
                font-weight: bold;
            }

            .profit-zero {
                color: #6c757d;
                font-style: italic;
            }

            .profit-amount:not(.profit-zero):before {
                content: "+";
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

        <div class="main">
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile"><span class="username">Hi, <span><c:out value="${sessionScope.userName}" /></span></span></div>
            </div>

            <!-- Content -->
            <div class="content">
                <h1>Manage Orders</h1>

                <!-- Search + Filter + Create Order -->
                <div class="row mb-4 align-items-end">
                    <!-- Search -->
                    <div class="col-md-5">
                        <div class="d-flex align-items-center">
                            <label class="me-2 fw-semibold mb-0 flex-shrink-0">Search Customer:</label>
                            <input type="text" id="customerSearch" class="form-control" placeholder="Enter customer name..." />
                        </div>
                    </div>

                    <!-- Filter -->
                    <div class="col-md-5 mt-3 mt-md-0">
                        <div class="d-flex align-items-center">
                            <label class="me-2 fw-semibold mb-0 flex-shrink-0">Filter by Status:</label>
                            <select id="statusFilter" class="form-select">
                                <option value="all">All</option>
                                <option value="0">Pending</option>
                                <option value="1">Confirmed</option>
                                <option value="2">Preparing</option>
                                <option value="3">Out for Delivery</option>
                                <option value="4">Delivered</option>
                                <option value="5">Cancelled</option>
                                <option value="6">Failed</option>
                            </select>
                        </div>
                    </div>

                    <!-- Create Order -->
                    <div class="col-md-2 mt-3 mt-md-0 text-md-end">
                        <a href="${pageContext.request.contextPath}/staff/manage-orders/create-order" class="btn btn-success w-100">
                            <i class="bi bi-plus-circle"></i> Create
                        </a>
                    </div>
                </div>

                <!-- Orders Table -->
                <div class="table-responsive">
                    <table id="orderTable" class="table table-bordered table-hover">
                        <thead class="table-light">
                            <tr>
                                <th class="text-center">#</th>
                                <th class="text-center">Order ID</th>
                                <th>Customer</th>
                                <th>Voucher</th>
                                <th>Amount</th>
                                <th>Profit</th> <!-- Added Profit Column -->
                                <th>Payment</th>
                                <th>Status</th>
                                <th>Last Update</th>
                                <th>Address</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="orderTableBody" class="text-start">
                            <c:forEach var="o" items="${orders}" varStatus="status">
                                <tr data-customer="${o.customerName}" data-status="${o.orderStatus}">
                                    <td class="text-center">${status.index + 1}</td> <!-- Removed text-center -->
                                    <td class="text-center">${o.orderID}</td> <!-- Removed text-center -->
                                    <td class="truncate">${o.customerName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty o.voucherCode}">
                                                <span class="text-muted">N/A</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${o.voucherCode}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatNumber value="${o.amount}" type="number" groupingUsed="true"/></td> <!-- Removed text-center -->

                                    <!-- Profit Column -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty orderProfitMap[o.orderID]}">
                                                <c:set var="profitValue" value="${orderProfitRawMap[o.orderID]}" />
                                                <c:choose>
                                                    <c:when test="${profitValue eq 0}">
                                                        <span class="profit-zero">0 VND</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="profit-amount">${orderProfitMap[o.orderID]}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td> <!-- Removed text-center -->
                                        <c:choose>
                                            <c:when test="${o.paymentStatus == 0}">
                                                <span class="badge rounded-pill text-bg-danger">Unpaid</span>
                                            </c:when>
                                            <c:when test="${o.paymentStatus == 1}">
                                                <span class="badge rounded-pill text-bg-success">Paid</span>
                                            </c:when>
                                            <c:when test="${o.paymentStatus == 2}">
                                                <span class="badge rounded-pill text-bg-warning text-dark">Refunded</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge rounded-pill text-bg-secondary">Unknown</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.orderStatus == 0}">Pending</c:when>
                                            <c:when test="${o.orderStatus == 1}">Confirmed</c:when>
                                            <c:when test="${o.orderStatus == 2}">Preparing</c:when>
                                            <c:when test="${o.orderStatus == 3}">Out for Delivery</c:when>
                                            <c:when test="${o.orderStatus == 4}">Delivered</c:when>
                                            <c:when test="${o.orderStatus == 5}">Cancelled</c:when>
                                            <c:when test="${o.orderStatus == 6}">Failed</c:when>
                                            <c:otherwise>Unknown</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td> <!-- Removed text-center -->
                                        <c:choose>
                                            <c:when test="${not empty o.lastUpdated}">
                                                ${o.lastUpdated}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="truncate">
                                        <c:choose>
                                            <c:when test="${not empty o.address}">
                                                ${o.address}
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="align-middle"> <!-- Removed text-center -->
                                        <div class="d-flex justify-content-start align-items-center flex-wrap gap-2" style="min-width: 350px;"> <!-- Changed to justify-content-start -->
                                            <a class="btn btn-sm btn-primary fw-semibold text-white"
                                               href="${pageContext.request.contextPath}/staff/manage-orders/update-status?orderID=${o.orderID}">
                                                Detail
                                            </a>
                                            <!-- Dropdown Update Status -->
                                            <form method="post" action="${pageContext.request.contextPath}/staff/manage-orders" style="display:inline-block;">
                                                <input type="hidden" name="orderId" value="${o.orderID}" />
                                                <select name="status" class="form-select form-select-sm w-auto d-inline-block fw-semibold text-dark bg-warning border-warning" onchange="this.form.submit()">
                                                    <c:forEach var="entry" items="${statusMap}">
                                                        <c:set var="key" value="${entry.key}" />
                                                        <c:set var="value" value="${entry.value}" />
                                                        <option value="${key}" <c:if test="${key == o.orderStatus}">selected</c:if>>${value}</option>
                                                    </c:forEach>
                                                </select>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/staff/manage-orders" style="display:inline-block;">
                                                <input type="hidden" name="orderId" value="${o.orderID}" />
                                                <select name="paymentStatus" class="form-select form-select-sm w-auto d-inline-block fw-semibold bg-purple-light"
                                                        onchange="this.form.submit()">
                                                    <c:forEach var="entry" items="${paymentStatusMap}">
                                                        <c:set var="key" value="${entry.key}" />
                                                        <c:set var="value" value="${entry.value}" />
                                                        <option value="${key}" <c:if test="${key == o.paymentStatus}">selected</c:if>>${value}</option>
                                                    </c:forEach>
                                                </select>
                                            </form>
                                        </div>
                                    </td>

                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div id="orderPagination" class="mt-4 d-flex justify-content-center"></div>

            </div>

            <!-- JavaScript Filter -->
            <script>
                document.addEventListener("DOMContentLoaded", () => {
                    const rowsPerPage = 20;
                    const tableBody = document.getElementById("orderTableBody");
                    const rows = Array.from(tableBody.querySelectorAll("tr"));
                    const pagination = document.getElementById("orderPagination");
                    const searchInput = document.getElementById("customerSearch");
                    const statusFilter = document.getElementById("statusFilter");

                    function removeVietnameseTones(str) {
                        return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "")
                                .replace(/đ/g, "d").replace(/Đ/g, "D");
                    }

                    function filterRows() {
                        const keyword = removeVietnameseTones(searchInput.value.trim().toLowerCase());
                        const selectedStatus = statusFilter.value;

                        return rows.filter(row => {
                            const customer = removeVietnameseTones(row.getAttribute("data-customer")?.toLowerCase() || "");
                            const status = row.getAttribute("data-status");
                            const matchSearch = customer.includes(keyword);
                            const matchStatus = selectedStatus === "all" || status === selectedStatus;
                            return matchSearch && matchStatus;
                        });
                    }

                    function showPage(filteredRows, page) {
                        tableBody.innerHTML = "";
                        const start = (page - 1) * rowsPerPage;
                        const end = start + rowsPerPage;
                        const paginated = filteredRows.slice(start, end);
                        paginated.forEach(row => tableBody.appendChild(row));
                        renderPagination(filteredRows.length, page);
                    }

                    function renderPagination(totalRows, currentPage) {
                        pagination.innerHTML = "";
                        const totalPages = Math.ceil(totalRows / rowsPerPage);
                        if (totalPages <= 1)
                            return;

                        const createButton = (text, page, active = false, disabled = false) => {
                            const btn = document.createElement("button");
                            btn.className = "btn btn-sm mx-1 " + (active ? "btn-primary" : "btn-outline-primary");
                            btn.textContent = text;
                            btn.disabled = disabled;
                            btn.onclick = () => showPage(filterRows(), page);
                            pagination.appendChild(btn);
                        };

                        createButton("Previous", currentPage - 1, false, currentPage === 1);
                        for (let i = 1; i <= totalPages; i++) {
                            createButton(i, i, i === currentPage);
                        }
                        createButton("Next", currentPage + 1, false, currentPage === totalPages);
                    }

                    function init() {
                        showPage(filterRows(), 1);
                    }

                    // Event listeners
                    searchInput.addEventListener("input", () => showPage(filterRows(), 1));
                    statusFilter.addEventListener("change", () => showPage(filterRows(), 1));

                    // Initialize
                    init();
                });
            </script>

        </div>
    </body>
</html>