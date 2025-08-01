<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Successful</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="height: 100vh;">

    <div class="text-center border shadow p-5 rounded bg-white" style="max-width: 500px; width: 100%;">
        <h2 class="text-success mb-3">✔ Payment Successful!</h2>
        <p class="mb-4">Thank you for using our service.</p>
        <a href="<%= request.getContextPath() %>/customer/order" class="btn btn-primary">⬅ Back to Order</a>
    </div>

</body>
</html>
