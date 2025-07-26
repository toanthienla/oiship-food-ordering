<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff - Manage Reviews</title>

        <!-- Bootstrap 5 CSS & JS -->
        <link rel="stylesheet" href="../css/bootstrap.css" />
        <script src="../js/bootstrap.bundle.js"></script>

        <!--CSS for Sidebar-->
        <link rel="stylesheet" href="../css/sidebar.css" />

        <!--JS for Sidebar-->
        <script src="../js/sidebar.js"></script>

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

        <!-- Main Section -->
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

            <!-- Content -->
            <div class="content">
                <h1>Manage Reviews</h1>

                <!-- Search and Filter -->
                <div class="row mb-4">
                    <!-- Search Dish -->
                    <div class="col-md-6">
                        <div class="d-flex align-items-center">
                            <label for="dishSearch" class="me-2 fw-semibold mb-0 flex-shrink-0">Search Dish:</label>
                            <input type="text" id="dishSearch" class="form-control" placeholder="Enter dish name..." />
                        </div>
                    </div>
                    <!-- Filter -->
                    <div class="col-md-6">
                        <div class="d-flex align-items-center">
                            <label class="me-2 fw-semibold mb-0 flex-shrink-0">Filter by Star:</label>
                            <select id="starFilter" class="form-select">
                                <option value="">All</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Reviews Table -->
                <div class="table-responsive">
                    <table id="reviewTable" class="table table-bordered table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Review ID</th>
                                <th>Dish</th>
                                <th>Category</th>
                                <th>Customer</th>
                                <th>Rating</th>
                                <th>Comment</th>
                                <th>Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="reviewTableBody" class="text-start">
                            <c:forEach var="r" items="${reviews}" varStatus="loop">
                                <tr data-category="${r.catName}">
                                    <td class="fw-bold text-center">${loop.index + 1}</td>
                                    <td class="text-center">${r.reviewID}</td>
                                    <td>${r.dishName}</td>
                                    <td>${r.catName}</td>
                                    <td class="truncate">${r.customerName}</td>
                                    <td>
                                        <span class="badge bg-warning text-dark fs-6">${r.rating} ★</span>
                                    </td>
                                    <td class="text-start truncate">${r.comment}</td>
                                    <td><small class="text-muted">
                                            <fmt:formatDate value="${r.reviewCreatedAt}" pattern="dd-MM-yyyy HH:mm:ss" />
                                        </small>
                                    </td>
                                    <td>
                                        <a href="manage-reviews?action=delete&reviewID=${r.reviewID}"
                                           class="btn btn-sm btn-danger fw-semibold"
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa đánh giá này không?');">
                                            Delete
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div id="pagination" class="mt-4 d-flex justify-content-center"></div>

                </div>
            </div>

            <!-- JavaScript search and pagination -->
            <script>
                document.addEventListener("DOMContentLoaded", () => {
                    const rowsPerPage = 20;
                    const tableBody = document.getElementById("reviewTableBody");
                    const rows = Array.from(tableBody.querySelectorAll("tr"));
                    const pagination = document.getElementById("pagination");
                    const searchInput = document.getElementById("dishSearch");
                    const starFilter = document.getElementById("starFilter");

                    function removeVietnameseTones(str) {
                        return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "")
                                .replace(/đ/g, "d").replace(/Đ/g, "D");
                    }

                    function filterRows() {
                        const keyword = removeVietnameseTones(searchInput.value.trim().toLowerCase());
                        const selectedStar = starFilter.value;

                        return rows.filter(row => {
                            const dish = removeVietnameseTones(row.children[2].textContent.toLowerCase());
                            const rating = row.children[5].textContent.trim().split(" ")[0];
                            const matchDish = dish.includes(keyword);
                            const matchStar = selectedStar === "" || rating === selectedStar;
                            return matchDish && matchStar;
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

                    searchInput.addEventListener("input", () => showPage(filterRows(), 1));
                    starFilter.addEventListener("change", () => showPage(filterRows(), 1));

                    init();
                });
            </script>

        </div>
    </body>
</html>