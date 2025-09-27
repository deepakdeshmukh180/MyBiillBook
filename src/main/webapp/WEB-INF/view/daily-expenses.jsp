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
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
:root{
    --brand:#0d6efd;
    --soft:#f4f6f9;
    --ink:#33475b;
}
body{ background: var(--soft); }

/* Top Navbar Gradient */
.sb-topnav { background: linear-gradient(135deg, #3c7bff, #70a1ff); border-bottom: 1px solid rgba(255,255,255,.08); }

/* Card design */
.card-modern{ border:0; border-radius:18px; box-shadow:0 8px 22px rgba(0,0,0,.08); }
.card-header{ background: linear-gradient(135deg,#3c7bff,#70a1ff); color:#fff; font-weight:bold; border-top-left-radius:18px; border-top-right-radius:18px; }

/* KPI card style */
.kpi{ border-radius:14px; box-shadow:0 6px 18px rgba(0,0,0,.08); padding:12px; transition:.2s; }
.kpi:hover{ transform: translateY(-4px); }
.kpi .icon{ font-size:1.5rem; }

/* Expense item */
.expense-item{ border-radius:14px; border:1px dashed #d8e2ff; background:#fff; transition:.2s; }
.expense-item:hover{ transform:scale(1.01); background:#f8fbff; }

/* Sidebar toggle */
body.sb-sidenav-toggled #layoutSidenav_nav { margin-left: -250px; }
body.sb-sidenav-toggled #layoutSidenav_content { margin-left: 0; }
#layoutSidenav_nav { width: 250px; transition: all 0.3s ease; }
#layoutSidenav_content { margin-left: 250px; transition: all 0.3s ease; }
</style>
</head>
<body class="sb-nav-fixed">

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark">
    <a class="navbar-brand ps-3 fw-bold" href="#" onclick="showSection('dashboard')">
          <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgwIiBoZWlnaHQ9IjQwIiB2aWV3Qm94PSIwIDAgMTgwIDQwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iNSIgeTE9IjMiIHgyPSIyNSIgeTI9IjI3IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiNmZmZmZmYiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjZjJmMmYyIi8+CjwvbGluZWFyR3JhZGllbnQ+CjxsaW5lYXJHcmFkaWVudCBpZD0icGFpbnQxX2xpbmVhciIgeDE9IjE3IiB5MT0iMTMiIHgyPSIyOCIgeTI9IjI0IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMxMEI5ODEiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDU5NjY5Ii8+CjwvbGluZWFyR3JhZGllbnQ+CjwvZGVmcz4KPCEtLSBEb2N1bWVudC9CaWxsIEljb24gLS0+CjxyZWN0IHg9IjUiIHk9IjMiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyNCIgcng9IjMiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcikiLz4KPCEtLSBMaW5lcyBvbiBkb2N1bWVudCAtLT4KPHBhdGggZD0iTTkgOWg4bS04IDNaNW0tNSAzaDciIHN0cm9rZT0iIzJGNDc1OSIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPCEtLSBDaGVja21hcmsgLS0+CjxjaXJjbGUgY3g9IjIyLjUiIGN5PSIxOC41IiByPSI1LjUiIGZpbGw9InVybCgjcGFpbnQxX2xpbmVhcikiLz4KPHBhdGggZD0ibTIwIDE4LjUgMiAyIDQtNCIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8IS0tIFRleHQgLS0+Cjx0ZXh0IHg9IjM1IiB5PSIxNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmb250LXdlaWdodD0iNzAwIiBmaWxsPSJ3aGl0ZSI+CkJpbGxNYXRlUHJvPC90ZXh0Pgo8dGV4dCB4PSIzNSIgeT0iMjYiIGZvbnQtZmFtaWx5PSJJbnRlciwgc2Fucy1zZXJpZiIgZm9udC1zaXplPSI4IiBmaWxsPSIjZTJlOGYwIj4KWW91ciBCaWxsaW5nIFBhcnRuZXI8L3RleHQ+Cjwvc3ZnPg=="
               alt="BillMatePro" style="height: 50px; margin-right: 8px;">
        </a>
    <button class="btn btn-outline-light btn-sm ms-2" id="sidebarToggle" type="button">
        <i class="fas fa-bars"></i>
    </button>

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

<div id="layoutSidenav" class="d-flex">
    <!-- Sidebar -->
    <div id="layoutSidenav_nav" class="bg-dark text-white">
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports"><i class="fas fa-chart-line me-2 text-white"></i>Reports</a>
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
    <div id="layoutSidenav_content" class="flex-grow-1">
        <main>
            <div class="container-fluid px-4 mt-4">

                <!-- Success Toast -->
                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-dismissible fade show shadow-soft border-0" role="alert" id="success-alert">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <script>
                        window.addEventListener('load',()=>{
                            setTimeout(()=>{
                                const el=document.getElementById('success-alert');
                                if(el){ bootstrap.Alert.getOrCreateInstance(el).close(); }
                            }, 3500);
                        });
                    </script>
                </c:if>

                <!-- KPI Cards -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="kpi d-flex justify-content-between align-items-center p-3 bg-white rounded-18 shadow-soft">
                            <div>
                                <div class="text-muted small">Today's Expenses</div>
                                <div class="fw-bold fs-5">₹<fmt:formatNumber value="${daily_expenses}" type="number" minFractionDigits="2"/></div>
                            </div>
                            <div class="icon bg-primary-subtle text-primary"><i class="fas fa-calendar-day"></i></div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="kpi d-flex justify-content-between align-items-center p-3 bg-white rounded-18 shadow-soft">
                            <div>
                                <div class="text-muted small">Monthly Expenses</div>
                                <div class="fw-bold fs-5">₹<fmt:formatNumber value="${monthly_expenses}" type="number" minFractionDigits="2"/></div>
                            </div>
                            <div class="icon bg-success-subtle text-success"><i class="fas fa-calendar-alt"></i></div>
                        </div>
                    </div>
                </div>

                <!-- Add Expense & Filter -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card card-modern mb-3">
                            <div class="card-header"><i class="fas fa-plus me-1"></i> Add Expense</div>
                            <div class="card-body">
                                <form method="post" action="${pageContext.request.contextPath}/expenses/add" class="row g-2">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <div class="col-md-4">
                                        <label class="form-label">Date</label>
                                        <input type="date" name="date" class="form-control" value="<fmt:formatDate value='${today}' pattern='yyyy-MM-dd'/>" required/>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="form-label">Expense Name</label>
                                        <input type="text" name="expenseName" class="form-control" maxlength="100" required/>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">Amount</label>
                                        <input type="number" name="amount" class="form-control" step="0.01" min="0" required/>
                                    </div>
                                    <div class="col-md-1 d-grid">
                                        <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-save"></i></button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card card-modern mb-3">
                            <div class="card-header"><i class="fas fa-filter me-1"></i> Filter Expenses</div>
                            <div class="card-body">
                                <form method="get" action="${pageContext.request.contextPath}/expenses" class="row g-2 align-items-end">
                                    <div class="col-md-6">
                                        <label class="form-label">Filter Date</label>
                                        <input type="date" name="date" class="form-control" value="<fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd'/>"/>
                                    </div>
                                    <div class="col-md-3 d-grid">
                                        <button class="btn btn-outline-primary btn-sm" type="submit">Apply</button>
                                    </div>
                                    <div class="col-md-3 d-grid">
                                        <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/expenses">Reset</a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Expense List Table -->
                  <div class="row">
                    <div class="col-md-6">
                <div class="card card-modern mb-4">
                    <div class="card-header"><i class="fas fa-table me-1"></i> Expense List</div>
                    <div class="card-body">
                        <table id="expensesTable" class="table table-striped table-hover table-sm align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
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
                                        <td><fmt:formatDate value="${e.date}" pattern="dd-MMM-yyyy"/></td>
                                        <td>${e.expenseName}</td>
                                        <td class="text-end"><fmt:formatNumber value="${e.amount}" type="number" minFractionDigits="2"/></td>
                                    </tr>
                                    <c:set var="total" value="${total + e.amount}"/>
                                </c:forEach>
                                <c:if test="${empty expenses}">
                                    <tr><td colspan="4" class="text-center text-muted">No expenses found</td></tr>
                                </c:if>
                            </tbody>
                            <tfoot class="table-light fw-bold">
                                <tr>
                                    <th colspan="3" class="text-end">Total</th>
                                    <th class="text-end"><fmt:formatNumber value="${total}" type="number" minFractionDigits="2"/></th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                </div>
                <div class="col-md-6">
<div class="card card-modern mb-4">
    <div class="card-header"><i class="fas fa-chart-bar me-1"></i> Monthly Expense Overview</div>
    <div class="card-body">
        <canvas id="monthlyExpenseChart" height="100"></canvas>
    </div>
</div>
  </div>
    </div>
            </div>
        </main>
    </div>
</div>

<!-- Logout form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js"></script>
<script>
// Sidebar toggle
document.addEventListener("DOMContentLoaded", () => {
    const sidebarToggle = document.getElementById("sidebarToggle");
    if (sidebarToggle) {
        sidebarToggle.addEventListener("click", (e) => {
            e.preventDefault();
            document.body.classList.toggle("sb-sidenav-toggled");
        });
    }
});

// DataTable init
const dataTable = document.getElementById('expensesTable');
if(dataTable) new simpleDatatables.DataTable(dataTable);
</script>

<!-- Add this where you want the chart, e.g., after the Expense List -->


<!-- Inside <script> tag at the bottom (after DataTable init) -->
<script>
document.addEventListener("DOMContentLoaded", () => {
    // Sidebar toggle
    const sidebarToggle = document.getElementById("sidebarToggle");
    if (sidebarToggle) {
        sidebarToggle.addEventListener("click", (e) => {
            e.preventDefault();
            document.body.classList.toggle("sb-sidenav-toggled");
        });
    }

    // DataTable init
    const dataTable = document.getElementById('expensesTable');
    if(dataTable) new simpleDatatables.DataTable(dataTable);

    // Chart.js - Monthly Expense Chart
    const ctx = document.getElementById('monthlyExpenseChart').getContext('2d');

    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: [
                <c:forEach var="m" items="${monthlyExpenses}" varStatus="vs">
                    '<c:out value="${m.month}"/>'<c:if test="${!vs.last}">,</c:if>
                </c:forEach>
            ],
            datasets: [{
                label: 'Total Expenses (₹)',
                data: [
                    <c:forEach var="m" items="${monthlyExpenses}" varStatus="vs">
                        <c:out value="${m.totalAmount}"/><c:if test="${!vs.last}">,</c:if>
                    </c:forEach>
                ],
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: (context) => `₹ ${context.parsed.y.toLocaleString()}`
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
                    }
                },
                x: {
                    ticks: {
                        callback: function(value, index, values) {
                            // Optional: format "2025-09" to "Sep 2025"
                            const raw = this.getLabelForValue(index);
                            const [year, month] = raw.split("-");
                            const date = new Date(year, month - 1);
                            return date.toLocaleString('default', { month: 'short', year: 'numeric' });
                        }
                    }
                }
            }
        }
    });
});
</script>

</body>
</html>
