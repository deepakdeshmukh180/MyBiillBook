<!-- Dashboard Section -->
<section id="dashboard" class="page-section active">
    <!-- Welcome Section -->
    <div class="welcome-section">
        <div class="row align-items-center">
            <div class="col-md-8">
                <div class="d-flex align-items-center mb-3">
                    <div class="me-3">
                        <i class="fas fa-hand-paper fs-2"></i>
                    </div>
                    <div>
                        <h5 class="mb-1">Hello, <span class="fw-bold">${ownerInfo.ownerName}!</span></h5>
                        <p class="mb-0 opacity-75">Welcome back to BillMatePro</p>
                    </div>
                </div>

                <div class="bg-white bg-opacity-10 rounded-3 p-3 mb-4">
                    <h6 class="mb-2"><i class="fas fa-store me-2"></i>${ownerInfo.shopName}</h6>
                    <div class="row g-2 small">
                        <div class="col-md-6"><i class="fas fa-map-marker-alt me-1"></i><strong>Address:</strong> ${ownerInfo.address}</div>
                        <div class="col-md-6"><i class="fas fa-phone me-1"></i><strong>Mobile:</strong> ${ownerInfo.mobNumber}</div>
                        <div class="col-md-6"><i class="fas fa-envelope me-1"></i><strong>Email:</strong> ${ownerInfo.email}</div>
                        <div class="col-md-6"><i class="fas fa-receipt me-1"></i><strong>GST:</strong> ${ownerInfo.gstNumber}</div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 text-md-end">
                <button class="btn btn-light btn-modern" data-bs-toggle="modal" data-bs-target="#addInvoiceModal">
                    <i class="fas fa-plus"></i>
                    New Invoice
                </button>
            </div>
        </div>
    </div>

    <!-- KPI Cards -->
    <div class="row g-4 mb-4">
        <div class="col-lg-3 col-md-6">
            <div class="enhanced-card kpi-card customers" onclick="navigateToPage('customers')" style="cursor: pointer;">
                <div class="kpi-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="kpi-value text-primary" id="dashboardCustomerCount">${custmerCount}</div>
                <div class="kpi-label">Total Customers</div>
                <div class="kpi-trend mt-2">
                    <small class="text-success">
                        <i class="fas fa-arrow-up"></i>
                        +12% from last month
                    </small>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="enhanced-card kpi-card invoices" onclick="navigateToPage('invoices')" style="cursor: pointer;">
                <div class="kpi-icon">
                    <i class="fas fa-file-invoice"></i>
                </div>
                <div class="kpi-value text-warning" id="dashboardInvoiceCount">${invoicesCount}</div>
                <div class="kpi-label">Total Invoices</div>
                <div class="kpi-trend mt-2">
                    <small class="text-success">
                        <i class="fas fa-arrow-up"></i>
                        +8% this week
                    </small>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="enhanced-card kpi-card revenue" onclick="navigateToPage('expenses')" style="cursor: pointer;">
                <div class="kpi-icon">
                    <i class="fas fa-rupee-sign"></i>
                </div>
                <div class="kpi-value text-success" id="dashboardDailyExpenses">₹${daily_expenses}</div>
                <div class="kpi-label">Today's Expenses</div>
                <div class="kpi-trend mt-2">
                    <small class="text-warning">
                        <i class="fas fa-arrow-down"></i>
                        -5% from yesterday
                    </small>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="enhanced-card kpi-card expenses" onclick="navigateToPage('expenses')" style="cursor: pointer;">
                <div class="kpi-icon">
                    <i class="fas fa-wallet"></i>
                </div>
                <div class="kpi-value text-danger" id="dashboardMonthlyExpenses">₹${monthly_expenses}</div>
                <div class="kpi-label">Monthly Expenses</div>
                <div class="kpi-trend mt-2">
                    <small class="text-info">
                        <i class="fas fa-minus"></i>
                        Same as last month
                    </small>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts and Analytics Row -->
    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="chart-container">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-line me-2"></i>
                        Revenue Trend
                    </h5>
                    <div class="btn-group" role="group" aria-label="Chart period">
                        <input type="radio" class="btn-check" name="revenuePeriod" id="revenue7days" value="7" checked>
                        <label class="btn btn-outline-primary btn-sm" for="revenue7days">7D</label>

                        <input type="radio" class="btn-check" name="revenuePeriod" id="revenue30days" value="30">
                        <label class="btn btn-outline-primary btn-sm" for="revenue30days">30D</label>

                        <input type="radio" class="btn-check" name="revenuePeriod" id="revenue6months" value="180">
                        <label class="btn btn-outline-primary btn-sm" for="revenue6months">6M</label>

                        <input type="radio" class="btn-check" name="revenuePeriod" id="revenue1year" value="365">
                        <label class="btn btn-outline-primary btn-sm" for="revenue1year">1Y</label>
                    </div>
                </div>
                <div class="chart-wrapper">
                    <canvas id="revenueChart"></canvas>
                </div>
                <!-- Revenue Summary -->
                <div class="row mt-3 pt-3 border-top">
                    <div class="col-3 text-center">
                        <div class="text-success fw-bold" id="revenueToday">₹12,450</div>
                        <small class="text-muted">Today</small>
                    </div>
                    <div class="col-3 text-center">
                        <div class="text-info fw-bold" id="revenueWeek">₹89,750</div>
                        <small class="text-muted">This Week</small>
                    </div>
                    <div class="col-3 text-center">
                        <div class="text-primary fw-bold" id="revenueMonth">₹3,45,890</div>
                        <small class="text-muted">This Month</small>
                    </div>
                    <div class="col-3 text-center">
                        <div class="text-warning fw-bold" id="revenueYear">₹42,67,540</div>
                        <small class="text-muted">This Year</small>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="chart-container">
                <h5 class="mb-3">
                    <i class="fas fa-chart-pie me-2"></i>
                    Payment Distribution
                </h5>
                <div class="chart-wrapper">
                    <canvas id="paymentChart"></canvas>
                </div>
                <!-- Payment Summary -->
                <div class="mt-3">
                    <div class="row text-center">
                        <div class="col-4">
                            <div class="text-success fw-bold">₹${totalAmount}</div>
                            <small class="text-muted">Total</small>
                        </div>
                        <div class="col-4">
                            <div class="text-warning fw-bold">₹${paidAmount}</div>
                            <small class="text-muted">Paid</small>
                        </div>
                        <div class="col-4">
                            <div class="text-danger fw-bold">₹${currentOutstanding}</div>
                            <small class="text-muted">Outstanding</small>
                        </div>
                    </div>
                    <!-- Payment Status Progress -->
                    <div class="mt-3">
                        <div class="d-flex justify-content-between mb-1">
                            <small>Collection Rate</small>
                            <small class="fw-bold" id="collectionRate">0%</small>
                        </div>
                        <div class="progress" style="height: 6px;">
                            <div class="progress-bar bg-success" id="collectionProgressBar" style="width: 0%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Activity Section -->
    <div class="row g-4">
        <div class="col-lg-8">
            <div class="enhanced-card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">
                            <i class="fas fa-clock me-2"></i>
                            Recent Invoices
                        </h5>
                        <a href="#" class="btn btn-outline-primary btn-sm nav-link" data-page="invoices">
                            View All <i class="fas fa-arrow-right ms-1"></i>
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Invoice #</th>
                                    <th>Customer</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="invoice" items="${invoices}" begin="0" end="4">
                                    <tr>
                                        <td>
                                            <span class="fw-bold text-primary">${invoice.invoiceId}</span>
                                        </td>
                                        <td>
                                            <div>
                                                <div class="fw-semibold">${invoice.custName}</div>
                                                <small class="text-muted">Customer</small>
                                            </div>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${invoice.date}" pattern="dd MMM"/>
                                        </td>
                                        <td>₹${invoice.totInvoiceAmt}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${invoice.invoiceType == 'PAID'}">
                                                    <span class="status-badge status-paid">Paid</span>
                                                </c:when>
                                                <c:when test="${invoice.invoiceType == 'PARTIAL'}">
                                                    <span class="status-badge status-pending">Partial</span>
                                                </c:when>
                                                <c:when test="${invoice.invoiceType == 'CREDIT'}">
                                                    <span class="status-badge status-overdue">Credit</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-pending">Unknown</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary" onclick="viewInvoice('${invoice.invoiceId}')" title="View Invoice">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty invoices}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
                                            <i class="fas fa-file-invoice fa-2x mb-2 opacity-50"></i>
                                            <div>No invoices found</div>
                                            <small>Create your first invoice to get started</small>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- Quick Actions Card -->
            <div class="enhanced-card mb-4">
                <div class="card-body">
                    <h5 class="mb-3">
                        <i class="fas fa-bolt me-2"></i>
                        Quick Actions
                    </h5>
                    <div class="d-grid gap-2">
                        <button class="btn btn-primary btn-modern" data-bs-toggle="modal" data-bs-target="#addInvoiceModal">
                            <i class="fas fa-file-invoice me-2"></i>
                            Create Invoice
                        </button>
                        <button class="btn btn-success btn-modern" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                            <i class="fas fa-user-plus me-2"></i>
                            Add Customer
                        </button>
                        <button class="btn btn-warning btn-modern" data-bs-toggle="modal" data-bs-target="#addExpenseModal">
                            <i class="fas fa-wallet me-2"></i>
                            Record Expense
                        </button>
                        <button class="btn btn-info btn-modern" onclick="navigateToPage('reports')">
                            <i class="fas fa-chart-line me-2"></i>
                            View Reports
                        </button>
                    </div>
                </div>
            </div>

            <!-- Recent Activity Feed -->
            <div class="enhanced-card">
                <div class="card-body">
                    <h6 class="mb-3">
                        <i class="fas fa-bell me-2"></i>
                        Recent Activity
                    </h6>
                    <div class="activity-feed">
                        <div class="activity-item">
                            <div class="activity-icon bg-success">
                                <i class="fas fa-check"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">Payment received from John Doe</div>
                                <div class="activity-time">2 hours ago</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-primary">
                                <i class="fas fa-file-invoice"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">New invoice created #INV2024001</div>
                                <div class="activity-time">4 hours ago</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-warning">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">New customer added: Jane Smith</div>
                                <div class="activity-time">1 day ago</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-danger">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">Invoice #INV2023987 is overdue</div>
                                <div class="activity-time">2 days ago</div>
                            </div>
                        </div>
                    </div>
                    <div class="text-center mt-3">
                        <a href="#" class="btn btn-outline-primary btn-sm">View All Activity</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<style>
/* Activity Feed Styles */
.activity-feed {
    max-height: 300px;
    overflow-y: auto;
}

.activity-item {
    display: flex;
    align-items: flex-start;
    padding: 0.75rem 0;
    border-bottom: 1px solid var(--border-color);
}

.activity-item:last-child {
    border-bottom: none;
}

.activity-icon {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 0.875rem;
    margin-right: 0.75rem;
    flex-shrink: 0;
}

.activity-content {
    flex-grow: 1;
    min-width: 0;
}

.activity-text {
    font-size: 0.875rem;
    line-height: 1.4;
    margin-bottom: 0.25rem;
}

.activity-time {
    font-size: 0.75rem;
    color: var(--text-color);
    opacity: 0.6;
}

/* KPI Trend styles */
.kpi-trend {
    font-size: 0.75rem;
}

/* Enhanced hover effects for KPI cards */
.kpi-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
}

/* Chart container enhancements */
.chart-container {
    position: relative;
}

.chart-container::before {
    content: '';
    position: absolute;
    top: -2px;
    left: -2px;
    right: -2px;
    bottom: -2px;
    background: linear-gradient(45deg, var(--primary-color), var(--success-color), var(--warning-color), var(--info-color));
    border-radius: 18px;
    opacity: 0;
    transition: opacity 0.3s ease;
    z-index: -1;
}

.chart-container:hover::before {
    opacity: 0.1;
}
</style>

<script>
// Dashboard specific functions
$(document).ready(function() {
    // Calculate and display collection rate
    updateCollectionRate();

    // Initialize real-time updates
    startDashboardUpdates();

    // Revenue period change handler
    $('input[name="revenuePeriod"]').change(function() {
        const period = $(this).val();
        updateRevenueChart(period);
    });
});

function updateCollectionRate() {
    const totalAmount = parseFloat('${totalAmount}') || 0;
    const paidAmount = parseFloat('${paidAmount}') || 0;

    if (totalAmount > 0) {
        const rate = Math.round((paidAmount / totalAmount) * 100);
        $('#collectionRate').text(rate + '%');
        $('#collectionProgressBar').css('width', rate + '%');

        // Update progress bar color based on rate
        $('#collectionProgressBar').removeClass('bg-success bg-warning bg-danger');
        if (rate >= 80) {
            $('#collectionProgressBar').addClass('bg-success');
        } else if (rate >= 60) {
            $('#collectionProgressBar').addClass('bg-warning');
        } else {
            $('#collectionProgressBar').addClass('bg-danger');
        }
    }
}

function updateRevenueChart(period) {
    // Show loading state
    const chartWrapper = $('.chart-wrapper');
    const originalContent = chartWrapper.html();
    chartWrapper.html('<div class="chart-loading"><i class="fas fa-spinner fa-spin"></i> Loading chart data...</div>');

    $.ajax({
        url: '${pageContext.request.contextPath}/api/dashboard/revenue-trend',
        method: 'GET',
        data: { period: period },
        success: function(data) {
            // Restore chart content
            chartWrapper.html(originalContent);

            // Update chart with new data
            if (window.dashboardCharts && window.dashboardCharts.revenue) {
                const chart = window.dashboardCharts.revenue;
                chart.data.labels = data.labels;
                chart.data.datasets[0].data = data.values;
                chart.update('none'); // Disable animation for smoother updates
            }

            // Update revenue summary
            if (data.summary) {
                $('#revenueToday').text('₹' + (data.summary.today || 0).toLocaleString());
                $('#revenueWeek').text('₹' + (data.summary.week || 0).toLocaleString());
                $('#revenueMonth').text('₹' + (data.summary.month || 0).toLocaleString());
                $('#revenueYear').text('₹' + (data.summary.year || 0).toLocaleString());
            }
        },
        error: function() {
            chartWrapper.html(originalContent);
            showNotification('Error loading chart data', 'error');
        }
    });
}

// Update KPI cards with real-time data
function updateDashboardKPIs() {
    $.ajax({
        url: '${pageContext.request.contextPath}/api/dashboard/kpis',
        method: 'GET',
        success: function(data) {
            // Animate number changes
            animateCounter('#dashboardCustomerCount', data.customerCount);
            animateCounter('#dashboardInvoiceCount', data.invoiceCount);
            $('#dashboardDailyExpenses').text('₹' + (data.dailyExpenses || 0).toLocaleString());
            $('#dashboardMonthlyExpenses').text('₹' + (data.monthlyExpenses || 0).toLocaleString());

            // Update collection rate
            updateCollectionRate();
        },
        error: function() {
            console.warn('Could not update KPIs');
        }
    });
}

function animateCounter(selector, targetValue) {
    const element = $(selector);
    const currentValue = parseInt(element.text()) || 0;
    const increment = targetValue > currentValue ? 1 : -1;
    const duration = Math.abs(targetValue - currentValue) * 50; // 50ms per number

    if (currentValue !== targetValue) {
        let current = currentValue;
        const timer = setInterval(() => {
            current += increment;
            element.text(current);

            if ((increment > 0 && current >= targetValue) || (increment < 0 && current <= targetValue)) {
                element.text(targetValue);
                clearInterval(timer);
            }
        }, duration / Math.abs(targetValue - currentValue));
    }
}

// Auto-refresh dashboard data every 5 minutes
function startDashboardUpdates() {
    // Update immediately when dashboard loads
    updateDashboardKPIs();

    // Set up periodic updates
    setInterval(function() {
        if (currentPage === 'dashboard') {
            updateDashboardKPIs();
        }
    }, 300000); // 5 minutes

    // Update every minute for critical data
    setInterval(function() {
        if (currentPage === 'dashboard') {
            updateRealtimeData();
        }
    }, 60000); // 1 minute
}

function updateRealtimeData() {
    // Update only critical real-time data
    $.ajax({
        url: '${pageContext.request.contextPath}/api/dashboard/realtime',
        method: 'GET',
        success: function(data) {
            if (data.newInvoices && data.newInvoices.length > 0) {
                // Add notification for new invoices
                showNotification(`${data.newInvoices.length} new invoice(s) created`, 'info');
            }

            if (data.newPayments && data.newPayments.length > 0) {
                // Add notification for new payments
                showNotification(`${data.newPayments.length} new payment(s) received`, 'success');
            }
        },
        error: function() {
            // Silently fail for real-time updates
        }
    });
}

// Generate sample report
function generateSampleReport() {
    showNotification('Generating sample report...', 'info');

    setTimeout(() => {
        showNotification('Sample report generated successfully!', 'success');
        // You would typically redirect to the actual report or download it
        window.open('${pageContext.request.contextPath}/reports/sample', '_blank');
    }, 2000);
}

// Export functionality
function exportDashboardData() {
    const exportData = {
        period: $('input[name="revenuePeriod"]:checked').val(),
        includeCharts: true,
        format: 'pdf'
    };

    const params = new URLSearchParams(exportData);
    window.open('${pageContext.request.contextPath}/api/dashboard/export?' + params.toString(), '_blank');
}

// Refresh dashboard data manually
function refreshDashboard() {
    showNotification('Refreshing dashboard data...', 'info');
    updateDashboardKPIs();
    updateRevenueChart($('input[name="revenuePeriod"]:checked').val());

    setTimeout(() => {
        showNotification('Dashboard data refreshed!', 'success');
    }, 1000);
}
</script>