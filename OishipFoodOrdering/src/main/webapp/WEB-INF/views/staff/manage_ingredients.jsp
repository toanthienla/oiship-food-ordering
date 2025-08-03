<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff - Manage Ingredients</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css" />
        <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

        <!-- Select2 -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <style>
            /* Ensure select2 dropdown is above the modal */
            .select2-container--open {
                z-index: 9999 !important;
            }
        </style>
    </head>
    <body>
        <jsp:include page="staff_sidebar.jsp" />

        <div class="main" id="main">
            <div class="topbar">
                <i class="bi bi-list menu-toggle" id="menuToggle"></i>
                <div class="profile">
                    <span class="username">Hi, <span><c:out value="${sessionScope.userName}" /></span></span>
                </div>
            </div>

            <div class="content">
                <h1>Manage Ingredients for Dishes</h1>

                <ul class="nav nav-tabs" id="ingredientTab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#allIngredients" type="button" role="tab">All Ingredients</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="by-dish-tab" data-bs-toggle="tab" data-bs-target="#byDish" type="button" role="tab">Ingredients by Dish</button>
                    </li>
                </ul>

                <div class="tab-content mt-3" id="ingredientTabContent">
                    <div class="tab-pane fade show active" id="allIngredients" role="tabpanel">
                        <!-- Add Ingredient Button -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addIngredientModal">
                                <i class="bi bi-plus-circle me-1"></i> Add Ingredient to Dish
                            </button>
                        </div>

                        <!-- Ingredient Alert (Tab 1) -->
                        <div id="ingredientAlert" class="alert mt-3 d-none" role="alert"></div>

                        <h4 class="mt-2">All Ingredients</h4>

                        <!-- Search Box -->
                        <div class="col-md-6 mt-3 mb-3">
                            <div class="d-flex align-items-center">
                                <label class="me-2 fw-semibold mb-0">Search Ingredient:</label>
                                <input type="text" id="ingredientSearch" class="form-control w-auto" placeholder="Enter ingredient name..." />
                            </div>
                        </div>

                        <!-- Ingredients Table -->
                        <table id="ingredientTable" class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-center">#</th>
                                    <th>Name</th>
                                    <th>Unit Cost (vnđ/kg)</th>
                                    <th class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ing" items="${ingredients}" varStatus="loop">
                                    <tr>
                                        <td class="text-center">${loop.index + 1}</td>
                                        <td>${ing.ingredientName}</td>
                                        <td>${ing.unitCost}</td>
                                        <td class="text-center">
                                            <div class="d-flex flex-wrap justify-content-center gap-2">
                                                <button type="button" class="btn btn-sm btn-primary px-3"
                                                        data-id="${ing.ingredientId}"
                                                        data-name="${ing.ingredientName}"
                                                        data-cost="${ing.unitCost}"
                                                        data-bs-toggle="modal" data-bs-target="#editModal"
                                                        onclick="fillEditForm(this);">Edit</button>
                                                <a href="manage-ingredients?action=delete&id=${ing.ingredientId}"
                                                   class="btn btn-sm btn-danger px-3"
                                                   onclick="return confirmDelete(event);">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="tab-pane fade" id="byDish" role="tabpanel">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="filterDishId" class="form-label">Choose Dish to View Ingredients</label>
                                <select id="filterDishId" class="form-select select2" style="width: 100%;">
                                    <option value="">-- Select a Dish --</option>
                                    <c:forEach var="dish" items="${dishes}">
                                        <option value="${dish.dishID}">${dish.dishName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Dish Ingredient Alert (Tab 2) -->
                        <div id="dishIngredientAlert" class="alert mt-3 d-none" role="alert"></div>

                        <div id="dishIngredientsTable" class="mt-4" style="display:none;">
                            <h5>Ingredients for Selected Dish</h5>
                            <table class="table table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-center">#</th>
                                        <th>Ingredient Name</th>
                                        <th>Unit Cost (vnđ/kg)</th>
                                        <th>Quantity (kg/dish)</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="dishIngredientBody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ✅ ADD INGREDIENT MODAL -->
            <div class="modal fade" id="addIngredientModal" tabindex="-1" aria-labelledby="addIngredientModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="manage-ingredients" method="post" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addIngredientModalLabel">Add Ingredient to Dish</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body row">
                            <div class="col-12 mb-3">
                                <label class="form-label">Select Dish</label>
                                <select class="form-select select2" name="dishID" required style="width: 100%;">
                                    <option value="">-- Select a Dish --</option>
                                    <c:forEach var="dish" items="${dishes}">
                                        <option value="${dish.dishID}">${dish.dishName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-12">
                                <!-- Step 1: Choose Mode -->
                                <label class="form-label">Ingredient Input Mode</label>
                                <select id="ingredientModeModal" name="ingredientMode" class="form-select mb-3">
                                    <option value="new" selected>Create New Ingredient</option>
                                    <option value="existing">Select Existing Ingredient</option>
                                </select>

                                <!-- Step 2A: Select Existing Ingredient -->
                                <div id="existingIngredientSectionModal" class="mb-3" style="display: none;">
                                    <label for="ingredientSelectModal" class="form-label fw-semibold">Choose Existing Ingredient</label>
                                    <select class="form-select select2" id="ingredientSelectModal" name="ingredientId" style="width: 100%;">
                                        <option value="">-- Select an Ingredient --</option>
                                        <c:forEach var="ing" items="${ingredients}">
                                            <option value="${ing.ingredientId}" data-name="${ing.ingredientName}" data-cost="${ing.unitCost}">
                                                ${ing.ingredientName} — ${ing.unitCost} vnđ/kg
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Step 2B: Create New Ingredient -->
                                <div id="newIngredientSectionModal" class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label">New Ingredient Name</label>
                                        <input type="text" class="form-control" name="newName" placeholder="e.g., Garlic, Tofu">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Unit Cost (vnđ/kg)</label>
                                        <input type="number" class="form-control" name="newCost" step="0.01" placeholder="e.g., 12000">
                                    </div>
                                </div>
                            </div>

                            <!-- Quantity -->
                            <div class="col-md-6 mb-3 mt-3">
                                <label class="form-label">Quantity (kg/dish)</label>
                                <input type="number" step="0.01" name="quantity" class="form-control" required placeholder="e.g. 0.1" />
                            </div>

                            <!-- Submit Button -->
                            <div class="col-12">
                                <input type="hidden" name="action" value="add" />
                                <button type="submit" class="btn btn-success">Add Ingredient to Dish</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- ✅ EDIT MODAL FOR TAB 1 -->
            <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="manage-ingredients" method="post" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Edit Ingredient</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="ingredientId" id="editIngredientId">
                            <div class="mb-3">
                                <label class="form-label">Name</label>
                                <input type="text" name="ingredientName" id="editIngredientName" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Unit Cost</label>
                                <input type="number" name="unitCost" step="0.01" id="editIngredientCost" class="form-control" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Update Ingredient</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- ✅ EDIT MODAL FOR TAB 2 -->
            <div class="modal fade" id="editDishIngredientModal" tabindex="-1" aria-labelledby="editDishIngredientLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="manage-ingredients" method="post" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Edit Dish Ingredient</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="updateDishIngredient">
                            <input type="hidden" name="dishID" id="editDishID">
                            <input type="hidden" name="ingredientID" id="editDishIngredientID">

                            <div class="mb-3">
                                <label class="form-label">Ingredient Name</label>
                                <input type="text" name="ingredientName" id="editDishIngredientName" class="form-control" disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Unit Cost (vnđ/kg)</label>
                                <input type="number" step="0.01" name="ingredientCost" id="editDishIngredientCost" class="form-control" disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Quantity (kg/dish)</label>
                                <input type="number" step="0.01" name="quantity" id="editDishIngredientQty" class="form-control" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Update</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                const allDishIngredients = [
                <c:forEach var="di" items="${allDishIngredients}" varStatus="loop">
                {
                dishID: ${di.dishId},
                        ingredientID: ${di.ingredientId},
                        ingredientName: "${di.ingredientName}",
                        ingredientCost: ${di.ingredientCost},
                        quantity: ${di.quantity}
                }<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
                ];

                // --- Select2 initialization with dropdownParent for modal ---
                $(document).ready(function () {
                    // Global select2 for outside modal
                    $('.tab-pane.active .select2').select2({
                        placeholder: "-- Select a Dish --",
                        allowClear: true,
                        width: 'resolve'
                    });

                    // Select2 for modal: Add Ingredient
                    $('#addIngredientModal').on('shown.bs.modal', function () {
                        $(this).find('.select2').select2({
                            dropdownParent: $('#addIngredientModal'),
                            placeholder: "-- Select a Dish --",
                            allowClear: true,
                            width: 'resolve'
                        });
                    });

                    // Toggle ingredient section in Add Ingredient Modal
                    function toggleIngredientSectionsModal() {
                        const mode = $('#ingredientModeModal').val();
                        if (mode === "existing") {
                            $('#existingIngredientSectionModal').show();
                            $('#newIngredientSectionModal').hide();
                        } else {
                            $('#existingIngredientSectionModal').hide();
                            $('#newIngredientSectionModal').show();
                        }
                    }
                    $('#ingredientModeModal').on('change', toggleIngredientSectionsModal);
                    toggleIngredientSectionsModal();
                });

                // Select dish (Tab 2)
                $(document).ready(function () {
                    // Init Select2
                    $('#filterDishId').select2({
                        placeholder: "-- Select a Dish --",
                        allowClear: true,
                        width: 'resolve'
                    });

                    // Dish Change Handler
                    $('#filterDishId').on('change', function () {
                        const selectedDishId = parseInt(this.value);
                        const tbody = document.getElementById("dishIngredientBody");
                        const tableSection = document.getElementById("dishIngredientsTable");
                        tbody.innerHTML = "";

                        if (!selectedDishId) {
                            tableSection.style.display = "none";
                            return;
                        }

                        const filtered = allDishIngredients.filter(di => Number(di.dishID) === selectedDishId);

                        if (filtered.length === 0) {
                            tbody.innerHTML = "<tr><td colspan='5' class='text-center'>No ingredients found for this dish.</td></tr>";
                        } else {
                            filtered.forEach(function (di, index) {
                                var row = "<tr>" +
                                        "<td class='text-center'>" + (index + 1) + "</td>" +
                                        "<td>" + (di.ingredientName || "") + "</td>" +
                                        "<td>" + (di.ingredientCost || "") + "</td>" +
                                        "<td>" + (di.quantity || "") + "</td>" +
                                        "<td class='text-center'>" +
                                        "<div class='d-flex justify-content-center gap-2'>" +
                                        "<button type='button' class='btn btn-sm btn-primary' " +
                                        "data-dishid='" + selectedDishId + "' " +
                                        "data-ingredientid='" + di.ingredientID + "' " +
                                        "data-name='" + di.ingredientName + "' " +
                                        "data-cost='" + di.ingredientCost + "' " +
                                        "data-qty='" + di.quantity + "' " +
                                        "data-bs-toggle='modal' " +
                                        "data-bs-target='#editDishIngredientModal' " +
                                        "onclick='fillEditDishIngredient(this)'>" +
                                        "Edit" +
                                        "</button>" +
                                        "<a href='manage-ingredients?action=deleteDishIngredient&dishID=" + selectedDishId + "&ingredientID=" + di.ingredientID + "' " +
                                        "class='btn btn-sm btn-danger' " +
                                        "onclick='return confirmDelete(event)'>" +
                                        "Delete" +
                                        "</a>" +
                                        "</div>" +
                                        "</td>" +
                                        "</tr>";
                                tbody.innerHTML += row;
                            });
                        }

                        tableSection.style.display = "block";
                    });

                    // Handle tab + dishID from URL
                    const urlParams = new URLSearchParams(window.location.search);
                    const tab = urlParams.get("tab");
                    const selectedDishID = urlParams.get("dishID");

                    if (tab === "byDish") {
                        const tabTrigger = new bootstrap.Tab(document.querySelector('#by-dish-tab'));
                        tabTrigger.show();

                        if (selectedDishID) {
                            $('#filterDishId').val(selectedDishID).trigger('change');
                        }
                    }
                });

                function getParam(param) {
                    const urlParams = new URLSearchParams(window.location.search);
                    return urlParams.get(param);
                }

                // Search Ingredient (Tab 1)
                document.getElementById("ingredientSearch").addEventListener("input", function () {
                    const keyword = this.value.toLowerCase();
                    const rows = document.querySelectorAll("#ingredientTable tbody tr");

                    rows.forEach(row => {
                        const name = row.cells[1].textContent.toLowerCase();
                        if (name.includes(keyword)) {
                            row.style.display = "";
                        } else {
                            row.style.display = "none";
                        }
                    });
                });

                // Fill modal form for tab 1
                function fillEditForm(btn) {
                    document.getElementById("editIngredientId").value = btn.dataset.id;
                    document.getElementById("editIngredientName").value = btn.dataset.name;
                    document.getElementById("editIngredientCost").value = btn.dataset.cost;
                }

                // Confirm delete
                function confirmDelete(event) {
                    if (!confirm("Are you sure you want to delete this ingredient?")) {
                        event.preventDefault();
                        return false;
                    }
                    return true;
                }

                function fillEditDishIngredient(btn) {
                    document.getElementById("editDishID").value = btn.dataset.dishid;
                    document.getElementById("editDishIngredientID").value = btn.dataset.ingredientid;
                    document.getElementById("editDishIngredientName").value = btn.dataset.name;
                    document.getElementById("editDishIngredientCost").value = btn.dataset.cost;
                    document.getElementById("editDishIngredientQty").value = btn.dataset.qty;
                }

                window.addEventListener("DOMContentLoaded", () => {
                    const success = getParam("success");
                    const tab = getParam("tab");

                    const ingredientAlertBox = document.getElementById("ingredientAlert");
                    const dishAlertBox = document.getElementById("dishIngredientAlert");

                    if (!success)
                        return;

                    let message = "";
                    let alertClass = "";

                    switch (success) {
                        // ✅ Ingredient tab alerts
                        case "add":
                            message = '<i class="bi bi-check-circle-fill me-2"></i>Ingredient added successfully!';
                            alertClass = "alert-success";
                            showAlert(ingredientAlertBox, message, alertClass);
                            break;
                        case "edit":
                            message = '<i class="bi bi-pencil-square me-2"></i>Ingredient updated successfully!';
                            alertClass = "alert-success";
                            showAlert(ingredientAlertBox, message, alertClass);
                            break;
                        case "delete":
                            message = '<i class="bi bi-trash-fill me-2"></i>Ingredient deleted successfully!';
                            alertClass = "alert-success";
                            showAlert(ingredientAlertBox, message, alertClass);
                            break;
                        case "false":
                            message = '<i class="bi bi-x-circle-fill me-2"></i>Failed to process ingredient. Please try again.';
                            alertClass = "alert-danger";
                            showAlert(ingredientAlertBox, message, alertClass);
                            break;
                        case "exists":
                            message = '<i class="bi bi-exclamation-triangle-fill me-2"></i>An ingredient with this name already exists!';
                            alertClass = "alert-warning";
                            showAlert(ingredientAlertBox, message, alertClass);
                            break;

                        case "dishEdit":
                            message = '<i class="bi bi-pencil-square me-2"></i>Dish Ingredient updated successfully!';
                            alertClass = "alert-success";
                            showAlert(dishAlertBox, message, alertClass);
                            break;
                        case "dishDelete":
                            message = '<i class="bi bi-trash-fill me-2"></i>Dish Ingredient deleted successfully!';
                            alertClass = "alert-success";
                            showAlert(dishAlertBox, message, alertClass);
                            break;
                        case "replaced":
                            message = '<i class="bi bi-arrow-repeat me-2"></i>Ingredient already existed for this dish. Quantity replaced!';
                            alertClass = "alert-success";
                            showAlert(ingredientAlertBox, message, alertClass);
                            break;
                        default:
                            message = '<i class="bi bi-info-circle-fill me-2"></i>Unknown status.';
                            alertClass = "alert-secondary";
                            showAlert(ingredientAlertBox, message, alertClass); // fallback
                    }

                    // Clean the URL
                    if (window.history.replaceState) {
                        const url = new URL(window.location);
                        url.searchParams.delete("success");
                        window.history.replaceState({}, document.title, url.pathname + url.search);
                    }
                });

                function showAlert(alertElement, message, alertClass) {
                    alertElement.innerHTML = message;
                    alertElement.classList.remove("d-none");
                    alertElement.classList.add("alert", alertClass, "mt-3");
                    alertElement.setAttribute("role", "alert");
                }
            </script>
    </body>
</html>
