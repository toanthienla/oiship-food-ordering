<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Account Management - Oiship</title>

        <!-- Bootstrap 5 CSS & JS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

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
            .tab-content {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .status-active {
                color: green;
            }
            .status-inactive {
                color: red;
            }
            .status-suspended {
                color: orange;
            }
            .dropdown-menu {
                min-width: 10rem;
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
                <h1>Account Management</h1>
                <p>Manage staff and customer accounts. Updated: Thu Jun 19 21:43 ICT 2025</p>

                <!-- Search and Action Bar -->
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/admin/accounts" method="get" class="d-flex">
                            <input class="form-control me-2" type="search" name="search" placeholder="Search by name or email" value="${param.search}">
                            <button class="btn btn-outline-success" type="submit">Search</button>
                        </form>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="${pageContext.request.contextPath}/admin/accounts?action=add&role=staff" class="btn btn-primary me-2">Add Staff</a>
                        <a href="${pageContext.request.contextPath}/admin/accounts?action=add&role=customer" class="btn btn-primary me-2">Add Customer</a>
                        <button class="btn btn-danger me-2" onclick="confirmDeleteSelected()">Delete</button>
                    </div>
                </div>

                <!-- Tabs -->
                <ul class="nav nav-tabs" id="accountTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="staff-tab" data-bs-toggle="tab" data-bs-target="#staff" type="button" role="tab" aria-controls="staff" aria-selected="true">Staff</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="customer-tab" data-bs-toggle="tab" data-bs-target="#customer" type="button" role="tab" aria-controls="customer" aria-selected="false">Customers</button>
                    </li>
                </ul>

                <div class="tab-content" id="accountTabContent">
                    <!-- Staff Tab -->
                    <div class="tab-pane fade show active" id="staff" role="tabpanel" aria-labelledby="staff-tab">
                        <div class="table-responsive mt-3">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="account" items="${staffAccounts}">
                                        <tr>
                                            <td>${account.accountID}</td>
                                            <td>${account.fullName}</td>
                                            <td>${account.email}</td>
                                            <td>${account.role}</td>
                                            <td class="${account.status == 1 ? 'status-active' : account.status == 0 ? 'status-inactive' : 'status-suspended'}">
                                                ${account.status == 1 ? 'Active' : account.status == 0 ? 'Inactive' : 'Suspended'}
                                            </td>
                                            <td><fmt:formatDate value="${account.createAt}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                                            <td>
                                                <button class="btn btn-info btn-sm me-1" data-bs-toggle="modal" data-bs-target="#detailsModal-${account.accountID}">View Details</button>
                                                <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal-${account.accountID}">Edit</button>
                                                <div class="btn-group">
                                                    <button type="button" class="btn btn-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                                        Update Status
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=1">Active</a></li>
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=0">Inactive</a></li>
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=2">Suspended</a></li>
                                                    </ul>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Customer Tab -->
                    <div class="tab-pane fade" id="customer" role="tabpanel" aria-labelledby="customer-tab">
                        <div class="table-responsive mt-3">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="account" items="${customerAccounts}">
                                        <tr>
                                            <td>${account.accountID}</td>
                                            <td>${account.fullName}</td>
                                            <td>${account.email}</td>
                                            <td>${account.role}</td>
                                            <td class="${account.status == 1 ? 'status-active' : account.status == 0 ? 'status-inactive' : 'status-suspended'}">
                                                ${account.status == 1 ? 'Active' : account.status == 0 ? 'Inactive' : 'Suspended'}
                                            </td>
                                            <td><fmt:formatDate value="${account.createAt}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                                            <td>
                                                <button class="btn btn-info btn-sm me-1" data-bs-toggle="modal" data-bs-target="#detailsModal-${account.accountID}">View Details</button>
                                                <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal-${account.accountID}">Edit</button>
                                                <div class="btn-group">
                                                    <button type="button" class="btn btn-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                                        Update Status
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=1">Active</a></li>
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=0">Inactive</a></li>
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=2">Suspended</a></li>
                                                    </ul>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty message}">
                    <div class="alert alert-info mt-3">${message}</div>
                </c:if>
            </div>
        </div>

        <!-- Edit Modal for Staff -->
        <c:forEach var="account" items="${staffAccounts}">
            <div class="modal fade" id="editModal-${account.accountID}" tabindex="-1" aria-labelledby="editModalLabel-${account.accountID}" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editModalLabel-${account.accountID}">Edit Account (ID: ${account.accountID})</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form action="${pageContext.request.contextPath}/admin/accounts" method="post" class="needs-validation" novalidate>
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="id" value="${account.accountID}">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="fullName-${account.accountID}" class="form-label">Full Name</label>
                                            <input type="text" class="form-control" id="fullName-${account.accountID}" name="fullName" value="${account.fullName}" required>
                                            <div class="invalid-feedback">Please enter full name.</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="email-${account.accountID}" class="form-label">Email</label>
                                            <input type="email" class="form-control" id="email-${account.accountID}" name="email" value="${account.email}" readonly required>
                                            <div class="invalid-feedback">Please enter a valid email.</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="password-${account.accountID}" class="form-label">Password</label>
                                            <input type="password" class="form-control" id="password-${account.accountID}" name="password" value="${account.password}" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="role-${account.accountID}" class="form-label">Role</label>
                                            <input type="text" class="form-control" id="role-${account.accountID}" name="role" value="${account.role}" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Created At</label>
                                            <input type="text" class="form-control" value="<fmt:formatDate value="${account.createAt}" pattern="dd/MM/yyyy HH:mm:ss" />" readonly>
                                        </div>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Details Modal for Staff -->
            <div class="modal fade" id="detailsModal-${account.accountID}" tabindex="-1" aria-labelledby="detailsModalLabel-${account.accountID}" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="detailsModalLabel-${account.accountID}">Account Details (ID: ${account.accountID})</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Full Name:</label>
                                    <input type="text" class="form-control" value="${account.fullName}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email:</label>
                                    <input type="text" class="form-control" value="${account.email}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Password:</label>
                                    <input type="text" class="form-control" value="${account.password}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Role:</label>
                                    <input type="text" class="form-control" value="${account.role}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Status:</label>
                                    <input type="text" class="form-control" value="${account.status == 1 ? 'Active' : account.status == 0 ? 'Inactive' : 'Suspended'}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Created At:</label>
                                    <input type="text" class="form-control" value="<fmt:formatDate value="${account.createAt}" pattern="dd/MM/yyyy HH:mm:ss" />" readonly>
                                </div>
                            </div>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <!-- Edit Modal for Customers -->
        <c:forEach var="account" items="${customerAccounts}">
            <div class="modal fade" id="editModal-${account.accountID}" tabindex="-1" aria-labelledby="editModalLabel-${account.accountID}" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editModalLabel-${account.accountID}">Edit Account (ID: ${account.accountID})</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form action="${pageContext.request.contextPath}/admin/accounts" method="post" class="needs-validation" novalidate>
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="id" value="${account.accountID}">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="fullName-${account.accountID}" class="form-label">Full Name</label>
                                            <input type="text" class="form-control" id="fullName-${account.accountID}" name="fullName" value="${account.fullName}" required>
                                            <div class="invalid-feedback">Please enter full name.</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="email-${account.accountID}" class="form-label">Email</label>
                                            <input type="email" class="form-control" id="email-${account.accountID}" name="email" value="${account.email}" readonly required>
                                            <div class="invalid-feedback">Email cannot be changed.</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="password-${account.accountID}" class="form-label">Password</label>
                                            <input type="password" class="form-control" id="password-${account.accountID}" name="password" value="${account.password}" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="phone-${account.accountID}" class="form-label">Phone</label>
                                            <input type="text" class="form-control" id="phone-${account.accountID}" name="phone" value="${account.customer != null ? account.customer.phone : ''}" required>
                                            <div class="invalid-feedback">Please enter a phone number.</div>
                                            <script>console.log("DEBUG JSP: Account ID ${account.accountID}, Phone: ${account.customer != null ? account.customer.phone : 'null'}");</script>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="address-${account.accountID}" class="form-label">Address</label>
                                            <input type="text" class="form-control" id="address-${account.accountID}" name="address" value="${account.customer != null ? account.customer.address : ''}" required>
                                            <div class="invalid-feedback">Please enter an address.</div>
                                            <script>console.log("DEBUG JSP: Account ID ${account.accountID}, Address: ${account.customer != null ? account.customer.address : 'null'}");</script>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="role-${account.accountID}" class="form-label">Role</label>
                                            <input type="text" class="form-control" id="role-${account.accountID}" name="role" value="${account.role}" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Created At</label>
                                            <input type="text" class="form-control" value="<fmt:formatDate value="${account.createAt}" pattern="dd/MM/yyyy HH:mm:ss" />" readonly>
                                        </div>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Details Modal for Customers -->
            <div class="modal fade" id="detailsModal-${account.accountID}" tabindex="-1" aria-labelledby="detailsModalLabel-${account.accountID}" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="detailsModalLabel-${account.accountID}">Account Details (ID: ${account.accountID})</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Full Name:</label>
                                    <input type="text" class="form-control" value="${account.fullName}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email:</label>
                                    <input type="text" class="form-control" value="${account.email}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Password:</label>
                                    <input type="text" class="form-control" value="${account.password}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Phone:</label>
                                    <input type="text" class="form-control" value="${account.customer != null ? account.customer.phone : ''}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Address:</label>
                                    <input type="text" class="form-control" value="${account.customer != null ? account.customer.address : ''}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Role:</label>
                                    <input type="text" class="form-control" value="${account.role}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Status:</label>
                                    <input type="text" class="form-control" value="${account.status == 1 ? 'Active' : account.status == 0 ? 'Inactive' : 'Suspended'}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Created At:</label>
                                    <input type="text" class="form-control" value="<fmt:formatDate value="${account.createAt}" pattern="dd/MM/yyyy HH:mm:ss" />" readonly>
                                </div>
                            </div>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <script>
            // Bootstrap validation
            (function () {
                'use strict';
                var forms = document.querySelectorAll('.needs-validation');
                Array.prototype.slice.call(forms).forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventPropagation();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            })();

            function confirmDeleteSelected() {
                if (confirm('Are you sure you want to delete the selected account?')) {
                    alert('Deletion logic to be implemented.');
                }
            }

            function editSelected() {
                alert('Edit logic to be implemented.');
            }
        </script>
    </body>
</html>