<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
                height: 450px;
                margin-bottom: 20px;
            }
            .error-message {
                color: red;
                margin-top: 10px;
                display: none;
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
                <p>Overview of your restaurant's performance and management tools. Updated: <fmt:formatDate value="<%= new java.util.Date()%>" pattern="EEE MMM dd HH:mm zzz yyyy" /></p>

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
                    <!-- Order Statistics by Month -->
                    <div class="col-md-6 mb-4">
                        <div class="card p-4">
                            <div class="card-body">
                                <h5 class="card-title">Order Statistics by Month</h5>
                                <div class="chart-container">
                                    <canvas id="orderChart"></canvas>
                                </div>
                                <div class="error-message" id="orderError"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Dish Statistics by Month -->
                    <div class="col-md-6 mb-4">
                        <div class="card p-4">
                            <div class="card-body">
                                <h5 class="card-title">Dish Statistics by Month</h5>
                                <div class="chart-container">
                                    <canvas id="dishChart"></canvas>
                                </div>
                                <div class="error-message" id="dishError"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Statistics by Month -->
                    <div class="col-md-6 mb-4">
                        <div class="card p-4">
                            <div class="card-body">
                                <h5 class="card-title">Payment Statistics by Month</h5>
                                <div class="chart-container">
                                    <canvas id="paymentChart"></canvas>
                                </div>
                                <div class="error-message" id="paymentError"></div>
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
            // Hàm chuyển đổi List<ChartData> thành chuỗi JSON trong JavaScript
            function convertToJson(dataList) {
                if (!dataList || dataList.length === 0)
                    return '[]';
                return '[' + dataList.map(item =>
                        `{ "label": "${item.label}", "value": ${item.value} }`
                ).join(',') + ']';
            }

            // Dữ liệu thô từ servlet
            const rawOrderStats = ${orderStats != null ? orderStats : []};
            const rawDishStats = ${dishStats != null ? dishStats : []};
            const rawPaymentStats = ${paymentStats != null ? paymentStats : []};

            // Chuyển đổi thành chuỗi JSON
            const orderStatsData = convertToJson(rawOrderStats);
            const dishStatsData = convertToJson(rawDishStats);
            const paymentStatsData = convertToJson(rawPaymentStats);

            // Chuyển đổi thành mảng JavaScript với kiểm tra lỗi
            let orderStats, dishStats, paymentStats;
            try {
                orderStats = JSON.parse(orderStatsData);
                dishStats = JSON.parse(dishStatsData);
                paymentStats = JSON.parse(paymentStatsData);
            } catch (e) {
                console.error('JSON Parse Error:', e.message);
                console.log('OrderStatsData:', orderStatsData);
                console.log('DishStatsData:', dishStatsData);
                console.log('PaymentStatsData:', paymentStatsData);
                orderStats = [];
                dishStats = [];
                paymentStats = [];
            }

            // Debug log
            console.log('OrderStats:', orderStats);
            console.log('DishStats:', dishStats);
            console.log('PaymentStats:', paymentStats);

            // Hàm tạo biểu đồ với trục ngang là tháng, trục đứng là số lượng/tổng, thêm nhãn giá trị
            function createChart(ctxId, data, label, yAxisLabel, errorId) {
                try {
                    if (!Array.isArray(data) || data.length === 0) {
                        document.getElementById(errorId).textContent = 'No data available for ' + label.toLowerCase() + '.';
                        document.getElementById(errorId).style.display = 'block';
                        return;
                    }

                    new Chart(document.getElementById(ctxId).getContext('2d'), {
                        type: 'bar',
                        data: {
                            labels: data.map(item => item.label), // Trục ngang: Tháng
                            datasets: [{
                                    label: label,
                                    data: data.map(item => item.value), // Trục đứng: Số lượng/tổng
                                    backgroundColor: [
                                        'rgba(54, 162, 235, 0.6)', // Màu xanh dương
                                        'rgba(75, 192, 192, 0.6)', // Màu xanh lá
                                        'rgba(255, 99, 132, 0.6)', // Màu hồng
                                        'rgba(255, 205, 86, 0.6)'  // Màu vàng
                                    ],
                                    borderColor: [
                                        'rgba(54, 162, 235, 1)',
                                        'rgba(75, 192, 192, 1)',
                                        'rgba(255, 99, 132, 1)',
                                        'rgba(255, 205, 86, 1)'
                                    ],
                                    borderWidth: 1
                                }]
                        },
                        options: {
                            indexAxis: 'x', // Trục ngang là x
                            scales: {
                                x: {
                                    title: {
                                        display: true,
                                        text: 'Month'
                                    },
                                    ticks: {
                                        autoSkip: false,
                                        maxRotation: 0,
                                        minRotation: 0
                                    }
                                },
                                y: {
                                    beginAtZero: true,
                                    title: {
                                        display: true,
                                        text: yAxisLabel
                                    }
                                }
                            },
                            plugins: {
                                legend: {
                                    display: true
                                },
                                tooltip: {
                                    enabled: true
                                },
                                datalabels: {
                                    anchor: 'end',
                                    align: 'top',
                                    formatter: (value) => value,
                                    color: '#000',
                                    font: {
                                        weight: 'bold'
                                    }
                                }
                            },
                            maintainAspectRatio: false
                        }
                    });
                } catch (e) {
                    document.getElementById(errorId).textContent = 'Error loading ' + label.toLowerCase() + ' chart: ' + e.message;
                    document.getElementById(errorId).style.display = 'block';
                }
            }

            // Tải plugin Chart.js Data Labels
            Chart.register(ChartDataLabels);

            // Tạo các biểu đồ khi DOM sẵn sàng
            document.addEventListener('DOMContentLoaded', function () {
                createChart('orderChart', orderStats, 'Number of Orders', 'Orders', 'orderError');
                createChart('dishChart', dishStats, 'Number of Dishes', 'Dishes', 'dishError');
                createChart('paymentChart', paymentStats, 'Payment Amount (USD)', 'Amount (USD)', 'paymentError');
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0/dist/chartjs-plugin-datalabels.min.js"></script>
    </body>
</html>