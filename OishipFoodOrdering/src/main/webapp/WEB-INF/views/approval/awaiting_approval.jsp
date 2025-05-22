<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <title>Approval Page</title>
        <!-- Bootstrap v5 -->
        <link rel="stylesheet" href="css/bootstrap.css" />
        <script src="js/bootstrap.bundle.js"></script>
        <style>
            body {
                background: #f8f9fa;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .approval-card {
                background: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                text-align: center;
            }
            .approval-card h3 {
                color: #ffc107;
                margin-bottom: 20px;
            }
            .btn-login {
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <div class="approval-card">
            <h3>💡 Your account is pending approve</h3>
            <a href="login" class="btn btn-primary btn-login">🔐 ReLogin</a>
        </div>
    </body>
</html>
