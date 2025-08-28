<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Customers - My Bill Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"></script>
    <style>
        .card-header {
            background: linear-gradient(to right, #0d6efd, #6610f2);
            color: #fff;
            font-weight: bold;
            padding: 1rem;
        }
        #searchInput {
            border: 2px solid #0d6efd;
            border-radius: 20px;
            padding-left: 15px;
            width: 100%;
        }
        .badge-total { background-color: #0d6efd; }
        .badge-paid { background-color: #198754; }
        .badge-balance { background-color: #dc3545; }
    </style>
</head>
<body class="sb-nav-fixed">

<!-- Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
    <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">My <i class="fa fa-calculator text-danger"></i> Bill Book</a>
    <button class="btn btn-link btn-sm" id="sidebarToggle"><i class="fas fa-bars"></i></button>
    <ul class="navbar-nav ms-auto me-3 me-lg-4">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#"><i class="fas fa-user fa-fw"></i></a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="#" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
            </ul>
        </li>
    </ul>
</nav>

<div id="layoutSidenav">
    <div id="layoutSidenav_nav" class="d-none d-md-block">
        <!-- Sidebar -->
        <nav class="sb-sidenav accordion sb-sidenav-dark">
            <div class="sb-sidenav-menu">
                <div class="nav">
                    <div class="sb-sidenav-menu-heading">Core</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login/home">
                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div> Dashboard
                    </a>
                    <div class="sb-sidenav-menu-heading">Interface</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">All Customers</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">Invoice Search</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">Reports</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">Products</a>
                </div>
            </div>
        </nav>
    </div>

    <div id="layoutSidenav_content">
        <main class="container-fluid px-3 mt-4 mb-5">
            <div class="card mb-4">
                <div class="card-header d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                    <div>
                        <i class="fas fa-users me-2"></i><strong>My Customers</strong>
                        <span class="badge bg-light text-dark ms-3">Total: ${totalcustomers}</span>
                    </div>
                    <div class="d-flex flex-column flex-sm-row gap-2 w-100">
                        <input id="searchInput" class="form-control form-control-sm" placeholder="Search by Customer Name" autocomplete="off" />
                        <button class="btn btn-outline-secondary btn-sm" onclick="resetSearch()">Reset</button>
                    </div>
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
                                    <td style="text-align: right;"><span class="badge badge-total text-white">&#8377; ${custmer.totalAmount}</span></td>
                                    <td style="text-align: right;"><span class="badge badge-paid text-white">&#8377; ${custmer.paidAmout}</span></td>
                                    <td style="text-align: right;"><span class="badge badge-balance text-white">&#8377; ${custmer.currentOusting}</span></td>
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

    if (query.length < 2) {
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
                        '<td>' +
                            '<div class="dropdown">' +
                                '<button class="btn btn-sm btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown"><i class="fas fa-bars"></i></button>' +
                                '<ul class="dropdown-menu dropdown-menu-end shadow-sm">' +
                                    '<li><form method="get" action="' + contextPath + '/company/get-cust-by-id">' +
                                    '<input type="hidden" name="custid" value="' + custmer.id + '" />' +
                                    '<button class="dropdown-item" type="submit"><i class="fas fa-file-invoice me-2 text-primary"></i>Invoice</button>' +
                                    '</form></li>' +
                                    '<li><form method="get" action="' + contextPath + '/company/get-bal-credit-page/' + custmer.id + '">' +
                                    '<button class="dropdown-item" type="submit"><i class="fas fa-donate me-2 text-success"></i>Deposit</button>' +
                                    '</form></li>' +
                                    '<li><form method="get" action="' + contextPath + '/company/cust-history" target="_blank">' +
                                    '<input type="hidden" name="custid" value="' + custmer.id + '" />' +
                                    '<button class="dropdown-item" type="submit"><i class="fas fa-list-ol me-2 text-warning"></i>History</button>' +
                                    '</form></li>' +
                                '</ul>' +
                            '</div>' +
                        '</td>';
                    tbody.appendChild(tr);
                });
            })
            .catch(err => {
                console.error('Search error:', err);
            });
    }, 300);
});

function resetSearch() {
    searchInput.value = '';
    window.location.reload();
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
