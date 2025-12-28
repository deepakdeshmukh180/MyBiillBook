<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>


        .product-row {
            transition: all 0.2s;
        }
        .product-row:hover {
            background-color: #f8f9fa;
            transform: scale(1.01);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .btn-action {
            width: 35px;
            height: 35px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            transition: all 0.2s;
        }
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .filter-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            margin: 5px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .filter-badge:hover {
            transform: scale(1.05);
        }
        .filter-badge.active {
            background-color: #667eea;
            color: white;
        }
        .fade-in {
            animation: fadeIn 0.3s;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .low-stock {
            color: #dc3545;
            font-weight: 600;
        }
        .good-stock {
            color: #28a745;
            font-weight: 600;
        }
        .product-form-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* Inline Spinner Styles */
        .spinner-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }
        .spinner-overlay.show {
            display: flex;
        }
        .spinner-content {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            text-align: center;
        }
        .spinner-border-custom {
            width: 3rem;
            height: 3rem;
            border: 0.3em solid #f3f3f3;
            border-top: 0.3em solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>

<jsp:include page="../view/logo.jsp"></jsp:include>

<div id="layoutSidenav_content">
<main>
<div class="container-fluid px-4 mt-4">

    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="h3 mb-0 text-gray-800">
            <i class="fas fa-boxes me-2"></i>Product Management
        </h2>
        <button class="btn btn-primary" onclick="toggleProductForm()">
            <i class="bi bi-plus-circle me-1"></i>Add New Product
        </button>
    </div>

    <!-- Product Form -->
    <div id="productFormContainer" class="product-form-card" style="display:none;">
        <h5 class="mb-3">
            <i class="bi bi-box-seam me-2"></i>
            <span id="formTitle">Add New Product</span>
        </h5>

        <form id="productForm" class="row g-3">
            <input type="hidden" id="productId" name="productId" value="0"/>

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
            <div class="col-md-4">
                <label class="form-label">Stock</label>
                <input type="number" id="stock" name="stock" class="form-control"/>
            </div>
            <div class="col-md-4">
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
                <button type="button" class="btn btn-outline-secondary" onclick="toggleProductForm()">
                    <i class="bi bi-x-circle me-1"></i> Cancel
                </button>
            </div>
        </form>

        <div id="msgBox" class="alert d-none mt-3"></div>
    </div>

    <!-- Quick Filters -->
    <div class="mb-3">
        <span class="filter-badge bg-light active" data-filter="all" onclick="filterProducts('all')">
            <i class="fas fa-box me-1"></i>All Products
        </span>
        <span class="filter-badge bg-light" data-filter="low-stock" onclick="filterProducts('low-stock')">
            <i class="fas fa-exclamation-triangle me-1"></i>Low Stock
        </span>
        <span class="filter-badge bg-light" data-filter="good-stock" onclick="filterProducts('good-stock')">
            <i class="fas fa-check-circle me-1"></i>Good Stock
        </span>
    </div>

    <!-- Search Bar -->
    <div class="row mb-4">
        <div class="col-md-10 mx-auto">
            <div class="input-group">
                <span class="input-group-text bg-white border-end-0">
                    <i class="fas fa-search text-muted"></i>
                </span>
                <input type="text" id="searchBox" class="form-control border-start-0"
                       placeholder="Search by product name, company, or batch number...">
                <button class="btn btn-outline-secondary" onclick="location.reload()">
                    <i class="fas fa-sync-alt me-1"></i>Refresh
                </button>
                <button class="btn btn-outline-danger" onclick="clearSearch()">
                    <i class="fas fa-times me-1"></i>Clear
                </button>
            </div>
        </div>
    </div>

    <!-- Export Buttons -->
    <div class="row mb-3">
        <div class="col-md-10 mx-auto d-flex justify-content-end gap-2">
            <button class="btn btn-outline-primary btn-sm" onclick="exportToExcel()">
                <i class="fas fa-file-excel me-1"></i>Export Excel
            </button>
            <button class="btn btn-outline-secondary btn-sm" onclick="printTable()">
                <i class="fas fa-print me-1"></i>Print
            </button>
        </div>
    </div>

    <!-- Results Summary -->
    <div id="resultsSummary" class="alert alert-info" style="display:none;">
        <i class="fas fa-info-circle me-2"></i>
        <span id="resultsText"></span>
    </div>

    <!-- Product Table -->
    <div class="table-responsive">
        <table id="productTable" class="table table-hover table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th><i class="fas fa-box me-1"></i>Product Name</th>
                    <th><i class="fas fa-building me-1"></i>Company</th>
                    <th><i class="fas fa-barcode me-1"></i>Batch</th>
                    <th><i class="fas fa-calendar me-1"></i>Expiry</th>
                    <th><i class="fas fa-tag me-1"></i>MRP</th>
                    <th><i class="fas fa-rupee-sign me-1"></i>Price</th>
                    <th><i class="fas fa-warehouse me-1"></i>Stock</th>
                    <th><i class="fas fa-percentage me-1"></i>Tax (%)</th>
                    <th width="120"><i class="fas fa-cog me-1"></i>Actions</th>
                </tr>
            </thead>
            <tbody id="productTableBody">
                <c:choose>
                    <c:when test="${empty products}">
                        <tr>
                            <td colspan="10" class="text-center text-muted py-4">
                                <i class="fas fa-box-open fa-3x mb-3 d-block"></i>
                                <h5>No Products Found</h5>
                                <p>Add your first product to get started.</p>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="product" items="${products}" varStatus="i">
                            <tr id="row-${product.productId}" class="product-row" data-stock="${product.stock}">
                                <td>${i.index + 1}</td>
                                <td><strong>${product.productName}</strong></td>
                                <td>${product.company}</td>
                                <td>${product.batchNo}</td>
                                <td>${product.expdate}</td>
                                <td class="text-end">₹${product.mrp}</td>
                                <td class="text-end">₹${product.price}</td>
                                <td class="text-center ${product.stock < 10 ? 'low-stock' : 'good-stock'}">
                                    ${product.stock}
                                    <c:if test="${product.stock < 10}">
                                        <i class="fas fa-exclamation-triangle ms-1" title="Low Stock"></i>
                                    </c:if>
                                </td>
                                <td class="text-center">${product.taxPercentage}%</td>
                                <td>
                                    <div class="d-flex gap-1 justify-content-center">
                                        <button type="button" class="btn btn-success btn-action"
                                                onclick="editProduct(${product.productId})" title="Edit">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
                                        <button type="button" class="btn btn-danger btn-action"
                                                onclick="deleteProduct(${product.productId})" title="Delete">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

</div>
</main>

<!-- Loading Spinner Overlay -->
<div id="loadingSpinner" class="spinner-overlay">
    <div class="spinner-content">
        <div class="spinner-border-custom"></div>
        <p class="mt-3 mb-0"><strong>Processing...</strong></p>
    </div>
</div>

<jsp:include page="../view/footer.jsp"></jsp:include>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<script>
// Wrap everything in IIFE to avoid function name collisions with logo.jsp
(function() {
    'use strict';

var contextPath = '${pageContext.request.contextPath}';
var debounceTimer;
var originalTableBody;

document.addEventListener('DOMContentLoaded', function() {
    var tableBody = document.getElementById('productTableBody');
    if (tableBody) {
        originalTableBody = tableBody.innerHTML;
    }
    initializeSearch();
});

// Spinner Control Functions
function showSpinner() {
    var spinner = document.getElementById('loadingSpinner');
    if (spinner) {
        spinner.classList.add('show');
    }
}

function hideSpinner() {
    var spinner = document.getElementById('loadingSpinner');
    if (spinner) {
        spinner.classList.remove('show');
    }
}

// Toggle Product Form
function toggleProductForm() {
    var formContainer = document.getElementById('productFormContainer');
    if (!formContainer) return;

    if (formContainer.style.display === 'none' || formContainer.style.display === '') {
        formContainer.style.display = 'block';
        formContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } else {
        formContainer.style.display = 'none';
        resetForm();
    }
}

// CSRF Token Helper
function getCsrf() {
    return {
        token: '${_csrf.token}',
        header: '${_csrf.headerName}'
    };
}

// Product Form Submission
var productForm = document.getElementById('productForm');
if (productForm) {
    productForm.addEventListener('submit', function(e) {
        e.preventDefault();

        var submitBtn = document.getElementById('submitBtn');
        if (!submitBtn) return;

        var originalText = submitBtn.innerHTML;

        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Saving...';
        showSpinner();

        var formData = new FormData(this);
        var csrf = getCsrf();

        fetch(contextPath + '/product/save-or-update', {
            method: 'POST',
            body: formData,
            credentials: 'same-origin',
            headers: csrf.header ? { [csrf.header]: csrf.token } : {}
        })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            hideSpinner();
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;

            if (data.status === 'success') {
                showMessage(data.message, 'success');
                setTimeout(function() {
                    location.reload();
                }, 1500);
            } else {
                showMessage(data.message || 'Failed to save product', 'danger');
            }
        })
        .catch(function(error) {
            console.error('Error:', error);
            hideSpinner();
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
            showMessage('Error saving product. Please try again.', 'danger');
        });
    });
}

// Edit Product
function editProduct(productId) {
    showSpinner();

    fetch(contextPath + '/product/get-product?id=' + productId)
        .then(function(response) {
            if (!response.ok) throw new Error('Product not found');
            return response.json();
        })
        .then(function(product) {
            hideSpinner();

            // Show form
            var formContainer = document.getElementById('productFormContainer');
            var formTitle = document.getElementById('formTitle');

            if (formContainer) formContainer.style.display = 'block';
            if (formTitle) formTitle.textContent = 'Edit Product';

            // Fill form
            var fields = {
                'productId': product.productId || 0,
                'pname': product.pname || '',
                'company': product.company || '',
                'quantity': product.quantity || '',
                'batchNo': product.batchNo || '',
                'expdate': product.expdate || '',
                'mrp': product.mrp || '',
                'dealerPrice': product.dealerPrice || '',
                'price': product.price || '',
                'stock': product.stock || '',
                'taxPercentage': product.taxPercentage || ''
            };

            for (var fieldId in fields) {
                var field = document.getElementById(fieldId);
                if (field) field.value = fields[fieldId];
            }

            // Update button
            var submitBtn = document.getElementById('submitBtn');
            if (submitBtn) {
                submitBtn.innerHTML = '<i class="bi bi-save me-1"></i> Update Product';
            }

            // Scroll to form
            if (formContainer) {
                formContainer.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }

            showMessage('Product loaded for editing', 'info');
        })
        .catch(function(error) {
            hideSpinner();
            console.error('Error:', error);
            showMessage('Error loading product. Please try again.', 'danger');
        });
}

// Delete Product
function deleteProduct(productId) {
    if (!confirm('Are you sure you want to delete this product?')) return;

    var csrf = getCsrf();
    var row = document.getElementById('row-' + productId);

    showSpinner();

    fetch(contextPath + '/product/delete-product-by-id?productId=' + productId, {
        method: 'DELETE',
        credentials: 'same-origin',
        headers: csrf.header ? { [csrf.header]: csrf.token } : {}
    })
    .then(function(response) {
        return response.json();
    })
    .then(function(data) {
        hideSpinner();

        if (data.status === 'success') {
            showMessage(data.message, 'success');
            if (row) {
                row.style.transition = 'opacity 0.3s';
                row.style.opacity = '0';
                setTimeout(function() {
                    row.remove();
                }, 300);
            }
        } else {
            showMessage(data.message || 'Failed to delete product', 'danger');
        }
    })
    .catch(function(error) {
        hideSpinner();
        console.error('Error:', error);
        showMessage('Error deleting product. Please try again.', 'danger');
    });
}

// Reset Form
function resetForm() {
    var form = document.getElementById('productForm');
    var formTitle = document.getElementById('formTitle');
    var submitBtn = document.getElementById('submitBtn');
    var msgBox = document.getElementById('msgBox');

    if (form) form.reset();

    var productIdField = document.getElementById('productId');
    if (productIdField) productIdField.value = '0';

    if (formTitle) formTitle.textContent = 'Add New Product';
    if (submitBtn) submitBtn.innerHTML = '<i class="bi bi-save me-1"></i> Save Product';
    if (msgBox) msgBox.classList.add('d-none');
}

// Show Message
function showMessage(msg, type) {
    var box = document.getElementById('msgBox');
    if (!box) return;

    var iconClass = 'info-circle-fill';
    if (type === 'success') iconClass = 'check-circle-fill';
    else if (type === 'danger') iconClass = 'exclamation-triangle-fill';

    box.className = 'alert alert-' + type + ' mt-3';
    box.innerHTML = '<i class="bi bi-' + iconClass + ' me-2"></i>' + msg;
    box.classList.remove('d-none');

    box.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

    setTimeout(function() {
        box.classList.add('d-none');
    }, 4000);
}

// Search Functionality
function initializeSearch() {
    var searchInput = document.getElementById('searchBox');
    if (!searchInput) return;

    searchInput.addEventListener('input', function() {
        clearTimeout(debounceTimer);
        var query = searchInput.value.trim();

        if (query.length === 0) {
            resetToOriginal();
            return;
        }

        if (query.length < 2) return;

        debounceTimer = setTimeout(function() {
            performSearch(query);
        }, 500);
    });
}

function performSearch(query) {
    var tableBody = document.getElementById('productTableBody');
    if (!tableBody) return;

    showSpinner();
    tableBody.innerHTML = '';

    fetch(contextPath + '/product/search?query=' + encodeURIComponent(query))
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            hideSpinner();
            handleSearchSuccess(data, query);
        })
        .catch(function(error) {
            hideSpinner();
            console.error('Search error:', error);
            handleSearchError('Search failed. Please try again.');
        });
}

function handleSearchSuccess(list, query) {
    var tableBody = document.getElementById('productTableBody');
    var resultsSummary = document.getElementById('resultsSummary');
    var resultsText = document.getElementById('resultsText');

    if (!tableBody) return;

    if (!list || list.length === 0) {
        tableBody.innerHTML =
            '<tr><td colspan="10" class="text-center text-muted py-4">' +
            '<i class="fas fa-search fa-3x mb-3 d-block"></i>' +
            '<h5>No matching products found</h5>' +
            '<p>Try adjusting your search terms</p>' +
            '<button class="btn btn-outline-primary btn-sm mt-2" onclick="clearSearch()">' +
            '<i class="fas fa-times me-1"></i> Clear Search</button></td></tr>';
        if (resultsSummary) resultsSummary.style.display = 'none';
        return;
    }

    if (resultsText) {
        resultsText.textContent = 'Found ' + list.length + ' product(s) matching "' + query + '"';
    }
    if (resultsSummary) {
        resultsSummary.style.display = 'block';
    }

    var html = '';
    for (var i = 0; i < list.length; i++) {
        var p = list[i];
        var stockClass = p.stock < 10 ? 'low-stock' : 'good-stock';
        var stockWarning = p.stock < 10 ? '<i class="fas fa-exclamation-triangle ms-1"></i>' : '';

        html += '<tr id="row-' + p.productId + '" class="product-row fade-in" data-stock="' + p.stock + '">' +
            '<td>' + (i + 1) + '</td>' +
            '<td><strong>' + escapeHtml(p.productName || '') + '</strong></td>' +
            '<td>' + escapeHtml(p.company || '') + '</td>' +
            '<td>' + escapeHtml(p.batchNo || '') + '</td>' +
            '<td>' + escapeHtml(p.expdate || '') + '</td>' +
            '<td class="text-end">₹' + (p.mrp || 0).toFixed(2) + '</td>' +
            '<td class="text-end">₹' + (p.price || 0).toFixed(2) + '</td>' +
            '<td class="text-center ' + stockClass + '">' + (p.stock || 0) + stockWarning + '</td>' +
            '<td class="text-center">' + (p.taxPercentage || 0) + '%</td>' +
            '<td><div class="d-flex gap-1 justify-content-center">' +
            '<button class="btn btn-success btn-action" onclick="editProduct(' + p.productId + ')">' +
            '<i class="bi bi-pencil-square"></i></button>' +
            '<button class="btn btn-danger btn-action" onclick="deleteProduct(' + p.productId + ')">' +
            '<i class="bi bi-trash"></i></button></div></td></tr>';
    }

    tableBody.innerHTML = html;
}

function handleSearchError(errorMessage) {
    var tableBody = document.getElementById('productTableBody');
    if (!tableBody) return;

    tableBody.innerHTML =
        '<tr><td colspan="10" class="text-center text-danger py-4">' +
        '<i class="fas fa-exclamation-triangle fa-2x mb-3 d-block"></i>' +
        '<h5>Error</h5><p>' + errorMessage + '</p>' +
        '<button class="btn btn-primary btn-sm mt-2" onclick="clearSearch()">' +
        '<i class="fas fa-refresh me-1"></i> Try Again</button></td></tr>';
}

function resetToOriginal() {
    var tableBody = document.getElementById('productTableBody');
    var resultsSummary = document.getElementById('resultsSummary');

    if (tableBody && originalTableBody) {
        tableBody.innerHTML = originalTableBody;
    }
    if (resultsSummary) {
        resultsSummary.style.display = 'none';
    }
}

function clearSearch() {
    var searchInput = document.getElementById('searchBox');
    if (searchInput) {
        searchInput.value = '';
    }
    resetToOriginal();
}

// Filter Products
function filterProducts(filter) {
    var badges = document.querySelectorAll('.filter-badge');
    for (var i = 0; i < badges.length; i++) {
        badges[i].classList.remove('active');
    }

    var activeFilter = document.querySelector('[data-filter="' + filter + '"]');
    if (activeFilter) {
        activeFilter.classList.add('active');
    }

    var rows = document.querySelectorAll('#productTableBody tr');
    for (var j = 0; j < rows.length; j++) {
        var row = rows[j];
        var stock = parseInt(row.getAttribute('data-stock')) || 0;

        if (filter === 'all') {
            row.style.display = '';
        } else if (filter === 'low-stock') {
            row.style.display = stock < 10 ? '' : 'none';
        } else if (filter === 'good-stock') {
            row.style.display = stock >= 10 ? '' : 'none';
        }
    }
}

// Export to Excel
function exportToExcel() {
    var table = document.getElementById('productTable');
    if (!table) return;

    var wb = XLSX.utils.table_to_book(table, {sheet: 'Products'});
    XLSX.writeFile(wb, 'products_' + new Date().toISOString().split('T')[0] + '.xlsx');
}

// Print Table
function printTable() {
    window.print();
}

// Escape HTML
function escapeHtml(text) {
    var div = document.createElement('div');
    div.textContent = text || '';
    return div.innerHTML;
}

// Make functions global so they can be called from onclick attributes
window.toggleProductForm = toggleProductForm;
window.editProduct = editProduct;
window.deleteProduct = deleteProduct;
window.resetForm = resetForm;
window.filterProducts = filterProducts;
window.exportToExcel = exportToExcel;
window.printTable = printTable;
window.clearSearch = clearSearch;

})(); // End IIFE
</script>

<style media="print">
    .btn, .filter-badge, #searchBox, .input-group, .product-form-card, .spinner-overlay {
        display: none !important;
    }
    .table { font-size: 12px; }
</style>

</body>
</html>