<%-- /WEB-INF/views/staff/ingredientStaff/ingredientStaff.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang chủ Nhân viên Kho - Oiship</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <style>
            body { background-color: #f8f9fa; }
            .navbar-brand { font-weight: bold; color: #ff5733 !important; }
            .dashboard-container { max-width: 1200px; margin: 2rem auto; padding: 2rem; background: white; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
            .table th { background-color: #ff5733; color: white; }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
            <div class="container-fluid">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/ingredient-staff">Oiship Ingredient</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/ingredient-staff">Kho hàng</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Dashboard -->
        <div class="dashboard-container">
            <h3 class="text-center mb-4">Quản lý Kho hàng</h3>
            <c:if test="${not empty requestScope.message}">
                <div class="alert alert-success text-center">${requestScope.message}</div>
            </c:if>
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger text-center">${requestScope.error}</div>
            </c:if>

            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>Mã sản phẩm</th>
                        <th>Tên sản phẩm</th>
                        <th>Số lượng tồn</th>
                        <th>Đơn vị</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${requestScope.inventory}">
                        <tr>
                            <td>${item.productId}</td>
                            <td>${item.productName}</td>
                            <td>${item.quantity}</td>
                            <td>${item.unit}</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/ingredient-staff" method="post" class="d-inline">
                                    <input type="hidden" name="productId" value="${item.productId}"/>
                                    <input type="number" name="restockQuantity" min="1" class="form-control d-inline-block w-50" placeholder="Số lượng"/>
                                    <button type="submit" name="action" value="restock" class="btn btn-sm btn-primary">
                                        <i class="bi bi-plus-circle-fill"></i> Nhập kho
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty requestScope.inventory}">
                        <tr>
                            <td colspan="5" class="text-center">Không có sản phẩm nào trong kho.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>