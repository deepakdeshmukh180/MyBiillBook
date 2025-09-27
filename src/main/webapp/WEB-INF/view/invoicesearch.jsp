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
        --success-light: #d1edff;
        --warning-light: #fff3cd;
        --danger-light: #f8d7da;
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
<body class="sb-nav-fixed">

<!-- Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark brand-gradient">
    <a class="navbar-brand ps-3 fw-bold" href="#" onclick="showSection('dashboard')">
          <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgwIiBoZWlnaHQ9IjQwIiB2aWV3Qm94PSIwIDAgMTgwIDQwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iNSIgeTE9IjMiIHgyPSIyNSIgeTI9IjI3IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiNmZmZmZmYiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjZjJmMmYyIi8+CjwvbGluZWFyR3JhZGllbnQ+CjxsaW5lYXJHcmFkaWVudCBpZD0icGFpbnQxX2xpbmVhciIgeDE9IjE3IiB5MT0iMTMiIHgyPSIyOCIgeTI9IjI0IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMxMEI5ODEiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDU5NjY5Ii8+CjwvbGluZWFyR3JhZGllbnQ+CjwvZGVmcz4KPCEtLSBEb2N1bWVudC9CaWxsIEljb24gLS0+CjxyZWN0IHg9IjUiIHk9IjMiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyNCIgcng9IjMiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcikiLz4KPCEtLSBMaW5lcyBvbiBkb2N1bWVudCAtLT4KPHBhdGggZD0iTTkgOWg4bS04IDNaNW0tNSAzaDciIHN0cm9rZT0iIzJGNDc1OSIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPCEtLSBDaGVja21hcmsgLS0+CjxjaXJjbGUgY3g9IjIyLjUiIGN5PSIxOC41IiByPSI1LjUiIGZpbGw9InVybCgjcGFpbnQxX2xpbmVhcikiLz4KPHBhdGggZD0ibTIwIDE4LjUgMiAyIDQtNCIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8IS0tIFRleHQgLS0+Cjx0ZXh0IHg9IjM1IiB5PSIxNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmb250LXdlaWdodD0iNzAwIiBmaWxsPSJ3aGl0ZSI+CkJpbGxNYXRlUHJvPC90ZXh0Pgo8dGV4dCB4PSIzNSIgeT0iMjYiIGZvbnQtZmFtaWx5PSJJbnRlciwgc2Fucy1zZXJpZiIgZm9udC1zaXplPSI4IiBmaWxsPSIjZTJlOGYwIj4KWW91ciBCaWxsaW5nIFBhcnRuZXI8L3RleHQ+Cjwvc3ZnPg=="
               alt="BillMatePro" style="height: 50px; margin-right: 8px;">
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

            <!-- Header Controls -->
            <div class="card my-4 p-3 shadow-soft rounded-lg">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">
                        <i class="fa fa-file-invoice text-primary me-2"></i> Invoices
                        <span class="badge bg-primary ms-2">${totalInvoices}</span>
                    </h5>
                    <input id="searchBox" type="text" class="form-control form-control-sm search-bar mt-2 mt-md-0"
                           placeholder="Search Invoice ID / Customer Name..."/>
                </div>
            </div>

            <!-- Invoice Cards Container -->
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
            <div id="paginationContainer" style="style=" padding-bottom: 4%;" class="d-flex justify-content-between flex-wrap gap-2 mt-4">
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

<div id="invoiceCardContainer" class="row g-3">
    <!-- Original cards here -->
</div>

<div id="paginationContainer" class="d-flex justify-content-center mt-3">
    <!-- Original pagination here -->
</div>

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