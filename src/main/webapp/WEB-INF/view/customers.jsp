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
      font-size: 1rem;
      font-weight: 700;
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
            <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div> Dashboard
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
        <div class="cards-grid" id="customerCardContainer">
          <c:forEach items="${custmers}" var="custmer" varStatus="status">
            <div class="customer-card" style="animation-delay: ${status.index * 0.1}s;">
              <div class="card-header">
                <div class="customer-avatar">
                  <c:set var="nameWords" value="${fn:split(custmer.custName, ' ')}" />
                  <c:choose>
                    <c:when test="${fn:length(nameWords) > 1}">
                      ${fn:substring(nameWords[0], 0, 1)}${fn:substring(nameWords[1], 0, 1)}
                    </c:when>
                    <c:otherwise>
                      ${fn:substring(custmer.custName, 0, 1)}${fn:substring(custmer.custName, 1, 2)}
                    </c:otherwise>
                  </c:choose>
                </div>
                <h3 class="customer-name">${custmer.custName}</h3>
              </div>

              <div class="card-content">
                <div class="info-item">
                  <div class="info-icon address-icon">
                    <i class="fas fa-map-marker-alt"></i>
                  </div>
                  <span class="info-text">${not empty custmer.address ? custmer.address : 'No address provided'}</span>
                </div>

                <div class="info-item">
                  <div class="info-icon phone-icon">
                    <i class="fab fa-whatsapp"></i>
                  </div>
                <c:choose>
                    <c:when test="${not empty custmer.phoneNo}">
                        <a href="https://wa.me/${custmer.phoneNo}" target="_blank" class="whatsapp-link">
                            <span class="info-text">${phoneNo}</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="info-text">No phone number</span>
                    </c:otherwise>
                </c:choose>


                </div>
              </div>

              <div class="amount-section">
                <div class="amount-card total-card">
                  <div class="amount-label">Total</div>
                  <div class="amount-value">₹<fmt:formatNumber value="${custmer.totalAmount}" pattern="#,##0.00"/></div>
                </div>
                <div class="amount-card paid-card">
                  <div class="amount-label">Paid</div>
                  <div class="amount-value">₹<fmt:formatNumber value="${custmer.paidAmout}" pattern="#,##0.00"/></div>
                </div>
                <div class="amount-card balance-card">
                  <div class="amount-label">Balance</div>
                  <div class="amount-value">₹<fmt:formatNumber value="${custmer.currentOusting}" pattern="#,##0.00"/></div>
                </div>
              </div>

              <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/company/get-cust-by-id?custid=${custmer.id}" class="action-btn btn-invoice">
                  <i class="fas fa-file-invoice"></i> Invoice
                </a>
                <a href="${pageContext.request.contextPath}/company/get-bal-credit-page/${custmer.id}" class="action-btn btn-deposit">
                  <i class="fas fa-donate"></i> Deposit
                </a>
                <a href="${pageContext.request.contextPath}/company/cust-history?custid=${custmer.id}" target="_blank" class="action-btn btn-history">
                  <i class="fas fa-list-ol"></i> History
                </a>
                <a href="${pageContext.request.contextPath}/company/update-customer/${custmer.id}" class="action-btn btn-edit">
                  <i class="fas fa-edit"></i> Edit
                </a>
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

<script>
// Global variables
const contextPath = '${pageContext.request.contextPath}';
const searchInput = document.getElementById('searchBox');
const cardContainer = document.getElementById('customerCardContainer');
const paginationContainer = document.getElementById('paginationContainer');
const loader = document.getElementById('loader');
let debounceTimer;

// Theme management
function toggleTheme() {
    const body = document.body;
    const themeIcon = document.getElementById('theme-icon');
    const currentTheme = body.getAttribute("data-theme");
    const newTheme = currentTheme === "dark" ? "light" : "dark";

    body.setAttribute("data-theme", newTheme);

    if (newTheme === "dark") {
        themeIcon.className = "fas fa-sun";
    } else {
        themeIcon.className = "fas fa-moon";
    }

    localStorage.setItem('theme', newTheme);
}

// Initialize theme on page load
function initializeTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    const body = document.body;
    const themeIcon = document.getElementById('theme-icon');

    body.setAttribute("data-theme", savedTheme);

    if (savedTheme === "dark") {
        themeIcon.className = "fas fa-sun";
    } else {
        themeIcon.className = "fas fa-moon";
    }
}

// Utility functions
function showLoader() {
    loader.style.display = 'block';
}

function hideLoader() {
    loader.style.display = 'none';
}

function formatNumber(num) {
    if (num === null || num === undefined) return '0.00';
    return parseFloat(num).toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function truncateText(text, maxLength) {
    if (!text || text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
}

// Generate avatar initials
function getInitials(name) {
    if (!name) return 'NA';
    const words = name.trim().split(/\s+/);
    if (words.length > 1) {
        return words[0].charAt(0).toUpperCase() + words[1].charAt(0).toUpperCase();
    }
    return name.charAt(0).toUpperCase() + (name.charAt(1) || '').toUpperCase();
}

// Render customer cards
function renderCards(customers) {
    if (!customers || customers.length === 0) {
        cardContainer.innerHTML = '<div class="no-customers">No customers found matching your search.</div>';
        return;
    }

    const fragment = document.createDocumentFragment();

    customers.forEach(function (customer, index) {
        if (!customer || !customer.custName) {
            console.warn('Invalid customer data at index', index);
            return;
        }

        const card = document.createElement('div');
        card.className = 'customer-card';
        card.style.animationDelay = (index * 0.1) + 's';

        const initials = getInitials(customer.custName);
        const address = customer.address || 'Address not provided';
        const phoneNo = customer.phoneNo || '';
        const totalAmount = customer.totalAmount || 0;
        const paidAmount = customer.paidAmout || customer.paidAmount || 0;
        const currentOusting = customer.currentOusting || customer.balance || 0;

        card.innerHTML = `
            <div class="card-header">
                <div class="customer-avatar">${initials}</div>
                <h3 class="customer-name">${escapeHtml(customer.custName)}</h3>
            </div>

            <div class="card-content">
                <div class="info-item">
                    <div class="info-icon address-icon">
                        <i class="fas fa-map-marker-alt"></i>
                    </div>
                    <span class="info-text" title="${escapeHtml(address)}">
                        ${escapeHtml(truncateText(address, 50))}
                    </span>
                </div>

                <div class="info-item">
                    <div class="info-icon phone-icon">
                        <i class="fab fa-whatsapp"></i>
                    </div>
                    <c:choose>
                        <c:when test="${not empty customer.phoneNo}">
                            <a href="https://wa.me/${customer.phoneNo}" target="_blank" class="whatsapp-link">
                                <span class="info-text">${customer.phoneNo}</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <span class="info-text">No phone number</span>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>

            <div class="amount-section">
                <div class="amount-card total-card">
                    <div class="amount-label">Total</div>
                    <div class="amount-value">₹${formatNumber(totalAmount)}</div>
                </div>
                <div class="amount-card paid-card">
                    <div class="amount-label">Paid</div>
                    <div class="amount-value">₹${formatNumber(paidAmount)}</div>
                </div>
                <div class="amount-card balance-card">
                    <div class="amount-label">Balance</div>
                    <div class="amount-value">₹${formatNumber(currentOusting)}</div>
                </div>
            </div>

            <div class="action-buttons">
                <a href="${contextPath}/company/get-cust-by-id?custid=${customer.id}" class="action-btn btn-invoice">
                    <i class="fas fa-file-invoice"></i> Invoice
                </a>
                <a href="${contextPath}/company/get-bal-credit-page/${customer.id}" class="action-btn btn-deposit">
                    <i class="fas fa-donate"></i> Deposit
                </a>
                <a href="${contextPath}/company/cust-history?custid=${customer.id}" target="_blank" class="action-btn btn-history">
                    <i class="fas fa-list-ol"></i> History
                </a>
                <a href="${contextPath}/company/update-customer/${customer.id}" class="action-btn btn-edit">
                    <i class="fas fa-edit"></i> Edit
                </a>
            </div>
        `;

        fragment.appendChild(card);
    });

    cardContainer.innerHTML = '';
    cardContainer.appendChild(fragment);
}

// Search functionality
function performSearch(query) {
    if (!query || query.length < 2) {
        return;
    }

    showLoader();

    fetch(`${contextPath}/company/search?query=${encodeURIComponent(query)}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Search failed');
            }
            return response.json();
        })
        .then(data => {
            hideLoader();
            renderCards(data);
            if (paginationContainer) {
                paginationContainer.style.display = 'none';
            }
        })
        .catch(error => {
            hideLoader();
            console.error('Search error:', error);
            cardContainer.innerHTML = '<div class="no-customers">Search failed. Please try again.</div>';
        });
}

// Event listeners
document.addEventListener('DOMContentLoaded', function() {
    // Initialize theme
    initializeTheme();

    // Auto-hide success alert
    const successAlert = document.getElementById('success-alert');
    if (successAlert) {
        setTimeout(() => {
            const alert = bootstrap.Alert.getOrCreateInstance(successAlert);
            alert.close();
        }, 5000);
    }

    // Search functionality
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const query = this.value.trim();

            clearTimeout(debounceTimer);

            if (!query) {
                // Reload page to show all customers
                window.location.href = `${contextPath}/company/get-all-customers`;
                return;
            }

            if (query.length < 2) {
                return;
            }

            debounceTimer = setTimeout(() => {
                performSearch(query);
            }, 300);
        });
    }

    // Sidebar toggle
    const sidebarToggle = document.getElementById('sidebarToggle');
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function() {
            document.body.classList.toggle('sb-sidenav-toggled');
        });
    }

    // Animation delay for existing cards
    const existingCards = document.querySelectorAll('.customer-card');
    existingCards.forEach((card, index) => {
        card.style.animationDelay = (index * 0.1) + 's';
    });
});

// Global function for notifications (if needed)
function openNotifications() {
    // Implementation for opening notifications modal
    console.log('Opening notifications...');
}

// Handle errors gracefully
window.addEventListener('error', function(e) {
    console.error('JavaScript error:', e.error);
});

// Handle unhandled promise rejections
window.addEventListener('unhandledrejection', function(e) {
    console.error('Unhandled promise rejection:', e.reason);
});
</script>

</body>
</html>