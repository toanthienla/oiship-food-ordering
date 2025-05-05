<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Complete Shipper Profile</title>
        <!-- Bootstrap v5 -->
        <link rel="stylesheet" href="css/bootstrap.css"/>         
        <script src="js/bootstrap.bundle.js"></script>   
    </head>
    <body class="d-flex align-items-center justify-content-center" style="min-height: 100vh; background-color: #f5f5f5;">
        <div class="card p-4" style="max-width: 600px; width: 100%;">
            <h2 class="text-center mb-4">Complete Your Shipper Profile</h2>

            <form action="shipper-profile-completion" method="POST" enctype="multipart/form-data" class="row gy-3">
                <div class="col-12">
                    <label>Email</label>
                    <input type="email" class="form-control" value="${sessionScope.oauth_email}" disabled />
                </div>

                <div class="col-12">
                    <label>Name</label>
                    <input type="text" class="form-control" value="${sessionScope.oauth_name}" disabled />
                </div>

                <div class="col-12">
                    <label>Phone</label>
                    <input type="text" name="phone" class="form-control" required pattern="0[0-9]{9}" placeholder="Phone (0xxxxxxxxx)" />
                </div>

                <div class="col-12">
                    <label>Address</label>
                    <input type="text" name="address" class="form-control" required placeholder="Your Address" />
                </div>

                <div class="col-12">
                    <label>Citizen ID (CCCD)</label>
                    <input type="text" name="cccd" class="form-control" required pattern="[0-9]{12}" placeholder="12-digit CCCD" />
                </div>

                <div class="col-12">
                    <label>Driver License Number</label>
                    <input type="text" name="driver_license" class="form-control" required placeholder="Driver License" />
                </div>

                <div class="col-12">
                    <label>Upload Driver License Image</label>
                    <input type="file" name="driver_license_image" class="form-control" required accept=".jpg,.png" />
                </div>

                <div class="col-12">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required minlength="8" placeholder="Password" />
                </div>

                <div class="col-12">
                    <label>Confirm Password</label>
                    <input type="password" name="confirm_password" class="form-control" required minlength="8" placeholder="Confirm Password" />
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
