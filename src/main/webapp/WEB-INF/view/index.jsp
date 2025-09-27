<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
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
      --shadow-light:0 2px 20px rgba(0,0,0,.05);
      --shadow-medium:0 8px 30px rgba(0,0,0,.12);
      --shadow-strong:0 15px 40px rgba(0,0,0,.15);
    }

    body{
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      min-height: 100vh;
    }

    .brand-gradient{ background:linear-gradient(135deg,#3c7bff,#70a1ff); }

    /* Enhanced Card Styles */
    .enhanced-card {
      border: none;
      border-radius: 20px;
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(20px);
      box-shadow: var(--shadow-light);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      overflow: hidden;
      position: relative;
    }

    .enhanced-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
      opacity: 0;
      transition: opacity 0.3s ease;
    }

    .enhanced-card:hover {
      transform: translateY(-8px);
      box-shadow: var(--shadow-strong);
    }

    .enhanced-card:hover::before {
      opacity: 1;
    }

    /* KPI Cards */
    .kpi-card {
      border: none;
      border-radius: 24px;
      background: linear-gradient(145deg, #ffffff, #f0f0f0);
      box-shadow:
        20px 20px 40px #d9d9d9,
        -20px -20px 40px #ffffff;
      transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
      overflow: hidden;
      position: relative;
    }

    .kpi-card::after {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.8), transparent);
      transition: left 0.6s;
    }

    .kpi-card:hover::after {
      left: 100%;
    }

    .kpi-card:hover {
      transform: translateY(-12px) scale(1.02);
      box-shadow:
        25px 25px 50px #d0d0d0,
        -25px -25px 50px #ffffff;
    }

    .kpi-icon {
      width: 64px;
      height: 64px;
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 24px;
      background: linear-gradient(45deg, var(--bs-primary), var(--bs-primary-rgb));
      color: white;
      box-shadow: 0 8px 16px rgba(13, 110, 253, 0.3);
    }

    /* Welcome Card */
    .welcome-card {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-radius: 24px;
      border: none;
      position: relative;
      overflow: hidden;
    }

    .welcome-card::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 100%;
      height: 100%;
      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
    }

    /* Chart Cards */
    .chart-card {
      border: none;
      border-radius: 24px;
      background: rgba(255, 255, 255, 0.98);
      box-shadow: var(--shadow-medium);
      backdrop-filter: blur(10px);
      transition: all 0.3s ease;
    }

    .chart-card:hover {
      transform: translateY(-4px);
      box-shadow: var(--shadow-strong);
    }

    /* Customer Cards */
    .customer-mini-card {
      border: none;
      border-radius: 18px;
      background: linear-gradient(145deg, #ffffff, #f8f9fa);
      transition: all 0.3s ease;
      border-left: 4px solid transparent;
      box-shadow: var(--shadow-light);
    }

    .customer-mini-card:hover {
      transform: translateX(8px);
      border-left-color: var(--bs-primary);
      box-shadow: var(--shadow-medium);
      background: linear-gradient(145deg, #f8f9fa, #ffffff);
    }

    .customer-avatar {
      width: 48px;
      height: 48px;
      border-radius: 16px;
      background: linear-gradient(45deg, var(--bs-primary), var(--bs-info));
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 18px;
      box-shadow: 0 4px 12px rgba(13, 110, 253, 0.3);
    }

    /* Expense Cards */
    .expense-item {
      border: none;
      border-radius: 16px;
      background: linear-gradient(145deg, #ffffff, #f8f9fa);
      transition: all 0.3s ease;
      border-left: 4px solid var(--bs-danger);
      box-shadow: var(--shadow-light);
    }

    .expense-item:hover {
      transform: translateX(6px);
      box-shadow: var(--shadow-medium);
    }

    .expense-icon {
      width: 40px;
      height: 40px;
      border-radius: 12px;
      background: linear-gradient(45deg, #dc3545, #e74c3c);
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
    }

    /* Section Headers */
    .section-header {
      position: relative;
      padding-bottom: 12px;
      margin-bottom: 24px;
    }

    .section-header::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 0;
      width: 60px;
      height: 3px;
      background: linear-gradient(90deg, var(--bs-primary), var(--bs-info));
      border-radius: 2px;
    }

    .section-title {
      font-weight: 700;
      color: var(--ink);
      font-size: 1.1rem;
      letter-spacing: 0.5px;
    }

    /* Enhanced Badges */
    .badge-modern {
      padding: 6px 12px;
      border-radius: 12px;
      font-weight: 500;
      font-size: 0.75rem;
    }

    /* Carousel Enhancement */
    .expiry-carousel .carousel-item .card {
      border: none;
      border-radius: 20px;
      background: linear-gradient(145deg, #fff5f5, #ffe6e6);
      border-left: 6px solid var(--bs-danger);
      box-shadow: var(--shadow-medium);
    }

    /* Button Enhancements */
    .btn-modern {
      border-radius: 12px;
      padding: 8px 16px;
      font-weight: 500;
      transition: all 0.3s ease;
    }

    .btn-modern:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(0,0,0,0.15);
    }

    /* Animation Classes */
    .fade-in-up {
      animation: fadeInUp 0.6s ease-out;
    }

    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .stagger-1 { animation-delay: 0.1s; }
    .stagger-2 { animation-delay: 0.2s; }
    .stagger-3 { animation-delay: 0.3s; }
    .stagger-4 { animation-delay: 0.4s; }

    /* Responsive Adjustments */
    @media (max-width: 768px) {
      .kpi-card {
        margin-bottom: 1rem;
      }

      .customer-mini-card:hover {
        transform: none;
      }

      .expense-item:hover {
        transform: none;
      }
    }

    .sb-topnav{ border-bottom:1px solid rgba(255,255,255,.08); }
    .badge-soft-danger{ background:#fdecea;color:#d93025; }
    .list-mini{ font-size:.875rem; color:#6b7a90; }
  </style>
</head>
<body class="sb-nav-fixed">

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark brand-gradient">
   <a class="navbar-brand ps-3 fw-bold" href="#" onclick="showSection('dashboard')">
      <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgwIiBoZWlnaHQ9IjQwIiB2aWV3Qm94PSIwIDAgMTgwIDQwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iNSIgeTE9IjMiIHgyPSIyNSIgeTI9IjI3IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiNmZmZmZmYiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjZjJmMmYyIi8+CjwvbGluZWFyR3JhZGllbnQ+CjxsaW5lYXJHcmFkaWVudCBpZD0icGFpbnQxX2xpbmVhciIgeDE9IjE3IiB5MT0iMTMiIHgyPSIyOCIgeTI9IjI0IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMxMEI5ODEiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDU5NjY5Ii8+CjwvbGluZWFyR3JhZGllbnQ+CjwvZGVmcz4KPCEtLSBEb2N1bWVudC9CaWxsIEljb24gLS0+CjxyZWN0IHg9IjUiIHk9IjMiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyNCIgcng9IjMiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcikiLz4KPCEtLSBMaW5lcyBvbiBkb2N1bWVudCAtLT4KPHBhdGggZD0iTTkgOWg4bS04IDNINW0tNSAzaDciIHN0cm9rZT0iIzJGNDc1OSIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPCEtLSBDaGVja21hcmsgLS0+CjxjaXJjbGUgY3g9IjIyLjUiIGN5PSIxOC41IiByPSI1LjUiIGZpbGw9InVybCgjcGFpbnQxX2xpbmVhcikiLz4KPHBhdGggZD0ibTIwIDE4LjUgMiAyIDQtNCIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8IS0tIFRleHQgLS0+Cjx0ZXh0IHg9IjM1IiB5PSIxNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmb250LXdlaWdodD0iNzAwIiBmaWxsPSJ3aGl0ZSI+CkJpbGxNYXRlUHJvPC90ZXh0Pgo8dGV4dCB4PSIzNSIgeT0iMjYiIGZvbnQtZmFtaWx5PSJJbnRlciwgc2Fucy1zZXJpZiIgZm9udC1zaXplPSI4IiBmaWxsPSIjZTJlOGYwIj4KWW91ciBCaWxsaW5nIFBhcnRuZXI8L3RleHQ+Cjwvc3ZnPg=="
           alt="BillMatePro" style="height: 50px; margin-right: 8px;">
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
                                          <div class="sb-nav-link-icon"><i class="fa fa-gear fa-spin"></i></div> Account Settings
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
          <div class="alert alert-success alert-dismissible fade show enhanced-card border-0" role="alert" id="success-alert">
            <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
          <script>
            window.addEventListener('load',()=>{ setTimeout(()=>{ const el=document.getElementById('success-alert'); if(el){ bootstrap.Alert.getOrCreateInstance(el).close(); } }, 3500); });
          </script>
        </c:if>

        <!-- KPI ROW -->
        <div class="row g-4 mb-4">
          <!-- Customers -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi-card p-4 fade-in-up stagger-1">
              <div class="d-flex align-items-center">
                <div class="kpi-icon me-3">
                  <i class="fa-solid fa-user-group"></i>
                </div>
                <div class="flex-grow-1">
                  <div class="text-muted small mb-1">Total Customers</div>
                  <div class="fs-3 fw-bold text-primary"><c:out value="${customerCount}"/></div>
                </div>
                <a class="btn btn-outline-primary btn-sm btn-modern" href="${pageContext.request.contextPath}/company/get-all-customers">
                  <i class="fas fa-eye me-1"></i>View
                </a>
              </div>
            </div>
          </div>

          <!-- Invoices -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi-card p-4 fade-in-up stagger-2">
              <div class="d-flex align-items-center">
                <div class="kpi-icon me-3" style="background: linear-gradient(45deg, #ffc107, #ff8f00);">
                  <i class="fa-solid fa-file-invoice"></i>
                </div>
                <div class="flex-grow-1">
                  <div class="text-muted small mb-1">Total Invoices</div>
                  <div class="fs-3 fw-bold text-warning"><c:out value="${invoiceCount}"/></div>
                </div>
                <a class="btn btn-outline-warning btn-sm btn-modern" href="${pageContext.request.contextPath}/company/get-all-invoices">
                  <i class="fas fa-eye me-1"></i>View
                </a>
              </div>
            </div>
          </div>

          <!-- Today's Expense -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi-card p-4 fade-in-up stagger-3">
              <div class="d-flex align-items-center">
                <div class="kpi-icon me-3" style="background: linear-gradient(45deg, #198754, #20c997);">
                  <i class="fa-solid fa-indian-rupee-sign"></i>
                </div>
                <div class="flex-grow-1">
                  <div class="text-muted small mb-1">Today's Expense</div>
                  <div class="fs-3 fw-bold text-success">
                    ₹<fmt:formatNumber value="${empty daily_expenses ? 0.0 : daily_expenses}" type="number"/>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Total Expenses -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi-card p-4 fade-in-up stagger-4">
              <div class="d-flex align-items-center">
                <div class="kpi-icon me-3" style="background: linear-gradient(45deg, #dc3545, #e74c3c);">
                  <i class="fa-solid fa-wallet"></i>
                </div>
                <div class="flex-grow-1">
                  <div class="text-muted small mb-1">Total Expenses</div>
                  <div class="fs-3 fw-bold text-danger">
                    ₹<fmt:formatNumber value="${empty monthly_expenses ? 0.0 : monthly_expenses}" type="number"/>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- MAIN CONTENT ROW -->
        <div class="row g-4">
          <!-- Welcome Card -->
          <div class="col-lg-4">
            <div class="card welcome-card fade-in-up">
              <div class="card-body p-4">
                <div class="d-flex align-items-center mb-3">
                  <div class="me-3">
                    <i class="fas fa-hand-paper fs-2"></i>
                  </div>
                  <div>
                    <h5 class="mb-1">Hello, <span class="fw-bold">${ownerInfo.ownerName}!</span></h5>
                    <p class="mb-0 opacity-75">Welcome to My Bill Book Solutions</p>
                  </div>
                </div>

                <div class="bg-white bg-opacity-10 rounded-3 p-3 mb-4">
                  <h6 class="mb-2"><i class="bi bi-shop me-2"></i>${ownerInfo.shopName}</h6>
                  <div class="row g-2 small">
                    <div class="col-12"><i class="bi bi-geo-alt me-1"></i><strong>Address:</strong> ${ownerInfo.address}</div>
                    <div class="col-12"><i class="bi bi-phone me-1"></i><strong>Mobile:</strong> ${ownerInfo.mobNumber}</div>
                    <div class="col-12"><i class="bi bi-envelope me-1"></i><strong>Email:</strong> ${ownerInfo.email}</div>
                    <div class="col-12"><i class="bi bi-receipt me-1"></i><strong>GST:</strong> ${ownerInfo.gstNumber}</div>
                  </div>
                </div>

                <div class="d-flex gap-2">
                  <a href="${pageContext.request.contextPath}/company/get-my-profile" class="btn btn-light btn-sm btn-modern flex-fill">
                    <i class="fa fa-user-edit me-1"></i> Edit Shop
                  </a>
                  <button class="btn btn-outline-light btn-sm btn-modern flex-fill" data-bs-toggle="offcanvas" data-bs-target="#addCustomerSidebar">
                    <i class="fa fa-user-plus me-1"></i> Add Customer
                  </button>
                </div>
              </div>

              <!-- Pie Chart Section -->
              <div class="card-body pt-0">
                <div class="bg-white bg-opacity-10 rounded-3 p-3">
                  <h6 class="text-center mb-3">Payment Overview</h6>
                  <canvas id="paymentPieChart" height="200"></canvas>
                </div>
              </div>
            </div>
          </div>

          <!-- Today's Summary & Charts -->
          <div class="col-lg-4">
            <div class="card chart-card h-100 fade-in-up">
              <div class="card-body">
                <div class="section-header">
                  <h6 class="section-title mb-0">Today's Business Summary</h6>
                </div>

                <div class="row text-center mb-4">
                  <div class="col-6">
                    <div class="bg-primary bg-opacity-10 rounded-3 p-3">
                      <i class="bi bi-file-earmark-text-fill text-primary fs-3 d-block mb-2"></i>
                      <small class="text-muted">Invoices Created</small>
                      <h4 class="mb-0 text-primary fw-bold">${dailySummary.invoiceCount}</h4>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="bg-success bg-opacity-10 rounded-3 p-3">
                      <i class="bi bi-currency-exchange text-success fs-3 d-block mb-2"></i>
                      <small class="text-muted">Transactions</small>
                      <h4 class="mb-0 text-success fw-bold">${dailySummary.transactionCount}</h4>
                    </div>
                  </div>
                </div>

                <div class="row text-center mb-4">
                  <div class="col-4">
                    <div class="border-end">
                      <small class="text-muted d-block">Collected</small>
                      <h6 class="mb-0 text-success">₹${dailySummary.collectedAmount/1000}K</h6>
                    </div>
                  </div>
                  <div class="col-4">
                    <div>
                      <small class="text-muted d-block">Balance</small>
                      <h6 class="mb-0 text-warning">₹${dailySummary.totalBalanceAmount/1000}K</h6>
                    </div>
                  </div>
                </div>

                <!-- Bar Chart -->
                <div class="bg-light rounded-3 p-3 mb-4">
                  <h6 class="text-center mb-3">Today's Financial Summary</h6>
                  <canvas id="paymentBarChart" height="180"></canvas>
                </div>

                <!-- Expiry Carousel -->
                <div class="expiry-carousel">
                  <h6 class="section-title mb-3"><i class="fas fa-exclamation-triangle text-warning me-2"></i>Product Alerts</h6>
                  <div id="expiryNoticeCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4200">
                    <div class="carousel-inner">
                      <c:forEach var="product" items="${productList}" varStatus="loop">
                        <div class="carousel-item ${loop.index == 0 ? 'active' : ''}">
                          <div class="card border-0 mx-auto" style="max-width: 100%;">
                            <div class="card-header bg-gradient text-white text-center" style="background: linear-gradient(45deg, #dc3545, #e74c3c);">
                              <h6 class="mb-0">⚠️ Expiry Alert #${loop.index + 1}</h6>
                            </div>
                            <div class="card-body text-center">
                              <h6 class="card-title text-danger mb-2">${product.name}</h6>
                              <div class="d-flex justify-content-between align-items-center">
                                <small><strong>Qty:</strong> ${product.quantity}</small>
                                <span class="badge bg-danger badge-modern">${product.expiresIn} days left</span>
                              </div>
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
          </div>

          <!-- Recent Customers -->
          <div class="col-lg-4">
            <div class="card enhanced-card h-100 fade-in-up">
              <div class="card-body">
                <div class="section-header">
                  <h6 class="section-title mb-0">Recent Customers <small class="text-muted fw-normal">(Latest 5)</small></h6>
                </div>

                <div class="customer-list" style="max-height: 70vh; overflow-y: auto;">
                  <c:forEach items="${custmers}" var="custmer" varStatus="status">
                    <div class="customer-mini-card p-3 mb-3">
                      <div class="d-flex align-items-start">
                        <div class="customer-avatar me-3">
                          ${fn:substring(custmer.custName, 0, 1)}
                        </div>
                        <div class="flex-grow-1">
                          <div class="d-flex justify-content-between align-items-start mb-2">
                            <h6 class="text-primary fw-semibold mb-0">${custmer.custName}</h6>
                            <a href="${pageContext.request.contextPath}/company/update-customer/${custmer.id}"
                               class="text-primary" title="Edit Customer">
                              <i class="fas fa-edit"></i>
                            </a>
                          </div>

                          <div class="text-muted small mb-2">
                            <i class="fas fa-map-marker-alt me-1"></i>${custmer.address}
                          </div>

                          <div class="text-muted small mb-3">
                            <a href="https://wa.me/${custmer.phoneNo}" target="_blank" class="text-success text-decoration-none">
                              <i class="fab fa-whatsapp me-1"></i>${custmer.phoneNo}
                            </a>
                          </div>

                          <div class="d-flex gap-1 mb-3 flex-wrap">
                            <span class="badge bg-primary badge-modern">Total ₹${custmer.totalAmount}</span>
                            <span class="badge bg-success badge-modern">Paid ₹${custmer.paidAmout}</span>
                            <span class="badge bg-danger badge-modern">Bal ₹${custmer.currentOusting}</span>
                          </div>

                          <div class="d-flex gap-2 flex-wrap">
                            <form method="get" action="${pageContext.request.contextPath}/company/get-cust-by-id" class="flex-fill">
                              <input type="hidden" name="custid" value="${custmer.id}" />
                              <button class="btn btn-outline-primary btn-sm btn-modern w-100" type="submit">
                                <i class="fas fa-file-invoice me-1"></i>Invoice
                              </button>
                            </form>
                            <form method="get" action="${pageContext.request.contextPath}/company/get-bal-credit-page/${custmer.id}" class="flex-fill">
                              <button class="btn btn-outline-success btn-sm btn-modern w-100" type="submit">
                                <i class="fas fa-donate me-1"></i>Deposit
                              </button>
                            </form>
                            <form method="get" action="${pageContext.request.contextPath}/company/cust-history" target="_blank" class="flex-fill">
                              <input type="hidden" name="custid" value="${custmer.id}" />
                              <button class="btn btn-outline-warning btn-sm btn-modern w-100" type="submit">
                                <i class="fas fa-list-ol me-1"></i>History
                              </button>
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

        <!-- EXPENSES SECTION -->
        <div class="row g-4 mt-2">
          <!-- Daily Expenses -->
          <div class="col-lg-6">
            <div class="card enhanced-card fade-in-up">
              <div class="card-body">
                <div class="section-header">
                  <h6 class="section-title mb-0">
                    <i class="fa-solid fa-calendar-day me-2 text-primary"></i>Today's Expenses
                  </h6>
                </div>

                <div class="expenses-container" style="max-height: 400px; overflow-y: auto;">
                  <c:forEach var="exp" items="${dailyExpenses}" varStatus="status">
                    <div class="expense-item p-3 mb-3">
                      <div class="d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center">
                          <div class="expense-icon me-3">
                            <i class="fa-solid fa-receipt"></i>
                          </div>
                          <div>
                            <h6 class="fw-semibold mb-1">${exp.expenseName}</h6>
                            <small class="text-muted">
                              <i class="fas fa-calendar me-1"></i>
                              <fmt:formatDate value="${exp.date}" pattern="dd MMM yyyy"/>
                            </small>
                          </div>
                        </div>
                        <div class="text-end">
                          <div class="fs-5 fw-bold text-danger">
                            ₹<fmt:formatNumber value="${exp.amount}" type="number"/>
                          </div>
                        </div>
                      </div>
                    </div>
                  </c:forEach>

                  <c:if test="${empty dailyExpenses}">
                    <div class="text-center py-5">
                      <div class="text-muted">
                        <i class="fas fa-inbox fs-1 mb-3"></i>
                        <p>No expenses recorded today</p>
                        <a href="${pageContext.request.contextPath}/expenses" class="btn btn-primary btn-modern">
                          <i class="fas fa-plus me-1"></i>Add Expense
                        </a>
                      </div>
                    </div>
                  </c:if>
                </div>
              </div>
            </div>
          </div>

          <!-- Expenses Trend Chart -->
          <div class="col-lg-6">
            <div class="card chart-card h-100 fade-in-up">
              <div class="card-body">
                <div class="section-header">
                  <h6 class="section-title mb-0">
                    <i class="fa-solid fa-chart-line me-2 text-primary"></i>Expenses Trend
                  </h6>
                </div>

                <div class="chart-container bg-light rounded-3 p-3">
                  <canvas id="expensesTrendChart" height="300"></canvas>
                </div>
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
        <button type="button" class="btn btn-primary btn-modern" id="confirmButton">
          <i class="fa fa-check me-1"></i>Confirm & Save
        </button>
      </div>
    </form>
  </div>
</div>

<!-- Confirm Modal -->
<div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow-lg">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title">Confirm Customer Details</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <ul class="list-unstyled ms-2">
          <li class="mb-2"><strong>Name:</strong> <span id="modalCustName"></span></li>
          <li class="mb-2"><strong>Email:</strong> <span id="modalEmail"></span></li>
          <li class="mb-2"><strong>Address:</strong> <span id="modalAddress"></span></li>
          <li class="mb-2"><strong>Mobile:</strong> <span id="modalPhone"></span></li>
          <li class="mb-2"><strong>Balance:</strong> ₹<span id="modalBalance"></span></li>
        </ul>
      </div>
      <div class="modal-footer">
        <button class="btn btn-outline-secondary btn-modern" data-bs-dismiss="modal">Cancel</button>
        <button class="btn btn-primary btn-modern" id="submitConfirmed">Yes, Add Customer</button>
      </div>
    </div>
  </div>
</div>

<!-- Expiring Products Modal -->
<div class="modal fade" id="expiringModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content border-0 shadow-lg">
      <div class="modal-header" style="background: linear-gradient(45deg, #ffc107, #ff8f00); color: white;">
        <h5 class="modal-title">⚠️ Product Expiration Report</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="table-responsive">
          <table class="table table-hover align-middle">
            <thead class="table-warning">
            <tr>
              <th class="text-center">#</th>
              <th>Product Name</th>
              <th class="text-center">Available Quantity</th>
              <th class="text-center">Expires In</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="product" items="${productList}" varStatus="loop">
              <tr>
                <td class="text-center fw-bold">${loop.index + 1}</td>
                <td>
                  <div class="d-flex align-items-center">
                    <div class="bg-danger bg-opacity-10 rounded-circle p-2 me-2">
                      <i class="fas fa-box text-danger"></i>
                    </div>
                    <span class="fw-semibold">${product.name}</span>
                  </div>
                </td>
                <td class="text-center">
                  <span class="badge bg-info badge-modern">${product.quantity} Nos.</span>
                </td>
                <td class="text-center">
                  <span class="badge bg-danger badge-modern">${product.expiresIn} days left</span>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-outline-secondary btn-modern" data-bs-dismiss="modal">Close</button>
      </div>
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

  const toK = v => v >= 1000 ? (v/1000).toFixed(1)+'K' : v;

const ctx = document.getElementById('paymentPieChart').getContext('2d');

// Gradient 1 – Purple Blue
const gradient1 = ctx.createLinearGradient(0, 0, 0, 400);
gradient1.addColorStop(0, '#6a11cb'); // rich purple
gradient1.addColorStop(1, '#2575fc'); // bright blue

// Gradient 2 – Pink Red
const gradient2 = ctx.createLinearGradient(0, 0, 0, 400);
gradient2.addColorStop(0, '#ff416c'); // hot pink
gradient2.addColorStop(1, '#ff4b2b'); // red-orange

// Gradient 3 – Cyan Teal
const gradient3 = ctx.createLinearGradient(0, 0, 0, 400);
gradient3.addColorStop(0, '#00f260'); // bright green-cyan
gradient3.addColorStop(1, '#0575e6'); // deep blue

// Gradient 4 (optional extra) – Orange Yellow
const gradient4 = ctx.createLinearGradient(0, 0, 0, 400);
gradient4.addColorStop(0, '#f7971e'); // orange


// Enhanced Pie Chart with Canvas Gradients
new Chart(ctx, {
  type: 'doughnut',
  data: {
    labels: ['Total Amount', 'Balance Amount', 'Paid Amount'],
    datasets: [{
      data: [totalAmount, currentOusting, paidAmount],
      backgroundColor: [gradient1, gradient2, gradient3],
      borderWidth: 0,
      hoverOffset: 10
    }]
  },
  options: {
    responsive: true,
    cutout: '60%',
    plugins: {
      legend: {
        position: 'bottom',
        labels: {
          usePointStyle: true,
          padding: 20,
          font: { size: 12, weight: '500' }
        }
      },
      tooltip: {
        callbacks: {
          label: ctx => ctx.label + ': ₹' + toK(ctx.parsed)
        }
      }
    }
  }
});


  // Enhanced Bar Chart
  const totalAmount1 = ${dailySummary.totalAmount != null ? dailySummary.totalAmount : 0};
  const paidAmount1 = ${dailySummary.collectedAmount != null ? dailySummary.collectedAmount : 0};
  const currentOusting1 = ${dailySummary.totalBalanceAmount != null ? dailySummary.totalBalanceAmount : 0};

  new Chart(document.getElementById('paymentBarChart').getContext('2d'), {
    type: 'bar',
    data: {
      labels: ['Total Amt', 'Collected', 'Balance'],
      datasets: [{
        label: 'Amount',
        data: [totalAmount1, paidAmount1, currentOusting1],
        backgroundColor: [
          'rgba(13, 110, 253, 0.8)',
          'rgba(25, 135, 84, 0.8)',
          'rgba(255, 193, 7, 0.8)'
        ],
        borderColor: [
          'rgb(13, 110, 253)',
          'rgb(25, 135, 84)',
          'rgb(255, 193, 7)'
        ],
        borderWidth: 2,
        borderRadius: 8,
        borderSkipped: false
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: c => '₹' + toK(c.raw)
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: toK
          },
          grid: {
            color: 'rgba(0,0,0,0.1)'
          }
        },
        x: {
          grid: {
            display: false
          }
        }
      }
    }
  });

  // Enhanced Line Chart for Expenses Trend
  const trendLabels = [
    <c:forEach var="exp" items="${dailyExpenses}" varStatus="s">
      '<fmt:formatDate value="${exp.date}" pattern="dd MMM"/>'<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];
  const trendData = [
    <c:forEach var="exp" items="${dailyExpenses}" varStatus="s">
      ${exp.amount}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  new Chart(document.getElementById('expensesTrendChart').getContext('2d'), {
    type: 'line',
    data: {
      labels: trendLabels,
      datasets: [{
        label: 'Daily Expenses',
        data: trendData,
        borderColor: 'rgb(220, 53, 69)',
        backgroundColor: 'rgba(220, 53, 69, 0.1)',
        fill: true,
        tension: 0.4,
        pointBackgroundColor: 'rgb(220, 53, 69)',
        pointBorderColor: '#fff',
        pointBorderWidth: 2,
        pointRadius: 6,
        pointHoverRadius: 8
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: false },
        tooltip: {
          mode: 'index',
          intersect: false,
          callbacks: {
            label: c => '₹' + c.raw.toLocaleString()
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: function(value) {
              return '₹' + value.toLocaleString();
            }
          },
          grid: {
            color: 'rgba(0,0,0,0.1)'
          }
        },
        x: {
          grid: {
            display: false
          }
        }
      },
      interaction: {
        intersect: false,
        mode: 'index'
      }
    }
  });

  // Initialize animations on scroll
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  };

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
      }
    });
  }, observerOptions);

  document.querySelectorAll('.fade-in-up').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'all 0.6s ease-out';
    observer.observe(el);
  });
</script>
</body>
</html>