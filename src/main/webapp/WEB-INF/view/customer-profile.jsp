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

                <!-- Success Alert -->
                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert" id="success-alert">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Page Header -->
                <div class="mb-4">
                    <h2 class="mb-1">Customer Profile</h2>
                    <p class="text-muted mb-0">View and manage customer details</p>
                </div>

                <!-- Customer Info Card -->
                <div class="card card-modern shadow-sm mb-4">
                    <div class="card-body p-4">
                        <div class="row g-4">
                            <div class="col-md-3">
                                <div class="section-heading">Customer Name</div>
                                <div class="section-value">
                                    <i class="fas fa-user me-2 text-primary"></i>${profile.custName}
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="section-heading">WhatsApp Number</div>
                                <div class="section-value">
                                    <i class="bi bi-whatsapp text-success me-2"></i>${profile.phoneNo}
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="section-heading">Address</div>
                                <div class="section-value">
                                    <i class="bi bi-geo-alt-fill text-danger me-2"></i>${profile.address}
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="section-heading">Financial Year</div>
                                <div class="highlight">${financialYear}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- KPI Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="kpi text-center">
                            <div class="card-body p-4">
                                <h6 class="text-muted">Total Amount</h6>
                                <h3 class="fw-bold text-primary mb-0">
                                    ₹<fmt:formatNumber value="${profile.totalAmount}" type="number" minFractionDigits="2"/>
                                </h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="kpi text-center">
                            <div class="card-body p-4">
                                <h6 class="text-muted">Paid Amount</h6>
                                <h3 class="fw-bold text-success mb-0">
                                    ₹<fmt:formatNumber value="${profile.paidAmout}" type="number" minFractionDigits="2"/>
                                </h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="kpi text-center">
                            <div class="card-body p-4">
                                <h6 class="text-muted">Balance Amount</h6>
                                <h3 class="fw-bold text-danger mb-0">
                                    ₹<fmt:formatNumber value="${profile.currentOusting}" type="number" minFractionDigits="2"/>
                                </h3>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Update Customer Form -->
                <div class="card card-modern">
                    <div class="card-header">
                        <i class="fas fa-edit me-2"></i>Update Customer Details
                    </div>
                    <div class="card-body p-4">
                        <form name="my-form" modelAttribute="CustProfile"
                              action="${pageContext.request.contextPath}/login/update-profile-details"
                              method="POST" novalidate>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="full_name" class="form-label">
                                        <i class="fas fa-user me-2"></i>Full Name
                                    </label>
                                    <input type="text" id="full_name" class="form-control"
                                           value="${profile.custName}" name="custName"
                                           placeholder="Enter full name" required />
                                </div>

                                <div class="col-md-6">
                                    <label for="phoneNo" class="form-label">
                                        <i class="fas fa-phone me-2"></i>Phone Number
                                    </label>
                                    <input type="tel" id="phoneNo" name="phoneNo"
                                           value="${profile.phoneNo}" class="form-control"
                                           pattern="[0-9]{10}" placeholder="10-digit number"
                                           title="Please enter a 10 digit phone number" required />
                                </div>

                                <div class="col-md-6">
                                    <label for="email_address" class="form-label">
                                        <i class="fas fa-envelope me-2"></i>Email Address
                                    </label>
                                    <input type="email" id="email_address" class="form-control"
                                           value="${profile.email}" name="email"
                                           placeholder="example@mail.com" required />
                                </div>

                                <div class="col-md-6">
                                    <label for="addharNo" class="form-label">
                                        <i class="fas fa-id-card me-2"></i>Aadhaar Number
                                    </label>
                                    <input type="text" id="addharNo" pattern="\d{12}"
                                           title="Please enter a valid 12-digit Aadhaar number"
                                           minlength="12" maxlength="12" name="addharNo"
                                           value="${profile.addharNo}" class="form-control"
                                           placeholder="12-digit Aadhaar" required />
                                </div>

                                <div class="col-12">
                                    <label for="address" class="form-label">
                                        <i class="fas fa-map-marker-alt me-2"></i>Address
                                    </label>
                                    <input type="text" id="address" class="form-control"
                                           value="${profile.address}" name="address"
                                           placeholder="Enter complete address" required />
                                </div>
                            </div>

                            <!-- Hidden Fields -->
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <input type="hidden" name="id" value="${profile.id}" />

                            <div class="d-flex justify-content-end gap-2 mt-4">
                                <button type="submit" name="action" value="update" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Update Details
                                </button>
                                <button type="submit" name="action" value="delete" class="btn btn-danger"
                                        onclick="return confirm('Are you sure you want to delete this customer? This action cannot be undone.');">
                                    <i class="fas fa-trash me-2"></i>Delete Customer
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Success Toast -->
            <c:if test="${not empty msg}">
                <div class="alert alert-success alert-dismissible fade show shadow-soft border-0" role="alert" id="success-alert">
                    <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <script>
                    window.addEventListener('load',()=>{
                        setTimeout(()=>{
                            const el=document.getElementById('success-alert');
                            if(el){ bootstrap.Alert.getOrCreateInstance(el).close(); }
                        }, 3500);
                    });
                </script>
            </c:if>
        </main>
    </div>
</div>

<!-- Logout form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/timeout.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>

</body>
</html>
