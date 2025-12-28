<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="../view/logo.jsp"></jsp:include>

<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --shadow-sm: 0 2px 4px rgba(0,0,0,0.08);
        --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
        --shadow-lg: 0 4px 12px rgba(0,0,0,0.15);
        --transition: all 0.2s ease;
    }

    .stats-card {
        background: var(--primary-gradient);
        color: white;
        border-radius: 10px;
        padding: 15px 20px;
        box-shadow: var(--shadow-md);
    }

    .stats-card h5 {
        font-size: 0.85rem;
        opacity: 0.9;
        margin-bottom: 5px;
    }

    .stats-card h3 {
        font-size: 1.6rem;
        font-weight: bold;
        margin: 0;
    }

    .invoice-row {
        transition: var(--transition);
        cursor: pointer;
    }

    .invoice-row:hover {
        background-color: #f8f9fa;
        transform: scale(1.005);
        box-shadow: var(--shadow-sm);
    }

    .btn-action {
        width: 32px;
        height: 32px;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 6px;
        transition: var(--transition);
        margin: 0 2px;
    }

    .btn-action:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    .badge-credit { background-color: #dc3545; color: white; }
    .badge-partial { background-color: #ffc107; color: #000; }
    .badge-paid { background-color: #28a745; color: white; }

    .filter-badge {
        display: inline-block;
        padding: 6px 16px;
        border-radius: 20px;
        font-size: 0.8rem;
        margin: 3px;
        cursor: pointer;
        transition: var(--transition);
        border: 1px solid #ddd;
    }

    .filter-badge:hover {
        transform: scale(1.05);
        box-shadow: var(--shadow-sm);
    }

    .filter-badge.active {
        background-color: #667eea;
        color: white;
        border-color: #667eea;
    }

    .invoice-items-cell {
        max-width: 300px;
        font-size: 0.85rem;
        line-height: 1.4;
    }

    .item-entry {
        padding: 4px 0;
        border-bottom: 1px dashed #e0e0e0;
    }

    .item-entry:last-child {
        border-bottom: none;
    }

    .item-name {
        font-weight: 600;
        color: #2c3e50;
    }

    .item-details {
        color: #7f8c8d;
        font-size: 0.8rem;
    }

    .items-preview {
        max-height: 100px;
        overflow-y: auto;
        padding-right: 5px;
        FONT-SIZE: smaller;

    }

    .items-preview::-webkit-scrollbar {
        width: 4px;
    }

    .items-preview::-webkit-scrollbar-thumb {
        background: #ccc;
        border-radius: 4px;
    }

    .compact-table th,
    .compact-table td {
        padding: 8px 10px;
        font-size: 0.9rem;
    }

    .fade-in {
        animation: fadeIn 0.3s ease-in;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .search-section {
        background: white;
        border-radius: 8px;
        padding: 15px;
        box-shadow: var(--shadow-sm);
        margin-bottom: 20px;
    }

    .action-buttons {
        display: flex;
        gap: 5px;
    }

    @media (max-width: 768px) {
        .invoice-items-cell {
            max-width: 200px;
        }
        .compact-table {
            font-size: 0.8rem;
        }
    }

    @media print {
        .btn, .pagination, .filter-badge, .search-section, #searchBox, .input-group {
            display: none !important;
        }
        .table { font-size: 11px; }
        .invoice-items-cell { max-width: 250px; }
    }
</style>

<div id="layoutSidenav_content">
<main>
<div class="container-fluid px-4 mt-4">

    <!-- Success Alert -->
    <c:if test="${not empty msg}">
        <div class="alert alert-success alert-dismissible fade show fade-in" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Header with Stats -->
    <div class="row align-items-center mb-3">
        <div class="col-md-8">
            <h2 class="h3 mb-0 text-gray-800">Invoice Management</h2>
            <p class="text-muted mb-0">View and manage all your invoices</p>
        </div>
        <div class="col-md-4">
            <div class="stats-card">
                <h5>Total Invoices</h5>
                <h3>${totalInvoices}</h3>
                <small><i class="fas fa-chart-line me-1"></i>All records</small>
            </div>
        </div>
    </div>

    <!-- Quick Filters -->
    <div class="mb-3">
        <span class="filter-badge bg-light active" data-filter="all" onclick="filterInvoices('all')">
            <i class="fas fa-file-invoice me-1"></i>All
        </span>
        <span class="filter-badge bg-light" data-filter="credit" onclick="filterInvoices('credit')">
            <i class="fas fa-exclamation-circle me-1"></i>Credit
        </span>
        <span class="filter-badge bg-light" data-filter="partial" onclick="filterInvoices('partial')">
            <i class="fas fa-clock me-1"></i>Partial
        </span>
        <span class="filter-badge bg-light" data-filter="paid" onclick="filterInvoices('paid')">
            <i class="fas fa-check-circle me-1"></i>Paid
        </span>
    </div>

    <!-- Search & Actions -->
    <div class="search-section">
        <div class="row g-2 align-items-center">
            <div class="col-md-6">
                <div class="input-group input-group-sm">
                    <span class="input-group-text bg-white border-end-0">
                        <i class="fas fa-search text-muted"></i>
                    </span>
                    <input type="text" id="searchBox" class="form-control border-start-0"
                           placeholder="Search by customer name or phone...">
                </div>
            </div>
            <div class="col-md-6 text-end">
                <button class="btn btn-outline-primary btn-sm" onclick="exportToExcel()">
                    <i class="fas fa-file-excel me-1"></i>Excel
                </button>
                <button class="btn btn-outline-secondary btn-sm" onclick="printTable()">
                    <i class="fas fa-print me-1"></i>Print
                </button>
                <button class="btn btn-outline-danger btn-sm" onclick="clearSearch()">
                    <i class="fas fa-times me-1"></i>Clear
                </button>
                <button class="btn btn-outline-secondary btn-sm" onclick="location.reload();">
                    <i class="fas fa-sync-alt me-1"></i>Refresh
                </button>
            </div>
        </div>
    </div>

    <!-- Page Loader -->
    <div id="pageLoader"
         style="display:none; position:fixed; z-index:9999; top:0; left:0; width:100%; height:100%;
         background:rgba(0,0,0,0.4); backdrop-filter: blur(2px);">
        <div style="position:absolute; top:50%; left:50%; transform:translate(-50%, -50%);
             padding:20px; background:white; border-radius:8px; font-weight:bold;">
             <div class="spinner-border text-primary me-2" role="status"></div>
             Loading...
        </div>
    </div>

    <!-- Results Summary -->
    <div id="resultsSummary" class="alert alert-info alert-dismissible fade-in" style="display:none;">
        <i class="fas fa-info-circle me-2"></i>
        <span id="resultsText"></span>
        <button type="button" class="btn-close" onclick="clearSearch()"></button>
    </div>



    <!-- Invoice Table -->
    <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle compact-table" id="invoiceTable">
            <thead class="table-dark">
                <tr>
                    <th width="40">#</th>
                    <th width="100">
                        <i class="fas fa-hashtag me-1"></i>Invoice ID
                        <i class="fas fa-sort ms-1" style="cursor:pointer;" onclick="sortTable(1)"></i>
                    </th>
                    <th width="150">
                        <i class="fas fa-user me-1"></i>Customer
                        <i class="fas fa-sort ms-1" style="cursor:pointer;" onclick="sortTable(2)"></i>
                    </th>
                    <th width="300">
                        <i class="fas fa-shopping-cart me-1"></i>Invoice Items
                    </th>
                    <th width="100">
                        <i class="fas fa-rupee-sign me-1"></i>Amount
                        <i class="fas fa-sort ms-1" style="cursor:pointer;" onclick="sortTable(4)"></i>
                    </th>
                    <th width="100">
                        <i class="fas fa-balance-scale me-1"></i>Balance
                        <i class="fas fa-sort ms-1" style="cursor:pointer;" onclick="sortTable(5)"></i>
                    </th>
                    <th width="90">
                        <i class="fas fa-money-bill-wave me-1"></i>Paid
                    </th>
                    <th width="60">
                        <i class="fas fa-boxes me-1"></i>Qty
                    </th>
                    <th width="90">
                        <i class="fas fa-info-circle me-1"></i>Status
                    </th>
                    <th width="80">
                        <i class="fas fa-cog me-1"></i>Actions
                    </th>
                </tr>
            </thead>

            <tbody id="invoiceTableBody">
                <c:choose>
                    <c:when test="${empty invoices}">
                        <tr>
                            <td colspan="10" class="text-center text-muted py-4">
                                <i class="fas fa-file-invoice fa-3x mb-3 d-block"></i>
                                <h5>No Invoices Found</h5>
                                <p>Create your first invoice to get started.</p>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="invoice" items="${invoices}" varStatus="i">
                            <tr class="invoice-row"
                                data-type="${invoice.invoiceType}"
                                data-items="${fn:escapeXml(invoice.itemDetails)}"
                                onclick="window.open('${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}', '_blank')">
                                <td>${i.index + 1}</td>
                                <td><strong>#${invoice.invoiceId}</strong></td>
                                <td>${invoice.custName}</td>
                                <td class="invoice-items-cell" onclick="event.stopPropagation()">
                                    <div class="items-preview">
                                        <c:choose>
                                            <c:when test="${not empty invoice.itemDetails}">
                                                ${invoice.itemDetails}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">No items</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td>₹<fmt:formatNumber value="${invoice.totInvoiceAmt}" type="number" minFractionDigits="2" /></td>
                                <td>₹<fmt:formatNumber value="${invoice.balanceAmt}" type="number" minFractionDigits="2" /></td>
                                <td>₹<fmt:formatNumber value="${invoice.advanAmt}" type="number" minFractionDigits="2" /></td>
                                <td>${invoice.totQty}</td>
                                <td>
                                    <span class="badge ${invoice.invoiceType eq 'CREDIT' ? 'badge-credit' : (invoice.invoiceType eq 'PARTIAL' ? 'badge-partial' : (invoice.invoiceType eq 'PAID' ? 'badge-paid' : 'bg-secondary'))}">
                                        ${invoice.invoiceType}
                                    </span>
                                </td>
                                <td onclick="event.stopPropagation()">
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}"
                                           class="btn btn-primary btn-action" target="_blank" title="View Invoice">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Pagination Bottom -->
    <c:if test="${totalPages > 1}">
        <nav class="d-flex justify-content-center mt-3" id="paginationBottom">
            <ul class="pagination pagination-sm">
                <c:if test="${page > 0}">
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-invoices?page=${page - 1}">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                </c:if>

                <c:forEach begin="${page - 2 < 0 ? 0 : page - 2}"
                           end="${page + 2 >= totalPages ? totalPages - 1 : page + 2}" var="i">
                    <li class="page-item ${page == i ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-invoices?page=${i}">
                            ${i + 1}
                        </a>
                    </li>
                </c:forEach>

                <c:if test="${page < totalPages - 1}">
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-invoices?page=${page + 1}">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </c:if>

</div>
</main>
<jsp:include page="../view/footer.jsp"></jsp:include>
</div>

<!-- JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<script>
var contextPath = '${pageContext.request.contextPath}';
var debounceTimer;
var originalTableBody;
var originalPaginationTop;
var originalPaginationBottom;

// Show Loader
function showLoader() {
    document.getElementById("pageLoader").style.display = "block";
}

// Hide Loader
function hideLoader() {
    document.getElementById("pageLoader").style.display = "none";
}

document.addEventListener('DOMContentLoaded', function() {
    originalTableBody = document.getElementById('invoiceTableBody').innerHTML;

    var paginationTop = document.getElementById('paginationTop');
    var paginationBottom = document.getElementById('paginationBottom');

    if (paginationTop) originalPaginationTop = paginationTop.innerHTML;
    if (paginationBottom) originalPaginationBottom = paginationBottom.innerHTML;

    initializeSearch();
});

function initializeSearch() {
    var searchInput = document.getElementById('searchBox');
    if (!searchInput) return;

    searchInput.addEventListener('input', function() {
        clearTimeout(debounceTimer);
        var query = searchInput.value.trim();

        if (query.length === 0) {
            resetToOriginal();
            return;
        }

        if (query.length < 2) return;

        debounceTimer = setTimeout(function() {
            performSearch(query);
        }, 500);
    });
}

function performSearch(query) {
    var tableBody = document.getElementById('invoiceTableBody');
    var paginationTop = document.getElementById('paginationTop');
    var paginationBottom = document.getElementById('paginationBottom');

    showLoader();
    tableBody.innerHTML = '';

    if (paginationTop) paginationTop.style.display = 'none';
    if (paginationBottom) paginationBottom.style.display = 'none';

    var searchUrl = contextPath + '/company/search-invoices?query=' + encodeURIComponent(query);

    fetch(searchUrl, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        credentials: 'same-origin'
    })
    .then(function(response) {
        if (!response.ok) throw new Error('HTTP error! status: ' + response.status);
        return response.json();
    })
    .then(function(data) {
        hideLoader();
        handleSearchSuccess(data, query);
    })
    .catch(function(error) {
        hideLoader();
        console.error('Search error:', error);
        handleSearchError('Search failed: ' + error.message);
    });
}

function handleSearchSuccess(list, query) {
    var tableBody = document.getElementById('invoiceTableBody');
    var resultsSummary = document.getElementById('resultsSummary');
    var resultsText = document.getElementById('resultsText');

    if (!list || list.length === 0) {
        tableBody.innerHTML =
            '<tr><td colspan="10" class="text-center text-muted py-4">' +
            '<i class="fas fa-search fa-3x mb-3 d-block"></i>' +
            '<h5>No matching invoices found</h5>' +
            '<p>Try adjusting your search terms</p>' +
            '<button class="btn btn-outline-primary btn-sm mt-2" onclick="clearSearch()">' +
            '<i class="fas fa-times me-1"></i> Clear Search' +
            '</button>' +
            '</td></tr>';
        resultsSummary.style.display = 'none';
        return;
    }

    resultsText.textContent = 'Found ' + list.length + ' invoice(s) matching "' + query + '"';
    resultsSummary.style.display = 'block';

    var html = '';
    for (var i = 0; i < list.length; i++) {
        var invoice = list[i];
        var badgeClass = invoice.invoiceType === 'CREDIT' ? 'badge-credit' :
                        (invoice.invoiceType === 'PARTIAL' ? 'badge-partial' :
                        (invoice.invoiceType === 'PAID' ? 'badge-paid' : 'bg-secondary'));

var itemsDisplay =
    invoice.itemDetails && invoice.itemDetails.trim() !== ""
        ? invoice.itemDetails
        : '<span class="text-muted">No items</span>';
        html += '<tr class="invoice-row fade-in" data-type="' + invoice.invoiceType + '" ' +
            'onclick="window.open(\'' + contextPath + '/company/get-invoice/' + invoice.custId + '/' + invoice.invoiceId + '\', \'_blank\')">' +
            '<td>' + (i + 1) + '</td>' +
            '<td><strong>#' + (invoice.invoiceId || 'N/A') + '</strong></td>' +
            '<td>' + escapeHtml(invoice.custName || 'N/A') + '</td>' +
            '<td class="invoice-items-cell" onclick="event.stopPropagation()"><div class="items-preview">' + itemsDisplay + '</div></td>' +
            '<td>₹' + formatAmount(invoice.totInvoiceAmt) + '</td>' +
            '<td>₹' + formatAmount(invoice.balanceAmt) + '</td>' +
            '<td>₹' + formatAmount(invoice.advanAmt) + '</td>' +
            '<td>' + (invoice.totQty || 0) + '</td>' +
            '<td><span class="badge ' + badgeClass + '">' + (invoice.invoiceType || 'UNKNOWN') + '</span></td>' +
            '<td onclick="event.stopPropagation()"><div class="action-buttons">' +
            '<a href="' + contextPath + '/company/get-invoice/' + invoice.custId + '/' + invoice.invoiceId + '" ' +
            'class="btn btn-primary btn-action" target="_blank" title="View Invoice">' +
            '<i class="fas fa-eye"></i></a>' +
            '</div></td>' +
            '</tr>';
    }

    tableBody.innerHTML = html;
}

function handleSearchError(errorMessage) {
    var tableBody = document.getElementById('invoiceTableBody');
    tableBody.innerHTML =
        '<tr><td colspan="10" class="text-center text-danger py-4">' +
        '<i class="fas fa-exclamation-triangle fa-2x mb-3 d-block"></i>' +
        '<h5>Error loading invoices</h5>' +
        '<p>' + errorMessage + '</p>' +
        '<button class="btn btn-primary btn-sm mt-2" onclick="clearSearch()">' +
        '<i class="fas fa-refresh me-1"></i> Try Again' +
        '</button>' +
        '</td></tr>';
}

function resetToOriginal() {
    var tableBody = document.getElementById('invoiceTableBody');
    var paginationTop = document.getElementById('paginationTop');
    var paginationBottom = document.getElementById('paginationBottom');
    var resultsSummary = document.getElementById('resultsSummary');

    tableBody.innerHTML = originalTableBody;

    if (paginationTop && originalPaginationTop) {
        paginationTop.innerHTML = originalPaginationTop;
        paginationTop.style.display = 'flex';
    }

    if (paginationBottom && originalPaginationBottom) {
        paginationBottom.innerHTML = originalPaginationBottom;
        paginationBottom.style.display = 'flex';
    }

    resultsSummary.style.display = 'none';
}

function clearSearch() {
    var searchInput = document.getElementById('searchBox');
    searchInput.value = '';
    resetToOriginal();
    searchInput.focus();
}

function filterInvoices(filter) {
    var badges = document.querySelectorAll('.filter-badge');
    badges.forEach(function(badge) { badge.classList.remove('active'); });

    var activeFilter = document.querySelector('[data-filter="' + filter + '"]');
    if (activeFilter) activeFilter.classList.add('active');

    var rows = document.querySelectorAll('#invoiceTableBody tr');
    rows.forEach(function(row) {
        var type = row.getAttribute('data-type');
        if (filter === 'all') {
            row.style.display = '';
        } else {
            row.style.display = type === filter.toUpperCase() ? '' : 'none';
        }
    });
}

function sortTable(columnIndex) {
    var table = document.getElementById('invoiceTable');
    var rows = Array.from(table.querySelectorAll('tbody tr'));
    var isNumeric = columnIndex >= 4 && columnIndex <= 6;

    rows.sort(function(a, b) {
        var aVal = a.cells[columnIndex].textContent.trim();
        var bVal = b.cells[columnIndex].textContent.trim();

        if (isNumeric) {
            aVal = parseFloat(aVal.replace(/[₹,]/g, '')) || 0;
            bVal = parseFloat(bVal.replace(/[₹,]/g, '')) || 0;
            return bVal - aVal;
        }

        return aVal.localeCompare(bVal);
    });

    var tbody = table.querySelector('tbody');
    rows.forEach(function(row, index) {
        row.cells[0].textContent = index + 1;
        tbody.appendChild(row);
    });
}

function exportToExcel() {
    showLoader();
    try {
        var table = document.getElementById('invoiceTable');
        var wb = XLSX.utils.table_to_book(table, {sheet: 'Invoices'});
        XLSX.writeFile(wb, 'invoices_' + new Date().toISOString().split('T')[0] + '.xlsx');
        hideLoader();
    } catch (error) {
        hideLoader();
        alert('Export failed: ' + error.message);
    }
}

function printTable() {
    window.print();
}

function formatAmount(amount) {
    if (!amount && amount !== 0) return '0.00';
    return parseFloat(amount).toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

function escapeHtml(text) {
    var div = document.createElement('div');
    div.textContent = text || '';
    return div.innerHTML;
}

window.addEventListener('offline', function() {
    console.log('Network connection lost');
    hideLoader();
    var tableBody = document.getElementById('invoiceTableBody');
    if (tableBody) {
        tableBody.innerHTML =
            '<tr><td colspan="10" class="text-center text-warning py-4">' +
            '<i class="fas fa-wifi fa-2x mb-3 d-block"></i>' +
            '<h5>Connection Lost</h5>' +
            '<p>Please check your internet connection and try again.</p>' +
            '</td></tr>';
    }
});
</script>

</body>
</html>