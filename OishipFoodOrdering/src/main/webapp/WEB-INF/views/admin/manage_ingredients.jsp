<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin - Manage Ingredients</title>

        <!-- Bootstrap 5 CSS & JS -->
        <link rel="stylesheet" href="../css/bootstrap.css" />
        <script src="../js/bootstrap.bundle.js"></script>

        <!-- CSS for Dashboard and Sidebar -->
        <link rel="stylesheet" href="../css/sidebar.css" />
        <link rel="stylesheet" href="../css/dashboard.css" />

        <!-- JS for Sidebar -->
        <script src="../js/sidebar.js"></script>

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

        <style>
            .ingredient-table th, .ingredient-table td {
                vertical-align: middle;
                text-align: center;
            }
            .ingredient-table .btn-group {
                display: flex;
                gap: 5px;
                justify-content: center;
            }
            .alert {
                position: fixed;
                top: 10px;
                right: 10px;
                z-index: 1050;
                max-width: 300px;
            }
            .autocomplete-suggestions {
                position: absolute;
                background: white;
                border: 1px solid #ccc;
                max-height: 150px;
                overflow-y: auto;
                z-index: 1000;
                width: 100%;
            }
            .autocomplete-suggestion {
                padding: 5px 10px;
                cursor: pointer;
            }
            .autocomplete-suggestion:hover {
                background-color: #f0f0f0;
            }
            .database-error {
                color: red;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="admin_sidebar.jsp" />

        <!-- Main Section -->
        <div class="main" id="main">
            <!-- Topbar -->
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile">
                    <span class="username">Hi, Admin</span>
                </div>
            </div>

            <!-- Content -->
            <div class="content">
                <h1>Manage Ingredients</h1>
                <p>Manage your restaurant's ingredients and stock levels.</p>
                <c:if test="${empty ingredients}">
                    <p class="database-error">Warning: No ingredients available. Database connection may be down. Check server logs.</p>
                </c:if>
                <c:if test="${empty dishes}">
                    <p class="database-error">Warning: No dishes available. Database connection may be down. Check server logs.</p>
                </c:if>

                <!-- Add Ingredient Form -->
                <form action="${pageContext.request.contextPath}/admin/manage-ingredients" method="post" class="row g-3 mt-4">
                    <div class="col-md-6 position-relative">
                        <label for="ingredientName" class="form-label">Ingredient Name</label>
                        <input type="text" class="form-control" id="ingredientName" name="ingredientName" required placeholder="e.g. Chicken" oninput="suggestIngredients(this)" list="ingredientSuggestionsList">
                        <datalist id="ingredientSuggestionsList"></datalist>
                    </div>
                    <div class="col-md-3">
                        <label for="unitCost" class="form-label">Unit Cost (VNĐ/kg)</label>
                        <input type="number" step="0.01" class="form-control" id="unitCost" name="unitCost" required placeholder="e.g. 50000" oninput="validateNumber(this)">
                    </div>
                    <div class="col-md-3 position-relative">
                        <label for="dishName" class="form-label">Dish Name (Optional)</label>
                        <input type="text" class="form-control" id="dishName" name="dishName" placeholder="e.g. Chicken Dish" oninput="suggestDishes(this)" list="dishSuggestionsList">
                        <datalist id="dishSuggestionsList"></datalist>
                    </div>
                    <div class="col-md-3">
                        <label for="quantity" class="form-label">Quantity (kg) (Optional)</label>
                        <input type="number" step="0.01" class="form-control" id="quantity" name="quantity" placeholder="e.g. 0.5" oninput="validateNumber(this)">
                    </div>
                    <div class="col-12">
                        <button type="submit" name="action" value="add" class="btn btn-success">Add Ingredient</button>
                    </div>
                </form>

                <!-- Ingredient List -->
                <div class="mt-5">
                    <h4>Existing Ingredients</h4>
                    <table class="table table-striped table-hover ingredient-table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Unit Cost (VNĐ/kg)</th>
                                <th>Quantity (kg)</th>
                                <th>Dish</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ingredient" items="${ingredients}">
                                <c:forEach var="di" items="${ingredient.dishIngredients}">
                                    <c:set var="dish" value="${dishes.stream().filter(d -> d.dishID == di.dishId).findFirst().orElse(null)}"/>
                                    <tr>
                                        <td>${ingredient.ingredientName}</td>
                                        <td>${ingredient.unitCost}</td>
                                        <td>${di.quantity}</td>
                                        <td>${dish != null ? dish.dishName : 'N/A'}</td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="#" class="btn btn-sm btn-primary me-2"
                                                   data-id="${ingredient.ingredientId}"
                                                   data-dishid="${di.dishId}"
                                                   data-name="${ingredient.ingredientName}"
                                                   data-unitcost="${ingredient.unitCost}"
                                                   data-dishname="${dish != null ? dish.dishName : ''}"
                                                   data-quantity="${di.quantity}"
                                                   onclick="handleEditClick(this); event.stopPropagation();">
                                                    Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/manage-ingredients?_method=DELETE&id=${ingredient.ingredientId}&dishId=${di.dishId}"
                                                   class="btn btn-sm btn-danger"
                                                   onclick="return confirmDelete(event);">
                                                    Delete
                                                </a>
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
                                                <a href="#" class="btn btn-sm btn-primary me-2"
                                                   data-id="${ingredient.ingredientId}"
                                                   data-dishid="0"
                                                   data-name="${ingredient.ingredientName}"
                                                   data-unitcost="${ingredient.unitCost}"
                                                   data-dishname=""
                                                   data-quantity=""
                                                   onclick="handleEditClick(this); event.stopPropagation();">
                                                    Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/manage-ingredients?_method=DELETE&id=${ingredient.ingredientId}&dishId=0"
                                                   class="btn btn-sm btn-danger"
                                                   onclick="return confirmDelete(event);">
                                                    Delete
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty ingredients}">
                                <tr><td colspan="5" class="text-center">No ingredients available.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Edit Ingredient Modal -->
        <div class="modal fade" id="editIngredientModal" tabindex="-1" aria-labelledby="editIngredientModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form action="${pageContext.request.contextPath}/admin/manage-ingredients" method="post" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editIngredientModalLabel">Edit Ingredient</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="editIngredientId" name="ingredientId" />
                        <input type="hidden" id="editDishId" name="dishId" />
                        <div class="mb-3">
                            <label for="editIngredientName" class="form-label">Ingredient Name</label>
                            <input type="text" class="form-control" id="editIngredientName" name="ingredientName" required list="ingredientSuggestionsListEdit">
                        </div>
                        <div class="mb-3">
                            <label for="editUnitCost" class="form-label">Unit Cost (VNĐ/kg)</label>
                            <input type="number" step="0.01" class="form-control" id="editUnitCost" name="unitCost" required oninput="validateNumber(this)">
                        </div>
                        <div class="mb-3">
                            <label for="editDishName" class="form-label">Dish Name (Optional)</label>
                            <input type="text" class="form-control" id="editDishName" name="dishName" list="dishSuggestionsListEdit">
                        </div>
                        <div class="mb-3">
                            <label for="editQuantity" class="form-label">Quantity (kg) (Optional)</label>
                            <input type="number" step="0.01" class="form-control" id="editQuantity" name="quantity" oninput="validateNumber(this)">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" name="action" value="update" class="btn btn-primary">Update Ingredient</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Success or Error Message Alerts -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" onclick="clearSessionMessage('successMessage')"></button>
            </div>
            <% session.removeAttribute("successMessage"); %> <!-- Clear after display -->
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" onclick="clearSessionMessage('errorMessage')"></button>
            </div>
            <% session.removeAttribute("errorMessage");%> <!-- Clear after display -->
        </c:if>

        <script>
            let ingredientNames = [];
            let dishNames = [];

            function suggestIngredients(input) {
                const value = input.value.toLowerCase();
                const suggestions = document.getElementById(input.id === 'ingredientName' ? 'ingredientSuggestionsList' : 'ingredientSuggestionsListEdit');
                suggestions.innerHTML = '';

                if (value) {
                    const filtered = ingredientNames.filter(name => name.toLowerCase().includes(value));
                    if (filtered.length > 0) {
                        filtered.forEach(name => {
                            const option = document.createElement('option');
                            option.value = name;
                            suggestions.appendChild(option);
                        });
                    }
                }
            }

            function suggestDishes(input) {
                const value = input.value.toLowerCase();
                const suggestions = document.getElementById(input.id === 'dishName' ? 'dishSuggestionsList' : 'dishSuggestionsListEdit');
                suggestions.innerHTML = '';

                if (value) {
                    const filtered = dishNames.filter(name => name.toLowerCase().includes(value));
                    if (filtered.length > 0) {
                        filtered.forEach(name => {
                            const option = document.createElement('option');
                            option.value = name;
                            suggestions.appendChild(option);
                        });
                    }
                }
            }

            function handleEditClick(button) {
                const id = button.getAttribute('data-id');
                const dishId = button.getAttribute('data-dishid');
                const name = button.getAttribute('data-name');
                const unitCost = button.getAttribute('data-unitcost');
                const dishName = button.getAttribute('data-dishname');
                const quantity = button.getAttribute('data-quantity');

                document.getElementById("editIngredientId").value = id;
                document.getElementById("editDishId").value = dishId;
                document.getElementById("editIngredientName").value = name;
                document.getElementById("editUnitCost").value = unitCost;
                document.getElementById("editDishName").value = dishName;
                document.getElementById("editQuantity").value = quantity || '';

                const modal = new bootstrap.Modal(document.getElementById('editIngredientModal'));
                modal.show();
            }

            function confirmDelete(event) {
                const confirmed = confirm("Are you sure you want to delete this ingredient?");
                if (!confirmed) {
                    event.preventDefault();
                    return false;
                }
                return true;
            }

            function validateNumber(input) {
                if (isNaN(input.value) || input.value <= 0) {
                    input.setCustomValidity('Please enter a valid positive number.');
                } else {
                    input.setCustomValidity('');
                }
            }

            function clearSessionMessage(messageType) {
                // This function is called on alert close, but session is cleared server-side
            }

            // Fetch ingredient and dish names on page load
            window.addEventListener('load', () => {
                Promise.all([
                    fetch('${pageContext.request.contextPath}/admin/manage-ingredients?action=getIngredientNames').then(r => r.json()),
                    fetch('${pageContext.request.contextPath}/admin/manage-ingredients?action=getDishNames').then(r => r.json())
                ]).then(([ingredientData, dishData]) => {
                    if (ingredientData.success) {
                        ingredientNames = ingredientData.names;
                    } else {
                        console.error('Failed to fetch ingredient names:', ingredientData.error);
                    }
                    if (dishData.success) {
                        dishNames = dishData.names;
                    } else {
                        console.error('Failed to fetch dish names:', dishData.error);
                }
                }).catch(error => console.error('Error fetching names:', error));
            });
        </script>
    </body>
</html>