<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Canceled</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="height: 100vh;">

    <div class="text-center border shadow p-5 rounded bg-white" style="max-width: 500px; width: 100%;">
        <h2 class="text-danger mb-3">✘ Payment Canceled</h2>
        <p class="mb-4">Your order has not been paid yet.</p>
        <a href="<%= request.getContextPath() %>/customer/confirm_order.jsp" class="btn btn-warning">
            ⟳ Try Again
        </a>
    </div>

</body>
</html>
