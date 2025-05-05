<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Shipper, model.RestaurantManager" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Pending Account Approvals</title>
        <!-- Bootstrap v5 -->
        <link rel="stylesheet" href="css/bootstrap.css"/>         
        <script src="js/bootstrap.bundle.js"></script>   
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body {
                background: #f5f5f5;
            }
            .sidebar {
                background: #343a40;
                color: #fff;
                height: 100vh;
                position: fixed;
                width: 220px;
            }
            .sidebar .nav-link {
                color: #adb5bd;
            }
            .sidebar .nav-link:hover {
                color: #fff;
                background: #495057;
                border-radius: 5px;
            }
            .main-content {
                margin-left: 230px;
                padding: 20px;
            }
            .table-container {
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
            .status-pending {
                color: orange;
                font-weight: bold;
            }
            .topbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1rem;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <nav class="col-md-2 sidebar p-3">
                    <div class="text-center mb-4">
                        <i class="bi bi-person-circle" style="font-size: 4rem;"></i>
                        <h4>Admin</h4>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item"><a class="nav-link" href="admin"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link active" href="pending-accounts"><i class="bi bi-clock-history"></i> Pending Approvals</a></li>
                        <li class="nav-item"><a class="nav-link" href="logout"><i class="bi bi-box-arrow-left"></i> Logout</a></li>
                    </ul>
                </nav>

                <main class="col-md-10 main-content">
                    <div class="topbar">
                        <h2><i class="bi bi-clock-history"></i> Pending Approvals</h2>
                    </div>

                    <!-- Pending Shippers -->
                    <div class="table-container">
                        <h4><i class="bi bi-truck"></i> Pending Shippers</h4>
                        <table class="table table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>STT</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int shipperIndex = 1;
                                    List<Shipper> shippers = (List<Shipper>) request.getAttribute("shippers");
                                    for (Shipper s : shippers) {
                                        if (s.getStatusId() != 2)
                                            continue;
                                %>
                                <tr>
                                    <td><%= shipperIndex++%></td>
                                    <td><%= s.getName()%></td>
                                    <td><%= s.getEmail()%></td>
                                    <td><%= s.getPhone()%></td>
                                    <td><span class="status-pending">Pending Approval</span></td>
                                    <td>
                                        <form action="pending-accounts" method="post" class="d-inline">
                                            <input type="hidden" name="type" value="shipper">
                                            <input type="hidden" name="id" value="<%= s.getShipperId()%>">
                                            <input type="hidden" name="status" value="1">
                                            <button class="btn btn-success btn-sm" type="submit"><i class="bi bi-check-circle"></i> Approve</button>
                                        </form>
                                        <form action="pending-accounts" method="post" class="d-inline">
                                            <input type="hidden" name="type" value="shipper">
                                            <input type="hidden" name="id" value="<%= s.getShipperId()%>">
                                            <input type="hidden" name="status" value="3">
                                            <button class="btn btn-danger btn-sm" type="submit"><i class="bi bi-x-circle"></i> Reject</button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pending Restaurants -->
                    <div class="table-container">
                        <h4><i class="bi bi-shop"></i> Pending Restaurants</h4>
                        <table class="table table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>STT</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int restIndex = 1;
                                    List<RestaurantManager> restaurants = (List<RestaurantManager>) request.getAttribute("restaurants");
                                    for (RestaurantManager r : restaurants) {
                                        if (r.getStatusId() != 2)
                                            continue;
                                %>
                                <tr>
                                    <td><%= restIndex++%></td>
                                    <td><%= r.getName()%></td>
                                    <td><%= r.getEmail()%></td>
                                    <td><%= r.getPhone()%></td>
                                    <td><span class="status-pending">Pending Approval</span></td>
                                    <td>
                                        <form action="pending-accounts" method="post" class="d-inline">
                                            <input type="hidden" name="type" value="restaurant">
                                            <input type="hidden" name="id" value="<%= r.getRestaurantId()%>">
                                            <input type="hidden" name="status" value="1">
                                            <button class="btn btn-success btn-sm" type="submit"><i class="bi bi-check-circle"></i> Approve</button>
                                        </form>
                                        <form action="pending-accounts" method="post" class="d-inline">
                                            <input type="hidden" name="type" value="restaurant">
                                            <input type="hidden" name="id" value="<%= r.getRestaurantId()%>">
                                            <input type="hidden" name="status" value="3">
                                            <button class="btn btn-danger btn-sm" type="submit"><i class="bi bi-x-circle"></i> Reject</button>
                                        </form>
                                    </td>
                                </tr>
                                <% }%>
                            </tbody>
                        </table>
                    </div>

                </main>
            </div>
        </div>
    </body>
</html>
