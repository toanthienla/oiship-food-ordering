<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Login - Oiship</title>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="css/bootstrap.css" />
        <script src="js/bootstrap.bundle.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
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
                transform: translateY(-5%);
            }

            .logo {
                position: absolute;
                top: 65px;
                left: 30px;
                height: 45px;
            }

            .login-card {
                max-width: 900px;
                width: 100%;
                border-radius: 20px;
                background: #ffffff;
            }

            .inner-card {
                box-shadow: rgba(0, 0, 0, 0.02) 0px 1px 3px 0px, rgba(27, 31, 35, 0.15) 0px 0px 0px 1px;
                border-radius: 10px;
            }

            .nav-tabs {
                border-bottom: none;
                padding: 15px 10px;
                justify-content: center;
                border-radius: 10px 10px 0 0;
                border-bottom: 2px solid rgba(0, 0, 0, 0.08);
            }

            .nav-tabs .nav-link {
                border: none;
                border-radius: 10px;
                margin: 0 5px;
                padding: 10px 20px;
                color: #343a40;
                font-weight: 500;
            }

            .nav-tabs .nav-link:hover {
                background: #e9ecef;
                color: #007bff;
            }

            .nav-tabs .nav-link.active {
                background: #007bff;
                color: #fff;
            }

            .tab-pane {
                padding: 30px;
                border-radius: 0 0 10px 10px;
            }

            #customer {
                background-color: #ffffff;
            }
            #shipper {
                background-color: #f0f8ff;
            }
            #restaurant {
                background-color: #fff9eb;
            }
            #admin {
                background-color: #feecec;
            }

            .btn-login {
                background: #007bff;
                border: none;
                padding: 10px;
            }

            .btn-login:hover {
                background: #0056b3;
            }

            .btn-social:hover, .btn-login:hover {
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }

            .error-alert {
                animation: fadeIn 0.5s;
                font-size: 0.9rem;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>

        <a href="/OishipFoodOrdering">
            <img src="images/logo_1.png" alt="Oiship Logo" class="logo" />
        </a>

        <h1 class="display-5 fw-bold">Welcome to Oiship!</h1>
        <p class="text-muted mt-2">Don't have an account? <a href="register" class="text-decoration-none">Sign up</a></p>

        <div class="login-card">
            <div class="m-4 inner-card">
                <!-- Tabs -->
                <ul class="nav nav-tabs" id="roleTabs" role="tablist">
                    <li class="nav-item"><button class="nav-link active" id="customer-tab" data-bs-toggle="tab" data-bs-target="#customer" type="button" role="tab">Customer</button></li>
                    <li class="nav-item"><button class="nav-link" id="shipper-tab" data-bs-toggle="tab" data-bs-target="#shipper" type="button" role="tab">Shipper</button></li>
                    <li class="nav-item"><button class="nav-link" id="restaurant-tab" data-bs-toggle="tab" data-bs-target="#restaurant" type="button" role="tab">Restaurant</button></li>
                </ul>

                <div class="tab-content">
                    <!-- Customer -->
                    <div class="tab-pane fade show active" id="customer" role="tabpanel">
                        <div class="row gy-4 justify-content-center">
                            <div class="col-12 col-lg-5">
                                <form action="login" method="POST" class="login-form">
                                    <input type="hidden" name="role" value="customer" />
                                    <div class="form-floating mb-3">
                                        <input type="email" class="form-control" name="email" id="customer_email" placeholder="name@example.com" required>
                                        <label for="customer_email">Email</label>
                                    </div>
                                    <div class="form-floating mb-3">
                                        <input type="password" class="form-control" name="password" id="customer_password" placeholder="Password" required>
                                        <label for="customer_password">Password</label>
                                    </div>
                                    <div class="d-flex justify-content-between mb-3">
                                        <div><input type="checkbox" name="remember_me" /> Remember me</div>
                                        <div><a href="#" onclick="submitForgot('customer')">Forgot password?</a></div>
                                    </div>
                                    <button class="btn btn-login w-100" type="submit">Login</button>
                                </form>
                            </div>
                            <div class="col-12 col-lg-2 d-flex align-items-center justify-content-center">or</div>
                            <div class="col-12 col-lg-5">
                                <a href="google-init?role=customer" class="btn btn-danger btn-social w-100">
                                    <i class="bi bi-google me-2"></i>Sign in with Google
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Shipper -->
                    <div class="tab-pane fade" id="shipper" role="tabpanel">
                        <div class="row gy-4 justify-content-center">
                            <div class="col-12 col-lg-5">
                                <form action="login" method="POST" class="login-form">
                                    <input type="hidden" name="role" value="shipper" />
                                    <div class="form-floating mb-3">
                                        <input type="email" class="form-control" name="email" id="shipper_email" placeholder="name@example.com" required>
                                        <label for="shipper_email">Email</label>
                                    </div>
                                    <div class="form-floating mb-3">
                                        <input type="password" class="form-control" name="password" id="shipper_password" placeholder="Password" required>
                                        <label for="shipper_password">Password</label>
                                    </div>
                                    <div class="d-flex justify-content-between mb-3">
                                        <div><input type="checkbox" name="remember_me" /> Remember me</div>
                                        <div><a href="#" onclick="submitForgot('shipper')">Forgot password?</a></div>
                                    </div>
                                    <button class="btn btn-login w-100" type="submit">Login</button>
                                </form>
                            </div>
                            <div class="col-12 col-lg-2 d-flex align-items-center justify-content-center">or</div>
                            <div class="col-12 col-lg-5">
                                <a href="google-init?role=shipper" class="btn btn-danger btn-social w-100">
                                    <i class="bi bi-google me-2"></i>Continue with Google
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Restaurant -->
                    <div class="tab-pane fade" id="restaurant" role="tabpanel">
                        <div class="row gy-4 justify-content-center">
                            <div class="col-12 col-lg-5">
                                <form action="login" method="POST" class="login-form">
                                    <input type="hidden" name="role" value="restaurant" />
                                    <div class="form-floating mb-3">
                                        <input type="email" class="form-control" name="email" id="restaurant_email" placeholder="name@example.com" required>
                                        <label for="restaurant_email">Email</label>
                                    </div>
                                    <div class="form-floating mb-3">
                                        <input type="password" class="form-control" name="password" id="restaurant_password" placeholder="Password" required>
                                        <label for="restaurant_password">Password</label>
                                    </div>
                                    <div class="d-flex justify-content-between mb-3">
                                        <div><input type="checkbox" name="remember_me" /> Remember me</div>
                                        <div><a href="#" onclick="submitForgot('restaurant')">Forgot password?</a></div>
                                    </div>
                                    <button class="btn btn-login w-100" type="submit">Login</button>
                                </form>
                            </div>
                            <div class="col-12 col-lg-2 d-flex align-items-center justify-content-center">or</div>
                            <div class="col-12 col-lg-5">
                                <a href="google-init?role=restaurantmanager"
                                   class="btn btn-danger btn-social w-100">
                                    <i class="bi bi-google me-2"></i>Continue with Google
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Error alert -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger error-alert mt-4 mx-4 rounded-3">
                        <i class="bi bi-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

            </div>
        </div>

        <!-- Hidden forgot form -->
        <form id="forgotForm" action="password-recovery" method="POST" style="display:none;">
            <input type="hidden" name="email" id="forgot_email">
            <input type="hidden" name="role" id="forgot_role">
        </form>

        <script>
            function submitForgot(role) {
                const email = document.getElementById(role + "_email").value.trim();
                if (!email) {
                    alert("Please enter your email first.");
                    return;
                }
                document.getElementById("forgot_email").value = email;
                document.getElementById("forgot_role").value = role;
                document.getElementById("forgotForm").submit();
            }
        </script>

    </body>
</html>
