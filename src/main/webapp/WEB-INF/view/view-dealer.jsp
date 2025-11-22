<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Purchase Entry - ${dealer.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary-color: #0d6efd;
            --primary-dark: #0a58ca;
            --primary-light: #e7f1ff;
            --success-color: #198754;
            --success-light: #d1e7dd;
            --danger-color: #dc3545;
            --danger-light: #f8d7da;
            --warning-color: #ffc107;
            --warning-light: #fff3cd;
            --info-color: #0dcaf0;
            --info-light: #cff4fc;
            --text-color: #212529;
            --text-secondary: #6c757d;
            --border-color: #dee2e6;
            --bg-secondary: #f8f9fa;
            --card-bg: #ffffff;
            --shadow-sm: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
            --shadow-md: 0 0.5rem 1rem rgba(0,0,0,0.15);
            --shadow-lg: 0 1rem 3rem rgba(0,0,0,0.175);
            --shadow-xl: 0 1.5rem 4rem rgba(0,0,0,0.2);
            --radius-sm: 0.25rem;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;
            --radius-xl: 1rem;
            --transition-fast: 0.15s;
            --transition-base: 0.3s;
        }

        [data-theme="dark"] {
            --text-color: #e9ecef;
            --text-secondary: #adb5bd;
            --border-color: #495057;
            --bg-secondary: #343a40;
            --card-bg: #212529;
        }

        body {
            background: var(--bg-secondary);
            color: var(--text-color);
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }

        /* Dealer Info Cards */
        .dealer-info-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: var(--radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
            box-shadow: var(--shadow-lg);
        }

        .dealer-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .dealer-info-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: var(--radius-md);
            padding: 1rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .dealer-info-card i {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            opacity: 0.9;
        }

        .dealer-info-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            opacity: 0.8;
            margin-bottom: 0.25rem;
        }

        .dealer-info-value {
            font-size: 1.1rem;
            font-weight: 600;
        }

        /* Purchase Summary Cards */
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .summary-card {
            background: var(--card-bg);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            border: 2px solid var(--border-color);
            transition: all var(--transition-base);
        }

        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .summary-card.total { border-left: 4px solid #667eea; }
        .summary-card.items { border-left: 4px solid #11998e; }
        .summary-card.tax { border-left: 4px solid #f093fb; }

        .summary-card-icon {
            width: 50px;
            height: 50px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .summary-card.total .summary-card-icon { background: #e7f1ff; color: #667eea; }
        .summary-card.items .summary-card-icon { background: #d1f4e8; color: #11998e; }
        .summary-card.tax .summary-card-icon { background: #fce4ff; color: #f093fb; }

        .summary-card-label {
            font-size: 0.875rem;
            color: var(--text-secondary);
            margin-bottom: 0.5rem;
        }

        .summary-card-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text-color);
        }

        /* Form Section */
        .form-section {
            background: var(--card-bg);
            border-radius: var(--radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--border-color);
        }

        .section-header h5 {
            margin: 0;
            font-weight: 600;
            color: var(--text-color);
        }

        .section-header i {
            font-size: 1.5rem;
            color: var(--primary-color);
        }

        /* Form Controls */
        .form-label-modern {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-color);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-control-modern, .form-select-modern {
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            border-radius: var(--radius-sm);
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            color: var(--text-color);
            transition: all var(--transition-fast);
        }

        .form-control-modern:focus, .form-select-modern:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px var(--primary-light);
            outline: none;
        }

        .form-control-modern[readonly] {
            background: var(--bg-secondary);
            cursor: not-allowed;
        }

        /* Items Table */
        .items-table-wrapper {
            background: var(--card-bg);
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 2rem;
            border: 1px solid var(--border-color);
        }

        .items-table {
            width: 100%;
            margin-bottom: 0;
        }

        .items-table thead {
            background: linear-gradient(135deg, #475569, #334155);
            color: white;
        }

        .items-table thead th {
            padding: 1rem;
            font-weight: 600;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
        }

        .items-table tbody tr {
            transition: background var(--transition-fast);
            border-bottom: 1px solid var(--border-color);
        }

        .items-table tbody tr:hover {
            background: var(--primary-light);
        }

        .items-table tbody td {
            padding: 1rem;
            color: var(--text-color);
            vertical-align: middle;
        }

        /* Quantity Controls */
        .qty-control {
            display: flex;
            align-items: stretch;
            gap: 0;
        }

        .qty-control .btn {
            padding: 0.5rem 0.75rem;
            border-radius: 0;
            font-size: 1rem;
            min-width: 40px;
            border: 2px solid var(--border-color);
        }

        .qty-control .btn:first-child {
            border-radius: var(--radius-sm) 0 0 var(--radius-sm);
            border-right: none;
        }

        .qty-control .btn:last-child {
            border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
            border-left: none;
        }

        .qty-control input {
            text-align: center;
            border-left: none;
            border-right: none;
            width: 80px;
        }

        /* Buttons */
        .btn-modern {
            padding: 0.75rem 1.5rem;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: var(--radius-md);
            transition: all var(--transition-base);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
        }

        .btn-modern:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-modern i {
            font-size: 1rem;
        }

        /* Alert */
        .alert-modern {
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            border-radius: var(--radius-md);
            font-size: 0.95rem;
            border: none;
            border-left: 4px solid;
            animation: slideInDown 0.3s ease-out;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-modern.alert-success {
            background: var(--success-light);
            border-left-color: var(--success-color);
            color: var(--success-color);
        }

        .alert-modern.alert-danger {
            background: var(--danger-light);
            border-left-color: var(--danger-color);
            color: var(--danger-color);
        }

        .alert-modern.alert-warning {
            background: var(--warning-light);
            border-left-color: var(--warning-color);
            color: #856404;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-secondary);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .dealer-info-grid {
                grid-template-columns: 1fr;
            }

            .summary-cards {
                grid-template-columns: 1fr;
            }

            .items-table {
                font-size: 0.85rem;
            }

            .items-table th, .items-table td {
                padding: 0.75rem 0.5rem;
            }
        }

        /* Select2 Custom Styling */
        .select2-container--default .select2-selection--single {
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            border-radius: var(--radius-sm);
            height: auto;
            padding: 0.75rem 1rem;
        }

        .select2-container--default .select2-selection--single:focus {
            border-color: var(--primary-color);
        }

        .select2-container--default .select2-results__option--highlighted.select2-results__option--selectable {
            background-color: var(--primary-light);
            color: var(--text-color);
        }
    </style>
</head>
<body>

<div class="container-fluid px-4 py-4">
    <!-- Dealer Info Section -->
    <div class="dealer-info-section">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h3 class="mb-2"><i class="fas fa-shopping-cart me-2"></i>Create Purchase Entry</h3>
                <p class="mb-0 opacity-75">Purchase Invoice: <strong>${purchaseNo}</strong> | Date: <strong>${date}</strong></p>
            </div>
            <a href="${pageContext.request.contextPath}/dealers/view-dealer/${dealer.id}" class="btn btn-light btn-modern">
                <i class="fas fa-arrow-left"></i> Back to Dealer
            </a>
        </div>

        <div class="dealer-info-grid">
            <div class="dealer-info-card">
                <i class="fas fa-building"></i>
                <div class="dealer-info-label">Dealer Name</div>
                <div class="dealer-info-value">${dealer.name}</div>
            </div>
            <div class="dealer-info-card">
                <i class="fas fa-phone"></i>
                <div class="dealer-info-label">Contact</div>
                <div class="dealer-info-value">${dealer.phoneNo}</div>
            </div>
            <div class="dealer-info-card">
                <i class="fas fa-map-marker-alt"></i>
                <div class="dealer-info-label">Address</div>
                <div class="dealer-info-value">${dealer.address}</div>
            </div>
            <div class="dealer-info-card">
                <i class="fas fa-file-invoice"></i>
                <div class="dealer-info-label">GST Number</div>
                <div class="dealer-info-value">${dealer.gstNo}</div>
            </div>
        </div>
    </div>

    <!-- Summary Cards -->
    <div class="summary-cards">
        <div class="summary-card total">
            <div class="summary-card-icon">
                <i class="fas fa-receipt"></i>
            </div>
            <div class="summary-card-label">Total Purchase Amount</div>
            <div class="summary-card-value">₹<span id="totalAmount">0.00</span></div>
        </div>
        <div class="summary-card items">
            <div class="summary-card-icon">
                <i class="fas fa-boxes"></i>
            </div>
            <div class="summary-card-label">Total Items</div>
            <div class="summary-card-value"><span id="totalItems">0</span></div>
        </div>
        <div class="summary-card tax">
            <div class="summary-card-icon">
                <i class="fas fa-percent"></i>
            </div>
            <div class="summary-card-label">Total GST</div>
            <div class="summary-card-value">₹<span id="totalGst">0.00</span></div>
        </div>
    </div>

    <!-- Alert Container -->
    <div id="alertContainer"></div>

    <!-- Add Product Form -->
    <div class="form-section">
        <div class="section-header">
            <i class="fas fa-plus-circle"></i>
            <h5>Add Product to Purchase</h5>
        </div>

        <form id="addProductForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="dealerId" value="${dealer.id}">
            <input type="hidden" name="purchaseNo" value="${purchaseNo}">
            <input type="hidden" name="productId" id="productId">
            <input type="hidden" name="productName" id="productName">

            <div class="row g-3">
                <div class="col-md-1">
                    <label class="form-label-modern">Item#</label>
                    <input type="text" class="form-control-modern text-center" name="itemNo" id="itemNo" readonly value="${itemNo}">
                </div>

                <div class="col-md-4">
                    <label class="form-label-modern">
                        <i class="fas fa-box"></i> Product
                    </label>
                    <select id="productDropdown" class="form-control-modern" style="width:100%"></select>
                </div>

                <div class="col-md-2">
                    <label class="form-label-modern">
                        <i class="fas fa-barcode"></i> Batch No
                    </label>
                    <input type="text" class="form-control-modern" name="batchNo" id="batchNo" required>
                </div>

                <div class="col-md-1">
                    <label class="form-label-modern">
                        <i class="fas fa-cubes"></i> Quantity
                    </label>
                    <div class="qty-control">
                        <button class="btn btn-outline-secondary" type="button" onclick="changeQty(-1)">
                            <i class="fas fa-minus"></i>
                        </button>
                        <input type="number" class="form-control-modern" name="quantity" id="quantity" value="1" min="1" onchange="calculateAmount()">
                        <button class="btn btn-outline-secondary" type="button" onclick="changeQty(1)">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                </div>

                <div class="col-md-2">
                    <label class="form-label-modern">
                        <i class="fas fa-rupee-sign"></i> Rate per Unit
                    </label>
                    <input type="number" step="0.01" class="form-control-modern text-end" name="rate" id="rate" required onchange="calculateAmount()">
                </div>

                <div class="col-md-1">
                    <label class="form-label-modern">
                        <i class="fas fa-percent"></i> GST %
                    </label>
                    <input type="number" step="0.01" class="form-control-modern text-end" name="gstPercent" id="gstPercent" value="0" onchange="calculateAmount()">
                </div>

                <div class="col-md-2">
                    <label class="form-label-modern">
                        <i class="fas fa-calculator"></i> Amount
                    </label>
                    <input type="text" class="form-control-modern text-end fw-bold" name="amount" id="amount" readonly style="color: var(--primary-color);">
                </div>

                <div class="col-md-12">
                    <button type="submit" class="btn btn-primary btn-modern">
                        <i class="fas fa-plus"></i> Add Product
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Items Table -->
    <div class="items-table-wrapper">
        <table class="items-table table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Product Name</th>
                    <th>Batch No</th>
                    <th class="text-center">Quantity</th>
                    <th class="text-end">Rate</th>
                    <th class="text-end">GST %</th>
                    <th class="text-end">GST Amount</th>
                    <th class="text-end">Total</th>
                    <th class="text-center">Action</th>
                </tr>
            </thead>
            <tbody id="itemsTableBody">
                <c:choose>
                    <c:when test="${empty purchaseItems}">
                        <tr>
                            <td colspan="9" class="empty-state">
                                <i class="fas fa-inbox"></i>
                                <p class="mb-0">No products added yet. Start adding products to create purchase entry.</p>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${purchaseItems}" var="item" varStatus="status">
                            <tr id="item-${item.id}">
                                <td>${item.itemNo}</td>
                                <td><strong>${item.productName}</strong></td>
                                <td><span class="badge bg-secondary">${item.batchNo}</span></td>
                                <td class="text-center">${item.quantity}</td>
                                <td class="text-end">₹${item.rate}</td>
                                <td class="text-end">${item.gstPercent}%</td>
                                <td class="text-end">₹${item.gstAmount}</td>
                                <td class="text-end"><strong style="color: var(--primary-color);">₹${item.totalAmount}</strong></td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-danger btn-sm" onclick="deleteItem('${item.id}')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Final Actions -->
    <div class="form-section">
        <form method="post" action="${pageContext.request.contextPath}/dealers/save-purchase">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="dealerId" value="${dealer.id}">
            <input type="hidden" name="purchaseNo" value="${purchaseNo}">
            <input type="hidden" id="totalAmountHidden" name="totalAmount" value="0">
            <input type="hidden" id="totalGstHidden" name="totalGst" value="0">
            <input type="hidden" id="totalItemsHidden" name="totalItems" value="0">

            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label-modern">
                        <i class="fas fa-file-invoice"></i> Dealer Invoice Number
                    </label>
                    <input type="text" class="form-control-modern" name="dealerInvoiceNo" required placeholder="Enter dealer's invoice number">
                </div>

                <div class="col-md-6">
                    <label class="form-label-modern">
                        <i class="fas fa-calendar"></i> Invoice Date
                    </label>
                    <input type="date" class="form-control-modern" name="invoiceDate" value="${date}" required>
                </div>

                <div class="col-md-12">
                    <label class="form-label-modern">
                        <i class="fas fa-sticky-note"></i> Notes (Optional)
                    </label>
                    <textarea class="form-control-modern" name="notes" rows="3" placeholder="Add any additional notes..."></textarea>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-3">
                <button type="button" onclick="location.reload();" class="btn btn-outline-secondary btn-modern">
                    <i class="fas fa-sync-alt"></i> Reset
                </button>
                <button type="submit" class="btn btn-success btn-modern" id="savePurchaseBtn" ${empty purchaseItems ? 'disabled' : ''}>
                    <i class="fas fa-save"></i> Save Purchase Entry
                </button>
            </div>
        </form>
    </div>
</div>

<!-- jQuery & Select2 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
let currentItemNo = ${itemNo};

// Calculate amount with GST
function calculateAmount() {
    const qty = parseFloat($('#quantity').val()) || 0;
    const rate = parseFloat($('#rate').val()) || 0;
    const gstPercent = parseFloat($('#gstPercent').val()) || 0;

    const baseAmount = qty * rate;
    const gstAmount = (baseAmount * gstPercent) / 100;
    const totalAmount = baseAmount + gstAmount;

    $('#amount').val(totalAmount.toFixed(2));
}

// Change quantity
function changeQty(val) {
    let qtyInput = $('#quantity');
    let current = parseInt(qtyInput.val()) || 0;
    current += val;
    if (current < 1) current = 1;
    qtyInput.val(current);
    calculateAmount();
}

// Show alert
function showAlert(message, type) {
    const alertHtml = `
        <div class="alert alert-modern alert-${type} alert-dismissible fade show" role="alert">
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'danger' ? 'exclamation-circle' : 'exclamation-triangle'}"></i>
            <strong>${type === 'success' ? 'Success!' : type === 'danger' ? 'Error!' : 'Warning!'}</strong> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;
    $('#alertContainer').html(alertHtml);

    setTimeout(() => {
        $('.alert').fadeOut();
    }, 4000);
}

// Update totals
function updateTotals() {
    let totalAmount = 0;
    let totalGst = 0;
    let totalItems = 0;

    $('#itemsTableBody tr').each(function() {
        if (!$(this).find('.empty-state').length) {
            const amount = parseFloat($(this).find('td:eq(7)').text().replace('₹', '')) || 0;
            const gst = parseFloat($(this).find('td:eq(6)').text().replace('₹', '')) || 0;
            totalAmount += amount;
            totalGst += gst;
            totalItems++;
        }
    });

    $('#totalAmount').text(totalAmount.toFixed(2));
    $('#totalGst').text(totalGst.toFixed(2));
    $('#totalItems').text(totalItems);

    $('#totalAmountHidden').val(totalAmount.toFixed(2));
    $('#totalGstHidden').val(totalGst.toFixed(2));
    $('#totalItemsHidden').val(totalItems);

    // Enable/disable save button
    $('#savePurchaseBtn').prop('disabled', totalItems === 0);
}

// Delete item
function deleteItem(itemId) {
    if (!confirm('Are you sure you want to delete this item?')) {
        return;
    }

    $.ajax({
        url: '${pageContext.request.contextPath}/dealers/delete-purchase-item',
        type: 'DELETE',
        contentType: 'application/json',
        data: JSON.stringify({ itemId: itemId }),
        headers: {
            '${_csrf.headerName}': '${_csrf.token}'
        },
        success: function(response) {
            if (response.status === 'success') {
                $('#item-' + itemId).fadeOut(300, function() {
                    $(this).remove();

                    if ($('#itemsTableBody tr').length === 0) {
                        $('#itemsTableBody').html(`
                            <tr>
                                <td colspan="9" class="empty-state">
                                    <i class="fas fa-inbox"></i>
                                    <p class="mb-0">No products added yet.</p>
                                </td>
                            </tr>
                        `);
                    }

                    updateTotals();
                });
                showAlert('Item deleted successfully!', 'success');
            } else {
                showAlert(response.message || 'Failed to delete item.', 'danger');
            }
        },
        error: function() {
            showAlert('Error occurred while deleting item.', 'danger');
        }
    });
}

// Initialize
$(document).ready(function() {
    // Initialize Select2
    $('#productDropdown').select2({
        placeholder: 'Search and select product...',
        allowClear: true,
        minimumInputLength: 2,
        ajax: {
            url: '${pageContext.request.contextPath}/products/search',
            dataType: 'json',
            delay: 250,
            data: function(params) {
                return { query: params.term };
            },
            processResults: function(data) {
                return {
                    results: $.map(data, function(item) {
                        return {
                            id: item.id,
                            text: `${item.name} - ₹${item.purchaseRate}`,
                            name: item.name,
                            rate: item.purchaseRate,
                            gst: item.gstPercent || 0
                        };
                    })
                };
            },
            cache: true
        }
    });

    // Product selection handler
    $('#productDropdown').on('select2:select', function(e) {
        const data = e.params.data;
        $('#productId').val(data.id);
        $('#productName').val(data.name);
        $('#rate').val(data.rate);
        $('#gstPercent').val(data.gst);
        calculateAmount();
    });

    // Add product form submission
    $('#addProductForm').on('submit', function(e) {
        e.preventDefault();

        const productId = $('#productId').val();
        const productName = $('#productName').val();

        if (!productId || !productName) {
            showAlert('Please select a product.', 'warning');
            return;
        }

        const formData = {
            dealerId: $('input[name="dealerId"]').val(),
            purchaseNo: $('input[name="purchaseNo"]').val(),
            itemNo: $('#itemNo').val(),
            productId: productId,
            productName: productName,
            batchNo: $('#batchNo').val(),
            quantity: $('#quantity').val(),
            rate: $('#rate').val(),
            gstPercent: $('#gstPercent').val(),
            amount: $('#amount').val()
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/dealers/add-purchase-item',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            headers: {
                '${_csrf.headerName}': '${_csrf.token}'
            },
            success: function(response) {
                if (response.status === 'success') {
                    showAlert('Product added successfully!', 'success');

                    // Remove empty state if exists
                    $('#itemsTableBody .empty-state').closest('tr').remove();

                    // Add new row
                    const item = response.item;
                    const newRow = `
                        <tr id="item-${item.id}">
                            <td>${item.itemNo}</td>
                            <td><strong>${item.productName}</strong></td>
                            <td><span class="badge bg-secondary">${item.batchNo}</span></td>
                            <td class="text-center">${item.quantity}</td>
                            <td class="text-end">₹${item.rate}</td>
                            <td class="text-end">${item.gstPercent}%</td>
                            <td class="text-end">₹${item.gstAmount}</td>
                            <td class="text-end"><strong style="color: var(--primary-color);">₹${item.totalAmount}</strong></td>
                            <td class="text-center">
                                <button type="button" class="btn btn-danger btn-sm" onclick="deleteItem('${item.id}')">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `;

                    $('#itemsTableBody').append(newRow);

                    // Reset form
                    $('#addProductForm')[0].reset();
                    $('#productDropdown').val(null).trigger('change');
                    $('#amount').val('');
                    currentItemNo++;
                    $('#itemNo').val(currentItemNo);

                    // Update totals
                    updateTotals();

                } else {
                    showAlert(response.message || 'Failed to add product.', 'danger');
                }
            },
            error: function() {
                showAlert('Error occurred while adding product.', 'danger');
            }
        });
    });

    // Initial totals calculation
    updateTotals();
});
</script>

</body>
</html>