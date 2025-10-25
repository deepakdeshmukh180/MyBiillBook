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

                <!-- Tabbed Results -->
                <div class="card mb-4" style="border: none; border-radius: var(--radius-lg); box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);">
                    <div class="card-header p-0" style="background: var(--card-bg); border-bottom: 2px solid var(--border-color);">
                        <ul class="nav nav-tabs card-header-tabs" id="reportTabs" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="invoice-tab" data-bs-toggle="tab" href="#invoice" role="tab">
                                    <i class="fas fa-file-invoice me-2"></i>Invoices
                                    <span class="badge">${fn:length(Invoices)}</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="transaction-tab" data-bs-toggle="tab" href="#transaction" role="tab">
                                    <i class="fas fa-exchange-alt me-2"></i>Transactions
                                    <span class="badge">${fn:length(transactions)}</span>
                                </a>
                            </li>
                        </ul>
                    </div>

                    <div class="card-body tab-content" id="reportTabsContent">
                        <!-- Invoices Tab -->
                        <div class="tab-pane fade show active" id="invoice" role="tabpanel">
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
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Transactions Tab -->
                        <div class="tab-pane fade" id="transaction" role="tabpanel">
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
                </div>

                <!-- Download Section -->
                <div class="row mt-4">
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

<!-- Hidden Logout Form -->
<!-- Enhanced logout form with better CSRF handling -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
</form>

<jsp:include page="../view/footer.jsp"></jsp:include>


<script>

 $(document).ready(function () {
        $('#invoiceTable').DataTable();
        $('#transactionTable').DataTable();
    });

    // Enhanced logout function with confirmation and error handling
    function confirmLogout(event) {
        event.preventDefault();

        // Optional: Add confirmation dialog
        if (confirm('Are you sure you want to logout?')) {
            performLogout();
        }
    }

    function performLogout() {
        try {
            const logoutForm = document.getElementById('logoutForm');
            if (logoutForm) {
                // Show loading state (optional)
                const logoutBtn = event.target;
                const originalText = logoutBtn.innerHTML;
                logoutBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Logging out...';
                logoutBtn.style.pointerEvents = 'none';

                // Submit the form
                logoutForm.submit();
            } else {
                console.error('Logout form not found');
                // Fallback: redirect to logout URL
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        } catch (error) {
            console.error('Logout failed:', error);
            // Fallback logout
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    }

    // Alternative simpler version without confirmation
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

            // Save theme preference
            localStorage.setItem('theme', isDark ? 'light' : 'dark');
        }

        // Load saved theme on page load
        document.addEventListener('DOMContentLoaded', function() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            document.body.setAttribute('data-theme', savedTheme);
            const icon = document.getElementById('theme-icon');
            icon.classList.toggle('fa-sun', savedTheme === 'dark');
            icon.classList.toggle('fa-moon', savedTheme === 'light');

            // Initialize search functionality
            initializeSearch();

            // Initialize sidebar
            initializeSidebar();

            // Add loading animation for cards
            animateCards();
        });


</script>
</body>
</html>