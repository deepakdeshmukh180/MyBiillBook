<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dashboard - My Bill Book</title>

    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --brand: #0d6efd;
            --soft: #f4f6f9;
            --ink: #33475b;
        }
        body { background: var(--soft); }

        /* Top Navbar */
        .sb-topnav {
            background: linear-gradient(135deg, #3c7bff, #70a1ff);
            border-bottom: 1px solid rgba(255, 255, 255, .08);
        }

        /* Cards */
        .card-modern {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 8px 22px rgba(0, 0, 0, .08);
        }
        .card-header {
            background: linear-gradient(135deg, #3c7bff, #70a1ff);
            color: #fff;
            font-weight: bold;
            border-top-left-radius: 18px;
            border-top-right-radius: 18px;
        }

        /* KPI */
        .kpi {
            border-radius: 14px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, .08);
            padding: 12px;
            transition: .2s;
        }
        .kpi:hover { transform: translateY(-4px); }
        .kpi .icon { font-size: 1.5rem; }

        /* Expense Item */
        .expense-item {
            border-radius: 14px;
            border: 1px dashed #d8e2ff;
            background: #fff;
            transition: .2s;
        }
        .expense-item:hover { transform: scale(1.01); background: #f8fbff; }

        /* Sidebar */
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">
                                <i class="fas fa-user-friends me-2 text-white"></i> All Customers
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">
                                <i class="fas fa-file-invoice me-2 text-white"></i> Invoices
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">
                                <i class="fas fa-chart-line me-2 text-white"></i> Reports
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">
                                <i class="fas fa-leaf me-2 text-white"></i> Products
                            </a>
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
        <main class="container-fluid mt-4">

            <!-- Filter Form -->
            <div class="card mb-4">
                <div class="card-header">
                    <i class="fas fa-filter me-2"></i> Filter Reports by Date
                </div>
                <div class="card-body">
                    <form id="myform" action="${pageContext.request.contextPath}/company/reportbydate" method="post">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label for="startDate" class="form-label">
                                    <i class="fas fa-calendar-alt me-2"></i>From Date
                                </label>
                                <input type="date" id="startDate" name="startDate" class="form-control"
                                       value="${startDate}" max="${today}"/>
                            </div>
                            <div class="col-md-3">
                                <label for="endDate" class="form-label">
                                    <i class="fas fa-calendar-alt me-2"></i>To Date
                                </label>
                                <input type="date" id="endDate" name="endDate" class="form-control"
                                       value="${endDate}" max="${today}"/>
                            </div>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-outline-success w-100">
                                    <i class="fas fa-search me-2"></i> Search Reports
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button type="reset" class="btn btn-outline-secondary w-100" onclick="clearForm()">
                                    <i class="fas fa-times me-2"></i> Clear
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Tabbed Results -->
            <div class="card mb-4">
                <div class="card-header p-0">
                    <ul class="nav nav-tabs card-header-tabs" id="reportTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="invoice-tab" data-bs-toggle="tab" href="#invoice" role="tab">
                                <i class="fas fa-file-invoice me-2"></i>Invoices
                                <span class="badge bg-light text-dark ms-2">${Invoices.size()}</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="transaction-tab" data-bs-toggle="tab" href="#transaction" role="tab">
                                <i class="fas fa-exchange-alt me-2"></i>Transactions
                                <span class="badge bg-light text-dark ms-2">${transactions.size()}</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <div class="card-body tab-content" id="reportTabsContent">
                    <!-- Invoices -->
                    <div class="tab-pane fade show active" id="invoice" role="tabpanel">
                        <div class="table-responsive">
                            <table class="table table-hover" id="datatablesSimple">
                                <thead>
                                <tr>
                                    <th>Invoice No</th>
                                    <th>Customer Name</th>
                                    <th class="text-end">Invoice Amt</th>
                                    <th class="text-end">Paid Amt</th>
                                    <th class="text-end">Closing Amt</th>
                                    <th class="text-end">Date</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${Invoices}" var="custmer">
                                    <tr>
                                        <td><strong>${custmer.invoiceId}</strong></td>
                                        <td>${custmer.custName}</td>
                                        <td class="text-end">₹${custmer.totInvoiceAmt}</td>
                                        <td class="text-end text-success">₹${custmer.advanAmt}</td>
                                        <td class="text-end text-warning">₹${custmer.balanceAmt}</td>
                                        <td class="text-end">${custmer.date}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Transactions -->
                    <div class="tab-pane fade" id="transaction" role="tabpanel">
                        <div class="table-responsive">
                            <table class="table table-hover" id="datatablesSimple1">
                                <thead>
                                <tr>
                                    <th>Transaction ID</th>
                                    <th>Customer Name</th>
                                    <th>Description</th>
                                    <th class="text-end">Closing Amt</th>
                                    <th>Payment Mode</th>
                                    <th class="text-end">Deposited Amt</th>
                                    <th class="text-end">Date</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${transactions}" var="balanceDeposit">
                                    <tr>
                                        <td><strong>${balanceDeposit.id}</strong></td>
                                        <td>${balanceDeposit.custName}</td>
                                        <td>${balanceDeposit.description}</td>
                                        <td class="text-end text-info">₹${balanceDeposit.currentOusting}</td>
                                        <td><span class="badge bg-primary">${balanceDeposit.modeOfPayment}</span></td>
                                        <td class="text-end text-success">₹${balanceDeposit.advAmt}</td>
                                        <td class="text-end">${balanceDeposit.createdAt}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Download Section -->
            <div class="row mt-4">
                <div class="col-12 d-flex justify-content-center">
                    <div class="card border-0" style="background: var(--brand); border-radius: 20px;">
                        <div class="card-body p-4 d-flex align-items-center gap-3 text-white">
                            <div>
                                <h5 class="mb-1">Download Report</h5>
                                <small>Get your filtered report as PDF</small>
                            </div>
                            <form action="${pageContext.request.contextPath}/company/export-statement-file-date"
                                  method="get" class="d-flex align-items-center gap-3">
                                <input type="hidden" name="startDate" value="${startDate}"/>
                                <input type="hidden" name="endDate" value="${endDate}"/>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button class="btn btn-light" type="submit" style="border-radius: 15px; padding: 12px 24px;">
                                    <i class="fas fa-file-pdf me-2 text-danger"></i> Download PDF
                                </button>
                            </form>
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
    if (document.getElementById('datatablesSimple'))
        new simpleDatatables.DataTable('#datatablesSimple');
    if (document.getElementById('datatablesSimple1'))
        new simpleDatatables.DataTable('#datatablesSimple1');
</script>
</body>
</html>
