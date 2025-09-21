<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dashboard - My Bill Book</title>

    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>

    <!-- JS (head) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root{ --brand:#0d6efd; --soft:#f4f6f9; --ink:#2b3643; }
        body{ background:var(--soft); font-family: 'Segoe UI', system-ui, sans-serif; }
        .brand-gradient{ background:linear-gradient(135deg,#3c7bff,#70a1ff); }
        .kpi{ border:0; border-radius:18px; box-shadow:0 10px 24px rgba(0,0,0,.08); transition:.2s; }
        .kpi:hover{ transform:translateY(-4px); }
        .card-modern{ border:0; border-radius:18px; box-shadow:0 8px 22px rgba(0,0,0,.08); }
        .shadow-soft{ box-shadow:0 4px 14px rgba(0,0,0,.08); }
        .section-heading{ font-size:1rem; font-weight:600; color:#6c757d; margin-bottom:0.25rem; }
        .section-value{ font-size:1.15rem; font-weight:700; color:var(--ink); }
        .highlight{ font-size:1.2rem; font-weight:700; color:#0d6efd; }
    </style>
</head>
<body class="sb-nav-fixed">

<!-- Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark brand-gradient">
    <a class="navbar-brand ps-3 fw-bold" href="${pageContext.request.contextPath}/login/home">
        My <i class="fa fa-calculator text-warning"></i> Bill Book
    </a>
    <button class="btn btn-outline-light btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>

    <div class="ms-auto d-flex align-items-center gap-3 pe-3">
        <div class="position-relative" role="button" onclick="openModal()">
            <i class="bi bi-bell fs-5 text-white"></i>
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                ${productList.size()}
            </span>
        </div>
        <div class="dropdown">
            <a class="nav-link dropdown-toggle text-white" id="navbarDropdown" href="#" data-bs-toggle="dropdown">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div id="layoutSidenav">
    <!-- Sidebar -->
    <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
            <div class="sb-sidenav-menu">
                <div class="nav">
                    <div class="sb-sidenav-menu-heading">Core</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login/home">
                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div> Dashboard
                    </a>
                    <div class="sb-sidenav-menu-heading">Interface</div>
                    <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts">
                        <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div> Menu
                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                    </a>
                    <div class="collapse" id="collapseLayouts" data-bs-parent="#sidenavAccordion">
                        <nav class="sb-sidenav-menu-nested nav">
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers"><i class="fas fa-user-friends me-2 text-white"></i>All Customers</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices"><i class="fas fa-file-invoice me-2 text-white"></i>Invoices</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports"><i class="fas fa-chart-line me-2 text-white"></i>Daily/Monthly Reports</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products"><i class="fas fa-leaf me-2 text-white"></i>Products</a>
                        </nav>
                    </div>
                    <div class="sb-sidenav-menu-heading">Addons</div>
                     <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
                                                    <div class="sb-nav-link-icon"><i class="fa fa-gear fa-spin"></i></div> Account Settings
                                                  </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/export-to-pdf">
                        <div class="sb-nav-link-icon"><i class="fas fa-file-export"></i></div> Export Customers
                    </a>
                </div>
            </div>
            <div class="sb-sidenav-footer">
                <div class="small">Logged in as:</div>
                ${pageContext.request.userPrincipal.name}
            </div>
        </nav>
    </div>

    <!-- Main -->
    <div id="layoutSidenav_content">
        <main class="container-fluid px-4">
            <ol class="breadcrumb mb-4">
                <li class="breadcrumb-item active"></li>
            </ol>

            <!-- Customer Info Card -->
            <div class="card card-modern shadow-soft mb-4 p-3">
                <div class="row text-center text-md-start">
                    <div class="col-md-3 mb-3 mb-md-0">
                        <div class="section-heading">Customer Name</div>
                        <div class="section-value">${profile.custName}</div>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <div class="section-heading">WhatsApp No</div>
                        <div class="section-value">
                            <i class="bi bi-whatsapp text-success me-1"></i>${profile.phoneNo}
                        </div>
                    </div>
                    <div class="col-md-3 mb-3 mb-md-0">
                        <div class="section-heading">Address</div>
                        <div class="section-value">
                            <i class="bi bi-geo-alt-fill text-danger me-1"></i>${profile.address}
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="section-heading">Financial Year</div>
                        <div class="highlight">${financialYear}</div>
                    </div>
                </div>
            </div>

            <!-- KPI Cards Row -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="card kpi text-center p-3">
                        <div class="card-body">
                            <h6 class="text-muted">Total Amount</h6>
                            <h3 class="fw-bold text-primary">
                                ₹<fmt:formatNumber value="${profile.totalAmount}" type="number" minFractionDigits="2"/>
                            </h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card kpi text-center p-3">
                        <div class="card-body">
                            <h6 class="text-muted">Paid Amount</h6>
                            <h3 class="fw-bold text-success">
                                ₹<fmt:formatNumber value="${profile.paidAmout}" type="number" minFractionDigits="2"/>
                            </h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card kpi text-center p-3">
                        <div class="card-body">
                            <h6 class="text-muted">Balance Amount</h6>
                            <h3 class="fw-bold text-danger">
                                ₹<fmt:formatNumber value="${profile.currentOusting}" type="number" minFractionDigits="2"/>
                            </h3>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Update Customer Form -->
            <div class="card card-modern mb-4">
                <div class="card-header fw-bold">Update Customer Detail</div>
                <div class="card-body">
                    <form name="my-form" modelAttribute="CustProfile"
                          action="${pageContext.request.contextPath}/login/update-profile-details" method="POST" novalidate>

                        <div class="row mb-3">
                            <label for="full_name" class="col-md-3 col-form-label">Full Name</label>
                            <div class="col-md-6">
                                <input type="text" id="full_name" class="form-control"
                                       value="${profile.custName}" name="custName" required />
                            </div>
                        </div>

                        <div class="row mb-3">
                            <label for="address" class="col-md-3 col-form-label">Address</label>
                            <div class="col-md-6">
                                <input type="text" id="address" class="form-control"
                                       value="${profile.address}" name="address" required />
                            </div>
                        </div>

                        <div class="row mb-3">
                            <label for="email_address" class="col-md-3 col-form-label">E-Mail</label>
                            <div class="col-md-6">
                                <input type="email" id="email_address" class="form-control"
                                       value="${profile.email}" name="email" required />
                            </div>
                        </div>

                        <div class="row mb-3">
                            <label for="phoneNo" class="col-md-3 col-form-label">Phone Number</label>
                            <div class="col-md-6">
                                <input type="tel" id="phoneNo" name="phoneNo"
                                       value="${profile.phoneNo}" class="form-control"
                                       pattern="[0-9]{10}" title="Please enter a 10 digit phone number" required />
                            </div>
                        </div>

                        <div class="row mb-3">
                            <label for="addharNo" class="col-md-3 col-form-label">Aadhaar Number</label>
                            <div class="col-md-6">
                                <input type="text" id="addharNo" pattern="\d{12}"
                                       title="Please enter a valid 12-digit Aadhaar number"
                                       minlength="12" maxlength="12" name="addharNo"
                                       value="${profile.addharNo}" class="form-control" required />
                            </div>
                        </div>

                        <!-- Hidden -->
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="id" value="${profile.id}" />

                        <div class="d-flex justify-content-end gap-2 mt-4">
                            <button type="submit" name="action" value="update" class="btn btn-primary">Update</button>
                            <button type="submit" name="action" value="delete" class="btn btn-danger"
                                    onclick="return confirm('Are you sure you want to delete this customer?');">Delete</button>
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
