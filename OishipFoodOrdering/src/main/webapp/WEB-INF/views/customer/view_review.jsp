<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Review" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Review" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>View Review</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <h3 class="mb-4">Your Reviews</h3>

            <%
                if (reviews != null && !reviews.isEmpty()) {
                    for (Review review : reviews) {
            %>
            <div class="card p-4 mb-3">
                <p><strong>Dish:</strong> <%= review.getDishName()%></p> 
                <p><strong>Rating:</strong> ⭐ <%= review.getRating()%> / 5</p>
                <p><strong>Comment:</strong> <%= review.getComment()%></p>
                <p><strong>Submitted at:</strong> <%= sdf.format(review.getReviewCreatedAt())%></p>
                <!-- Nút xoá đánh giá -->
                <form action="<%= request.getContextPath()%>/customer/view-review" method="post" onsubmit="return confirm('Are you sure you want to delete this review?');">
                    <input type="hidden" name="reviewID" value="<%= review.getReviewID()%>">
                    <button type="submit" class="btn btn-danger btn-sm mt-2">Delete</button>
                </form>
            </div>
            <%
                }
            } else {
            %>
            <div class="alert alert-info">You haven't submitted any reviews for this order.</div>
            <%
                }
            %>

            <div class="mt-3">
                <a href="<%= request.getContextPath()%>/customer/order" class="btn btn-secondary">&laquo; Back to Orders</a>
            </div>
        </div>

    </body>
</html>
