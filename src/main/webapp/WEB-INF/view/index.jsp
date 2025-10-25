<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="../view/logo.jsp"></jsp:include>


  <!-- Main -->
  <div id="layoutSidenav_content">
    <main>
      <div class="container-fluid px-4 mt-4">

        <!-- Success toast -->
        <c:if test="${not empty msg}">
          <div class="alert alert-success alert-dismissible fade show enhanced-card border-0 fade-in-up" role="alert" id="success-alert">
            <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
        </c:if>

        <!-- KPI ROW -->
        <div class="row g-4 mb-4">
          <!-- Customers -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi-card p-4 fade-in-up stagger-1">
              <div class="d-flex align-items-center">
                <div class="kpi-icon me-3">
                  <i class="fa-solid fa-user-group"></i>
                </div>
                <div class="flex-grow-1">
                  <div class="text-muted small mb-1">Total Customers</div>
                  <div class="fs-3 fw-bold text-primary"><c:out value="${customerCount}"/></div>
                </div>
                <a class="btn btn-outline-primary btn-sm btn-modern" href="${pageContext.request.contextPath}/company/get-all-customers">
                  <i class="fas fa-eye me-1"></i>View
                </a>
              </div>
            </div>
          </div>

          <!-- Invoices -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi-card p-4 fade-in-up stagger-2">
              <div class="d-flex align-items-center">
                <div class="kpi-icon me-3" style="background: linear-gradient(45deg, #ffc107, #ff8f00);">
                  <i class="fa-solid fa-file-invoice"></i>
                </div>
                <div class="flex-grow-1">
                  <div class="text-muted small mb-1">Total Invoices</div>
                  <div class="fs-3 fw-bold text-warning"><c:out value="${invoiceCount}"/></div>
                </div>
                <a class="btn btn-outline-warning btn-sm btn-modern" href="${pageContext.request.contextPath}/company/get-all-invoices">
                  <i class="fas fa-eye me-1"></i>View
                </a>
              </div>
            </div>
          </div>

          <!-- Today's Expense -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi-card p-4 fade-in-up stagger-3">
              <div class="d-flex align-items-center">
                <div class="kpi-icon me-3" style="background: linear-gradient(45deg, #198754, #20c997);">
                  <i class="fa-solid fa-indian-rupee-sign"></i>
                </div>
                <div class="flex-grow-1">
                  <div class="text-muted small mb-1">Today's Expense</div>
                  <div class="fs-3 fw-bold text-success">
                    ₹<fmt:formatNumber value="${empty daily_expenses ? 0.0 : daily_expenses}" type="number"/>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Total Expenses -->
          <div class="col-xl-3 col-md-6">
            <div class="card kpi-card p-4 fade-in-up stagger-4">
              <div class="d-flex align-items-center">
                <div class="kpi-icon me-3" style="background: linear-gradient(45deg, #dc3545, #e74c3c);">
                  <i class="fa-solid fa-wallet"></i>
                </div>
                <div class="flex-grow-1">
                  <div class="text-muted small mb-1">Total Expenses</div>
                  <div class="fs-3 fw-bold text-danger">
                    ₹<fmt:formatNumber value="${empty monthly_expenses ? 0.0 : monthly_expenses}" type="number"/>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- MAIN CONTENT ROW -->
        <div class="row g-4">
          <!-- Welcome Card -->
          <div class="col-lg-4">
            <div class="card welcome-card fade-in-up">
              <div class="card-body p-4">
                <div class="d-flex align-items-center mb-3">
                  <div class="me-3">
                    <i class="fas fa-hand-paper fs-2"></i>
                  </div>
                  <div>
                    <h5 class="mb-1">Hello, <span class="fw-bold">${ownerInfo.ownerName}!</span></h5>
                    <p class="mb-0 opacity-75">Welcome to BillMatePro Solutions</p>
                  </div>
                </div>

                <div class="bg-white bg-opacity-10 rounded-3 p-3 mb-4">
                  <h6 class="mb-2"><i class="bi bi-shop me-2"></i>${ownerInfo.shopName}</h6>
                  <div class="row g-2 small">
                    <div class="col-12"><i class="bi bi-geo-alt me-1"></i><strong>Address:</strong> ${ownerInfo.address}</div>
                    <div class="col-12"><i class="bi bi-phone me-1"></i><strong>Mobile:</strong> ${ownerInfo.mobNumber}</div>
                    <div class="col-12"><i class="bi bi-envelope me-1"></i><strong>Email:</strong> ${ownerInfo.email}</div>
                    <div class="col-12"><i class="bi bi-receipt me-1"></i><strong>GST:</strong> ${ownerInfo.gstNumber}</div>
                  </div>
                </div>

                <div class="d-flex gap-2">
                  <div>
                  <a href="${pageContext.request.contextPath}/company/get-my-profile" class="btn btn-light btn-sm btn-modern flex-fill">
                    <i class="fa fa-user-edit me-1"></i> Edit Shop
                  </a>  </div>
                  <button type="button"
                          class="btn btn-outline-light btn-sm btn-modern flex-fill"
                          id="addCustomerBtn">
                    <i class="fa fa-user-plus me-1"></i> Add Customer
                  </button>
                </div>
              </div>

              <!-- Pie Chart Section -->
              <div class="card-body pt-0">
                <div class="bg-white bg-opacity-10 rounded-3 p-3">
                  <h6 class="text-center mb-3">Payment Overview</h6>
                  <canvas id="paymentPieChart" height="200"></canvas>
                </div>
              </div>
            </div>
          </div>

          <!-- Today's Summary & Charts -->
          <div class="col-lg-4">
            <div class="card chart-card h-100 fade-in-up">
              <div class="card-body">
                <div class="section-header">
                  <h6 class="section-title mb-0">Today's Business Summary</h6>
                </div>

                <div class="row text-center mb-4">
                  <div class="col-6">
                    <div class="bg-primary bg-opacity-10 rounded-3 p-3">
                      <i class="bi bi-file-earmark-text-fill text-primary fs-3 d-block mb-2"></i>
                      <small class="text-muted">Invoices Created</small>
                      <h4 class="mb-0 text-primary fw-bold">${dailySummary.invoiceCount}</h4>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="bg-success bg-opacity-10 rounded-3 p-3">
                      <i class="bi bi-currency-exchange text-success fs-3 d-block mb-2"></i>
                      <small class="text-muted">Transactions</small>
                      <h4 class="mb-0 text-success fw-bold">${dailySummary.transactionCount}</h4>
                    </div>
                  </div>
                </div>

                <div class="row text-center mb-4">
                  <div class="col-6">
                    <div class="border-end">
                      <small class="text-muted d-block">Collected</small>
                      <h6 class="mb-0 text-success">₹${dailySummary.collectedAmount/1000}K</h6>
                    </div>
                  </div>
                  <div class="col-6">
                    <div>
                      <small class="text-muted d-block">Balance</small>
                      <h6 class="mb-0 text-warning">₹${dailySummary.totalBalanceAmount/1000}K</h6>
                    </div>
                  </div>
                </div>

                <!-- Bar Chart -->
                <div class="bg-light rounded-3 p-3 mb-4">
                  <h6 class="text-center mb-3">Today's Financial Summary</h6>
                  <canvas id="paymentBarChart" height="180"></canvas>
                </div>

                <!-- Expiry Carousel -->
                <div class="expiry-carousel">
                  <h6 class="section-title mb-3"><i class="fas fa-exclamation-triangle text-warning me-2"></i>Product Alerts</h6>
                  <div id="expiryNoticeCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4200">
                    <div class="carousel-inner">
                      <c:forEach var="product" items="${productList}" varStatus="loop">
                        <div class="carousel-item ${loop.index == 0 ? 'active' : ''}">
                          <div class="card border-0 mx-auto">
                            <div class="card-header text-white text-center">
                              <h6 class="mb-0">⚠️ Expiry Alert #${loop.index + 1}</h6>
                            </div>
                            <div class="card-body text-center">
                              <h6 class="card-title text-danger fw-bold mb-3">${product.name}</h6>

                              <div class="d-flex justify-content-between align-items-center px-2">
                                <small><strong>Qty:</strong> ${product.quantity}</small>
                                <span class="badge bg-danger badge-modern">
                                  ${product.expiresIn} days left
                                </span>
                              </div>

                            </div>
                          </div>
                        </div>
                      </c:forEach>

                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#expiryNoticeCarousel" data-bs-slide="prev">
                      <span class="carousel-control-prev-icon"></span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#expiryNoticeCarousel" data-bs-slide="next">
                      <span class="carousel-control-next-icon"></span>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Recent Customers -->
         <!-- Recent Customers -->
                  <div class="col-lg-4">
                    <div class="card enhanced-card h-100 fade-in-up">
                      <div class="card-body">
                        <div class="section-header">
                          <h6 class="section-title mb-0">Recent Customers <small class="text-muted fw-normal">(Latest 5)</small></h6>
                        </div>

                        <!-- Search Box -->
                        <div class="mb-3" style="margin-top: 2%"
>
                          <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                            <input type="text"
                                   class="form-control"
                                   id="searchInput"
                                   placeholder="Search customers..."
                                   autocomplete="off" />
                            <button class="btn btn-primary btn-modern" id="searchBtn" type="button">
                              <i class="fas fa-search me-1"></i>Search
                            </button>
                          </div>
                          <small class="text-muted">Type at least 2 characters</small>
                        </div>

                        <!-- Loading Spinner -->
                        <div id="searchLoader" class="text-center py-3" style="display: none;">
                          <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Searching...</span>
                          </div>
                        </div>

                     <div class="customer-list" id="customerList" style="max-height: 75vh; overflow-y: auto; position: relative;">
                  <c:forEach items="${custmers}" var="custmer" varStatus="status">
                    <div class="customer-mini-card p-3 mb-3">
                      <div class="d-flex align-items-start">
                        <div class="customer-avatar me-3">
                          ${fn:substring(custmer.custName, 0, 1)}
                        </div>
                        <div class="flex-grow-1">
                          <div class="d-flex justify-content-between align-items-start mb-2">
                            <h6 class="text-primary fw-semibold mb-0">${custmer.custName}</h6>
                            <a href="${pageContext.request.contextPath}/company/update-customer/${custmer.id}"
                               class="text-primary" title="Edit Customer">
                              <i class="fas fa-edit"></i>
                            </a>
                          </div>

                          <div class="text-muted small mb-2">
                            <i class="fas fa-map-marker-alt me-1"></i>${custmer.address}
                          </div>

                          <div class="text-muted small mb-3">
                            <a href="https://wa.me/${custmer.phoneNo}" target="_blank" class="text-success text-decoration-none">
                              <i class="fab fa-whatsapp me-1"></i>${custmer.phoneNo}
                            </a>
                          </div>

                          <div class="d-flex gap-1 mb-3 flex-wrap">
                            <span class="badge bg-primary badge-modern">Total ₹${custmer.totalAmount}</span>
                            <span class="badge bg-success badge-modern">Paid ₹${custmer.paidAmout}</span>
                            <span class="badge bg-danger badge-modern">Bal ₹${custmer.currentOusting}</span>
                          </div>

                          <div class="d-flex gap-2 flex-wrap">
                            <form method="get" action="${pageContext.request.contextPath}/company/get-cust-by-id" class="flex-fill">
                              <input type="hidden" name="custid" value="${custmer.id}" />
                              <button class="btn btn-outline-primary btn-sm btn-modern w-100" type="submit">
                                <i class="fas fa-file-invoice me-1"></i>Invoice
                              </button>
                            </form>
                            <form method="get" action="${pageContext.request.contextPath}/company/get-bal-credit-page/${custmer.id}" class="flex-fill">
                              <button class="btn btn-outline-success btn-sm btn-modern w-100" type="submit">
                                <i class="fas fa-donate me-1"></i>Deposit
                              </button>
                            </form>
                            <form method="get" action="${pageContext.request.contextPath}/company/cust-history" target="_blank" class="flex-fill">
                              <input type="hidden" name="custid" value="${custmer.id}" />
                              <button class="btn btn-outline-warning btn-sm btn-modern w-100" type="submit">
                                <i class="fas fa-list-ol me-1"></i>History
                              </button>
                            </form>
                          </div>
                        </div>
                      </div>
                    </div>
                  </c:forEach>

                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- EXPENSES SECTION -->
        <div class="row g-4 mt-2">
          <!-- Daily Expenses -->
          <div class="col-lg-6">
            <div class="card enhanced-card fade-in-up">
              <div class="card-body">
                <div class="section-header">
                  <h6 class="section-title mb-0">
                    <i class="fa-solid fa-calendar-day me-2 text-primary"></i>Today's Expenses
                  </h6>
                </div>

                <div class="expenses-container" style="max-height: 400px; overflow-y: auto;">
                  <c:forEach var="exp" items="${dailyExpenses}" varStatus="status">
                    <div class="expense-item p-3 mb-3">
                      <div class="d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center">
                          <div class="expense-icon me-3">
                            <i class="fa-solid fa-receipt"></i>
                          </div>
                          <div>
                            <h6 class="fw-semibold mb-1">${exp.expenseName}</h6>
                            <small class="text-muted">
                              <i class="fas fa-calendar me-1"></i>
                              <fmt:formatDate value="${exp.date}" pattern="dd MMM yyyy"/>
                            </small>
                          </div>
                        </div>
                        <div class="text-end">
                          <div class="fs-5 fw-bold text-danger">
                            ₹<fmt:formatNumber value="${exp.amount}" type="number"/>
                          </div>
                        </div>
                      </div>
                    </div>
                  </c:forEach>

                  <c:if test="${empty dailyExpenses}">
                    <div class="text-center py-5">
                      <div class="text-muted">
                        <i class="fas fa-inbox fs-1 mb-3"></i>
                        <p>No expenses recorded today</p>
                        <a href="${pageContext.request.contextPath}/expenses" class="btn btn-primary btn-modern">
                          <i class="fas fa-plus me-1"></i>Add Expense
                        </a>
                      </div>
                    </div>
                  </c:if>
                </div>
              </div>
            </div>
          </div>

          <!-- Expenses Trend Chart -->
          <div class="col-lg-6">
            <div class="card chart-card h-100 fade-in-up">
              <div class="card-body">
                <div class="section-header">
                  <h6 class="section-title mb-0">
                    <i class="fa-solid fa-chart-line me-2 text-primary"></i>Expenses Trend
                  </h6>
                </div>

                <div class="chart-container bg-light rounded-3 p-3">
                  <canvas id="expensesTrendChart" height="300"></canvas>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div> <!-- /container-fluid -->
    </main>
  </div>
</div>

<!-- Modal: Add Customer -->
<div class="modal fade" id="addCustomerModal" tabindex="-1" role="dialog" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
    <div class="modal-content shadow-lg border-0">
      <!-- Modal Header -->
      <div class="modal-header text-white">
        <h5 class="modal-title" id="addCustomerModalLabel">
          <i class="fas fa-user-plus me-2"></i>Add New Customer
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <!-- Modal Body -->
      <div class="modal-body p-4">
        <form id="customerForm" action="${pageContext.request.contextPath}/login/save-profile-details" method="post" class="needs-validation" novalidate>
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="custName" class="form-label">Customer Name <span class="text-danger">*</span></label>
              <div class="input-group">
                <span class="input-group-text"><i class="fas fa-user"></i></span>
                <input type="text" class="form-control" id="custName" name="custName" required>
                <div class="invalid-feedback">Please enter customer name.</div>
              </div>
            </div>

            <div class="col-md-6 mb-3">
              <label for="phoneNo" class="form-label">Mobile Number <span class="text-danger">*</span></label>
              <div class="input-group">
                <span class="input-group-text"><i class="fas fa-phone"></i></span>
                <input type="tel" class="form-control" id="phoneNo" name="phoneNo" pattern="^[6-9][0-9]{9}$" maxlength="10" required>
                <div class="invalid-feedback">Enter valid 10-digit mobile number.</div>
              </div>
            </div>
          </div>

          <div class="mb-3">
            <label for="email" class="form-label">Email Address</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-envelope"></i></span>
              <input type="email" class="form-control" id="email" name="email" placeholder="customer@example.com">
              <div class="invalid-feedback">Enter valid email address.</div>
            </div>
          </div>

          <div class="mb-3">
            <label for="address" class="form-label">Address <span class="text-danger">*</span></label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
              <textarea class="form-control" id="address" name="address" rows="2" required></textarea>
              <div class="invalid-feedback">Please enter address.</div>
            </div>
          </div>

          <div class="mb-3">
            <label for="currentOusting" class="form-label">Opening Balance</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-rupee-sign"></i></span>
              <input type="number" class="form-control" id="currentOusting" name="currentOusting" value="0" step="0.01" min="0">
              <div class="invalid-feedback">Enter valid balance amount.</div>
            </div>
          </div>

          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </form>
      </div>

      <!-- Modal Footer -->
      <div class="modal-footer bg-light">
        <button type="button" class="btn btn-secondary btn-modern" data-bs-dismiss="modal">
          <i class="fas fa-times me-1"></i>Cancel
        </button>
        <button type="submit" form="customerForm" class="btn btn-primary btn-modern">
          <i class="fas fa-save me-1"></i>Save Customer
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Expiring Products Modal -->
<div class="modal fade" id="expiringModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content border-0 shadow-lg">
      <div class="modal-header" style="background: linear-gradient(45deg, #ffc107, #ff8f00); color: white;">
        <h5 class="modal-title">⚠️ Product Expiration Report</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="table-responsive">
          <table class="table table-hover align-middle">
            <thead class="table-warning">
            <tr>
              <th class="text-center">#</th>
              <th>Product Name</th>
              <th class="text-center">Available Quantity</th>
              <th class="text-center">Expires In</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="product" items="${productList}" varStatus="loop">
              <tr>
                <td class="text-center fw-bold">${loop.index + 1}</td>
                <td>
                  <div class="d-flex align-items-center">
                    <div class="bg-danger bg-opacity-10 rounded-circle p-2 me-2">
                      <i class="fas fa-box text-danger"></i>
                    </div>
                    <span class="fw-semibold">${product.name}</span>
                  </div>
                </td>
                <td class="text-center">
                  <span class="badge bg-info badge-modern">${product.quantity} Nos.</span>
                </td>
                <td class="text-center">
                  <span class="badge bg-danger badge-modern">${product.expiresIn} days left</span>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-outline-secondary btn-modern" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
</form>
<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<jsp:include page="../view/footer.jsp"></jsp:include>


<script>

// Theme toggle functionality
function toggleTheme() {
    const body = document.body;
    const themeIcon = document.getElementById('theme-icon');
    const currentTheme = body.getAttribute("data-theme");
    const newTheme = currentTheme === "dark" ? "light" : "dark";

    body.setAttribute("data-theme", newTheme);

    // Update icon
    if (newTheme === "dark") {
        themeIcon.className = "fas fa-sun";
    } else {
        themeIcon.className = "fas fa-moon";
    }

    // Save preference
    localStorage.setItem('theme', newTheme);
}

// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
  // Load saved theme
  const savedTheme = localStorage.getItem('theme') || 'light';
  const body = document.body;
  const themeIcon = document.getElementById('theme-icon');

  body.setAttribute("data-theme", savedTheme);

  if (savedTheme === "dark") {
      themeIcon.className = "fas fa-sun";
  } else {
      themeIcon.className = "fas fa-moon";
  }

  console.log('DOM loaded, initializing modals...');

  // Initialize modal functionality
  const addCustomerBtn = document.getElementById('addCustomerBtn');
  const addCustomerModal = document.getElementById('addCustomerModal');

  if (addCustomerBtn && addCustomerModal) {
    console.log('Modal elements found, setting up event listener');

    addCustomerBtn.addEventListener('click', function(e) {
      e.preventDefault();
      console.log('Add Customer button clicked');

      try {
        const modal = new bootstrap.Modal(addCustomerModal, {
          backdrop: 'static',
          keyboard: false
        });
        modal.show();
        console.log('Modal shown successfully');
      } catch (error) {
        console.error('Error showing modal:', error);
        // Fallback: try jQuery
        if (typeof $ !== 'undefined') {
          $('#addCustomerModal').modal('show');
        }
      }
    });
  } else {
    console.error('Modal elements not found');
  }

  // Success alert auto-hide
  const successAlert = document.getElementById('success-alert');
  if (successAlert) {
    setTimeout(() => {
      const alert = bootstrap.Alert.getOrCreateInstance(successAlert);
      alert.close();
    }, 3500);
  }

  // Form validation
  const forms = document.querySelectorAll('.needs-validation');
  forms.forEach(form => {
    form.addEventListener('submit', function(event) {
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    });
  });
});

// Global functions
function openModal() {
  const modal = new bootstrap.Modal(document.getElementById('expiringModal'));
  modal.show();
}

// Chart Data and Configuration
const totalAmount = ${totalAmount != null ? totalAmount : 0};
const paidAmount = ${paidAmount != null ? paidAmount : 0};
const currentOusting = ${currentOutstanding != null ? currentOutstanding : 0};
const toK = v => v >= 1000 ? (v/1000).toFixed(1)+'K' : v.toLocaleString();

// Pie Chart
const ctx = document.getElementById('paymentPieChart');
if (ctx) {
  const pieCtx = ctx.getContext('2d');

  // Gradients
  const gradient1 = pieCtx.createLinearGradient(0, 0, 0, 400);
  gradient1.addColorStop(0, '#6a11cb');
  gradient1.addColorStop(1, '#2575fc');

  const gradient2 = pieCtx.createLinearGradient(0, 0, 0, 400);
  gradient2.addColorStop(0, '#ff416c');
  gradient2.addColorStop(1, '#ff4b2b');

  const gradient3 = pieCtx.createLinearGradient(0, 0, 0, 400);
  gradient3.addColorStop(0, '#00f260');
  gradient3.addColorStop(1, '#0575e6');

  new Chart(pieCtx, {
    type: 'doughnut',
    data: {
      labels: ['Total Amount', 'Balance Amount', 'Paid Amount'],
      datasets: [{
        data: [totalAmount, currentOusting, paidAmount],
        backgroundColor: [gradient1, gradient2, gradient3],
        borderWidth: 0,
        hoverOffset: 10
      }]
    },
    options: {
      responsive: true,
      cutout: '60%',
      plugins: {
        legend: {
          position: 'bottom',
          labels: {
            usePointStyle: true,
            padding: 20,
            font: { size: 12, weight: '500' },
            color: getComputedStyle(document.documentElement).getPropertyValue('--text-color').trim()
          }
        },
        tooltip: {
          callbacks: {
            label: function(context) {
              return context.label + ': ₹' + toK(context.parsed);
            }
          }
        }
      }
    }
  });
}

// Bar Chart
const barCtx = document.getElementById('paymentBarChart');
if (barCtx) {
  const totalAmount1 = ${dailySummary.totalAmount != null ? dailySummary.totalAmount : 0};
  const paidAmount1 = ${dailySummary.collectedAmount != null ? dailySummary.collectedAmount : 0};
  const currentOusting1 = ${dailySummary.totalBalanceAmount != null ? dailySummary.totalBalanceAmount : 0};

  new Chart(barCtx.getContext('2d'), {
    type: 'bar',
    data: {
      labels: ['Total Amt', 'Collected', 'Balance'],
      datasets: [{
        label: 'Amount',
        data: [totalAmount1, paidAmount1, currentOusting1],
        backgroundColor: [
          'rgba(34, 71, 165, 0.8)',
          'rgba(16, 185, 129, 0.8)',
          'rgba(245, 158, 11, 0.8)'
        ],
        borderColor: [
          'rgb(34, 71, 165)',
          'rgb(16, 185, 129)',
          'rgb(245, 158, 11)'
        ],
        borderWidth: 2,
        borderRadius: 8,
        borderSkipped: false
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: function(context) {
              return '₹' + toK(context.raw);
            }
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: function(value) {
              return '₹' + toK(value);
            },
            color: getComputedStyle(document.documentElement).getPropertyValue('--text-color').trim()
          },
          grid: {
            color: 'rgba(0,0,0,0.1)'
          }
        },
        x: {
          ticks: {
            color: getComputedStyle(document.documentElement).getPropertyValue('--text-color').trim()
          },
          grid: {
            display: false
          }
        }
      }
    }
  });
}

// Line Chart for Expenses Trend
const expenseCtx = document.getElementById('expensesTrendChart');
if (expenseCtx) {
  const trendLabels = [
    <c:forEach var="exp" items="${dailyExpenses}" varStatus="s">
      '<fmt:formatDate value="${exp.date}" pattern="dd MMM"/>'<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];
  const trendData = [
    <c:forEach var="exp" items="${dailyExpenses}" varStatus="s">
      ${exp.amount}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  new Chart(expenseCtx.getContext('2d'), {
    type: 'line',
    data: {
      labels: trendLabels,
      datasets: [{
        label: 'Daily Expenses',
        data: trendData,
        borderColor: 'rgb(239, 68, 68)',
        backgroundColor: 'rgba(239, 68, 68, 0.1)',
        fill: true,
        tension: 0.4,
        pointBackgroundColor: 'rgb(239, 68, 68)',
        pointBorderColor: '#fff',
        pointBorderWidth: 2,
        pointRadius: 6,
        pointHoverRadius: 8
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: false },
        tooltip: {
          mode: 'index',
          intersect: false,
          callbacks: {
            label: function(context) {
              return '₹' + context.raw.toLocaleString();
            }
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: function(value) {
              return '₹' + value.toLocaleString();
            },
            color: getComputedStyle(document.documentElement).getPropertyValue('--text-color').trim()
          },
          grid: {
            color: 'rgba(0,0,0,0.1)'
          }
        },
        x: {
          ticks: {
            color: getComputedStyle(document.documentElement).getPropertyValue('--text-color').trim()
          },
          grid: {
            display: false
          }
        }
      },
      interaction: {
        intersect: false,
        mode: 'index'
      }
    }
  });
}

// Animation on scroll
const observerOptions = {
  threshold: 0.1,
  rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = '1';
      entry.target.style.transform = 'translateY(0)';
    }
  });
}, observerOptions);

document.querySelectorAll('.fade-in-up').forEach(el => {
  el.style.opacity = '0';
  el.style.transform = 'translateY(30px)';
  el.style.transition = 'all 0.6s ease-out';
  observer.observe(el);
});

// Parallax effect for floating shapes
window.addEventListener('scroll', function() {
    const scrolled = window.pageYOffset;
    const shapes = document.querySelectorAll('.floating-shape');

    shapes.forEach((shape, index) => {
        const speed = 0.5 + (index * 0.1);
        const yPos = -(scrolled * speed);
        shape.style.transform = `translateY(${yPos}px)`;
    });
});

// Add particle effect on mouse move (subtle for dashboard)
let particleCount = 0;
document.addEventListener('mousemove', function(e) {
    if (particleCount > 5) return; // Limit particles

    const cursor = document.createElement('div');
    cursor.className = 'cursor-particle';
    cursor.style.left = e.clientX + 'px';
    cursor.style.top = e.clientY + 'px';

    document.body.appendChild(cursor);
    particleCount++;

    setTimeout(() => {
        cursor.remove();
        particleCount--;
    }, 1000);
});

// Add CSS for cursor particles
const style = document.createElement('style');
style.textContent = `
    .cursor-particle {
        position: fixed;
        width: 3px;
        height: 3px;
        background: var(--primary-color);
        border-radius: 50%;
        pointer-events: none;
        opacity: 0.5;
        animation: fadeParticle 1s ease-out forwards;
        z-index: 9999;
    }

    @keyframes fadeParticle {
        to {
            opacity: 0;
            transform: scale(0);
        }
    }

    .cursor-particle:nth-child(2n) {
        background: var(--success-color);
    }
`;
document.head.appendChild(style);

// Update charts on theme change
function updateChartsTheme() {
    // This function can be called when theme changes to update chart colors
    // You can extend this to update all charts with theme-appropriate colors
}

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



function renderCards(customers) {
    const customerList = document.getElementById('customerList');

    if (!customerList) {
        console.error('customerList container not found');
        return;
    }

    if (!customers || customers.length === 0) {
        customerList.innerHTML =
            '<div class="text-center py-5">' +
                '<i class="fas fa-search fs-1 text-muted mb-3"></i>' +
                '<p class="text-muted">No matching customers found</p>' +
            '</div>';
        return;
    }

    var html = '';

    customers.forEach(function(customer) {
        html += '<div class="customer-mini-card p-3 mb-3">' +
                    '<div class="d-flex align-items-start">' +
                        '<div class="customer-avatar me-3">' +
                            (customer.custName ? customer.custName.charAt(0).toUpperCase() : '?') +
                        '</div>' +
                        '<div class="flex-grow-1">' +
                            '<div class="d-flex justify-content-between align-items-start mb-2">' +
                                '<h6 class="text-primary fw-semibold mb-0">' + (customer.custName || 'N/A') + '</h6>' +
                                '<a href="' + contextPath + '/company/update-customer/' + customer.id + '" ' +
                                   'class="text-primary" title="Edit Customer">' +
                                    '<i class="fas fa-edit"></i>' +
                                '</a>' +
                            '</div>' +

                            '<div class="text-muted small mb-2">' +
                                '<i class="fas fa-map-marker-alt me-1"></i>' + (customer.address || 'No address') +
                            '</div>' +

                            '<div class="text-muted small mb-3">' +
                                '<a href="https://wa.me/' + (customer.phoneNo || '') + '" ' +
                                   'target="_blank" class="text-success text-decoration-none">' +
                                    '<i class="fab fa-whatsapp me-1"></i>' + (customer.phoneNo || 'N/A') +
                                '</a>' +
                            '</div>' +

                            '<div class="d-flex gap-1 mb-3 flex-wrap">' +
                                '<span class="badge bg-primary badge-modern">Total ₹' + (customer.totalAmount || 0) + '</span>' +
                                '<span class="badge bg-success badge-modern">Paid ₹' + (customer.paidAmout || 0) + '</span>' +
                                '<span class="badge bg-danger badge-modern">Bal ₹' + (customer.currentOusting || 0) + '</span>' +
                            '</div>' +

                            '<div class="d-flex gap-2 flex-wrap">' +
                                '<form method="get" action="' + contextPath + '/company/get-cust-by-id" class="flex-fill">' +
                                    '<input type="hidden" name="custid" value="' + customer.id + '" />' +
                                    '<button class="btn btn-outline-primary btn-sm btn-modern w-100" type="submit">' +
                                        '<i class="fas fa-file-invoice me-1"></i>Invoice' +
                                    '</button>' +
                                '</form>' +

                                '<form method="get" action="' + contextPath + '/company/get-bal-credit-page/' + customer.id + '" class="flex-fill">' +
                                    '<button class="btn btn-outline-success btn-sm btn-modern w-100" type="submit">' +
                                        '<i class="fas fa-donate me-1"></i>Deposit' +
                                    '</button>' +
                                '</form>' +

                                '<form method="get" action="' + contextPath + '/company/cust-history" target="_blank" class="flex-fill">' +
                                    '<input type="hidden" name="custid" value="' + customer.id + '" />' +
                                    '<button class="btn btn-outline-warning btn-sm btn-modern w-100" type="submit">' +
                                        '<i class="fas fa-list-ol me-1"></i>History' +
                                    '</button>' +
                                '</form>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';
    });

    customerList.innerHTML = html;
}


const searchBtn = document.getElementById("searchBtn");
    const searchInput = document.getElementById("searchInput");
    const cardContainer = document.getElementById("cardContainer");
    const paginationContainer = document.getElementById("paginationContainer");
    let debounceTimer;

const contextPath = "${pageContext.request.contextPath}";

// Updated search button handler
searchBtn.addEventListener("click", () => {
    const query = searchInput.value.trim();
    const containerId = 'customerList';

    if (!query) {
        location.href = contextPath + '/login/home';
        return;
    }

    if (query.length < 2) {
        alert('Please enter at least 2 characters to search');
        return;
    }

    showBlockLoader(containerId);

    clearTimeout(debounceTimer);

    debounceTimer = setTimeout(() => {
        fetch(contextPath + '/company/search?query=' + encodeURIComponent(query))
            .then(res => {
                if (!res.ok) {
                    throw new Error('Network response was not ok');
                }
                return res.json();
            })
            .then(data => {
                console.log('Search results:', data); // Debug log
                renderCards(data);

                // Hide pagination if it exists
                const paginationContainer = document.getElementById("paginationContainer");
                if (paginationContainer) {
                    paginationContainer.style.display = 'none';
                }
            })
            .catch(error => {
                console.error("Error fetching customers:", error);
                document.getElementById('customerList').innerHTML = `
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Error loading search results. Please try again.
                    </div>
                `;
            })
            .finally(() => {
                hideBlockLoader(containerId);
            });
    }, 300);
});

// Also add Enter key support for search input
searchInput.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        searchBtn.click();
    }
});


    function showBlockLoader(containerId) {
        const container = document.getElementById(containerId);
        if (container && !container.querySelector('.block-loader')) {
            const loader = document.createElement('div');
            loader.className = 'block-loader';
            loader.innerHTML = '<div class="spinner"></div>';
            container.appendChild(loader);
        }
    }

    function hideBlockLoader(containerId) {
        const container = document.getElementById(containerId);
        const loader = container ? container.querySelector('.block-loader') : null;
        if (loader) {
            loader.remove();
        }
    }

</script>
</body>
</html>