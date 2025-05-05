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

            .register-card {
                max-width: 900px;
                width: 100%;
                border-radius: 20px;
                /*box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);*/
                background: #ffffff;
                /*margin: 20px;*/
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
                transition: all 0.3s ease;
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
                transition: background-color 0.5s ease, opacity 0.3s ease;
                opacity: 1;
            }
            .tab-pane.fade {
                opacity: 0;
            }
            .tab-pane.fade.show {
                opacity: 1;
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
            .form-floating label {
                color: #555;
            }
            .btn-primary {
                transition: all 0.3s ease;
            }
            .btn-primary:hover {
                /*transform: translateY(-2px);*/
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
                .nav-tabs .nav-link {
                    padding: 8px 12px;
                    font-size: 14px;
                }
                .tab-pane {
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <h1 class="display-5 fw-bold">Welcome to Oiship!</h1>
        <p class="text-muted mt-2">Already have an account? <a href="login" class="text-decoration-none">Sign in</a></p>

        <div class="register-card">
            <div class="m-4 inner-card">
                <!-- Tabs for role selection -->
                <ul class="nav nav-tabs" id="roleTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button
                            class="nav-link active"
                            id="customer-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#customer"
                            type="button"
                            role="tab"
                            aria-controls="customer"
                            aria-selected="true"
                            >
                            <i class="bi bi-person title-icon"></i>Customer
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button
                            class="nav-link"
                            id="shipper-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#shipper"
                            type="button"
                            role="tab"
                            aria-controls="shipper"
                            aria-selected="false"
                            >
                            <i class="bi bi-truck title-icon"></i>Shipper
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button
                            class="nav-link"
                            id="restaurant-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#restaurant"
                            type="button"
                            role="tab"
                            aria-controls="restaurant"
                            aria-selected="false"
                            >
                            <i class="bi bi-shop title-icon"></i>Restaurant
                        </button>
                    </li>
                </ul>

                <!-- Tab content -->
                <div class="tab-content">
                    <!-- Customer Register -->
                    <div
                        class="tab-pane fade show active"
                        id="customer"
                        role="tabpanel"
                        aria-labelledby="customer-tab"
                        >
                        <form action="register" method="POST">
                            <input type="hidden" name="role" value="customer" />
                            <div class="row gy-3 justify-content-center">
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="text"
                                            class="form-control rounded-3"
                                            name="name"
                                            id="customer_name"
                                            placeholder="Full Name"
                                            required
                                            />
                                        <label for="customer_name"
                                               >Full Name</label
                                        >
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
                                            />
                                        <label for="customer_email"
                                               >Email</label
                                        >
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
                                            />
                                        <label for="customer_phone"
                                               >Phone Number (10 digits, starts
                                            with 0)</label
                                        >
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
                                            />
                                        <label for="customer_address"
                                               >Address</label
                                        >
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
                                            />
                                        <label for="customer_password"
                                               >Password (min 8 characters)</label
                                        >
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
                                            />
                                        <label for="customer_confirm_password"
                                               >Confirm Password</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 text-center">
                                    <button
                                        class="btn btn-primary w-50 rounded-3 py-2"
                                        type="submit"
                                        >
                                        <i class="fas fa-user-plus me-2"></i
                                        >Register
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <!-- Shipper Register -->
                    <div
                        class="tab-pane fade"
                        id="shipper"
                        role="tabpanel"
                        aria-labelledby="shipper-tab"
                        >
                        <form
                            action="register"
                            method="POST"
                            enctype="multipart/form-data"
                            >
                            <input type="hidden" name="role" value="shipper" />
                            <div class="row gy-3 justify-content-center">
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="text"
                                            class="form-control rounded-3"
                                            name="name"
                                            id="shipper_name"
                                            placeholder="Full Name"
                                            required
                                            />
                                        <label for="shipper_name"
                                               >Full Name</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="email"
                                            class="form-control rounded-3"
                                            name="email"
                                            id="shipper_email"
                                            placeholder="name@example.com"
                                            required
                                            pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                            />
                                        <label for="shipper_email">Email</label>
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="tel"
                                            class="form-control rounded-3"
                                            name="phone"
                                            id="shipper_phone"
                                            placeholder="Phone Number"
                                            required
                                            pattern="0[0-9]{9}"
                                            />
                                        <label for="shipper_phone"
                                               >Phone Number (10 digits, starts
                                            with 0)</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="text"
                                            class="form-control rounded-3"
                                            name="address"
                                            id="shipper_address"
                                            placeholder="Address"
                                            required
                                            />
                                        <label for="shipper_address"
                                               >Address</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="text"
                                            class="form-control rounded-3"
                                            name="cccd"
                                            id="shipper_cccd"
                                            placeholder="CCCD"
                                            required
                                            pattern="[0-9]{12}"
                                            />
                                        <label for="shipper_cccd"
                                               >Identity Card (12 digits)</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="text"
                                            class="form-control rounded-3"
                                            name="driver_license"
                                            id="shipper_driver_license"
                                            placeholder="Driver License"
                                            required
                                            pattern="[0-9A-Za-z]{10,12}"
                                            />
                                        <label for="shipper_driver_license"
                                               >Driver License Number (10-12
                                            characters)</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="password"
                                            class="form-control rounded-3"
                                            name="password"
                                            id="shipper_password"
                                            placeholder="Password"
                                            required
                                            minlength="8"
                                            />
                                        <label for="shipper_password"
                                               >Password (min 8 characters)</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="password"
                                            class="form-control rounded-3"
                                            name="confirm_password"
                                            id="shipper_confirm_password"
                                            placeholder="Confirm Password"
                                            required
                                            minlength="8"
                                            />
                                        <label for="shipper_confirm_password"
                                               >Confirm Password</label
                                        >
                                    </div>
                                </div>
                                 <div class="col-12 col-lg-12">
                                    <div class="form-group">
                                        <label
                                            for="shipper_driver_license_image"
                                            class="form-label"
                                            >Driver License Image (.jpg, .png,
                                            max 2MB)</label
                                        >
                                        <input
                                            type="file"
                                            class="form-control rounded-3"
                                            name="driver_license_image"
                                            id="shipper_driver_license_image"
                                            accept=".jpg,.png"
                                            required
                                            />
                                    </div>
                                </div>
                                <div class="col-12 text-center">
                                    <button
                                        class="btn btn-primary w-50 rounded-3 py-2"
                                        type="submit"
                                        >
                                        <i class="fas fa-user-plus me-2"></i
                                        >Register
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <!-- Restaurant Register -->
                    <div
                        class="tab-pane fade"
                        id="restaurant"
                        role="tabpanel"
                        aria-labelledby="restaurant-tab"
                        >
                        <form action="register" method="POST">
                            <input
                                type="hidden"
                                name="role"
                                value="restaurant"
                                />
                            <div class="row gy-3 justify-content-center">
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="text"
                                            class="form-control rounded-3"
                                            name="name"
                                            id="restaurant_name"
                                            placeholder="Restaurant Name"
                                            required
                                            />
                                        <label for="restaurant_name"
                                               >Restaurant Name</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="email"
                                            class="form-control rounded-3"
                                            name="email"
                                            id="restaurant_email"
                                            placeholder="name@example.com"
                                            required
                                            pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                            />
                                        <label for="restaurant_email"
                                               >Email</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="tel"
                                            class="form-control rounded-3"
                                            name="phone"
                                            id="restaurant_phone"
                                            placeholder="Phone Number"
                                            required
                                            pattern="0[0-9]{9}"
                                            />
                                        <label for="restaurant_phone"
                                               >Phone Number (10 digits, starts
                                            with 0)</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="text"
                                            class="form-control rounded-3"
                                            name="address"
                                            id="restaurant_address"
                                            placeholder="Address"
                                            required
                                            />
                                        <label for="restaurant_address"
                                               >Restaurant Address</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="password"
                                            class="form-control rounded-3"
                                            name="password"
                                            id="restaurant_password"
                                            placeholder="Password"
                                            required
                                            minlength="8"
                                            />
                                        <label for="restaurant_password"
                                               >Password (min 8 characters)</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 col-lg-6">
                                    <div class="form-floating">
                                        <input
                                            type="password"
                                            class="form-control rounded-3"
                                            name="confirm_password"
                                            id="restaurant_confirm_password"
                                            placeholder="Confirm Password"
                                            required
                                            minlength="8"
                                            />
                                        <label for="restaurant_confirm_password"
                                               >Confirm Password</label
                                        >
                                    </div>
                                </div>
                                <div class="col-12 text-center">
                                    <button
                                        class="btn btn-primary w-50 rounded-3 py-2"
                                        type="submit"
                                        >
                                        <i class="fas fa-user-plus me-2"></i
                                        >Register
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- Success/Error message -->
                <% if (request.getAttribute("success") != null) {%>
                <div
                    class="alert alert-success success-alert mt-4 mx-4 rounded-3"
                    role="alert"
                    >
                    <i class="fas fa-check-circle me-2"></i><%=request.getAttribute("success")%>
                </div>
                <% } else if (request.getAttribute("error") != null) {%>
                <div
                    class="alert alert-danger error-alert mt-4 mx-4 rounded-3"
                    role="alert"
                    >
                    <i class="fas fa-exclamation-circle me-2"></i><%=request.getAttribute("error")%>
                </div>
                <% }%>
            </div>
        </div>
    </body>
</html>
