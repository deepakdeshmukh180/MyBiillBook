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
  <title>Dashboard - BillMatePro</title>

  <!-- CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>

  <!-- JS (head) -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
      --glass-bg: rgba(255, 255, 255, 0.1);
      --glass-border: rgba(255, 255, 255, 0.2);
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
      overflow-x: hidden;
    }

    /* Light theme */
    [data-theme="light"] {
      --bg-color: var(--bg-light);
      --text-color: var(--text-light);
      --card-bg: var(--card-light);
      --border-color: var(--border-light);
    }

    /* Dark theme */
    [data-theme="dark"] {
      --bg-color: var(--bg-dark);
      --text-color: var(--text-dark);
      --card-bg: var(--card-dark);
      --border-color: var(--border-dark);
    }

    /* Animated background */
    body::before {
      content: '';
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(135deg, var(--primary-color) 0%, var(--success-color) 100%);
      opacity: 0.05;
      z-index: -2;
    }

    /* Floating shapes */
    .floating-shape {
      position: fixed;
      border-radius: 50%;
      background: linear-gradient(45deg, var(--primary-color), var(--success-color));
      opacity: 0.1;
      animation: float 6s ease-in-out infinite;
      z-index: -1;
    }

    .floating-shape:nth-child(1) {
      width: 80px;
      height: 80px;
      top: 20%;
      left: 10%;
      animation-delay: 0s;
    }

    .floating-shape:nth-child(2) {
      width: 120px;
      height: 120px;
      top: 60%;
      right: 10%;
      animation-delay: -2s;
    }

    .floating-shape:nth-child(3) {
      width: 60px;
      height: 60px;
      top: 80%;
      left: 20%;
      animation-delay: -4s;
    }

    .floating-shape:nth-child(4) {
      width: 100px;
      height: 100px;
      top: 10%;
      right: 25%;
      animation-delay: -3s;
    }

    @keyframes float {
      0%, 100% { transform: translateY(0px) rotate(0deg); }
      50% { transform: translateY(-20px) rotate(180deg); }
    }

    /* Enhanced Card Styles */
    .enhanced-card {
      border: none;
      border-radius: 24px;
      background: var(--card-bg);
      backdrop-filter: blur(20px);
      border: 1px solid var(--border-color);
      box-shadow:
        0 20px 25px -5px rgba(0, 0, 0, 0.1),
        0 10px 10px -5px rgba(0, 0, 0, 0.04);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      overflow: hidden;
      position: relative;
    }

    [data-theme="dark"] .enhanced-card {
      box-shadow:
        0 20px 25px -5px rgba(0, 0, 0, 0.4),
        0 10px 10px -5px rgba(0, 0, 0, 0.2);
    }

    .enhanced-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 3px;
      background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
      opacity: 0;
      transition: opacity 0.3s ease;
    }

    .enhanced-card:hover {
      transform: translateY(-8px);
      box-shadow:
        0 32px 64px -12px rgba(0, 0, 0, 0.25),
        0 12px 24px -8px rgba(0, 0, 0, 0.12);
    }

    .enhanced-card:hover::before {
      opacity: 1;
    }

    /* KPI Cards */
    .kpi-card {
      border: none;
      border-radius: 24px;
      background: var(--card-bg);
      backdrop-filter: blur(20px);
      border: 1px solid var(--border-color);
      box-shadow:
        0 20px 25px -5px rgba(0, 0, 0, 0.1),
        0 10px 10px -5px rgba(0, 0, 0, 0.04);
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
        0 32px 64px -12px rgba(0, 0, 0, 0.25),
        0 12px 24px -8px rgba(0, 0, 0, 0.12);
    }

    .kpi-icon {
      width: 64px;
      height: 64px;
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 24px;
      background: linear-gradient(45deg, var(--primary-color), var(--primary-dark));
      color: white;
      box-shadow: 0 8px 16px rgba(34, 71, 165, 0.3);
    }

    /* Welcome Card */
    .welcome-card {
      background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
      color: white;
      border-radius: 24px;
      border: none;
      position: relative;
      overflow: hidden;
      backdrop-filter: blur(20px);
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
      background: var(--card-bg);
      backdrop-filter: blur(20px);
      border: 1px solid var(--border-color);
      box-shadow:
        0 20px 25px -5px rgba(0, 0, 0, 0.1),
        0 10px 10px -5px rgba(0, 0, 0, 0.04);
      transition: all 0.3s ease;
    }

    .chart-card:hover {
      transform: translateY(-4px);
      box-shadow:
        0 32px 64px -12px rgba(0, 0, 0, 0.25),
        0 12px 24px -8px rgba(0, 0, 0, 0.12);
    }

    /* Customer Cards */
    .customer-mini-card {
      border: none;
      border-radius: 18px;
      background: var(--card-bg);
      backdrop-filter: blur(20px);
      border: 1px solid var(--border-color);
      transition: all 0.3s ease;
      border-left: 4px solid transparent;
      box-shadow:
        0 10px 15px -3px rgba(0, 0, 0, 0.1),
        0 4px 6px -2px rgba(0, 0, 0, 0.05);
    }

    .customer-mini-card:hover {
      transform: translateX(8px);
      border-left-color: var(--primary-color);
      box-shadow:
        0 20px 25px -5px rgba(0, 0, 0, 0.1),
        0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    .customer-avatar {
      width: 48px;
      height: 48px;
      border-radius: 16px;
      background: linear-gradient(45deg, var(--primary-color), var(--success-color));
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 18px;
      box-shadow: 0 4px 12px rgba(34, 71, 165, 0.3);
    }

    /* Expense Cards */
    .expense-item {
      border: none;
      border-radius: 16px;
      background: var(--card-bg);
      backdrop-filter: blur(20px);
      border: 1px solid var(--border-color);
      transition: all 0.3s ease;
      border-left: 4px solid var(--danger-color);
      box-shadow:
        0 10px 15px -3px rgba(0, 0, 0, 0.1),
        0 4px 6px -2px rgba(0, 0, 0, 0.05);
    }

    .expense-item:hover {
      transform: translateX(6px);
      box-shadow:
        0 20px 25px -5px rgba(0, 0, 0, 0.1),
        0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    .expense-icon {
      width: 40px;
      height: 40px;
      border-radius: 12px;
      background: linear-gradient(45deg, var(--danger-color), #e74c3c);
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
    }

    /* Navigation */
    .sb-topnav {
      background: var(--card-bg);
      backdrop-filter: blur(20px);
      border-bottom: 1px solid var(--border-color);
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }

    .sb-topnav .navbar-brand img {
      filter: drop-shadow(0 4px 15px rgba(34, 71, 165, 0.2));
      transition: all 0.3s ease;
    }

    .sb-topnav .navbar-brand img:hover {
      transform: scale(1.05);
      filter: drop-shadow(0 8px 25px rgba(34, 71, 165, 0.3));
    }

    /* Sidebar */
    .sb-sidenav {
      background: var(--card-bg);
      backdrop-filter: blur(20px);
      border-right: 1px solid var(--border-color);
    }

    .sb-sidenav .nav-link {
      color: var(--text-color);
      border-radius: 12px;
      margin: 0.25rem 1rem;
      transition: all 0.3s ease;
    }

    .sb-sidenav .nav-link:hover {
      background: var(--glass-bg);
      backdrop-filter: blur(10px);
      transform: translateX(4px);
    }

    .sb-sidenav .nav-link.active {
      background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
      color: white;
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
      background: linear-gradient(90deg, var(--primary-color), var(--success-color));
      border-radius: 2px;
    }

    .section-title {
      font-weight: 700;
      color: var(--text-color);
      font-size: 1.1rem;
      letter-spacing: 0.5px;
    }

    /* Enhanced Badges */
    .badge-modern {
      padding: 6px 12px;
      border-radius: 12px;
      font-weight: 500;
      font-size: 0.75rem;
      backdrop-filter: blur(10px);
    }

    /* Button Enhancements */
    .btn-modern {
      border-radius: 12px;
      padding: 8px 16px;
      font-weight: 500;
      transition: all 0.3s ease;
      border: none;
    }

    .btn-modern:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(0,0,0,0.15);
    }

    .btn-primary {
      background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
      box-shadow: 0 4px 15px rgba(34, 71, 165, 0.3);
    }

    .btn-primary:hover {
      box-shadow: 0 8px 25px rgba(34, 71, 165, 0.4);
    }

    /* Theme toggle */
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
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
      backdrop-filter: blur(20px);
    }

    .theme-toggle:hover {
      transform: scale(1.1);
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
    }

    .theme-toggle i {
      font-size: 1.2rem;
      color: var(--primary-color);
    }

    /* Animation Classes */
    .fade-in-up {
      opacity: 0;
      transform: translateY(30px);
      animation: fadeInUp 0.8s ease forwards;
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

    /* Modal Enhancements */
    .modal-content {
      border: none;
      border-radius: 20px;
      background: var(--card-bg);
      backdrop-filter: blur(20px);
      box-shadow:
        0 32px 64px -12px rgba(0, 0, 0, 0.25),
        0 12px 24px -8px rgba(0, 0, 0, 0.12);
    }

    .modal-header {
      background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
      border-bottom: none;
      border-radius: 20px 20px 0 0;
    }

    /* Form Enhancements */
    .form-control {
      background: var(--card-bg);
      border: 2px solid var(--border-color);
      border-radius: 12px;
      transition: all 0.3s ease;
      color: var(--text-color);
      backdrop-filter: blur(10px);
    }

    .form-control:focus {
      border-color: var(--primary-color);
      box-shadow: 0 0 0 3px rgba(34, 71, 165, 0.1);
      background: var(--card-bg);
      color: var(--text-color);
    }

    .input-group-text {
      background: var(--card-bg);
      border: 2px solid var(--border-color);
      color: var(--primary-color);
      backdrop-filter: blur(10px);
    }

    /* Carousel Enhancement */
    .expiry-carousel .carousel-item .card {
      border: none;
      border-radius: 20px;
      background: var(--card-bg);
      backdrop-filter: blur(20px);
      border-left: 6px solid var(--danger-color);
      box-shadow:
        0 20px 25px -5px rgba(0, 0, 0, 0.1),
        0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    /* Alert Enhancements */
    .alert {
      border: none;
      border-radius: 16px;
      backdrop-filter: blur(20px);
      border: 1px solid var(--border-color);
    }

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

      .theme-toggle {
        top: 1rem;
        right: 1rem;
        width: 45px;
        height: 45px;
      }
    }

    /* Modal backdrop fix */
    .modal-backdrop {
      z-index: 1040 !important;
    }

    .modal {
      z-index: 1050 !important;
    }
  </style>
</head>
<body class="sb-nav-fixed" data-theme="light">

<!-- Floating background shapes -->
<div class="floating-shape"></div>
<div class="floating-shape"></div>
<div class="floating-shape"></div>
<div class="floating-shape"></div>

<!-- Theme Toggle -->
<div class="theme-toggle" onclick="toggleTheme()" title="Toggle dark/light mode">
    <i class="fas fa-moon" id="theme-icon"></i>
</div>

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-light">
   <a class="navbar-brand ps-3 fw-bold" href="#" onclick="showSection('dashboard')">
      <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgwIiBoZWlnaHQ9IjQwIiB2aWV3Qm94PSIwIDAgMTgwIDQwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iNSIgeTE9IjMiIHgyPSIyNSIgeTI9IjI3IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMyMjQ3QTUiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMTQ1RkEwIi8+CjwvbGluZWFyR3JhZGllbnQ+CjxsaW5lYXJHcmFkaWVudCBpZD0icGFpbnQxX2xpbmVhciIgeDE9IjE3IiB5MT0iMTMiIHgyPSIyOCIgeTI9IjI0IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMxMEI5ODEiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDU5NjY5Ii8+CjwvbGluZWFyR3JhZGllbnQ+CjwvZGVmcz4KPCEtLSBEb2N1bWVudC9CaWxsIEljb24gLS0+CjxyZWN0IHg9IjUiIHk9IjMiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyNCIgcng9IjMiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcikiLz4KPCEtLSBMaW5lcyBvbiBkb2N1bWVudCAtLT4KPHBhdGggZD0iTTkgOWg4bS04IDVINW0tNSAzaDciIHN0cm9rZT0iI2ZmZmZmZiIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPCEtLSBDaGVja21hcmsgLS0+CjxjaXJjbGUgY3g9IjIyLjUiIGN5PSIxOC41IiByPSI1LjUiIGZpbGw9InVybCgjcGFpbnQxX2xpbmVhcikiLz4KPHBhdGggZD0ibTIwIDE4LjUgMiAyIDQtNCIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8IS0tIFRleHQgLS0+Cjx0ZXh0IHg9IjM1IiB5PSIxNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmb250LXdlaWdodD0iNzAwIiBmaWxsPSIjMjI0N0E1Ij4KQmlsbE1hdGVQcm88L3RleHQ+Cjx0ZXh0IHg9IjM1IiB5PSIyNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjgiIGZpbGw9IiM2Mzc1OEEiPgpZb3VyIEJpbGxpbmcgUGFydG5lcjwvdGV4dD4KPC9zdmc+"
           alt="BillMatePro" style="height: 50px; margin-right: 8px;">
    </a>
  <button class="btn btn-outline-primary btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>

  <div class="ms-auto d-flex align-items-center gap-3 pe-3">
    <div class="position-relative" role="button" onclick="openModal()">
      <i class="bi bi-bell fs-5 text-primary"></i>
      <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
        ${productList.size()}
      </span>
    </div>
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
          <a class="nav-link active" href="${pageContext.request.contextPath}/login/home">
            <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div> Dashboard
          </a>

          <div class="sb-sidenav-menu-heading">Interface</div>
          <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts">
            <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div> Menu
            <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
          </a>
          <div class="collapse" id="collapseLayouts" data-bs-parent="#sidenavAccordion">
            <nav class="sb-sidenav-menu-nested nav">
              <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers"><i class="fas fa-user-friends me-2"></i>All Customers</a>
              <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices"><i class="fas fa-file-invoice me-2"></i>Invoices</a>
              <a class="nav-link" href="${pageContext.request.contextPath}/company/reports"><i class="fas fa-chart-line me-2"></i>Daily/Monthly Reports</a>
              <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products"><i class="fas fa-leaf me-2"></i>Products</a>
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

  <!-- Main -->
  <div id="layoutSidenav_content">
    <main>
      <div class="container-fluid px-4 mt-4">

        <!-- Success toast -->
        <c:if test="${not empty msg}">
          <div class="alert alert-success alert-dismissible fade show enhanced-card border-0 fade-in-up" role="alert" id="success-alert">
            <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
        </c:if>



      </div> <!-- /container-fluid -->
    </main>
  </div>
</div>

<!-- Modal: Add Customer -->


<!-- Logout form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/timeout.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>

<script>
// Theme toggle functionality
function toggleTheme() {
    const body = document.body;
    const themeIcon = document.getElementById('theme-icon');
    const currentTheme = body.getAttribute("data-theme");
    const newTheme = currentTheme === "dark" ? "light" : "dark";

    body.setAttribute("data-theme", newTheme);

    // Update icon
    if (newTheme === "dark") {
        themeIcon.className = "fas fa-sun";
    } else {
        themeIcon.className = "fas fa-moon";
    }

    // Save preference
    localStorage.setItem('theme', newTheme);
}

// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
  // Load saved theme
  const savedTheme = localStorage.getItem('theme') || 'light';
  const body = document.body;
  const themeIcon = document.getElementById('theme-icon');

  body.setAttribute("data-theme", savedTheme);

  if (savedTheme === "dark") {
      themeIcon.className = "fas fa-sun";
  } else {
      themeIcon.className = "fas fa-moon";
  }

  console.log('DOM loaded, initializing modals...');

  // Initialize modal functionality
  const addCustomerBtn = document.getElementById('addCustomerBtn');
  const addCustomerModal = document.getElementById('addCustomerModal');

  if (addCustomerBtn && addCustomerModal) {
    console.log('Modal elements found, setting up event listener');

    addCustomerBtn.addEventListener('click', function(e) {
      e.preventDefault();
      console.log('Add Customer button clicked');

      try {
        const modal = new bootstrap.Modal(addCustomerModal, {
          backdrop: 'static',
          keyboard: false
        });
        modal.show();
        console.log('Modal shown successfully');
      } catch (error) {
        console.error('Error showing modal:', error);
        // Fallback: try jQuery
        if (typeof $ !== 'undefined') {
          $('#addCustomerModal').modal('show');
        }
      }
    });
  } else {
    console.error('Modal elements not found');
  }

  // Success alert auto-hide
  const successAlert = document.getElementById('success-alert');
  if (successAlert) {
    setTimeout(() => {
      const alert = bootstrap.Alert.getOrCreateInstance(successAlert);
      alert.close();
    }, 3500);
  }

  // Form validation
  const forms = document.querySelectorAll('.needs-validation');
  forms.forEach(form => {
    form.addEventListener('submit', function(event) {
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    });
  });
});

// Global functions
function openModal() {
  const modal = new bootstrap.Modal(document.getElementById('expiringModal'));
  modal.show();
}

// Chart Data and Configuration
const totalAmount = ${totalAmount != null ? totalAmount : 0};
const paidAmount = ${paidAmount != null ? paidAmount : 0};
const currentOusting = ${currentOutstanding != null ? currentOutstanding : 0};
const toK = v => v >= 1000 ? (v/1000).toFixed(1)+'K' : v.toLocaleString();

// Pie Chart
const ctx = document.getElementById('paymentPieChart');
if (ctx) {
  const pieCtx = ctx.getContext('2d');

  // Gradients
  const gradient1 = pieCtx.createLinearGradient(0, 0, 0, 400);
  gradient1.addColorStop(0, '#6a11cb');
  gradient1.addColorStop(1, '#2575fc');

  const gradient2 = pieCtx.createLinearGradient(0, 0, 0, 400);
  gradient2.addColorStop(0, '#ff416c');
  gradient2.addColorStop(1, '#ff4b2b');

  const gradient3 = pieCtx.createLinearGradient(0, 0, 0, 400);
  gradient3.addColorStop(0, '#00f260');
  gradient3.addColorStop(1, '#0575e6');

  new Chart(pieCtx, {
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
            font: { size: 12, weight: '500' },
            color: getComputedStyle(document.documentElement).getPropertyValue('--text-color').trim()
          }
        },
        tooltip: {
          callbacks: {
            label: function(context) {
              return context.label + ': ₹' + toK(context.parsed);
            }
          }
        }
      }
    }
  });
}

// Bar Chart
const barCtx = document.getElementById('paymentBarChart');
if (barCtx) {
  const totalAmount1 = ${dailySummary.totalAmount != null ? dailySummary.totalAmount : 0};
  const paidAmount1 = ${dailySummary.collectedAmount != null ? dailySummary.collectedAmount : 0};
  const currentOusting1 = ${dailySummary.totalBalanceAmount != null ? dailySummary.totalBalanceAmount : 0};

  new Chart(barCtx.getContext('2d'), {
    type: 'bar',
    data: {
      labels: ['Total Amt', 'Collected', 'Balance'],
      datasets: [{
        label: 'Amount',
        data: [totalAmount1, paidAmount1, currentOusting1],
        backgroundColor: [
          'rgba(34, 71, 165, 0.8)',
          'rgba(16, 185, 129, 0.8)',
          'rgba(245, 158, 11, 0.8)'
        ],
        borderColor: [
          'rgb(34, 71, 165)',
          'rgb(16, 185, 129)',
          'rgb(245, 158, 11)'
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
            label: function(context) {
              return '₹' + toK(context.raw);
            }
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: function(value) {
              return '₹' + toK(value);
            },
            color: getComputedStyle(document.documentElement).getPropertyValue('--text-color').trim()
          },
          grid: {
            color: 'rgba(0,0,0,0.1)'
          }
        },
        x: {
          ticks: {
            color: getComputedStyle(document.documentElement).getPropertyValue('--text-color').trim()
          },
          grid: {
            display: false
          }
        }
      }
    }
  });
}

// Line Chart for Expenses Trend
const expenseCtx = document.getElementById('expensesTrendChart');
if (expenseCtx) {
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

  new Chart(expenseCtx.getContext('2d'), {
    type: 'line',
    data: {
      labels: trendLabels,
      datasets: [{
        label: 'Daily Expenses',
        data: trendData,
        borderColor: 'rgb(239, 68, 68)',
        backgroundColor: 'rgba(239, 68, 68, 0.1)',
        fill: true,
        tension: 0.4,
        pointBackgroundColor: 'rgb(239, 68, 68)',
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
            label: function(context) {
              return '₹' + context.raw.toLocaleString();
            }
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: function(value) {
              return '₹' + value.toLocaleString();
            },
            color: getComputedStyle(document.documentElement).getPropertyValue('--text-color').trim()
          },
          grid: {
            color: 'rgba(0,0,0,0.1)'
          }
        },
        x: {
          ticks: {
            color: getComputedStyle(document.documentElement).getPropertyValue('--text-color').trim()
          },
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
}

// Animation on scroll
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

// Parallax effect for floating shapes
window.addEventListener('scroll', function() {
    const scrolled = window.pageYOffset;
    const shapes = document.querySelectorAll('.floating-shape');

    shapes.forEach((shape, index) => {
        const speed = 0.5 + (index * 0.1);
        const yPos = -(scrolled * speed);
        shape.style.transform = `translateY(${yPos}px)`;
    });
});

// Add particle effect on mouse move (subtle for dashboard)
let particleCount = 0;
document.addEventListener('mousemove', function(e) {
    if (particleCount > 5) return; // Limit particles

    const cursor = document.createElement('div');
    cursor.className = 'cursor-particle';
    cursor.style.left = e.clientX + 'px';
    cursor.style.top = e.clientY + 'px';

    document.body.appendChild(cursor);
    particleCount++;

    setTimeout(() => {
        cursor.remove();
        particleCount--;
    }, 1000);
});

// Add CSS for cursor particles
const style = document.createElement('style');
style.textContent = `
    .cursor-particle {
        position: fixed;
        width: 3px;
        height: 3px;
        background: var(--primary-color);
        border-radius: 50%;
        pointer-events: none;
        opacity: 0.5;
        animation: fadeParticle 1s ease-out forwards;
        z-index: 9999;
    }

    @keyframes fadeParticle {
        to {
            opacity: 0;
            transform: scale(0);
        }
    }

    .cursor-particle:nth-child(2n) {
        background: var(--success-color);
    }
`;
document.head.appendChild(style);

// Update charts on theme change
function updateChartsTheme() {
    // This function can be called when theme changes to update chart colors
    // You can extend this to update all charts with theme-appropriate colors
}
</script>

</body>
</html>