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
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
:root{
    --brand:#0d6efd;
    --soft:#f4f6f9;
    --ink:#33475b;
}
body{ background: var(--soft); }
.badge-total {
  background-color: #0d6efd; /* Bootstrap primary blue */
  color: white;
  font-weight: 600;
  padding: 0.35em 0.65em;
  border-radius: 12px;
  font-size: 0.9rem;
}

.badge-paid {
  background-color: #198754; /* Bootstrap success green */
  color: white;
  font-weight: 600;
  padding: 0.35em 0.65em;
  border-radius: 12px;
  font-size: 0.9rem;
}

.badge-balance {
  background-color: #dc3545; /* Bootstrap danger red */
  color: white;
  font-weight: 600;
  padding: 0.35em 0.65em;
  border-radius: 12px;
  font-size: 0.9rem;
}

/* Top Navbar Gradient */
.sb-topnav { background: linear-gradient(135deg, #3c7bff, #70a1ff); border-bottom: 1px solid rgba(255,255,255,.08); }

/* Card design */
.card-modern{ border:0; border-radius:18px; box-shadow:0 8px 22px rgba(0,0,0,.08); }
.card-header{ background: linear-gradient(135deg,#3c7bff,#70a1ff); color:#fff; font-weight:bold; border-top-left-radius:18px; border-top-right-radius:18px; }

/* KPI card style */
.kpi{ border-radius:14px; box-shadow:0 6px 18px rgba(0,0,0,.08); padding:12px; transition:.2s; }
.kpi:hover{ transform: translateY(-4px); }
.kpi .icon{ font-size:1.5rem; }

/* Expense item */
.expense-item{ border-radius:14px; border:1px dashed #d8e2ff; background:#fff; transition:.2s; }
.expense-item:hover{ transform:scale(1.01); background:#f8fbff; }
</style>
</head>
<body class="sb-nav-fixed">

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark">
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports"><i class="fas fa-chart-line me-2 text-white"></i>Reports</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products"><i class="fas fa-leaf me-2 text-white"></i>Products</a>
                        </nav>
                    </div>
                    <div class="sb-sidenav-menu-heading">Addons</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
                        <div class="sb-nav-link-icon"><i class="fas fa-user-circle"></i></div> My Profile
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/export-to-pdf">
                        <div class="sb-nav-link-icon"><i class="fas fa-file-export"></i></div> Export Customers
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/expenses">
                        <div class="sb-nav-link-icon"><i class="fas fa-file-export"></i></div> Daily Expenses
                    </a>
                </div>
            </div>
        </nav>
    </div>

    <div id="layoutSidenav_content">
        <main class="container-fluid px-3 mt-4 mb-5">

            <!-- Top cards row -->
            <div class="row mb-4 g-3">
                <!-- Total Customers Card -->
                <div class="row mb-4 g-3">
                    <!-- Total Customers Card -->
                    <div class="col-md-3">
                        <div class="card-modern p-2 d-flex align-items-center justify-content-between">
                            <div class="text-primary d-flex align-items-center gap-2">
                                <i class="fas fa-users fa-lg"></i>
                                <strong>Total Customers:</strong>
                            </div>
                            <div class="fw-bold fs-5">${totalcustomers}</div>
                        </div>
                    </div>

                    <!-- Search Card -->
                    <div class="col-md-6">
                        <div class="card-modern p-2 d-flex align-items-center">
                            <input id="searchInput" class="form-control form-control-sm w-100" placeholder="Search by Customer Name" autocomplete="off" />
                        </div>
                    </div>
                </div>

            </div>

            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div><i class="fas fa-users me-2"></i><strong>My Customers</strong></div>
                </div>

                <div class="card-body table-responsive">
                    <table class="table table-hover text-center align-middle" id="customerTable">
                        <thead class="table-light">
                            <tr>
                                <th>Edit</th>
                                <th>Name</th>
                                <th>Address</th>
                                <th>Contact</th>
                                <th>Total</th>
                                <th>Paid</th>
                                <th>Balance</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="customerTableBody">
                            <c:forEach items="${custmers}" var="custmer">
                                <tr>
                                    <td><a href="${pageContext.request.contextPath}/company/update-customer/${custmer.id}" class="text-primary"><i class="fas fa-edit"></i></a></td>
                                    <td style="text-align: left;"><strong>${custmer.custName}</strong></td>
                                    <td style="text-align: left;">${custmer.address}</td>
                                    <td><a href="https://wa.me/${custmer.phoneNo}" target="_blank"><i class="fab fa-whatsapp text-success"></i> ${custmer.phoneNo}</a></td>
                                    <td style="text-align: right;"><span class="badge badge-total">&#8377; ${custmer.totalAmount}</span></td>
                                    <td style="text-align: right;"><span class="badge badge-paid ">&#8377; ${custmer.paidAmout}</span></td>
                                    <td style="text-align: right;"><span class="badge badge-balance">&#8377; ${custmer.currentOusting}</span></td>
                                    <td>
                                        <div class="dropdown">
                                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown"><i class="fas fa-bars"></i></button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                                <li>
                                                    <form method="get" action="${pageContext.request.contextPath}/company/get-cust-by-id">
                                                        <input type="hidden" name="custid" value="${custmer.id}" />
                                                        <button class="dropdown-item" type="submit"><i class="fas fa-file-invoice me-2 text-primary"></i>Invoice</button>
                                                    </form>
                                                </li>
                                                <li>
                                                    <form method="get" action="${pageContext.request.contextPath}/company/get-bal-credit-page/${custmer.id}">
                                                        <button class="dropdown-item" type="submit"><i class="fas fa-donate me-2 text-success"></i>Deposit</button>
                                                    </form>
                                                </li>
                                                <li>
                                                    <form method="get" action="${pageContext.request.contextPath}/company/cust-history" target="_blank">
                                                        <input type="hidden" name="custid" value="${custmer.id}" />
                                                        <button class="dropdown-item" type="submit"><i class="fas fa-list-ol me-2 text-warning"></i>History</button>
                                                    </form>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div id="paginationContainer" class="d-flex justify-content-between align-items-center flex-wrap">
                        <c:if test="${totalPages > 0}">
                            <div class="text-muted">Page <strong>${page + 1}</strong> of <strong>${totalPages}</strong></div>
                            <nav>
                                <ul class="pagination pagination-sm mb-0">
                                    <c:if test="${page > 0}">
                                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${page - 1}">&laquo; Prev</a></li>
                                    </c:if>
                                    <c:forEach begin="${page - 2 < 0 ? 0 : page - 2}" end="${page + 2 >= totalPages ? totalPages - 1 : page + 2}" var="i">
                                        <li class="page-item ${page == i ? 'active' : ''}"><a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${i}">${i + 1}</a></li>
                                    </c:forEach>
                                    <c:if test="${page < totalPages - 1}">
                                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${page + 1}">Next &raquo;</a></li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>

        <footer class="py-3 bg-light mt-auto">
            <div class="container-fluid px-4">
                <div class="d-flex justify-content-between small text-muted">
                    <div>&copy; Your Website 2023</div>
                    <div><a href="#">Privacy Policy</a> · <a href="#">Terms &amp; Conditions</a></div>
                </div>
            </div>
        </footer>
    </div>
</div>

<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>


<script>
const contextPath = '${pageContext.request.contextPath}';
const searchInput = document.getElementById('searchInput');
const tbody = document.getElementById('customerTableBody');
const paginationContainer = document.getElementById('paginationContainer');
let debounceTimer;

searchInput.addEventListener('input', function () {
    const query = this.value.trim();
    clearTimeout(debounceTimer);

     if (!query) {
            location.href = contextPath + '/company/get-all-customers';
            return;
        }

    if (query.length < 3) {
        return;
    }

    debounceTimer = setTimeout(() => {
        fetch(contextPath + '/company/search?query=' + encodeURIComponent(query))
            .then(res => res.json())
            .then(data => {
                tbody.innerHTML = '';
                paginationContainer.style.display = 'none';

                if (!data || data.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" class="text-muted">No matching customers found.</td></tr>';
                    return;
                }

                data.forEach(custmer => {
                    const tr = document.createElement('tr');
                    tr.innerHTML =
                        '<td><a href="' + contextPath + '/company/update-customer/' + custmer.id + '" class="text-primary"><i class="fas fa-edit"></i></a></td>' +
                        '<td style="text-align: left;"><strong>' + custmer.custName + '</strong></td>' +
                        '<td style="text-align: left;">' + custmer.address + '</td>' +
                        '<td><a href="https://wa.me/' + custmer.phoneNo + '" target="_blank"><i class="fab fa-whatsapp text-success"></i> ' + custmer.phoneNo + '</a></td>' +
                        '<td style="text-align: right;"><span class="badge badge-total text-white">&#8377; ' + custmer.totalAmount + '</span></td>' +
                        '<td style="text-align: right;"><span class="badge badge-paid text-white">&#8377; ' + custmer.paidAmout + '</span></td>' +
                        '<td style="text-align: right;"><span class="badge badge-balance text-white">&#8377; ' + custmer.currentOusting + '</span></td>' +
                        '<td><div class="dropdown">' +
                        '<button class="btn btn-sm btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown"><i class="fas fa-bars"></i></button>' +
                        '<ul class="dropdown-menu dropdown-menu-end shadow-sm">' +
                        '<li><form method="get" action="' + contextPath + '/company/get-cust-by-id">' +
                        '<input type="hidden" name="custid" value="' + custmer.id + '" />' +
                        '<button class="dropdown-item" type="submit"><i class="fas fa-file-invoice me-2 text-primary"></i>Invoice</button></form></li>' +
                        '<li><form method="get" action="' + contextPath + '/company/get-bal-credit-page/' + custmer.id + '">' +
                        '<button class="dropdown-item" type="submit"><i class="fas fa-donate me-2 text-success"></i>Deposit</button></form></li>' +
                        '<li><form method="get" action="' + contextPath + '/company/cust-history" target="_blank">' +
                        '<input type="hidden" name="custid" value="' + custmer.id + '" />' +
                        '<button class="dropdown-item" type="submit"><i class="fas fa-list-ol me-2 text-warning"></i>History</button></form></li>' +
                        '</ul></div></td>';
                    tbody.appendChild(tr);
                });
            });
    }, 300);
});

function resetSearch() {
    searchInput.value = '';
    paginationContainer.style.display = 'flex';
    location.href = contextPath + '/company/get-all-customers';
}

document.getElementById('sidebarToggle').addEventListener('click', function () {
    document.body.classList.toggle('sb-sidenav-toggled');
});

</script>

<!-- Bootstrap and dependencies -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/simple-datatables.min.js"></script>
</body>
</html>
