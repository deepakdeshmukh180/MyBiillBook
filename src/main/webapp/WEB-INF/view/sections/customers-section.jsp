<!-- Customers Section -->
<section id="customers" class="page-section">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Customers Management</h2>
        <button class="btn btn-primary btn-modern" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
            <i class="fas fa-plus"></i>
            Add Customer
        </button>
    </div>

    <div class="enhanced-card">
        <div class="card-body">
            <!-- Search and Filter Controls -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="form-modern">
                        <input type="text" class="form-control" id="customerSearch" placeholder="Search customers...">
                    </div>
                </div>
                <div class="col-md-3">
                    <select class="form-control form-modern" id="customerStatusFilter">
                        <option value="">All Status</option>
                        <option value="Paid">Paid</option>
                        <option value="Pending">Pending</option>
                        <option value="Overdue">Overdue</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <button class="btn btn-success btn-modern w-100" onclick="exportCustomers()">
                        <i class="fas fa-download"></i>
                        Export
                    </button>
                </div>
            </div>

            <!-- Customers Table -->
            <div class="table-responsive">
                <table class="table table-modern" id="customersTable">
                    <thead>
                        <tr>
                            <th>Customer Name</th>
                            <th>Phone</th>
                            <th>Total Amount</th>
                            <th>Paid Amount</th>
                            <th>Balance</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="payment" items="${custmers}">
                            <tr data-customer-id="${payment.custId}">
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                                            ${fn:toUpperCase(fn:substring(payment.custName, 0, 1))}
                                        </div>
                                        <div>
                                            <div class="fw-semibold">${payment.custName}</div>
                                            <small class="text-muted">${payment.email}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>${payment.phoneNo}</td>
                                <td>₹<span class="total-amount">${payment.totalAmount}</span></td>
                                <td>₹<span class="paid-amount">${payment.paidAmout}</span></td>
                                <td>₹<span class="balance-amount">${payment.currentOusting}</span></td>
                                <td>
                                    <span class="status-badge ${payment.status == 'Pending' ? 'status-pending' : payment.status == 'Paid' ? 'status-paid' : 'status-other'}">
                                        ${payment.status}
                                    </span>
                                </td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-sm btn-primary btn-modern" onclick="editCustomer(${payment.custId})" title="Edit Customer">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-success btn-modern" onclick="viewCustomerInvoices(${payment.custId})" title="View Invoices">
                                            <i class="fas fa-file-invoice"></i>
                                        </button>
                                        <button class="btn btn-sm btn-info btn-modern" onclick="addPayment(${payment.custId})" title="Add Payment">
                                            <i class="fas fa-credit-card"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger btn-modern" onclick="deleteCustomer(${payment.custId})" title="Delete Customer">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <nav aria-label="Customer pagination" class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item">
                        <a class="page-link" href="#" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</section>

<script>
// Customer Management Functions
function editCustomer(customerId) {
    // AJAX call to get customer data
    $.ajax({
        url: '${pageContext.request.contextPath}/api/customers/' + customerId,
        method: 'GET',
        success: function(customer) {
            // Populate edit modal with customer data
            populateEditCustomerModal(customer);
            $('#editCustomerModal').modal('show');
        },
        error: function() {
            showNotification('Error loading customer data', 'error');
        }
    });
}

function viewCustomerInvoices(customerId) {
    // Navigate to invoices with customer filter
    navigateToPage('invoices');
    // Apply customer filter
    setTimeout(() => {
        filterInvoicesByCustomer(customerId);
    }, 500);
}

function addPayment(customerId) {
    // Show payment modal
    $('#paymentModal').modal('show');
    $('#paymentModal').find('#customerId').val(customerId);
}

function deleteCustomer(customerId) {
    if (confirm('Are you sure you want to delete this customer? This action cannot be undone.')) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/customers/' + customerId,
            method: 'DELETE',
            success: function() {
                showNotification('Customer deleted successfully', 'success');
                // Remove row from table
                $('tr[data-customer-id="' + customerId + '"]').fadeOut(300, function() {
                    $(this).remove();
                });
            },
            error: function() {
                showNotification('Error deleting customer', 'error');
            }
        });
    }
}

function exportCustomers() {
    // Export customers to Excel/PDF
    window.open('${pageContext.request.contextPath}/api/customers/export', '_blank');
}

// Search and Filter functionality
$(document).ready(function() {
    $('#customerSearch').on('keyup', function() {
        const searchTerm = $(this).val().toLowerCase();
        $('#customersTable tbody tr').each(function() {
            const customerName = $(this).find('td:first .fw-semibold').text().toLowerCase();
            const email = $(this).find('td:first small').text().toLowerCase();
            const phone = $(this).find('td:nth-child(2)').text().toLowerCase();

            if (customerName.includes(searchTerm) || email.includes(searchTerm) || phone.includes(searchTerm)) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    });

    $('#customerStatusFilter').on('change', function() {
        const selectedStatus = $(this).val();
        $('#customersTable tbody tr').each(function() {
            const status = $(this).find('.status-badge').text().trim();

            if (!selectedStatus || status === selectedStatus) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    });
});
</script>