<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Long expiryMillis = (Long) session.getAttribute("codeExpiryTime");
    long secondsLeft = 0;
    if (expiryMillis != null) {
        long now = System.currentTimeMillis();
        secondsLeft = (expiryMillis - now) / 1000;
        if (secondsLeft < 0) {
            secondsLeft = 0;
        }
    } else {
        secondsLeft = 60; // Mặc định 60 giây nếu chưa có
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <title>Verify Google Account - Oiship</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
        <style>
            body {
                background: white;
                font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .logo {
                position: absolute;
                top: 10px;
                left: 20px;
                height: 80px;
            }

            .verify-card {
                max-width: 400px;
                width: 100%;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 30px;
            }

            .verify-card h2 {
                font-size: 1.5rem;
                margin-bottom: 20px;
                color: #343a40;
            }

            .countdown {
                color: #dc3545;
                font-weight: bold;
                margin-bottom: 15px;
            }

            .error-message {
                color: #dc3545;
                font-size: 0.9rem;
                margin-bottom: 15px;
            }

            .form-control {
                border-radius: 5px;
                margin-bottom: 15px;
            }

            .btn-verify {
                width: 100%;
                background: #28a745;
                border: none;
                border-radius: 5px;
                padding: 10px;
                color: white;
            }

            .btn-verify:hover {
                background: #218838;
            }

            .btn-resend {
                width: 100%;
                background: #007bff;
                border: none;
                border-radius: 5px;
                padding: 10px;
                color: #fff;
                margin-top: 10px;
                display: none;
            }

            .btn-resend:hover {
                background: #0056b3;
            }
        </style>
    </head>
    <body>

        <a href="/OishipFoodOrdering"><img src="images/logo_1.png" alt="Oiship Logo" class="logo"/></a>

        <div class="verify-card">
            <h2><i class="bi bi-shield-check"></i> Enter Verification Code</h2>

            <% if (request.getAttribute("error") != null) {%>
            <p class="error-message"><%= request.getAttribute("error")%></p>
            <% }%>

            <form action="verify" method="POST" id="verifyForm">
                <input type="text" name="code" class="form-control" id="codeInput"
                       placeholder="Enter 6-digit code"
                       required maxlength="6" pattern="[0-9]{6}" inputmode="numeric"
                       title="Please enter a 6-digit code"/>

                <div class="countdown" id="countdown">Code expires in: 01:00</div>

                <button type="submit" class="btn btn-verify" id="verifyButton">
                    <i class="bi bi-check-circle"></i> Verify
                </button>

                <button type="button" class="btn btn-resend" id="resendButton" style="display: none;">
                    <i class="bi bi-arrow-repeat"></i> Resend Code
                </button>
            </form>
        </div>

        <script>
            const countdownEl = document.getElementById('countdown');
            const resendButton = document.getElementById('resendButton');
            const verifyButton = document.getElementById('verifyButton');
            const codeInput = document.getElementById('codeInput');
            let timeLeft = <%= secondsLeft%>;

            const pad = (num) => num.toString().padStart(2, '0');
            const tpl = (m, s) => "Code expires in: " + pad(m) + ":" + pad(s);

            const updateCountdown = () => {
                if (timeLeft <= 0) {
                    countdownEl.textContent = "Code expired.";
                    verifyButton.disabled = true;
                    codeInput.disabled = true;
                    // Tạm thời vô hiệu hóa resend để tập trung khôi phục gửi ban đầu
                    clearInterval(timer);
                    return;
                }
                const minutes = Math.floor(timeLeft / 60);
                const seconds = timeLeft % 60;
                countdownEl.textContent = tpl(minutes, seconds);
                timeLeft--;
            };

            let timer = setInterval(updateCountdown, 1000);
            updateCountdown();
        </script>

    </body>
</html>