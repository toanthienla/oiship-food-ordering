<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Oiship</title>

        <!-- Bootstrap 5 CSS & JS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Chart.js for Charts -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

        <!-- CSS for Dashboard -->
        <link rel="stylesheet" href="../css/sidebar.css">
        <link rel="stylesheet" href="../css/dashboard.css">

        <!-- JS for Sidebar -->
        <script src="../js/sidebar.js"></script>

        <style>
            .topbar {
                padding: 10px 20px;
                background: #e9ecef;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .profile .username {
                font-weight: 500;
                margin-right: 10px;
            }
            .content {
                padding: 20px;
            }
            .chart-container {
                position: relative;
                height: 300px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <jsp:include page="admin_sidebar.jsp" />

        <!-- Main Section -->
        <div class="main" id="main">
            <!-- Topbar -->
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile">
                    <span class="username">Hi, <c:out value="${sessionScope.userName}" default="Admin" /></span>
                </div>
            </div>

            <!-- Content -->
            <div class="content">
                <h1>Admin Dashboard</h1>
                <p>Overview of your restaurant's performance and management tools. Updated: Wed Jun 18 14:50 ICT 2025</p>

                <!-- Search and Action Bar -->
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/admin/accounts" method="get" class="d-flex">
                            <input class="form-control me-2" type="search" name="search" placeholder="Search accounts" value="${param.search}">
                            <button class="btn btn-outline-success" type="submit">Search</button>
                        </form>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="row">
                    <!-- Order Statistics -->
                    <div class="col-md-6 mb-4">
                        <div class="card p-4">
                            <div class="card-body">
                                <h5 class="card-title">Order Statistics</h5>
                                <div class="chart-container">
                                    <canvas id="orderChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Ingredient Statistics -->
                    <div class="col-md-6 mb-4">
                        <div class="card p-4">
                            <div class="card-body">
                                <h5 class="card-title">Ingredient Statistics</h5>
                                <div class="chart-container">
                                    <canvas id="ingredientChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Dish Statistics -->
                    <div class="col-md-6 mb-4">
                        <div class="card p-4">
                            <div class="card-body">
                                <h5 class="card-title">Dish Statistics</h5>
                                <div class="chart-container">
                                    <canvas id="dishChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Voucher Statistics -->
                    <div class="col-md-6 mb-4">
                        <div class="card p-4">
                            <div class="card-body">
                                <h5 class="card-title">Voucher Statistics</h5>
                                <div class="chart-container">
                                    <canvas id="voucherChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty message}">
                    <div class="alert alert-info mt-3">${message}</div>
                </c:if>
            </div>
        </div>

        <script>
            // Sample data (to be replaced with actual data from servlet)
            const orderStats = ${orderStats != null ? orderStats : '[]'};
            const ingredientStats = ${ingredientStats != null ? ingredientStats : '[]'};
            const dishStats = ${dishStats != null ? dishStats : '[]'};
            const voucherStats = ${voucherStats != null ? voucherStats : '[]'};

            // Order Chart
            const orderCtx = document.getElementById('orderChart').getContext('2d');
            new Chart(orderCtx, {
                type: 'bar',
                data: {
                    labels: orderStats.map(item => item.label),
                    datasets: [{
                            label: 'Number of Orders',
                            data: orderStats.map(item => item.value),
                            backgroundColor: 'rgba(54, 162, 235, 0.6)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Orders'
                            }
                        }
                    }
                }
            });

            // Ingredient Chart
            const ingredientCtx = document.getElementById('ingredientChart').getContext('2d');
            new Chart(ingredientCtx, {
                type: 'bar',
                data: {
                    labels: ingredientStats.map(item => item.label),
                    datasets: [{
                            label: 'Ingredient Usage',
                            data: ingredientStats.map(item => item.value),
                            backgroundColor: 'rgba(255, 99, 132, 0.6)',
                            borderColor: 'rgba(255, 99, 132, 1)',
                            borderWidth: 1
                        }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Usage (kg)'
                            }
                        }
                    }
                }
            });

            // Dish Chart
            const dishCtx = document.getElementById('dishChart').getContext('2d');
            new Chart(dishCtx, {
                type: 'bar',
                data: {
                    labels: dishStats.map(item => item.label),
                    datasets: [{
                            label: 'Dish Sales',
                            data: dishStats.map(item => item.value),
                            backgroundColor: 'rgba(75, 192, 192, 0.6)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1
                        }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Sales'
                            }
                        }
                    }
                }
            });

            // Voucher Chart
            const voucherCtx = document.getElementById('voucherChart').getContext('2d');
            new Chart(voucherCtx, {
                type: 'bar',
                data: {
                    labels: voucherStats.map(item => item.label),
                    datasets: [{
                            label: 'Voucher Usage',
                            data: voucherStats.map(item => item.value),
                            backgroundColor: 'rgba(255, 206, 86, 0.6)',
                            borderColor: 'rgba(255, 206, 86, 1)',
                            borderWidth: 1
                        }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Usage Count'
                            }
                        }
                    }
                }
            });
        </script>
</html>