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
    <title>Daily Expenses - BillMatePro</title>

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
            --radius-lg: 12px;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
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
            transition: background 0.3s ease, color 0.3s ease;
        }

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

        /* Page Loader */
        .page-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--bg-color);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 1;
            visibility: visible;
            transition: opacity 0.5s ease, visibility 0.5s ease;
        }

        .page-loader.hidden {
            opacity: 0;
            visibility: hidden;
        }

        .loader-spinner {
            width: 60px;
            height: 60px;
            border: 4px solid var(--border-color);
            border-top-color: var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Navigation */
        .sb-topnav {
            background: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 1000;
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
            padding: 0.75rem 1rem;
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

        /* KPI Cards */
        .kpi {
            background: var(--card-bg);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .kpi:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
        }

        .kpi .icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        /* Modern Cards */
        .card-modern {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
        }

        .card-modern:hover {
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
        }

        .card-modern .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border-bottom: none;
            border-radius: var(--radius-lg) var(--radius-lg) 0 0;
            padding: 1rem 1.25rem;
            font-weight: 600;
        }

        /* Form Controls */
        .form-label {
            font-weight: 500;
            color: var(--text-color);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            border-radius: 8px;
            padding: 0.625rem 0.875rem;
            transition: all 0.3s ease;
            color: var(--text-color);
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(34, 71, 165, 0.1);
            background: var(--card-bg);
            color: var(--text-color);
        }

        /* Buttons */
        .btn {
            border-radius: 8px;
            padding: 0.625rem 1.25rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(34, 71, 165, 0.4);
        }

        /* Table */
        .table {
            background: var(--card-bg);
            color: var(--text-color);
        }

        .table thead th {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            border: none;
        }

        .table tbody tr {
            transition: background 0.2s ease;
            border-bottom: 1px solid var(--border-color);
        }

        .table tbody tr:hover {
            background: rgba(34, 71, 165, 0.05);
        }

        .table tfoot {
            background: var(--border-color);
            font-weight: 600;
        }

        /* Theme Toggle */
        .theme-toggle {
            position: fixed;
            top: 5.5rem;
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
            z-index: 999;
            box-shadow: var(--shadow);
        }

        .theme-toggle:hover {
            transform: scale(1.1) rotate(15deg);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }

        /* Alert Enhancement */
        .alert {
            border: none;
            border-radius: var(--radius-lg);
            border-left: 4px solid;
            box-shadow: var(--shadow);
            animation: slideInDown 0.3s ease;
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

        .alert-success {
            border-left-color: var(--success-color);
            background: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
        }

        /* Chart Container */
        #monthlyExpenseChart {
            max-height: 300px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .theme-toggle {
                top: 1rem;
                right: 1rem;
            }

            .kpi {
                margin-bottom: 1rem;
            }
        }
    </style>
</head>

<body class="sb-nav-fixed" data-theme="light">

<!-- Page Loader -->
<div class="page-loader" id="pageLoader">
    <div class="text-center">
        <div class="loader-spinner mx-auto mb-3"></div>
        <div class="text-muted">Loading Expenses...</div>
    </div>
</div>

<!-- Theme Toggle -->
<div class="theme-toggle" onclick="toggleTheme()" title="Toggle theme">
    <i class="fas fa-moon" id="theme-icon"></i>
</div>

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-light">
    <a class="navbar-brand ps-3 fw-bold" href="${pageContext.request.contextPath}/login/home">
        <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgwIiBoZWlnaHQ9IjQwIiB2aWV3Qm94PSIwIDAgMTgwIDQwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iNSIgeTE9IjMiIHgyPSIyNSIgeTI9IjI3IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMyMjQ3QTUiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMTQ1RkEwIi8+CjwvbGluZWFyR3JhZGllbnQ+CjxsaW5lYXJHcmFkaWVudCBpZD0icGFpbnQxX2xpbmVhciIgeDE9IjE3IiB5MT0iMTMiIHgyPSIyOCIgeTI9IjI0IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMxMEI5ODEiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDU5NjY5Ii8+CjwvbGluZWFyR3JhZGllbnQ+CjwvZGVmcz4KPCEtLSBEb2N1bWVudC9CaWxsIEljb24gLS0+CjxyZWN0IHg9IjUiIHk9IjMiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyNCIgcng9IjMiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcikiLz4KPCEtLSBMaW5lcyBvbiBkb2N1bWVudCAtLT4KPHBhdGggZD0iTTkgOWg4bS04IDRINW0tNSAzaDciIHN0cm9rZT0iI2ZmZmZmZiIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPCEtLSBDaGVja21hcmsgLS0+CjxjaXJjbGUgY3g9IjIyLjUiIGN5PSIxOC41IiByPSI1LjUiIGZpbGw9InVybCgjcGFpbnQxX2xpbmVhcikiLz4KPHBhdGggZD0ibTIwIDE4LjUgMiAyIDQtNCIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8IS0tIFRleHQgLS0+Cjx0ZXh0IHg9IjM1IiB5PSIxNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmb250LXdlaWdodD0iNzAwIiBmaWxsPSIjMjI0N0E1Ij4KQmlsbE1hdGVQcm88L3RleHQ+Cjx0ZXh0IHg9IjM1IiB5PSIyNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjgiIGZpbGw9IiM2Mzc1OEEiPgpZb3VyIEJpbGxpbmcgUGFydG5lcjwvdGV4dD4KPC9zdmc+"
             alt="BillMatePro" style="height: 50px;">
    </a>
     <button class="btn btn-outline-primary btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>


    <div class="ms-auto d-flex align-items-center gap-3 pe-3">
        <c:if test="${not empty productList}">
            <div class="position-relative" role="button">
                <i class="bi bi-bell fs-5 text-primary"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                    ${fn:length(productList)}
                </span>
            </div>
        </c:if>
        <div class="dropdown">
            <a class="nav-link dropdown-toggle text-primary" id="navbarDropdown" href="#"
               data-bs-toggle="dropdown" aria-expanded="false" role="button">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                <li>
                    <h6 class="dropdown-header">
                        <i class="fas fa-user-circle me-2"></i>
                        ${pageContext.request.userPrincipal.name}
                    </h6>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/company/get-my-profile">
                        <i class="fas fa-cog me-2"></i>Account Settings
                    </a>
                </li>
                <li>
                    <a class="dropdown-item" href="#" onclick="event.preventDefault(); document.getElementById('logoutForm').submit();">
                        <i class="fas fa-sign-out-alt me-2"></i>Logout
                    </a>
                </li>
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/expenses">
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
            <div class="container-fluid px-4 py-4">

                <!-- Success Alert -->
                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert" id="success-alert">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="mb-1">Daily Expenses</h2>
                        <p class="text-muted mb-0">Track and manage your business expenses</p>
                    </div>
                </div>

                <!-- KPI Cards -->
                <div class="row g-3 mb-4">
                    <!-- Today's Expenses -->
                    <div class="col-md-6 col-lg-4">
                        <div class="kpi d-flex justify-content-between align-items-center p-3 shadow-sm rounded-3 bg-white">
                            <div>
                                <div class="text-muted small mb-1">Today's Expenses</div>
                                <div class="fw-bold fs-4">
                                    ₹<fmt:formatNumber value="${daily_expenses}" type="number" minFractionDigits="2"/>
                                </div>
                            </div>
                            <div class="icon bg-primary-subtle text-primary rounded-circle p-3">
                                <i class="fas fa-calendar-day fa-lg"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Monthly Expenses -->
                    <div class="col-md-6 col-lg-4">
                        <div class="kpi d-flex justify-content-between align-items-center p-3 shadow-sm rounded-3 bg-white">
                            <div>
                                <div class="text-muted small mb-1">Monthly Expenses</div>
                                <div class="fw-bold fs-4">
                                    ₹<fmt:formatNumber value="${monthly_expenses}" type="number" minFractionDigits="2"/>
                                </div>
                            </div>
                            <div class="icon bg-success-subtle text-success rounded-circle p-3">
                                <i class="fas fa-calendar-alt fa-lg"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Yearly Expenses -->
                    <div class="col-md-6 col-lg-4">
                        <div class="kpi d-flex justify-content-between align-items-center p-3 shadow-sm rounded-3 bg-white">
                            <div>
                                <div class="text-muted small mb-1">Yearly Expenses</div>
                                <div class="fw-bold fs-4">
                                    ₹<fmt:formatNumber value="${yearly_expenses}" type="number" minFractionDigits="2"/>
                                </div>
                            </div>
                            <div class="icon bg-warning-subtle text-warning rounded-circle p-3">
                                <i class="fas fa-calendar fa-lg"></i>
                            </div>
                        </div>
                    </div>
                </div>


                <!-- Add Expense & Filter -->
                <div class="row g-3 mb-4">
                    <div class="col-lg-6">
                        <div class="card card-modern">
                            <div class="card-header">
                                <i class="fas fa-plus me-2"></i>Add New Expense
                            </div>
                            <div class="card-body">
                                <form method="post" action="${pageContext.request.contextPath}/expenses/add">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label">Date</label>
                                            <input type="date" name="date" class="form-control"
                                                   value="<fmt:formatDate value='${today}' pattern='yyyy-MM-dd'/>" required/>
                                        </div>
                                        <div class="col-md-5">
                                            <label class="form-label">Expense Name</label>
                                            <input type="text" name="expenseName" class="form-control"
                                                   maxlength="100" placeholder="Enter expense name" required/>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">Amount (₹)</label>
                                            <input type="number" name="amount" class="form-control"
                                                   step="0.01" min="0" placeholder="0.00" required/>
                                        </div>
                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-2"></i>Save Expense
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="card card-modern">
                            <div class="card-header">
                                <i class="fas fa-filter me-2"></i>Filter Expenses
                            </div>
                            <div class="card-body">
                                <form method="get" action="${pageContext.request.contextPath}/expenses">
                                    <div class="row g-3">
                                        <div class="col-md-8">
                                            <label class="form-label">Filter by Date</label>
                                            <input type="date" name="date" class="form-control"
                                                   value="<fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd'/>"/>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label d-block">&nbsp;</label>
                                            <button class="btn btn-primary w-100" type="submit">
                                                <i class="fas fa-search me-2"></i>Apply
                                            </button>
                                        </div>
                                        <div class="col-12">
                                            <a class="btn btn-outline-secondary w-100" href="${pageContext.request.contextPath}/expenses">
                                                <i class="fas fa-redo me-2"></i>Reset Filter
                                            </a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Expense List & Chart -->
                <div class="row g-3">
                    <div class="col-lg-6">
                        <div class="card card-modern">
                            <div class="card-header">
                                <i class="fas fa-table me-2"></i>Expense List
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th style="width: 50px;">#</th>
                                                <th>Date</th>
                                                <th>Expense</th>
                                                <th class="text-end">Amount (₹)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:set var="total" value="0"/>
                                            <c:forEach items="${expenses}" var="e" varStatus="vs">
                                                <tr>
                                                    <td>${vs.index + 1}</td>
                                                    <td><fmt:formatDate value="${e.date}" pattern="dd MMM yyyy"/></td>
                                                    <td>${e.expenseName}</td>
                                                    <td class="text-end">
                                                        <fmt:formatNumber value="${e.amount}" type="number" minFractionDigits="2"/>
                                                    </td>
                                                </tr>
                                                <c:set var="total" value="${total + e.amount}"/>
                                            </c:forEach>
                                            <c:if test="${empty expenses}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-4">
                                                        <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                                                        No expenses found
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th colspan="3" class="text-end">Total</th>
                                                <th class="text-end">
                                                    <fmt:formatNumber value="${total}" type="number" minFractionDigits="2"/>
                                                </th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="card card-modern">
                            <div class="card-header">
                                <i class="fas fa-chart-bar me-2"></i>Monthly Expense Overview
                            </div>
                            <div class="card-body">
                                <canvas id="monthlyExpenseChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="py-4 bg-light mt-auto">
            <div class="container-fluid px-4">
                <div class="d-flex align-items-center justify-content-between small">
                    <div class="text-muted">Copyright &copy; BillMatePro 2025</div>
                    <div>
                        <a href="#" class="text-muted">Privacy Policy</a>
                        &middot;
                        <a href="#" class="text-muted">Terms &amp; Conditions</a>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</div>

<!-- Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // Hide page loader
    setTimeout(() => {
        const loader = document.getElementById('pageLoader');
        if (loader) loader.classList.add('hidden');
    }, 800);

    // Auto-hide success alert
    const successAlert = document.getElementById('success-alert');
    if (successAlert) {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(successAlert);
            bsAlert.close();
        }, 3500);
    }

    // Sidebar toggle
    const sidebarToggle = document.getElementById("sidebarToggle");
    if (sidebarToggle) {
        sidebarToggle.addEventListener("click", function(e) {
            e.preventDefault();
            document.body.classList.toggle("sb-sidenav-toggled");
            localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
        });
    }

    // Restore sidebar state
    if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
        document.body.classList.add('sb-sidenav-toggled');
    }

    // Theme toggle
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.body.setAttribute('data-theme', savedTheme);
    updateThemeIcon(savedTheme);

    // Monthly Expense Chart
    const ctx = document.getElementById('monthlyExpenseChart');
    if (ctx) {
        const chartData = {
            labels: [
                <c:forEach var="m" items="${monthlyExpenses}" varStatus="vs">
                    '<c:out value="${m.month}"/>'<c:if test="${!vs.last}">,</c:if>
                </c:forEach>
            ],
            datasets: [{
                label: 'Total Expenses',
                data: [
                    <c:forEach var="m" items="${monthlyExpenses}" varStatus="vs">
                        <c:out value="${m.totalAmount}"/><c:if test="${!vs.last}">,</c:if>
                    </c:forEach>
                ],
                backgroundColor: 'rgba(34, 71, 165, 0.7)',
                borderColor: 'rgba(34, 71, 165, 1)',
                borderWidth: 2,
                borderRadius: 8,
                barThickness: 40
            }]
        };

        new Chart(ctx.getContext('2d'), {
            type: 'bar',
            data: chartData,
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        padding: 12,
                        borderRadius: 8,
                        callbacks: {
                            label: function(context) {
                                return '₹' + context.parsed.y.toLocaleString('en-IN', {
                                    minimumFractionDigits: 2,
                                    maximumFractionDigits: 2
                                });
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)'
                        },
                        ticks: {
                            callback: function(value) {
                                return '₹' + value.toLocaleString('en-IN');
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            callback: function(value, index) {
                                const label = this.getLabelForValue(index);
                                const [year, month] = label.split('-');
                                const date = new Date(year, month - 1);
                                return date.toLocaleDateString('en-US', {
                                    month: 'short',
                                    year: 'numeric'
                                });
                            }
                        }
                    }
                }
            }
        });
    }
});

// Theme toggle function
function toggleTheme() {
    const currentTheme = document.body.getAttribute('data-theme');
    const newTheme = currentTheme === 'light' ? 'dark' : 'light';

    document.body.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    updateThemeIcon(newTheme);
}

function updateThemeIcon(theme) {
    const icon = document.getElementById('theme-icon');
    if (icon) {
        icon.className = theme === 'light' ? 'fas fa-moon' : 'fas fa-sun';
    }
}
</script>
</body>
</html>