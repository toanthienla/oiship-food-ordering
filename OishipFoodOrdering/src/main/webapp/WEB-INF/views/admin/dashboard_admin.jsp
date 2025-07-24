<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Arrays"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Statistics Dashboard</title>

    <!-- Bootstrap 5 CSS & JS -->
    <link rel="stylesheet" href="<c:url value='/css/bootstrap.css' />" />
    <script src="<c:url value='/js/bootstrap.bundle.js' />"></script>

    <!--CSS for Dashboard-->
    <link rel="stylesheet" href="<c:url value='/css/sidebar.css' />" />
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css' />" />

    <!--JS for Sidebar-->
    <script src="<c:url value='/js/sidebar.js' />"></script>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0/dist/chartjs-plugin-datalabels.min.js"></script>

    <style>
        .year-select-form {
            margin-bottom: 0;
        }
        .year-select {
            width: 120px;
            display: inline-block;
        }
        .chart-container {
            position: relative;
            width: 100%;
            min-width: 350px;
            height: 420px;
            margin-bottom: 20px;
        }
        #incomeChart {
            width: 100% !important;
            height: 400px !important;
            max-width: 100vw;
            display: block;
        }
        .card.mb-4 {
            border-radius: 10px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
        }
        .card-header {
            border-radius: 10px 10px 0 0;
            background: #f8fafc;
            font-weight: 500;
            color: #222;
            font-size: 1.1rem;
            border-bottom: 1px solid #eaeaea;
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
                <span class="username">Hi, Admin</span>
            </div>
        </div>

        <!-- Content -->
        <div class="content">
            <h1>Statistics Dashboard</h1>
            <p>Overview of your platform's income trends.</p>

            <!-- Income Statistics Chart -->
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Income Statistics (Monthly)</h5>
                    <form method="get" action="" class="year-select-form">
                        <select name="year" onchange="this.form.submit()" class="form-select year-select">
                            <%
                                List<Integer> years = (List<Integer>) request.getAttribute("availableYears");
                                int selectedYear = (request.getAttribute("selectedYear") != null)
                                        ? (Integer) request.getAttribute("selectedYear")
                                        : java.time.Year.now().getValue();
                                if (years != null) {
                                    for (Integer y : years) {
                            %>
                            <option value="<%=y%>" <%= (y == selectedYear) ? "selected" : ""%>><%=y%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </form>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="incomeChart"></canvas>
                    </div>
                </div>
            </div>
            <!-- End Income Chart -->
        </div>
    </div>
    <script>
        // Prepare chart data from backend attributes
        <% 
            Map<Integer, Double> monthlyIncomeMap = (Map<Integer, Double>) request.getAttribute("monthlyIncomeMap");
            List<String> monthNames = Arrays.asList("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                                                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
            StringBuilder labelsJs = new StringBuilder("[");
            StringBuilder dataJs = new StringBuilder("[");
            for (int i = 1; i <= 12; i++) {
                if (i > 1) {
                    labelsJs.append(",");
                    dataJs.append(",");
                }
                labelsJs.append("\"").append(monthNames.get(i - 1)).append("\"");
                double income = (monthlyIncomeMap != null && monthlyIncomeMap.get(i) != null) ? monthlyIncomeMap.get(i) : 0.0;
                dataJs.append(income);
            }
            labelsJs.append("]");
            dataJs.append("]");
        %>
        const labels = <%= labelsJs.toString()%>;
        const data = <%= dataJs.toString()%>;
        const selectedYear = <%= request.getAttribute("selectedYear") != null ? request.getAttribute("selectedYear") : java.time.Year.now().getValue()%>;

        const ctx = document.getElementById('incomeChart').getContext('2d');
        const incomeChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                        label: 'Income in ' + selectedYear,
                        data: data,
                        backgroundColor: 'rgba(13, 110, 253, 0.6)',
                        borderColor: 'rgba(13, 110, 253, 1)',
                        borderWidth: 1,
                        maxBarThickness: 38
                    }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    datalabels: {
                        display: true,
                        color: '#000',
                        anchor: 'end',
                        align: 'top',
                        formatter: function (value) {
                            return value.toLocaleString();
                        }
                    }
                },
                responsive: true,
                scales: {
                    x: {
                        grid: { display: false }
                    },
                    y: {
                        beginAtZero: true,
                        grid: { color: "#eee" },
                        title: {
                            display: true,
                            text: 'Income (VND)'
                        }
                    }
                }
            },
            plugins: [ChartDataLabels]
        });
    </script>
</body>
</html>