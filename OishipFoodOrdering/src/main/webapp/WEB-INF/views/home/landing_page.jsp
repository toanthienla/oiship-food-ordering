<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Welcome to Oiship</title>

        <!-- Bootstrap 5 -->
        <link rel="stylesheet" href="css/bootstrap.css" />
        <script src="js/bootstrap.bundle.js"></script>

        <style>
            body {
                background: #fff;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                margin: 0;
                font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                position: relative;
            }

            .logo {
                position: absolute;
                top: 10px;
                left: 20px;
                height: 80px;
            }

            .welcome-title {
                margin-top: -50px;
            }

            .footer-text {
                font-size: 0.9rem;
                color: gray;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <!-- Logo -->
        <a href="/OishipFoodOrdering"><img src="images/logo_1.png" alt="Oiship Logo" class="logo" /></a>

        <!-- Welcome Message -->
        <div class="text-center welcome-title">
            <h1 class="display-5 fw-bold">Welcome to Oiship</h1>
        </div>

        <!-- Account Link -->
        <p class="footer-text">
            Already have an account? <a href="login">Sign in</a>
        </p>
    </body>
</html>
