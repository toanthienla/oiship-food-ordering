
<%@page import="model.Customer"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Staff - My Profile</title>

        <!-- Bootstrap 5 CSS & JS -->
        <link rel="stylesheet" href="../css/bootstrap.css" />
        <script src="../js/bootstrap.bundle.js"></script>

        <!--CSS for Sidebar-->
        <link rel="stylesheet" href="../css/sidebar.css" />

        <!--JS for Sidebar-->
        <script src="../js/sidebar.js"></script>

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
        <jsp:include page="customer_sidebar.jsp" />

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
            <!-- Profile Content -->
            <div class="container py-5">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="card shadow">
                            <div class="card-header bg-primary text-white">
                                <h4 class="mb-0">Customer Profile</h4>
                            </div>
                            <div class="card-body">
                                <%
                                    Customer customer = (Customer) request.getAttribute("customer");
                                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                                    if (customer != null) {
                                %>
                                <dl class="row">
                                    <dt class="col-sm-4">Full Name:</dt>
                                    <dd class="col-sm-8"><%= customer.getFullName() != null ? customer.getFullName(): "N/A"%></dd>

                                    <dt class="col-sm-4">Email:</dt>
                                    <dd class="col-sm-8"><%= customer.getEmail() != null ? customer.getEmail() : "N/A"%></dd>

                                    <dt class="col-sm-4">Role:</dt>
                                    <dd class="col-sm-8"><%= customer.getRole() != null ? customer.getRole() : "N/A"%></dd>

                                    <dt class="col-sm-4">Created At:</dt>
                                    <dd class="col-sm-8"><%= customer.getAccountCreatedAt()!= null ? dateFormat.format(customer.getAccountCreatedAt()) : "N/A"%></dd>
                                </dl>
                                <% } else { %>
                                <div class="alert alert-danger text-center">No staff profile found.</div>
                                <% }%>
                                <div class="text-center mt-4 d-flex justify-content-center gap-3 flex-wrap">
                                    <a href="${pageContext.request.contextPath}/staff/profile/edit-profile" class="btn btn-success">Edit Profile</a>
                                    <a href="${pageContext.request.contextPath}/staff/profile/change-password" class="btn btn-danger">Change Password</a>
                                    <a href="${pageContext.request.contextPath}/staff/dashboard" class="btn btn-secondary">Back to Dashboard</a>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

    </body>
</html>
