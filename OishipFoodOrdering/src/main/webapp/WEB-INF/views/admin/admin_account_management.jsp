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

        <!-- jQuery for AJAX -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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
            .modal-content {
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .modal-body .form-control {
                margin-bottom: 1rem;
            }
            #filterStatus {
                margin-left: 10px;
                width: 150px;
                display: inline-block;
            }
            .loading {
                display: none;
                margin-left: 10px;
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
                <h1>Account Management</h1>
                <p>Manage staff and customer accounts. Updated: <fmt:formatDate value="<%= new java.util.Date()%>" pattern="EEE MMM dd HH:mm zzz yyyy" /></p>

                <!-- Search and Action Bar -->
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/admin/accounts" method="get" class="d-flex" id="searchForm">
                            <input class="form-control me-2" type="search" name="search" placeholder="Search by name or email" value="${param.search}">
                            <button class="btn btn-outline-success" type="submit">Search</button>
                        </form>
                    </div>
                    <div class="col-md-6 text-end">
                        <select class="form-select" id="filterStatus" name="status" onchange="filterAccounts()">
                            <option value="">All</option>
                            <option value="1" ${param.status == '1' ? 'selected' : ''}>Active</option>
                            <option value="0" ${param.status == '0' ? 'selected' : ''}>Inactive</option>
                            <option value="2" ${param.status == '2' ? 'selected' : ''}>Suspended</option>
                        </select>
                        <span class="loading"><i class="bi bi-spinner bi-spin"></i> Loading...</span>
                        <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addStaffModal">Add Staff</button>
                        <button class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#addCustomerModal">Add Customer</button>
                    </div>
                </div>

                <!-- Error Message -->
                <div class="error-message" id="errorMessage"></div>

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
                            <table class="table table-striped" id="staffTable">
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
                                <tbody id="staffBody">
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
                                                <a href="${pageContext.request.contextPath}/admin/accounts?action=delete&id=${account.accountID}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this account?');">Delete</a>
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
                            <table class="table table-striped" id="customerTable">
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
                                <tbody id="customerBody">
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
                                                <a href="${pageContext.request.contextPath}/admin/accounts?action=delete&id=${account.accountID}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this account?');">Delete</a>
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

        <!-- Add Staff Modal -->
        <div class="modal fade" id="addStaffModal" tabindex="-1" aria-labelledby="addStaffModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addStaffModalLabel">Add New Staff</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="${pageContext.request.contextPath}/admin/accounts" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="insert">
                            <input type="hidden" name="role" value="staff">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="addFullNameStaff" class="form-label">Full Name</label>
                                        <input type="text" class="form-control" id="addFullNameStaff" name="fullName" required>
                                        <div class="invalid-feedback">Please enter full name.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="addEmailStaff" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="addEmailStaff" name="email" required>
                                        <div class="invalid-feedback">Please enter a valid email.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="addPasswordStaff" class="form-label">Password</label>
                                        <input type="password" class="form-control" id="addPasswordStaff" name="password" required>
                                        <div class="invalid-feedback">Please enter a password.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="addRoleStaff" class="form-label">Role</label>
                                        <input type="text" class="form-control" id="addRoleStaff" name="role" value="staff" readonly>
                                    </div>
                                </div>
                            </div>
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
                        <form action="${pageContext.request.contextPath}/admin/accounts" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="insert">
                            <input type="hidden" name="role" value="customer">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="addFullNameCustomer" class="form-label">Full Name</label>
                                        <input type="text" class="form-control" id="addFullNameCustomer" name="fullName" required>
                                        <div class="invalid-feedback">Please enter full name.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="addEmailCustomer" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="addEmailCustomer" name="email" required>
                                        <div class="invalid-feedback">Please enter a valid email.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="addPasswordCustomer" class="form-label">Password</label>
                                        <input type="password" class="form-control" id="addPasswordCustomer" name="password" required>
                                        <div class="invalid-feedback">Please enter a password.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="addPhoneCustomer" class="form-label">Phone</label>
                                        <input type="text" class="form-control" id="addPhoneCustomer" name="phone" required>
                                        <div class="invalid-feedback">Please enter a phone number.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="addAddressCustomer" class="form-label">Address</label>
                                        <input type="text" class="form-control" id="addAddressCustomer" name="address" required>
                                        <div class="invalid-feedback">Please enter an address.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="addRoleCustomer" class="form-label">Role</label>
                                        <input type="text" class="form-control" id="addRoleCustomer" name="role" value="customer" readonly>
                                    </div>
                                </div>
                            </div>
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

                function filterAccounts() {
                    var status = $('#filterStatus').val();
                    var search = $('input[name="search"]').val();
                    var activeTab = $('.nav-link.active').attr('id');
                    console.log('Filtering with status:', status, 'search:', search);
                    $('#errorMessage').hide();
                    $('.loading').show();

                    $.ajax({
                        url: '${pageContext.request.contextPath}/admin/accounts',
                        type: 'GET',
                        data: {status: status, search: search},
                        dataType: 'html', // Đảm bảo trả về HTML
                        success: function (response) {
                            try {
                                var $response = $(response);
                                var newStaffBody = $response.find('#staffBody').html();
                                var newCustomerBody = $response.find('#customerBody').html();
                                if (newStaffBody && newCustomerBody) {
                                    $('#staffBody').html(newStaffBody);
                                    $('#customerBody').html(newCustomerBody);
                                    $('#' + activeTab).tab('show'); // Khôi phục tab
                                } else {
                                    $('#errorMessage').text('Error: No table data received.').show();
                                }
                            } catch (e) {
                                $('#errorMessage').text('Error processing response: ' + e.message).show();
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error('AJAX error:', error, 'Status:', xhr.status, 'Response:', xhr.responseText);
                            $('#errorMessage').text('Error: ' + error + ' (Status: ' + xhr.status + ')').show();
                        },
                        complete: function () {
                            $('.loading').hide();
                        }
                    });
                }

                $(document).ready(function () {
                    console.log('Page loaded, calling filterAccounts');
                    filterAccounts(); // Load lần đầu
                    $('#searchForm').on('submit', function (e) {
                        e.preventDefault();
                        filterAccounts();
                    });

                    $('#accountTabs a').on('shown.bs.tab', function (e) {
                        console.log('Tab changed, calling filterAccounts');
                        filterAccounts();
                    });
                });
            </script>
    </body>
</html>