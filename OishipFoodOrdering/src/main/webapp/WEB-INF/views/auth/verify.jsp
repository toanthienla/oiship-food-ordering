<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@page import="java.time.LocalDateTime"%> 
<%@page import="java.time.Duration"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Verify Google Account - Oiship</title>
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet"
            />
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
            rel="stylesheet"
            />
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
            .title-icon {
                margin-right: 8px;
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
                transition: background 0.3s;
                color: white;
            }
            .btn-verify:hover {
                background: #218838;
                color: white;
            }
            .btn-verify:active {
                color: white;
            }
            .btn-resend {
                width: 100%;
                background: #007bff;
                border: none;
                border-radius: 5px;
                padding: 10px;
                color: #fff;
                transition: background 0.3s;
                margin-top: 10px;
            }
            .btn-resend:hover {
                background: #0056b3;
                color: white;
            }
            .btn-resend:active {
                background: white;
                color: white;
            }
        </style>
    </head>
    <body>
        <!-- Logo -->
        <a href="/OishipFoodOrdering"><img src="images/logo_1.png" alt="Oiship Logo" class="logo" /></a>

        <div class="verify-card">
            <h2>
                <i class="bi bi-shield-check title-icon"></i> Enter Verification
                Code
            </h2>

            <% if (request.getAttribute("error") != null) {%>
            <p class="error-message"><%= request.getAttribute("error")%></p>
            <% } %>

            <form action="verify" method="POST" id="verifyForm">
                <input
                    type="text"
                    name="code"
                    class="form-control"
                    placeholder="Enter 6-digit code"
                    required
                    maxlength="6"
                    pattern="\d{6}"
                    title="Please enter a 6-digit code"
                    />
                <button type="submit" class="btn btn-verify" id="verifyButton">
                    <i class="bi bi-check-circle title-icon"></i> Verify
                </button>
                <a
                    href="send-verification-email"
                    class="btn btn-resend"
                    id="resendButton"
                    ><i class="bi bi-arrow-repeat title-icon"></i> Resend
                    Code</a
                >
            </form>
        </div>

        <script>
            // Lấy thời gian hết hạn từ server
            <%
                LocalDateTime expiryTime = (LocalDateTime) session.getAttribute("codeExpiryTime");
                boolean isExpired = false;
                if (expiryTime != null) {
                    Duration duration = Duration.between(LocalDateTime.now(), expiryTime);
                    isExpired = duration.getSeconds() <= 0;
                }
            %>

            // Giữ nguyên các biến cũ (trừ countdownElement và timeLeft)
            const verifyButton = document.getElementById('verifyButton');
            const resendButton = document.getElementById('resendButton');
            const verifyForm = document.getElementById('verifyForm');

            // Kiểm tra nếu mã đã hết hạn ngay khi tải trang
            if (<%= isExpired%>) {
                verifyButton.disabled = true;
                verifyButton.innerHTML = '<i class="bi bi-x-circle title-icon"></i> Code Expired';
            }

            // Hiệu ứng loading khi submit form và kiểm tra thời gian
            verifyForm.addEventListener('submit', function (e) {
                // Kiểm tra thời gian hết hạn phía server, nhưng client cũng kiểm tra sơ bộ
                if (verifyButton.disabled) {
                    e.preventDefault();
                    return;
                }
                verifyButton.disabled = true;
                verifyButton.innerHTML = '<i class="bi bi-arrow-clockwise title-icon"></i> Verifying...';
            });

            // Hiệu ứng loading khi resend code
            resendButton.addEventListener('click', function (e) {
                e.preventDefault(); // Ngăn chuyển hướng mặc định
                resendButton.innerHTML = '<i class="bi bi-arrow-repeat title-icon"></i> Sending...';
                resendButton.classList.add('disabled');

                // Gửi yêu cầu resend code
                fetch('send-verification-email', {
                    method: 'GET'
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                // Kích hoạt lại nút Verify sau khi gửi lại mã
                                verifyButton.disabled = false;
                                verifyButton.innerHTML = '<i class="bi bi-check-circle title-icon"></i> Verify';
                                resendButton.innerHTML = '<i class="bi bi-arrow-repeat title-icon"></i> Resend Code';
                                resendButton.classList.remove('disabled');
                            } else {
                                resendButton.innerHTML = '<i class="bi bi-arrow-repeat title-icon"></i> Resend Code';
                                resendButton.classList.remove('disabled');
                                alert('Failed to resend code: ' + (data.message || 'Please try again.'));
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            resendButton.innerHTML = '<i class="bi bi-arrow-repeat title-icon"></i> Resend Code';
                            resendButton.classList.remove('disabled');
                            alert('An error occurred while resending code.');
                        });
            });
        </script>
    </body>
</html>
