<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="../view/logo.jsp"></jsp:include>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Purchase Entry - ${dealer.dealerName}</title>

    <style>
        :root {
            --primary-color: #6366f1;
            --primary-dark: #4f46e5;
            --primary-light: #eef2ff;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --bg-secondary: #f9fafb;
            --text-color: #1f2937;
            --text-secondary: #6b7280;
            --border-color: #e5e7eb;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            --radius-sm: 0.375rem;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;
            --radius-xl: 1rem;
            --transition-base: all 0.3s ease;
            --transition-fast: all 0.15s ease;
        }

        body {
            background-color: #f3f4f6;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        .purchase-header-card {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            border-radius: var(--radius-xl);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            color: white;
            box-shadow: var(--shadow-lg);
        }

        .purchase-header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .purchase-header-left h4 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .purchase-invoice-info {
            display: flex;
            gap: 2rem;
            font-size: 0.9rem;
            opacity: 0.95;
        }

        .purchase-invoice-info span {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-purchase-header {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: var(--radius-md);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition-base);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-purchase-header:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            transform: translateY(-2px);
            text-decoration: none;
        }

        .dealer-info-compact {
            background: rgba(255, 255, 255, 0.15);
            border-radius: var(--radius-md);
            padding: 1rem;
            margin-top: 1rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .dealer-info-item {
            display: flex;
            flex-direction: column;
        }

        .dealer-info-label {
            font-size: 0.75rem;
            opacity: 0.8;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.25rem;
        }

        .dealer-info-value {
            font-size: 0.95rem;
            font-weight: 600;
        }

        .content-card {
            background: white;
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-color);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--border-color);
        }

        .section-title i {
            color: var(--primary-color);
        }

        .purchase-summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .purchase-stat-card {
            background: var(--bg-secondary);
            border-radius: var(--radius-md);
            padding: 1.25rem;
            border-left: 4px solid;
            transition: transform var(--transition-base);
        }

        .purchase-stat-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .purchase-stat-card.total { border-left-color: var(--primary-color); }
        .purchase-stat-card.items { border-left-color: var(--success-color); }
        .purchase-stat-card.tax { border-left-color: var(--warning-color); }

        .purchase-stat-label {
            font-size: 0.85rem;
            color: var(--text-secondary);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .purchase-stat-value {
            font-size: 1.75rem;
            font-weight: 700;
        }

        .purchase-stat-card.total .purchase-stat-value { color: var(--primary-color); }
        .purchase-stat-card.items .purchase-stat-value { color: var(--success-color); }
        .purchase-stat-card.tax .purchase-stat-value { color: var(--warning-color); }

        .form-label {
            font-weight: 600;
            color: var(--text-color);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .form-label i {
            color: var(--primary-color);
            margin-right: 0.25rem;
        }

        .form-control {
            border: 2px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 0.625rem 0.875rem;
            transition: var(--transition-base);
            font-size: 0.9375rem;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            outline: none;
        }

        .purchase-qty-wrapper {
            display: flex;
            align-items: stretch;
        }

        .purchase-qty-btn {
            background: var(--bg-secondary);
            border: 2px solid var(--border-color);
            padding: 0.65rem 1rem;
            cursor: pointer;
            transition: var(--transition-base);
            font-weight: 600;
            color: var(--text-color);
        }

        .purchase-qty-btn:hover {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .purchase-qty-btn:first-child {
            border-radius: var(--radius-md) 0 0 var(--radius-md);
            border-right: none;
        }

        .purchase-qty-btn:last-child {
            border-radius: 0 var(--radius-md) var(--radius-md) 0;
            border-left: none;
        }

        .purchase-qty-input {
            text-align: center;
            border-left: none !important;
            border-right: none !important;
            width: 80px;
            border-radius: 0 !important;
        }

        .purchase-table-wrapper {
            border-radius: var(--radius-md);
            overflow: hidden;
            border: 1px solid var(--border-color);
        }

        .purchase-modern-table {
            margin-bottom: 0;
            width: 100%;
        }

        .purchase-modern-table thead {
            background: linear-gradient(135deg, #1f2937, #111827);
        }

        .purchase-modern-table thead th {
            color: white;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 1rem;
            border: none;
        }

        .purchase-modern-table tbody tr {
            transition: background var(--transition-fast);
            border-bottom: 1px solid var(--border-color);
        }

        .purchase-modern-table tbody tr:hover {
            background: var(--primary-light);
        }

        .purchase-modern-table tbody td {
            padding: 1rem;
            vertical-align: middle;
            color: var(--text-color);
        }

        .empty-state {
            text-align: center;
            padding: 3rem 1rem !important;
            color: var(--text-secondary);
        }

        .empty-state i {
            font-size: 3rem;
            opacity: 0.3;
            display: block;
            margin-bottom: 1rem;
        }

        .btn {
            border-radius: var(--radius-md);
            padding: 0.625rem 1.25rem;
            font-weight: 600;
            transition: var(--transition-base);
            border: none;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-success {
            background: var(--success-color);
            color: white;
        }

        .btn-success:hover {
            background: #059669;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-danger {
            background: var(--danger-color);
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        .btn-outline-secondary {
            border: 2px solid var(--border-color);
            color: var(--text-color);
            background: white;
        }

        .btn-outline-secondary:hover {
            background: var(--bg-secondary);
            border-color: var(--text-secondary);
        }

        .alert {
            border-radius: var(--radius-md);
            padding: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            border: none;
            margin-bottom: 1rem;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
        }

        .alert-warning {
            background: #fef3c7;
            color: #92400e;
        }

        .badge {
            padding: 0.375rem 0.75rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            font-size: 0.8125rem;
        }

        .bg-secondary {
            background-color: #6b7280 !important;
            color: white;
        }

        @media (max-width: 768px) {
            .purchase-header-content {
                flex-direction: column;
                align-items: stretch;
            }

            .dealer-info-compact {
                grid-template-columns: 1fr;
            }

            .purchase-summary-grid {
                grid-template-columns: 1fr;
            }

            .purchase-invoice-info {
                flex-direction: column;
                gap: 0.5rem;
            }
        }

        /* Select2 Custom Styling */
        .select2-container--default .select2-selection--single {
            border: 2px solid var(--border-color);
            border-radius: var(--radius-md);
            height: auto;
            padding: 0.5rem;
        }

        .select2-container--default .select2-selection--single:focus {
            border-color: var(--primary-color);
        }

        .select2-container--default .select2-selection--single .select2-selection__rendered {
            color: var(--text-color);
            line-height: normal;
        }

        .select2-dropdown {
            border: 2px solid var(--primary-color);
            border-radius: var(--radius-md);
        }

        .select2-results__option {
            padding: 0.75rem;
        }

        .select2-results__option--highlighted {
            background-color: var(--primary-light) !important;
            color: var(--text-color) !important;
        }
    </style>
</head>

<body class="sb-nav-fixed" data-theme="light">

<div id="layoutSidenav_content">
    <main>
        <div class="container-fluid px-3 py-3">

            <!-- Success Alert -->
            <c:if test="${not empty msg}">
                <div class="alert alert-success alert-dismissible fade show" id="success-alert">
                    <i class="fas fa-check-circle fa-lg"></i>
                    <div>
                        <strong>Success!</strong> ${msg}
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Compact Header Card -->
            <div class="purchase-header-card">
                <div class="purchase-header-content">
                    <div class="purchase-header-left">
                        <h4><i class="fas fa-shopping-cart"></i> Create Purchase Entry</h4>
                        <div class="purchase-invoice-info">
                            <span><i class="fas fa-file-invoice"></i> Invoice: <strong>${purchaseNo}</strong></span>
                            <span><i class="fas fa-calendar"></i> Date: <strong>${date}</strong></span>
                        </div>
                    </div>
                    <div class="header-right">
                        <a href="${pageContext.request.contextPath}/dealers/view-dealer/${dealer.id}" class="btn-purchase-header">
                            <i class="fas fa-arrow-left"></i> Back to Dealer
                        </a>
                    </div>
                </div>

                <!-- Dealer Info Compact - Aligned with DealerInfo Entity -->
                <div class="dealer-info-compact">
                    <div class="dealer-info-item">
                        <span class="dealer-info-label">Dealer Name</span>
                        <span class="dealer-info-value">${dealer.dealerName}</span>
                    </div>
                    <div class="dealer-info-item">
                        <span class="dealer-info-label">Mobile</span>
                        <span class="dealer-info-value">${dealer.mobileNo}</span>
                    </div>
                    <div class="dealer-info-item">
                        <span class="dealer-info-label">GST Number</span>
                        <span class="dealer-info-value">${not empty dealer.gstNo ? dealer.gstNo : 'N/A'}</span>
                    </div>
                    <div class="dealer-info-item">
                        <span class="dealer-info-label">Total Amount</span>
                        <span class="dealer-info-value" style="color: var(--primary-color);">₹<fmt:formatNumber value="${dealer.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>
                    <div class="dealer-info-item">
                        <span class="dealer-info-label">Paid Amount</span>
                        <span class="dealer-info-value" style="color: var(--success-color);">₹<fmt:formatNumber value="${dealer.paidAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>
                    <div class="dealer-info-item">
                        <span class="dealer-info-label">Balance Amount</span>
                        <span class="dealer-info-value" style="color: var(--danger-color);">₹<fmt:formatNumber value="${dealer.balanceAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>
                </div>
            </div>

            <!-- Summary Stats -->
            <div class="purchase-summary-grid">
                <div class="purchase-stat-card total">
                    <div class="purchase-stat-label">Total Amount</div>
                    <div class="purchase-stat-value">₹<span id="totalAmount">0.00</span></div>
                </div>
                <div class="purchase-stat-card items">
                    <div class="purchase-stat-label">Total Items</div>
                    <div class="purchase-stat-value"><span id="totalItems">0</span></div>
                </div>
                <div class="purchase-stat-card tax">
                    <div class="purchase-stat-label">Total GST</div>
                    <div class="purchase-stat-value">₹<span id="totalGst">0.00</span></div>
                </div>
            </div>

            <!-- Alert Container -->
            <div id="alertContainer"></div>

            <!-- Add Product Form -->
            <div class="content-card">
                <div class="section-title">
                    <i class="fas fa-plus-circle"></i>
                    <span>Add Product to Purchase</span>
                </div>

                <form id="addProductForm">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="dealerId" value="${dealer.id}">
                    <input type="hidden" name="purchaseNo" value="${purchaseNo}">
                    <input type="hidden" name="productId" id="productId">
                    <input type="hidden" name="productName" id="productName">

                    <!-- Row 1: Basic Product Details -->
                    <div class="row g-3">
                        <div class="col-md-1">
                            <label class="form-label">Item#</label>
                            <input type="text" class="form-control text-center" name="itemNo" id="itemNo" readonly value="${itemNo}">
                        </div>

                        <div class="col-md-5">
                            <label class="form-label"><i class="fas fa-box"></i> Product</label>
                            <select id="productDropdown" class="form-control" style="width:100%"></select>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label"><i class="fas fa-barcode"></i> Batch No</label>
                            <input type="text" class="form-control" name="batchNo" id="batchNo" required>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label"><i class="fas fa-calendar-alt"></i> Expiry Date</label>
                            <input type="date" class="form-control" name="expDate" id="expDate" required>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label"><i class="fas fa-tag"></i> MRP</label>
                            <input type="number" step="0.01" min="0" class="form-control text-end" name="mrp" id="mrp" required>
                        </div>
                    </div>

                    <!-- Row 2: Quantity, Rates, GST, and Total -->
                    <div class="row g-3 mt-2">
                        <div class="col-md-2">
                            <label class="form-label"><i class="fas fa-cubes"></i> Quantity</label>
                            <div class="purchase-qty-wrapper">
                                <button class="purchase-qty-btn" type="button" onclick="changeQty(-1)">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <input type="number" class="form-control purchase-qty-input" name="quantity" id="quantity" value="1" min="1" onchange="calculateAmount()">
                                <button class="purchase-qty-btn" type="button" onclick="changeQty(1)">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label"><i class="fas fa-rupee-sign"></i> Purchase Rate</label>
                            <input type="number" step="0.01" min="0" class="form-control text-end" name="rate" id="rate" required onchange="calculateAmount()">
                        </div>

                        <div class="col-md-2">
                            <label class="form-label"><i class="fas fa-rupee-sign"></i> Selling Rate</label>
                            <input type="number" step="0.01" min="0" class="form-control text-end" name="sellingRate" id="sellingRate" required>
                        </div>

                        <div class="col-md-1">
                            <label class="form-label"><i class="fas fa-percent"></i> GST %</label>
                            <input type="number" step="0.01" min="0" max="100" class="form-control text-end" name="gstPercent" id="gstPercent" value="0" onchange="calculateAmount()">
                        </div>

                        <div class="col-md-2">
                            <label class="form-label"><i class="fas fa-calculator"></i> Total Amount</label>
                            <input type="text" class="form-control text-end fw-bold" name="amount" id="amount" readonly style="color: var(--primary-color);">
                        </div>

                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-plus"></i> Add Product
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Items Table -->
            <div class="content-card">
                <div class="section-title">
                    <i class="fas fa-list"></i>
                    <span>Purchase Items</span>
                </div>

                <div class="purchase-table-wrapper">
                    <table class="purchase-modern-table table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Product</th>
                                <th>Batch</th>
                                <th>Exp Date</th>
                                <th class="text-center">Qty</th>
                                <th class="text-end">MRP</th>
                                <th class="text-end">P. Rate</th>
                                <th class="text-end">S. Rate</th>
                                <th class="text-end">GST %</th>
                                <th class="text-end">GST Amt</th>
                                <th class="text-end">Total</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody id="itemsTableBody">
                            <c:choose>
                                <c:when test="${empty purchaseItems}">
                                    <tr>
                                        <td colspan="12" class="empty-state">
                                            <i class="fas fa-inbox"></i>
                                            <p class="mb-0">No products added yet. Start adding products above.</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${purchaseItems}" var="item" varStatus="status">
                                        <tr id="item-${item.id}">
                                            <td>${item.itemNo}</td>
                                            <td><strong>${item.productName}</strong></td>
                                            <td><span class="badge bg-secondary">${item.batchNo}</span></td>
                                            <td><fmt:formatDate value="${item.expDate}" pattern="dd-MMM-yyyy"/></td>
                                            <td class="text-center">${item.quantity}</td>
                                            <td class="text-end">₹<fmt:formatNumber value="${item.mrp}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td class="text-end">₹<fmt:formatNumber value="${item.rate}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td class="text-end">₹<fmt:formatNumber value="${item.sellingRate}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td class="text-end"><fmt:formatNumber value="${item.gstPercent}" type="number" minFractionDigits="2" maxFractionDigits="2"/>%</td>
                                            <td class="text-end">₹<fmt:formatNumber value="${item.gstAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                                            <td class="text-end"><strong style="color: var(--primary-color);">₹<fmt:formatNumber value="${item.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/></strong></td>
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
            </div>

            <!-- Final Actions -->
            <div class="content-card">
                <div class="section-title">
                    <i class="fas fa-file-invoice"></i>
                    <span>Invoice Details</span>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/dealers/save-purchase">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="dealerId" value="${dealer.id}">
                    <input type="hidden" name="purchaseNo" value="${purchaseNo}">
                    <input type="hidden" id="totalAmountHidden" name="totalAmount" value="0">
                    <input type="hidden" id="totalGstHidden" name="totalGst" value="0">
                    <input type="hidden" id="totalItemsHidden" name="totalItems" value="0">

                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <label class="form-label">
                                <i class="fas fa-file-invoice"></i> Dealer Invoice Number
                            </label>
                            <input type="text" class="form-control" value="${purchaseNo}" name="dealerInvoiceNo" readonly>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">
                                <i class="fas fa-calendar"></i> Invoice Date
                            </label>
                            <input type="date" class="form-control" name="invoiceDate" value="${date}" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">
                                <i class="fas fa-info-circle"></i> Status
                            </label>
                            <input type="text" class="form-control" value="${dealer.status}" readonly>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label">
                                <i class="fas fa-sticky-note"></i> Notes (Optional)
                            </label>
                            <textarea class="form-control" name="notes" rows="3" placeholder="Add any additional notes about this purchase..."></textarea>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-3">
                        <button type="button" onclick="location.reload();" class="btn btn-outline-secondary">
                            <i class="fas fa-sync-alt"></i> Reset
                        </button>
                        <button type="submit" class="btn btn-success" id="savePurchaseBtn" ${empty purchaseItems ? 'disabled' : ''}>
                            <i class="fas fa-save"></i> Save Purchase Entry
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </main>

    <jsp:include page="../view/footer.jsp"></jsp:include>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

<script>
    let currentItemNo = parseInt('<c:out value="${itemNo}" default="0"/>') || 0;

    // Calculate total amount including GST
    function calculateAmount() {
        const qty = parseFloat($('#quantity').val()) || 0;
        const rate = parseFloat($('#rate').val()) || 0;
        const gstPercent = parseFloat($('#gstPercent').val()) || 0;

        const baseAmount = qty * rate;
        const gstAmount = (baseAmount * gstPercent) / 100;
        const totalAmount = baseAmount + gstAmount;

        $('#amount').val(totalAmount.toFixed(2));
    }

    // Change quantity with + and - buttons
    function changeQty(val) {
        let qtyInput = $('#quantity');
        let current = parseInt(qtyInput.val()) || 0;
        current += val;
        if (current < 1) current = 1;
        qtyInput.val(current);
        calculateAmount();
    }

    // Show alert messages
    function showAlert(message, type) {
        const iconMap = {
            'success': 'check-circle',
            'danger': 'exclamation-circle',
            'warning': 'exclamation-triangle',
            'info': 'info-circle'
        };

        const icon = iconMap[type] || 'info-circle';

        const alertHtml = `
            <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                <i class="fas fa-${icon}"></i>
                <div>
                    <strong>${message}</strong>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;

        $('#alertContainer').html(alertHtml);

        // Auto-dismiss after 5 seconds
        setTimeout(() => {
            $('.alert').fadeOut('slow', function() {
                $(this).remove();
            });
        }, 5000);
    }

    // Update summary totals
    function updateTotals() {
        let totalAmount = 0;
        let totalGst = 0;
        let totalItems = 0;

        $('#itemsTableBody tr').each(function() {
            if (!$(this).find('.empty-state').length) {
                // Extract amount text and parse
                const amountText = $(this).find('td:eq(10)').text().replace('₹', '').replace(',', '').trim();
                const gstText = $(this).find('td:eq(9)').text().replace('₹', '').replace(',', '').trim();

                const amount = parseFloat(amountText) || 0;
                const gst = parseFloat(gstText) || 0;

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

        // Enable/disable save button based on items
        $('#savePurchaseBtn').prop('disabled', totalItems === 0);
    }

    // Delete item from purchase
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

                        // Check if table is empty
                        if ($('#itemsTableBody tr:visible').length === 0) {
                            $('#itemsTableBody').html(`
                                <tr>
                                    <td colspan="12" class="empty-state">
                                        <i class="fas fa-inbox"></i>
                                        <p class="mb-0">No products added yet. Start adding products above.</p>
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
            error: function(xhr, status, error) {
                console.error('Error deleting item:', error);
                showAlert('Error occurred while deleting item. Please try again.', 'danger');
            }
        });
    }

    // Format number for display
    function formatNumber(num) {
        return parseFloat(num).toFixed(2);
    }

    // Document ready
    $(document).ready(function() {
        // Initialize Select2 for product search
        $('#productDropdown').select2({
            placeholder: 'Search and select a product...',
            allowClear: true,
            minimumInputLength: 2,
            ajax: {
                url: '${pageContext.request.contextPath}/company/search-product',
                dataType: 'json',
                delay: 300,
                data: function(params) {
                    return {
                        query: params.term,
                        page: params.page || 1
                    };
                },
                processResults: function(data, params) {
                    params.page = params.page || 1;

                    return {
                        results: $.map(data, function(item) {
                            return {
                                id: item.productId,
                                productId: item.productId,
                                productName: item.productName,
                                gstPercent: item.taxPercentage || 0,
                                price: item.price || 0,
                                mrp: item.mrp || 0,
                                batchNo: item.batchNo || '',
                                expDate: item.expDate || '',
                                stock: item.stock || 0,
                                text: `
                                    <div style='padding: 8px 0;'>
                                        <div style='margin-bottom: 6px;'>
                                            <strong style='color: #1f2937; font-size: 1rem;'>
                                                <i class='fas fa-box-open' style='color: #6366f1; margin-right: 6px;'></i>
                                                ${item.productName}
                                            </strong>
                                            <span style='color: #10b981; font-weight: 600; margin-left: 12px; font-size: 0.9rem;'>
                                                ₹${formatNumber(item.price)}
                                            </span>
                                            <span style='color: #6366f1; font-weight: 500; margin-left: 10px; font-size: 0.85rem;'>
                                                <i class='fas fa-layer-group' style='margin-right: 4px;'></i>Stock: ${item.stock}
                                            </span>
                                        </div>
                                        <div style='font-size: 0.8rem; color: #6b7280;'>
                                            <span>
                                                <i class='fas fa-barcode' style='margin-right: 4px;'></i>Batch: ${item.batchNo || 'N/A'}
                                            </span>
                                            <span style='margin-left: 12px;'>
                                                <i class='fas fa-calendar-alt' style='margin-right: 4px;'></i>Exp: ${item.expDate || 'N/A'}
                                            </span>
                                            <span style='margin-left: 12px; color: #f59e0b;'>
                                                <i class='fas fa-tag' style='margin-right: 4px;'></i>MRP: ₹${formatNumber(item.mrp || 0)}
                                            </span>
                                        </div>
                                    </div>
                                `
                            };
                        })
                    };
                },
                cache: true
            },
            escapeMarkup: function(markup) {
                return markup;
            },
            templateResult: function(data) {
                if (data.loading) return data.text;
                return $(data.text);
            },
            templateSelection: function(data) {
                return data.productName || data.text;
            }
        });

        // Handle product selection
        $('#productDropdown').on('select2:select', function(e) {
            const data = e.params.data;

            $('#productId').val(data.productId);
            $('#productName').val(data.productName);
            $('#rate').val(formatNumber(data.price));
            $('#mrp').val(formatNumber(data.mrp));
            $('#sellingRate').val(formatNumber(data.price));
            $('#batchNo').val(data.batchNo);
            $('#expDate').val(data.expDate);
            $('#gstPercent').val(formatNumber(data.gstPercent));

            calculateAmount();

            // Focus on batch number if empty
            if (!data.batchNo) {
                $('#batchNo').focus();
            }
        });

        // Clear form on product clear
        $('#productDropdown').on('select2:clear', function() {
            $('#productId').val('');
            $('#productName').val('');
            $('#rate').val('');
            $('#mrp').val('');
            $('#sellingRate').val('');
            $('#batchNo').val('');
            $('#expDate').val('');
            $('#gstPercent').val('0');
            $('#amount').val('');
        });

        // Add product form submission
        $('#addProductForm').on('submit', function(e) {
            e.preventDefault();

            const productId = $('#productId').val();
            const productName = $('#productName').val();

            if (!productId || !productName) {
                showAlert('Please select a product from the dropdown.', 'warning');
                return;
            }

            const batchNo = $('#batchNo').val().trim();
            const expDate = $('#expDate').val();
            const quantity = parseInt($('#quantity').val());
            const rate = parseFloat($('#rate').val());
            const mrp = parseFloat($('#mrp').val());
            const sellingRate = parseFloat($('#sellingRate').val());

            // Validation
            if (!batchNo) {
                showAlert('Please enter batch number.', 'warning');
                $('#batchNo').focus();
                return;
            }

            if (!expDate) {
                showAlert('Please enter expiry date.', 'warning');
                $('#expDate').focus();
                return;
            }

            if (!quantity || quantity < 1) {
                showAlert('Please enter valid quantity (minimum 1).', 'warning');
                $('#quantity').focus();
                return;
            }

            if (!rate || rate < 0) {
                showAlert('Please enter valid purchase rate.', 'warning');
                $('#rate').focus();
                return;
            }

            if (!mrp || mrp < 0) {
                showAlert('Please enter valid MRP.', 'warning');
                $('#mrp').focus();
                return;
            }

            if (!sellingRate || sellingRate < 0) {
                showAlert('Please enter valid selling rate.', 'warning');
                $('#sellingRate').focus();
                return;
            }

            const formData = {
                dealerId: $('input[name="dealerId"]').val(),
                purchaseNo: $('input[name="purchaseNo"]').val(),
                itemNo: $('#itemNo').val(),
                productId: productId,
                productName: productName,
                batchNo: batchNo,
                expDate: expDate,
                quantity: quantity,
                mrp: mrp,
                rate: rate,
                sellingRate: sellingRate,
                gstPercent: parseFloat($('#gstPercent').val()) || 0,
                amount: parseFloat($('#amount').val()) || 0
            };

            // Disable submit button to prevent double submission
            const submitBtn = $(this).find('button[type="submit"]');
            submitBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Adding...');

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
                                <td>${item.expDate}</td>
                                <td class="text-center">${item.quantity}</td>
                                <td class="text-end">₹${formatNumber(item.mrp)}</td>
                                <td class="text-end">₹${formatNumber(item.rate)}</td>
                                <td class="text-end">₹${formatNumber(item.sellingRate)}</td>
                                <td class="text-end">${formatNumber(item.gstPercent)}%</td>
                                <td class="text-end">₹${formatNumber(item.gstAmount)}</td>
                                <td class="text-end"><strong style="color: var(--primary-color);">₹${formatNumber(item.totalAmount)}</strong></td>
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
                        $('#gstPercent').val('0');
                        $('#quantity').val('1');

                        // Increment item number
                        currentItemNo++;
                        $('#itemNo').val(currentItemNo);

                        // Update totals
                        updateTotals();

                        // Focus back on product dropdown
                        $('#productDropdown').select2('open');
                    } else {
                        showAlert(response.message || 'Failed to add product. Please try again.', 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error adding product:', error);
                    let errorMessage = 'Error occurred while adding product.';

                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMessage = xhr.responseJSON.message;
                    }

                    showAlert(errorMessage, 'danger');
                },
                complete: function() {
                    // Re-enable submit button
                    submitBtn.prop('disabled', false).html('<i class="fas fa-plus"></i> Add Product');
                }
            });
        });

        // Initial totals calculation
        updateTotals();

        // Auto-dismiss success alert after 4 seconds
        setTimeout(function() {
            $('#success-alert').fadeOut('slow', function() {
                $(this).remove();
            });
        }, 4000);

        // Set min date for expiry date (today)
        const today = new Date().toISOString().split('T')[0];
        $('#expDate').attr('min', today);

        // Prevent negative values in number inputs
        $('input[type="number"]').on('input', function() {
            const min = parseFloat($(this).attr('min'));
            const max = parseFloat($(this).attr('max'));
            let value = parseFloat($(this).val());

            if (!isNaN(min) && value < min) {
                $(this).val(min);
            }
            if (!isNaN(max) && value > max) {
                $(this).val(max);
            }
        });
    });
</script>

</body>
</html>