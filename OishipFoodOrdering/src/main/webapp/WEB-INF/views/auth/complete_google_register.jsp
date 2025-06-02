<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Hoàn tất đăng ký bằng Google - Oiship</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
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
            .error-alert {
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
        <a href="/OishipFoodOrdering"><img src="images/logo_1.png" alt="Oiship Logo" class="logo" /></a>

        <h1 class="display-5 fw-bold">Continue with google</h1>
        <p class="text-muted mt-2">Already have an account? <a href="login" class="text-decoration-none">Sign in</a></p>

        <div class="register-card">
            <div class="m-4 inner-card">
                <form action="${pageContext.request.contextPath}/google-register" method="post">
                    <div class="row gy-3 justify-content-center">
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="text"
                                    class="form-control rounded-3"
                                    name="fullName"
                                    id="fullName"
                                    placeholder="Full Name"
                                    required
                                    maxlength="255"
                                    value="${fullName != null ? fullName : ''}"
                                    />
                                <label for="fullName">Full Name</label>
                            </div>
                        </div>
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="email"
                                    class="form-control rounded-3"
                                    name="email"
                                    id="email"
                                    placeholder="name@example.com"
                                    readonly
                                    value="${email != null ? email : ''}"
                                    />
                                <label for="email">Email</label>
                            </div>
                        </div>
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="tel"
                                    class="form-control rounded-3"
                                    name="phone"
                                    id="phone"
                                    placeholder="Phone Number"
                                    value="${phone != null ? phone : ''}"
                                    required
                                    />
                                <label for="phone">Phone Number</label>
                            </div>
                        </div>
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="text"
                                    class="form-control rounded-3"
                                    name="address"
                                    id="address"
                                    placeholder="Address"
                                    value="${address != null ? address : ''}"
                                    required
                                    />
                                <label for="address">Address</label>
                            </div>
                        </div>
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="password"
                                    class="form-control rounded-3"
                                    name="password"
                                    id="password"
                                    placeholder="Password"
                                    required
                                    />
                                <label for="password">Password</label>
                            </div>
                        </div>
                        <div class="col-12 col-lg-6">
                            <div class="form-floating">
                                <input
                                    type="password"
                                    class="form-control rounded-3"
                                    name="confirmPassword"
                                    id="confirmPassword"
                                    placeholder="Confirm Password"
                                    required
                                    />
                                <label for="confirmPassword">Confirm Password</label>
                            </div>
                        </div>
                        <div class="col-12 text-center">
                            <button class="btn btn-primary w-50 rounded-3 py-2" type="submit">
                                <i class="bi bi-person-plus me-2"></i>Submit
                            </button>
                        </div>
                    </div>
                </form>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger error-alert mt-4 mx-4 rounded-3" role="alert">
                        <i class="bi bi-exclamation-circle me-2"></i>${errorMessage}
                    </div>
                </c:if>
            </div>
        </div>

        <script>
            function validateForm() {
                const password = document.getElementById("password").value;
                const confirmPassword = document.getElementById("confirmPassword").value;
                if (password !== confirmPassword) {
                    alert("Passwords do not match!");
                    return false;
                }
                return true;
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>