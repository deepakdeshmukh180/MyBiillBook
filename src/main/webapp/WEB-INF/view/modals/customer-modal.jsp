<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Add Customer Button -->
<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
    <i class="fas fa-plus me-2"></i> Add Customer
</button>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<!-- Modal -->
<div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="customerForm">
                <div class="modal-header">
                    <h5 class="modal-title" id="addCustomerModalLabel">Add Customer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body row g-3">
                    <div class="col-md-6">
                        <label for="custName" class="form-label">Customer Name <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="custName" name="custName" required>
                    </div>
                    <div class="col-md-6">
                        <label for="phoneNo" class="form-label">WhatsApp Number <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="phoneNo" name="phoneNo" required>
                    </div>
                    <div class="col-md-6">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="email" name="email">
                    </div>
                    <div class="col-md-6">
                        <label for="currentOusting" class="form-label">Outstanding Amount</label>
                        <input type="number" class="form-control" id="currentOusting" name="currentOusting" value="0">
                    </div>
                    <div class="col-12">
                        <label for="address" class="form-label">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="2"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <span id="formMessage" class="me-auto text-danger"></span>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Save Customer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- AJAX Logic -->
<script>
    $(document).ready(function () {
        $('#customerForm').on('submit', function (e) {
            e.preventDefault();
            let formData = $(this).serialize();

            $.ajax({
                url: '/save-profile-details',
                type: 'POST',
                data: formData,
                success: function (response) {
                    $('#addCustomerModal').modal('hide');
                    $('#customerForm')[0].reset();

                    // Replace the customer table body
                    $('#customer-tbl tbody').html($(response).find('#customer-tbl tbody').html());

                    // Optionally: Refresh pagination
                    updatePagination();
                },
                error: function () {
                    $('#formMessage').text("Something went wrong. Please try again.");
                }
            });
        });
    });

    function updatePagination() {
        // Optional placeholder for re-triggering any pagination logic after AJAX update
    }
</script>
