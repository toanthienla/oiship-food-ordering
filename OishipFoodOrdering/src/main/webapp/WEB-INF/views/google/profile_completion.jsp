<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Complete Your Profile</title>
        <link rel="stylesheet" href="css/bootstrap.css"/>
        <script src="js/bootstrap.bundle.js"></script>
        <style>
            .role-form {
                display: none;
            }
        </style>
    </head>
    <body class="d-flex align-items-center justify-content-center" style="min-height: 100vh; background-color: #f5f5f5;">
        <div class="card p-4" style="max-width: 600px; width: 100%;">
            <h2 class="text-center mb-4">Complete Your Profile</h2>

            <!-- CUSTOMER FORM -->
            <form id="form-customer" class="role-form" action="profile-completion" method="POST">
                <input type="hidden" name="role" value="customer"/>
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" class="form-control" value="${sessionScope.oauth_email}" disabled />
                    <input type="hidden" name="email" value="${sessionScope.oauth_email}" />
                </div>
                <div class="mb-3">
                    <label>Name</label>
                    <input type="text" name="name" class="form-control" value="${sessionScope.oauth_name}" required />
                </div>
                <div class="mb-3">
                    <label>Phone Number</label>
                    <input type="text" name="phone" class="form-control" required pattern="0[0-9]{9}" placeholder="0xxxxxxxxx" />
                </div>
                <div class="mb-3">
                    <label>Address</label>
                    <input type="text" name="address" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required minlength="8" />
                </div>
                <div class="mb-3">
                    <label>Confirm Password</label>
                    <input type="password" name="confirm_password" class="form-control" required minlength="8" />
                </div>
                <button type="submit" class="btn btn-primary w-100">Create Account</button>
            </form>

            <!-- RESTAURANT FORM -->
            <form id="form-restaurantmanager" class="role-form" action="profile-completion" method="POST">
                <input type="hidden" name="role" value="restaurantmanager"/>
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" class="form-control" value="${sessionScope.oauth_email}" disabled />
                    <input type="hidden" name="email" value="${sessionScope.oauth_email}" />
                </div>
                <div class="mb-3">
                    <label>Restaurant Name</label>
                    <input type="text" name="name" class="form-control" value="${sessionScope.oauth_name}" required />
                </div>
                <div class="mb-3">
                    <label>Phone Number</label>
                    <input type="text" name="phone" class="form-control" required pattern="0[0-9]{9}" />
                </div>
                <div class="mb-3">
                    <label>Address</label>
                    <input type="text" name="address" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required minlength="8" />
                </div>
                <div class="mb-3">
                    <label>Confirm Password</label>
                    <input type="password" name="confirm_password" class="form-control" required minlength="8" />
                </div>
                <button type="submit" class="btn btn-primary w-100">Create Account</button>
            </form>

            <!-- SHIPPER FORM -->
            <form id="form-shipper" class="role-form" action="profile-completion" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="role" value="shipper"/>
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" class="form-control" value="${sessionScope.oauth_email}" disabled />
                    <input type="hidden" name="email" value="${sessionScope.oauth_email}" />
                </div>
                <div class="mb-3">
                    <label>Name</label>
                    <input type="text" name="name" class="form-control" value="${sessionScope.oauth_name}" required />
                </div>
                <div class="mb-3">
                    <label>Phone</label>
                    <input type="text" name="phone" class="form-control" required pattern="0[0-9]{9}" />
                </div>
                <div class="mb-3">
                    <label>Address</label>
                    <input type="text" name="address" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Citizen ID (CCCD)</label>
                    <input type="text" name="cccd" class="form-control" required pattern="[0-9]{12}" />
                </div>
                <div class="mb-3">
                    <label>Driver License Number</label>
                    <input type="text" name="driver_license" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Upload Driver License Image</label>
                    <input type="file" name="driver_license_image" class="form-control" required accept=".jpg,.png" />
                </div>
                <div class="mb-3">
                    <label>Vehicle Info</label>
                    <input type="text" name="vehicle_info" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required minlength="8" />
                </div>
                <div class="mb-3">
                    <label>Confirm Password</label>
                    <input type="password" name="confirm_password" class="form-control" required minlength="8" />
                </div>
                <button type="submit" class="btn btn-primary w-100">Create Account</button>
            </form>

            <!-- ERROR MESSAGE -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <div class="alert alert-danger mt-3"><%= error%></div>
            <%
                }
            %>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", () => {
                const role = "<%= request.getAttribute("role") != null ? request.getAttribute("role") : ""%>";
                const form = document.getElementById("form-" + role);
                if (form) {
                    form.style.display = "block";
                } else {
                    document.querySelector(".card h2").textContent = "Invalid Role or Session Expired.";
                }
            });
        </script>
    </body>
</html>
