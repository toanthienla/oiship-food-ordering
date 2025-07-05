<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Contact Us</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }

        .contact-container {
            max-width: 600px;
            margin: 60px auto;
            background-color: #fff;
            padding: 40px 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        }

        h2 {
            color: #EF5D10;
            font-weight: bold;
            text-align: center;
            margin-bottom: 30px;
        }

        .form-label {
            color: #EF5D10;
            font-weight: 600;
        }

        .form-control {
            border-radius: 10px;
            transition: 0.3s ease;
            width: 100%;
            min-height: 45px;
        }

        textarea.form-control {
            min-height: 150px;
        }

        .form-control:focus {
            border-color: #EF5D10;
            box-shadow: 0 0 0 0.2rem rgba(239, 93, 16, 0.25);
        }

        .btn-orange {
            background-color: #EF5D10;
            border: none;
            color: #fff;
            font-weight: 600;
            padding: 10px 30px;
            border-radius: 8px;
        }

        .btn-orange:hover {
            background-color: #d44e09;
        }

        .btn-outline-orange {
            border: 2px solid #EF5D10;
            color: #EF5D10;
            font-weight: 600;
            padding: 10px 30px;
            border-radius: 8px;
            background-color: #fff;
        }

        .btn-outline-orange:hover {
            background-color: #ffe5da;
            color: #d44e09;
        }

        .alert-success {
            background-color: #fbe9e3;
            border-left: 5px solid #EF5D10;
            color: #333;
            border-radius: 8px;
            padding: 10px 15px;
            margin-top: 15px;
        }

        .char-count {
            font-size: 13px;
            color: #999;
            text-align: right;
        }

        .btn-group-custom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }
    </style>

    <script>
        function validateContactForm(event) {
            const subject = document.getElementById("subject").value.trim();
            const message = document.getElementById("message").value.trim();

            if (subject.length > 255) {
                alert("Subject cannot exceed 255 characters.");
                event.preventDefault();
                return false;
            }

            if (message.length > 2000) {
                alert("Message cannot exceed 2000 characters.");
                event.preventDefault();
                return false;
            }
        }

     
    </script>
</head>
<body>

<div class="contact-container">
    <h2>Contact Us</h2>
    <form action="${pageContext.request.contextPath}/customer/contact" method="post" onsubmit="validateContactForm(event)">
        <div class="mb-3">
            <label for="subject" class="form-label">Subject</label>
              <textarea type="text" name="subject" id="subject" class="form-control" required ></textarea>
                   
          
        </div>
        <div class="mb-3">
            <label for="message" class="form-label">Message</label>
            <textarea name="message" id="message" class="form-control" rows="5" required></textarea>
          
        </div>

        <div class="btn-group-custom">
            <a href="${pageContext.request.contextPath}/customer" class="btn btn-outline-orange"> Back to Menu</a>
            <button type="submit" class="btn btn-orange">Send Message</button>
        </div>
    </form>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
</div>

</body>
</html>
