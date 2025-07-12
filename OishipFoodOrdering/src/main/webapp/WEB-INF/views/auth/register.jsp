<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Register - Oiship</title>
        <link rel="stylesheet" href="css/bootstrap.css" />
        <script src="js/bootstrap.bundle.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
        <style>
            .error-message {
                color: red;
                font-size: 0.9em;
                margin-top: 5px;
            }
        </style>
    </head>
    <body class="d-flex align-items-center justify-content-center min-vh-100">
        <div class="register-card w-100 px-4" style="max-width: 900px;">
            <h1 class="text-center fw-bold">Register to Oiship</h1>
            <p class="text-muted text-center">Already have an account? <a href="login">Sign in</a></p>

            <div class="inner-card p-4 border rounded-4 shadow">
                <form action="register" method="POST" onsubmit="return validateForm();">
                    <input type="hidden" name="role" value="customer" />
                    <div class="row gy-3">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" name="fullName" id="fullName" required maxlength="255" />
                            <div id="errorFullName" class="error-message"></div>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" name="email" id="email" required maxlength="100" />
                            <div id="errorEmail" class="error-message"></div>
                        </div>
                        <div class="col-md-6">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="tel" class="form-control" name="phone" id="phone" required maxlength="10" />
                            <div id="errorPhone" class="error-message"></div>
                        </div>
                        <div class="col-md-6">
                            <label for="address" class="form-label">Address</label>
                            <input type="text" class="form-control" name="address" id="address" required maxlength="255" />
                        </div>
                        <div class="col-md-6">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" name="password" id="password" required />
                            <div id="errorPassword" class="error-message"></div>
                        </div>
                        <div class="col-md-6">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control" name="confirm_password" id="confirmPassword" required />
                            <div id="errorConfirmPassword" class="error-message"></div>
                        </div>
                    </div>
                    <div class="text-center mt-4">
                        <button class="btn btn-primary w-50" type="submit">
                            <i class="bi bi-person-plus me-2"></i>Register
                        </button>
                    </div>
                </form>

                <% if (request.getAttribute("error") != null) {%>
                <div class="alert alert-danger mt-4"><%= request.getAttribute("error")%></div>
                <% } else if (request.getAttribute("success") != null) {%>
                <div class="alert alert-success mt-4"><%= request.getAttribute("success")%></div>
                <% }%>
            </div>
        </div>

        <script>
            function validateForm() {
                let isValid = true;

                // Clear previous messages
                document.querySelectorAll('.error-message').forEach(e => e.innerText = "");

                const name = document.getElementById("fullName").value.trim();
                const email = document.getElementById("email").value.trim();
                const phone = document.getElementById("phone").value.trim();
                const password = document.getElementById("password").value;
                const confirmPassword = document.getElementById("confirmPassword").value;

                const nameRegex = /^[a-zA-ZÀ-ỹ\s]{2,}$/;
                const phoneRegex = /^0\d{9}$/;
                const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

                if (!nameRegex.test(name)) {
                    document.getElementById("errorFullName").innerText = "Full name must contain only letters and spaces.";
                    isValid = false;
                }

                if (!email.match(/[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/)) {
                    document.getElementById("errorEmail").innerText = "Invalid email format.";
                    isValid = false;
                }

                if (!phoneRegex.test(phone)) {
                    document.getElementById("errorPhone").innerText = "Phone number must be exactly 10 digits and start with 0.";
                    isValid = false;
                }

                if (!passwordRegex.test(password)) {
                    document.getElementById("errorPassword").innerText = "Password must be at least 8 characters, including letters and numbers.";
                    isValid = false;
                }

                if (password !== confirmPassword) {
                    document.getElementById("errorConfirmPassword").innerText = "Passwords do not match.";
                    isValid = false;
                }

                return isValid;
            }
        </script>
    </body>
</html>
