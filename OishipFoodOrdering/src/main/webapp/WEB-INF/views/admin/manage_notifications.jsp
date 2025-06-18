<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin - Manage Notifications</title>
        <link rel="stylesheet" href="../css/bootstrap.css"/>
        <script src="../js/bootstrap.bundle.js"></script>
        <link rel="stylesheet" href="../css/sidebar.css"/>
        <link rel="stylesheet" href="../css/dashboard.css"/>
        <script src="../js/sidebar.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"/>
    </head>
    <body>

        <jsp:include page="admin_sidebar.jsp"/>

        <div class="main" id="main">
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile">
                    <span class="username">Hi, Admin</span>
                </div>
            </div>

            <div class="content">
                <h1>Manage Notifications</h1>
                <p>View and manage your system announcements.</p>

                <!-- Add Notification Form -->
                <form action="manage-notifications" method="post" class="row g-3 mt-4">
                    <input type="hidden" name="accountID" value="${sessionScope.account.accountID}" />
                    <div class="col-md-6">
                        <label for="notTitle" class="form-label">Notification Title</label>
                        <input type="text" class="form-control" id="notTitle" name="notTitle" required placeholder="e.g., New Voucher Released!"/>
                    </div>
                    <div class="col-12">
                        <label for="notDescription" class="form-label">Notification Description</label>
                        <textarea class="form-control" id="notDescription" name="notDescription" rows="3" required placeholder="Enter the full notification message..."></textarea>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-success">Add Notification</button>
                    </div>
                </form>

                <!-- Alert Box -->
                <div id="actionAlert" class="alert mt-3 d-none" role="alert"></div>

                <!-- Notifications Table -->
                <div class="mt-5">
                    <h4>Existing Notifications</h4>
                    <div class="col-md-6 mt-3">
                        <div class="d-flex align-items-center">
                            <label class="me-2 fw-semibold mb-0">Search:</label>
                            <input type="text" id="notificationSearch" class="form-control w-auto" placeholder="Enter title..." />
                        </div>
                    </div>

                    <% List<model.Notification> notifications = (List<model.Notification>) request.getAttribute("notifications"); %>
                    <% int index = 1;%>

                    <div class="table-responsive mt-3">
                        <table class="table table-bordered table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Title</th>
                                    <th>Description</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="n" items="${notifications}">
                                    <tr>
                                        <td><%= index++%></td>
                                        <td>${n.notTitle}</td>
                                        <td>${n.notDescription}</td>
                                        <td class="text-center">
                                            <div class="d-flex flex-wrap justify-content-center gap-2">
                                                <button type="button"
                                                        class="btn btn-sm btn-primary px-3"
                                                        data-id="${n.notID}"
                                                        data-title="${n.notTitle}"
                                                        data-description="${n.notDescription}"
                                                        onclick="handleEditClick(this);">
                                                    Edit
                                                </button>
                                                <a href="manage-notifications?action=delete&id=${n.notID}"
                                                   class="btn btn-sm btn-danger px-3"
                                                   onclick="return confirmDelete(event);">
                                                    Delete
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Notification Modal -->
        <div class="modal fade" id="editNotificationModal" tabindex="-1" aria-labelledby="editNotificationModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form action="manage-notifications" method="post" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editNotificationModalLabel">Edit Notification</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="editNotID" name="notID" />
                        <div class="mb-3">
                            <label for="editNotTitle" class="form-label">Notification Title</label>
                            <input type="text" class="form-control" id="editNotTitle" name="notTitle" required />
                        </div>
                        <div class="mb-3">
                            <label for="editNotDescription" class="form-label">Notification Description</label>
                            <textarea class="form-control" id="editNotDescription" name="notDescription" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Notification</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function getParam(name) {
                const urlParams = new URLSearchParams(window.location.search);
                return urlParams.get(name);
            }

            window.addEventListener("DOMContentLoaded", () => {
                const success = getParam("success");
                const alertBox = document.getElementById("actionAlert");

                if (success) {
                    let message = "";
                    let alertClass = "";

                    switch (success) {
                        case "add":
                            message = '<i class="bi bi-check-circle-fill me-2"></i>Notification added successfully!';
                            alertClass = "alert-success";
                            break;
                        case "edit":
                            message = '<i class="bi bi-pencil-square me-2"></i>Notification updated successfully!';
                            alertClass = "alert-success";
                            break;
                        case "delete":
                            message = '<i class="bi bi-trash-fill me-2"></i>Notification deleted successfully!';
                            alertClass = "alert-success";
                            break;
                        case "false":
                            message = '<i class="bi bi-x-circle-fill me-2"></i>Operation failed. Please try again.';
                            alertClass = "alert-danger";
                            break;
                    }

                    alertBox.innerHTML = message;
                    alertBox.classList.remove("d-none");
                    alertBox.classList.add("alert", alertClass);

                    if (window.history.replaceState) {
                        const url = new URL(window.location);
                        url.searchParams.delete("success");
                        window.history.replaceState({}, document.title, url.pathname);
                    }
                }
            });

            function handleEditClick(button) {
                document.getElementById("editNotID").value = button.getAttribute("data-id");
                document.getElementById("editNotTitle").value = button.getAttribute("data-title");
                document.getElementById("editNotDescription").value = button.getAttribute("data-description");

                new bootstrap.Modal(document.getElementById('editNotificationModal')).show();
            }

            function confirmDelete(event) {
                if (!confirm("Are you sure you want to delete this notification?")) {
                    event.preventDefault();
                    return false;
                }
                return true;
            }

            document.getElementById("notificationSearch").addEventListener("input", function () {
                const keyword = this.value.toLowerCase().trim();
                const rows = document.querySelectorAll("table tbody tr");

                rows.forEach(row => {
                    const title = row.cells[1].textContent.toLowerCase();
                    row.style.display = title.includes(keyword) ? "" : "none";
                });
            });
        </script>

    </body>
</html>