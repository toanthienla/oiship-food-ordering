<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="css/bootstrap.css"/>
        <script src="js/bootstrap.bundle.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            /* Existing styles remain unchanged */
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

                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/login"><i class="bi bi-box-arrow-left"></i> Logout</a></li>
                    </ul>
                </nav>







            </div>
        </div>
    </body>
</html>