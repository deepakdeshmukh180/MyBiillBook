<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Dashboard - My Bill Book</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>

    <!-- Custom Styles -->
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />

    <style>
        .card-header {
            background: linear-gradient(to right, #0d6efd, #6610f2);
            color: #fff;
            font-weight: bold;
        }

        #searchInput {
            border: 2px solid #0d6efd;
            border-radius: 20px;
            padding-left: 15px;
        }

        #searchDropdown {
            position: absolute;
            top: calc(100% + 5px); /* Push dropdown 5px below the search box */
            z-index: 1050;
            width: 100%;
            background: white;
            border-radius: 0.25rem;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            max-height: 300px;
            overflow-y: auto;
            display: none;
        }




        .invoice-card.compact {
            background: #f4f4f4;
            border-left: 3px solid #007bff;
            padding: 8px 12px;
            border-radius: 5px;
        }

        .invoice-details {
            display: flex;
            justify-content: space-between;
        }

        @media (max-width: 576px) {
            .invoice-details {
                flex-direction: column;
                gap: 4px;
            }

            .pagination {
                flex-wrap: wrap;
            }

            .table th, .table td {
                font-size: 12px;
            }

            #searchDropdown {
                width: 100% !important;
            }
        }

        .badge-total { background-color: #0d6efd; }
        .badge-paid { background-color: #198754; }
        .badge-balance { background-color: #dc3545; }
    </style>
</head>
<body class="sb-nav-fixed">



<!-- Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
    <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">My <i class="fa fa-calculator text-danger"></i> Bill Book</a>
    <button class="btn btn-link btn-sm order-1 order-lg-0" id="sidebarToggle"><i class="fas fa-bars"></i></button>
    <ul class="navbar-nav ms-auto me-3">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown"><i class="fas fa-user fa-fw"></i></a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="#" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
            </ul>
        </li>
    </ul>
</nav>

<!-- Sidebar + Main Layout -->
<div id="layoutSidenav">
    <!-- Sidebar -->
    <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion sb-sidenav-dark">
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
                    <div class="collapse" id="collapseLayouts">
                        <nav class="sb-sidenav-menu-nested nav">
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">All Customers</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">Invoice Search</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">Reports</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">Products</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/export-to-pdf">Export Customers</a>
                        </nav>
                    </div>
                </div>
            </div>
        </nav>
    </div>

    <!-- Main Content -->
    <div id="layoutSidenav_content">
        <main class="container-fluid mt-4 px-3 px-md-4">
            <div class="card mb-4">
                <div class="card-header d-flex flex-column flex-md-row justify-content-between gap-3">
                    <div>
                        <i class="fas fa-users me-2"></i><strong>All Invoices</strong>
                        <span class="badge bg-light text-dark ms-2">Total: ${totalCustomers}</span>
                    </div>
                    <div class="w-100 w-md-auto position-relative d-flex gap-2">
                        <input id="searchInput" class="form-control form-control-sm" placeholder="Search by Customer Name/ Invoice No" autocomplete="off" />
                        <div id="searchDropdown" class="list-group position-absolute mt-1"></div>
                        <button class="btn btn-outline-secondary btn-sm" onclick="resetSearch()">Reset</button>
                    </div>
                </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle text-center">
                        <thead class="table-secondary">
                            <tr>
                                <th>Invoice No</th>
                                <th>Customer Name</th>
                                <th>Pre Tax Amt</th>
                                <th>GST</th>
                                <th>Total Amt</th>
                                <th>Advance</th>
                                <th>Balance</th>
                                <th>Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="invoiceTableBody">
                            <c:if test="${totalPages > 0}">
                                <c:forEach items="${invoices}" var="invoice">
                                    <tr>
                                        <td><a href="${pageContext.request.contextPath}/company/get-invoice-details/${invoice.custId}/${invoice.invoiceId}" target="_blank">${invoice.invoiceId}</a></td>
                                        <td>${invoice.custName}</td>
                                        <td><span class="badge badge-total">&#x20b9; ${invoice.preTaxAmt}</span></td>
                                        <td><span class="badge badge-total">&#x20b9; ${invoice.tax}</span></td>
                                        <td><span class="badge badge-total">&#x20b9; ${invoice.totInvoiceAmt}</span></td>
                                        <td><span class="badge badge-paid">&#x20b9; ${invoice.advanAmt}</span></td>
                                        <td><span class="badge badge-balance">&#x20b9; ${invoice.balanceAmt}</span></td>
                                        <td>${invoice.createdAt}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}" class="btn btn-sm btn-link">
                                                <i class="fas fa-eye"></i> View
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination (unchanged) -->
                <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center mt-3">
                    <div class="text-muted">Page <strong>${page + 1}</strong> of <strong>${totalPages}</strong></div>
                    <c:if test="${totalPages > 0}">
                        <ul class="pagination pagination-sm mb-0 mt-2 mt-sm-0">
                            <c:if test="${page > 0}">
                                <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/company/get-all-invoices?page=${page - 1}">&laquo; Prev</a></li>
                            </c:if>
                            <c:forEach begin="${page - 2 < 0 ? 0 : page - 2}" end="${page + 2 >= totalPages ? totalPages - 1 : page + 2}" var="i">
                                <li class="page-item ${page == i ? 'active' : ''}"><a class="page-link" href="${pageContext.request.contextPath}/company/get-all-invoices?page=${i}">${i + 1}</a></li>
                            </c:forEach>
                            <c:if test="${page < totalPages - 1}">
                                <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/company/get-all-invoices?page=${page + 1}">Next &raquo;</a></li>
                            </c:if>
                        </ul>
                    </c:if>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer (unchanged) -->
</div>

<!-- Logout Form and scripts... -->

<script>
    const searchInput = document.getElementById('searchInput');
    const searchDropdown = document.getElementById('searchDropdown');
    let debounceTimer;

    const contextPath = '${pageContext.request.contextPath}';


    // Format number as Indian Rupee currency
    function formatCurrency(amount) {
        if (amount == null || amount === '') return '₹0';
        return new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 2 }).format(amount);
    }

    searchInput.addEventListener('input', function () {
        const query = this.value.trim();
        clearTimeout(debounceTimer);

        if (query.length < 2) {
            searchDropdown.style.display = 'none';
            return;
        }

        debounceTimer = setTimeout(() => {
            fetch(`${pageContext.request.contextPath}/company/search-invoice?query=` + query)
                .then(res => res.json())
                .then(data => {
                    searchDropdown.innerHTML = '';
                    searchDropdown.style.display = 'block';

                    if (!data.length) {
                        searchDropdown.innerHTML = '<div class="list-group-item text-muted small"><i class="fas fa-user"></i> No matches found</div>';
                        return;
                    }

                    data.forEach(c => {
                        const item = document.createElement('div');
                        item.className = 'list-group-item invoice-card compact';


                       item.innerHTML =
                           '<div class="cust-name fw-bold">' + c.custName + '</div>' +
                           '<div class="invoice-details">' +
                               '<span><i class="fas fa-file-invoice"></i> Bill No: ' + c.invoiceId + '</span><br>' +
                               '<span><i class="fas fa-calendar-alt"></i> Date: ' + c.createdAt + '</span><br>' +
                               '<span class="amount badge bg-success text-white">' + formatCurrency(c.totInvoiceAmt) + '</span>' +
                           '</div>';
                        item.addEventListener('click', () => {
                            searchInput.value = c.invoiceId;
                            searchDropdown.innerHTML = '';
                            searchDropdown.style.display = 'none';
                            loadInvoiceTable([c]); // Wrap single result in array
                        });

                        searchDropdown.appendChild(item);
                    });
                });
        }, 300);
    });

    document.addEventListener('click', (e) => {
        if (!searchDropdown.contains(e.target) && e.target !== searchInput) {
            searchDropdown.style.display = 'none';
        }
    });

    function loadInvoiceTable(invoices) {
        const tbody = document.getElementById('invoiceTableBody');
        tbody.innerHTML = ''; // Clear existing rows

        invoices.forEach(invoice => {
            const row = document.createElement('tr');

            row.innerHTML =
                '<td><a href="' + contextPath + '/company/get-invoice-details/' + invoice.custId + '/' + invoice.invoiceId + '" target="_blank">' + invoice.invoiceId + '</a></td>' +
                '<td>' + (invoice.custName || 'N/A') + '</td>' +
                '<td><span class="badge badge-total">' + formatCurrency(invoice.preTaxAmt) + '</span></td>' +
                '<td><span class="badge badge-total">' + formatCurrency(invoice.tax) + '</span></td>' +
                '<td><span class="badge badge-total">' + formatCurrency(invoice.totInvoiceAmt) + '</span></td>' +
                '<td><span class="badge badge-paid">' + formatCurrency(invoice.advanAmt) + '</span></td>' +
                '<td><span class="badge badge-balance">' + formatCurrency(invoice.balanceAmt) + '</span></td>' +
                '<td>' + (invoice.createdAt || '') + '</td>' +
                '<td><a href="' + contextPath + '/company/get-invoice/' + invoice.custId + '/' + invoice.invoiceId + '" class="btn btn-sm btn-link"><i class="fas fa-eye"></i> View</a></td>';

            tbody.appendChild(row);
        });

        // Hide pagination when showing search results
        const pagination = document.querySelector('.pagination');
        if (pagination) pagination.classList.add('d-none');
    }

    function resetSearch() {
        searchInput.value = '';
        searchDropdown.innerHTML = '';
        searchDropdown.style.display = 'none';

        // Reload the full invoice table by reloading the page
        window.location.href = `${pageContext.request.contextPath}/company/get-all-invoices`;
    }
</script>


</body>
</html>
