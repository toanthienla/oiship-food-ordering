<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin - Manage Contacts</title>
        <link rel="stylesheet" href="../css/bootstrap.css" />
        <script src="../js/bootstrap.bundle.js"></script>
        <link rel="stylesheet" href="../css/sidebar.css" />
        <link rel="stylesheet" href="../css/dashboard.css" />
        <script src="../js/sidebar.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
    </head>
    <body>

        <jsp:include page="admin_sidebar.jsp" />

        <div class="main" id="main">
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile">
                    <span class="username">Hi, Admin</span>
                </div>
            </div>

            <div class="content">
                <h1>Manage Contacts</h1>
                <p>View contact messages from customers.</p>

                <!-- Contact Messages Table -->
                <div class="mt-4">
                    <h4>Contact Messages</h4>
                    <div class="table-responsive mt-3">
                        <table class="table table-bordered table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-center">#</th>
                                    <th>Subject</th>
                                    <th>Message</th>
                                    <th>Create Time</th>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="contact" items="${contacts}" varStatus="loop">
                                    <tr>
                                        <td class="text-center">${loop.index + 1}</td>
                                        <td>${contact.subject}</td>
                                        <td>${contact.message}</td>
                                        <td>
                                            <fmt:formatDate value="${contact.createAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                        </td>
                                        <td>${contact.customer.fullName}</td>
                                        <td>${contact.customer.email}</td>
                                        <td>${contact.customer.phone}</td>
                                        <td>${contact.customer.address}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${contact.customer.status == 1}">Active</c:when>
                                                <c:when test="${contact.customer.status == 0}">Inactive</c:when>
                                                <c:when test="${contact.customer.status == -1}">Banned</c:when>
                                                <c:otherwise>Unknown</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>