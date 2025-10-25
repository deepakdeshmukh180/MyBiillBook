<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">


<jsp:include page="../view/logo.jsp"></jsp:include>

    <!-- Main Content -->
    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4 mt-4">

                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert" id="success-alert">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Product Management Card -->
                <div class="main-card p-4">
                    <h4 class="section-title section-header mb-4">
                        <i class="bi bi-box-seam me-2"></i> Product Management
                    </h4>

                    <!-- Product Form -->
                    <form id="productForm" method="post" class="row g-3">
                        <input type="hidden" name="productId" value="0"/>

                        <div class="col-md-4">
                            <label class="form-label">Product Name *</label>
                            <input type="text" id="pname" name="pname" class="form-control" required/>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Company</label>
                            <input type="text" id="company" name="company" class="form-control"/>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Quantity *</label>
                            <input type="text" id="quantity" name="quantity" class="form-control" required/>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Batch No</label>
                            <input type="text" id="batchNo" name="batchNo" class="form-control"/>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Expiry Date</label>
                            <input type="date" id="expdate" name="expdate" class="form-control"/>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">MRP</label>
                            <input type="number" step="0.01" id="mrp" name="mrp" class="form-control"/>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Dealer Price</label>
                            <input type="number" step="0.01" id="dealerPrice" name="dealerPrice" class="form-control"/>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Price</label>
                            <input type="number" step="0.01" id="price" name="price" class="form-control"/>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Stock</label>
                            <input type="number" id="stock" name="stock" class="form-control"/>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Tax (%)</label>
                            <input type="number" step="0.01" id="taxPercentage" name="taxPercentage" class="form-control"/>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <i class="bi bi-save me-1"></i> Save Product
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="resetForm()">
                                <i class="bi bi-arrow-counterclockwise me-1"></i> Reset
                            </button>
                        </div>
                    </form>

                    <!-- Message Box -->
                    <div id="msgBox" class="alert d-none"></div>

                    <hr class="my-4"/>

                    <!-- Product Table -->
                    <div class="table-responsive">
                        <table id="productTable" class="table table-hover align-middle">
                            <thead>
                            <tr>
                                <th>Product Name</th>
                                <th>Company</th>
                                <th>Batch</th>
                                <th>Expiry</th>
                                <th>MRP</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Tax (%)</th>
                                <th>Edit</th>
                                <th>Delete</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="product" items="${products}">
                                <tr id="row-${product.productId}">
                                    <td>${product.productName}</td>
                                    <td>${product.company}</td>
                                    <td>${product.batchNo}</td>
                                    <td>${product.expdate}</td>
                                    <td class="text-end">${product.mrp}</td>
                                    <td class="text-end">${product.price}</td>
                                    <td class="text-center">${product.stock}</td>
                                    <td class="text-center">${product.taxPercentage}</td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-outline-success btn-sm"
                                                onclick="editProduct(${product.productId})">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
                                    </td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-outline-danger btn-sm"
                                                onclick="deleteProduct(${product.productId})">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>

<!-- Hidden Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
</form>

<jsp:include page="../view/footer.jsp"></jsp:include>


<script>
// ============================================
// PAGE INITIALIZATION
// ============================================
document.addEventListener('DOMContentLoaded', function() {
    // Initialize theme
    initializeTheme();



    // Initialize DataTable
    initializeDataTable();

    // Hide page loader
    setTimeout(function() {
        const loader = document.getElementById('pageLoader');
        if (loader) {
            loader.classList.add('hidden');
            setTimeout(() => loader.style.display = 'none', 500);
        }
    }, 1000);

    // Auto-dismiss success alert
    const successAlert = document.getElementById('success-alert');
    if (successAlert) {
        setTimeout(function() {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(successAlert);
            bsAlert.close();
        }, 3500);
    }
});

// ============================================
// THEME MANAGEMENT
// ============================================
function initializeTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.body.setAttribute('data-theme', savedTheme);
    const icon = document.getElementById('theme-icon');
    icon.className = savedTheme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
}

function toggleTheme() {
    const body = document.body;
    const icon = document.getElementById('theme-icon');
    const currentTheme = body.getAttribute('data-theme');

    if (currentTheme === 'light') {
        body.setAttribute('data-theme', 'dark');
        icon.className = 'fas fa-sun';
        localStorage.setItem('theme', 'dark');
    } else {
        body.setAttribute('data-theme', 'light');
        icon.className = 'fas fa-moon';
        localStorage.setItem('theme', 'light');
    }
}

// ============================================
// SIDEBAR MANAGEMENT
// ============================================


// ============================================
// DATATABLE INITIALIZATION
// ============================================
function initializeDataTable() {
    $('#productTable').DataTable({
        responsive: true,
        pageLength: 10,
        order: [[0, 'asc']],
        dom: 'Bfrtip',
        buttons: [
            {
                extend: 'copy',
                className: 'btn btn-sm btn-primary'
            },
            {
                extend: 'csv',
                className: 'btn btn-sm btn-primary'
            },
            {
                extend: 'excel',
                className: 'btn btn-sm btn-primary'
            },
            {
                extend: 'pdf',
                className: 'btn btn-sm btn-primary'
            },
            {
                extend: 'print',
                className: 'btn btn-sm btn-primary'
            }
        ],
        language: {
            search: "Search Products:",
            lengthMenu: "Show _MENU_ products",
            info: "Showing _START_ to _END_ of _TOTAL_ products",
            paginate: {
                first: "First",
                last: "Last",
                next: "Next",
                previous: "Previous"
            }
        }
    });
}

// ============================================
// CSRF TOKEN HELPER
// ============================================
function getCsrf() {
    return {
        token: '${_csrf.token}',
        header: '${_csrf.headerName}'
    };
}

// ============================================
// PRODUCT FORM SUBMISSION
// ============================================
document.getElementById("productForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const submitBtn = document.getElementById('submitBtn');
    const originalText = submitBtn.innerHTML;

    // Show loading state
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Saving...';

    const formData = new FormData(this);
    const csrf = getCsrf();

    fetch("${pageContext.request.contextPath}/product/save-or-update", {
        method: "POST",
        body: formData,
        credentials: "same-origin",
        headers: {
            [csrf.header]: csrf.token
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.status === "success") {
            showMessage(data.message, "success");
            setTimeout(() => location.reload(), 1500);
        } else {
            showMessage(data.message || "Failed to save product", "danger");
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        }
    })
    .catch(error => {
        console.error("Error saving product:", error);
        showMessage("Error saving product. Please try again.", "danger");
        submitBtn.disabled = false;
        submitBtn.innerHTML = originalText;
    });
});

// ============================================
// DELETE PRODUCT
// ============================================
function deleteProduct(productId) {
    if (!confirm("Are you sure you want to delete this product?")) {
        return;
    }

    const csrf = getCsrf();
    const row = document.getElementById("row-" + productId);

    fetch("${pageContext.request.contextPath}/product/delete-product-by-id?productId=" + productId, {
        method: "DELETE",
        credentials: "same-origin",
        headers: {
            [csrf.header]: csrf.token
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.status === "success") {
            showMessage(data.message, "success");
            if (row) {
                row.style.transition = 'opacity 0.3s';
                row.style.opacity = '0';
                setTimeout(() => row.remove(), 300);
            }
        } else {
            showMessage(data.message || "Failed to delete product", "danger");
        }
    })
    .catch(error => {
        console.error("Delete error:", error);
        showMessage("Error deleting product. Please try again.", "danger");
    });
}

// ============================================
// EDIT PRODUCT
// ============================================
function editProduct(productId) {
    fetch("${pageContext.request.contextPath}/product/get-product?id=" + productId)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(product => {
            // Fill form fields
            document.getElementById("pname").value = product.pname || product.productName || '';
            document.getElementById("company").value = product.company || '';
            document.getElementById("quantity").value = product.quantity || '';
            document.getElementById("batchNo").value = product.batchNo || '';
            document.getElementById("expdate").value = product.expdate || '';
            document.getElementById("mrp").value = product.mrp || '';
            document.getElementById("dealerPrice").value = product.dealerPrice || '';
            document.getElementById("price").value = product.price || '';
            document.getElementById("stock").value = product.stock || '';
            document.getElementById("taxPercentage").value = product.taxPercentage || '';

            // Set product ID for update
            document.querySelector("input[name='productId']").value = product.productId;

            // Change button text
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.innerHTML = '<i class="bi bi-save me-1"></i> Update Product';

            // Scroll to form
            document.getElementById("productForm").scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });

            showMessage("Product loaded for editing", "success");
        })
        .catch(error => {
            console.error("Error loading product:", error);
            showMessage("Error loading product. Please try again.", "danger");
        });
}

// ============================================
// RESET FORM
// ============================================
function resetForm() {
    document.getElementById("productForm").reset();
    document.querySelector("input[name='productId']").value = '0';
    const submitBtn = document.getElementById('submitBtn');
    submitBtn.innerHTML = '<i class="bi bi-save me-1"></i> Save Product';
    showMessage("Form reset successfully", "success");
}

// ============================================
// MESSAGE DISPLAY
// ============================================
function showMessage(msg, type) {
    const box = document.getElementById("msgBox");
    box.className = "alert alert-" + type;
    box.innerHTML = '<i class="bi bi-' + (type === 'success' ? 'check-circle-fill' : 'exclamation-triangle-fill') + ' me-2"></i>' + msg;
    box.classList.remove("d-none");

    // Scroll to message
    box.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

    // Auto-hide after 4 seconds
    setTimeout(() => box.classList.add("d-none"), 4000);
}

// ============================================
// LOGOUT FUNCTIONALITY
// ============================================
function confirmLogout(event) {
    event.preventDefault();

    if (confirm('Are you sure you want to logout?')) {
        performLogout();
    }
}

function performLogout() {
    try {
        const logoutForm = document.getElementById('logoutForm');
        if (logoutForm) {
            logoutForm.submit();
        } else {
            console.error('Logout form not found');
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    } catch (error) {
        console.error('Logout failed:', error);
        window.location.href = '${pageContext.request.contextPath}/logout';
    }
}

// ============================================
// NOTIFICATIONS
// ============================================
function openNotifications() {
    // Implement notification panel logic here
    alert('You have ' + '${fn:length(productList)}' + ' low stock alerts');
    // You can redirect to a notifications page or open a modal
    // window.location.href = '${pageContext.request.contextPath}/notifications';
}
</script>

</body>
</html>