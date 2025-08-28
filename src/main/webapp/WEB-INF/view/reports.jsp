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
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --brand-gradient: linear-gradient(135deg, #3c7bff, #70a1ff);
            --dark-gradient: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            --hover-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Enhanced Loader */
        #loader {
            display: none;
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            z-index: 9999;
            text-align: center;
            padding-top: 200px;
        }

        .spinner-border {
            width: 3rem;
            height: 3rem;
            border-width: 4px;
        }

        /* Brand Gradient Header */
        .sb-topnav {
            background: var(--brand-gradient) !important;
            box-shadow: 0 4px 20px rgba(60, 123, 255, 0.3);
            border: none;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }

        .navbar-brand:hover {
            transform: scale(1.05);
        }

        .navbar-brand .fa-calculator {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        /* Enhanced Sidebar */
        .sb-sidenav {
            background: var(--dark-gradient);
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1);
        }

        .sb-sidenav .nav-link {
            transition: all 0.3s ease;
            border-radius: 8px;
            margin: 2px 8px;
        }

        .sb-sidenav .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .sb-sidenav-menu-heading {
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            padding: 10px 16px;
            margin: 10px 0;
            border-radius: 8px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        /* Enhanced Cards */
        .card {
            border: none;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            overflow: hidden;
            background: white;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: var(--hover-shadow);
        }

        .card-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-bottom: none;
            padding: 1.5rem;
            font-weight: 600;
            border-radius: 20px 20px 0 0 !important;
        }

        /* Enhanced Form Styling */
        .form-control {
            border-radius: 12px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
            padding: 12px 16px;
        }

        .form-control:focus {
            border-color: #70a1ff;
            box-shadow: 0 0 20px rgba(112, 161, 255, 0.2);
            transform: translateY(-2px);
        }

        /* Enhanced Buttons */
        .btn {
            border-radius: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            padding: 12px 24px;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: all 0.6s ease;
        }

        .btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn-outline-success {
            background: var(--success-gradient);
            border: none;
            color: white;
        }

        .btn-outline-primary {
            background: var(--primary-gradient);
            border: none;
            color: white;
        }

        .btn-animate {
            transition: all 0.3s ease;
        }

        .btn-animate:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }

        /* Enhanced Tabs */
        .nav-tabs {
            border-bottom: none;
            gap: 8px;
        }

        .nav-tabs .nav-link {
            border: none;
            border-radius: 12px 12px 0 0;
            background: #f8f9fa;
            color: #6c757d;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .nav-tabs .nav-link.active {
            background: var(--brand-gradient);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(60, 123, 255, 0.3);
        }

        .nav-tabs .nav-link:hover:not(.active) {
            background: #e9ecef;
            transform: translateY(-2px);
        }

        /* Enhanced Tables */
        .table {
            border-radius: 12px;
            overflow: hidden;
        }

        .table thead th {
            background: var(--brand-gradient);
            color: white;
            border: none;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 16px;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background: linear-gradient(90deg, transparent, rgba(60, 123, 255, 0.05), transparent);
            transform: scale(1.01);
        }

        .table td {
            padding: 16px;
            border: none;
            border-bottom: 1px solid #f1f3f4;
        }

        /* Tab Content Animation */
        .tab-pane {
            animation: slideInUp 0.5s ease;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        /* Enhanced Search Bar */
        .input-group .form-control {
            background: rgba(255, 255, 255, 0.9);
            border: 2px solid rgba(255, 255, 255, 0.2);
            color: white;
        }

        .input-group .form-control::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .input-group .btn {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.2);
            color: white;
        }

        /* Floating Labels Effect */
        .form-floating {
            position: relative;
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }

        /* Enhanced Footer */
        footer {
            background: var(--dark-gradient);
            color: white;
            border-top: 3px solid #70a1ff;
        }

        footer a {
            color: #70a1ff;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        footer a:hover {
            color: #fff;
            text-shadow: 0 0 10px #70a1ff;
        }

        /* Responsive Enhancements */
        @media (max-width: 768px) {
            .card {
                margin-bottom: 1rem;
            }

            .btn {
                width: 100%;
                margin-bottom: 10px;
            }
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: var(--brand-gradient);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: var(--primary-gradient);
        }

        /* Loading Animation for Cards */
        .card-loading {
            position: relative;
            overflow: hidden;
        }

        .card-loading::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            animation: shimmer 1.5s infinite;
        }

        @keyframes shimmer {
            0% { left: -100%; }
            100% { left: 100%; }
        }

        /* Enhanced Dropdown */
        .dropdown-menu {
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            background: white;
        }

        .dropdown-item {
            transition: all 0.3s ease;
            border-radius: 8px;
            margin: 4px 8px;
        }

        .dropdown-item:hover {
            background: var(--brand-gradient);
            color: white;
            transform: translateX(5px);
        }

        /* Success/Error Messages */
        .alert {
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
        }

        /* DataTables Custom Styling */
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            border-radius: 8px;
            margin: 0 2px;
            transition: all 0.3s ease;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: var(--brand-gradient) !important;
            border: none !important;
            color: white !important;
        }

        .dataTables_wrapper .dataTables_filter input {
            border-radius: 12px;
            border: 2px solid #e9ecef;
            padding: 8px 12px;
        }
    </style>
</head>
<body class="sb-nav-fixed">

<!-- Enhanced Loader -->
<div id="loader">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
    <p class="mt-3 text-muted">Loading your reports...</p>
</div>

<!-- Enhanced Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark">
    <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">
        My <i class="fa fa-calculator text-warning"></i> Bill Book
    </a>
    <button class="btn btn-link btn-sm" id="sidebarToggle"><i class="fas fa-bars"></i></button>
    <form class="d-none d-md-inline-block form-inline ms-auto me-3">
        <div class="input-group">
            <input class="form-control" type="text" placeholder="Search reports..." />
            <button class="btn btn-outline-light" type="button"><i class="fas fa-search"></i></button>
        </div>
    </form>
    <ul class="navbar-nav ms-auto">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" id="navbarDropdown" data-bs-toggle="dropdown">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Profile</a></li>
                <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Settings</a></li>
                <li><hr class="dropdown-divider" /></li>
                <li><a class="dropdown-item" href="#" onclick="document.getElementById('logoutForm').submit()">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </a></li>
            </ul>
        </li>
    </ul>
</nav>

<!-- Enhanced Side Navbar -->
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/export-statement-file">
                                <i class="fas fa-chart-line me-2"></i>Daily Report
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">
                                <i class="fas fa-users me-2"></i>All Customers
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">
                                <i class="fas fa-search me-2"></i>Invoice Search
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">
                                <i class="fas fa-file-alt me-2"></i>Reports
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">
                                <i class="fas fa-box me-2"></i>Products
                            </a>
                        </nav>
                    </div>
                </div>
            </div>
            <div class="sb-sidenav-footer">
                <div class="small">Logged in as:</div>
                <strong>${pageContext.request.userPrincipal.name}</strong>
            </div>
        </nav>
    </div>

    <!-- Enhanced Main Content -->
    <div id="layoutSidenav_content">
        <main class="container-fluid mt-4">

            <!-- Enhanced Filter Form -->
            <div class="card mb-4 card-loading">
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
                                <input type="date" id="startDate" name="startDate" class="form-control" value="${startDate}" max="${today}" />
                            </div>
                            <div class="col-md-3">
                                <label for="endDate" class="form-label">
                                    <i class="fas fa-calendar-alt me-2"></i>To Date
                                </label>
                                <input type="date" id="endDate" name="endDate" class="form-control" value="${endDate}" max="${today}" />
                            </div>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-outline-success w-100 btn-animate">
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

            <!-- Enhanced Tabbed Results -->
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
                    <div class="tab-pane fade show active" id="invoice" role="tabpanel">
                        <div class="table-responsive">
                            <table class="table table-hover" id="datatablesSimple">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag me-2"></i>Invoice No</th>
                                        <th><i class="fas fa-user me-2"></i>Customer Name</th>
                                        <th class="text-end"><i class="fas fa-rupee-sign me-2"></i>Invoice Amt</th>
                                        <th class="text-end"><i class="fas fa-check-circle me-2"></i>Paid Amt</th>
                                        <th class="text-end"><i class="fas fa-clock me-2"></i>Closing Amt</th>
                                        <th class="text-end"><i class="fas fa-calendar me-2"></i>Date</th>
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
                    <div class="tab-pane fade" id="transaction" role="tabpanel">
                        <div class="table-responsive">
                            <table class="table table-hover" id="datatablesSimple1">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag me-2"></i>Transaction ID</th>
                                        <th><i class="fas fa-user me-2"></i>Customer Name</th>
                                        <th><i class="fas fa-info-circle me-2"></i>Description</th>
                                        <th class="text-end"><i class="fas fa-balance-scale me-2"></i>Closing Amt</th>
                                        <th><i class="fas fa-credit-card me-2"></i>Payment Mode</th>
                                        <th class="text-end"><i class="fas fa-deposit me-2"></i>Deposited Amt</th>
                                        <th class="text-end"><i class="fas fa-calendar me-2"></i>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${transactions}" var="balanceDeposit">
                                        <tr>
                                            <td><strong>${balanceDeposit.id}</strong></td>
                                            <td>${balanceDeposit.custName}</td>
                                            <td>${balanceDeposit.description}</td>
                                            <td class="text-end text-info">₹${balanceDeposit.currentOusting}</td>
                                            <td>
                                                <span class="badge bg-primary">${balanceDeposit.modeOfPayment}</span>
                                            </td>
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

            <!-- Enhanced Download Section -->
            <div class="row mt-4">
                <div class="col-12 d-flex justify-content-center">
                    <div class="card border-0" style="background: var(--brand-gradient); border-radius: 20px;">
                        <div class="card-body p-4">
                            <form action="${pageContext.request.contextPath}/company/export-statement-file-date" method="get" class="d-flex align-items-center gap-3">
                                <input type="hidden" name="startDate" value="${startDate}" />
                                <input type="hidden" name="endDate" value="${endDate}" />
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <div class="text-white">
                                    <h5 class="mb-1">Download Report</h5>
                                    <small>Get your filtered report as PDF</small>
                                </div>
                                <button class="btn btn-light btn-animate" type="submit" style="border-radius: 15px; padding: 12px 24px;">
                                    <i class="fas fa-file-pdf me-2 text-danger"></i> Download PDF
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Enhanced Footer -->
        <footer class="py-4 mt-auto">
            <div class="container-fluid px-4 d-flex justify-content-between align-items-center small">
                <div class="text-light">
                    <i class="fas fa-copyright me-2"></i>My Bill Book 2025 - All Rights Reserved
                </div>
                <div>
                    <a href="#" class="me-3">Privacy Policy</a>
                    <span class="text-muted">•</span>
                    <a href="#" class="ms-3">Terms & Conditions</a>
                </div>
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
        // Initialize DataTables
        const invoiceTable = new simpleDatatables.DataTable("#datatablesSimple", {
            searchable: true,
            sortable: true,
            perPageSelect: [10, 25, 50, 100]
        });

        const transactionTable = new simpleDatatables.DataTable("#datatablesSimple1", {
            searchable: true,
            sortable: true,
            perPageSelect: [10, 25, 50, 100]
        });

        // Form submission with loader
        $('#myform').on('submit', function (e) {
            const startDate = $('#startDate').val();
            const endDate = $('#endDate').val();

            if (startDate && endDate && startDate > endDate) {
                e.preventDefault();
                alert('Start date cannot be greater than end date!');
                return false;
            }

            $('#loader').fadeIn();
        });

        // Tab switching animation
        $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
            const targetPane = $($(e.target).attr('href'));
            targetPane.addClass('animate__animated animate__fadeInUp');
            setTimeout(() => {
                targetPane.removeClass('animate__animated animate__fadeInUp');
            }, 500);
        });

        // Remove card loading animation after page load
        setTimeout(() => {
            $('.card-loading').removeClass('card-loading');
        }, 1000);

        // Smooth scroll for internal links
        $('a[href^="#"]').on('click', function(event) {
            const target = $(this.getAttribute('href'));
            if(target.length) {
                event.preventDefault();
                $('html, body').stop().animate({
                    scrollTop: target.offset().top - 100
                }, 500);
            }
        });

        // Auto-hide alerts
        $('.alert').delay(5000).fadeOut();
    });

    // Clear form function
    function clearForm() {
        $('#startDate, #endDate').val('');
        $('form')[0].reset();
    }

    // Add ripple effect to buttons
    $('.btn').on('click', function(e) {
        const button = $(this);
        const ripple = $('<span class="ripple"></span>');

        const size = Math.max(button.outerWidth(), button.outerHeight());
        const x = e.pageX - button.offset().left - size / 2;
        const y = e.pageY - button.offset().top - size / 2;

        ripple.css({
            width: size,
            height: size,
            left: x,
            top: y
        }).appendTo(button);

        setTimeout(() => {
            ripple.remove();
        }, 600);
    });

    // Enhanced search functionality
    function enhancedSearch() {
        const searchInput = document.querySelector('input[type="text"][placeholder*="Search"]');
        if (searchInput) {
            searchInput.addEventListener('input', function(e) {
                const searchTerm = e.target.value.toLowerCase();
                // Add your custom search logic here
                console.log('Searching for:', searchTerm);
            });
        }
    }

    // Initialize enhanced features
    enhancedSearch();

    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl + K for search focus
        if (e.ctrlKey && e.key === 'k') {
            e.preventDefault();
            document.querySelector('input[placeholder*="Search"]').focus();
        }

        // Escape to clear search
        if (e.key === 'Escape') {
            const searchInput = document.querySelector('input[placeholder*="Search"]');
            if (searchInput && searchInput === document.activeElement) {
                searchInput.value = '';
                searchInput.blur();
            }
        }
    });

    // Add loading states for better UX
    function showLoading(element) {
        const originalText = element.innerHTML;
        element.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Loading...';
        element.disabled = true;

        return function hideLoading() {
            element.innerHTML = originalText;
            element.disabled = false;
        };
    }

    // Enhanced form validation
    function validateDateRange() {
        const startDate = document.getElementById('startDate');
        const endDate = document.getElementById('endDate');

        if (startDate.value && endDate.value) {
            if (new Date(startDate.value) > new Date(endDate.value)) {
                endDate.setCustomValidity('End date must be after start date');
                endDate.reportValidity();
                return false;
            } else {
                endDate.setCustomValidity('');
                return true;
            }
        }
        return true;
    }

    // Add event listeners for date validation
    document.getElementById('startDate').addEventListener('change', validateDateRange);
    document.getElementById('endDate').addEventListener('change', validateDateRange);
</script>

<!-- Additional CSS for ripple effect -->
<style>
    .btn {
        position: relative;
        overflow: hidden;
    }

    .ripple {
        position: absolute;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.6);
        transform: scale(0);
        animation: ripple-animation 0.6s linear;
        pointer-events: none;
    }

    @keyframes ripple-animation {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }

    /* Enhanced notification styles */
    .notification {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 20px;
        background: var(--brand-gradient);
        color: white;
        border-radius: 12px;
        box-shadow: var(--card-shadow);
        z-index: 1050;
        transform: translateX(400px);
        transition: transform 0.3s ease;
    }

    .notification.show {
        transform: translateX(0);
    }

    /* Print styles */
    @media print {
        .sb-topnav, .sb-sidenav, footer, .btn, .card-header {
            display: none !important;
        }

        .card {
            box-shadow: none !important;
            border: 1px solid #ddd !important;
        }

        .table {
            font-size: 12px;
        }
    }

    /* Dark mode support */
    @media (prefers-color-scheme: dark) {
        :root {
            --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            --hover-shadow: 0 15px 40px rgba(0, 0, 0, 0.4);
        }

        .card {
            background: #2d3748;
            color: #e2e8f0;
        }

        .table {
            color: #e2e8f0;
        }

        .form-control {
            background: #4a5568;
            border-color: #718096;
            color: #e2e8f0;
        }
    }
</style>