<%@page import="model.Staff"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Admin Manage Orders - Update Status</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />

        <!-- Sidebar CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css" />

        <!-- Sidebar JS -->
        <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

        <style>
            body {
                margin: 0;
                font-family: "Segoe UI", sans-serif;
                background-color: white;
                display: flex;
                min-height: 100vh;
            }

            .main {
                margin-left: 250px;
                width: calc(100% - 250px);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                transition: margin-left 0.3s ease-in-out;
            }

            .topbar {
                height: 60px;
                background-color: #fff;
                display: flex;
                justify-content: flex-end;
                align-items: center;
                padding: 0 30px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                z-index: 999;
            }

            .topbar .profile {
                display: flex;
                align-items: center;
                gap: 20px;
                visibility: visible;
                opacity: 1;
            }

            .topbar .profile i {
                font-size: 1.3rem;
                cursor: pointer;
                color: #2c3e50;
            }

            .topbar .username {
                font-weight: 400;
                color: #333;
            }

            .content {
                padding: 30px;
                background-color: white;
                flex-grow: 1;
            }

            .menu-toggle {
                display: none;
                font-size: 1.5rem;
                cursor: pointer;
                color: #333;
            }

            .wellcome-text{
                padding: 8px;
            }

            /* Timeline container */
            .timeline {
                display: flex;
                justify-content: space-between;
                margin: 40px 0;
                position: relative;
            }

            .timeline::before {
                content: "";
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 4px;
                background: #dee2e6;
                z-index: 0;
            }

            /* Step holder */
            .status-step {
                text-align: center;
                position: relative;
                z-index: 1;
            }

            /* Default dot (gray for inactive) */
            .status-dot {
                width: 20px;
                height: 20px;
                border-radius: 50%;
                margin: 0 auto 10px;
                border: 2px solid #6c757d;
                background: #dee2e6;
            }

            /* Active dot style (only visual effect) */
            .status-dot.active {
                box-shadow: 0 0 0 4px rgba(0, 0, 0, 0.1);
                transform: scale(1.2);
            }

            /* Colored dots by status */
            .status-step[data-status="0"] .status-dot.active {
                background: #ffc0cb; /* Pink */
                border-color: #ff99aa;
            }

            .status-step[data-status="1"] .status-dot.active,
            .status-step[data-status="2"] .status-dot.active,
            .status-step[data-status="3"] .status-dot.active {
                background: #fd7e14; /* Orange */
                border-color: #e8590c;
            }

            .status-step[data-status="4"] .status-dot.active {
                background: #198754; /* Green */
                border-color: #146c43;
            }

            .status-step[data-status="5"] .status-dot.active,
            .status-step[data-status="6"] .status-dot.active {
                background: #dc3545; /* Red */
                border-color: #b02a37;
            }

            /* Label styling */
            .status-label {
                font-weight: 500;
            }

            .bg-purple-light {
                background-color: #e6ccff !important;  /* Tím nhạt */
                color: #000 !important;                /* Chữ đen */
                border: 1px solid #d6b3ff !important;  /* Viền tím nhạt */
            }

            @media (max-width: 768px) {
                .main {
                    margin-left: 0;
                }

                .main.sidebar-active {
                    margin-left: 250px;
                }

                .menu-toggle {
                    display: block;
                }

                .topbar {
                    position: fixed;
                    justify-content: space-between;
                    top: 0;
                    width: 100%;
                    left: 0;
                }

                .content {
                    padding-top: 90px;
                }

                .topbar .profile {
                    display: flex;
                    visibility: visible;
                    opacity: 1;
                }

                .notification-popup {
                    right: 10px;
                    width: 90%;
                    max-width: 300px;
                }
            }

            @media (max-width: 576px) {
                .main.sidebar-active {
                    margin-left: 200px;
                }
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <jsp:include page="admin_sidebar.jsp" />

        <div class="main">
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile"><span class="username">Hi, Admin</span></div>
            </div>

            <!--Content -->
            <div class="content">
                <div class="container">
                    <h1>Update Order Status - Order #${orderID}</h1>

                    <!-- Timeline -->
                    <div class="timeline">
                        <c:forEach var="i" begin="0" end="6">
                            <div class="status-step" data-status="${i}">
                                <div class="status-dot ${orderStatus == i ? 'active' : ''}"></div>
                                <div class="status-label">
                                    <c:choose>
                                        <c:when test="${i == 0}">Pending</c:when>
                                        <c:when test="${i == 1}">Confirmed</c:when>
                                        <c:when test="${i == 2}">Preparing</c:when>
                                        <c:when test="${i == 3}">Out for Delivery</c:when>
                                        <c:when test="${i == 4}">Delivered</c:when>
                                        <c:when test="${i == 5}">Cancelled</c:when>
                                        <c:when test="${i == 6}">Failed</c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Payment Status Icon Display -->
                    <div class="payment-status-icons d-flex justify-content-center align-items-center gap-4 mt-4 mb-4">

                        <!-- Unpaid -->
                        <div class="text-center">
                            <i class="bi bi-x-circle-fill fs-2 
                               ${paymentStatus == 0 ? 'text-danger' : 'text-secondary'} 
                               ${paymentStatus == 0 ? 'opacity-100' : 'opacity-50'}"></i>
                            <div class="small mt-1 ${paymentStatus == 0 ? 'fw-bold text-danger' : 'text-muted'}">Unpaid</div>
                        </div>

                        <!-- Paid -->
                        <div class="text-center">
                            <i class="bi bi-check-circle-fill fs-2 
                               ${paymentStatus == 1 ? 'text-success' : 'text-secondary'} 
                               ${paymentStatus == 1 ? 'opacity-100' : 'opacity-50'}"></i>
                            <div class="small mt-1 ${paymentStatus == 1 ? 'fw-bold text-success' : 'text-muted'}">Paid</div>
                        </div>

                        <!-- Refunded -->
                        <div class="text-center">
                            <i class="bi bi-arrow-counterclockwise fs-2 
                               ${paymentStatus == 2 ? 'text-warning' : 'text-secondary'} 
                               ${paymentStatus == 2 ? 'opacity-100' : 'opacity-50'}"></i>
                            <div class="small mt-1 ${paymentStatus == 2 ? 'fw-bold text-warning' : 'text-muted'}">Refunded</div>
                        </div>

                    </div>

                    <!-- Update Form -->
                    <form action="${pageContext.request.contextPath}/admin/manage-orders/update-status" method="post" class="text-center">
                        <input type="hidden" name="orderID" value="${orderID}">

                        <div class="row justify-content-center align-items-end g-3">
                            <!-- Select Order Status -->
                            <div class="col-md-4">
                                <label class="fw-semibold">Order Status:</label>
                                <select name="newStatus" class="form-select fw-semibold text-dark bg-warning border-warning" required>
                                    <option value="0" <c:if test="${orderStatus == 0}">selected</c:if>>Pending</option>
                                    <option value="1" <c:if test="${orderStatus == 1}">selected</c:if>>Confirmed</option>
                                    <option value="2" <c:if test="${orderStatus == 2}">selected</c:if>>Preparing</option>
                                    <option value="3" <c:if test="${orderStatus == 3}">selected</c:if>>Out for Delivery</option>
                                    <option value="4" <c:if test="${orderStatus == 4}">selected</c:if>>Delivered</option>
                                    <option value="5" <c:if test="${orderStatus == 5}">selected</c:if>>Cancelled</option>
                                    <option value="6" <c:if test="${orderStatus == 6}">selected</c:if>>Failed</option>
                                    </select>
                                </div>

                                <!-- Select Payment Status -->
                                <div class="col-md-4">
                                    <label class="fw-semibold">Payment Status:</label>
                                    <select name="newPaymentStatus" class="form-select fw-semibold bg-purple-light" required>
                                        <option value="0" <c:if test="${paymentStatus == 0}">selected</c:if>>Unpaid</option>
                                    <option value="1" <c:if test="${paymentStatus == 1}">selected</c:if>>Paid</option>
                                    <option value="2" <c:if test="${paymentStatus == 2}">selected</c:if>>Refunded</option>
                                    </select>
                                </div>

                                <!-- Update button -->
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-primary w-100">Update</button>
                                </div>

                                <!-- Back button -->
                                <div class="col-md-2">
                                    <a href="${pageContext.request.contextPath}/admin/manage-orders" class="btn btn-secondary w-100">Back</a>
                            </div>
                        </div>
                    </form>


                    <!-- Success/Error Message -->
                    <c:if test="${not empty message}">
                        <script>alert("${message}");</script>
                    </c:if>
                </div>

                <!-- Chi tiết đơn hàng -->
                <div class="mt-5">
                    <c:if test="${empty orderDetails}">
                        <div class="alert alert-info">No details available for this order.</div>
                    </c:if>

                    <c:if test="${not empty orderDetails}">
                        <!-- THÔNG TIN CHUNG -->
                        <div class="border rounded p-3 mb-4 bg-light">
                            <p><strong>Customer:</strong> ${orderDetails[0].customerName}</p>
                            <p><strong>Phone:</strong>
                                <c:choose>
                                    <c:when test="${empty orderDetails[0].phone}">N/A</c:when>
                                    <c:when test="${orderDetails[0].phone.startsWith('0000')}">N/A</c:when>
                                    <c:otherwise>${orderDetails[0].phone}</c:otherwise>
                                </c:choose>
                            </p>

                            <p><strong>Address:</strong>
                                <c:choose>
                                    <c:when test="${empty orderDetails[0].address}">N/A</c:when>
                                    <c:otherwise>${orderDetails[0].address}</c:otherwise>
                                </c:choose>
                            </p>
                            <p>
                                <strong>Timestamps:</strong><br />
                                <i>- Create:</i>
                                <span class="text-muted">
                                    <fmt:formatDate value="${orderDetails[0].createAt}" pattern="dd-MM-yyyy HH:mm:ss" />
                                </span><br />
                                <i>- Update:</i>
                                <span class="text-muted">
                                    <fmt:formatDate value="${orderDetails[0].updateAt}" pattern="dd-MM-yyyy HH:mm:ss" />
                                </span>
                            </p>



                            <p><strong>Voucher:</strong>
                                <c:choose>
                                    <c:when test="${empty orderDetails[0].voucherCode}">
                                        <span class="text-muted fst-italic">N/A</span>
                                    </c:when>
                                    <c:otherwise>
                                        ${orderDetails[0].voucherCode}
                                        <br/>
                                        <small class="text-success fst-italic">
                                            (${orderDetails[0].discount}
                                            <c:choose>
                                                <c:when test="${orderDetails[0].discountType eq '%'}">%</c:when>
                                                <c:when test="${orderDetails[0].discountType eq 'VND'}"> VNĐ</c:when>
                                                <c:otherwise></c:otherwise>
                                            </c:choose>
                                            off)
                                        </small>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <p><strong>Payment:</strong>
                                <c:choose>
                                    <c:when test="${orderDetails[0].paymentStatus == 0}">
                                        <span class="badge rounded-pill text-bg-danger">Unpaid</span>
                                    </c:when>
                                    <c:when test="${orderDetails[0].paymentStatus == 1}">
                                        <span class="badge rounded-pill text-bg-success">Paid</span>
                                    </c:when>
                                    <c:when test="${orderDetails[0].paymentStatus == 2}">
                                        <span class="badge rounded-pill text-bg-warning text-dark">Refunded</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge rounded-pill text-bg-secondary">Unknown</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <p><strong>Status:</strong>
                                <c:choose>
                                    <c:when test="${orderDetails[0].orderStatus == 0}">Pending</c:when>
                                    <c:when test="${orderDetails[0].orderStatus == 1}">Confirmed</c:when>
                                    <c:when test="${orderDetails[0].orderStatus == 2}">Preparing</c:when>
                                    <c:when test="${orderDetails[0].orderStatus == 3}">Out for Delivery</c:when>
                                    <c:when test="${orderDetails[0].orderStatus == 4}">Delivered</c:when>
                                    <c:when test="${orderDetails[0].orderStatus == 5}">Cancelled</c:when>
                                    <c:when test="${orderDetails[0].orderStatus == 6}">Failed</c:when>
                                    <c:otherwise>Unknown</c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <!-- BẢNG MÓN ĂN -->
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Dish</th>
                                    <th>Image</th>
                                    <th>Quantity</th>
                                    <th>Unit Price</th>
                                    <th>Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="detail" items="${orderDetails}">
                                    <tr>
                                        <td>${detail.dishName}</td>
                                        <td><img src="${detail.dishImage}" alt="${detail.dishName}" width="70" height="40"
                                                 style="cursor: pointer;"
                                                 onclick="showImageModal('${detail.dishImage}')" />
                                        </td>
                                        <td>${detail.quantity}</td>
                                        <td><fmt:formatNumber value="${detail.unitPrice}" type="number" groupingUsed="true"/> VNĐ</td>
                                        <td>
                                            <fmt:formatNumber value="${detail.unitPrice * detail.quantity}" type="number" groupingUsed="true"/> VNĐ
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- TỔNG -->
                        <div class="mt-3 border-top pt-3">
                            <div class="text-end">
                                <h5 class="fw-bold">
                                    Total Cost:
                                    <span class="text-primary">
                                        <fmt:formatNumber value="${orderDetails[0].amount}" type="number" groupingUsed="true"/> VNĐ
                                    </span>
                                </h5>
                            </div>
                        </div>

                    </c:if>
                </div>
            </div>

            <!-- Modal để hiển thị ảnh phóng to -->
            <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg"> <!-- modal-lg để ảnh to -->
                    <div class="modal-content">
                        <div class="modal-body text-center">
                            <img id="modalImage" src="" class="img-fluid" alt="Dish Image" />
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <script>
            function showImageModal(imageSrc) {
                const modalImage = document.getElementById("modalImage");
                modalImage.src = imageSrc;
                const modal = new bootstrap.Modal(document.getElementById('imageModal'));
                modal.show();
            }
        </script>
        <!-- JS -->
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.js"></script>

    </body>
</html>
