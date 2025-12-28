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
    .stats-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    .stats-card h5 {
        font-size: 0.9rem;
        opacity: 0.9;
        margin-bottom: 10px;
    }

    .stats-card h3 {
        font-size: 1.8rem;
        font-weight: bold;
        margin: 0;
    }

    .search-container {
        position: relative;
    }

    .search-icon {
        position: absolute;
        left: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: #6c757d;
    }

    #searchBox {
        padding-left: 45px;
        border-radius: 25px;
        border: 2px solid #e0e0e0;
        transition: all 0.3s;
    }

    #searchBox:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
    }

    .table-actions {
        display: flex;
        gap: 5px;
        justify-content: center;
    }

    .balance-positive {
        color: #28a745;
        font-weight: 600;
    }

    .balance-negative {
        color: #dc3545;
        font-weight: 600;
    }

    .customer-row {
        transition: all 0.2s;
    }

    .customer-row:hover {
        background-color: #f8f9fa;
        transform: scale(1.01);
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .btn-action {
        width: 35px;
        height: 35px;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 6px;
        transition: all 0.2s;
    }

    .btn-action:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }

    .export-buttons {
        display: flex;
        gap: 10px;
    }

    @media (max-width: 768px) {
        .table-actions {
            flex-wrap: wrap;
        }

        .export-buttons {
            flex-direction: column;
        }
    }

    .fade-in {
        animation: fadeIn 0.3s;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .filter-badge {
        display: inline-block;
        padding: 5px 15px;
        border-radius: 20px;
        font-size: 0.85rem;
        margin: 5px;
        cursor: pointer;
        transition: all 0.2s;
    }

    .filter-badge:hover {
        transform: scale(1.05);
    }

    .filter-badge.active {
        background-color: #667eea;
        color: white;
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

    <!-- Page Header with Stats -->
    <div class="row mb-4">
        <div class="col-md-8">
            <h2 class="h3 mb-3">Customer Management</h2>

            <!-- Quick Filters -->
            <div class="mb-3">
                <span class="filter-badge bg-light" data-filter="all" onclick="filterCustomers('all')">
                    <i class="fas fa-users me-1"></i>All Customers
                </span>
                <span class="filter-badge bg-light" data-filter="balance" onclick="filterCustomers('balance')">
                    <i class="fas fa-money-bill-wave me-1"></i>With Balance
                </span>
                <span class="filter-badge bg-light" data-filter="cleared" onclick="filterCustomers('cleared')">
                    <i class="fas fa-check-circle me-1"></i>Cleared
                </span>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stats-card">
                <h5>Total Customers</h5>
                <h3>${totalcustomers}</h3>
                <small><i class="fas fa-chart-line me-1"></i>Active Accounts</small>
            </div>
        </div>
    </div>

    <!-- Search and Export -->
    <div class="row mb-4">
        <div class="col-md-7">
            <div class="search-container">
                <i class="fas fa-search search-icon"></i>
                <input type="text" id="searchBox" class="form-control"
                       placeholder="Search by name, address, or phone number...">
            </div>
        </div>

        <div class="col-md-5">
            <div class="export-buttons">
                <button class="btn btn-outline-primary flex-fill" onclick="exportToExcel()">
                    <i class="fas fa-file-excel me-1"></i>Export Excel
                </button>
                <button class="btn btn-outline-secondary flex-fill" onclick="printTable()">
                    <i class="fas fa-print me-1"></i>Print
                </button>
                <button class="btn btn-outline-success flex-fill" onclick="location.reload()">
                    <i class="fas fa-sync-alt me-1"></i>Refresh
                </button>
            </div>
        </div>
    </div>


    <!-- Results Summary -->
    <div id="resultsSummary" class="alert alert-info" style="display:none;">
        <i class="fas fa-info-circle me-2"></i>
        <span id="resultsText"></span>
    </div>

    <!-- Table -->
    <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle" id="customerTable">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>
                        <i class="fas fa-user me-1"></i>Name
                        <i class="fas fa-sort ms-1" style="cursor:pointer;" onclick="sortTable(1)"></i>
                    </th>
                    <th>
                        <i class="fas fa-map-marker-alt me-1"></i>Address
                    </th>
                    <th>
                        <i class="fas fa-phone me-1"></i>Phone
                    </th>
                    <th>
                        <i class="fas fa-rupee-sign me-1"></i>Total
                        <i class="fas fa-sort ms-1" style="cursor:pointer;" onclick="sortTable(4)"></i>
                    </th>
                    <th>
                        <i class="fas fa-check-circle me-1"></i>Paid
                        <i class="fas fa-sort ms-1" style="cursor:pointer;" onclick="sortTable(5)"></i>
                    </th>
                    <th>
                        <i class="fas fa-balance-scale me-1"></i>Balance
                        <i class="fas fa-sort ms-1" style="cursor:pointer;" onclick="sortTable(6)"></i>
                    </th>
                    <th width="180">
                        <i class="fas fa-cog me-1"></i>Actions
                    </th>
                </tr>
            </thead>

            <tbody id="customerTableBody">
                <c:forEach items="${custmers}" var="cust" varStatus="i">
                    <tr class="customer-row" data-balance="${cust.currentOusting}">
                        <td>${i.index + 1}</td>
                        <td><strong>${cust.custName}</strong></td>
                        <td>${cust.address}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty cust.phoneNo}">
                                    <a href="https://wa.me/${cust.phoneNo}" target="_blank"
                                       class="text-decoration-none" title="Contact on WhatsApp">
                                        <i class="fab fa-whatsapp text-success"></i>
                                        ${cust.phoneNo}
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">—</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>₹<fmt:formatNumber value="${cust.totalAmount}" pattern="#,##0.00"/></td>
                        <td>₹<fmt:formatNumber value="${cust.paidAmout}" pattern="#,##0.00"/></td>
                        <td class="${cust.currentOusting > 0 ? 'balance-negative' : 'balance-positive'}">
                            ₹<fmt:formatNumber value="${cust.currentOusting}" pattern="#,##0.00"/>
                        </td>

                        <td>
                            <div class="table-actions">
                                <a href="${pageContext.request.contextPath}/company/get-cust-by-id?custid=${cust.id}"
                                   class="btn btn-primary btn-action" title="View Invoice">
                                    <i class="fas fa-file-invoice"></i>
                                </a>

                                <a href="${pageContext.request.contextPath}/company/get-bal-credit-page/${cust.id}"
                                   class="btn btn-success btn-action" title="Add Payment">
                                    <i class="fas fa-donate"></i>
                                </a>

                                <a href="${pageContext.request.contextPath}/company/cust-history?custid=${cust.id}"
                                   class="btn btn-warning btn-action" target="_blank" title="View History">
                                    <i class="fas fa-list-ol"></i>
                                </a>

                                <a href="${pageContext.request.contextPath}/company/update-customer/${cust.id}"
                                   class="btn btn-dark btn-action" title="Edit Customer">
                                    <i class="fas fa-edit"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <nav class="d-flex justify-content-center mt-4" id="paginationNav">
            <ul class="pagination pagination-lg">
                <c:if test="${page > 0}">
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${page - 1}">
                            <i class="fas fa-chevron-left"></i> Previous
                        </a>
                    </li>
                </c:if>

                <c:forEach begin="${page - 2 < 0 ? 0 : page - 2}"
                           end="${page + 2 >= totalPages ? totalPages - 1 : page + 2}" var="i">
                    <li class="page-item ${page == i ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${i}">
                            ${i + 1}
                        </a>
                    </li>
                </c:forEach>

                <c:if test="${page < totalPages - 1}">
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${page + 1}">
                            Next <i class="fas fa-chevron-right"></i>
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

<!-- Logout form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display:none;">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
</form>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<script>
const contextPath = '${pageContext.request.contextPath}';
let debounceTimer;
let allCustomers = [];

// Store initial data
$(document).ready(function() {
    storeTableData();
});

// =========================
// AJAX SEARCH
// =========================
$("#searchBox").on("input", function () {
    const query = $(this).val().trim();

    clearTimeout(debounceTimer);

    if (query.length === 0) {
        location.href = contextPath + "/company/get-all-customers";
        return;
    }

    if (query.length < 2) return;

    debounceTimer = setTimeout(() => {
        $("#pageLoader").show();

        $.ajax({
            url: contextPath + "/company/search",
            method: "GET",
            data: { query: query },
            success: function (list) {
                $("#pageLoader").hide();
                $("#customerTableBody").empty();
                $("#paginationNav").hide();

                if (!list || list.length === 0) {
                    $("#customerTableBody").html(
                        "<tr><td colspan='8' class='text-center text-muted py-4'>" +
                        "<i class='fas fa-search fa-3x mb-3 d-block'></i>" +
                        "<h5>No matching customers found</h5>" +
                        "<p>Try adjusting your search terms</p>" +
                        "</td></tr>"
                    );
                    $("#resultsSummary").hide();
                    return;
                }

                // Show results summary
                $("#resultsText").text("Found " + list.length + " customer(s) matching '" + query + "'");
                $("#resultsSummary").show();

                list.forEach(function(c, i) {
                    let phone = c.phoneNo
                        ? "<a href='https://wa.me/" + c.phoneNo + "' target='_blank' class='text-decoration-none' title='Contact on WhatsApp'>" +
                          "<i class='fab fa-whatsapp text-success'></i> " + c.phoneNo +
                          "</a>"
                        : "<span class='text-muted'>—</span>";

                    let balanceClass = c.currentOusting > 0 ? 'balance-negative' : 'balance-positive';

                    $("#customerTableBody").append(
                        "<tr class='customer-row fade-in' data-balance='" + c.currentOusting + "'>" +
                        "<td>" + (i + 1) + "</td>" +
                        "<td><strong>" + c.custName + "</strong></td>" +
                        "<td>" + (c.address || '') + "</td>" +
                        "<td>" + phone + "</td>" +
                        "<td>₹" + formatNumber(c.totalAmount) + "</td>" +
                        "<td>₹" + formatNumber(c.paidAmout) + "</td>" +
                        "<td class='" + balanceClass + "'>₹" + formatNumber(c.currentOusting) + "</td>" +
                        "<td>" +
                        "<div class='table-actions'>" +
                        "<a href='" + contextPath + "/company/get-cust-by-id?custid=" + c.id + "' class='btn btn-primary btn-action' title='View Invoice'>" +
                        "<i class='fas fa-file-invoice'></i></a>" +
                        "<a href='" + contextPath + "/company/get-bal-credit-page/" + c.id + "' class='btn btn-success btn-action' title='Add Payment'>" +
                        "<i class='fas fa-donate'></i></a>" +
                        "<a href='" + contextPath + "/company/cust-history?custid=" + c.id + "' target='_blank' class='btn btn-warning btn-action' title='View History'>" +
                        "<i class='fas fa-list-ol'></i></a>" +
                        "<a href='" + contextPath + "/company/update-customer/" + c.id + "' class='btn btn-dark btn-action' title='Edit Customer'>" +
                        "<i class='fas fa-edit'></i></a>" +
                        "</div>" +
                        "</td>" +
                        "</tr>"
                    );
                });
            },
            error: function() {
                $("#pageLoader").hide();
                alert("Error searching customers. Please try again.");
            }
        });
    }, 300);
});

// =========================
// FILTER CUSTOMERS
// =========================
function filterCustomers(filter) {
    $(".filter-badge").removeClass("active");
    $("[data-filter='" + filter + "']").addClass("active");

    const rows = $("#customerTableBody tr");

    rows.each(function() {
        const balance = parseFloat($(this).attr("data-balance")) || 0;

        if (filter === "all") {
            $(this).show();
        } else if (filter === "balance") {
            balance > 0 ? $(this).show() : $(this).hide();
        } else if (filter === "cleared") {
            balance <= 0 ? $(this).show() : $(this).hide();
        }
    });
}

// =========================
// SORT TABLE
// =========================
function sortTable(columnIndex) {
    const table = document.getElementById("customerTable");
    const rows = Array.from(table.querySelectorAll("tbody tr"));
    const isNumeric = columnIndex >= 4 && columnIndex <= 6;

    rows.sort((a, b) => {
        let aVal = a.cells[columnIndex].textContent.trim();
        let bVal = b.cells[columnIndex].textContent.trim();

        if (isNumeric) {
            aVal = parseFloat(aVal.replace(/[₹,]/g, '')) || 0;
            bVal = parseFloat(bVal.replace(/[₹,]/g, '')) || 0;
            return bVal - aVal;
        }

        return aVal.localeCompare(bVal);
    });

    const tbody = table.querySelector("tbody");
    rows.forEach((row, index) => {
        row.cells[0].textContent = index + 1;
        tbody.appendChild(row);
    });
}

// =========================
// EXPORT TO EXCEL
// =========================
function exportToExcel() {
    const table = document.getElementById("customerTable");
    const wb = XLSX.utils.table_to_book(table, {sheet: "Customers"});
    XLSX.writeFile(wb, "customers_" + new Date().toISOString().split('T')[0] + ".xlsx");
}

// =========================
// PRINT TABLE
// =========================
function printTable() {
    window.print();
}

// =========================
// STORE TABLE DATA
// =========================
function storeTableData() {
    $("#customerTableBody tr").each(function() {
        const row = $(this);
        allCustomers.push({
            name: row.find("td:eq(1)").text(),
            address: row.find("td:eq(2)").text(),
            phone: row.find("td:eq(3)").text(),
            total: row.find("td:eq(4)").text(),
            paid: row.find("td:eq(5)").text(),
            balance: row.find("td:eq(6)").text()
        });
    });
}

// =========================
// FORMAT NUMBERS
// =========================
function formatNumber(num) {
    if (!num && num !== 0) return "0.00";
    return parseFloat(num).toLocaleString("en-IN", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

// Initialize first filter
$(document).ready(function() {
    $("[data-filter='all']").addClass("active");
});
</script>

<style media="print">
    .btn, .pagination, .filter-badge, .export-buttons, #searchBox, .search-container {
        display: none !important;
    }

    .table {
        font-size: 12px;
    }
</style>

</body>
</html>