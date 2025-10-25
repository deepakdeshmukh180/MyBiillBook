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
  <title>All Customers - BillMatePro</title>

  <!-- CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>

  <style>
    :root {
      --primary-color: #2247a5;
      --primary-dark: #145fa0;
      --success-color: #10b981;
      --danger-color: #ef4444;
      --warning-color: #f59e0b;
      --bg-light: #f8fafc;
      --bg-dark: #0f172a;
      --card-light: #ffffff;
      --card-dark: #1e293b;
      --text-light: #1e293b;
      --text-dark: #f1f5f9;
      --border-light: #e2e8f0;
      --border-dark: #334155;
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Inter', sans-serif;
      background: var(--bg-color);
      color: var(--text-color);
      min-height: 100vh;
      transition: all 0.3s ease;
    }

    /* Theme Variables */
    [data-theme="light"] {
      --bg-color: var(--bg-light);
      --text-color: var(--text-light);
      --card-bg: var(--card-light);
      --border-color: var(--border-light);
    }

    [data-theme="dark"] {
      --bg-color: var(--bg-dark);
      --text-color: var(--text-dark);
      --card-bg: var(--card-dark);
      --border-color: var(--border-dark);
    }

    /* Navigation */
    .sb-topnav {
      background: var(--card-bg);
      border-bottom: 1px solid var(--border-color);
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .sb-topnav .navbar-brand img {
      transition: transform 0.3s ease;
    }

    .sb-topnav .navbar-brand img:hover {
      transform: scale(1.05);
    }

    /* Sidebar */
    .sb-sidenav {
      background: var(--card-bg);
      border-right: 1px solid var(--border-color);
    }

    .sb-sidenav .nav-link {
      color: var(--text-color);
      border-radius: 8px;
      margin: 0.25rem 1rem;
      transition: all 0.3s ease;
    }

    .sb-sidenav .nav-link:hover {
      background: rgba(34, 71, 165, 0.1);
      transform: translateX(4px);
    }

    .sb-sidenav .nav-link.active {
      background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
      color: white;
    }

    /* Customer Cards Grid */
    .cards-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
      gap: 1.5rem;
      padding: 1rem 0;
    }

    .customer-card {
      background: var(--card-bg);
      border: 1px solid var(--border-color);
      border-radius: 16px;
      padding: 1.5rem;
      transition: all 0.3s ease;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
      animation: fadeInUp 0.6s ease forwards;
      opacity: 0;
      transform: translateY(20px);
    }

    .customer-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
    }

    .card-header {
      display: flex;
      align-items: center;
      gap: 1rem;
      margin-bottom: 1rem;
      padding-bottom: 1rem;
      border-bottom: 1px solid var(--border-color);
    }

    .customer-avatar {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      background: linear-gradient(45deg, var(--primary-color), var(--success-color));
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 16px;
      flex-shrink: 0;
    }

    .customer-name {
      font-size: 1.1rem;
      font-weight: 600;
      color: var(--text-color);
      margin: 0;
      line-height: 1.2;
    }

    .card-content {
      margin-bottom: 1.5rem;
    }

    .info-item {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      margin-bottom: 0.75rem;
    }

    .info-icon {
      width: 32px;
      height: 32px;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      flex-shrink: 0;
    }

    .address-icon {
      background: rgba(239, 68, 68, 0.1);
      color: var(--danger-color);
    }

    .phone-icon {
      background: rgba(16, 185, 129, 0.1);
      color: var(--success-color);
    }

    .info-text {
      font-size: 0.9rem;
      color: var(--text-color);
      opacity: 0.8;
      line-height: 1.3;
    }

    .whatsapp-link {
      text-decoration: none;
      color: inherit;
      transition: color 0.3s ease;
    }

    .whatsapp-link:hover {
      color: var(--success-color);
    }

    /* Amount Section */
    .amount-section {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 0.75rem;
      margin-bottom: 1.5rem;
    }

    .amount-card {
      text-align: center;
      padding: 0.75rem;
      border-radius: 12px;
      border: 1px solid var(--border-color);
    }

    .total-card {
      background: rgba(34, 71, 165, 0.05);
      border-color: rgba(34, 71, 165, 0.2);
    }

    .paid-card {
      background: rgba(16, 185, 129, 0.05);
      border-color: rgba(16, 185, 129, 0.2);
    }

    .balance-card {
      background: rgba(245, 158, 11, 0.05);
      border-color: rgba(245, 158, 11, 0.2);
    }

    .amount-label {
      font-size: 0.75rem;
      font-weight: 500;
      color: var(--text-color);
      opacity: 0.7;
      margin-bottom: 0.25rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .amount-value {
      font-size: 0.8em;
      font-weight: 500;
      color: var(--text-color);
    }

    /* Action Buttons */
    .action-buttons {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 0.5rem;
    }

    .action-btn {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
      padding: 0.6rem;
      border-radius: 8px;
      text-decoration: none;
      font-size: 0.85rem;
      font-weight: 500;
      transition: all 0.3s ease;
      border: 1px solid transparent;
    }

    .btn-invoice {
      background: rgba(34, 71, 165, 0.1);
      color: var(--primary-color);
      border-color: rgba(34, 71, 165, 0.2);
    }

    .btn-deposit {
      background: rgba(16, 185, 129, 0.1);
      color: var(--success-color);
      border-color: rgba(16, 185, 129, 0.2);
    }

    .btn-history {
      background: rgba(245, 158, 11, 0.1);
      color: var(--warning-color);
      border-color: rgba(245, 158, 11, 0.2);
    }

    .btn-edit {
      background: rgba(139, 69, 19, 0.1);
      color: #8b4513;
      border-color: rgba(139, 69, 19, 0.2);
    }

    .action-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    /* Search Box */
    .form-control {
      background: var(--card-bg);
      border: 2px solid var(--border-color);
      border-radius: 12px;
      transition: all 0.3s ease;
      color: var(--text-color);
    }

    .form-control:focus {
      border-color: var(--primary-color);
      box-shadow: 0 0 0 3px rgba(34, 71, 165, 0.1);
      background: var(--card-bg);
      color: var(--text-color);
    }

    /* Theme Toggle */
    .theme-toggle {
      position: fixed;
      top: 2rem;
      right: 2rem;
      width: 50px;
      height: 50px;
      border-radius: 50%;
      background: var(--card-bg);
      border: 2px solid var(--border-color);
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s ease;
      z-index: 1000;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .theme-toggle:hover {
      transform: scale(1.1);
    }

    .theme-toggle i {
      font-size: 1.2rem;
      color: var(--primary-color);
    }

    /* Alerts */
    .alert {
      border: none;
      border-radius: 12px;
      border: 1px solid var(--border-color);
    }

    /* Pagination */
    .pagination .page-link {
      background: var(--card-bg);
      border-color: var(--border-color);
      color: var(--text-color);
      border-radius: 8px;
      margin: 0 2px;
    }

    .pagination .page-link:hover {
      background: var(--primary-color);
      border-color: var(--primary-color);
      color: white;
    }

    .pagination .page-item.active .page-link {
      background: var(--primary-color);
      border-color: var(--primary-color);
    }

    /* Animations */
    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* Responsive */
    @media (max-width: 768px) {
      .cards-grid {
        grid-template-columns: 1fr;
        gap: 1rem;
      }

      .theme-toggle {
        top: 1rem;
        right: 1rem;
        width: 45px;
        height: 45px;
      }

      .action-buttons {
        grid-template-columns: 1fr;
      }

      .amount-section {
        grid-template-columns: 1fr;
        gap: 0.5rem;
      }
    }

    /* Loading spinner */
    .spinner-border {
      width: 2rem;
      height: 2rem;
    }

    /* No customers found */
    .no-customers {
      grid-column: 1 / -1;
      text-align: center;
      padding: 3rem;
      color: var(--text-color);
      opacity: 0.7;
      font-size: 1.1rem;
      background: var(--card-bg);
      border: 1px solid var(--border-color);
      border-radius: 16px;
    }
    .brand-gradient {
            background: linear-gradient(135deg, #3c7bff, #70a1ff);
            color: #fff;
        }

        .shadow-soft {
            box-shadow: 0 6px 18px rgba(0, 0, 0, .08);
        }

        .rounded-lg {
            border-radius: var(--radius-lg);
        }

        .search-bar {
            max-width: 350px;
        }

        /* Invoice Cards Styling */
        .invoice-card {
            border: none;
            border-radius: 12px;
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
        }

        .invoice-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .invoice-card.paid {
            border-left: 4px solid #28a745;
            background: linear-gradient(135deg, #ffffff, var(--success-light));
        }

        .invoice-card.partial {
            border-left: 4px solid #ffc107;
            background: linear-gradient(135deg, #ffffff, var(--warning-light));
        }

        .invoice-card.credit {
            border-left: 4px solid #dc3545;
            background: linear-gradient(135deg, #ffffff, var(--danger-light));
        }

        .invoice-header {
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 12px;
            margin-bottom: 12px;
        }

        .invoice-number {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--brand);
            text-decoration: none;
        }

        .invoice-number:hover {
            color: #0a58ca;
        }

        .customer-name {
            font-size: 0.9rem;
            color: #6c757d;
            text-transform: capitalize;
            margin-bottom: 0;
        }

        .amount-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            margin-bottom: 12px;
        }

        .amount-item {
            text-align: center;
            padding: 8px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.7);
        }

        .amount-label {
            font-size: 0.75rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }

        .amount-value {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--ink);
        }

        .status-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
            padding-top: 8px;
        }

        .qty-badge {
            background: #f8f9fa;
            color: var(--ink);
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .no-invoices {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .spinner-container {
            text-align: center;
            padding: 60px 20px;
        }

        /* Sidebar */
        #layoutSidenav_nav {
            transition: transform 0.3s ease-in-out;
            width: 250px;
        }

        .sb-sidenav-toggled #layoutSidenav_nav {
            transform: translateX(-250px);
        }

        /* Overlay for mobile */
        .overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1049;
            display: none;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .overlay.active {
            display: block;
            opacity: 1;
        }

        /* Mobile Sidebar */
        @media (max-width: 768px) {
            #layoutSidenav_nav {
                position: fixed;
                top: 0; left: -250px;
                height: 100%;
                z-index: 1050;
                transform: translateX(-250px);
            }

            .sb-sidenav-toggled #layoutSidenav_nav {
                transform: translateX(0);
            }

            body.sidebar-open {
                overflow: hidden;
            }

            .amount-grid {
                grid-template-columns: 1fr;
                gap: 6px;
            }
        }

        /* Accessibility: links & buttons */
        a, button {
            color: var(--brand);
            transition: color 0.2s;
            cursor: pointer;
        }

        a:hover, button:hover,
        a:focus, button:focus {
            color: #0a58ca;
            outline: none;
        }
  </style>
</head>

<body class="sb-nav-fixed" data-theme="light">

<!-- Theme Toggle -->
<div class="theme-toggle" onclick="toggleTheme()" title="Toggle dark/light mode">
    <i class="fas fa-moon" id="theme-icon"></i>
</div>

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-light">
   <a class="navbar-brand ps-3 fw-bold" href="${pageContext.request.contextPath}/login/home">
      <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgwIiBoZWlnaHQ9IjQwIiB2aWV3Qm94PSIwIDAgMTgwIDQwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iNSIgeTE9IjMiIHgyPSIyNSIgeTI9IjI3IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMyMjQ3QTUiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMTQ1RkEwIi8+CjwvbGluZWFyR3JhZGllbnQ+CjxsaW5lYXJHcmFkaWVudCBpZD0icGFpbnQxX2xpbmVhciIgeDE9IjE3IiB5MT0iMTMiIHgyPSIyOCIgeTI9IjI0IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMxMEI5ODEiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDU5NjY5Ii8+CjwvbGluZWFyR3JhZGllbnQ+CjwvZGVmcz4KPCEtLSBEb2N1bWVudC9CaWxsIEljb24gLS0+CjxyZWN0IHg9IjUiIHk9IjMiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyNCIgcng9IjMiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcikiLz4KPCEtLSBMaW5lcyBvbiBkb2N1bWVudCAtLT4KPHBhdGggZD0iTTkgOWg4bS04IDRINW0tNSAzaDciIHN0cm9rZT0iI2ZmZmZmZiIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPCEtLSBDaGVja21hcmsgLS0+CjxjaXJjbGUgY3g9IjIyLjUiIGN5PSIxOC41IiByPSI1LjUiIGZpbGw9InVybCgjcGFpbnQxX2xpbmVhcikiLz4KPHBhdGggZD0ibTIwIDE4LjUgMiAyIDQtNCIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8IS0tIFRleHQgLS0+Cjx0ZXh0IHg9IjM1IiB5PSIxNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmb250LXdlaWdodD0iNzAwIiBmaWxsPSIjMjI0N0E1Ij4KQmlsbE1hdGVQcm88L3RleHQ+Cjx0ZXh0IHg9IjM1IiB5PSIyNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjgiIGZpbGw9IiM2Mzc1OEEiPgpZb3VyIEJpbGxpbmcgUGFydG5lcjwvdGV4dD4KPC9zdmc+"
           alt="BillMatePro" style="height: 50px; margin-right: 8px;">
    </a>
  <button class="btn btn-outline-primary btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>

  <div class="ms-auto d-flex align-items-center gap-3 pe-3">
    <c:if test="${not empty productList}">
    <div class="position-relative" role="button" onclick="openNotifications()">
      <i class="bi bi-bell fs-5 text-primary"></i>
      <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
        ${fn:length(productList)}
      </span>
    </div>
    </c:if>
    <div class="dropdown">
      <a class="nav-link dropdown-toggle text-primary" id="navbarDropdown" href="#" data-bs-toggle="dropdown">
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
    <nav class="sb-sidenav accordion" id="sidenavAccordion">
      <div class="sb-sidenav-menu">
        <div class="nav">
          <div class="sb-sidenav-menu-heading">Core</div>
          <a class="nav-link" href="${pageContext.request.contextPath}/login/home">
           <div class="sb-nav-link-icon"><i class="fas fa-home"></i></div> Home

          </a>

          <div class="sb-sidenav-menu-heading">Interface</div>
          <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts">
            <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div> Menu
            <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
          </a>
          <div class="collapse show" id="collapseLayouts" data-bs-parent="#sidenavAccordion">
            <nav class="sb-sidenav-menu-nested nav">
              <a class="nav-link active" href="${pageContext.request.contextPath}/company/get-all-customers">
                <i class="fas fa-user-friends me-2"></i>All Customers
              </a>
              <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">
                <i class="fas fa-file-invoice me-2"></i>Invoices
              </a>
              <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">
                <i class="fas fa-chart-line me-2"></i>Daily/Monthly Reports
              </a>
              <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">
                <i class="fas fa-leaf me-2"></i>Products
              </a>
            </nav>
          </div>

          <div class="sb-sidenav-menu-heading">Settings</div>
          <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
            <div class="sb-nav-link-icon"><i class="fas fa-cog"></i></div> Account Settings
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/company/export-to-pdf">
            <div class="sb-nav-link-icon"><i class="fas fa-file-export"></i></div> Export Customers
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/expenses">
            <div class="sb-nav-link-icon"><i class="fas fa-wallet"></i></div> Daily Expenses
          </a>
        </div>
      </div>
      <div class="sb-sidenav-footer">
        <div class="small">Logged in as:</div>
        ${pageContext.request.userPrincipal.name}
      </div>
    </nav>
  </div>

  <!-- Main Content -->
  <div id="layoutSidenav_content">
    <main>
      <div class="container-fluid px-4 mt-4">

        <!-- Success Alert -->
        <c:if test="${not empty msg}">
          <div class="alert alert-success alert-dismissible fade show" role="alert" id="success-alert">
            <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
        </c:if>

        <!-- Search Section -->
        <div class="row mb-4">
          <div class="col-md-8 mx-auto">
            <div class="input-group">
              <input type="text" id="searchBox" class="form-control" placeholder="Search customers by name or phone...">
              <button class="btn btn-outline-secondary" type="button" onclick="location.reload();">
                <i class="fas fa-sync-alt me-1"></i> Refresh
              </button>
            </div>
          </div>
        </div>

        <!-- Loading Indicator -->
        <div id="loader" class="text-center my-4" style="display: none;">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="text-muted mt-2">Searching customers...</p>
        </div>

        <!-- Customer Cards Container -->

<div id="invoiceCardsContainer" class="row g-3">
                <c:forEach var="invoice" items="${invoices}">
                    <div class="col-12 col-sm-6 col-lg-4 col-xl-3">
                        <div class="card invoice-card shadow-soft
                            <c:choose>
                                <c:when test='${invoice.invoiceType eq "CREDIT"}'>credit</c:when>
                                <c:when test='${invoice.invoiceType eq "PARTIAL"}'>partial</c:when>
                                <c:when test='${invoice.invoiceType eq "PAID"}'>paid</c:when>
                            </c:choose>
                        " onclick="window.open('${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}', '_blank')">
                            <div class="card-body d-flex flex-column">
                                <!-- Header -->
                                <div class="invoice-header">
                                    <a href="${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}"
                                       class="invoice-number" target="_blank" onclick="event.stopPropagation()">
                                        #${invoice.invoiceId}
                                    </a>
                                    <p class="customer-name">${invoice.custName}</p>
                                </div>

                                <!-- Amount Grid -->
                                <div class="amount-grid">
                                    <div class="amount-item">
                                        <div class="amount-label">Invoice</div>
                                        <div class="amount-value">₹<fmt:formatNumber value="${invoice.totInvoiceAmt}" type="number" minFractionDigits="2" /></div>
                                    </div>
                                    <div class="amount-item">
                                        <div class="amount-label">Balance</div>
                                        <div class="amount-value">₹<fmt:formatNumber value="${invoice.balanceAmt}" type="number" minFractionDigits="2" /></div>
                                    </div>
                                    <div class="amount-item">
                                        <div class="amount-label">Discount</div>
                                        <div class="amount-value">₹<fmt:formatNumber value="${invoice.discount}" type="number" minFractionDigits="2" /></div>
                                    </div>
                                    <div class="amount-item">
                                        <div class="amount-label">Paid</div>
                                        <div class="amount-value">₹<fmt:formatNumber value="${invoice.advanAmt}" type="number" minFractionDigits="2" /></div>
                                    </div>
                                </div>

                                <!-- Footer -->
                                <div class="status-footer">
                                    <span class="qty-badge">
                                        <i class="fas fa-boxes me-1"></i>${invoice.totQty} items
                                    </span>
                                    <span class="badge
                                        <c:choose>
                                            <c:when test='${invoice.invoiceType eq "CREDIT"}'>bg-danger</c:when>
                                            <c:when test='${invoice.invoiceType eq "PARTIAL"}'>bg-warning text-dark</c:when>
                                            <c:when test='${invoice.invoiceType eq "PAID"}'>bg-success</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>
                                    ">
                                        ${invoice.invoiceType}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
        <div id="paginationContainer" class="d-flex justify-content-center mt-4">
          <nav>
            <ul class="pagination">
              <c:if test="${page > 0}">
                <li class="page-item">
                  <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${page - 1}">
                    <i class="fas fa-chevron-left"></i> Previous
                  </a>
                </li>
              </c:if>

              <c:forEach begin="${page - 2 < 0 ? 0 : page - 2}"
                         end="${page + 2 >= totalPages ? totalPages - 1 : page + 2}" var="i">
                <li class="page-item ${page == i ? 'active' : ''}">
                  <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${i}">
                    ${i + 1}
                  </a>
                </li>
              </c:forEach>

              <c:if test="${page < totalPages - 1}">
                <li class="page-item">
                  <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${page + 1}">
                    Next <i class="fas fa-chevron-right"></i>
                  </a>
                </li>
              </c:if>
            </ul>
          </nav>
        </div>
        </c:if>

      </div>
    </main>
  </div>
</div>

<!-- Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
const searchInput = document.getElementById('searchBox');
const cardContainer = document.getElementById('invoiceCardsContainer'); // Use JSP container
const paginationContainer = document.getElementById('paginationContainer');
let debounceTimer;

// Save original cards & pagination
const originalCards = cardContainer.innerHTML;
const originalPagination = paginationContainer.innerHTML;

// Spinner function
function showSpinner() {
    cardContainer.innerHTML =
        '<div class="col-12 text-center py-4">' +
            '<div class="spinner-border text-primary" role="status"></div>' +
            '<div class="mt-2 text-muted small">Searching invoices...</div>' +
        '</div>';
}

// Render one invoice card
function renderInvoiceCard(inv) {
    var cardTypeClass = '', badgeClass = '';
    if (inv.invoiceType === "CREDIT") { cardTypeClass = 'credit'; badgeClass = 'bg-danger'; }
    else if (inv.invoiceType === "PARTIAL") { cardTypeClass = 'partial'; badgeClass = 'bg-warning text-dark'; }
    else if (inv.invoiceType === "PAID") { cardTypeClass = 'paid'; badgeClass = 'bg-success'; }
    else { cardTypeClass = ''; badgeClass = 'bg-secondary'; }

    return '' +
    '<div class="col-12 col-sm-6 col-lg-4 col-xl-3">' +
        '<div class="card invoice-card shadow-soft ' + cardTypeClass + '" onclick="window.open(\'' + contextPath + '/company/get-invoice/' + inv.custId + '/' + inv.invoiceId + '\', \'_blank\')">' +
            '<div class="card-body d-flex flex-column">' +
                '<div class="invoice-header">' +
                    '<a href="' + contextPath + '/company/get-invoice/' + inv.custId + '/' + inv.invoiceId + '" class="invoice-number" target="_blank" onclick="event.stopPropagation()">' +
                        '#' + inv.invoiceId +
                    '</a>' +
                    '<p class="customer-name">' + inv.custName + '</p>' +
                '</div>' +
                '<div class="amount-grid">' +
                    '<div class="amount-item"><div class="amount-label">Invoice</div><div class="amount-value">₹' + Number(inv.totInvoiceAmt || 0).toFixed(2) + '</div></div>' +
                    '<div class="amount-item"><div class="amount-label">Balance</div><div class="amount-value">₹' + Number(inv.balanceAmt || 0).toFixed(2) + '</div></div>' +
                    '<div class="amount-item"><div class="amount-label">Discount</div><div class="amount-value">₹' + Number(inv.discount || 0).toFixed(2) + '</div></div>' +
                    '<div class="amount-item"><div class="amount-label">Paid</div><div class="amount-value">₹' + Number(inv.advanAmt || 0).toFixed(2) + '</div></div>' +
                '</div>' +
                '<div class="status-footer">' +
                    '<span class="qty-badge"><i class="fas fa-boxes me-1"></i>' + (inv.totQty || 0) + ' items</span>' +
                    '<span class="badge ' + badgeClass + '">' + inv.invoiceType + '</span>' +
                '</div>' +
            '</div>' +
        '</div>' +
    '</div>';
}

// Search functionality
searchInput.addEventListener('input', function () {
    var query = this.value.trim();
    clearTimeout(debounceTimer);

    if (query.length < 3) {
        cardContainer.innerHTML = originalCards;
        paginationContainer.innerHTML = originalPagination;
        paginationContainer.style.display = 'flex';
        return;
    }

    debounceTimer = setTimeout(function () {
        showSpinner();

        fetch(contextPath + '/company/search-invoices?query=' + encodeURIComponent(query))
            .then(function (res) {
                if (!res.ok) throw new Error("HTTP error " + res.status);
                return res.json();
            })
            .then(function (data) {
                cardContainer.innerHTML = '';
                if (!data || data.length === 0) {
                    cardContainer.innerHTML = '<div class="col-12 text-center text-muted py-4">No matching invoices found.</div>';
                    paginationContainer.style.display = 'none';
                    return;
                }
                paginationContainer.style.display = 'none';
                data.forEach(function (inv) {
                    cardContainer.insertAdjacentHTML('beforeend', renderInvoiceCard(inv));
                });
            })
            .catch(function (err) {
                console.error('Search error:', err);
                cardContainer.innerHTML = '<div class="col-12 text-center text-danger py-4">Error loading search results.</div>';
                paginationContainer.style.display = 'none';
            });
    }, 400);
});


// Sidebar toggle
document.getElementById('sidebarToggle').addEventListener('click', function () {
    document.body.classList.toggle('sb-sidenav-toggled');
    document.getElementById('sidebarOverlay').classList.toggle('active');
});
document.getElementById('sidebarOverlay').addEventListener('click', function () {
    document.body.classList.remove('sb-sidenav-toggled');
    this.classList.remove('active');
});
</script>
</body>
</html>