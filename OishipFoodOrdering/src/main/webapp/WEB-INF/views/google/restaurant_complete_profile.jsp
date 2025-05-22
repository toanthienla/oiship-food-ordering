<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Complete Your Profile - Restaurant</title>
        <!-- Bootstrap v5 -->
        <link rel="stylesheet" href="css/bootstrap.css"/>         
        <script src="js/bootstrap.bundle.js"></script>   
    </head>
    <body class="d-flex align-items-center justify-content-center" style="min-height: 100vh; background-color: #f5f5f5;">
        <div class="card p-4" style="max-width: 500px; width: 100%;">
            <h2 class="text-center mb-4">Complete Restaurant Profile</h2>

            <form action="restaurantmanager-profile-completion" method="POST" class="row gy-3">
                <div class="col-12">
                    <label>Email</label>
                    <input type="email" class="form-control" value="${sessionScope.oauth_email}" disabled />
                </div>

                <div class="col-12">
                    <label>Restaurant Name</label>
                    <input type="text" class="form-control" value="${sessionScope.oauth_name}" disabled />
                </div>

                <div class="col-12">
                    <label>Phone Number</label>
                    <input type="text" name="phone" class="form-control" placeholder="0xxxxxxxxx" required pattern="0[0-9]{9}">
                </div>

                <div class="col-12">
                    <label>Address</label>
                    <input type="text" name="address" class="form-control" placeholder="Enter your restaurant address" required>
                </div>

                <div class="col-12">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Enter password" required minlength="8">
                </div>

                <div class="col-12">
                    <label>Confirm Password</label>
                    <input type="password" name="confirm_password" class="form-control" placeholder="Re-enter password" required minlength="8">
                </div>

                <div class="col-12">
                    <button type="submit" class="btn btn-primary w-100">Create Account</button>
                </div>

                <% if (request.getAttribute("error") != null) {%>
                <div class="alert alert-danger mt-2"><%= request.getAttribute("error")%></div>
                <% }%>
            </form>

        </div>
    </body>
</html>
