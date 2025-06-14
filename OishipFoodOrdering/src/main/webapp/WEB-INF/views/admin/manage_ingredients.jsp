<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Manage Ingredients</title>
    <link rel="stylesheet" href="../css/bootstrap.css" />
    <script src="../js/bootstrap.bundle.js"></script>
    <link rel="stylesheet" href="../css/sidebar.css" />
    <link rel="stylesheet" href="../css/dashboard.css" />
    <script src="../js/sidebar.js"></script>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
    <style>
        .ingredient-table th, .ingredient-table td { vertical-align: middle; text-align: center; }
        .ingredient-table .btn-group { display: flex; gap: 5px; justify-content: center; }
        .custom-select-wrapper { position: relative; width: 100%; }
        .custom-select { width: 100%; padding: 0.375rem 0.75rem; font-size: 1rem; line-height: 1.5; border: 1px solid #ced4da; border-radius: 0.25rem; }
        .ui-autocomplete { z-index: 1050; }
        .alert { position: fixed; top: 10px; right: 10px; z-index: 1050; max-width: 300px; }
    </style>
</head>
<body>
    <jsp:include page="admin_sidebar.jsp" />
    <div class="main" id="main">
        <div class="topbar">
            <i class="bi bi-list menu-toggle" id="menuToggle"></i>
            <div class="profile">
                <span class="username">Hi, Admin</span>
            </div>
        </div>
        <div class="content">
            <h1>Manage Ingredients</h1>
            <p>Manage your restaurant's ingredients and stock levels.</p>

            <form action="manage-ingredients" method="post" id="addIngredientForm" class="row g-3 mt-4">
                <div class="col-md-6">
                    <label for="dishName" class="form-label">Chọn DishName</label>
                    <input type="text" class="form-control custom-select" id="dishName" name="dishName" value="${dishName}" placeholder="Tìm hoặc chọn món ăn" data-id="${param.dishId}">
                </div>
                <div class="col-md-6">
                    <label for="ingredientName" class="form-label">Ingredient Name</label>
                    <input type="text" class="form-control custom-select" id="ingredientName" name="ingredientName" value="${ingredientName}" placeholder="Nhập hoặc chọn nguyên liệu" data-id="${param.ingredientId}">
                </div>
                <div class="col-md-3">
                    <label for="unitCost" class="form-label">UnitCost (VNĐ/kg)</label>
                    <input type="number" step="0.01" class="form-control" id="unitCost" name="unitCost" value="${unitCost}" required placeholder="Số tiền nguyên liệu">
                </div>
                <div class="col-md-3">
                    <label for="quantity" class="form-label">Quantity (kg)</label>
                    <input type="number" step="0.01" class="form-control" id="quantity" name="quantity" value="${quantity}" required placeholder="Số lượng">
                </div>
                <div class="col-12">
                    <button type="submit" name="action" value="add" class="btn btn-success">Thêm Ingredient</button>
                </div>
            </form>

            <div class="mt-5">
                <h4>Existing Ingredients</h4>
                <table class="table table-striped table-hover ingredient-table">
                    <thead><tr><th>Name</th><th>Unit Cost (VNĐ/kg)</th><th>Quantity (kg)</th><th>Dish Name</th><th>Actions</th></tr></thead>
                    <tbody>
                        <c:forEach var="ingredient" items="${ingredients}">
                            <c:forEach var="di" items="${ingredient.dishIngredients}">
                                <tr>
                                    <td>${ingredient.ingredientName}</td>
                                    <td>${ingredient.unitCost}</td>
                                    <td>${di.quantity}</td>
                                    <td>
                                        <c:set var="dish" value="${dishes.stream().filter(d -> d.dishID == di.dishId).findFirst().orElse(null)}"/>
                                        ${dish != null ? dish.dishName : 'Unknown Dish'}
                                    </td>
                                    <td>
                                        <div class="btn-group">
                                            <a href="#" class="btn btn-sm btn-primary" data-id="${ingredient.ingredientId}"
                                               data-name="${ingredient.ingredientName}" data-unitcost="${ingredient.unitCost}"
                                               data-dishid="${di.dishId}" data-quantity="${di.quantity}"
                                               onclick="handleEditClick(this); event.stopPropagation();">Edit</a>
                                            <button class="btn btn-sm btn-danger" onclick="handleDelete(${ingredient.ingredientId}, ${di.dishId});">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty ingredient.dishIngredients}">
                                <tr>
                                    <td>${ingredient.ingredientName}</td>
                                    <td>${ingredient.unitCost}</td>
                                    <td>N/A</td>
                                    <td>N/A</td>
                                    <td>
                                        <div class="btn-group">
                                            <a href="#" class="btn btn-sm btn-primary" data-id="${ingredient.ingredientId}"
                                               data-name="${ingredient.ingredientName}" data-unitcost="${ingredient.unitCost}"
                                               data-dishid="0" data-quantity="0"
                                               onclick="handleEditClick(this); event.stopPropagation();">Edit</a>
                                            <button class="btn btn-sm btn-danger" onclick="handleDelete(${ingredient.ingredientId}, 0);">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <c:if test="${empty ingredients}"><tr><td colspan="5" class="text-center">No ingredients available.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editIngredientModal" tabindex="-1" aria-labelledby="editIngredientModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form action="manage-ingredients" method="post" class="modal-content">
                <div class="modal-header"><h5 class="modal-title" id="editIngredientModalLabel">Edit Ingredient</h5><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div>
                <div class="modal-body">
                    <input type="hidden" id="editIngredientId" name="ingredientId" />
                    <input type="hidden" id="editDishId" name="dishId" />
                    <div class="mb-3"><label for="editIngredientName" class="form-label">Ingredient Name</label><input type="text" class="form-control" id="editIngredientName" name="ingredientName" required /></div>
                    <div class="mb-3"><label for="editUnitCost" class="form-label">Unit Cost (VNĐ/kg)</label><input type="number" step="0.01" class="form-control" id="editUnitCost" name="unitCost" required /></div>
                    <div class="mb-3"><label for="editQuantity" class="form-label">Quantity (kg)</label><input type="number" step="0.01" class="form-control" id="editQuantity" name="quantity" required /></div>
                </div>
                <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" name="action" value="update" class="btn btn-primary">Update Ingredient</button></div>
            </form>
        </div>
    </div>

    <c:if test="${not empty message}"><div class="alert alert-success alert-dismissible fade show" role="alert">${message}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div></c:if>
    <c:if test="${not empty errorMessage}"><div class="alert alert-danger alert-dismissible fade show" role="alert">${errorMessage}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div></c:if>

    <script>
        $(document).ready(function() {
            let dishNames = [<c:forEach var="dish" items="${dishes}" varStatus="loop">{ label: "${dish.dishName}", value: "${dish.dishID}" }${!loop.last ? ',' : ''}</c:forEach>];
            $("#dishName").autocomplete({
                source: dishNames,
                select: function(event, ui) {
                    $("#dishName").val(ui.item.label);
                    $("#dishName").attr("data-id", ui.item.value);
                    return false;
                },
                focus: function(event, ui) {
                    $("#dishName").val(ui.item.label);
                    return false;
                },
                change: function(event, ui) {
                    if (!ui.item) {
                        $("#dishName").val("");
                        $("#dishName").removeAttr("data-id");
                    }
                }
            }).on("input", function() {
                if ($(this).val() === "") {
                    $(this).removeAttr("data-id");
                }
            });

            let ingredientNames = [<c:forEach var="ingredient" items="${ingredients}" varStatus="loop">{ label: "${ingredient.ingredientName}", value: "${ingredient.ingredientId}" }${!loop.last ? ',' : ''}</c:forEach>];
            $("#ingredientName").autocomplete({
                source: ingredientNames,
                select: function(event, ui) {
                    $("#ingredientName").val(ui.item.label);
                    $("#ingredientName").attr("data-id", ui.item.value);
                    return false;
                },
                focus: function(event, ui) {
                    $("#ingredientName").val(ui.item.label);
                    return false;
                },
                change: function(event, ui) {
                    if (!ui.item) {
                        $("#ingredientName").val("");
                        $("#ingredientName").removeAttr("data-id");
                    }
                }
            }).on("input", function() {
                if ($(this).val() === "") {
                    $(this).removeAttr("data-id");
                }
            });

            $("#addIngredientForm").on("submit", function(event) {
                const dishId = $("#dishName").attr("data-id");
                const ingredientId = $("#ingredientName").attr("data-id");
                const ingredientName = $("#ingredientName").val().trim();
                const unitCost = $("#unitCost").val();
                const quantity = $("#quantity").val();

                if (!ingredientName) {
                    event.preventDefault();
                    alert("Ingredient name is required.");
                    return false;
                }
                if (!unitCost || !quantity) {
                    event.preventDefault();
                    alert("Unit cost and quantity are required.");
                    return false;
                }

                if (dishId) {
                    const hiddenDishId = document.createElement("input");
                    hiddenDishId.type = "hidden";
                    hiddenDishId.name = "dishName";
                    hiddenDishId.value = dishId;
                    this.appendChild(hiddenDishId);
                }
            });

            function handleEditClick(button) {
                const id = button.getAttribute('data-id');
                const name = button.getAttribute('data-name');
                const unitCost = button.getAttribute('data-unitcost');
                const dishId = button.getAttribute('data-dishid');
                const quantity = button.getAttribute('data-quantity');

                document.getElementById("editIngredientId").value = id;
                document.getElementById("editDishId").value = dishId;
                document.getElementById("editIngredientName").value = name;
                document.getElementById("editUnitCost").value = unitCost;
                document.getElementById("editQuantity").value = quantity;

                new bootstrap.Modal(document.getElementById('editIngredientModal')).show();
            }

            function handleDelete(ingredientId, dishId) {
                if (confirm("Are you sure you want to delete this ingredient?")) {
                    $.ajax({
                        url: 'manage-ingredients',
                        type: 'POST',
                        data: { id: ingredientId, dishId: dishId, _method: 'DELETE' },
                        success: function(response) {
                            const data = JSON.parse(response);
                            if (data.success) {
                                alert(data.message);
                                location.reload();
                            } else {
                                alert(data.error);
                            }
                        },
                        error: function(xhr, status, error) {
                            alert("Error deleting ingredient: " + error);
                            console.log("AJAX Error: ", xhr.responseText);
                        }
                    });
                }
            }
        });
    </script>
</body>
</html>