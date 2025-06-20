<%@ page import="java.util.List" %>
<%@ page import="model.Cart" %>
<%@ page import="model.Dish" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    </head>
    <body>
        <div class="container mt-4">
            <h2 class="mb-4">Giỏ hàng của bạn</h2>

            <%
                List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
                String error = (String) request.getAttribute("error");
            %>

            <% if (error != null) {%>
            <div class="alert alert-danger"><%= error%></div>
            <% } %>

            <% if (cartItems != null && !cartItems.isEmpty()) { %>
            <table class="table table-bordered table-striped align-middle text-center">
                <thead class="table-dark">
                    <tr>
                        <th>Hình ảnh</th>
                        <th>Tên món</th>
                        <th>Số lượng</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Cart item : cartItems) {
                            Dish dish = item.getDish();
                    %>
                    <tr>
                        <td><img src="<%= dish.getImage()%>" alt="Ảnh món" width="100" height="80" class="img-thumbnail"></td>
                        <td><%= dish.getDishName()%></td>
                        <td>
                            <div class="d-flex justify-content-center align-items-center gap-2">
                                <button class="btn btn-outline-secondary btn-sm" onclick="updateQuantity(<%= item.getCartID()%>, -1)">−</button>

                                <input type="hidden" name="cartID" value="<%= item.getCartID()%>">
                                <input type="text" 
                                       id="qty_<%= item.getCartID()%>" 
                                       name="quantity" 
                                       value="<%= item.getQuantity()%>" 
                                       readonly 
                                       class="form-control text-center" 
                                       style="width:60px;">

                                <button class="btn btn-outline-secondary btn-sm" onclick="updateQuantity(<%= item.getCartID()%>, 1)">+</button>
                            </div>

                        </td>
                        <td>
                            <form action="<%= request.getContextPath()%>/customer/view-cart" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa món này?');">
                                <input type="hidden" name="cartID" value="<%= item.getCartID()%>">
                                <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="alert alert-warning">Giỏ hàng của bạn hiện chưa có món nào.</div>
            <% }%>
        </div>

     <script>
    const contextPath = "<%= request.getContextPath() %>";

    /**
     * Cập nhật số lượng món ăn trong giỏ hàng.
     * @param {number} cartId - ID của món trong giỏ hàng.
     * @param {number} delta - Giá trị thay đổi (+1 hoặc -1).
     */
    function updateQuantity(cartId, delta) {
        const input = document.getElementById("qty_" + cartId);
        let qty = parseInt(input.value);

        if (isNaN(qty)) qty = 1;

        qty += delta;
        if (qty < 1) qty = 1; // Không cho giảm xuống dưới 1

        // Cập nhật ngay trên giao diện
        input.value = qty;

        // Gửi Ajax để cập nhật trên server
        fetch(contextPath + "/customer/view-cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "cartID=" + encodeURIComponent(cartId) + "&quantity=" + encodeURIComponent(qty)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Cập nhật thất bại!");
            }
            return response.text(); // hoặc .json() nếu server trả JSON
        })
        .then(data => {
            // Cập nhật giao diện nếu cần (ví dụ: tổng tiền)
            // location.reload(); // Nếu muốn reload lại trang
        })
        .catch(error => {
            alert("Lỗi khi cập nhật số lượng: " + error.message);
        });
    }
</script>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
