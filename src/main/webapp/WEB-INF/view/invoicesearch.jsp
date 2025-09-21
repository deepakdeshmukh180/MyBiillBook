<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - My Bill Book</title>

    <!-- Bootstrap & Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
<style>
    :root {
        --brand: #0d6efd;
        --soft: #f4f6f9;
        --ink: #33475b;
        --radius-lg: 18px;
    }

    body {
        background: var(--soft);
        font-size: 0.95rem;
        margin: 0;
        color: var(--ink);
    }

    .section-title {
        font-weight: 700;
        color: var(--ink);
            padding-top: 2%;
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
            overflow: hidden; /* Prevent background scroll */
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
<body class="sb-nav-fixed">

<!-- Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark brand-gradient">
    <a class="navbar-brand ps-3 fw-bold" href="${pageContext.request.contextPath}/login/home">
        My <i class="fa fa-calculator text-warning"></i> Bill Book
    </a>
    <button class="btn btn-outline-light btn-sm ms-2" id="sidebarToggle">
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
                    <div class="sb-sidenav-menu-heading">Menu</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">
                        <div class="sb-nav-link-icon"><i class="fas fa-file-invoice"></i></div> Invoices
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">
                        <div class="sb-nav-link-icon"><i class="fas fa-box"></i></div> Products
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">
                        <div class="sb-nav-link-icon"><i class="fas fa-chart-line"></i></div> Reports
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
                        <div class="sb-nav-link-icon"><i class="fa fa-gear fa-spin"></i></div> Account Settings
                    </a>
                </div>
            </div>
            <div class="sb-sidenav-footer">
                <div class="small">Logged in as:</div>
                ${pageContext.request.userPrincipal.name}
            </div>
        </nav>
    </div>

    <!-- Overlay for mobile -->
    <div class="overlay" id="sidebarOverlay"></div>

    <!-- Main Content -->
    <div id="layoutSidenav_content">
        <div class="container-fluid px-4">

        <h4 class="section-title mb-4">
                            <i class="bi bi-receipt me-2"></i> Invoice Section
                        </h4>

            <!-- Invoices Card -->
            <div class="card my-4 p-3 shadow-soft rounded-18">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">
                        <i class="fa fa-file-invoice text-primary me-2"></i> Invoices
                        <span class="badge bg-primary ms-2">${totalInvoices}</span>
                    </h5>
                    <input id="searchBox" type="text" class="form-control form-control-sm search-bar mt-2 mt-md-0"
                           placeholder="Search Invoice ID / Customer Name..."/>
                </div>

                <!-- Responsive Table -->
                <div class="table-responsive">
                    <table class="table table-hover align-middle text-center table-bordered mb-0">
                        <thead class="table-light small text-nowrap">
                        <tr>
                            <th>Invoice No</th>
                            <th>Customer</th>
                            <th class="text-end">Qty</th>
                            <th class="text-end">Invoice</th>
                            <th class="text-end">Balance</th>
                            <th class="text-end">Discount</th>
                            <th class="text-end">Paid</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody id="invoiceTableBody">
                        <c:forEach var="invoice" items="${invoices}">
                            <tr class="
                                <c:choose>
                                    <c:when test='${invoice.invoiceType eq "CREDIT"}'>table-danger</c:when>
                                    <c:when test='${invoice.invoiceType eq "PARTIAL"}'>table-warning</c:when>
                                    <c:when test='${invoice.invoiceType eq "PAID"}'>table-success</c:when>
                                </c:choose>
                            ">
                                <td class="text-nowrap">
                                    <a href="${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}"
                                       class="fw-bold text-decoration-none text-primary" target="_blank">
                                        ${invoice.invoiceId}
                                    </a>
                                </td>
                                <td class="fw-semibold text-capitalize">${invoice.custName}</td>
                                <td class="text-end">${invoice.totQty}</td>
                                <td class="text-end">₹<fmt:formatNumber value="${invoice.totInvoiceAmt}" type="number" minFractionDigits="2" /></td>
                                <td class="text-end">₹<fmt:formatNumber value="${invoice.balanceAmt}" type="number" minFractionDigits="2" /></td>
                                <td class="text-end">₹<fmt:formatNumber value="${invoice.discount}" type="number" minFractionDigits="2" /></td>
                                <td class="text-end">₹<fmt:formatNumber value="${invoice.advanAmt}" type="number" minFractionDigits="2" /></td>
                                <td>
                                    <span class="badge
                                        <c:choose>
                                            <c:when test='${invoice.invoiceType eq "CREDIT"}'>bg-danger text-dark</c:when>
                                            <c:when test='${invoice.invoiceType eq "PARTIAL"}'>bg-warning text-dark</c:when>
                                            <c:when test='${invoice.invoiceType eq "PAID"}'>bg-success</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>
                                    ">
                                        ${invoice.invoiceType}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pagination -->
            <div id="paginationContainer" class="d-flex justify-content-between flex-wrap gap-2">
                <div class="text-muted small">Page <strong>${page + 1}</strong> of <strong>${totalPages}</strong></div>
                <c:if test="${totalPages > 0}">
                    <ul class="pagination pagination-sm mb-0 flex-wrap">
                        <c:if test="${page > 0}">
                            <li class="page-item"><a class="page-link"
                                href="${pageContext.request.contextPath}/company/get-all-invoices?page=${page - 1}">&laquo; Prev</a></li>
                        </c:if>
                        <c:forEach begin="${page - 2 < 0 ? 0 : page - 2}"
                                   end="${page + 2 >= totalPages ? totalPages - 1 : page + 2}" var="i">
                            <li class="page-item ${page == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-invoices?page=${i}">${i + 1}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${page < totalPages - 1}">
                            <li class="page-item"><a class="page-link"
                                href="${pageContext.request.contextPath}/company/get-all-invoices?page=${page + 1}">Next &raquo;</a></li>
                        </c:if>
                    </ul>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
const contextPath = '${pageContext.request.contextPath}';
const searchInput = document.getElementById('searchBox');
const tbody = document.getElementById('invoiceTableBody');
const paginationContainer = document.getElementById('paginationContainer');
let debounceTimer;

// Save original table & pagination
const originalTable = tbody.innerHTML;
const originalPagination = paginationContainer.innerHTML;

// Show spinner
function showSpinner() {
    tbody.innerHTML = `
        <tr>
            <td colspan="8" class="text-center py-4">
                <div class="spinner-border text-primary" role="status"></div>
                <div class="mt-2 text-muted small">Searching invoices...</div>
            </td>
        </tr>`;
}

// Search functionality
searchInput.addEventListener('input', function () {
    const query = this.value.trim();
    clearTimeout(debounceTimer);

    if (query.length < 2) {
        tbody.innerHTML = originalTable;
        paginationContainer.innerHTML = originalPagination;
        paginationContainer.style.display = 'flex';
        return;
    }

    debounceTimer = setTimeout(() => {
        showSpinner();

        fetch(contextPath + '/company/search-invoices?query=' + encodeURIComponent(query))
            .then(res => {
                if (!res.ok) throw new Error("HTTP error " + res.status);
                return res.json();
            })
            .then(data => {
                tbody.innerHTML = '';
                if (!data || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" class="text-muted">No matching invoices found.</td></tr>';
                    paginationContainer.style.display = 'none';
                    return;
                }
                paginationContainer.style.display = 'none';

                data.forEach(inv => {
                    let rowClass = "", badgeClass = "";
                    if (inv.invoiceType === "CREDIT") { rowClass = "table-danger"; badgeClass = "bg-danger text-dark"; }
                    else if (inv.invoiceType === "PARTIAL") { rowClass = "table-warning"; badgeClass = "bg-warning text-dark"; }
                    else if (inv.invoiceType === "PAID") { rowClass = "table-success"; badgeClass = "bg-success"; }
                    else { badgeClass = "bg-secondary"; }

                    const tr = document.createElement('tr');
                    tr.className = rowClass;
                    tr.innerHTML =
                        '<td><a href="' + contextPath + '/company/get-invoice/' + inv.custId + '/' + inv.invoiceId + '" target="_blank" class="fw-bold text-decoration-none text-primary">' + inv.invoiceId + '</a></td>' +
                        '<td class="fw-semibold text-capitalize">' + inv.custName + '</td>' +
                        '<td class="text-end">' + (inv.totQty ?? 0) + '</td>' +
                        '<td class="text-end">₹' + Number(inv.totInvoiceAmt || 0).toFixed(2) + '</td>' +
                        '<td class="text-end">₹' + Number(inv.balanceAmt || 0).toFixed(2) + '</td>' +
                        '<td class="text-end">₹' + Number(inv.discount || 0).toFixed(2) + '</td>' +
                        '<td class="text-end">₹' + Number(inv.advanAmt || 0).toFixed(2) + '</td>' +
                        '<td><span class="badge ' + badgeClass + '">' + inv.invoiceType + '</span></td>';
                    tbody.appendChild(tr);
                });
            })
            .catch(err => {
                console.error('Search error:', err);
                tbody.innerHTML = '<tr><td colspan="8" class="text-danger">Error loading search results.</td></tr>';
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
