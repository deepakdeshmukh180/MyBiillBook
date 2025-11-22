<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="../view/logo.jsp"></jsp:include>

<style>
/* ===================================
   CREATE INVOICE SPECIFIC STYLES
   =================================== */

/* Anti-Flicker Modal */
.modal {
    z-index: 1055 !important;
}

.modal-backdrop {
    z-index: 1050 !important;
    background-color: rgba(0, 0, 0, 0.5);
}

.modal.fade {
    transition: opacity 0.15s linear;
}

.modal.fade .modal-dialog {
    transition: transform 0.2s ease-out;
    transform: scale(0.95);
}

.modal.show .modal-dialog {
    transform: scale(1);
}
.section-header {
    background: var(--card-bg, #1e1e1e);
    padding: 15px;
    border-radius: 12px;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
    border: 1px solid rgba(255,255,255,0.06);
}

.dropdown-center {
    width: 360px;          /* keeps dropdown centered & neat */
    text-align: center;
}

.centered-dropdown {
    height: 38px;
    font-size: 0.9rem;
    text-align: center;
    padding: 5px 10px;
}


.modal-content {
    border: none;
    border-radius: var(--radius-xl);
    background: var(--card-bg);
    box-shadow: var(--shadow-xl);
    will-change: transform;
    backface-visibility: hidden;
    -webkit-font-smoothing: antialiased;
}

body.modal-open {
    overflow: hidden;
    padding-right: 0 !important;
}

/* Customer Info Cards */
.info-card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 0.75rem;
    margin-bottom: 1.5rem;
}

.info-card {
    background: var(--card-bg);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-md);
    padding: 0.875rem;
    transition: all var(--transition-base);
    border-left: 3px solid var(--primary-color);
}

.info-card:hover {
    box-shadow: var(--shadow-sm);
    transform: translateY(-2px);
}

.info-card-content {
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.info-icon {
    width: 36px;
    height: 36px;
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1rem;
    flex-shrink: 0;
}

.info-icon.user { background: var(--primary-light); color: var(--primary-color); }
.info-icon.location { background: var(--danger-light); color: var(--danger-color); }
.info-icon.phone { background: var(--success-light); color: var(--success-color); }
.info-icon.invoice { background: var(--info-light); color: var(--info-color); }

.info-details {
    flex: 1;
    min-width: 0;
}

.info-label {
    font-size: 0.7rem;
    color: var(--text-secondary);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 0.15rem;
}

.info-value {
    font-size: 0.875rem;
    font-weight: 600;
    color: var(--text-color);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* KPI Summary Cards */
.kpi-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 0.75rem;
    margin-bottom: 1.5rem;
}

.kpi-summary-card {
    text-align: center;
    padding: 1.25rem;
    border-radius: var(--radius-lg);
    color: white;
    position: relative;
    overflow: hidden;
}

.kpi-summary-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
    transition: left 0.6s;
}

.kpi-summary-card:hover::before {
    left: 100%;
}

.kpi-summary-card.total {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.kpi-summary-card.paid {
    background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
}

.kpi-summary-card.balance {
    background: linear-gradient(135deg, #ee0979 0%, #ff6a00 100%);
}

.kpi-label {
    font-size: 0.75rem;
    opacity: 0.9;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 0.5rem;
}

.kpi-value {
    font-size: 1.75rem;
    font-weight: 700;
    line-height: 1;
}

/* Add Item Section */
.add-item-section {
    background: var(--card-bg);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-lg);
    overflow: hidden;
    margin-bottom: 1.5rem;
}

.section-header {
    background: linear-gradient(90deg, var(--primary-color) 0%, var(--primary-dark) 100%);
    color: white;
    padding: 0.875rem 1.25rem;
    font-weight: 600;
    font-size: 1rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.section-body {
    padding: 1.25rem;
}

/* Form Controls */
.form-row {
    display: grid;
    grid-template-columns: repeat(12, 1fr);
    gap: 0.75rem;
    margin-bottom: 0.75rem;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-group.col-1 { grid-column: span 1; }
.form-group.col-2 { grid-column: span 2; }
.form-group.col-3 { grid-column: span 3; }
.form-group.col-4 { grid-column: span 4; }
.form-group.col-5 { grid-column: span 5; }
.form-group.col-6 { grid-column: span 6; }
.form-group.col-12 { grid-column: span 12; }

.form-label-modern {
    font-size: 0.8rem;
    font-weight: 600;
    color: var(--text-color);
    margin-bottom: 0.375rem;
    display: flex;
    align-items: center;
    gap: 0.25rem;
}

.form-control-modern,
.form-select-modern {
    background: var(--card-bg);
    border: 2px solid var(--border-color);
    border-radius: var(--radius-sm);
    padding: 0.625rem 0.875rem;
    font-size: 0.875rem;
    color: var(--text-color);
    transition: all var(--transition-fast);
}

.form-control-modern:focus,
.form-select-modern:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px var(--primary-light);
    outline: none;
}

.form-control-modern[readonly] {
    background: var(--bg-secondary);
    cursor: not-allowed;
}

/* Quantity Controls */
.qty-control {
    display: flex;
    align-items: stretch;
    gap: 0;
    height: 100%;
}

.qty-control .btn {
    padding: 0 0.75rem;
    border-radius: 0;
    font-size: 1rem;
    line-height: 1;
    min-width: 36px;
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
    width: 60px;
}

/* Items Grid */
.items-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 0.875rem;
    margin-bottom: 1.5rem;
}

.item-card-compact {
    background: var(--card-bg);
    border: 2px solid var(--border-color);
    border-radius: var(--radius-md);
    transition: all var(--transition-base);
    overflow: hidden;
    display: flex;
    flex-direction: column;
}

.item-card-compact:hover {
    border-color: var(--primary-color);
    box-shadow: var(--shadow-md);
    transform: translateY(-3px);
}

.item-card-body {
    padding: 0.875rem;
    flex: 1;
}

.item-title {
    font-size: 0.875rem;
    font-weight: 600;
    color: var(--text-color);
    margin-bottom: 0.5rem;
    line-height: 1.2;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.item-detail {
    font-size: 0.7rem;
    color: var(--text-secondary);
    margin-bottom: 0.25rem;
    display: flex;
    align-items: center;
    gap: 0.375rem;
}

.item-detail i {
    width: 14px;
    font-size: 0.7rem;
}

.item-total {
    font-size: 0.9rem;
    font-weight: 700;
    color: var(--primary-color);
    margin-top: 0.625rem;
    padding-top: 0.625rem;
    border-top: 1px solid var(--border-color);
    display: flex;
    align-items: center;
    gap: 0.25rem;
}

.item-card-footer {
    padding: 0.5rem;
    background: var(--bg-secondary);
    border-top: 1px solid var(--border-color);
    text-align: right;
}

/* Empty State */
.empty-state {
    text-align: center;
    padding: 3rem 1rem;
    color: var(--text-secondary);
    grid-column: 1 / -1;
}

.empty-state i {
    font-size: 3rem;
    margin-bottom: 1rem;
    opacity: 0.3;
}

/* Invoice Summary */
.invoice-summary-section {
    background: var(--card-bg);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-lg);
    overflow: hidden;
    margin-bottom: 1.5rem;
}

.summary-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
    gap: 0.75rem;
    margin-bottom: 1rem;
}

.summary-item {
    background: var(--bg-secondary);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-sm);
    padding: 0.75rem;
    text-align: center;
}

.summary-label {
    font-size: 0.75rem;
    color: var(--text-secondary);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 0.25rem;
}

.summary-value {
    font-size: 1rem;
    font-weight: 700;
    color: var(--text-color);
}

/* Advance Input */
.advance-group {
    display: flex;
    gap: 0;
}

.advance-group .input-group-text {
    border-radius: var(--radius-sm) 0 0 var(--radius-sm);
    border-right: none;
    background: var(--bg-secondary);
    border: 2px solid var(--border-color);
    color: var(--text-color);
    font-weight: 600;
}

.advance-group input {
    border-radius: 0;
    border-left: none;
    border-right: none;
}

.advance-group .checkbox-wrapper {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0 1rem;
    background: var(--bg-secondary);
    border: 2px solid var(--border-color);
    border-left: none;
    border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
}

/* History Tabs */
.nav-tabs-modern {
    border-bottom: 2px solid var(--border-color);
    margin-bottom: 1.5rem;
}

.nav-tabs-modern .nav-link {
    padding: 0.875rem 1.25rem;
    font-size: 0.9rem;
    font-weight: 600;
    border: none;
    color: var(--text-secondary);
    transition: all var(--transition-base);
    position: relative;
    background: transparent;
}

.nav-tabs-modern .nav-link::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 0;
    width: 100%;
    height: 2px;
    background: var(--primary-color);
    transform: scaleX(0);
    transition: transform var(--transition-base);
}

.nav-tabs-modern .nav-link:hover {
    color: var(--primary-color);
}

.nav-tabs-modern .nav-link.active {
    color: var(--primary-color);
}

.nav-tabs-modern .nav-link.active::after {
    transform: scaleX(1);
}

/* Table Styles */
.table-modern {
    background: var(--card-bg);
    border-radius: var(--radius-md);
    overflow: hidden;
}

.table-modern thead {
    background: linear-gradient(135deg, #475569, #334155);
    color: white;
}

.table-modern thead th {
    padding: 0.875rem;
    font-weight: 600;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border: none;
}

.table-modern tbody tr {
    transition: background var(--transition-fast);
    border-bottom: 1px solid var(--border-color);
}

.table-modern tbody tr:hover {
    background: var(--primary-light);
}

.table-modern tbody td {
    padding: 0.875rem;
    color: var(--text-color);
    vertical-align: middle;
}

/* Button Styles */
.btn-compact {
    padding: 0.625rem 1.25rem;
    font-size: 0.875rem;
    border-radius: var(--radius-md);
    font-weight: 600;
    transition: all var(--transition-base);
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
}

.btn-icon-sm {
    padding: 0.375rem 0.625rem;
    font-size: 0.75rem;
}

.btn-loading {
    position: relative;
    color: transparent !important;
    pointer-events: none;
}

.btn-loading::after {
    content: '';
    position: absolute;
    width: 16px;
    height: 16px;
    top: 50%;
    left: 50%;
    margin-left: -8px;
    margin-top: -8px;
    border: 2px solid currentColor;
    border-radius: 50%;
    border-top-color: transparent;
    animation: spinner 0.6s linear infinite;
}

@keyframes spinner {
    to { transform: rotate(360deg); }
}

/* Alert Styles */
.alert-modern {
    padding: 1rem 1.25rem;
    margin-bottom: 1rem;
    border-radius: var(--radius-md);
    font-size: 0.875rem;
    border: none;
    border-left: 4px solid;
    animation: slideInDown 0.3s ease-out;
}

.alert-modern.alert-success {
    background: var(--success-light);
    border-left-color: var(--success-color);
    color: var(--success-color);
}



.alert-modern.alert-warning {
    background: var(--warning-light);
    border-left-color: var(--warning-color);
    color: #92400e;
}

.alert-modern.alert-danger {
    background: var(--danger-light);
    border-left-color: var(--danger-color);
    color: var(--danger-color);
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

/* Responsive */
@media (max-width: 768px) {
    .form-row {
        grid-template-columns: 1fr;
    }

    .form-group.col-1,
    .form-group.col-2,
    .form-group.col-3,
    .form-group.col-4,
    .form-group.col-5,
    .form-group.col-6 {
        grid-column: span 1;
    }

    .kpi-grid {
        grid-template-columns: 1fr;
    }

    .info-card-grid {
        grid-template-columns: 1fr;
    }

    .items-grid {
        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    }

    .summary-grid {
        grid-template-columns: 1fr;
    }

    .kpi-value {
        font-size: 1.5rem;
    }
}

@media (max-width: 480px) {
    .items-grid {
        grid-template-columns: 1fr;
    }
}
</style>

<!-- Main Content -->
<div id="layoutSidenav_content">
    <main>
        <div class="container-fluid px-3 py-3">
 <div id="pageLoader"
                   style="display:none; position:fixed; z-index:9999; top:0; left:0; width:100%; height:100%;
                   background:rgba(0,0,0,0.4); backdrop-filter: blur(2px);">

                  <div style="position:absolute; top:50%; left:50%; transform:translate(-50%, -50%);
                       padding:20px; background:white; border-radius:8px; font-weight:bold;">
                       Loading...
                  </div>
              </div>
            <!-- Customer Info Cards -->
            <div class="info-card-grid">
                <div class="info-card">
                    <div class="info-card-content">
                        <div class="info-icon user">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="info-details">
                            <div class="info-label">Customer</div>
                            <div class="info-value">${profile.custName}</div>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-content">
                        <div class="info-icon location">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="info-details">
                            <div class="info-label">Address</div>
                            <div class="info-value">${profile.address}</div>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-content">
                        <div class="info-icon phone">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="info-details">
                            <div class="info-label">Mobile</div>
                            <div class="info-value">${profile.phoneNo}</div>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-card-content">
                        <div class="info-icon invoice">
                            <i class="fas fa-file-invoice"></i>
                        </div>
                        <div class="info-details">
                            <div class="info-label">Invoice</div>
                            <div class="info-value">${invoiceNo}</div>
                            <small style="font-size: 0.65rem; color: var(--text-secondary);">${date}</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- KPI Summary -->
            <div class="kpi-grid">
                <div class="kpi-summary-card total">
                    <div class="kpi-label">Total Amount</div>
                    <div class="kpi-value">₹${profile.totalAmount}</div>
                </div>
                <div class="kpi-summary-card paid">
                    <div class="kpi-label">Paid Amount</div>
                    <div class="kpi-value">₹${profile.paidAmout}</div>
                </div>
                <div class="kpi-summary-card balance">
                    <div class="kpi-label">Balance Due</div>
                    <div class="kpi-value">₹${profile.currentOusting}</div>
                </div>
            </div>

            <!-- Add Item Section -->
            <div class="add-item-section">
               <div class="section-header d-flex flex-column align-items-center mb-3">

                   <!-- Title Row -->
                   <div class="d-flex align-items-center mb-2">
                       <i class="fas fa-plus-circle me-2"></i>
                       <span>Add Item to Invoice</span>
                   </div>

                   <!-- Product Dropdown Centered -->
                   <div class="form-group dropdown-center">
                       <select id="productDropdown" class="form-control-modern centered-dropdown"></select>
                   </div>

               </div>





               <div class="section-body">
                   <form id="addItemForm" class="d-flex flex-wrap align-items-end gap-3">

                       <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                       <input type="hidden" name="custId" value="${profile.id}">
                       <input type="hidden" name="productId" id="productId" required>
                       <input type="hidden" name="invoiceNo" value="${invoiceNo}">

                       <!-- Product First -->


                 <!-- Item No -->
                       <div class="form-group">
                           <label class="form-label-modern">Item#</label>
                           <input type="text" class="form-control-modern text-center" name="itemNo" id="itemNo" readonly value="${itemsNo}">
                       </div>
                       <!-- Description moved to product place -->
                       <div class="form-group flex-grow-1">
                           <label class="form-label-modern"><i class="fas fa-align-left"></i> Description</label>
                           <input type="text" class="form-control-modern" name="description" id="description" required>
                       </div>



                       <!-- Rate -->
                       <div class="form-group">
                           <label class="form-label-modern"><i class="fas fa-rupee-sign"></i> Rate</label>
                           <input type="text" class="form-control-modern text-end" name="rate" id="rate" required
                                  onkeyup="calAmt()" placeholder="0.00"
                                  oninput="this.value=this.value.replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');">
                       </div>

                       <!-- Qty -->
                       <div class="form-group">
                           <label class="form-label-modern"><i class="fas fa-sort-numeric-up"></i> Qty</label>
                           <div class="qty-control d-flex">
                               <button class="btn btn-outline-secondary" type="button" onclick="changeQty(-1)">
                                   <i class="fas fa-minus"></i>
                               </button>
                               <input type="text" class="form-control-modern text-center" name="qty" id="qty" value="1" onkeyup="calAmt()" required style="width:60px;">
                               <button class="btn btn-outline-secondary" type="button" onclick="changeQty(1)">
                                   <i class="fas fa-plus"></i>
                               </button>
                           </div>
                       </div>

                       <!-- Amount -->
                       <div class="form-group">
                           <label class="form-label-modern"><i class="fas fa-calculator"></i> Amount</label>
                           <input type="text" class="form-control-modern text-end fw-bold" name="amount" id="amount" readonly placeholder="0.00" style="color: var(--primary-color);">
                       </div>

                       <!-- Add Button -->
                       <div>
                           <button type="submit" class="btn btn-primary btn-compact" id="addItemBtn">
                               <i class="fa fa-plus"></i> Add
                           </button>
                       </div>

                   </form>
               </div>



            <!-- Alerts Container -->
            <div id="alertContainer"></div>

            <!-- Items Grid -->
            <div class="items-grid" id="itemsContainer">
                <c:choose>
                    <c:when test="${empty items}">
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <p class="mb-0">No items added yet. Start adding products to create an invoice.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${items}" var="item">
                            <div id="item-${item.id}">
                                <div class="item-card-compact">
                                    <div class="item-card-body">
                                        <div class="item-title">#${item.itemNo} ${item.description}</div>
                                        <div class="item-detail">
                                            <i class="fas fa-barcode text-secondary"></i>
                                            <span>Batch: ${item.batchNo}</span>
                                        </div>
                                        <div class="item-detail">
                                            <i class="fas fa-cubes text-info"></i>
                                            <span>Qty: ${item.qty}</span>
                                        </div>
                                        <div class="item-detail">
                                            <i class="fas fa-tags text-success"></i>
                                            <span>MRP: ₹${item.mrp}</span>
                                        </div>
                                        <div class="item-detail">
                                            <i class="fas fa-rupee-sign text-primary"></i>
                                            <span>Rate: ₹${item.rate}</span>
                                        </div>
                                        <div class="item-total">
                                            <i class="fas fa-wallet"></i>₹${item.amount}
                                        </div>
                                    </div>
                                    <div class="item-card-footer">
                                        <button type="button" class="btn btn-danger btn-icon-sm delete-item-btn" data-id="${item.id}">
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Invoice Summary -->
            <div class="invoice-summary-section">
                <div class="section-header">
                    <i class="fas fa-receipt"></i>
                    <span>Invoice Summary</span>
                </div>
                <div class="section-body">
                    <form name="frm" method="post" action="${pageContext.request.contextPath}/company/invoice">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="invoiceId" value="${invoiceNo}" />
                        <input type="hidden" name="custId" value="${profile.id}" />
                        <input type="hidden" name="custName" value="${profile.custName}" />
                        <input type="hidden" id="totalQtyHidden" name="totQty" value="${totalQty}" />
                        <input type="hidden" name="totInvoiceAmt" id="source" value="${totalAmout}" />
                        <input type="hidden" name="totAmt" value="${profile.totalAmount}" />
                        <input type="hidden" name="balanceAmt" value="${profile.currentOusting}" />
                        <input type="hidden" id="advanAmtsend" name="advanAmt" value="0.0">
                        <input type="hidden" name="oldInvoicesFlag" value="F" />

                        <div class="summary-grid">
                            <div class="summary-item">
                                <div class="summary-label">Total Qty</div>
                                <div class="summary-value" id="totalQty">${totalQty}</div>
                            </div>
                            <div class="summary-item">
                                <div class="summary-label">Amt (A)</div>
                                <div class="summary-value">₹${preTaxAmt}</div>
                            </div>
                            <div class="summary-item">
                                <div class="summary-label">GST (B)</div>
                                <div class="summary-value">₹${totGst}</div>
                            </div>
                            <div class="summary-item">
                                <div class="summary-label">Total (A+B)</div>
                                <div class="summary-value" style="color: var(--primary-color);">
                                    ₹<span id="totalAmout">${totalAmout}</span>
                                </div>
                            </div>
                             <div class="summary-item">
                                                            <div class="summary-label">Invoice Date</div>
                                                            <div class="summary-value" style="color: var(--primary-color);">
<input type="date" name="date"   id="datePicker" class="form-control form-control-sm" style="font-size: 0.70rem; color: var(--text-secondary);" >                                                            </div>
                                                        </div>


                        </div>

                        <div class="form-group mt-3">
                            <label class="form-label-modern">
                                <i class="fas fa-hand-holding-usd"></i> Advance Payment
                            </label>
                            <div class="advance-group">
                                <span class="input-group-text">₹</span>
                                <input type="text" id="advanceValue" class="form-control-modern text-end"
                                       oninput="copyValue()" value="0.0" placeholder="0.00">
                                <div class="checkbox-wrapper">
                                    <input class="form-check-input" type="checkbox" id="cashCheckbox">
                                    <label class="form-check-label" for="cashCheckbox" style="font-size: 0.8rem; font-weight: 500;">
                                        Full Payment
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <button type="button" onclick="location.reload();" class="btn btn-outline-secondary btn-compact">
                                <i class="fas fa-sync-alt"></i> Refresh
                            </button>
                            <button type="button" class="btn btn-success btn-compact" data-bs-toggle="modal"
                                    data-bs-target="#confirmModal1" ${empty items ? 'disabled' : ''}>
                                <i class="fas fa-file-invoice"></i> Generate Invoice
                            </button>
                        </div>

                        <!-- Confirm Modal -->
                        <div class="modal fade" id="confirmModal1" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <i class="fas fa-check-circle me-2"></i>Confirm Invoice Generation
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="alert alert-modern alert-info">
                                            <i class="fas fa-info-circle me-2"></i>
                                            Please review the invoice details below before generating.

                                        </div>

                                        <!-- Customer Summary -->
                                        <div class="info-card-grid">
                                            <div class="info-card">
                                                <div class="info-card-content">
                                                    <div class="info-icon user">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                    <div class="info-details">
                                                        <div class="info-label">Customer</div>
                                                        <div class="info-value">${profile.custName}</div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="info-card">
                                                <div class="info-card-content">
                                                    <div class="info-icon location">
                                                        <i class="fas fa-map-marker-alt"></i>
                                                    </div>
                                                    <div class="info-details">
                                                        <div class="info-label">Address</div>
                                                        <div class="info-value">${profile.address}</div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="info-card">
                                                <div class="info-card-content">
                                                    <div class="info-icon phone">
                                                        <i class="fas fa-phone"></i>
                                                    </div>
                                                    <div class="info-details">
                                                        <div class="info-label">Mobile</div>
                                                        <div class="info-value">${profile.phoneNo}</div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="info-card">
                                                <div class="info-card-content">
                                                    <div class="info-icon invoice">
                                                        <i class="fas fa-file-invoice"></i>
                                                    </div>
                                                    <div class="info-details">
                                                        <div class="info-label">Invoice</div>
                                                        <div class="info-value">${invoiceNo}</div>


                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Items Table -->
                                        <div class="table-responsive mt-3">
                                            <table class="table table-modern">
                                                <thead>
                                                    <tr>
                                                        <th>Sr#</th>
                                                        <th>Description</th>
                                                        <th>Batch</th>
                                                        <th class="text-end">Qty</th>
                                                        <th class="text-end">MRP</th>
                                                        <th class="text-end">Rate</th>
                                                        <th class="text-end">Total</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${items}" var="item">
                                                        <tr>
                                                            <td>#${item.itemNo}</td>
                                                            <td><strong>${item.description}</strong></td>
                                                            <td><span class="badge bg-secondary">${item.batchNo}</span></td>
                                                            <td class="text-end">${item.qty}</td>
                                                            <td class="text-end">₹${item.mrp}</td>
                                                            <td class="text-end"><strong>₹${item.rate}</strong></td>
                                                            <td class="text-end"><strong style="color: var(--primary-color);">₹${item.amount}</strong></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Totals -->
                                        <div class="summary-grid mt-3">
                                            <div class="summary-item">
                                                <div class="summary-label">Total Qty</div>
                                                <div class="summary-value">${totalQty}</div>
                                            </div>
                                            <div class="summary-item">
                                                <div class="summary-label">Amt (A)</div>
                                                <div class="summary-value">₹${preTaxAmt}</div>
                                            </div>
                                            <div class="summary-item">
                                                <div class="summary-label">GST (B)</div>
                                                <div class="summary-value">₹${totGst}</div>
                                            </div>
                                            <div class="summary-item">
                                                <div class="summary-label">Total</div>
                                                <div class="summary-value" style="color: var(--success-color);">₹${totalAmout}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-outline-secondary btn-compact" data-bs-dismiss="modal">
                                            <i class="fas fa-times"></i> Cancel
                                        </button>
                                        <button type="submit" class="btn btn-primary btn-compact">
                                            <i class="fas fa-check"></i> Yes, Generate Invoice
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- History Tabs -->
            <ul class="nav nav-tabs nav-tabs-modern" id="historyTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="payment-tab" data-bs-toggle="tab"
                            data-bs-target="#payment" type="button" role="tab">
                        <i class="fas fa-money-bill-wave me-1"></i>Payment History
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="invoice-tab" data-bs-toggle="tab"
                            data-bs-target="#invoice" type="button" role="tab">
                        <i class="fas fa-file-invoice me-1"></i>Invoice History
                    </button>
                </li>
            </ul>

            <div class="tab-content">
                <!-- Payment History Tab -->
                <div class="tab-pane fade show active" id="payment" role="tabpanel">
                    <div class="card-modern">
                        <c:choose>
                            <c:when test="${empty balanceDeposits}">
                                <div class="empty-state">
                                    <i class="fas fa-receipt"></i>
                                    <p class="mb-0">No payment history found.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-modern">
                                        <thead>
                                            <tr>
                                                <th><i class="fas fa-hashtag me-1"></i>Transaction ID</th>
                                                <th><i class="fas fa-user me-1"></i>Customer</th>
                                                <th><i class="fas fa-info-circle me-1"></i>Description</th>
                                                <th class="text-end"><i class="fas fa-chart-line me-1"></i>Closing</th>
                                                <th><i class="fas fa-credit-card me-1"></i>Mode</th>
                                                <th class="text-end"><i class="fas fa-rupee-sign me-1"></i>Deposited</th>
                                                <th><i class="fas fa-calendar me-1"></i>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${balanceDeposits}" var="balanceDeposit">
                                                <tr>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/company/get-bal-credit-receipt/${balanceDeposit.id}"
                                                           target="_blank" class="text-decoration-none">
                                                            <span class="badge bg-primary">
                                                                <i class="fa fa-receipt me-1"></i>${balanceDeposit.id}
                                                            </span>
                                                        </a>
                                                    </td>
                                                    <td><strong>${balanceDeposit.custName}</strong></td>
                                                    <td>${balanceDeposit.description}</td>
                                                    <td class="text-end">₹${balanceDeposit.currentOusting}</td>
                                                    <td><span class="badge bg-info">${balanceDeposit.modeOfPayment}</span></td>
                                                    <td class="text-end"><strong style="color: var(--success-color);">₹${balanceDeposit.advAmt}</strong></td>
                                                    <td>${balanceDeposit.date}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Invoice History Tab -->
                <div class="tab-pane fade" id="invoice" role="tabpanel">
                    <div class="card-modern">
                        <c:choose>
                            <c:when test="${empty oldinvoices}">
                                <div class="empty-state">
                                    <i class="fas fa-file-invoice"></i>
                                    <p class="mb-0">No invoice history found.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-modern">
                                        <thead>
                                            <tr>
                                                <th><i class="fas fa-file me-1"></i>Invoice No</th>
                                                <th class="text-end"><i class="fas fa-rupee-sign me-1"></i>Bill Amount</th>
                                                <th class="text-end"><i class="fas fa-hand-holding-usd me-1"></i>Advance</th>
                                                <th class="text-end"><i class="fas fa-balance-scale me-1"></i>Balance</th>
                                                <th><i class="fas fa-calendar me-1"></i>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${oldinvoices}" var="invoice">
                                                <tr>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}"
                                                           target="_blank" class="text-decoration-none">
                                                            <span class="badge bg-primary">
                                                                <i class="fas fa-external-link-alt me-1"></i>${invoice.invoiceId}
                                                            </span>
                                                        </a>
                                                    </td>
                                                    <td class="text-end"><strong>₹${invoice.totInvoiceAmt}</strong></td>
                                                    <td class="text-end"><span style="color: var(--success-color);">₹${invoice.advanAmt}</span></td>
                                                    <td class="text-end"><span style="color: var(--danger-color);">₹${invoice.balanceAmt}</span></td>
                                                    <td>${invoice.createdAt}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <jsp:include page="../view/footer.jsp"></jsp:include>
</div>

<!-- jQuery & Select2 (Must load before other scripts) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
// ===================================
// GLOBAL VARIABLES
// ===================================
let currentItemNo = ${itemsNo};
window.onload = function () {
    const dp = document.getElementById("datePicker");
    dp.value = new Date().toISOString().split("T")[0];
};
// ===================================
// THEME TOGGLE
// ===================================
function toggleTheme() {
    const body = document.body;
    const icon = document.getElementById('theme-icon');
    const isDark = body.getAttribute('data-theme') === 'dark';
    body.setAttribute('data-theme', isDark ? 'light' : 'dark');
    icon.classList.toggle('fa-sun', isDark);
    icon.classList.toggle('fa-moon', !isDark);
    localStorage.setItem('theme', isDark ? 'light' : 'dark');
}

// ===================================
// INITIALIZE ON LOAD
// ===================================
document.addEventListener('DOMContentLoaded', function() {
    // Apply saved theme
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.body.setAttribute('data-theme', savedTheme);
    const icon = document.getElementById('theme-icon');
    if (icon) {
        icon.classList.toggle('fa-sun', savedTheme === 'dark');
        icon.classList.toggle('fa-moon', savedTheme === 'light');
    }

    // Fix modal flickering
    const confirmModal = document.getElementById('confirmModal1');
    if (confirmModal) {
        confirmModal.addEventListener('show.bs.modal', function () {
            document.body.style.paddingRight = '0px';
        });

        confirmModal.addEventListener('shown.bs.modal', function () {
            document.body.style.overflow = 'hidden';
        });

        confirmModal.addEventListener('hide.bs.modal', function () {
            document.body.style.overflow = '';
        });

        confirmModal.addEventListener('hidden.bs.modal', function () {
            const backdrop = document.querySelector('.modal-backdrop');
            if (backdrop) backdrop.remove();
        });
    }

    // Cash checkbox functionality
    const cashCb = document.getElementById('cashCheckbox');
    if (cashCb) {
        cashCb.addEventListener('change', function() {
            const total = document.getElementById('totalAmout').textContent || "0.0";
            const advInput = document.getElementById('advanceValue');
            if (this.checked) {
                advInput.value = total;
                document.getElementById("advanAmtsend").value = total;
            } else {
                advInput.value = "0.0";
                document.getElementById("advanAmtsend").value = "0.0";
            }
        });
    }
});

// ===================================
// ALERT FUNCTIONALITY
// ===================================
function showAlert(message, type) {
    type = type || 'warning';
    var alertContainer = document.getElementById('alertContainer');
    var alertId = 'alert-' + Date.now();

    var iconClass = (type === 'success') ? 'check-circle' :
                    (type === 'danger') ? 'exclamation-circle' : 'exclamation-triangle';
    var alertTitle = (type === 'success') ? 'Success!' :
                     (type === 'danger') ? 'Error!' : 'Warning!';

    var alertHtml =
        '<div class="alert alert-modern alert-' + type + ' alert-dismissible fade show" role="alert" id="' + alertId + '">' +
            '<i class="fas fa-' + iconClass + ' me-2"></i>' +
            '<strong>' + alertTitle + '</strong> ' + message +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
        '</div>';

    // Append the alert instead of replacing content
    alertContainer.innerHTML += alertHtml;

    // Auto close after 4 seconds
    setTimeout(function() {
        var alertElement = document.getElementById(alertId);
        if (alertElement) {
            var bsAlert = bootstrap.Alert.getOrCreateInstance(alertElement);
            bsAlert.close();
        }
    }, 4000);
}


function setButtonLoading(button, isLoading) {
    if (isLoading) {
        button.classList.add('btn-loading');
        button.disabled = true;
        button.setAttribute('data-original-html', button.innerHTML);
        button.innerHTML = '';
    } else {
        button.classList.remove('btn-loading');
        button.disabled = false;
        const originalHtml = button.getAttribute('data-original-html');
        if (originalHtml) {
            button.innerHTML = originalHtml;
        }
    }
}

// ===================================
// CALCULATION FUNCTIONS
// ===================================
function copyValue() {
    var amt = document.getElementById("advanceValue").value || "0.0";
    document.getElementById("advanAmtsend").value = amt;
}

function calAmt() {
    var qty = parseFloat(document.getElementById("qty").value || 0);
    var rate = parseFloat(document.getElementById("rate").value || 0);
    var total = (qty * rate) || 0;
    document.getElementById('amount').value = total.toFixed(2);
}

function changeQty(val) {
    let qtyInput = document.getElementById("qty");
    let current = parseInt(qtyInput.value) || 0;
    current += val;
    if (current < 1) current = 1;
    qtyInput.value = current;
    calAmt();
}

// ===================================
// FORM MANAGEMENT
// ===================================
function resetAddItemForm() {
    $('#productDropdown').val(null).trigger('change');
    $('#description').val('');
    $('#productId').val('');
    $('#rate').val('');
    $('#qty').val('1');
    $('#amount').val('');
}

function appendItemCard(item) {
    // Remove empty state if it's present
    var emptyState = document.querySelector('#itemsContainer .empty-state');
    if (emptyState) {
        emptyState.remove();
    }

    var container = document.getElementById('itemsContainer');

    // Create item card
    var itemDiv = document.createElement('div');
    itemDiv.id = 'item-' + item.id;
    itemDiv.innerHTML =
        '<div class="item-card-compact">' +
            '<div class="item-card-body">' +
                '<div class="item-title">#' + item.itemNo + ' ' + item.description + '</div>' +
                '<div class="item-detail">' +
                    '<i class="fas fa-barcode text-secondary"></i>' +
                    '<span>Batch: ' + (item.batchNo || '') + '</span>' +
                '</div>' +
                '<div class="item-detail">' +
                    '<i class="fas fa-cubes text-info"></i>' +
                    '<span>Qty: ' + item.qty + '</span>' +
                '</div>' +
                '<div class="item-detail">' +
                    '<i class="fas fa-tags text-success"></i>' +
                    '<span>MRP: ₹' + (item.mrp || '') + '</span>' +
                '</div>' +
                '<div class="item-detail">' +
                    '<i class="fas fa-rupee-sign text-primary"></i>' +
                    '<span>Rate: ₹' + item.rate + '</span>' +
                '</div>' +
                '<div class="item-total">' +
                    '<i class="fas fa-wallet"></i>₹' + item.amount +
                '</div>' +
            '</div>' +
            '<div class="item-card-footer">' +
                '<button type="button" class="btn btn-danger btn-icon-sm delete-item-btn" data-id="' + item.id + '">' +
                    '<i class="fa fa-trash"></i>' +
                '</button>' +
            '</div>' +
        '</div>';

    // Append to container
    container.appendChild(itemDiv);
}


function updateInvoiceTotals(totals) {
    if (totals.totalQty !== undefined) {
        $('#totalQty').text(totals.totalQty);
        $('#totalQtyHidden').val(totals.totalQty);
    }
    if (totals.totalAmount !== undefined) {
        $('#totalAmout').text(totals.totalAmount);
        $('input[name="totInvoiceAmt"]').val(totals.totalAmount);
    }
}

// ===================================
// SELECT2 INITIALIZATION
// ===================================
$(document).ready(function () {
    $('#productDropdown').select2({
        placeholder: 'Search Product...',
        allowClear: true,
        minimumInputLength: 3,
        ajax: {
            url: '${pageContext.request.contextPath}/company/search-product',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return { query: params.term };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        return {
                            id: item.productId,
                            text:
                                "<div style='padding:6px 0;'>" +
                                    "<div style='margin-bottom:4px;'>" +
                                        "<strong style='color:#333; background-color: chartreuse; font-size:0.95rem;'>" +
                                            "<i class='fas fa-box-open' style='color:#0d6efd; margin-right:6px;'></i>" +
                                            item.productName +
                                        "</strong>" +
                                        "<span style='color:#198754; font-weight:600; margin-left:10px; font-size:0.9rem;'>₹" + item.price + "</span>" +
                                        "<span style='color:#0dcaf0; font-weight:500; margin-left:10px; font-size:0.85rem;'>" +
                                            "<i class='fas fa-layer-group' style='margin-right:4px;'></i>" + item.stock +
                                        "</span>" +
                                    "</div>" +
                                    "<div style='font-size:0.8rem;'>" +
                                        "<span style='color:#6c757d;'>" +
                                            "<i class='fas fa-barcode' style='margin-right:4px;'></i>Batch: " + item.batchNo +
                                        "</span>" +
                                        "<span style='color:#dc3545; margin-left:12px;'>" +
                                            "<i class='fas fa-calendar-alt' style='margin-right:4px;'></i>Exp: " + item.expDate +
                                        "</span>" +
                                    "</div>" +
                                "</div>",
                            productName: item.productName,
                            price: item.price,
                            productId: item.productId,
                            batchNo: item.batchNo,
                            expDate: item.expDate,
                            stock: item.stock
                        };

                    })
                };
            },
            cache: true
        },
        escapeMarkup: function (markup) {
            return markup;
        },
        templateResult: function (data) {
            return $(data.text);
        },
        templateSelection: function (data) {
            return data.productName || data.text;
        }
    });

  $('#productDropdown').on('select2:select', function (e) {
      const data = e.params.data;

      // CASE 1 — User selected from product list
      if (data.productId) {
          $('#description').val(data.productName);
          $('#productId').val(data.productId);
          $('#rate').val(data.price);
      }
      // CASE 2 — User typed a NEW product
      else {
          $('#description').val(data.text);  // typed value
          $('#productId').val("");           // no productId
          $('#rate').val("");                // clear rate
      }

      calAmt();
  });


    // ===================================
    // ADD ITEM FORM SUBMISSION
    // ===================================
    $('#addItemForm').on('submit', function(e) {
        e.preventDefault();

        const addBtn = document.getElementById('addItemBtn');
        setButtonLoading(addBtn, true);

        const productId = $('#productId').val();
        const description = $('#description').val();
        const rate = $('#rate').val();
        const qty = $('#qty').val();

        if (!productId || !description || !rate || !qty) {
            showAlert('Please fill all required fields and select a product.', 'warning');
            setButtonLoading(addBtn, false);
            return;
        }

        const formData = {
            custId: $('input[name="custId"]').val(),
            productId: productId,
            description: description,
            invoiceNo: $('input[name="invoiceNo"]').val(),
            itemNo: $('#itemNo').val(),
            rate: rate,
            qty: qty,
            amount: $('#amount').val(),
            _token: $('input[name="${_csrf.parameterName}"]').val()
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/company/add-item',
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify(formData),
            headers: {
                '${_csrf.headerName}': '${_csrf.token}'
            },
            success: function(response) {
                setButtonLoading(addBtn, false);
                  document.getElementById("pageLoader").style.display = "none";

                if (response.status === 'success') {
                    showAlert('Item added successfully!', 'success');

                    appendItemCard(response.item);
                    resetAddItemForm();

                    currentItemNo = parseInt(response.nextItemNo || response.item.itemNo) + 1;
                    $('#itemNo').val(currentItemNo);

                    if (response.totals) {
                        updateInvoiceTotals(response.totals);
                    }

                    // Enable generate button
                    const generateBtn = $('button[data-bs-target="#confirmModal1"]');
                    if (generateBtn.prop('disabled')) {
                        generateBtn.prop('disabled', false);
                    }

                } else {
                              document.getElementById("pageLoader").style.display = "none";

                    showAlert(response.message || 'Failed to add item.', 'danger');

                }
            },
            error: function(xhr, status, error) {
                setButtonLoading(addBtn, false);
                console.error('AJAX Error:', xhr.responseText);
                              document.getElementById("pageLoader").style.display = "none";

                showAlert('Error occurred while adding item. Please try again.', 'danger');
            }
        });
    });

    // ===================================
    // DELETE ITEM HANDLER
    // ===================================
    $(document).on('click', '.delete-item-btn', function(e) {
        e.preventDefault();

        const itemId = $(this).data('id');
        const deleteBtn = $(this);

        if (!confirm('Are you sure you want to delete this item?')) {
            return;
        }

        deleteBtn.prop('disabled', true);
        deleteBtn.html('<i class="fa fa-spinner fa-spin"></i>');

        $.ajax({
            url: '${pageContext.request.contextPath}/company/delete-item',
            type: 'DELETE',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({ itemId: itemId }),
            dataType: 'json',
            headers: {
                '${_csrf.headerName}': '${_csrf.token}'
            },
            success: function(response) {
                if (response.status === 'success') {
                    $('#item-' + itemId).fadeOut(300, function() {
                        $(this).remove();

                        // Check if no items left
                        if ($('#itemsContainer .item-card-compact').length === 0) {
                            $('#itemsContainer').html(`
                                <div class="empty-state">
                                    <i class="fas fa-inbox"></i>
                                    <p class="mb-0">No items added yet. Start adding products to create an invoice.</p>
                                </div>
                            `);
                            $('button[data-bs-target="#confirmModal1"]').prop('disabled', true);
                        }
                    });

                    showAlert('Item deleted successfully!', 'success');

                    let current = parseInt($('#itemNo').val()) || 0;
                    $('#itemNo').val(Math.max(1, current - 1));

                    if (response.totals) {
                        updateInvoiceTotals(response.totals);
                    }
                } else {
                    showAlert(response.message || 'Failed to delete item.', 'danger');
                    deleteBtn.prop('disabled', false).html('<i class="fa fa-trash"></i>');
                }
            },
            error: function(xhr) {
                console.error('Delete Error:', xhr.responseText);
                showAlert('Error occurred while deleting item. Please try again.', 'danger');
                deleteBtn.prop('disabled', false).html('<i class="fa fa-trash"></i>');
            }
        });
    });
});
</script>

</body>
</html>