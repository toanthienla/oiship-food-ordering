<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff Manage Orders - Create Order</title>

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
            <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
                <div class="container-fluid">
                    <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/dashboard">Oiship</a>
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav ms-auto">
                            <li class="wellcome-text">Welcome, <span><c:out value="${sessionScope.userName}" /></span>!</li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/logout">Logout</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>

            <!--div content-->
            <div class="content mt-5">
                <div class="container">
                    <h2 class="mb-4 text-center">Create New Order</h2>

                    <!-- Hiển thị lỗi nếu có -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger text-center">${error}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success text-center">${success}</div>
                    </c:if>

                    <!-- Form tạo đơn hàng -->
                    <form action="${pageContext.request.contextPath}/staff/manage-orders/create-order" method="post">
                        <!-- Nhập tên khách + Nút tạo đơn -->
                        <div class="mb-4 row">
                            <!-- Customer Name -->
                            <div class="col-md-6 mx-auto d-flex align-items-center mb-3">
                                <label class="me-2 fw-semibold mb-0 flex-shrink-0">Customer Name:</label>
                                <input type="text" name="customerName" class="form-control" placeholder="Enter customer full name" required />
                            </div>

                            <!-- Button -->
                            <div class="col-md-6 mx-auto">
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/staff/manage-orders/create-order"
                                       class="btn btn-secondary w-50 me-2">
                                        Reset
                                    </a>
                                    <button type="submit" class="btn btn-success w-50">
                                        <i class="bi bi-plus-circle"></i> Create Order
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Search + Filter -->
                        <div class="row mb-4 justify-content-center align-items-end">
                            <!-- Search Dish -->
                            <div class="col-md-6">
                                <div class="d-flex align-items-center">
                                    <label class="me-2 fw-semibold mb-0 flex-shrink-0">Search Dish:</label>
                                    <input type="text" id="dishSearch" class="form-control" placeholder="Enter dish name..." />
                                </div>
                            </div>

                            <!-- Filter Category -->
                            <div class="col-md-6 mt-3 mt-md-0">
                                <div class="d-flex align-items-center">
                                    <label class="me-2 fw-semibold mb-0 flex-shrink-0">Filter by Category:</label>
                                    <select id="categoryFilter" class="form-select">
                                        <option value="all">All</option>
                                        <c:forEach var="c" items="${categories}">
                                            <option value="${c.catName}">${c.catName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Danh sách món ăn -->
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle text-center shadow-sm">
                                <thead class="table-dark">
                                    <tr>
                                        <th>#</th>
                                        <th>Dish</th>
                                        <th>Category</th>
                                        <th>Image</th>
                                        <th>Price</th>
                                        <th>Stock</th>
                                        <th>Quantity</th>
                                    </tr>
                                </thead>
                                <tbody id="dishTableBody">
                                    <c:forEach var="dish" items="${dishes}" varStatus="loop">
                                        <tr data-dish="${dish.dishName}" data-category="${dish.category.catName}">
                                            <td>${loop.index + 1}</td>
                                            <td>${dish.dishName}</td>
                                            <td>${dish.category.catName}</td>
                                            <td>
                                                <img src="${dish.image}" alt="${dish.dishName}" width="60" height="60" class="dish-image" />
                                            </td>
                                            <td>${dish.formattedPrice}</td>
                                            <td>${dish.stock}</td>
                                            <td>
                                                <input type="number" name="quantity_${dish.dishID}" class="form-control" min="0" max="${dish.stock}" value="0" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <div id="pagination" class="mt-4 d-flex justify-content-center"></div>

                        </div>

                    </form>
                </div>
            </div>

            <!-- JavaScript Filter -->
            <script>
                function removeVietnameseTones(str) {
                    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "")
                            .replace(/đ/g, "d").replace(/Đ/g, "D");
                }

                document.addEventListener("DOMContentLoaded", () => {
                    const rowsPerPage = 20;
                    const tableBody = document.getElementById("dishTableBody");
                    const rows = Array.from(tableBody.querySelectorAll("tr"));
                    const pagination = document.getElementById("pagination");
                    const searchInput = document.getElementById("dishSearch");
                    const categoryFilter = document.getElementById("categoryFilter");

                    function filterRows() {
                        const keyword = removeVietnameseTones(searchInput.value.trim().toLowerCase());
                        const selectedCategory = categoryFilter.value;

                        return rows.filter(row => {
                            const dishName = removeVietnameseTones(row.dataset.dish?.toLowerCase() || "");
                            const category = row.dataset.category;
                            const matchDish = dishName.includes(keyword);
                            const matchCat = selectedCategory === "all" || category === selectedCategory;
                            return matchDish && matchCat;
                        });
                    }

                    function showPage(filteredRows, page) {
                        tableBody.innerHTML = "";
                        const start = (page - 1) * rowsPerPage;
                        const paginated = filteredRows.slice(start, start + rowsPerPage);
                        paginated.forEach(row => tableBody.appendChild(row));
                        renderPagination(filteredRows.length, page);
                    }

                    function renderPagination(totalRows, currentPage) {
                        pagination.innerHTML = "";
                        const totalPages = Math.ceil(totalRows / rowsPerPage);
                        if (totalPages <= 1)
                            return;

                        const createBtn = (text, page, active = false, disabled = false) => {
                            const btn = document.createElement("button");
                            btn.className = "btn btn-sm mx-1 " + (active ? "btn-primary" : "btn-outline-primary");
                            btn.textContent = text;
                            btn.disabled = disabled;
                            btn.onclick = () => showPage(filterRows(), page);
                            pagination.appendChild(btn);
                        };

                        createBtn("«", currentPage - 1, false, currentPage === 1);

                        for (let i = 1; i <= totalPages; i++) {
                            createBtn(i, i, i === currentPage);
                        }

                        createBtn("»", currentPage + 1, false, currentPage === totalPages);
                    }

                    function init() {
                        showPage(filterRows(), 1);
                    }

                    searchInput.addEventListener("input", () => showPage(filterRows(), 1));
                    categoryFilter.addEventListener("change", () => showPage(filterRows(), 1));
                    init();
                });
            </script>

        </div>
    </body>
</html>