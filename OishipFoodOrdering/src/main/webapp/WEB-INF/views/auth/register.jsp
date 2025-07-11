<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Register - Oiship</title>
        <!-- Bootstrap v5 -->
        <link rel="stylesheet" href="css/bootstrap.css" />
        <script src="js/bootstrap.bundle.js"></script>
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
            />
        <style>
            body {
                background: #ffffff;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                margin: 0;
                padding: 0;
                font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                transform: translateY(-5%); /* Shift slightly up */
            }

            .logo {
                position: absolute;
                top: 65px;
                left: 30px;
                height: 45px;
            }

            .register-card {
                max-width: 900px;
                width: 100%;
                border-radius: 20px;
                background: #ffffff;
            }
            .inner-card {
                box-shadow: rgba(0, 0, 0, 0.02) 0px 1px 3px 0px, rgba(27, 31, 35, 0.15) 0px 0px 0px 1px;
                border-radius: 10px;
                padding: 30px;
            }
            .form-floating label {
                color: #555;
            }
            .btn-primary {
                transition: all 0.3s ease;
            }
            .btn-primary:hover {
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }
            .error-alert,
            .success-alert {
                animation: fadeIn 0.5s;
            }
            .title-icon {
                margin-right: 8px;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }
            @media (max-width: 576px) {
                .register-card {
                    margin: 10px;
                }
                .inner-card {
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Logo -->
        <a href="/OishipFoodOrdering"><img src="images/logo_1.png" alt="Oiship Logo" class="logo" /></a>

        <h1 class="display-5 fw-bold">Welcome to Oiship!</h1>
        <p class="text-muted mt-2">Already have an account? <a href="login" class="text-decoration-none">Sign in</a></p>

        <div class="register-card">
            <div class="m-4 inner-card">
                <!-- Customer Registration Form -->
                <form action="register" method="POST">
                    <input type="hidden" name="role" value="customer" />
                    <div class="row gy-3 justify-content-center">
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="text"
                                    class="form-control rounded-3"
                                    name="fullName"
                                    id="customer_name"
                                    placeholder="Full Name"
                                    required
                                    maxlength="255"
                                    />
                                <label for="customer_name">Full Name</label>
                            </div>
                        </div>
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="email"
                                    class="form-control rounded-3"
                                    name="email"
                                    id="customer_email"
                                    placeholder="name@example.com"
                                    required
                                    pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                    maxlength="100"
                                    />
                                <label for="customer_email">Email</label>
                            </div>
                        </div>
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="tel"
                                    class="form-control rounded-3"
                                    name="phone"
                                    id="customer_phone"
                                    placeholder="Phone Number"
                                    required
                                    pattern="0[0-9]{9}"
                                    maxlength="15"
                                    />
                                <label for="customer_phone">Phone Number (10 digits, starts with 0)</label>
                            </div>
                        </div>
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="text"
                                    class="form-control rounded-3"
                                    name="address"
                                    id="customer_address"
                                    placeholder="Address"
                                    required
                                    maxlength="255"
                                    />
                                <label for="customer_address">Address</label>
                            </div>
                        </div>
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="password"
                                    class="form-control rounded-3"
                                    name="password"
                                    id="customer_password"
                                    placeholder="Password"
                                    required
                                    minlength="8"
                                    maxlength="255"
                                    />
                                <label for="customer_password">Password (min 8 characters)</label>
                            </div>
                        </div>
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="password"
                                    class="form-control rounded-3"
                                    name="confirm_password"
                                    id="customer_confirm_password"
                                    placeholder="Confirm Password"
                                    required
                                    minlength="8"
                                    maxlength="255"
                                    />
                                <label for="customer_confirm_password">Confirm Password</label>
                            </div>
                        </div>
                        <div class="col-12 text-center">
                            <button
                                class="btn btn-primary w-50 rounded-3 py-2"
                                type="submit"
                                >
                                <i class="bi bi-person-plus me-2"></i>Register
                            </button>
                        </div>
                    </div>
                </form>

                <!-- Success/Error message -->
                <% if (request.getAttribute("success") != null) {%>
                <div
                    class="alert alert-success success-alert mt-4 mx-4 rounded-3"
                    role="alert"
                    >
                    <i class="bi bi-check-circle me-2"></i><%=request.getAttribute("success")%>
                </div>
                <% } else if (request.getAttribute("error") != null) {%>
                <div
                    class="alert alert-danger error-alert mt-4 mx-4 rounded-3"
                    role="alert"
                    >
                    <i class="bi bi-exclamation-circle me-2"></i><%=request.getAttribute("error")%>
                </div>
                <% }%>
            </div>
        </div>
    </body>
</html>