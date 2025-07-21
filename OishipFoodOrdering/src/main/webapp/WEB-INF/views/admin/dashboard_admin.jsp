<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Oiship</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0/dist/chartjs-plugin-datalabels.min.js"></script>
        <link rel="stylesheet" href="../css/sidebar.css">
        <link rel="stylesheet" href="../css/dashboard.css">
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

        <!-- Main Content -->
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
                <p>Overview of performance. Updated: <fmt:formatDate value="<%= new java.util.Date()%>" pattern="EEE MMM dd HH:mm zzz yyyy" /></p>

       
           

                <!-- Chart Grid -->
                <div class="row">
                    <!-- Order Stats -->
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

                    <!-- Dish Stats -->
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

                    <!-- Payment Stats -->
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

                    <!-- Total Stats -->
                    <div class="col-md-6 mb-4">
                        <div class="card p-4">
                            <div class="card-body">
                                <h5 class="card-title">Total Statistics by Month</h5>
                                <div class="chart-container">
                                    <canvas id="totalChart"></canvas>
                                </div>
                                <div class="error-message" id="totalError"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Optional message -->
                <c:if test="${not empty message}">
                    <div class="alert alert-info mt-3">${message}</div>
                </c:if>
            </div>
        </div>

        <!-- Chart.js Logic -->
        <script>
            function convertToJson(dataList) {
                if (!dataList || dataList.length === 0)
                    return '[]';
                return '[' + dataList.map(item => `{ "label": "${item.label}", "value": ${item.value} }`).join(',') + ']';
            }

            // Injected Java data
            const rawOrderStats = ${orderStats != null ? orderStats : []};
            const rawDishStats = ${dishStats != null ? dishStats : []};
            const rawPaymentStats = ${paymentStats != null ? paymentStats : []};
            const rawTotalStats = ${totalStats != null ? totalStats : []};

            // Convert to JSON string
            const orderStatsData = convertToJson(rawOrderStats);
            const dishStatsData = convertToJson(rawDishStats);
            const paymentStatsData = convertToJson(rawPaymentStats);
            const totalStatsData = convertToJson(rawTotalStats);

            // Parse JSON
            let orderStats, dishStats, paymentStats, totalStats;
            try {
                orderStats = JSON.parse(orderStatsData);
                dishStats = JSON.parse(dishStatsData);
                paymentStats = JSON.parse(paymentStatsData);
                totalStats = JSON.parse(totalStatsData);
            } catch (e) {
                console.error("JSON Parse Error:", e.message);
                orderStats = dishStats = paymentStats = totalStats = [];
            }

            // Create Chart
            function createChart(canvasId, data, label, yAxisLabel, errorId) {
                if (!Array.isArray(data) || data.length === 0) {
                    document.getElementById(errorId).textContent = `No data available for ${label.toLowerCase()}.`;
                    document.getElementById(errorId).style.display = 'block';
                    return;
                }

                new Chart(document.getElementById(canvasId).getContext('2d'), {
                    type: 'bar',
                    data: {
                        labels: data.map(item => item.label),
                        datasets: [{
                                label: label,
                                data: data.map(item => item.value),
                                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                                borderColor: 'rgba(54, 162, 235, 1)',
                                borderWidth: 1
                            }]
                    },
                    options: {
                        indexAxis: 'x',
                        scales: {
                            x: {
                                title: {display: true, text: 'Month'}
                            },
                            y: {
                                beginAtZero: true,
                                title: {display: true, text: yAxisLabel}
                            }
                        },
                        plugins: {
                            legend: {display: true},
                            tooltip: {enabled: true},
                            datalabels: {
                                anchor: 'end',
                                align: 'top',
                                color: '#000',
                                font: {weight: 'bold'},
                                formatter: value => value
                            }
                        },
                        maintainAspectRatio: false
                    },
                    plugins: [ChartDataLabels]
                });
            }

            document.addEventListener('DOMContentLoaded', function () {
                createChart('orderChart', orderStats, 'Number of Orders', 'Orders', 'orderError');
                createChart('dishChart', dishStats, 'Number of Dishes', 'Dishes', 'dishError');
                createChart('paymentChart', paymentStats, 'Payment Amount', 'Amount', 'paymentError');
                createChart('totalChart', totalStats, 'Total Combined Value', 'Total', 'totalError');
            });
        </script>

    </body>
</html>
