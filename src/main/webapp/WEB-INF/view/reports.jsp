<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="../view/logo.jsp"></jsp:include>
    <!-- Main Content -->
    <div id="layoutSidenav_content">
        <div id="pageLoader"
             style="display:none; position:fixed; z-index:9999; top:0; left:0; width:100%; height:100%;
             background:rgba(0,0,0,0.4); backdrop-filter: blur(2px);">
            <div style="position:absolute; top:50%; left:50%; transform:translate(-50%, -50%);
                 padding:20px; background:white; border-radius:8px; font-weight:bold;">
                 Loading...
            </div>
        </div>

        <main>
            <div class="container-fluid px-4 mt-4">

                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Enhanced Filter Section -->
                <div class="filter-card mb-4">
                    <div class="filter-header">
                        <i class="fas fa-filter"></i>
                        <h5>Filter Reports by Date Range</h5>
                    </div>
                    <div class="filter-body">
                        <form id="myform" action="${pageContext.request.contextPath}/company/reportbydate" method="post">
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label for="startDate" class="form-label">
                                        <i class="fas fa-calendar-alt"></i>
                                        Start Date
                                    </label>
                                    <input type="date" id="startDate" name="startDate" class="form-control"
                                           value="${startDate}" max="${today}" required/>
                                </div>
                                <div class="col-md-4">
                                    <label for="endDate" class="form-label">
                                        <i class="fas fa-calendar-check"></i>
                                        End Date
                                    </label>
                                    <input type="date" id="endDate" name="endDate" class="form-control"
                                           value="${endDate}" max="${today}" required/>
                                </div>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <div class="col-md-4 d-flex align-items-end gap-2">
                                    <button type="submit" class="btn btn-search flex-fill">
                                        <i class="fas fa-search me-2"></i> Search
                                    </button>
                                    <button type="button" class="btn btn-clear" onclick="clearForm()">
                                        <i class="fas fa-times me-2"></i> Clear
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Invoices Table -->
                <div class="card mb-4" style="border: none; border-radius: var(--radius-lg); box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);">
                    <div class="card-header" style="background: var(--card-bg); border-bottom: 2px solid var(--border-color); padding: 1.25rem;">
                        <h5 class="mb-0">
                            <i class="fas fa-file-invoice me-2"></i>Invoices
                            <span class="badge bg-primary ms-2">${fn:length(Invoices)}</span>
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover" id="invoiceTable">
                                <thead>
                                <tr>
                                    <th>Invoice No</th>
                                    <th>Customer Name</th>
                                    <th class="text-end">Invoice Amt</th>
                                    <th class="text-end">Paid Amt</th>
                                    <th class="text-end">Closing Amt</th>
                                    <th class="text-end">Date</th>
                                    <th class="text-center">Products</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${Invoices}" var="invoice">
                                    <tr>
                                        <td><strong>${invoice.invoiceId}</strong></td>
                                        <td>${invoice.custName}</td>
                                        <td class="text-end">₹${invoice.totInvoiceAmt}</td>
                                        <td class="text-end text-success">₹${invoice.advanAmt}</td>
                                        <td class="text-end text-warning">₹${invoice.balanceAmt}</td>
                                        <td class="text-end">${invoice.date}</td>
                                        <td class="text-center">
                                            <button class="btn btn-sm btn-outline-primary"
                                                    onclick="showProducts('${invoice.invoiceId}', `${fn:escapeXml(invoice.itemDetails)}`)">
                                                <i class="fas fa-box-open me-1"></i> View
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Transactions Table -->
                <div class="card mb-4" style="border: none; border-radius: var(--radius-lg); box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);">
                    <div class="card-header" style="background: var(--card-bg); border-bottom: 2px solid var(--border-color); padding: 1.25rem;">
                        <h5 class="mb-0">
                            <i class="fas fa-exchange-alt me-2"></i>Transactions
                            <span class="badge bg-success ms-2">${fn:length(transactions)}</span>
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover" id="transactionTable">
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
                                <c:forEach items="${transactions}" var="transaction">
                                    <tr>
                                        <td><strong>${transaction.id}</strong></td>
                                        <td>${transaction.custName}</td>
                                        <td>${transaction.description}</td>
                                        <td class="text-end text-info">₹${transaction.currentOusting}</td>
                                        <td><span class="badge bg-primary">${transaction.modeOfPayment}</span></td>
                                        <td class="text-end text-success">₹${transaction.advAmt}</td>
                                        <td class="text-end">${transaction.createdAt}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Download Section -->
                <div class="row mt-4 mb-4">
                    <div class="col-12 d-flex justify-content-center">
                        <div class="card border-0" style="background: var(--brand); border-radius: 20px;">
                            <div class="card-body p-4 d-flex align-items-center gap-3 text-white">
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

            </div>
        </main>
    </div>
</div>

<!-- Product Details Modal -->
<div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="productModalLabel">
                    <i class="fas fa-box-open me-2"></i>Product Details
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3 p-3" style="background-color: #f8f9fa; border-radius: 8px;">
                    <strong><i class="fas fa-file-invoice me-2"></i>Invoice No:</strong>
                    <span id="modalInvoiceNo" class="text-primary fs-5"></span>
                </div>
                <div id="productList" style="max-height: 400px; overflow-y: auto;">
                    <!-- Products will be displayed here as formatted text -->
                </div>
                <div id="noProducts" class="alert alert-info" style="display: none;">
                    <i class="fas fa-info-circle me-2"></i>No products found for this invoice.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Close
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Hidden Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
</form>

<jsp:include page="../view/footer.jsp"></jsp:include>

<script>
    $(document).ready(function () {
        $('#invoiceTable').DataTable({
            order: [[5, 'desc']], // Sort by date column
            pageLength: 10,
            language: {
                search: "Search Invoices:",
                lengthMenu: "Show _MENU_ invoices per page"
            }
        });
        $('#transactionTable').DataTable({
            order: [[6, 'desc']], // Sort by date column
            pageLength: 10,
            language: {
                search: "Search Transactions:",
                lengthMenu: "Show _MENU_ transactions per page"
            }
        });
    });

    // Function to show products in modal (simple display)
    function showProducts(invoiceNo, itemDetails) {
        // Set invoice number
        document.getElementById('modalInvoiceNo').textContent = invoiceNo;

        // Get the product list container
        const productList = document.getElementById('productList');
        const noProductsDiv = document.getElementById('noProducts');

        // Clear previous content
        productList.innerHTML = '';
        noProductsDiv.style.display = 'none';

        // Check if itemDetails exists and is not empty
        if (itemDetails && itemDetails.trim() !== '') {
            // Split by comma and number pattern to get individual items
            const items = itemDetails.split(/,\s*(?=\(\d+\))/);

            if (items.length > 0 && items[0].trim() !== '') {
                let productHtml = '<div class="list-group">';

                items.forEach((item) => {
                    if (item.trim() !== '') {

                        productHtml += '<div class="list-group-item list-group-item-action" ' +
                                       'style="border-left:4px solid #0d6efd;">';

                        productHtml += '<p class="mb-0" style="font-size:1.1rem; line-height:1.6;">'
                                    + item +
                                    '</p>';

                        productHtml += '</div>';
                    }
                });

                productHtml += '</div>';
                productList.innerHTML = productHtml;
            } else {
                noProductsDiv.style.display = 'block';
            }
        } else {
            noProductsDiv.style.display = 'block';
        }

        // Show the modal
        const productModal = new bootstrap.Modal(document.getElementById('productModal'));
        productModal.show();
    }

    // Enhanced logout function with confirmation and error handling
    function confirmLogout(event) {
        event.preventDefault();
        if (confirm('Are you sure you want to logout?')) {
            performLogout();
        }
    }

    function performLogout() {
        try {
            const logoutForm = document.getElementById('logoutForm');
            if (logoutForm) {
                const logoutBtn = event.target;
                const originalText = logoutBtn.innerHTML;
                logoutBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Logging out...';
                logoutBtn.style.pointerEvents = 'none';
                logoutForm.submit();
            } else {
                console.error('Logout form not found');
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        } catch (error) {
            console.error('Logout failed:', error);
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    }

    function simpleLogout() {
        try {
            const logoutForm = document.forms['logoutForm'] || document.getElementById('logoutForm');
            if (logoutForm) {
                logoutForm.submit();
            } else {
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        } catch (error) {
            console.error('Logout error:', error);
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    }

    // Theme Toggle Script
    function toggleTheme() {
        const body = document.body;
        const icon = document.getElementById('theme-icon');
        const isDark = body.getAttribute('data-theme') === 'dark';
        body.setAttribute('data-theme', isDark ? 'light' : 'dark');
        icon.classList.toggle('fa-sun', isDark);
        icon.classList.toggle('fa-moon', !isDark);
        localStorage.setItem('theme', isDark ? 'light' : 'dark');
    }

    // Load saved theme on page load
    document.addEventListener('DOMContentLoaded', function() {
        const savedTheme = localStorage.getItem('theme') || 'light';
        document.body.setAttribute('data-theme', savedTheme);
        const icon = document.getElementById('theme-icon');
        if (icon) {
            icon.classList.toggle('fa-sun', savedTheme === 'dark');
            icon.classList.toggle('fa-moon', savedTheme === 'light');
        }
    });

    function hideLoader() {
        document.getElementById('pageLoader').style.display = 'none';
    }

    function clearForm() {
        document.getElementById('startDate').value = '';
        document.getElementById('endDate').value = '';
    }
</script>

</body>
</html>