<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Account Management</title>

        <!-- Bootstrap 5 CSS & JS -->
        <link rel="stylesheet" href="../css/bootstrap.css" />
        <script src="../js/bootstrap.bundle.js"></script>

        <!-- CSS for Dashboard and Sidebar -->
        <link rel="stylesheet" href="../css/sidebar.css" />
        <link rel="stylesheet" href="../css/dashboard.css" />

        <!-- JS for Sidebar -->
        <script src="../js/sidebar.js"></script>

        <!-- jQuery for AJAX -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

        <style>
            .topbar {
                padding: 10px 20px;
            }
            .content {
                margin-left: 0px;
                padding: 20px;
            }
            .dropdown-menu {
                min-width: 10rem;
            }
            .modal-content {
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .modal-body {
                padding: 20px;
            }
            .modal-body .form-control {
                margin-bottom: 1rem;
            }
            #filterStatus {
                margin-left: 10px;
                width: 150px;
                display: inline-block;
            }
            .error-message {
                color: red;
                margin-top: 10px;
                display: none;
            }
            .modal-feedback {
                margin-top: 15px;
                display: none;
            }
            .modal-feedback.success {
                color: green;
            }
            .modal-feedback.error {
                color: red;
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
                <h1>Account Management</h1>
                <p>Manage staff and customer accounts. Updated: <fmt:formatDate value="<%= new java.util.Date()%>" pattern="EEE MMM dd HH:mm zzz yyyy" /></p>

                <!-- Success or Error Message Alerts -->
                <c:if test="${not empty message}">
                    <div class="alert ${message.contains('success') || message.contains('added') || message.contains('updated') || message.contains('deleted') ? 'alert-success' : 'alert-danger'} alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Search and Action Bar -->
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/admin/accounts" method="get" class="d-flex" id="searchForm">
                            <input class="form-control me-2" type="search" name="search" placeholder="Search by name or email" value="${param.search}">
                            <button class="btn btn-outline-success" type="submit">Search</button>
                            <input type="hidden" name="tab" value="${param.tab != null ? param.tab : 'staff-tab'}">
                        </form>
                    </div>
                    <div class="col-md-6 text-end">
                        <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addStaffModal">Add Staff</button>
                        <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addCustomerModal">Add Customer</button>
                        <select class="form-select" id="filterStatus" name="filterStatus" onchange="filterAccounts()">
                            <option value="" ${param.filterStatus == '' ? 'selected' : ''}>All</option>
                            <option value="1" ${param.filterStatus == '1' ? 'selected' : ''}>Active</option>
                            <option value="0" ${param.filterStatus == '0' ? 'selected' : ''}>Inactive</option>
                            <option value="-1" ${param.filterStatus == '-1' ? 'selected' : ''}>Banned</option>
                        </select>
                    </div>
                </div>

                <!-- Error Message -->
                <div class="error-message" id="errorMessage"></div>

                <!-- Tabs -->
                <ul class="nav nav-tabs" id="accountTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <a class="nav-link ${param.tab == 'staff-tab' || empty param.tab ? 'active' : ''}" id="staff-tab" data-bs-toggle="tab" href="#staff" role="tab">Staff</a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link ${param.tab == 'customer-tab' ? 'active' : ''}" id="customer-tab" data-bs-toggle="tab" href="#customer" role="tab">Customer</a>
                    </li>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content">
                    <!-- Staff Tab -->
                    <div class="tab-pane fade ${param.tab == 'staff-tab' || empty param.tab ? 'show active' : ''}" id="staff" role="tabpanel" aria-labelledby="staff-tab">
                        <div class="table-responsive mt-3">
                            <table class="table table-striped" id="staffTable">
                                <thead>
                                    <tr>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="staffBody">
                                    <c:forEach var="account" items="${staffAccounts}">
                                        <tr>
                                            <td>${account.fullName}</td>
                                            <td>${account.email}</td>
                                            <td>${account.status == 1 ? 'Active' : account.status == 0 ? 'Inactive' : 'Banned'}</td>
                                            <td>
                                                <div class="btn-group">
                                                    <button type="button" class="btn btn-info btn-sm" onclick="toggleDetails(${account.accountID})">Details</button>
                                                    <a href="#" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#editModal-${account.accountID}">Edit</a>
                                                    <button type="button" class="btn btn-warning btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">Change Status</button>
                                                    <ul class="dropdown-menu">
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=1&filterStatus=${param.filterStatus}&search=${param.search}&tab=${param.tab}">Active</a></li>
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=0&filterStatus=${param.filterStatus}&search=${param.search}&tab=${param.tab}">Inactive</a></li>
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=-1&filterStatus=${param.filterStatus}&search=${param.search}&tab=${param.tab}">Banned</a></li>
                                                    </ul>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/admin/accounts?action=delete&id=${account.accountID}&filterStatus=${param.filterStatus}&search=${param.search}&tab=${param.tab}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete account ID ${account.accountID}?')">Delete</a>
                                            </td>
                                        </tr>
                                        <tr id="detailsRow-${account.accountID}" class="details-row" style="display: none;">
                                            <td colspan="4">
                                                <div class="details-content">
                                                    <strong>Details:</strong><br>
                                                    <label>Full Name: ${account.fullName}</label><br>
                                                    <label>Email: ${account.email}</label><br>
                                                    <label>Status: ${account.status == 1 ? 'Active' : account.status == 0 ? 'Inactive' : 'Banned'}</label><br>
                                                    <label>Created At: <fmt:formatDate value="${account.createAt}" pattern="dd/MM/yyyy HH:mm:ss" /></label>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty staffAccounts}">
                                        <tr><td colspan="4">No staff accounts found.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Customer Tab -->
                    <div class="tab-pane fade ${param.tab == 'customer-tab' ? 'show active' : ''}" id="customer" role="tabpanel" aria-labelledby="customer-tab">
                        <div class="table-responsive mt-3">
                            <table class="table table-striped" id="customerTable">
                                <thead>
                                    <tr>
                                        <th>Full Name</th>
                                        <th>Email</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="customerBody">
                                    <c:forEach var="account" items="${customerAccounts}">
                                        <tr>
                                            <td>${account.fullName}</td>
                                            <td>${account.email}</td>
                                            <td>${account.status == 1 ? 'Active' : account.status == 0 ? 'Inactive' : 'Banned'}</td>
                                            <td>
                                                <div class="btn-group">
                                                    <button type="button" class="btn btn-info btn-sm" onclick="toggleDetails(${account.accountID})">Details</button>
                                                    <a href="#" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#editModal-${account.accountID}">Edit</a>
                                                    <button type="button" class="btn btn-warning btn-sm dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">Change Status</button>
                                                    <ul class="dropdown-menu">
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=1&filterStatus=${param.filterStatus}&search=${param.search}&tab=${param.tab}">Active</a></li>
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=0&filterStatus=${param.filterStatus}&search=${param.search}&tab=${param.tab}">Inactive</a></li>
                                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts?action=updateStatus&id=${account.accountID}&status=-1&filterStatus=${param.filterStatus}&search=${param.search}&tab=${param.tab}">Banned</a></li>
                                                    </ul>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/admin/accounts?action=delete&id=${account.accountID}&filterStatus=${param.filterStatus}&search=${param.search}&tab=${param.tab}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete account ID ${account.accountID}?')">Delete</a>
                                            </td>
                                        </tr>
                                        <tr id="detailsRow-${account.accountID}" class="details-row" style="display: none;">
                                            <td colspan="4">
                                                <div class="details-content">
                                                    <strong>Details:</strong><br>
                                                    <label>Full Name: ${account.fullName}</label><br>
                                                    <label>Email: ${account.email}</label><br>
                                                    <label>Phone: ${account.customer.phone}</label><br>
                                                    <label>Address: ${account.customer.address}</label><br>
                                                    <label>Status: ${account.status == 1 ? 'Active' : account.status == 0 ? 'Inactive' : 'Banned'}</label><br>
                                                    <label>Created At: <fmt:formatDate value="${account.createAt}" pattern="dd/MM/yyyy HH:mm:ss" /></label>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty customerAccounts}">
                                        <tr><td colspan="4">No customer accounts found.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!-- Add Staff Modal -->
                    <div class="modal fade" id="addStaffModal" tabindex="-1" aria-labelledby="addStaffModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="addStaffModalLabel">Add New Staff</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form action="${pageContext.request.contextPath}/admin/accounts" method="post" class="needs-validation" novalidate id="addStaffForm">
                                        <input type="hidden" name="action" value="insert">
                                        <input type="hidden" name="role" value="staff">
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="addFullNameStaff" class="form-label">Full Name</label>
                                                    <input type="text" class="form-control" id="addFullNameStaff" name="fullName" placeholder="Enter full name" required>
                                                    <div class="invalid-feedback">Please enter full name.</div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="addEmailStaff" class="form-label">Email</label>
                                                    <input type="email" class="form-control" id="addEmailStaff" name="email" placeholder="Enter email address" required>
                                                    <div class="invalid-feedback">Please enter a valid email.</div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="addPasswordStaff" class="form-label">Password</label>
                                                    <input type="password" class="form-control" id="addPasswordStaff" name="password" placeholder="Enter password" required>
                                                    <div class="invalid-feedback">Please enter a password.</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-feedback" id="staffFeedback"></div>
                                        <button type="submit" class="btn btn-primary">Add Staff</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add Customer Modal -->
                    <div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="addCustomerModalLabel">Add New Customer</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form action="${pageContext.request.contextPath}/admin/accounts" method="post" class="needs-validation" novalidate id="addCustomerForm">
                                        <input type="hidden" name="action" value="insert">
                                        <input type="hidden" name="role" value="customer">
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="addFullNameCustomer" class="form-label">Full Name</label>
                                                    <input type="text" class="form-control" id="addFullNameCustomer" name="fullName" placeholder="Enter full name" required>
                                                    <div class="invalid-feedback">Please enter full name.</div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="addEmailCustomer" class="form-label">Email</label>
                                                    <input type="email" class="form-control" id="addEmailCustomer" name="email" placeholder="Enter email address" required>
                                                    <div class="invalid-feedback">Please enter a valid email.</div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="addPasswordCustomer" class="form-label">Password</label>
                                                    <input type="password" class="form-control" id="addPasswordCustomer" name="password" placeholder="Enter password" required>
                                                    <div class="invalid-feedback">Please enter a password.</div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="addPhoneCustomer" class="form-label">Phone</label>
                                                    <input type="text" class="form-control" id="addPhoneCustomer" name="phone" placeholder="Enter phone number" required>
                                                    <div class="invalid-feedback">Please enter a phone number.</div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="addAddressCustomer" class="form-label">Address</label>
                                                    <input type="text" class="form-control" id="addAddressCustomer" name="address" placeholder="Enter address" required>
                                                    <div class="invalid-feedback">Please enter an address.</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-feedback" id="customerFeedback"></div>
                                        <button type="submit" class="btn btn-primary">Add Customer</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    </form>
                                </div>
                            </div>
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
                                            <input type="hidden" name="role" value="${account.role}">
                                            <input type="hidden" name="tab" value="${param.tab != null ? param.tab : 'staff-tab'}">
                                            <input type="hidden" name="filterStatus" value="${param.filterStatus}">
                                            <input type="hidden" name="search" value="${param.search}">
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
                                                        <input type="text" class="form-control" id="password-${account.accountID}" name="password" value="${account.password}" readonly>
                                                        <div class="invalid-feedback">Password cannot be edited.</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="status-${account.accountID}" class="form-label">Status</label>
                                                        <select class="form-select" id="status-${account.accountID}" name="status" required>
                                                            <option value="1" ${account.status == 1 ? 'selected' : ''}>Active</option>
                                                            <option value="0" ${account.status == 0 ? 'selected' : ''}>Inactive</option>
                                                            <option value="-1" ${account.status == -1 ? 'selected' : ''}>Banned</option>
                                                        </select>
                                                        <div class="invalid-feedback">Please select a status.</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Role</label>
                                                        <input type="text" class="form-control" value="${account.role}" readonly>
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
                                                <label class="form-label">Status:</label>
                                                <input type="text" class="form-control" value="${account.status == 1 ? 'Active' : account.status == 0 ? 'Inactive' : 'Banned'}" readonly>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Role:</label>
                                                <input type="text" class="form-control" value="${account.role}" readonly>
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
                                            <input type="hidden" name="role" value="${account.role}">
                                            <input type="hidden" name="tab" value="${param.tab != null ? param.tab : 'customer-tab'}">
                                            <input type="hidden" name="filterStatus" value="${param.filterStatus}">
                                            <input type="hidden" name="search" value="${param.search}">
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
                                                        <label for="phone-${account.accountID}" class="form-label">Phone</label>
                                                        <input type="text" class="form-control" id="phone-${account.accountID}" name="phone" value="${account.customer != null ? account.customer.phone : ''}" required>
                                                        <div class="invalid-feedback">Please enter a phone number.</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="address-${account.accountID}" class="form-label">Address</label>
                                                        <input type="text" class="form-control" id="address-${account.accountID}" name="address" value="${account.customer != null ? account.customer.address : ''}" required>
                                                        <div class="invalid-feedback">Please enter an address.</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="password-${account.accountID}" class="form-label">Password</label>
                                                        <input type="text" class="form-control" id="password-${account.accountID}" name="password" value="${account.password}" readonly>
                                                        <div class="invalid-feedback">Password cannot be edited.</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="status-${account.accountID}" class="form-label">Status</label>
                                                        <select class="form-select" id="status-${account.accountID}" name="status" required>
                                                            <option value="1" ${account.status == 1 ? 'selected' : ''}>Active</option>
                                                            <option value="0" ${account.status == 0 ? 'selected' : ''}>Inactive</option>
                                                            <option value="-1" ${account.status == -1 ? 'selected' : ''}>Banned</option>
                                                        </select>
                                                        <div class="invalid-feedback">Please select a status.</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Role</label>
                                                        <input type="text" class="form-control" value="${account.role}" readonly>
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
                                                <label class="form-label">Phone:</label>
                                                <input type="text" class="form-control" value="${account.customer != null ? account.customer.phone : ''}" readonly>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Address:</label>
                                                <input type="text" class="form-control" value="${account.customer != null ? account.customer.address : ''}" readonly>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Password:</label>
                                                <input type="text" class="form-control" value="${account.password}" readonly>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Status:</label>
                                                <input type="text" class="form-control" value="${account.status == 1 ? 'Active' : account.status == 0 ? 'Inactive' : 'Banned'}" readonly>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Role:</label>
                                                <input type="text" class="form-control" value="${account.role}" readonly>
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
                </div>
            </div>




            <script>

                function toggleDetails(accountID) {
                    var detailsRow = document.getElementById('detailsRow-' + accountID);
                    if (detailsRow.style.display === 'none' || detailsRow.style.display === '') {
                        detailsRow.style.display = 'table-row'; // Hiển thị hàng chi tiết
                    } else {
                        detailsRow.style.display = 'none'; // Ẩn hàng chi tiết
                    }
                }

                // Bootstrap validation
                (function () {
                    'use strict';
                    var forms = document.querySelectorAll('.needs-validation');
                    Array.prototype.slice.call(forms).forEach(function (form) {
                        form.addEventListener('submit', function (event) {
                            if (!form.checkValidity()) {
                                event.preventDefault();
                                event.stopPropagation();
                            }
                            form.classList.add('was-validated');
                        }, false);
                    });
                })();

                function confirmDeleteSelected() {
                    var selected = $('.selectAccount:checked').map(function () {
                        return $(this).val();
                    }).get();
                    var filterStatus = $('#filterStatus').val();
                    var search = $('input[name="search"]').val();
                    var tab = $('.nav-link.active').attr('id');
                    if (selected.length === 0) {
                        $('#errorMessage').text('Please select at least one account to delete.').show();
                        setTimeout(() => $('#errorMessage').hide(), 3000);
                        return;
                    }
                    if (confirm('Are you sure you want to delete the selected accounts?')) {
                        window.location.href = '${pageContext.request.contextPath}/admin/accounts?action=deleteSelected&ids=' + selected.join(',') +
                                '&filterStatus=' + (filterStatus || '') +
                                '&search=' + encodeURIComponent(search || '') +
                                '&tab=' + (tab || 'staff-tab');
                    }
                }

                function filterAccounts() {
                    var filterStatus = $('#filterStatus').val();
                    var search = $('input[name="search"]').val();
                    var tab = $('.nav-link.active').attr('id');
                    window.location.href = '${pageContext.request.contextPath}/admin/accounts?filterStatus=' + (filterStatus || '') +
                            '&search=' + encodeURIComponent(search || '') +
                            '&tab=' + (tab || 'staff-tab');
                }

                $(document).ready(function () {
                    // Khôi phục tab từ URL hoặc sessionStorage
                    var urlParams = new URLSearchParams(window.location.search);
                    var tab = urlParams.get('tab') || sessionStorage.getItem('activeTab') || 'staff-tab';
                    $('#' + tab).tab('show');

                    // Xử lý select all checkboxes
                    $('#selectAllStaff').click(function () {
                        $('#staffBody .selectAccount').prop('checked', this.checked);
                    });
                    $('#selectAllCustomer').click(function () {
                        $('#customerBody .selectAccount').prop('checked', this.checked);
                    });

                    // Xử lý submit form tìm kiếm
                    $('#searchForm').on('submit', function (e) {
                        e.preventDefault();
                        filterAccounts();
                    });

                    // Lưu tab hiện tại khi chuyển tab
                    $('#accountTabs a').on('shown.bs.tab', function (e) {
                        var activeTab = $(this).attr('id');
                        sessionStorage.setItem('activeTab', activeTab);
                        console.log('Tab changed to:', activeTab, 'at:', new Date());
                    });

                    // Đảm bảo filterStatus được chọn đúng
                    var filterStatus = urlParams.get('filterStatus') || '';
                    $('#filterStatus').val(filterStatus);

                    // Handle form submission feedback
                    $('#addStaffForm').on('submit', function (e) {
                        if (!this.checkValidity()) {
                            e.preventDefault();
                            e.stopPropagation();
                            $(this).addClass('was-validated');
                            return;
                        }
                        e.preventDefault();
                        $.ajax({
                            url: $(this).attr('action'),
                            type: 'POST',
                            data: $(this).serialize(),
                            success: function (response) {
                                var message = response.message || 'Staff added successfully';
                                $('#staffFeedback').removeClass('error').addClass('success').text(message).show();
                                setTimeout(() => {
                                    $('#staffFeedback').hide();
                                    $('#addStaffModal').modal('hide');
                                    location.reload();
                                }, 2000);
                            },
                            error: function (xhr) {
                                var errorMsg = xhr.responseJSON?.message || 'Failed to add staff';
                                $('#staffFeedback').removeClass('success').addClass('error').text(errorMsg).show();
                                setTimeout(() => $('#staffFeedback').hide(), 3000);
                            }
                        });
                    });

                    $('#addCustomerForm').on('submit', function (e) {
                        if (!this.checkValidity()) {
                            e.preventDefault();
                            e.stopPropagation();
                            $(this).addClass('was-validated');
                            return;
                        }
                        e.preventDefault();
                        $.ajax({
                            url: $(this).attr('action'),
                            type: 'POST',
                            data: $(this).serialize(),
                            success: function (response) {
                                var message = response.message || 'Customer added successfully';
                                $('#customerFeedback').removeClass('error').addClass('success').text(message).show();
                                setTimeout(() => {
                                    $('#customerFeedback').hide();
                                    $('#addCustomerModal').modal('hide');
                                    location.reload();
                                }, 2000);
                            },
                            error: function (xhr) {
                                var errorMsg = xhr.responseJSON?.message || 'Failed to add customer';
                                $('#customerFeedback').removeClass('success').addClass('error').text(errorMsg).show();
                                setTimeout(() => $('#customerFeedback').hide(), 3000);
                            }
                        });
                    });
                });
            </script>
    </body>
</html>