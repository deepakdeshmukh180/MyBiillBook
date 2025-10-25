<!-- Add Invoice Modal -->
<div class="modal fade" id="addInvoiceModal" tabindex="-1" aria-labelledby="addInvoiceModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addInvoiceModalLabel">
                    <i class="fas fa-file-invoice me-2"></i>
                    Create New Invoice
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="addInvoiceForm" class="form-modern">
                <div class="modal-body">
                    <!-- Customer Selection -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="invoiceCustomer" class="form-label">Select Customer *</label>
                            <select class="form-control" id="invoiceCustomer" name="customerId" required>
                                <option value="">Choose Customer...</option>
                                <c:forEach var="customer" items="${custmers}">
                                    <option value="${customer.custId}" data-name="${customer.custName}" data-phone="${customer.phoneNo}" data-email="${customer.email}">
                                        ${customer.custName} - ${customer.phoneNo}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Please select a customer.</div>
                        </div>
                        <div class="col-md-3">
                            <label for="invoiceDate" class="form-label">Invoice Date *</label>
                            <input type="date" class="form-control" id="invoiceDate" name="invoiceDate" required>
                        </div>
                        <div class="col-md-3">
                            <label for="invoiceId" class="form-label">Invoice Number *</label>
                            <input type="text" class="form-control" id="invoiceId" name="invoiceId" placeholder="Auto-generated" readonly>
                        </div>
                    </div>

                    <!-- Customer Details Display -->
                    <div id="customerDetails" class="alert alert-info d-none">
                        <h6 class="mb-2">Customer Details:</h6>
                        <div class="row">
                            <div class="col-md-4"><strong>Name:</strong> <span id="custName"></span></div>
                            <div class="col-md-4"><strong>Phone:</strong> <span id="custPhone"></span></div>
                            <div class="col-md-4"><strong>Email:</strong> <span id="custEmail"></span></div>
                        </div>
                    </div>

                    <!-- Invoice Items -->
                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6>Invoice Items</h6>
                            <button type="button" class="btn btn-sm btn-success btn-modern" onclick="addInvoiceItem()">
                                <i class="fas fa-plus"></i>
                                Add Item
                            </button>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-bordered" id="invoiceItemsTable">
                                <thead class="table-primary">
                                    <tr>
                                        <th width="30%">Item Description</th>
                                        <th width="15%">Quantity</th>
                                        <th width="15%">Unit Price</th>
                                        <th width="10%">Tax %</th>
                                        <th width="20%">Total</th>
                                        <th width="10%">Action</th>
                                    </tr>
                                </thead>
                                <tbody id="invoiceItemsBody">
                                    <!-- Items will be added dynamically -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Invoice Totals -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group mb-3">
                                <label for="invoiceNotes" class="form-label">Notes</label>
                                <textarea class="form-control" id="invoiceNotes" name="notes" rows="3" placeholder="Additional notes or terms..."></textarea>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="bg-light rounded-3 p-3">
                                <div class="row mb-2">
                                    <div class="col-6"><strong>Subtotal:</strong></div>
                                    <div class="col-6 text-end">₹<span id="invoiceSubtotal">0.00</span></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-6"><strong>Tax:</strong></div>
                                    <div class="col-6 text-end">₹<span id="invoiceTax">0.00</span></div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-6"><strong>Discount:</strong></div>
                                    <div class="col-6">
                                        <div class="input-group input-group-sm">
                                            <input type="number" class="form-control" id="invoiceDiscount" name="discount" min="0" step="0.01" value="0">
                                            <span class="input-group-text">₹</span>
                                        </div>
                                    </div>
                                </div>
                                <hr>
                                <div class="row">
                                    <div class="col-6"><strong class="fs-5">Total:</strong></div>
                                    <div class="col-6 text-end"><strong class="fs-5 text-primary">₹<span id="invoiceTotal">0.00</span></strong></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Details -->
                    <div class="row mt-4">
                        <div class="col-md-4">
                            <label for="invoiceType" class="form-label">Invoice Type *</label>
                            <select class="form-control" id="invoiceType" name="invoiceType" required>
                                <option value="CREDIT">Credit</option>
                                <option value="PARTIAL">Partial Payment</option>
                                <option value="PAID">Fully Paid</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="advanceAmount" class="form-label">Advance/Paid Amount</label>
                            <input type="number" class="form-control" id="advanceAmount" name="advanceAmount" min="0" step="0.01" value="0">
                        </div>
                        <div class="col-md-4">
                            <label for="paymentMethod" class="form-label">Payment Method</label>
                            <select class="form-control" id="paymentMethod" name="paymentMethod">
                                <option value="">Select Method</option>
                                <option value="CASH">Cash</option>
                                <option value="UPI">UPI</option>
                                <option value="CARD">Card</option>
                                <option value="BANK_TRANSFER">Bank Transfer</option>
                                <option value="CHEQUE">Cheque</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-modern" data-bs-dismiss="modal">
                        <i class="fas fa-times"></i>
                        Cancel
                    </button>
                    <button type="button" class="btn btn-info btn-modern" onclick="previewInvoice()">
                        <i class="fas fa-eye"></i>
                        Preview
                    </button>
                    <button type="submit" class="btn btn-primary btn-modern">
                        <i class="fas fa-save"></i>
                        Create Invoice
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Invoice Preview Modal -->
<div class="modal fade" id="invoicePreviewModal" tabindex="-1" aria-labelledby="invoicePreviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="invoicePreviewModalLabel">Invoice Preview</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="invoicePreviewContent">
                <!-- Preview content will be generated here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-modern" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary btn-modern" onclick="confirmCreateInvoice()">
                    <i class="fas fa-check"></i>
                    Confirm & Create
                </button>
            </div>
        </div>
    </div>
</div>

<script>
let invoiceItemCounter = 0;

$(document).ready(function() {
    // Set today's date as default
    const today = new Date().toISOString().split('T')[0];
    $('#invoiceDate').val(today);

    // Generate invoice number
    generateInvoiceNumber();

    // Add first item row
    addInvoiceItem();

    // Customer selection handler
    $('#invoiceCustomer').on('change', function() {
        const selectedOption = $(this).find(':selected');
        if (selectedOption.val()) {
            $('#custName').text(selectedOption.data('name'));
            $('#custPhone').text(selectedOption.data('phone'));
            $('#custEmail').text(selectedOption.data('email'));
            $('#customerDetails').removeClass('d-none');
        } else {
            $('#customerDetails').addClass('d-none');
        }
    });

    // Invoice type change handler
    $('#invoiceType').on('change', function() {
        const type = $(this).val();
        const advanceField = $('#advanceAmount');
        const paymentMethodField = $('#paymentMethod');

        if (type === 'PAID') {
            advanceField.val($('#invoiceTotal').text());
            paymentMethodField.prop('required', true);
        } else if (type === 'CREDIT') {
            advanceField.val(0);
            paymentMethodField.prop('required', false);
        }
    });

    // Discount change handler
    $('#invoiceDiscount').on('input', function() {
        calculateInvoiceTotal();
    });

    // Form submission
    $('#addInvoiceForm').on('submit', function(e) {
        e.preventDefault();

        if (this.checkValidity() && validateInvoiceItems()) {
            const formData = collectInvoiceData();

            $.ajax({
                url: '${pageContext.request.contextPath}/api/invoices',
                method: 'POST',
                data: JSON.stringify(formData),
                contentType: 'application/json',
                success: function(response) {
                    showNotification('Invoice created successfully!', 'success');
                    $('#addInvoiceModal').modal('hide');
                    resetInvoiceForm();
                    // Refresh invoices table if on invoices page
                    if (currentPage === 'invoices') {
                        location.reload();
                    }
                },
                error: function(xhr) {
                    const error = xhr.responseJSON ? xhr.responseJSON.message : 'Error creating invoice';
                    showNotification(error, 'error');
                }
            });
        }

        $(this).addClass('was-validated');
    });
});

function generateInvoiceNumber() {
    // Generate invoice number based on date and sequence
    const today = new Date();
    const year = today.getFullYear().toString().slice(-2);
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');

    $.ajax({
        url: '${pageContext.request.contextPath}/api/invoices/next-number',
        method: 'GET',
        success: function(response) {
            $('#invoiceId').val(`INV${year}${month}${day}${String(response.nextNumber).padStart(3, '0')}`);
        },
        error: function() {
            // Fallback to timestamp-based number
            const timestamp = Date.now().toString().slice(-6);
            $('#invoiceId').val(`INV${year}${month}${day}${timestamp}`);
        }
    });
}

function addInvoiceItem() {
    invoiceItemCounter++;
    const row = `
        <tr id="item${invoiceItemCounter}">
            <td>
                <input type="text" class="form-control item-description" name="items[${invoiceItemCounter}].description" placeholder="Item description" required>
            </td>
            <td>
                <input type="number" class="form-control item-quantity" name="items[${invoiceItemCounter}].quantity" min="1" step="0.01" value="1" onchange="calculateItemTotal(${invoiceItemCounter})" required>
            </td>
            <td>
                <input type="number" class="form-control item-price" name="items[${invoiceItemCounter}].unitPrice" min="0" step="0.01" placeholder="0.00" onchange="calculateItemTotal(${invoiceItemCounter})" required>
            </td>
            <td>
                <input type="number" class="form-control item-tax" name="items[${invoiceItemCounter}].taxPercent" min="0" max="100" step="0.01" value="0" onchange="calculateItemTotal(${invoiceItemCounter})">
            </td>
            <td>
                <span class="fw-bold item-total" id="itemTotal${invoiceItemCounter}">₹0.00</span>
            </td>
            <td>
                <button type="button" class="btn btn-sm btn-danger" onclick="removeInvoiceItem(${invoiceItemCounter})">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
    `;
    $('#invoiceItemsBody').append(row);
}

function removeInvoiceItem(itemId) {
    $(`#item${itemId}`).remove();
    calculateInvoiceTotal();
}

function calculateItemTotal(itemId) {
    const row = $(`#item${itemId}`);
    const quantity = parseFloat(row.find('.item-quantity').val()) || 0;
    const price = parseFloat(row.find('.item-price').val()) || 0;
    const taxPercent = parseFloat(row.find('.item-tax').val()) || 0;

    const subtotal = quantity * price;
    const taxAmount = subtotal * (taxPercent / 100);
    const total = subtotal + taxAmount;

    row.find('.item-total').text(`₹${total.toFixed(2)}`);
    calculateInvoiceTotal();
}

function calculateInvoiceTotal() {
    let subtotal = 0;
    let totalTax = 0;

    $('#invoiceItemsBody tr').each(function() {
        const row = $(this);
        const quantity = parseFloat(row.find('.item-quantity').val()) || 0;
        const price = parseFloat(row.find('.item-price').val()) || 0;
        const taxPercent = parseFloat(row.find('.item-tax').val()) || 0;

        const itemSubtotal = quantity * price;
        const itemTax = itemSubtotal * (taxPercent / 100);

        subtotal += itemSubtotal;
        totalTax += itemTax;
    });

    const discount = parseFloat($('#invoiceDiscount').val()) || 0;
    const total = subtotal + totalTax - discount;

    $('#invoiceSubtotal').text(subtotal.toFixed(2));
    $('#invoiceTax').text(totalTax.toFixed(2));
    $('#invoiceTotal').text(total.toFixed(2));

    // Update advance amount if invoice type is PAID
    if ($('#invoiceType').val() === 'PAID') {
        $('#advanceAmount').val(total.toFixed(2));
    }
}

function validateInvoiceItems() {
    const itemRows = $('#invoiceItemsBody tr').length;
    if (itemRows === 0) {
        showNotification('Please add at least one item to the invoice', 'error');
        return false;
    }

    let isValid = true;
    $('#invoiceItemsBody tr').each(function() {
        const row = $(this);
        const description = row.find('.item-description').val().trim();
        const quantity = parseFloat(row.find('.item-quantity').val());
        const price = parseFloat(row.find('.item-price').val());

        if (!description || quantity <= 0 || price < 0) {
            isValid = false;
            row.addClass('table-danger');
        } else {
            row.removeClass('table-danger');
        }
    });

    if (!isValid) {
        showNotification('Please fill all item details correctly', 'error');
    }

    return isValid;
}

function collectInvoiceData() {
    const items = [];
    $('#invoiceItemsBody tr').each(function(index) {
        const row = $(this);
        items.push({
            description: row.find('.item-description').val(),
            quantity: parseFloat(row.find('.item-quantity').val()),
            unitPrice: parseFloat(row.find('.item-price').val()),
            taxPercent: parseFloat(row.find('.item-tax').val()) || 0
        });
    });

    return {
        invoiceId: $('#invoiceId').val(),
        customerId: $('#invoiceCustomer').val(),
        invoiceDate: $('#invoiceDate').val(),
        items: items,
        discount: parseFloat($('#invoiceDiscount').val()) || 0,
        notes: $('#invoiceNotes').val(),
        invoiceType: $('#invoiceType').val(),
        advanceAmount: parseFloat($('#advanceAmount').val()) || 0,
        paymentMethod: $('#paymentMethod').val()
    };
}

function previewInvoice() {
    if (!validateInvoiceItems()) {
        return;
    }

    const data = collectInvoiceData();
    const customer = $('#invoiceCustomer option:selected');

    const previewHtml = `
        <div class="invoice-preview">
            <div class="text-center mb-4">
                <h3>${ownerInfo.shopName || 'BillMatePro'}</h3>
                <p class="mb-1">${ownerInfo.address || ''}</p>
                <p class="mb-1">Phone: ${ownerInfo.mobNumber || ''} | Email: ${ownerInfo.email || ''}</p>
                <p class="mb-0">GST: ${ownerInfo.gstNumber || ''}</p>
            </div>

            <div class="row mb-3">
                <div class="col-6">
                    <strong>Bill To:</strong><br>
                    ${customer.data('name')}<br>
                    Phone: ${customer.data('phone')}<br>
                    Email: ${customer.data('email')}
                </div>
                <div class="col-6 text-end">
                    <strong>Invoice #:</strong> ${data.invoiceId}<br>
                    <strong>Date:</strong> ${new Date(data.invoiceDate).toLocaleDateString()}<br>
                    <strong>Type:</strong> ${data.invoiceType}
                </div>
            </div>

            <table class="table table-bordered">
                <thead class="table-primary">
                    <tr>
                        <th>Item</th>
                        <th>Qty</th>
                        <th>Price</th>
                        <th>Tax%</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.items.map(item => `
                        <tr>
                            <td>${item.description}</td>
                            <td>${item.quantity}</td>
                            <td>₹${item.unitPrice.toFixed(2)}</td>
                            <td>${item.taxPercent}%</td>
                            <td>₹${((item.quantity * item.unitPrice) * (1 + item.taxPercent/100)).toFixed(2)}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>

            <div class="row">
                <div class="col-8">
                    ${data.notes ? `<strong>Notes:</strong><br>${data.notes}` : ''}
                </div>
                <div class="col-4">
                    <table class="table table-sm">
                        <tr><td>Subtotal:</td><td class="text-end">₹${$('#invoiceSubtotal').text()}</td></tr>
                        <tr><td>Tax:</td><td class="text-end">₹${$('#invoiceTax').text()}</td></tr>
                        <tr><td>Discount:</td><td class="text-end">₹${data.discount.toFixed(2)}</td></tr>
                        <tr class="table-primary"><td><strong>Total:</strong></td><td class="text-end"><strong>₹${$('#invoiceTotal').text()}</strong></td></tr>
                        <tr><td>Paid:</td><td class="text-end">₹${data.advanceAmount.toFixed(2)}</td></tr>
                        <tr class="table-warning"><td><strong>Balance:</strong></td><td class="text-end"><strong>₹${(parseFloat($('#invoiceTotal').text()) - data.advanceAmount).toFixed(2)}</strong></td></tr>
                    </table>
                </div>
            </div>
        </div>
    `;

    $('#invoicePreviewContent').html(previewHtml);
    $('#invoicePreviewModal').modal('show');
}

function confirmCreateInvoice() {
    $('#invoicePreviewModal').modal('hide');
    $('#addInvoiceForm').submit();
}

function resetInvoiceForm() {
    $('#addInvoiceForm')[0].reset();
    $('#invoiceItemsBody').empty();
    $('#customerDetails').addClass('d-none');
    invoiceItemCounter = 0;

    // Reset calculated values
    $('#invoiceSubtotal').text('0.00');
    $('#invoiceTax').text('0.00');
    $('#invoiceTotal').text('0.00');

    // Set defaults
    const today = new Date().toISOString().split('T')[0];
    $('#invoiceDate').val(today);
    generateInvoiceNumber();
    addInvoiceItem();
}

// Reset form when modal is hidden
$('#addInvoiceModal').on('hidden.bs.modal', function() {
    resetInvoiceForm();
});
</script>