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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - My Bill Book</title>

    <!-- Bootstrap & Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --brand: #0d6efd;
            --soft: #f4f6f9;
            --ink: #33475b;
        }
        body { background: var(--soft); }
        .brand-gradient { background: linear-gradient(135deg, #3c7bff, #70a1ff); }
        .kpi { border: 0; border-radius: 18px; box-shadow: 0 10px 24px rgba(0, 0, 0, .08); transition: .2s transform; overflow: hidden; }
        .kpi:hover { transform: translateY(-4px); }
        .section-title { font-weight: 700; color: var(--ink); }
        .card-modern { border: 0; border-radius: 18px; box-shadow: 0 8px 22px rgba(0, 0, 0, .08); }
        .expense-item { border-radius: 14px; border: 1px dashed #d8e2ff; background: #fff; transition: .2s; }
        .expense-item:hover { transform: scale(1.01); background: #f8fbff; }
        .rounded-18 { border-radius: 18px; }
        .shadow-soft { box-shadow: 0 4px 14px rgba(0, 0, 0, .08); }
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

<!-- Sidebar -->
<div id="layoutSidenav">
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">All Customers</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">Invoices</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">Reports</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">Products</a>
                        </nav>
                    </div>
                    <div class="sb-sidenav-menu-heading">Addons</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
                        <div class="sb-nav-link-icon"><i class="fas fa-user-circle"></i></div> My Profile
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

    <!-- Main Content -->
    <div id="layoutSidenav_content">
        <div class="container-fluid px-4">

            <!-- Invoice Summary Card -->
            <div class="card my-4 p-3 shadow-soft rounded-18">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0"><i class="fa fa-file-invoice-dollar me-2 text-primary"></i>Invoice Summary</h5>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered align-middle">
                        <thead class="table-success">
                        <tr>
                            <th>Customer Name</th>
                            <th>Address</th>
                            <th>Mob No.</th>
                            <th>Total Amt</th>
                            <th>Paid Amt</th>
                            <th>Balance Amt</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>Mr. ${profile.custName}</td>
                            <td>${profile.address}</td>
                            <td>${profile.phoneNo}</td>
                            <td><input type="text" readonly class="form-control text-end text-primary fw-bold" value="₹ ${profile.totalAmount}" /></td>
                            <td><input type="text" readonly class="form-control text-end text-success fw-bold" value="₹ ${profile.paidAmout}" /></td>
                            <td><input type="text" readonly class="form-control text-end text-danger fw-bold" value="₹ ${profile.currentOusting}" /></td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Deposit Form -->
                <form action="${pageContext.request.contextPath}/company/balance-credit" method="post" modelAttribute="BalanceDeposite">
                    <input type="hidden" name="custId" value="${profile.id}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                    <div class="row mt-3 g-3">
                        <div class="col-md-3">
                            <select required name="modeOfPayment" class="form-select">
                                <option value="">-- Payment Mode/Returns --</option>
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
                            <input type="text" name="description" class="form-control" placeholder="Description" />
                        </div>
                        <div class="col-md-2">
                            <input name="date" type="date" required class="form-control" />
                        </div>
                        <div class="col-md-2">
                            <input type="text" name="advAmt" required maxlength="7" class="form-control"
                                   placeholder="Deposit Amount"
                                   oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" />
                        </div>
                        <div class="col-md-2 d-grid">
                            <button type="submit" class="btn btn-success">Deposit</button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Invoice History Card -->
            <div class="card my-4 p-3 shadow-soft rounded-18">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0"><i class="fas fa-history me-2 text-secondary"></i>Invoice History</h5>
                </div>

                <div class="table-responsive">
                    <table id="datatablesSimple" class="table table-bordered table-striped">
                        <thead class="table-success">
                        <tr>
                            <th>Transaction ID</th>
                            <th>Customer Name</th>
                            <th>Description</th>
                            <th>Closing Amt</th>
                            <th>Payment Mode</th>
                            <th>Deposited Amt</th>
                            <th>Date</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${balanceDeposits}" var="balanceDeposit">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/company/get-bal-credit-receipt/${balanceDeposit.id}"
                                       target="_blank" class="text-decoration-none">
                                        <i class="fa fa-receipt"></i> ${balanceDeposit.id}
                                    </a>
                                </td>
                                <td>${balanceDeposit.custName}</td>
                                <td>${balanceDeposit.description}</td>
                                <td class="text-end">${balanceDeposit.currentOusting}</td>
                                <td>${balanceDeposit.modeOfPayment}</td>
                                <td class="text-end">${balanceDeposit.advAmt}</td>
                                <td>${balanceDeposit.date}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Success Toast -->
            <c:if test="${not empty msg}">
                <div class="alert alert-success alert-dismissible fade show shadow-soft border-0" role="alert" id="success-alert">
                    <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <script>
                    window.addEventListener('load', () => {
                        setTimeout(() => {
                            const el = document.getElementById('success-alert');
                            if (el) {
                                bootstrap.Alert.getOrCreateInstance(el).close();
                            }
                        }, 3500);
                    });
                </script>
            </c:if>

        </div>
    </div>
</div>

<!-- Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/timeout.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>

</body>
</html>
