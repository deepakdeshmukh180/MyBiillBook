<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dealers - My Bill Book</title>

    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>

    <style>
        :root { --brand:#0d6efd; --soft:#f4f6f9; --ink:#33475b; }
        body { background:var(--soft); }
        .brand-gradient { background:linear-gradient(135deg,#3c7bff,#70a1ff); }
        .card-modern { border:0; border-radius:18px; box-shadow:0 8px 22px rgba(0,0,0,.08); }
        .section-title { font-weight:700; color:var(--ink); margin-bottom:.8rem; }
        .dealer-card { border-radius:18px; transition:.3s; }
        .dealer-card:hover { transform:translateY(-4px); box-shadow:0 6px 18px rgba(0,0,0,.1); }
        .empty-state { text-align:center; padding:3rem; color:#6c757d; }
        .empty-state i { font-size:3rem; margin-bottom:1rem; }
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
    <div id="layoutSidenav_nav">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp"/>
    </div>

    <!-- Main -->
    <div id="layoutSidenav_content">
        <main class="container py-4">
            <div class="row g-4">

                <!-- Dealer Form -->
                <div class="col-md-3">
                    <div class="card card-modern">
                        <div class="card-header bg-primary text-white fw-bold">
                            ${not empty dealer.id ? 'Update Dealer' : 'Add Dealer'}
                        </div>
                        <div class="card-body">
                            <form:form method="POST" modelAttribute="dealer" action="${pageContext.request.contextPath}/dealers/save">
                                <form:errors path="*" cssClass="alert alert-danger" element="div"/>
                                <form:input path="id" type="hidden"/>

                                <div class="mb-3">
                                    <label>Dealer Name</label>
                                    <form:input path="dealerName" cssClass="form-control" placeholder="Enter name"/>
                                </div>
                                <div class="mb-3">
                                    <label>Address</label>
                                    <form:input path="dealerAddress" cssClass="form-control" placeholder="Enter address"/>
                                </div>
                                <div class="mb-3">
                                    <label>Mobile No</label>
                                    <form:input path="mobileNo" cssClass="form-control" placeholder="Enter mobile"/>
                                </div>
                                <div class="mb-3">
                                    <label>GST No</label>
                                    <form:input path="gstNo" cssClass="form-control" placeholder="Enter GST"/>
                                </div>
                                <div class="mb-3">
                                    <label>Balance Amount</label>
                                    <form:input path="balanceAmount" type="number" readonly="${not empty dealer.id}" cssClass="form-control"/>
                                </div>

                                <h6 class="text-muted mt-3">Bank Details</h6>
                                <div class="mb-2"><label>Bank Name</label><form:input path="bankName" cssClass="form-control"/></div>
                                <div class="mb-2"><label>Account No</label><form:input path="accountNo" cssClass="form-control"/></div>
                                <div class="mb-2"><label>IFSC Code</label><form:input path="ifscCode" cssClass="form-control"/></div>
                                <div class="mb-2"><label>Branch Name</label><form:input path="branchName" cssClass="form-control"/></div>

                                <div class="d-grid mt-3">
                                    <button type="submit" class="btn btn-success">
                                        ${not empty dealer.id ? 'Update' : 'Save'}
                                    </button>
                                </div>
                            </form:form>
                        </div>
                    </div>
                </div>

                <!-- Dealer Table -->
                <div class="col-md-9">
                    <div class="card card-modern mb-4">
                        <div class="card-header bg-primary text-white fw-bold">Dealer List</div>
                        <div class="card-body table-responsive">
                            <table id="dealerTable" class="table table-bordered table-hover align-middle">
                                <thead class="table-dark text-center">
                                <tr>
                                    <th>Name</th>
                                    <th>Contact</th>
                                    <th>GST</th>
                                    <th>Bank</th>
                                    <th>Total</th>
                                    <th>Paid</th>
                                    <th>Balance</th>
                                    <th>Actions</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${dealers}" var="dealer">
                                    <tr>
                                        <td>${dealer.dealerName}</td>
                                        <td>${dealer.mobileNo}<br/><small>${dealer.dealerAddress}</small></td>
                                        <td>${dealer.gstNo}</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-info toggle-bank">Show</button>
                                            <div class="bank-details d-none small mt-1 text-start">
                                                <strong>${dealer.bankName}</strong><br/>
                                                A/C: ${dealer.accountNo}<br/>
                                                IFSC: ${dealer.ifscCode}<br/>
                                                Branch: ${dealer.branchName}
                                            </div>
                                        </td>
                                        <td class="text-end fw-bold text-primary">₹${dealer.totalAmount}</td>
                                        <td class="text-end fw-bold text-success">₹${dealer.paidAmount}</td>
                                        <td class="text-end fw-bold text-danger">₹${dealer.balanceAmount}</td>
                                        <td class="text-center">
                                            <a class="btn btn-sm btn-primary mb-1" href="${pageContext.request.contextPath}/dealers/update-dealer/${dealer.id}">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form method="get" action="${pageContext.request.contextPath}/dealers/view-dealer/${dealer.id}" class="d-inline">
                                                <input type="text" name="billNo" class="form-control form-control-sm mb-1" placeholder="Bill No" required/>
                                                <button class="btn btn-sm btn-outline-secondary" type="submit"><i class="fas fa-eye"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Dealer Cards -->
                    <div class="card card-modern">
                        <div class="card-header bg-primary text-white fw-bold d-flex justify-content-between align-items-center">
                            Dealer Cards
                            <div>
                                <input id="dealerSearch" class="form-control form-control-sm d-inline w-auto" placeholder="Search..."/>
                                <select id="balanceFilter" class="form-select form-select-sm d-inline w-auto">
                                    <option value="all">All</option>
                                    <option value="positive">Balance > 0</option>
                                    <option value="zero">Balance = 0</option>
                                </select>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row g-3" id="dealerCards">
                                <c:forEach items="${dealers}" var="dealer">
                                    <div class="col-md-4 dealer-card-wrapper" data-name="${dealer.dealerName}" data-balance="${dealer.balanceAmount}">
                                        <div class="card dealer-card p-3 h-100">
                                            <h5>${dealer.dealerName}</h5>
                                            <p class="mb-1"><i class="fa fa-phone me-1"></i>${dealer.mobileNo}</p>
                                            <p class="mb-1"><i class="fa fa-map-marker me-1"></i>${dealer.dealerAddress}</p>
                                            <p class="fw-bold text-danger">Balance: ₹${dealer.balanceAmount}</p>
                                            <a href="${pageContext.request.contextPath}/dealers/update-dealer/${dealer.id}" class="btn btn-sm btn-primary">Edit</a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <div id="emptyState" class="empty-state d-none">
                                <i class="fa fa-box-open"></i>
                                <p>No dealers found</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Success Alert -->
            <c:if test="${not empty msg}">
                <div class="alert alert-success alert-dismissible fade show mt-3" id="success-alert">
                    <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
        </main>
    </div>
</div>

<!-- Logout -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
$(document).ready(function(){

    // Success Alert Auto-close
    setTimeout(()=>{ $('#success-alert').alert('close'); },3500);

    // Toggle bank details
    $(document).on('click','.toggle-bank',function(){
        $(this).siblings('.bank-details').toggleClass('d-none');
        $(this).text($(this).text()==='Show'?'Hide':'Show');
    });

    // DataTable
    $('#dealerTable').DataTable({ pageLength:5, order:[[0,'asc']] });

    // Card Search & Filter
    function filterCards(){
        const search=$("#dealerSearch").val().toLowerCase();
        const filter=$("#balanceFilter").val();
        let visible=0;
        $("#dealerCards .dealer-card-wrapper").each(function(){
            const name=$(this).data("name").toLowerCase();
            const balance=parseFloat($(this).data("balance"))||0;
            let show=name.includes(search);
            if(filter==="positive") show=show && balance>0;
            if(filter==="zero") show=show && balance===0;
            $(this).toggle(show);
            if(show) visible++;
        });
        $("#emptyState").toggleClass("d-none",visible>0);
    }
    $("#dealerSearch, #balanceFilter").on("input change",filterCards);

});
</script>
</body>
</html>
