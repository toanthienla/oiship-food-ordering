<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Arrays"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

        <!--CSS for Dashboard-->
        <link rel="stylesheet" href="<c:url value='/css/dashboard.css' />" />

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
        <jsp:include page="staff_sidebar.jsp" />

        <!-- div.main -->
        <div class="main">
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile"><span class="username">Hi, <span><c:out value="${sessionScope.userName}" /></span></span></div>
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
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            <%
                Map<Integer, Double> monthlyIncomeMap = (Map<Integer, Double>) request.getAttribute("monthlyIncomeMap");
                List<String> monthNames = Arrays.asList("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
                StringBuilder labelsJs = new StringBuilder("[");
                StringBuilder incomeDataJs = new StringBuilder("[");
                StringBuilder backgroundColorsJs = new StringBuilder("[");
                StringBuilder borderColorsJs = new StringBuilder("[");

                for (int i = 1; i <= 12; i++) {
                    if (i > 1) {
                        labelsJs.append(",");
                        incomeDataJs.append(",");
                        backgroundColorsJs.append(",");
                        borderColorsJs.append(",");
                    }
                    labelsJs.append("\"").append(monthNames.get(i - 1)).append("\"");

                    double income = (monthlyIncomeMap != null && monthlyIncomeMap.get(i) != null) ? monthlyIncomeMap.get(i) : 0.0;
                    incomeDataJs.append(income);
                    
                    if (income >= 0) {
                        backgroundColorsJs.append("'rgba(40, 167, 69, 0.6)'");
                        borderColorsJs.append("'rgba(40, 167, 69, 1)'");
                    } else {
                        backgroundColorsJs.append("'rgba(220, 53, 69, 0.6)'");
                        borderColorsJs.append("'rgba(220, 53, 69, 1)'");
                    }
                }
                labelsJs.append("]");
                incomeDataJs.append("]");
                backgroundColorsJs.append("]");
                borderColorsJs.append("]");
            %>

            const labels = <%= labelsJs.toString()%>;
            const incomeData = <%= incomeDataJs.toString()%>;
            const backgroundColors = <%= backgroundColorsJs.toString()%>;
            const borderColors = <%= borderColorsJs.toString()%>;
            const selectedYear = <%= request.getAttribute("selectedYear") != null ? request.getAttribute("selectedYear") : java.time.Year.now().getValue()%>;

            const ctx = document.getElementById('incomeChart').getContext('2d');
            const incomeChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: 'Income in ' + selectedYear,
                            data: incomeData,
                            backgroundColor: backgroundColors,
                            borderColor: borderColors,
                            borderWidth: 1,
                            maxBarThickness: 30
                        }
                    ]
                },
                options: {
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const value = context.parsed.y;
                                    return context.dataset.label + ': ' + value.toLocaleString() + ' VND';
                                }
                            }
                        }
                    },
                    responsive: true,
                    scales: {
                        x: {
                            grid: {display: false}
                        },
                        y: {
                            beginAtZero: true,
                            grid: {color: "#eee"},
                            title: {
                                display: true,
                                text: 'Amount (VND)'
                            },
                            ticks: {
                                callback: function(value) {
                                    return value.toLocaleString();
                                }
                            }
                        }
                    }
                }
            });
        </script>
    </body>
</html>