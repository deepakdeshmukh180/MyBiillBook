<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dashboard - My Bill Book</title>

    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet"/>

    <style>
        :root{
          --brand:#0d6efd;
          --soft:#f4f6f9;
          --ink:#33475b;
        }
        body{ background:var(--soft); }
        .brand-gradient{ background:linear-gradient(135deg,#3c7bff,#70a1ff); }
        .card-modern{ border:0;border-radius:18px;box-shadow:0 8px 22px rgba(0,0,0,.08); }
        .rounded-18{ border-radius:18px; }
        .shadow-soft{ box-shadow:0 4px 14px rgba(0,0,0,.08); }
        .kpi-mini { border-left:4px solid #e9ecef; }
        .kpi-mini.primary { border-left-color:#0d6efd; }
        .kpi-mini.success { border-left-color:#198754; }
        .kpi-mini.danger { border-left-color:#dc3545; }
        .item-card { border-left:4px solid var(--brand); }
        .sb-topnav{ border-bottom:1px solid rgba(255,255,255,.08); }
    </style>
</head>
<body class="sb-nav-fixed">

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark brand-gradient">
    <a class="navbar-brand ps-3 fw-bold" href="${pageContext.request.contextPath}/login/home">
        My <i class="fa fa-calculator text-warning"></i> Bill Book
    </a>
    <button class="btn btn-outline-light btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>

    <div class="ms-auto d-flex align-items-center gap-3 pe-3">

        <div class="dropdown">
            <a class="nav-link dropdown-toggle text-white" id="navbarDropdown" href="#" data-bs-toggle="dropdown">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div id="layoutSidenav">
    <!-- Sidebar -->
    <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
            <div class="sb-sidenav-menu">
                <div class="nav">
                    <div class="sb-sidenav-menu-heading">Core</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login/home">
                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div> Dashboard
                    </a>

                    <div class="sb-sidenav-menu-heading">Interface</div>
                    <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts">
                        <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div> Menu
                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                    </a>
                    <div class="collapse" id="collapseLayouts" data-bs-parent="#sidenavAccordion">
                        <nav class="sb-sidenav-menu-nested nav">
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers"><i class="fas fa-user-friends me-2 text-white"></i>All Customers</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices"><i class="fas fa-file-invoice me-2 text-white"></i>Invoices</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports"><i class="fas fa-chart-line me-2 text-white"></i>Daily/Monthly Reports</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products"><i class="fas fa-leaf me-2 text-white"></i>Products</a>
                        </nav>
                    </div>

                    <div class="sb-sidenav-menu-heading">Addons</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
                        <div class="sb-nav-link-icon"><i class="fas fa-user-circle"></i></div> My Profile
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/export-to-pdf">
                        <div class="sb-nav-link-icon"><i class="fas fa-file-export"></i></div> Export Customers
                    </a>
                </div>
            </div>
            <div class="sb-sidenav-footer">
                <div class="small">Logged in as:</div>
                ${pageContext.request.userPrincipal.name}
            </div>
        </nav>
    </div>

    <!-- Main -->
    <div id="layoutSidenav_content">
        <div class="container-fluid px-4 py-4">

            <!-- Customer + Invoice header cards (4 per row) -->
            <div class="row g-3 mb-3">
                <div class="col-md-6 col-lg-3">
                    <div class="card card-modern h-100">
                        <div class="card-body">
                            <small class="text-muted"><i class="fas fa-user me-2 text-primary"></i>Customer</small>
                            <div class="fw-bold mt-1">Mr. ${profile.custName}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card card-modern h-100">
                        <div class="card-body">
                            <small class="text-muted"><i class="fas fa-map-marker-alt me-2 text-danger"></i>Address</small>
                            <div class="fw-bold mt-1">${profile.address}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card card-modern h-100">
                        <div class="card-body">
                            <small class="text-muted"><i class="fas fa-phone me-2 text-success"></i>Mobile</small>
                            <div class="fw-bold mt-1">${profile.phoneNo}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card card-modern h-100">
                        <div class="card-body">
                            <small class="text-muted"><i class="fas fa-file-invoice me-2 text-secondary"></i>Invoice</small>
                            <div class="fw-bold mt-1">${invoiceNo}</div>
                            <div class="text-muted small">${date}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Amount summary (3 cards) -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="card card-modern kpi-mini primary h-100">
                        <div class="card-body text-center">
                            <div class="text-muted">Total Amount</div>
                            <div class="fs-5 fw-bold text-primary">₹ ${profile.totalAmount}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card card-modern kpi-mini success h-100">
                        <div class="card-body text-center">
                            <div class="text-muted">Paid Amount</div>
                            <div class="fs-5 fw-bold text-success">₹ ${profile.paidAmout}</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card card-modern kpi-mini danger h-100">
                        <div class="card-body text-center">
                            <div class="text-muted">Balance Amount</div>
                            <div class="fs-5 fw-bold text-danger">₹ ${profile.currentOusting}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Add Item -->
            <div class="card card-modern mb-4">
                <div class="card-header bg-success text-white">
                    <i class="fas fa-plus-circle me-2"></i>Add Item
                </div>
                <div class="card-body">
                    <form method="post" modelAttribute="ItemDetails"
                          action="${pageContext.request.contextPath}/company/save-items"
                          class="row g-3 align-items-end">

                        <!-- CSRF + Hidden -->
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="custId" value="${profile.id}">
                        <input type="hidden" name="description" id="description" required>
                        <input type="hidden" name="productId" id="productId" required>
                        <input type="hidden" name="invoiceNo" value="${invoiceNo}">

                        <div class="col-md-2">
                            <label class="form-label fw-semibold">Item No</label>
                            <input type="text" class="form-control text-center" name="itemNo" readonly value="${itemsNo}">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Select Product</label>
                            <select id="productDropdown" class="form-control text-center" style="width:100%"></select>
                        </div>


                        <div class="col-md-2">
                            <label class="form-label fw-semibold">Rate</label>
                            <input type="text" class="form-control" name="rate" id="rate" required
                                   onkeyup="calAmt()"
                                   placeholder="Rate"
                                   oninput="this.value=this.value.replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');">
                        </div>

                       <div class="col-md-2">
                           <label class="form-label fw-semibold">Qty</label>
                           <div class="input-group">
                               <button class="btn btn-outline-secondary" type="button" onclick="changeQty(-1)">-</button>
                               <input type="text" class="form-control text-center" name="qty" id="qty" value="1"
                                      onkeyup="calAmt()" required placeholder="Qty">
                               <button class="btn btn-outline-secondary" type="button" onclick="changeQty(1)">+</button>
                           </div>
                       </div>



                        <div class="col-md-2">
                            <label class="form-label fw-semibold">Amount</label>
                            <input type="text" class="form-control fw-bold text-end" name="amount" id="amount" readonly placeholder="Amount">
                        </div>

                        <div class="col-12 text-end">
                            <button type="submit" class="btn btn-outline-primary">
                                <i class="fa fa-plus me-2"></i>Add Item
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty message}">
                <div class="alert alert-warning alert-dismissible fade show shadow-soft border-0" role="alert" id="alert-warning">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i><strong>Warning!</strong> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <script>
                    window.addEventListener('load',()=>{ setTimeout(()=>{ const el=document.getElementById('alert-warning'); if(el){ bootstrap.Alert.getOrCreateInstance(el).close(); } }, 3000); });
                </script>
            </c:if>

            <!-- Items Grid (cards, 4 per row on lg) -->
            <div class="row g-2 mb-3"> <!-- reduced gap for compactness -->
                <c:forEach items="${items}" var="item">
                    <div class="col-6 col-sm-4 col-md-2"> <!-- ensures 6 per row -->
                        <div class="card card-modern item-card h-100 d-flex flex-column p-2">
                            <div class="card-body flex-grow-1 p-2">
                                <h6 class="fw-semibold small mb-1">#${item.itemNo} — ${item.description}</h6>
                                <ul class="list-unstyled text-muted mb-1" style="font-size:11px;">
                                    <li><i class="fas fa-barcode me-1 text-secondary"></i><span class="fw-medium">Batch:</span> ${item.batchNo}</li>
                                    <li><i class="fas fa-cubes me-1 text-info"></i><span class="fw-medium">Qty:</span> ${item.qty}</li>
                                    <li><i class="fas fa-tags me-1 text-success"></i><span class="fw-medium">MRP:</span> ₹${item.mrp}</li>
                                    <li><i class="fas fa-dollar-sign me-1 text-primary"></i><span class="fw-medium">Rate:</span> ₹${item.rate}</li>
                                    <li class="fw-semibold text-dark"><i class="fas fa-wallet me-1 text-warning"></i>Total: ₹${item.amount}</li>
                                </ul>
                            </div>
                            <div class="card-footer bg-transparent border-0 text-end p-1 mt-auto">
                                <form method="get" action="${pageContext.request.contextPath}/company/delete-item-by-id">
                                    <input type="hidden" name="itemid" value="${item.id}" />
                                    <button type="submit" class="btn btn-xs btn-outline-danger rounded-pill">
                                        <i class="fa fa-trash"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>


            <!-- Invoice Summary + Generate -->
            <div class="card card-modern mb-4">
                <div class="card-header">
                    <i class="fas fa-receipt me-2"></i>Invoice Summary
                </div>
                <div class="card-body">
                    <form name="frm" method="post" action="${pageContext.request.contextPath}/company/invoice" modelAttribute="INVOICE_DETAILS">
                        <!-- CSRF -->
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <!-- Hidden Inputs as in original -->
                        <input type="hidden" name="invoiceId" value="${invoiceNo}" />
                        <input type="hidden" name="custId" value="${profile.id}" />
                        <input type="hidden" name="custName" value="${profile.custName}" />
                        <input type="hidden" name="totQty" value="${totalQty}" />
                        <input type="hidden" name="totInvoiceAmt" id="source" value="${totalAmout}" />
                        <input type="hidden" name="totAmt" value="${profile.totalAmount}" />
                        <input type="hidden" name="balanceAmt" value="${profile.currentOusting}" />
                        <input type="hidden" id="advanAmtsend" name="advanAmt" value="0.0" placeholder="Adv Amt">
                        <input type="hidden" id="oldInvoicesFlag" name="oldInvoicesFlag" value="F" />

                        <div class="row g-3 align-items-end">
                            <div class="col-md-2">
                                <label class="form-label">Invoice Qty</label>
                                <input type="text" class="form-control text-end" value="${totalQty}" readonly>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Invoice Amt (A)</label>
                                <input type="text" class="form-control text-end" value="${preTaxAmt}" readonly>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">GST (B)</label>
                                <input type="text" class="form-control text-end" value="${totGst}" readonly>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Total Amt (A+B)</label>
                                <input type="text" class="form-control text-end" value="${totalAmout}" id="totalAmout" readonly>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Advance Amount</label>
                                <div class="d-flex align-items-center">
                                    <input type="text" id="advanceValue" name="advanAmt" class="form-control text-end me-3" oninput="copyValue()" value="0.0" placeholder="Enter advance amount">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="cashCheckbox">
                                        <label class="form-check-label" for="cashCheckbox">Cash</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 text-end">
                                <button type="button" class="btn btn-outline-success"
                                        data-bs-toggle="modal" data-bs-target="#confirmModal"
                                        ${empty items ? 'disabled' : ''}>
                                    Generate Invoice
                                </button>
                            </div>
                        </div>

                        <!-- Confirm Modal -->
                        <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-xl">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="confirmModalLabel">Confirm Invoice Generation</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p>Are you sure you want to generate the invoice?</p>

                                        <!-- Customer Summary -->
                                        <div class="row g-3 mb-3">
                                            <div class="col-md-6 col-lg-3">
                                                <div class="card card-modern h-100">
                                                    <div class="card-body">
                                                        <small class="text-muted">Customer</small>
                                                        <div class="fw-bold">Mr. ${profile.custName}</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-lg-3">
                                                <div class="card card-modern h-100">
                                                    <div class="card-body">
                                                        <small class="text-muted">Address</small>
                                                        <div class="fw-bold">${profile.address}</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-lg-3">
                                                <div class="card card-modern h-100">
                                                    <div class="card-body">
                                                        <small class="text-muted">Mobile</small>
                                                        <div class="fw-bold">${profile.phoneNo}</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-lg-3">
                                                <div class="card card-modern h-100">
                                                    <div class="card-body">
                                                        <small class="text-muted">Invoice / Date</small>
                                                        <div class="fw-bold">${invoiceNo}</div>
                                                        <div class="text-muted small">${date}</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Items Preview (compact table for modal only) -->
                                        <div class="table-responsive">
                                            <table class="table table-sm align-middle">
                                                <thead class="table-primary">
                                                <tr>
                                                    <th>Sr.No</th>
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
                                                        <td>${item.description}</td>
                                                        <td>${item.batchNo}</td>
                                                        <td class="text-end">${item.qty}</td>
                                                        <td class="text-end">${item.mrp}</td>
                                                        <td class="text-end fw-semibold">${item.rate}</td>
                                                        <td class="text-end">${item.amount}</td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Totals row -->
                                        <div class="row g-3">
                                            <div class="col-md-3">
                                                <label class="form-label">Invoice Qty</label>
                                                <input type="text" class="form-control text-end" value="${totalQty}" readonly>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">Invoice Amt (A)</label>
                                                <input type="text" class="form-control text-end" value="${preTaxAmt}" readonly>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">GST (B)</label>
                                                <input type="text" class="form-control text-end" value="${totGst}" readonly>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">Total (A+B)</label>
                                                <input type="text" class="form-control text-end" value="${totalAmout}" readonly>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-outline-primary">Yes, Generate</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </form>
                </div>
            </div>

            <!-- History Tabs -->
            <ul class="nav nav-tabs" id="historyTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="payment-tab" data-bs-toggle="tab" data-bs-target="#payment" type="button" role="tab">
                        Payment History
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="invoice-tab" data-bs-toggle="tab" data-bs-target="#invoice" type="button" role="tab">
                        Invoice History
                    </button>
                </li>
            </ul>

            <div class="tab-content mt-3">
                <!-- Payment History Tab -->
                <div class="tab-pane fade show active" id="payment" role="tabpanel">
                    <div class="card card-modern mb-3">
                        <div class="card-header text-center"><strong>Payment History</strong></div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-striped align-middle">
                                    <thead class="table-success">
                                    <tr>
                                        <th>Transaction Id</th>
                                        <th>Customer Name</th>
                                        <th>Description</th>
                                        <th class="text-end">Closing Amt</th>
                                        <th>Payment Mode</th>
                                        <th class="text-end">Deposited Amt</th>
                                        <th>Date</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${balanceDeposits}" var="balanceDeposit">
                                        <tr>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/company/get-bal-credit-receipt/${balanceDeposit.id}"
                                                   target="_blank" style="text-decoration:none;">
                                                    <i class="fa fa-receipt me-1"></i>${balanceDeposit.id}
                                                </a>
                                            </td>
                                            <td>${balanceDeposit.custName}</td>
                                            <td>${balanceDeposit.description}</td>
                                            <td class="text-end">${balanceDeposit.currentOusting}</td>
                                            <td>${balanceDeposit.modeOfPayment}</td>
                                            <td class="text-end">${balanceDeposit.advAmt}</td>
                                            <td>${balanceDeposit.date}</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Invoice History Tab -->
                <div class="tab-pane fade" id="invoice" role="tabpanel">
                    <div class="card card-modern">
                        <div class="card-header text-center"><strong>Invoice History</strong></div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-striped align-middle">
                                    <thead class="table-success">
                                    <tr>
                                        <th>Invoice No</th>
                                        <th class="text-end">Bill Amt</th>
                                        <th class="text-end">Adv Amt</th>
                                        <th class="text-end">Bal</th>
                                        <th>Date</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${oldinvoices}" var="invoice">
                                        <tr>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}" target="_blank">
                                                    ${invoice.invoiceId}
                                                </a>
                                            </td>
                                            <td class="text-end">${invoice.totInvoiceAmt}</td>
                                            <td class="text-end">${invoice.advanAmt}</td>
                                            <td class="text-end">${invoice.balanceAmt}</td>
                                            <td>${invoice.createdAt}</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Success toast -->
            <c:if test="${not empty msg}">
                <div class="alert alert-success alert-dismissible fade show shadow-soft border-0" role="alert" id="success-alert">
                    <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <script>
                    window.addEventListener('load',()=>{ setTimeout(()=>{ const el=document.getElementById('success-alert'); if(el){ bootstrap.Alert.getOrCreateInstance(el).close(); } }, 3500); });
                </script>
            </c:if>

        </div>
    </div>
</div>

<!-- Logout form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/timeout.js" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>


<script>



    // Cash checkbox copies total amount into advance
    document.addEventListener('DOMContentLoaded', function(){
        const cashCb = document.getElementById('cashCheckbox');
        if (cashCb){
            cashCb.addEventListener('change', function() {
                const total = document.getElementById('totalAmout').value || "0.0";
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

    // Keep hidden advanAmtsend in sync
    function copyValue() {
        var amt = document.getElementById("advanceValue").value || "0.0";
        document.getElementById("advanAmtsend").value = amt;
    }

  $(document).ready(function () {
      $('#productDropdown').select2({
          placeholder: 'Search Product...',
          allowClear: true,
          minimumInputLength: 2,
          ajax: {
              url: '${pageContext.request.contextPath}/company/search-product',
              dataType: 'json',
              delay: 250,
              data: function (params) {
                  return { query: params.term }; // search term
              },
              processResults: function (data) {
                  return {
                      results: $.map(data, function (item) {
                          return {
                              id: item.productId,
                              text: item.productName + " (₹" + item.price + ")",

                              // extra fields (instead of split logic)
                              productName: item.productName,
                              price: item.price,
                              productId: item.productId
                          };
                      })
                  };
              },
              cache: true
          }
      });

      // Product selection = same as old getProductValue()
      $('#productDropdown').on('select2:select', function (e) {
          const data = e.params.data;

          // description = product name
          $('#description').val(data.productName);

          // productId = backend id
          $('#productId').val(data.productId);

          // rate = price
          $('#rate').val(data.price);

          // calculate total
          calAmt();
      });
  });

  // old calc function stays the same
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
                           if (current < 1) current = 1; // prevent negative or zero
                           qtyInput.value = current;
                           calAmt(); // recalculate when qty changes
                       }


</script>
</body>
</html>
