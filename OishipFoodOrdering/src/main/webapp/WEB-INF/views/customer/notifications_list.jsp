<%@page import="model.Notification"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Notification List</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4">📢 All Notifications</h2>

        <%
            List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
            if (notifications != null && !notifications.isEmpty()) {
        %>
            <ul class="list-group">
                <% int index = 0; for (Notification n : notifications) { %>
                    <li class="list-group-item">
                        <a href="#" class="text-decoration-none fw-bold" data-bs-toggle="modal" data-bs-target="#notiModal<%= index %>">
                            <%= n.getNotTitle() %>
                        </a>

                        <!-- Modal hiển thị chi tiết -->
                        <div class="modal fade" id="notiModal<%= index %>" tabindex="-1" aria-labelledby="modalLabel<%= index %>" aria-hidden="true">
                          <div class="modal-dialog">
                            <div class="modal-content">
                              <div class="modal-header">
                                <h5 class="modal-title" id="modalLabel<%= index %>"><%= n.getNotTitle() %></h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                              </div>
                              <div class="modal-body">
                                <p><%= n.getNotDescription() %></p>
                              </div>
                              <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                              </div>
                            </div>
                          </div>
                        </div>
                <% index++; } %>
            </ul>
        <% } else { %>
            <div class="alert alert-warning">There are no notifications at the moment.</div>
        <% } %>

        <a href="${pageContext.request.contextPath}/customer/home" class="btn btn-secondary mt-4">Back to Home</a>
    </div>
</body>
</html>
