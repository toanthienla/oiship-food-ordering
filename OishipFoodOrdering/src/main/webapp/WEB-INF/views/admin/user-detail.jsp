<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Chi Tiết Tài Khoản</title>
    </head>
    <body>
        <h2>Thông Tin Chi Tiết Tài Khoản</h2>

    <c:choose>
        <c:when test="${role == 'shipper'}">
            <p>Họ tên: ${userDetail.name}</p>
            <p>Số điện thoại: ${userDetail.phone}</p>
            <p>CMND: ${userDetail.identityNumber}</p>
            <p>Bằng lái: <img src="uploads/${userDetail.licenseImage}" width="300"/></p>
            <p>Ảnh đại diện: <img src="uploads/${userDetail.avatar}" width="150"/></p>
            <!-- các trường khác -->
        </c:when>

        <c:when test="${role == 'restaurant'}">
            <p>Tên nhà hàng: ${userDetail.restaurantName}</p>
            <p>Email: ${userDetail.email}</p>
            <p>Địa chỉ: ${userDetail.address}</p>
            <p>Logo: <img src="uploads/${userDetail.logo}" width="150"/></p>
            <p>Ảnh giấy phép: <img src="uploads/${userDetail.licenseImage}" width="300"/></p>
            <!-- các trường khác -->
        </c:when>
    </c:choose>

    <form action="approve-account" method="post">
        <input type="hidden" name="role" value="${role}">
        <input type="hidden" name="id" value="${userDetail.id}">
        <button class="btn btn-success">Duyệt</button>
    </form>
    <form action="reject-account" method="post">
        <input type="hidden" name="role" value="${role}">
        <input type="hidden" name="id" value="${userDetail.id}">
        <button class="btn btn-danger">Từ Chối</button>
    </form>

    <a href="admin-approve.jsp">⬅ Quay lại</a>
</body>
</html>
