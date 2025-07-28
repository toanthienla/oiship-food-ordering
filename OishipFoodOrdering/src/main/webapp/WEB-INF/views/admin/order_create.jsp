<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Manage Orders - Create Order</title>

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
        <jsp:include page="admin_sidebar.jsp" />

        <div class="main">
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile"><span class="username">Hi, Admin</span></div>
            </div>
            <!--div content-->
            <div class="content">
                <div class="container">
                    <h1>Create New Order</h1>


                    <!-- Hiển thị lỗi nếu có -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger text-center">${error}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success text-center">${success}</div>
                    </c:if>

                    <!-- Form tạo đơn hàng -->
                    <form action="${pageContext.request.contextPath}/admin/manage-orders/create-order" method="post">
                        <!-- Nhập tên khách + Nút tạo đơn + Tổng tiền -->
                        <div class="row align-items-center mb-4">
                            <!-- Nhập tên khách -->
                            <div class="col-md-5 d-flex align-items-center">
                                <label class="me-2 fw-semibold mb-0 flex-shrink-0">Customer Name:</label>
                                <input type="text" name="customerName" class="form-control" placeholder="Enter customer full name" required />
                            </div>

                            <!-- Tổng tiền -->
                            <div class="col-md-4 text-end">
                                <h6 class="mb-0 fw-semibold">
                                    Total: <span class="text-success fw-bold" id="totalAmount">0</span> VNĐ
                                </h6>
                            </div>

                            <!-- Nút tạo đơn -->
                            <div class="col-md-3 text-end">
                                <div class="d-flex justify-content-end">
                                    <a href="${pageContext.request.contextPath}/admin/manage-orders/create-order" class="btn btn-secondary me-2">
                                        Reset
                                    </a>
                                    <button type="submit" class="btn btn-success">
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
                            <table class="table table-bordered table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Dish</th>
                                        <th>Image</th>
                                        <th>Category</th>
                                        <th>Price</th>
                                        <th>Stock</th>
                                        <th>Quantity</th>
                                    </tr>
                                </thead>
                                <tbody id="dishTableBody">
                                    <c:forEach var="dish" items="${dishes}" varStatus="loop">
                                        <tr data-dish="${dish.dishName}" data-category="${dish.category.catName}">
                                            <td class="fw-bold text-center">${loop.index + 1}</td>
                                            <td>${dish.dishName}</td>
                                            <td class="text-center">
                                                <img src="${dish.image}" alt="${dish.dishName}" width="70" height="40"
                                                     class="dish-image"
                                                     style="cursor: pointer;"
                                                     onclick="showImageModal('${dish.image}')" />

                                            </td>
                                            <td>${dish.category.catName}</td>

                                            <td data-price="${dish.formattedPrice.replaceAll('[^\\d]', '')}" class="price-cell">
                                                ${dish.formattedPrice}
                                            </td>
                                            <td class="stock-cell text-center">${dish.stock}</td>
                                            <td>
                                                <input type="number" name="quantity_${dish.dishID}" class="form-control" min="0" max="${dish.stock}" value="0" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                    </form>
                </div>
            </div>

            <!-- Modal để hiển thị ảnh phóng to -->
            <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg"> <!-- modal-lg để ảnh to -->
                    <div class="modal-content">
                        <div class="modal-body text-center">
                            <img id="modalImage" src="" class="img-fluid" alt="Dish Image" />
                        </div>
                    </div>
                </div>
            </div>


            <!-- JavaScript Filter -->
            <script>
                function removeVietnameseTones(str) {
                    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "")
                            .replace(/đ/g, "d").replace(/Đ/g, "D");
                }

                document.addEventListener("DOMContentLoaded", () => {
                    const searchInput = document.getElementById("dishSearch");
                    const categoryFilter = document.getElementById("categoryFilter");
                    const rows = document.querySelectorAll("table tbody tr");

                    function filterDishes() {
                        const keyword = removeVietnameseTones(searchInput.value.trim().toLowerCase());
                        const selectedCat = categoryFilter.value;

                        rows.forEach(row => {
                            const dishName = removeVietnameseTones(row.getAttribute("data-dish")?.toLowerCase() || "");
                            const category = row.getAttribute("data-category");

                            const matchSearch = dishName.includes(keyword);
                            const matchCategory = selectedCat === "all" || category === selectedCat;

                            row.style.display = (matchSearch && matchCategory) ? "" : "none";
                        });
                    }

                    searchInput.addEventListener("input", filterDishes);
                    categoryFilter.addEventListener("change", filterDishes);
                });

                //tính tổng tiền
                document.addEventListener("DOMContentLoaded", () => {
                    const quantityInputs = document.querySelectorAll("input[name^='quantity_']");
                    const totalAmountElement = document.getElementById("totalAmount");

                    function calculateTotal() {
                        let total = 0;
                        quantityInputs.forEach(input => {
                            const quantity = parseInt(input.value) || 0;
                            const priceCell = input.closest("tr").querySelector(".price-cell");
                            const price = parseInt(priceCell?.getAttribute("data-price") || "0");
                            total += quantity * price;
                        });
                        totalAmountElement.textContent = total.toLocaleString("vi-VN");
                    }

                    quantityInputs.forEach(input => {
                        input.addEventListener("input", calculateTotal);
                    });

                    calculateTotal(); // tính lần đầu khi trang load
                });

                function showImageModal(imageSrc) {
                    const modalImage = document.getElementById("modalImage");
                    modalImage.src = imageSrc;
                    const modal = new bootstrap.Modal(document.getElementById('imageModal'));
                    modal.show();
                }
            </script>

        </div>
        <!-- Bootstrap Bundle JS (có Popper) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>