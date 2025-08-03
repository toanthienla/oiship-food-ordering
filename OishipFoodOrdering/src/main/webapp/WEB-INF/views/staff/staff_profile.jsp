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

        <!-- Tailwind CSS (prefix tw-) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tailwind.css" />

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

            .btn-orange {
                background-color: #EF5D10;
                color: white;
            }
            .btn-orange:hover {
                background-color: #d94f0f;
                color: white;
            }

            .card-rounded {
                border-radius: 1.5rem;
            }

            .card-header-orange {
                background-color: #EF5D10;
                color: white;
                border-top-left-radius: 1.5rem;
                border-top-right-radius: 1.5rem;
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

        <div class="main">
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile"><span class="username">Hi, <span><c:out value="${sessionScope.userName}" /></span></span></div>
            </div>

            <!-- Profile Content -->
            <div class="content container my-5">
                <div class="card shadow card-rounded border border-light">
                    <!-- Header -->
                    <div class="card-header px-4 py-3 d-flex align-items-center" style="background-color: #EF5D10;">
                        <i class="bi bi-person-circle me-3 fs-4 text-white"></i>
                        <h4 class="mb-0 text-white">Staff Profile</h4>
                    </div>

                    <!-- Body -->
                    <div class="card-body px-4 py-4 bg-light">
                        <%
                            Staff staff = (Staff) request.getAttribute("staff");
                            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                            if (staff != null) {
                        %>
                        <div class="row mb-4 text-dark">
                            <div class="col-md-6 mb-3">
                                <strong class="text-secondary"><i class="bi bi-person-fill me-1"></i>Full Name:</strong>
                                <div><%= staff.getFullName() != null ? staff.getFullName() : "N/A"%></div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <strong class="text-secondary"><i class="bi bi-envelope-fill me-1"></i>Email:</strong>
                                <div><%= staff.getEmail() != null ? staff.getEmail() : "N/A"%></div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <strong class="text-secondary"><i class="bi bi-person-badge-fill me-1"></i>Role:</strong>
                                <div><%= staff.getRole() != null ? staff.getRole() : "N/A"%></div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <strong class="text-secondary"><i class="bi bi-calendar-event me-1"></i>Created At:</strong>
                                <div><%= staff.getCreateAt() != null ? dateFormat.format(staff.getCreateAt()) : "N/A"%></div>
                            </div>
                        </div>
                        <% } else { %>
                        <div class="alert alert-warning text-center">
                            <i class="bi bi-exclamation-circle me-2"></i>No staff profile found.
                        </div>
                        <% }%>

                        <!-- Buttons -->
                        <div class="d-flex flex-wrap justify-content-center gap-3 mt-4">
                            <a href="${pageContext.request.contextPath}/staff/profile/edit-profile"
                               class="btn d-inline-flex align-items-center gap-2 px-4 py-2 shadow text-white"
                               style="background-color: #EF5D10;">
                                <i class="bi bi-pencil-square"></i> Edit Profile
                            </a>
                            <a href="${pageContext.request.contextPath}/staff/profile/change-password"
                               class="btn btn-secondary d-inline-flex align-items-center gap-2 px-4 py-2 shadow">
                                <i class="bi bi-shield-lock-fill"></i> Change Password
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </body>
</html>
