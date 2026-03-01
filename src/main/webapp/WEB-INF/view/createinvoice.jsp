<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="../view/logo.jsp"></jsp:include>

<style>
/* Base Variables */
:root {
    --primary: #0d6efd;
    --success: #198754;
    --danger: #dc3545;
    --warning: #ffc107;
    --info: #0dcaf0;
    --border: #dee2e6;
    --bg-light: #f8f9fa;
    --shadow: 0 2px 4px rgba(0,0,0,0.1);
}

/* Modal Fix */
.modal { z-index: 1055 !important; }
.modal-backdrop { z-index: 1050 !important; }
body.modal-open { overflow: hidden; padding-right: 0 !important; }

/* Card Styles */
.info-card {
    background: white;
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 1rem;
    margin-bottom: 1rem;
    border-left: 3px solid var(--primary);
}

.kpi-card {
    text-align: center;
    padding: 1.5rem;
    border-radius: 8px;
    color: white;
    margin-bottom: 1rem;
}

.kpi-card.total { background: linear-gradient(135deg, #667eea, #764ba2); }
.kpi-card.paid { background: linear-gradient(135deg, #11998e, #38ef7d); }
.kpi-card.balance { background: linear-gradient(135deg, #ee0979, #ff6a00); }

/* Form Section */
.section-box {
    background: white;
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 1.5rem;
    margin-bottom: 1rem;
}

.section-title {
    background: var(--primary);
    color: white;
    padding: 0.75rem 1rem;
    margin: -1.5rem -1.5rem 1rem;
    border-radius: 8px 8px 0 0;
    font-weight: 600;
}

/* Form Controls */
.form-label { font-weight: 600; font-size: 0.875rem; margin-bottom: 0.5rem; }
.form-control, .form-select {
    border: 2px solid var(--border);
    border-radius: 6px;
    padding: 0.625rem;
}
.form-control:focus, .form-select:focus {
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
}

/* Quantity Controls */
.qty-control { display: flex; gap: 0; }
.qty-control .btn {
    padding: 0.625rem 1rem;
    border-radius: 0;
    border: 2px solid var(--border);
}
.qty-control .btn:first-child { border-radius: 6px 0 0 6px; border-right: none; }
.qty-control .btn:last-child { border-radius: 0 6px 6px 0; border-left: none; }
.qty-control input { text-align: center; border-left: none; border-right: none; width: 70px; }

/* Items Grid */
.items-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 1rem;
    margin-bottom: 1rem;
}

.item-card {
    background: white;
    border: 2px solid var(--border);
    border-radius: 8px;
    overflow: hidden;
    transition: all 0.2s;
}

.item-card:hover {
    border-color: var(--primary);
    box-shadow: var(--shadow);
    transform: translateY(-2px);
}

.item-body { padding: 1rem; }
.item-title { font-weight: 600; margin-bottom: 0.5rem; }
.item-detail { font-size: 0.8rem; color: #6c757d; margin-bottom: 0.25rem; }
.item-total {
    font-weight: 700;
    color: var(--primary);
    margin-top: 0.5rem;
    padding-top: 0.5rem;
    border-top: 1px solid var(--border);
}
.item-footer {
    padding: 0.5rem;
    background: var(--bg-light);
    text-align: right;
}

/* Empty State */
.empty-state {
    text-align: center;
    padding: 3rem 1rem;
    color: #6c757d;
    grid-column: 1 / -1;
}
.empty-state i { font-size: 3rem; opacity: 0.3; margin-bottom: 1rem; }

/* Tables */
.table-simple { width: 100%; margin-bottom: 1rem; }
.table-simple thead { background: #475569; color: white; }
.table-simple th, .table-simple td { padding: 0.75rem; border-bottom: 1px solid var(--border); }
.table-simple tbody tr:hover { background: var(--bg-light); }

/* Alerts */
.alert-box {
    padding: 1rem;
    margin-bottom: 1rem;
    border-radius: 6px;
    border-left: 4px solid;
}
.alert-success { background: #d1e7dd; border-color: var(--success); color: var(--success); }
.alert-danger { background: #f8d7da; border-color: var(--danger); color: var(--danger); }
.alert-warning { background: #fff3cd; border-color: var(--warning); color: #856404; }

/* Utilities */
.text-end { text-align: right; }
.text-center { text-align: center; }
.fw-bold { font-weight: 700; }
.mb-1 { margin-bottom: 0.5rem; }
.mb-2 { margin-bottom: 1rem; }
.mb-3 { margin-bottom: 1.5rem; }
.d-flex { display: flex; }
.gap-2 { gap: 1rem; }
.justify-end { justify-content: flex-end; }
.align-center { align-items: center; }

/* Responsive */
@media (max-width: 768px) {
    .items-grid { grid-template-columns: 1fr; }
}
</style>

<body>

<div id="layoutSidenav_content">
    <main>
        <div class="container-fluid px-3 py-3">

            <!-- Loader -->
            <div id="pageLoader" style="display:none; position:fixed; z-index:9999; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5);">
                <div style="position:absolute; top:50%; left:50%; transform:translate(-50%, -50%); padding:20px; background:white; border-radius:8px; font-weight:bold;">
                    Loading...
                </div>
            </div>

            <!-- Customer Info -->
            <div class="row">
                <div class="col-md-3">
                    <div class="info-card">
                        <i class="fas fa-user text-primary"></i> <strong>Customer</strong><br>
                        <span>${profile.custName}</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="info-card">
                        <i class="fas fa-map-marker-alt text-danger"></i> <strong>Address</strong><br>
                        <span>${profile.address}</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="info-card">
                        <i class="fas fa-phone text-success"></i> <strong>Mobile</strong><br>
                        <span>${profile.phoneNo}</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="info-card">
                        <i class="fas fa-file-invoice text-info"></i> <strong>Invoice</strong><br>
                        <span>${invoiceNo}</span>
                    </div>
                </div>
            </div>

            <!-- KPI Summary -->
            <div class="row">
                <div class="col-md-4">
                    <div class="kpi-card total">
                        <div style="font-size: 0.875rem; opacity: 0.9;">Total Amount</div>
                        <div style="font-size: 2rem; font-weight: 700;">₹${profile.totalAmount}</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="kpi-card paid">
                        <div style="font-size: 0.875rem; opacity: 0.9;">Paid Amount</div>
                        <div style="font-size: 2rem; font-weight: 700;">₹${profile.paidAmout}</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="kpi-card balance">
                        <div style="font-size: 0.875rem; opacity: 0.9;">Balance Due</div>
                        <div style="font-size: 2rem; font-weight: 700;">₹${profile.currentOusting}</div>
                    </div>
                </div>
            </div>

            <!-- Add Item Section -->
            <div class="section-box">
                <div class="section-title">
                    <i class="fas fa-plus-circle"></i> Add Item to Invoice
                </div>

                <div class="mb-3">
                    <label class="form-label">Search Product</label>
                    <select id="productDropdown" class="form-select"></select>
                </div>

                <form id="addItemForm" class="row g-3">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="custId" value="${profile.id}">
                    <input type="hidden" name="productId" id="productId">
                    <input type="hidden" name="invoiceNo" value="${invoiceNo}">

                    <div class="col-md-1">
                        <label class="form-label">Item#</label>
                        <input type="text" class="form-control text-center" id="itemNo" readonly value="${itemsNo}">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Description</label>
                        <input type="text" class="form-control" id="description" required>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">Rate</label>
                        <input type="text" class="form-control text-end" id="rate" required>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">Quantity</label>
                        <div class="qty-control">
                            <button class="btn btn-outline-secondary" type="button" id="qtyMinus">-</button>
                            <input type="text" class="form-control" id="qty" value="1" required>
                            <button class="btn btn-outline-secondary" type="button" id="qtyPlus">+</button>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">Amount</label>
                        <input type="text" class="form-control text-end fw-bold" id="amount" readonly>
                    </div>

                    <div class="col-md-1">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" class="btn btn-primary w-100" id="addItemBtn">
                            <i class="fa fa-plus"></i> Add
                        </button>
                    </div>
                </form>
            </div>

            <!-- Alerts -->
            <div id="alertContainer"></div>

            <!-- Items Grid -->
            <div class="items-grid" id="itemsContainer">
                <c:choose>
                    <c:when test="${empty items}">
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <p>No items added yet</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${items}" var="item">
                            <div id="item-${item.id}" class="item-card">
                                <div class="item-body">
                                    <div class="item-title">#${item.itemNo} ${item.description}</div>
                                    <div class="item-detail"><i class="fas fa-barcode"></i> Batch: ${item.batchNo}</div>
                                    <div class="item-detail"><i class="fas fa-cubes"></i> Qty: ${item.qty}</div>
                                    <div class="item-detail"><i class="fas fa-tags"></i> MRP: ₹${item.mrp}</div>
                                    <div class="item-detail"><i class="fas fa-rupee-sign"></i> Rate: ₹${item.rate}</div>
                                    <div class="item-total">₹${item.amount}</div>
                                </div>
                                <div class="item-footer">
                                    <button type="button" class="btn btn-danger btn-sm delete-item-btn" data-id="${item.id}">
                                        <i class="fa fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Invoice Summary -->
            <div class="section-box">
                <div class="section-title">
                    <i class="fas fa-receipt"></i> Invoice Summary
                </div>

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

                    <div class="row mb-3">
                        <div class="col-md-2 text-center">
                            <div class="fw-bold">Total Qty</div>
                            <div id="totalQty">${totalQty}</div>
                        </div>
                        <div class="col-md-2 text-center">
                            <div class="fw-bold">Amt (A)</div>
                            <div id="preTaxAmt">₹${preTaxAmt}</div>
                        </div>
                        <div class="col-md-2 text-center">
                            <div class="fw-bold">GST (B)</div>
                            <div id="totGst">₹${totGst}</div>
                        </div>
                        <div class="col-md-2 text-center">
                            <div class="fw-bold">Total</div>
                            <div id="totalAmt" style="color: var(--success);">₹${totalAmout}</div>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Invoice Date</label>
                            <input type="date" name="date" id="datePicker" class="form-control">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-5">
                            <label class="form-label">Advance Payment</label>
                            <div class="input-group">
                                <span class="input-group-text">₹</span>
                                <input type="text" id="advanceValue" class="form-control" value="0.0">
                                <div class="input-group-text">
                                    <input class="form-check-input me-2" type="checkbox" id="cashCheckbox">
                                    <label class="form-check-label" for="cashCheckbox">Full Payment</label>
                                </div>
                            </div>
                        </div>
                         <div class="col-md-3"></div>
                        <div class="col-md-4">
                                                    <label class="form-label">Generate Invoice</label>
                                                    <div class="input-group">
                                                     <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#confirmModal" ${empty items ? 'disabled' : ''}>
                                                                               <i class="fas fa-file-invoice"></i> Generate Invoice
                                                                           </button>
                                                    </div>
                                                </div>
                    </div>



                    <!-- Confirm Modal -->
                    <div class="modal fade" id="confirmModal" tabindex="-1">
                        <div class="modal-dialog modal-xl">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Confirm Invoice</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <table class="table-simple">
                                        <thead>
                                            <tr>
                                                <th>Sr#</th>
                                                <th>Description</th>
                                                <th>Batch</th>
                                                <th class="text-end">Qty</th>
                                                <th class="text-end">Rate</th>
                                                <th class="text-end">Total</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${items}" var="item">
                                                <tr>
                                                    <td>#${item.itemNo}</td>
                                                    <td>${item.description}</td>
                                                    <td>${item.batchNo}</td>
                                                    <td class="text-end">${item.qty}</td>
                                                    <td class="text-end">₹${item.rate}</td>
                                                    <td class="text-end fw-bold">₹${item.amount}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Generate Invoice</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- History Tabs -->
            <ul class="nav nav-tabs mb-3">
                <li class="nav-item">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#payment">Payment History</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#invoice">Invoice History</button>
                </li>
            </ul>

            <div class="tab-content">
                <div class="tab-pane fade show active" id="payment">
                    <c:choose>
                        <c:when test="${empty balanceDeposits}">
                            <div class="empty-state"><p>No payment history</p></div>
                        </c:when>
                        <c:otherwise>
                            <table class="table-simple">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Customer</th>
                                        <th>Description</th>
                                        <th class="text-end">Deposited</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${balanceDeposits}" var="bd">
                                        <tr>
                                            <td><a href="${pageContext.request.contextPath}/company/get-bal-credit-receipt/${bd.id}" target="_blank">#${bd.id}</a></td>
                                            <td>${bd.custName}</td>
                                            <td>${bd.description}</td>
                                            <td class="text-end fw-bold">₹${bd.advAmt}</td>
                                            <td>${bd.date}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="tab-pane fade" id="invoice">
                    <c:choose>
                        <c:when test="${empty oldinvoices}">
                            <div class="empty-state"><p>No invoice history</p></div>
                        </c:when>
                        <c:otherwise>
                            <table class="table-simple">
                                <thead>
                                    <tr>
                                        <th>Invoice No</th>
                                        <th class="text-end">Bill Amount</th>
                                        <th class="text-end">Advance</th>
                                        <th class="text-end">Balance</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${oldinvoices}" var="inv">
                                        <tr>
                                            <td><a href="${pageContext.request.contextPath}/company/get-invoice/${inv.custId}/${inv.invoiceId}" target="_blank">#${inv.invoiceId}</a></td>
                                            <td class="text-end">₹${inv.totInvoiceAmt}</td>
                                            <td class="text-end">₹${inv.advanAmt}</td>
                                            <td class="text-end">₹${inv.balanceAmt}</td>
                                            <td>${inv.createdAt}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="../view/footer.jsp"></jsp:include>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
let currentItemNo = parseInt('${itemsNo}') || 1;

function showAlert(msg, type) {
    const container = $('#alertContainer');
    const alert = $('<div class="alert-box alert-' + type + '">' + msg + '</div>');
    container.append(alert);
    setTimeout(() => alert.fadeOut(() => alert.remove()), 4000);
}

function calAmt() {
    const qty = parseFloat($('#qty').val()) || 0;
    const rate = parseFloat($('#rate').val()) || 0;
    $('#amount').val((qty * rate).toFixed(2));
}

function changeQty(delta) {
    let val = parseInt($('#qty').val()) || 1;
    val += delta;
    if (val < 1) val = 1;
    $('#qty').val(val);
    calAmt();
}

$(document).ready(function() {
    $('#datePicker').val(new Date().toISOString().split('T')[0]);

    $('#cashCheckbox').on('change', function() {
        const total = $('#source').val() || '0.0';
        $('#advanceValue, #advanAmtsend').val(this.checked ? total : '0.0');
    });

    $('#qtyMinus').click(() => changeQty(-1));
    $('#qtyPlus').click(() => changeQty(1));
    $('#rate, #qty').on('input', calAmt);
    $('#advanceValue').on('input', function() {
        $('#advanAmtsend').val($(this).val());
    });

    $('#productDropdown').select2({
        placeholder: 'Search Product...',
        minimumInputLength: 3,
        ajax: {
            url: '${pageContext.request.contextPath}/company/search-product',
            dataType: 'json',
            delay: 250,
            data: p => ({query: p.term}),
            processResults: data => ({
                results: $.map(data, i => ({
                    id: i.productId,
                    text: i.productName + ' - ₹' + i.price + ' (Stock: ' + i.stock + ')',
                    productName: i.productName,
                    price: i.price,
                    productId: i.productId
                }))
            })
        }
    }).on('select2:select', function(e) {
        const d = e.params.data;
        $('#description').val(d.productName);
        $('#productId').val(d.productId);
        $('#rate').val(d.price);
        calAmt();
    });

    $('#addItemForm').on('submit', function(e) {
        e.preventDefault();
        const btn = $('#addItemBtn').prop('disabled', true);

        $.ajax({
            url: '${pageContext.request.contextPath}/company/add-item',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                custId: $('input[name="custId"]').val(),
                productId: $('#productId').val() || null,
                description: $('#description').val(),
                invoiceNo: $('input[name="invoiceNo"]').val(),
                itemNo: $('#itemNo').val(),
                rate: $('#rate').val(),
                qty: $('#qty').val(),
                amount: $('#amount').val()
            }),
            headers: {'${_csrf.headerName}': '${_csrf.token}'},
            success: function(res) {
                if (res.status === 'success') {
                    showAlert('Item added!', 'success');
                    location.reload();
                } else {
                    showAlert(res.message || 'Failed', 'danger');
                    btn.prop('disabled', false);
                }
            },
            error: () => {
                showAlert('Error occurred', 'danger');
                btn.prop('disabled', false);
            }
        });
    });

    $(document).on('click', '.delete-item-btn', function() {
        if (!confirm('Delete this item?')) return;

        const itemId = $(this).data('id');
        $(this).prop('disabled', true);

        $.ajax({
            url: '${pageContext.request.contextPath}/company/delete-item',
            type: 'DELETE',
            contentType: 'application/json',
            data: JSON.stringify({itemId: itemId}),
            headers: {'${_csrf.headerName}': '${_csrf.token}'},
            success: function(res) {
                if (res.status === 'success') {
                    showAlert('Item deleted!', 'success');
                    location.reload();
                } else {
                    showAlert('Failed to delete', 'danger');
                }
            },
            error: () => showAlert('Error occurred', 'danger')
        });
    });
});
</script>
</body>
</html>