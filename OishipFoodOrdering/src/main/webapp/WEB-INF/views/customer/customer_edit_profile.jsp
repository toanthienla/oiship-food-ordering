
<%@page import="model.Staff"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Staff - Edit Profile</title>

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

            <div class="content mt-4">
                <h2 class="mb-4">Edit Your Name</h2>

                <form method="post" action="${pageContext.request.contextPath}/customer/profile/edit-profile">
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Full Name</label>
                        <input type="text"
                               class="form-control"
                               id="fullName"
                               name="fullName"
                               value="${customer.fullName}"
                               required>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="text"
                               class="form-control"
                               id="phone"
                               name="phone"
                               value="${customer.phone}"
                               required>
                    </div>

                    <div class="mb-3">
                        <label for="address" class="form-label">Address</label>
                        <input type="text"
                               class="form-control"
                               id="address"
                               name="address"
                               value="${customer.address}"
                               required>
                    </div>


                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">Update</button>
                        <a href="${pageContext.request.contextPath}/customer/profile" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>

                <c:if test="${not empty message}">
                    <div class="alert alert-info mt-3">${message}</div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mt-3">${error}</div>
                </c:if>
            </div>




            <!-- JS -->
            <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.js"></script>
    </body>
</html>
