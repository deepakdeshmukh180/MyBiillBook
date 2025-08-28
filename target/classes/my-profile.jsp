<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dashboard - My Bill Book</title>

    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>

    <style>
        :root{ --brand:#0d6efd; --soft:#f4f6f9; --ink:#33475b; }
        body{ background:var(--soft); }
        .brand-gradient{ background:linear-gradient(135deg,#3c7bff,#70a1ff); }
        .glass{ backdrop-filter:blur(6px); background:rgba(255,255,255,.7); border:1px solid rgba(255,255,255,.4); }
        .card-modern{ border:0; border-radius:18px; box-shadow:0 8px 22px rgba(0,0,0,.08); }
        .section-title{ font-weight:700; color:var(--ink); }
        .nav-pills .nav-link.active{ background:var(--brand); }
        .form-section{ padding:1rem; }
    </style>
</head>
<body class="sb-nav-fixed">

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark brand-gradient">
    <a class="navbar-brand ps-3 fw-bold" href="${pageContext.request.contextPath}/login/home">
        My <i class="fa fa-calculator text-warning"></i> Bill Book
    </a>
    <button class="btn btn-outline-light btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>
    <div class="ms-auto d-flex align-items-center gap-3 pe-3">
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

<div class="container-fluid px-4 mt-4">
    <div class="card card-modern glass p-4">
        <h4 class="section-title mb-3">Owner Profile Detail</h4>

        <!-- Nav Pills -->
        <ul class="nav nav-pills mb-3" id="profileTabs" role="tablist">
            <li class="nav-item"><button class="nav-link active" data-bs-toggle="pill" data-bs-target="#basic" type="button">Basic Info</button></li>
            <li class="nav-item"><button class="nav-link" data-bs-toggle="pill" data-bs-target="#shop" type="button">Shop Info</button></li>
            <li class="nav-item"><button class="nav-link" data-bs-toggle="pill" data-bs-target="#business" type="button">Business Info</button></li>
            <li class="nav-item"><button class="nav-link" data-bs-toggle="pill" data-bs-target="#payment" type="button">Payment & Status</button></li>
        </ul>

        <!-- Form -->
        <form name="my-form" action="${pageContext.request.contextPath}/company/update-owner-details" method="POST">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="ownerId" value="${ownerInfo.ownerId}"/>

            <div class="tab-content">
                <!-- Basic Info -->
                <div class="tab-pane fade show active form-section" id="basic">
                    <div class="mb-3">
                        <label class="form-label">User Name</label>
                        <input type="text" readonly class="form-control" value="${ownerInfo.userName}" name="username"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Shop Name</label>
                        <input type="text" class="form-control" value="${ownerInfo.shopName}" name="shopName"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Shop Owner</label>
                        <input type="text" class="form-control" value="${ownerInfo.ownerName}" name="ownerName"/>
                    </div>
                </div>

                <!-- Shop Info -->
                <div class="tab-pane fade form-section" id="shop">
                    <div class="mb-3">
                        <label class="form-label">Shop Address</label>
                        <input type="text" class="form-control" value="${ownerInfo.address}" name="address"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone Number</label>
                        <input type="text" class="form-control" value="${ownerInfo.mobNumber}" name="mobNumber"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="text" class="form-control" value="${ownerInfo.email}" name="email"/>
                    </div>
                </div>

                <!-- Business Info -->
                <div class="tab-pane fade form-section" id="business">
                    <div class="mb-3">
                        <label class="form-label">GST</label>
                        <input type="text" class="form-control" value="${ownerInfo.gstNumber}" name="gstNumber"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">LC No.</label>
                        <input type="text" class="form-control" value="${ownerInfo.lcNo}" name="lcNo"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Plan Valid upto</label>
                        <input type="text" readonly class="form-control"
                               value="<fmt:formatDate value='${ownerInfo.expDate}' pattern='dd/MM/yyyy hh:mm a'/>"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Invoice Type</label>
                        <select name="invoiceType" class="form-control">
                            <option value="A4" ${ownerInfo.invoiceType == 'A4' ? 'selected' : ''}>A4-Page-size</option>
                            <option value="A0" ${ownerInfo.invoiceType == 'A0' ? 'selected' : ''}>4X6-Thermal</option>
                        </select>
                    </div>
                </div>

                <!-- Payment & Status -->
                <div class="tab-pane fade form-section" id="payment">
                    <div class="mb-3">
                        <label class="form-label">UPI ID</label>
                        <input type="text" class="form-control" value="${ownerInfo.upiId}" name="upiId"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <input type="text" readonly class="form-control" value="${ownerInfo.status}" name="status"/>
                    </div>
                </div>
            </div>

            <div class="mt-3">
                <button type="submit" class="btn btn-primary">Update</button>
            </div>
        </form>
    </div>

    <!-- Success Alert -->
    <c:if test="${not empty msg}">
        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert" id="success-alert">
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
</body>
</html>
