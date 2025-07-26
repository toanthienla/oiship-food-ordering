<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Long expiryMillis = (Long) session.getAttribute("codeExpiryTime");
    long secondsLeft = 300; // Default 5 minutes
    if (expiryMillis != null) {
        long now = System.currentTimeMillis();
        secondsLeft = (expiryMillis - now) / 1000;
        if (secondsLeft < 0) {
            secondsLeft = 0;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Verify Account - Oiship</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: linear-gradient(135deg, #fff4e6 0%, #ffe0b3 50%, #ffcc80 100%);
                font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                position: relative;
                overflow-x: hidden;
            }

            /* Animated background particles */
            .background-particles {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                pointer-events: none;
                z-index: 1;
            }

            .particle {
                position: absolute;
                background: rgba(255, 152, 0, 0.1);
                border-radius: 50%;
                animation: float 6s ease-in-out infinite;
            }

            .particle:nth-child(1) { width: 20px; height: 20px; top: 20%; left: 10%; animation-delay: 0s; }
            .particle:nth-child(2) { width: 15px; height: 15px; top: 60%; left: 20%; animation-delay: 2s; }
            .particle:nth-child(3) { width: 25px; height: 25px; top: 30%; left: 80%; animation-delay: 4s; }
            .particle:nth-child(4) { width: 18px; height: 18px; top: 80%; left: 70%; animation-delay: 1s; }
            .particle:nth-child(5) { width: 22px; height: 22px; top: 10%; left: 60%; animation-delay: 3s; }

            @keyframes float {
                0%, 100% { transform: translateY(0px) scale(1); }
                50% { transform: translateY(-20px) scale(1.1); }
            }

            .logo {
                position: absolute;
                top: 20px;
                left: 30px;
                height: 60px;
                z-index: 10;
                transition: transform 0.3s ease;
            }

            .logo:hover {
                transform: scale(1.05);
            }

            .verify-container {
                position: relative;
                z-index: 5;
                animation: slideIn 0.8s ease-out;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .verify-card {
                max-width: 450px;
                width: 90%;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(255, 152, 0, 0.2);
                padding: 40px;
                border: 1px solid rgba(255, 152, 0, 0.1);
                position: relative;
                overflow: hidden;
            }

            .verify-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #ff9800, #ff5722, #ff9800);
                background-size: 200% 100%;
                animation: shimmer 2s linear infinite;
            }

            @keyframes shimmer {
                0% { background-position: -200% 0; }
                100% { background-position: 200% 0; }
            }

            .verify-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .verify-header h2 {
                font-size: 1.8rem;
                color: #e65100;
                margin-bottom: 10px;
                font-weight: 600;
            }

            .verify-header p {
                color: #666;
                font-size: 0.95rem;
                margin: 0;
            }

            .header-icon {
                font-size: 3rem;
                color: #ff9800;
                margin-bottom: 15px;
                animation: pulse 2s ease-in-out infinite;
            }

            @keyframes pulse {
                0%, 100% { transform: scale(1); }
                50% { transform: scale(1.05); }
            }

            .countdown {
                background: linear-gradient(135deg, #fff3e0, #ffe0b2);
                color: #e65100;
                font-weight: 600;
                padding: 15px;
                border-radius: 12px;
                text-align: center;
                margin-bottom: 20px;
                border: 2px solid #ffcc80;
                font-size: 1.1rem;
                position: relative;
            }

            .countdown.expired {
                background: linear-gradient(135deg, #ffebee, #ffcdd2);
                color: #d32f2f;
                border-color: #ef9a9a;
                animation: shake 0.5s ease-in-out;
            }

            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                25% { transform: translateX(-5px); }
                75% { transform: translateX(5px); }
            }

            .error-message {
                background: linear-gradient(135deg, #ffebee, #ffcdd2);
                color: #c62828;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                border-left: 4px solid #f44336;
                font-size: 0.9rem;
                animation: slideInLeft 0.5s ease-out;
            }

            @keyframes slideInLeft {
                from {
                    opacity: 0;
                    transform: translateX(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            .form-control {
                border: 2px solid #ffcc80;
                border-radius: 12px;
                padding: 15px;
                font-size: 1.2rem;
                text-align: center;
                letter-spacing: 3px;
                font-weight: 600;
                margin-bottom: 20px;
                transition: all 0.3s ease;
                background: rgba(255, 248, 225, 0.8);
            }

            .form-control:focus {
                border-color: #ff9800;
                box-shadow: 0 0 0 0.2rem rgba(255, 152, 0, 0.25);
                background: white;
                transform: scale(1.02);
            }

            .form-control:disabled {
                background: #f5f5f5;
                color: #999;
            }

            .btn {
                padding: 15px 25px;
                border-radius: 12px;
                font-weight: 600;
                font-size: 1rem;
                border: none;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .btn::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                transform: translate(-50%, -50%);
                transition: width 0.6s, height 0.6s;
            }

            .btn:hover::before {
                width: 300px;
                height: 300px;
            }

            .btn-verify {
                width: 100%;
                background: linear-gradient(135deg, #ff9800, #ff5722);
                color: white;
                margin-bottom: 15px;
                box-shadow: 0 4px 15px rgba(255, 152, 0, 0.3);
            }

            .btn-verify:hover {
                background: linear-gradient(135deg, #f57c00, #e64a19);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255, 152, 0, 0.4);
            }

            .btn-verify:disabled {
                background: #ccc;
                transform: none;
                box-shadow: none;
            }

            .btn-resend {
                width: 100%;
                background: linear-gradient(135deg, #2196f3, #1976d2);
                color: white;
                margin-bottom: 15px;
                display: none;
                box-shadow: 0 4px 15px rgba(33, 150, 243, 0.3);
            }

            .btn-resend:hover {
                background: linear-gradient(135deg, #1976d2, #1565c0);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(33, 150, 243, 0.4);
            }

            .btn-back {
                width: 100%;
                background: linear-gradient(135deg, #757575, #616161);
                color: white;
                box-shadow: 0 4px 15px rgba(117, 117, 117, 0.3);
            }

            .btn-back:hover {
                background: linear-gradient(135deg, #616161, #424242);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(117, 117, 117, 0.4);
            }

            .divider {
                text-align: center;
                margin: 20px 0;
                color: #999;
                font-size: 0.9rem;
            }

            .loading-spinner {
                display: none;
                width: 20px;
                height: 20px;
                border: 2px solid #ffffff30;
                border-top: 2px solid #ffffff;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin-right: 10px;
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            /* Success animation */
            .success-checkmark {
                display: none;
                width: 80px;
                height: 80px;
                border-radius: 50%;
                background: #4caf50;
                margin: 20px auto;
                position: relative;
            }

            .success-checkmark::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 25px;
                height: 15px;
                border: solid white;
                border-width: 0 0 3px 3px;
                transform: translate(-50%, -60%) rotate(-45deg);
            }

            @media (max-width: 576px) {
                .verify-card {
                    padding: 30px 25px;
                    margin: 20px;
                }
                
                .logo {
                    height: 50px;
                    top: 15px;
                    left: 20px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Background particles -->
        <div class="background-particles">
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
        </div>

        <a href="/OishipFoodOrdering"><img src="images/logov2.png" alt="Oiship Logo" class="logo"/></a>

        <div class="verify-container">
            <div class="verify-card">
                <div class="verify-header">
                    <i class="bi bi-shield-check header-icon"></i>
                    <h2>Email Verification</h2>
                    <p>We've sent a 6-digit code to your email address</p>
                </div>

                <% if (request.getAttribute("error") != null) {%>
                <div class="error-message">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    <%= request.getAttribute("error")%>
                </div>
                <% }%>

                <form action="verify" method="POST" id="verifyForm">
                    <input type="text" name="code" class="form-control" id="codeInput"
                           placeholder="000000"
                           required maxlength="6" pattern="[0-9]{6}" inputmode="numeric"
                           title="Please enter a 6-digit code"/>

                    <div class="countdown" id="countdown">Code expires in: 05:00</div>

                    <button type="submit" class="btn btn-verify" id="verifyButton">
                        <span class="loading-spinner" id="loadingSpinner"></span>
                        <i class="bi bi-check-circle me-2"></i>
                        <span id="verifyText">Verify Code</span>
                    </button>

                    <button type="button" class="btn btn-resend" id="resendButton">
                        <i class="bi bi-arrow-repeat me-2"></i>
                        <span id="resendText">Resend Code</span>
                    </button>

                    <div class="divider">
                        <i class="bi bi-three-dots"></i>
                    </div>

                    <a href="/OishipFoodOrdering/register" class="btn btn-back">
                        <i class="bi bi-arrow-left me-2"></i>
                        Back to Registration
                    </a>
                </form>

                <div class="success-checkmark" id="successCheckmark"></div>
            </div>
        </div>

        <script>
            const countdownEl = document.getElementById('countdown');
            const resendButton = document.getElementById('resendButton');
            const verifyButton = document.getElementById('verifyButton');
            const codeInput = document.getElementById('codeInput');
            const loadingSpinner = document.getElementById('loadingSpinner');
            const verifyText = document.getElementById('verifyText');
            const resendText = document.getElementById('resendText');
            let timeLeft = <%= secondsLeft%>;

            const pad = (num) => num.toString().padStart(2, '0');
            const tpl = (m, s) => "Code expires in: " + pad(m) + ":" + pad(s);

            const updateCountdown = () => {
                if (timeLeft <= 0) {
                    countdownEl.textContent = "Code expired!";
                    countdownEl.classList.add('expired');
                    verifyButton.disabled = true;
                    codeInput.disabled = true;
                    resendButton.style.display = 'block';
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

            // Form submit animation
            document.getElementById('verifyForm').addEventListener('submit', function(e) {
                loadingSpinner.style.display = 'inline-block';
                verifyText.textContent = 'Verifying...';
                verifyButton.disabled = true;
            });

            // Auto-format input
            codeInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                e.target.value = value;
                
                if (value.length === 6) {
                    e.target.style.borderColor = '#4caf50';
                } else {
                    e.target.style.borderColor = '#ffcc80';
                }
            });

            // Resend code functionality
            resendButton.addEventListener('click', function () {
                resendText.textContent = 'Sending...';
                resendButton.disabled = true;

                fetch('resend', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    }
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        // Show success message
                        const successMsg = document.createElement('div');
                        successMsg.className = 'alert alert-success';
                        successMsg.innerHTML = '<i class="bi bi-check-circle me-2"></i>New verification code sent successfully!';
                        successMsg.style.animation = 'slideInLeft 0.5s ease-out';
                        document.querySelector('.verify-card').insertBefore(successMsg, document.querySelector('form'));
                        
                        setTimeout(() => successMsg.remove(), 3000);

                        // Reset timer to 5 minutes
                        timeLeft = 300;
                        countdownEl.textContent = tpl(5, 0);
                        countdownEl.classList.remove('expired');
                        verifyButton.disabled = false;
                        codeInput.disabled = false;
                        codeInput.value = "";
                        codeInput.focus();

                        // Hide resend button and reset
                        resendButton.style.display = 'none';
                        resendButton.disabled = false;
                        resendText.textContent = 'Resend Code';

                        // Restart countdown
                        clearInterval(timer);
                        timer = setInterval(updateCountdown, 1000);
                    } else {
                        alert("Error: " + (data.error || data.message || "Unknown error"));
                        resendButton.disabled = false;
                        resendText.textContent = 'Resend Code';
                    }
                })
                .catch(err => {
                    alert("Request failed. Please try again.");
                    console.error(err);
                    resendButton.disabled = false;
                    resendText.textContent = 'Resend Code';
                });
            });

            // Add some interactive effects
            document.querySelectorAll('.btn').forEach(btn => {
                btn.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                });
                
                btn.addEventListener('mouseleave', function() {
                    if (!this.disabled) {
                        this.style.transform = 'translateY(0)';
                    }
                });
            });
        </script>
    </body>
</html>