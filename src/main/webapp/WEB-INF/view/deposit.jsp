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
            <div class="container-fluid px-4 py-4">

                <!-- Invoice Summary Card -->
                <div class="card-modern invoice-summary mb-4">
                    <div class="p-4">
                        <h5 class="summary-title">
                            <i class="fas fa-file-invoice-dollar"></i>
                            Customer Account Summary
                        </h5>

                        <div class="table-responsive">
                            <table class="table table-modern mb-0">
                                <thead>
                                <tr>
                                    <th>Customer Name</th>
                                    <th>Address</th>
                                    <th>Mobile Number</th>
                                    <th>Total Amount</th>
                                    <th>Paid Amount</th>
                                    <th>Balance Amount</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td class="fw-semibold">Mr. ${profile.custName}</td>
                                    <td>${profile.address}</td>
                                    <td><i class="fas fa-phone me-2"></i>${profile.phoneNo}</td>
                                    <td>
                                        <input type="text" readonly class="form-control amount-box amount-total" value="₹ ${profile.totalAmount}" />
                                    </td>
                                    <td>
                                        <input type="text" readonly class="form-control amount-box amount-paid" value="₹ ${profile.paidAmout}" />
                                    </td>
                                    <td>
                                        <input type="text" readonly class="form-control amount-box amount-balance" value="₹ ${profile.currentOusting}" />
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Deposit Form Section -->
                        <div class="deposit-form-section">
                            <form action="${pageContext.request.contextPath}/company/balance-credit" method="post" modelAttribute="BalanceDeposite">
                                <input type="hidden" name="custId" value="${profile.id}">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <label class="form-label-modern">
                                            <i class="fas fa-credit-card"></i>
                                            Payment Mode
                                        </label>
                                        <select required name="modeOfPayment" class="form-select form-select-modern">
                                            <option value="">-- Select Payment Mode --</option>
                                            <option value="Returns">Returns</option>
                                            <option value="By GPay">GPay</option>
                                            <option value="By PhonePe">PhonePe</option>
                                            <option value="By Cash">By Cash</option>
                                            <option value="By Cheque">By Cheque</option>
                                            <option value="Booking">Booking</option>
                                            <option value="Others">Others</option>
                                        </select>
                                    </div>

                                    <div class="col-md-3">
                                        <label class="form-label-modern">
                                            <i class="fas fa-comment-dots"></i>
                                            Description
                                        </label>
                                        <input type="text" name="description" class="form-control form-control-modern"
                                               placeholder="Enter description (optional)" />
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label-modern">
                                            <i class="fas fa-calendar-alt"></i>
                                            Date
                                        </label>
                                        <input name="date" type="date" value="${date}" required class="form-control form-control-modern" />
                                    </div>

                                    <div class="col-md-2">
                                        <label class="form-label-modern">
                                            <i class="fas fa-rupee-sign"></i>
                                            Deposit Amount
                                        </label>
                                        <input type="text" name="advAmt" required maxlength="7"
                                               class="form-control form-control-modern"
                                               placeholder="0.00"
                                               oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" />
                                    </div>

                                    <div class="col-md-2 d-flex align-items-end">
                                        <button type="submit" class="btn btn-deposit w-100">
                                            <i class="fas fa-check-circle me-2"></i>Deposit
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Invoice History Card -->
                <div class="card-modern history-section">
                    <div class="history-header">
                        <i class="fas fa-history"></i>
                        <h5>Transaction History</h5>
                    </div>
                    <div class="history-body">
                        <div class="table-responsive">
                            <table id="datatablesSimple" class="table table-hover mb-0">
                                <thead>
                                <tr>
                                    <th>Transaction ID</th>
                                    <th>Customer Name</th>
                                    <th>Description</th>
                                    <th>Closing Amount</th>
                                    <th>Payment Mode</th>
                                    <th>Deposited Amount</th>
                                    <th>Date</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${balanceDeposits}" var="balanceDeposit">
                                    <tr>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/company/get-bal-credit-receipt/${balanceDeposit.id}"
                                               target="_blank" class="transaction-link">
                                                <i class="fas fa-receipt"></i>
                                                #${balanceDeposit.id}
                                            </a>
                                        </td>
                                        <td class="fw-semibold">${balanceDeposit.custName}</td>
                                        <td>${balanceDeposit.description}</td>
                                        <td class="text-end">
                                            <span class="badge bg-danger bg-gradient px-3 py-2">
                                                ₹ ${balanceDeposit.currentOusting}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-info bg-gradient px-3 py-2">
                                                ${balanceDeposit.modeOfPayment}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <span class="badge bg-success bg-gradient px-3 py-2">
                                                ₹ ${balanceDeposit.advAmt}
                                            </span>
                                        </td>
                                        <td>
                                            <i class="far fa-calendar me-2"></i>${balanceDeposit.date}
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Success Message -->
                <c:if test="${not empty msg}">
                    <div class="position-fixed top-0 end-0 p-3" style="z-index: 9999; margin-top: 80px;">
                        <div class="alert alert-success alert-modern alert-dismissible fade show shadow-lg" role="alert" id="success-alert">
                            <div class="d-flex align-items-center">
                                <i class="bi bi-check-circle-fill fs-4 me-3"></i>
                                <div>
                                    <strong>Success!</strong> ${msg}
                                </div>
                            </div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </div>
                </c:if>

            </div>
        </main>

        <!-- Footer -->
        <footer class="py-4 bg-light mt-auto">
            <div class="container-fluid px-4">
                <div class="d-flex align-items-center justify-content-between small">
                    <div class="text-muted">Copyright &copy; BillMatePro 2025</div>
                    <div>
                        <a href="#" class="text-decoration-none">Privacy Policy</a>
                        &middot;
                        <a href="#" class="text-decoration-none">Terms &amp; Conditions</a>
                    </div>
                </div>
            </div>
        </footer>
    </div>


<!-- Hidden Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
</form>

<!-- JavaScript Libraries -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

<!-- DataTables -->
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

<!-- Export Libraries -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>

<script>
    // Page Loader
    window.addEventListener('load', function() {
        setTimeout(function() {
            const loader = document.getElementById('pageLoader');
            if (loader) {
                loader.classList.add('hidden');
                setTimeout(() => {
                    loader.style.display = 'none';
                }, 500);
            }
        }, 1000);
    });

    // Theme Toggle
    function toggleTheme() {
        const body = document.body;
        const themeIcon = document.getElementById('theme-icon');
        const currentTheme = body.getAttribute('data-theme');

        if (currentTheme === 'light') {
            body.setAttribute('data-theme', 'dark');
            themeIcon.className = 'fas fa-sun';
            localStorage.setItem('theme', 'dark');
        } else {
            body.setAttribute('data-theme', 'light');
            themeIcon.className = 'fas fa-moon';
            localStorage.setItem('theme', 'light');
        }
    }

    // Load saved theme
    document.addEventListener('DOMContentLoaded', function() {
        const savedTheme = localStorage.getItem('theme') || 'light';
        document.body.setAttribute('data-theme', savedTheme);
        document.getElementById('theme-icon').className = savedTheme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
    });

    // DataTables Initialization
    $(document).ready(function() {
        $('#datatablesSimple').DataTable({
            responsive: true,
            pageLength: 10,
            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
            order: [[6, 'desc']], // Sort by date column
            language: {
                search: "_INPUT_",
                searchPlaceholder: "Search transactions...",
                lengthMenu: "Show _MENU_ entries",
                info: "Showing _START_ to _END_ of _TOTAL_ transactions",
                infoEmpty: "No transactions found",
                infoFiltered: "(filtered from _MAX_ total transactions)"
            },
            dom: '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>rtip',
            columnDefs: [
                { targets: [3, 5], className: 'text-end' }
            ]
        });
    });

    // Auto-hide success alert
    window.addEventListener('load', function() {
        setTimeout(function() {
            const successAlert = document.getElementById('success-alert');
            if (successAlert) {
                const bsAlert = bootstrap.Alert.getOrCreateInstance(successAlert);
                bsAlert.close();
            }
        }, 5000);
    });

    // Logout Confirmation
    function confirmLogout(event) {
        event.preventDefault();

        if (confirm('Are you sure you want to logout?')) {
            const logoutForm = document.getElementById('logoutForm');
            if (logoutForm) {
                logoutForm.submit();
            } else {
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        }
    }

    // Simple logout without confirmation
    function performLogout() {
        try {
            const logoutForm = document.getElementById('logoutForm');
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

    // Form Validation Enhancement
    document.addEventListener('DOMContentLoaded', function() {
        const depositForm = document.querySelector('form[action*="balance-credit"]');

        if (depositForm) {
            depositForm.addEventListener('submit', function(e) {
                const submitBtn = this.querySelector('button[type="submit"]');
                const amountInput = this.querySelector('input[name="advAmt"]');
                const paymentMode = this.querySelector('select[name="modeOfPayment"]');

                // Validate amount
                if (!amountInput.value || parseFloat(amountInput.value) <= 0) {
                    e.preventDefault();
                    alert('Please enter a valid deposit amount');
                    amountInput.focus();
                    return false;
                }

                // Validate payment mode
                if (!paymentMode.value) {
                    e.preventDefault();
                    alert('Please select a payment mode');
                    paymentMode.focus();
                    return false;
                }

                // Show loading state
                submitBtn.classList.add('btn-loading');
                submitBtn.disabled = true;
            });
        }
    });



    // Format currency inputs
    document.addEventListener('DOMContentLoaded', function() {
        const currencyInputs = document.querySelectorAll('input[name="advAmt"]');

        currencyInputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value) {
                    const value = parseFloat(this.value);
                    if (!isNaN(value)) {
                        this.value = value.toFixed(2);
                    }
                }
            });
        });
    });

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href !== '#' && href !== '') {
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }
        });
    });
</script>

</body>
</html>