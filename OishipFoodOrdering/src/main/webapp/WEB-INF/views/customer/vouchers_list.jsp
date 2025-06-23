<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Voucher"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html>
<head>
    <title>Discount Vouchers</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f9f9f9;
        }
        .voucher-card {
            border-left: 5px solid #db672d;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            padding: 16px;
            background-color: #fff;
            cursor: pointer;
            height: 100%;
        }
        .voucher-code {
            font-size: 18px; /* tăng size chữ */
            font-weight: bold;
            color: #db672d;
        }
        .voucher-discount, .voucher-description {
            font-size: 14px; /* cùng size chữ */
            color: #333;
            margin-top: 8px;
        }
    </style>
</head>
<body>
<div class="container mt-4">
    <h3 class="mb-4 text-danger">🎟️ Available Vouchers</h3>

    <%
        List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
        if (vouchers != null && !vouchers.isEmpty()) {
            int index = 0;
    %>
        <div class="row mb-4">
        <%
            for (Voucher v : vouchers) {
                String modalId = "voucherModal" + v.getVoucherID();
        %>
            <div class="col-md-3 mb-4 d-flex">
                <div class="voucher-card w-100" data-bs-toggle="modal" data-bs-target="#<%= modalId %>">
                    <div class="voucher-code"><%= v.getCode() %></div>
                    <div class="voucher-discount">
                        <%= v.getDiscountType().equals("%")
                                ? "Discount " + v.getDiscount() + "%"
                                : "Discount ₫" + v.getDiscount() %>
                    </div>
                    <div class="voucher-description"><%= v.getVoucherDescription() %></div>
                </div>
            </div>

            <!-- Modal -->
            <div class="modal fade" id="<%= modalId %>" tabindex="-1" aria-labelledby="<%= modalId %>Label" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title" id="<%= modalId %>Label"><%= v.getCode() %></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p><strong>Description:</strong> <%= v.getVoucherDescription() %></p>
                            <p><strong>Discount:</strong> <%= v.getDiscountType().equals("%") ? v.getDiscount() + "%" : "₫" + v.getDiscount() %></p>                        
                            <p><strong>Max Discount Value:</strong> ₫<%= v.getMaxDiscountValue() %></p>
                            <p><strong>Min Order Value:</strong> ₫<%= v.getMinOrderValue() %></p>
                            <p><strong>Start Date:</strong> <%= v.getStartDate() %></p>
                            <p><strong>End Date:</strong> <%= v.getEndDate() %></p>                       
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        <%
                index++;
                if (index % 4 == 0 && index != vouchers.size()) {
        %>
        </div><div class="row mb-4">
        <%
                }
            }
        %>
        </div>
    <%
        } else {
    %>
        <div class="alert alert-warning">No vouchers available.</div>
    <%
        }
    %>
</div>
</body>
</html>
