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
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>

  <!-- JS (head) -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <style>
    :root{
      --brand:#0d6efd;
      --soft:#f4f6f9;
      --ink:#33475b;
    }
    body{ background:var(--soft); }
    .brand-gradient{ background:linear-gradient(135deg,#3c7bff,#70a1ff); }
    .glass {
      backdrop-filter: blur(6px);
      background: rgba(255,255,255,.7);
      border: 1px solid rgba(255,255,255,.4);
    }
    .kpi{
      border:0; border-radius:18px;
      box-shadow:0 10px 24px rgba(0,0,0,.08);
      transition:.2s transform;
      overflow:hidden;
    }
    .kpi:hover{ transform:translateY(-4px); }
    .kpi .icon{
      width:44px;height:44px;border-radius:12px;
      display:flex;align-items:center;justify-content:center;
    }
    .section-title{
      font-weight:700;color:var(--ink);letter-spacing:.2px;
    }
    .card-modern{
      border:0;border-radius:18px;box-shadow:0 8px 22px rgba(0,0,0,.08);
    }
    .expense-item{
      border-radius:14px;
      border:1px dashed #d8e2ff;
      background:#fff;
      transition:.2s;
    }
    .expense-item:hover{ transform:scale(1.01); background:#f8fbff; }
    .avatar{ width:40px;height:40px;border-radius:50%;background:var(--brand);color:#fff;
      display:flex;align-items:center;justify-content:center;font-weight:700; }
    .sb-topnav{ border-bottom:1px solid rgba(255,255,255,.08); }
    .badge-soft-danger{ background:#fdecea;color:#d93025; }
    .list-mini{ font-size:.875rem; color:#6b7a90; }
    .rounded-18{ border-radius:18px; }
    .shadow-soft{ box-shadow:0 4px 14px rgba(0,0,0,.08); }
  </style>
</head>
<body class="sb-nav-fixed">

<!-- Loader -->


<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark brand-gradient">
  <a class="navbar-brand ps-3 fw-bold" href="${pageContext.request.contextPath}/login/home">
    My <i class="fa fa-calculator text-warning"></i> Bill Book
  </a>
  <button class="btn btn-outline-light btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>

  <div class="ms-auto d-flex align-items-center gap-3 pe-3">
    <div class="position-relative" role="button" onclick="openModal()">
      <i class="bi bi-bell fs-5 text-white"></i>
      <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
        ${productList.size()}
      </span>
    </div>
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

          <a class="nav-link" href="${pageContext.request.contextPath}/expenses">
                      <div class="sb-nav-link-icon"><i class="fas fa-file-export"></i></div> Daily Expenses
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
    <main>
      <div class="container-fluid px-4 mt-4">

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

        <!-- KPI ROW -->
        <div class="row g-4">
          <!-- Customers -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi p-3">
              <div class="d-flex align-items-center">
                <div class="icon bg-primary-subtle text-primary me-3"><i class="fa-solid fa-user-group"></i></div>
                <div>
                  <div class="text-muted small">Customers</div>
                  <div class="fs-4 fw-bold"><c:out value="${customerCount}"/></div>
                </div>
                <a class="ms-auto text-decoration-none small" href="${pageContext.request.contextPath}/company/get-all-customers">View</a>
              </div>
            </div>
          </div>
          <!-- Invoices -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi p-3">
              <div class="d-flex align-items-center">
                <div class="icon bg-warning-subtle text-warning me-3"><i class="fa-solid fa-file-invoice"></i></div>
                <div>
                  <div class="text-muted small">Invoices</div>
                  <div class="fs-4 fw-bold"><c:out value="${invoiceCount}"/></div>
                </div>
                <a class="ms-auto text-decoration-none small" href="${pageContext.request.contextPath}/company/get-all-invoices">View</a>
              </div>
            </div>
          </div>
          <!-- Today -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi p-3">
              <div class="d-flex align-items-center">
                <div class="icon bg-success-subtle text-success me-3"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                <div>
                  <div class="text-muted small">Today’s Expense</div>
                  <div class="fs-4 fw-bold">₹<fmt:formatNumber value="${todayExpense}" type="number"/></div>
                </div>
              </div>
            </div>
          </div>
          <!-- Total Expenses -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi p-3">
              <div class="d-flex align-items-center">
                <div class="icon bg-danger-subtle text-danger me-3"><i class="fa-solid fa-wallet"></i></div>
                <div>
                  <div class="text-muted small">Total Expenses</div>
                  <div class="fs-4 fw-bold">₹<fmt:formatNumber value="${totalExpenses}" type="number"/></div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- HERO + TODAY SUMMARY + CHARTS/EXPIRY -->
        <div class="row g-4 mt-1">
          <!-- Welcome / Business Card + Pie -->
          <div class="col-lg-4">
            <div class="card card-modern">
              <div class="card-body">
                <div class="d-flex align-items-start justify-content-between">
                  <div>
                    <h5 class="mb-1">👋 Hi, <span class="text-primary fw-bold">${ownerInfo.ownerName}</span></h5>
                    <div class="text-muted">Welcome to <b>My Bill Book Solutions</b></div>
                  </div>
                </div>
                <hr/>
                <div class="list-mini">
                  <div class="fw-semibold text-primary mb-1"><i class="bi bi-shop me-1"></i>${ownerInfo.shopName}</div>
                  <ul class="list-unstyled mb-0">
                    <li class="mb-1"><i class="bi bi-geo-alt me-1 text-primary"></i><b>Address:</b> ${ownerInfo.address}</li>
                    <li class="mb-1"><i class="bi bi-person-circle me-1 text-primary"></i><b>Owner:</b> ${ownerInfo.ownerName}</li>
                    <li class="mb-1"><i class="bi bi-phone me-1 text-primary"></i><b>Mobile:</b> ${ownerInfo.mobNumber}</li>
                    <li class="mb-1"><i class="bi bi-envelope me-1 text-primary"></i><b>Email:</b> ${ownerInfo.email}</li>
                    <li><i class="bi bi-receipt me-1 text-primary"></i><b>GST:</b> ${ownerInfo.gstNumber}</li>
                  </ul>
                </div>
              </div>
              <div class="card-body pt-0">
                <canvas id="paymentPieChart" height="180"></canvas>
              </div>
            </div>
          </div>

          <!-- Today Summary + Bar + Expiry Carousel -->
          <div class="col-lg-4">
            <div class="card card-modern h-100">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                  <h6 class="section-title mb-0">Today’s Summary</h6>
                  <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/company/get-my-profile" class="btn btn-outline-success btn-sm">
                      <i class="fa fa-user-edit me-1"></i> Edit Shop
                    </a>
                    <button class="btn btn-primary btn-sm" data-bs-toggle="offcanvas" data-bs-target="#addCustomerSidebar">
                      <i class="fa fa-user-plus me-1"></i> Add Customer
                    </button>
                  </div>
                </div>
                <hr class="mt-2"/>

                <div class="row text-center">
                  <div class="col-6 border-end">
                    <i class="bi bi-file-earmark-text-fill text-primary fs-4 d-block"></i>
                    <small class="text-muted">Invoices</small>
                    <h5 class="mb-0" id="dailyInvoiceCount">${dailySummary.invoiceCount}</h5>
                  </div>
                  <div class="col-6">
                    <i class="bi bi-currency-exchange text-success fs-4 d-block"></i>
                    <small class="text-muted">Transactions</small>
                    <h5 class="mb-0" id="transactionCount">${dailySummary.transactionCount}</h5>
                  </div>
                </div>

                <div class="row text-center mt-3">
                  <div class="col-4 border-end">
                    <small class="text-muted">Invoice Amt</small>
                    <h6 class="mb-0">₹${dailySummary.totalAmount/1000}K</h6>
                  </div>
                  <div class="col-4 border-end">
                    <small class="text-muted">Collected</small>
                    <h6 class="mb-0">₹${dailySummary.collectedAmount/1000}K</h6>
                  </div>
                  <div class="col-4">
                    <small class="text-muted">Balance</small>
                    <h6 class="mb-0">₹${dailySummary.totalBalanceAmount/1000}K</h6>
                  </div>
                </div>
              </div>

              <div class="card-body pt-0">
                <canvas id="paymentBarChart" height="180"></canvas>
              </div>

              <div class="card-body pt-0">
                <div id="expiryNoticeCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4200">
                  <div class="carousel-inner">
                    <c:forEach var="product" items="${productList}" varStatus="loop">
                      <div class="carousel-item ${loop.index == 0 ? 'active' : ''}">
                        <div class="card border-danger text-center mx-auto" style="max-width: 480px;">
                          <div class="card-header bg-danger text-white fw-bold">Product Expiry Notice - #${loop.index + 1}</div>
                          <div class="card-body">
                            <h5 class="card-title text-dark">${product.name}</h5>
                            <p class="card-text mb-0">
                              <strong>Available Quantity:</strong> ${product.quantity}<br/>
                              <strong>Expires In:</strong> <span class="badge badge-soft-danger">${product.expiresIn} days</span>
                            </p>
                          </div>
                        </div>
                      </div>
                    </c:forEach>
                  </div>
                  <button class="carousel-control-prev" type="button" data-bs-target="#expiryNoticeCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon"></span>
                  </button>
                  <button class="carousel-control-next" type="button" data-bs-target="#expiryNoticeCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon"></span>
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Customers -->
          <div class="col-lg-4">
            <style>
              .customer-card .card{ border:0;border-radius:14px;padding:.75rem; }
              .customer-card .btn{ font-size:.75rem;padding:4px 10px; }
              .customer-card .badge{ font-size:.7rem;padding:4px 6px; }
              .customer-card .text-muted{ font-size:.8rem; }
              .customer-card-container{ max-height:74vh; overflow-y:auto; }
            </style>
            <div class="card card-modern h-100">
              <div class="card-body pb-0">
                <h6 class="section-title">Customers</h6>
              </div>
              <div class="card-body pt-2 customer-card-container">
                <div class="row g-2" id="customerCardGrid">
                  <c:forEach items="${custmers}" var="custmer">
                    <div class="col-12 customer-card">
                      <div class="card shadow-sm">
                        <div class="card-body p-3">
                          <div class="d-flex justify-content-between align-items-start flex-wrap">
                            <div class="d-flex">
                              <div class="avatar me-2">${fn:substring(custmer.custName, 0, 1)}</div>
                              <div>
                                <h6 class="text-primary fw-semibold mb-0">${custmer.custName}</h6>
                                <div class="text-muted small">
                                  ${custmer.address}
                                  <a href="https://wa.me/${custmer.phoneNo}" target="_blank" class="text-success small ms-1">
                                    <i class="fab fa-whatsapp me-1"></i>${custmer.phoneNo}
                                  </a>
                                </div>
                              </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/company/update-customer/${custmer.id}" class="text-primary ms-auto mt-2" title="Edit Customer">
                              <i class="fas fa-edit"></i>
                            </a>
                          </div>

                          <div class="my-2">
                            <span class="badge bg-primary me-1">Total ₹${custmer.totalAmount}</span>
                            <span class="badge bg-success me-1">Paid ₹${custmer.paidAmout}</span>
                            <span class="badge bg-danger">Bal ₹${custmer.currentOusting}</span>
                          </div>

                          <div class="d-flex gap-2 mt-2 flex-wrap">
                            <form method="get" action="${pageContext.request.contextPath}/company/get-cust-by-id">
                              <input type="hidden" name="custid" value="${custmer.id}" />
                              <button class="btn btn-outline-primary btn-sm" type="submit"><i class="fas fa-file-invoice me-1"></i>Invoice</button>
                            </form>
                            <form method="get" action="${pageContext.request.contextPath}/company/get-bal-credit-page/${custmer.id}">
                              <button class="btn btn-outline-success btn-sm" type="submit"><i class="fas fa-donate me-1"></i>Deposit</button>
                            </form>
                            <form method="get" action="${pageContext.request.contextPath}/company/cust-history" target="_blank">
                              <input type="hidden" name="custid" value="${custmer.id}" />
                              <button class="btn btn-outline-warning btn-sm" type="submit"><i class="fas fa-list-ol me-1"></i>History</button>
                            </form>
                          </div>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- DAILY EXPENSES + TREND -->
        <div class="row g-4 mt-1">
          <!-- Daily Expenses (Card-based) -->
          <div class="col-lg-6">
            <div class="card card-modern">
              <div class="card-body">
                <h6 class="section-title mb-3"><i class="fa-solid fa-calendar-day me-2 text-primary"></i>Daily Expenses</h6>

                <c:forEach var="exp" items="${dailyExpenses}">
                  <div class="expense-item p-3 mb-2">
                    <div class="d-flex align-items-center justify-content-between">
                      <div class="d-flex align-items-center gap-3">
                        <div class="icon bg-primary-subtle text-primary rounded-18 p-2"><i class="fa-solid fa-receipt"></i></div>
                        <div>
                          <div class="fw-semibold">${exp.name}</div>
                          <div class="text-muted small"><fmt:formatDate value="${exp.date}" pattern="yyyy-MM-dd"/></div>
                        </div>
                      </div>
                      <div class="fw-bold text-danger">₹<fmt:formatNumber value="${exp.amount}" type="number"/></div>
                    </div>
                  </div>
                </c:forEach>

                <c:if test="${empty dailyExpenses}">
                  <div class="alert alert-light border text-muted mb-0">No expenses recorded today.</div>
                </c:if>
              </div>
            </div>
          </div>

          <!-- Expenses Trend -->
          <div class="col-lg-6">
            <div class="card card-modern h-100">
              <div class="card-body">
                <h6 class="section-title mb-3"><i class="fa-solid fa-chart-line me-2 text-primary"></i>Expenses Trend</h6>
                <canvas id="expensesTrendChart" height="210"></canvas>
              </div>
            </div>
          </div>
        </div>

      </div> <!-- /container-fluid -->
    </main>
  </div>
</div>

<!-- Offcanvas: Add Customer -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="addCustomerSidebar">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title">Add New Customer</h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
  </div>
  <div class="offcanvas-body">
    <form id="myform" action="${pageContext.request.contextPath}/login/save-profile-details" method="post" class="needs-validation" novalidate>
      <div class="mb-3">
        <label class="form-label">Customer Name</label>
        <div class="input-group has-validation">
          <span class="input-group-text"><i class="fa fa-user"></i></span>
          <input type="text" class="form-control" id="custName" name="custName" required>
          <div class="invalid-feedback">Please enter the customer's name.</div>
        </div>
      </div>
      <div class="mb-3">
        <label class="form-label">Email</label>
        <div class="input-group has-validation">
          <span class="input-group-text"><i class="fa fa-envelope"></i></span>
          <input type="email" class="form-control" id="email" name="email" placeholder="example@domain.com">
          <div class="invalid-feedback">Please enter a valid email address.</div>
        </div>
      </div>
      <div class="mb-3">
        <label class="form-label">Address</label>
        <div class="input-group has-validation">
          <span class="input-group-text"><i class="fa fa-map-marker"></i></span>
          <input type="text" class="form-control" id="address" name="address" required>
          <div class="invalid-feedback">Address is required.</div>
        </div>
      </div>
      <div class="mb-3">
        <label class="form-label">Mobile No.</label>
        <div class="input-group has-validation">
          <span class="input-group-text"><i class="fa fa-phone"></i></span>
          <input type="tel" class="form-control" id="phoneNo" name="phoneNo" pattern="^[6789][0-9]{9}$" minlength="10" maxlength="10" required title="Enter a valid 10-digit mobile number starting with 6-9">
          <div class="invalid-feedback">Enter a valid 10-digit mobile number starting with 6–9.</div>
        </div>
      </div>
      <div class="mb-3">
        <label class="form-label">Balance</label>
        <div class="input-group has-validation">
          <span class="input-group-text"><i class="fas fa-donate"></i></span>
          <input type="text" class="form-control" id="currentOusting" name="currentOusting" maxlength="10" value="0.00" required
                 oninput="this.value=this.value.replace(/[^0-9.]/g,'').replace(/(\..*)\./g,'$1');">
          <div class="invalid-feedback">Enter a valid numeric balance.</div>
        </div>
      </div>
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      <div class="d-grid">
        <button type="button" class="btn btn-primary" id="confirmButton"><i class="fa fa-check me-1"></i>Confirm & Save</button>
      </div>
    </form>
  </div>
</div>

<!-- Confirm Modal -->
<div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title">Confirm Customer Details</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <ul class="list-unstyled ms-2">
          <li><strong>Name:</strong> <span id="modalCustName"></span></li>
          <li><strong>Email:</strong> <span id="modalEmail"></span></li>
          <li><strong>Address:</strong> <span id="modalAddress"></span></li>
          <li><strong>Mobile:</strong> <span id="modalPhone"></span></li>
          <li><strong>Balance:</strong> ₹<span id="modalBalance"></span></li>
        </ul>
      </div>
      <div class="modal-footer">
        <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
        <button class="btn btn-outline-primary" id="submitConfirmed">Yes, Add Customer</button>
      </div>
    </div>
  </div>
</div>

<!-- Expiring Products Modal -->
<div class="modal fade" id="expiringModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header bg-warning-subtle">
        <h5 class="modal-title">⚠️ Product Expiration Report</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="table-responsive">
          <table class="table table-bordered table-striped align-middle text-center">
            <thead class="table-warning text-dark">
            <tr><th>#</th><th>Product Name</th><th>Available Quantity</th><th>Expires In</th></tr>
            </thead>
            <tbody>
            <c:forEach var="product" items="${productList}" varStatus="loop">
              <tr>
                <td>${loop.index + 1}</td>
                <td>${product.name}</td>
                <td>${product.quantity} Nos.</td>
                <td><span class="badge badge-soft-danger">${product.expiresIn} days</span></td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
      <div class="modal-footer"><button class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button></div>
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

<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/timeout.js" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>

<script>
  // Form validation
  (() => {
    'use strict';
    const form = document.querySelector('#myform');
    if(form){
      form.addEventListener('submit', e => {
        if (!form.checkValidity()) { e.preventDefault(); e.stopPropagation(); }
        form.classList.add('was-validated');
      }, false);
    }
  })();



  // Confirm modal flow
  const confirmBtn = document.getElementById('confirmButton');
  if(confirmBtn){
    confirmBtn.addEventListener('click', function(){
      const form = document.getElementById('myform');
      if(!form.checkValidity()){ form.classList.add('was-validated'); return; }
      document.getElementById('modalCustName').textContent  = document.getElementById('custName').value;
      document.getElementById('modalEmail').textContent     = document.getElementById('email').value || 'N/A';
      document.getElementById('modalAddress').textContent   = document.getElementById('address').value;
      document.getElementById('modalPhone').textContent     = document.getElementById('phoneNo').value;
      document.getElementById('modalBalance').textContent   = document.getElementById('currentOusting').value;
      new bootstrap.Modal(document.getElementById('confirmModal')).show();
    });
  }
  const submitConfirmed = document.getElementById('submitConfirmed');
  if(submitConfirmed){
    submitConfirmed.addEventListener('click', ()=> document.getElementById('myform').submit());
  }

  function openModal(){
    new bootstrap.Modal(document.getElementById('expiringModal')).show();
  }

  // ===== Charts =====
  const totalAmount = ${totalAmount != null ? totalAmount : 0};
  const paidAmount = ${paidAmount != null ? paidAmount : 0};
  const currentOusting = ${currentOutstanding != null ? currentOutstanding : 0};

  const toK = v => v >= 1000 ? (v/1000)+'K' : v;

  // Pie — overall totals
  new Chart(document.getElementById('paymentPieChart').getContext('2d'), {
    type: 'pie',
    data: {
      labels: ['Total Amount', 'Balance Amount', 'Paid Amount'],
      datasets: [{ data: [totalAmount, currentOusting, paidAmount] }]
    },
    options: {
      responsive:true,
      plugins:{
        legend:{ position:'bottom' },
        tooltip:{ callbacks:{ label:ctx => ctx.label+': '+toK(ctx.parsed) } }
      }
    }
  });

  // Bar — today summary
  const totalAmount1 = ${dailySummary.totalAmount != null ? dailySummary.totalAmount : 0};
  const paidAmount1 = ${dailySummary.collectedAmount != null ? dailySummary.collectedAmount : 0};
  const currentOusting1 = ${dailySummary.totalBalanceAmount != null ? dailySummary.totalBalanceAmount : 0};

  new Chart(document.getElementById('paymentBarChart').getContext('2d'), {
    type: 'bar',
    data: {
      labels: ['Total Amt', 'Balance Amt', 'Collected Amt'],
      datasets: [{ label:'Amount', data: [totalAmount1, currentOusting1, paidAmount1] }]
    },
    options:{
      responsive:true,
      plugins:{ legend:{ display:false }, tooltip:{ callbacks:{ label: c => toK(c.raw) } } },
      scales:{ y:{ beginAtZero:true, ticks:{ callback: toK } } }
    }
  });

  // Line — expenses trend from dailyExpenses
  const trendLabels = [
    <c:forEach var="exp" items="${dailyExpenses}" varStatus="s">
      '<fmt:formatDate value="${exp.date}" pattern="dd-MM"/>'<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];
  const trendData = [
    <c:forEach var="exp" items="${dailyExpenses}" varStatus="s">
      ${exp.amount}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];
  new Chart(document.getElementById('expensesTrendChart').getContext('2d'), {
    type: 'line',
    data: { labels: trendLabels, datasets: [{ label:'Daily Expenses', data: trendData, fill:true, tension:.35 }] },
    options:{ responsive:true, plugins:{ legend:{ display:false } }, scales:{ y:{ beginAtZero:true } } }
  });
</script>
</body>
</html>
