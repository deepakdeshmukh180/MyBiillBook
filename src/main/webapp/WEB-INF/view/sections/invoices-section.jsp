<!-- Invoices Section -->
<section id="invoices" class="page-section">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Invoice Management</h2>
        <div class="d-flex gap-2">
            <button class="btn btn-success btn-modern" onclick="exportInvoices()">
                <i class="fas fa-download"></i>
                Export
            </button>
            <button class="btn btn-primary btn-modern" data-bs-toggle="modal" data-bs-target="#addInvoiceModal">
                <i class="fas fa-plus"></i>
                Create Invoice
            </button>
        </div>
    </div>

    <!-- Filter Controls -->
    <div class="enhanced-card mb-4">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Search Invoices</label>
                    <input type="text" class="form-control form-modern" id="invoiceSearch" placeholder="Invoice ID or Customer">
                </div>
                <div class="col-md-2">
                    <label class="form-label">Status</label>
                    <select class="form-control form-modern" id="invoiceStatusFilter">
                        <option value="">All Status</option>
                        <option value="PAID">Paid</option>
                        <option value="PARTIAL">Partial</option>
                        <option value="CREDIT">Credit</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">From Date</label>
                    <input type="date" class="form-control form-modern" id="fromDate">
                </div>
                <div class="col-md-2">
                    <label class="form-label">To Date</label>
                    <input type="date" class="form-control form-modern" id="toDate">
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button class="btn btn-outline-primary btn-modern me-2" onclick="applyInvoiceFilters()">
                        <i class="fas fa-filter"></i>
                        Apply Filters
                    </button>
                    <button class="btn btn-outline-secondary btn-modern" onclick="clearInvoiceFilters()">
                        <i class="fas fa-times"></i>
                        Clear
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Invoices Table -->
    <div class="enhanced-card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-modern" id="invoicesTable">
                    <thead>
                        <tr>
                            <th>Invoice #</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Amount</th>
                            <th>Paid</th>
                            <th>Balance</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="invoice" items="${invoices}">
                            <tr data-invoice-id="${invoice.invoiceId}">
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
                                    <fmt:formatDate value="${invoice.date}" pattern="dd MMM yyyy"/>
                                </td>
                                <td>₹${invoice.totInvoiceAmt}</td>
                                <td>₹${invoice.advanAmt}</td>
                                <td>₹${invoice.totInvoiceAmt - invoice.advanAmt}</td>
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
                                    <div class="btn-group" role="group">
                                        <button class="btn btn-sm btn-primary btn-modern" onclick="viewInvoice('${invoice.invoiceId}')" title="View Invoice">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn btn-sm btn-success btn-modern" onclick="downloadInvoice('${invoice.invoiceId}')" title="Download PDF">
                                            <i class="fas fa-download"></i>
                                        </button>
                                        <button class="btn btn-sm btn-warning btn-modern" onclick="editInvoice('${invoice.invoiceId}')" title="Edit Invoice">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <c:if test="${invoice.invoiceType != 'PAID'}">
                                            <button class="btn btn-sm btn-info btn-modern" onclick="addInvoicePayment('${invoice.invoiceId}')" title="Add Payment">
                                                <i class="fas fa-credit-card"></i>
                                            </button>
                                        </c:if>
                                        <button class="btn btn-sm btn-danger btn-modern" onclick="deleteInvoice('${invoice.invoiceId}')" title="Delete Invoice">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Invoice Summary -->
            <div class="row mt-4 pt-3 border-top">
                <div class="col-md-3">
                    <div class="text-center">
                        <div class="fs-4 fw-bold text-primary" id="totalInvoices">${fn:length(invoices)}</div>
                        <div class="text-muted">Total Invoices</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <div class="fs-4 fw-bold text-success" id="totalInvoiceAmount">₹0</div>
                        <div class="text-muted">Total Amount</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <div class="fs-4 fw-bold text-warning" id="totalPaidAmount">₹0</div>
                        <div class="text-muted">Total Paid</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="text-center">
                        <div class="fs-4 fw-bold text-danger" id="totalOutstanding">₹0</div>
                        <div class="text-muted">Outstanding</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
// Invoice Management Functions
function viewInvoice(invoiceId) {
    // Open invoice in modal or new window
    window.open('${pageContext.request.contextPath}/api/invoices/' + invoiceId + '/view', '_blank');
}

function downloadInvoice(invoiceId) {
    // Download invoice PDF
    const link = document.createElement('a');
    link.href = '${pageContext.request.contextPath}/api/invoices/' + invoiceId + '/download';
    link.download = 'invoice_' + invoiceId + '.pdf';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

function editInvoice(invoiceId) {
    // Load invoice data and show edit modal
    $.ajax({
        url: '${pageContext.request.contextPath}/api/invoices/' + invoiceId,
        method: 'GET',
        success: function(invoice) {
            populateEditInvoiceModal(invoice);
            $('#editInvoiceModal').modal('show');
        },
        error: function() {
            showNotification('Error loading invoice data', 'error');
        }
    });
}

function addInvoicePayment(invoiceId) {
    // Show payment modal for specific invoice
    $('#invoicePaymentModal').modal('show');
    $('#invoicePaymentModal').find('#paymentInvoiceId').val(invoiceId);
}

function deleteInvoice(invoiceId) {
    if (confirm('Are you sure you want to delete this invoice? This action cannot be undone.')) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/invoices/' + invoiceId,
            method: 'DELETE',
            success: function() {
                showNotification('Invoice deleted successfully', 'success');
                $('tr[data-invoice-id="' + invoiceId + '"]').fadeOut(300, function() {
                    $(this).remove();
                    updateInvoiceSummary();
                });
            },
            error: function() {
                showNotification('Error deleting invoice', 'error');
            }
        });
    }
}

function exportInvoices() {
    const filters = getInvoiceFilters();
    const params = new URLSearchParams(filters);
    window.open('${pageContext.request.contextPath}/api/invoices/export?' + params.toString(), '_blank');
}

function applyInvoiceFilters() {
    const filters = getInvoiceFilters();

    $('#invoicesTable tbody tr').each(function() {
        const row = $(this);
        let showRow = true;

        // Search filter
        if (filters.search) {
            const invoiceId = row.find('td:first').text().toLowerCase();
            const customerName = row.find('td:nth-child(2) .fw-semibold').text().toLowerCase();
            if (!invoiceId.includes(filters.search) && !customerName.includes(filters.search)) {
                showRow = false;
            }
        }

        // Status filter
        if (filters.status) {
            const status = row.find('.status-badge').text().trim();
            const statusMap = { 'Paid': 'PAID', 'Partial': 'PARTIAL', 'Credit': 'CREDIT' };
            if (statusMap[status] !== filters.status) {
                showRow = false;
            }
        }

        // Date filters would require server-side processing for proper implementation

        row.toggle(showRow);
    });

    updateInvoiceSummary();
}

function clearInvoiceFilters() {
    $('#invoiceSearch').val('');
    $('#invoiceStatusFilter').val('');
    $('#fromDate').val('');
    $('#toDate').val('');
    $('#invoicesTable tbody tr').show();
    updateInvoiceSummary();
}

function getInvoiceFilters() {
    return {
        search: $('#invoiceSearch').val().toLowerCase(),
        status: $('#invoiceStatusFilter').val(),
        fromDate: $('#fromDate').val(),
        toDate: $('#toDate').val()
    };
}

function updateInvoiceSummary() {
    let totalAmount = 0;
    let totalPaid = 0;
    let visibleRows = 0;

    $('#invoicesTable tbody tr:visible').each(function() {
        const row = $(this);
        const amount = parseFloat(row.find('td:nth-child(4)').text().replace('₹', '')) || 0;
        const paid = parseFloat(row.find('td:nth-child(5)').text().replace('₹', '')) || 0;

        totalAmount += amount;
        totalPaid += paid;
        visibleRows++;
    });

    $('#totalInvoices').text(visibleRows);
    $('#totalInvoiceAmount').text('₹' + totalAmount.toLocaleString());
    $('#totalPaidAmount').text('₹' + totalPaid.toLocaleString());
    $('#totalOutstanding').text('₹' + (totalAmount - totalPaid).toLocaleString());
}

function filterInvoicesByCustomer(customerId) {
    // Filter invoices by specific customer (called from customer section)
    $('#invoicesTable tbody tr').each(function() {
        const row = $(this);
        const rowCustomerId = row.data('customer-id'); // Assuming this data attribute exists
        row.toggle(!customerId || rowCustomerId == customerId);
    });
    updateInvoiceSummary();
}

// Initialize on document ready
$(document).ready(function() {
    // Search functionality
    $('#invoiceSearch').on('keyup', function() {
        applyInvoiceFilters();
    });

    // Status filter
    $('#invoiceStatusFilter').on('change', function() {
        applyInvoiceFilters();
    });

    // Initialize summary
    updateInvoiceSummary();

    // Set default date range (last 30 days)
    const today = new Date();
    const thirtyDaysAgo = new Date(today.getTime() - (30 * 24 * 60 * 60 * 1000));
    $('#toDate').val(today.toISOString().split('T')[0]);
    $('#fromDate').val(thirtyDaysAgo.toISOString().split('T')[0]);
});
</script>