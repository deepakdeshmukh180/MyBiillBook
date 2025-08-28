<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Report Dashboard - My Bill Book</title>

    <!-- Stylesheets -->
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

    <style>
        #loader {
            display: none;
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            background: rgba(255, 255, 255, 0.7);
            z-index: 9999;
            text-align: center;
            padding-top: 200px;
        }

        .btn-animate {
            transition: all 0.3s ease;
        }

        .btn-animate:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .nav-tabs .nav-link.active {
            background-color: #0d6efd;
            color: white;
        }

        .tab-pane {
            animation: fadeIn 0.3s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to   { opacity: 1; }
        }
    </style>
</head>
<body class="sb-nav-fixed">

<!-- Loader -->
<div id="loader">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
    <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">
        My <i class="fa fa-calculator text-danger"></i> Bill Book
    </a>
    <button class="btn btn-link btn-sm" id="sidebarToggle"><i class="fas fa-bars"></i></button>
    <form class="d-none d-md-inline-block form-inline ms-auto me-3">
        <div class="input-group">
            <input class="form-control" type="text" placeholder="Search for..." />
            <button class="btn btn-outline-primary" type="button"><i class="fas fa-search"></i></button>
        </div>
    </form>
    <ul class="navbar-nav ms-auto">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" id="navbarDropdown" data-bs-toggle="dropdown">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><hr class="dropdown-divider" /></li>
                <li><a class="dropdown-item" href="#" onclick="document.getElementById('logoutForm').submit()">Logout</a></li>
            </ul>
        </li>
    </ul>
</nav>

<!-- Side Navbar -->
<div id="layoutSidenav">
    <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
            <div class="sb-sidenav-menu">
                <div class="nav">
                    <div class="sb-sidenav-menu-heading">Core</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login/home">
                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                        Dashboard
                    </a>
                    <div class="sb-sidenav-menu-heading">Interface</div>
                    <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts">
                        <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>
                        Menu
                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                    </a>
                    <div class="collapse" id="collapseLayouts">
                        <nav class="sb-sidenav-menu-nested nav">
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/export-statement-file">Daily Report</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">All Customers</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">Invoice Search</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">Reports</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">Products</a>
                        </nav>
                    </div>
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
        <main class="container-fluid mt-4">

            <!-- Filter Form -->
            <div class="card mb-4">
                <div class="card-header"><i class="fas fa-filter me-1"></i> Filter Reports by Date</div>
                <div class="card-body">
                    <form id="myform" action="${pageContext.request.contextPath}/company/reportbydate" method="post">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label for="startDate" class="form-label">From</label>
                                <input type="date" id="startDate" name="startDate" class="form-control" value="${startDate}" max="${today}" />
                            </div>
                            <div class="col-md-3">
                                <label for="endDate" class="form-label">To</label>
                                <input type="date" id="endDate" name="endDate" class="form-control" value="${endDate}" max="${today}" />
                            </div>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-outline-success w-100">
                                    <i class="fas fa-search"></i> Search
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Tabbed Results -->
            <div class="card mb-4">
                <div class="card-header">
                    <ul class="nav nav-tabs card-header-tabs" id="reportTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="invoice-tab" data-bs-toggle="tab" href="#invoice" role="tab">Invoices</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="transaction-tab" data-bs-toggle="tab" href="#transaction" role="tab">Transactions</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body tab-content" id="reportTabsContent">
                    <div class="tab-pane fade show active" id="invoice" role="tabpanel">
                        <div class="table-responsive">
                            <table class="table table-striped" id="datatablesSimple">
                                <thead class="table-secondary">
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
                                            <td>${custmer.invoiceId}</td>
                                            <td>${custmer.custName}</td>
                                            <td class="text-end">${custmer.totInvoiceAmt}</td>
                                            <td class="text-end">${custmer.advanAmt}</td>
                                            <td class="text-end">${custmer.balanceAmt}</td>
                                            <td class="text-end">${custmer.date}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="transaction" role="tabpanel">
                        <div class="table-responsive">
                            <table class="table table-striped" id="datatablesSimple1">
                                <thead class="table-secondary">
                                    <tr>
                                        <th>Transaction Id</th>
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
                                            <td>${balanceDeposit.id}</td>
                                            <td>${balanceDeposit.custName}</td>
                                            <td>${balanceDeposit.description}</td>
                                            <td class="text-end">${balanceDeposit.currentOusting}</td>
                                            <td>${balanceDeposit.modeOfPayment}</td>
                                            <td class="text-end">${balanceDeposit.advAmt}</td>
                                            <td class="text-end">${balanceDeposit.createdAt}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Download Button -->
            <div class="row mt-4">
                <div class="col-12 d-flex justify-content-center">
                    <form action="${pageContext.request.contextPath}/company/export-statement-file-date" method="get" style="width: 200px;">
                        <input type="hidden" name="startDate" value="${startDate}" />
                        <input type="hidden" name="endDate" value="${endDate}" />
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button class="btn btn-outline-primary w-100 btn-animate" type="submit">
                            <i class="fas fa-file-pdf me-2"></i> Download PDF
                        </button>
                    </form>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="py-4 bg-light mt-auto">
            <div class="container-fluid px-4 d-flex justify-content-between small">
                <div class="text-muted">© My Bill Book 2025</div>
                <div><a href="#">Privacy Policy</a> &middot; <a href="#">Terms & Conditions</a></div>
            </div>
        </footer>
    </div>

    <!-- Logout Form -->
    <form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        new simpleDatatables.DataTable("#datatablesSimple");
        new simpleDatatables.DataTable("#datatablesSimple1");

        $('#myform').on('submit', function () {
            $('#loader').fadeIn();
        });
    });
</script>
</body>
</html>
