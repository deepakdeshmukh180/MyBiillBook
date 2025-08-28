<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Dealer Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

  <!-- Font Awesome -->
  <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>

  <!-- jQuery -->
  <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

  <!-- DataTables -->
  <link href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css" rel="stylesheet" />
  <link href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.dataTables.min.css" rel="stylesheet" />
  <link href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css" rel="stylesheet" />

  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
  <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
  <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>
  <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
</head>

<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/login/home">
      My <i class="fa fa-calculator text-danger"></i> Bill Book
    </a>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <form class="d-flex me-3">
        <input class="form-control me-2" type="search" placeholder="Search..." />
        <button class="btn btn-outline-light" type="submit"><i class="fas fa-search"></i></button>
      </form>
      <ul class="navbar-nav">
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown"><i class="fas fa-user fa-fw"></i></a>
          <ul class="dropdown-menu dropdown-menu-end">
            <li><hr class="dropdown-divider" /></li>
            <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>

<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
</form>

<div class="container-fluid">
  <div class="row">

    <!-- Dealer Form -->
    <div class="col-md-3 mb-4">
      <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
          ${not empty dealer.id ? 'Update Dealer' : 'Add Dealer'}
        </div>
        <div class="card-body">
          <form:form method="POST" modelAttribute="dealer" action="${pageContext.request.contextPath}/dealers/save">
            <form:errors path="*" cssClass="alert alert-danger" element="div" />
            <form:input path="id" type="hidden" />

            <div class="mb-3">
              <label>Dealer Name</label>
              <form:input path="dealerName" cssClass="form-control" placeholder="Enter name" />
            </div>

            <div class="mb-3">
              <label>Address</label>
              <form:input path="dealerAddress" cssClass="form-control" placeholder="Enter address" />
            </div>

            <div class="mb-3">
              <label>Mobile No</label>
              <form:input path="mobileNo" cssClass="form-control" placeholder="Enter mobile number" />
            </div>

            <div class="mb-3">
              <label>GST No</label>
              <form:input path="gstNo" cssClass="form-control" placeholder="Enter GST number" />
            </div>

            <div class="mb-3">
              <label>Balance Amount</label>
              <form:input path="balanceAmount" type="number" readonly="${not empty dealer.id}" cssClass="form-control" />
            </div>

            <h6 class="text-muted">Bank Details</h6>
            <div class="mb-3">
              <label>Bank Name</label>
              <form:input path="bankName" cssClass="form-control" />
            </div>
            <div class="mb-3">
              <label>Account No</label>
              <form:input path="accountNo" cssClass="form-control" />
            </div>
            <div class="mb-3">
              <label>IFSC Code</label>
              <form:input path="ifscCode" cssClass="form-control" />
            </div>
            <div class="mb-3">
              <label>Branch Name</label>
              <form:input path="branchName" cssClass="form-control" />
            </div>

            <div class="d-grid">
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
      <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
          Dealer List
        </div>
        <div class="card-body table-responsive">
          <table id="dealerTable" class="table table-bordered table-hover align-middle display nowrap">
            <thead class="table-dark text-center">
              <tr>
                <th>Name</th>
                <th>Contact</th>
                <th>GST</th>
                <th>Bank Details</th>
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
                  <td>
                    ${dealer.mobileNo}<br />
                    <small>${dealer.dealerAddress}</small>
                  </td>
                  <td>${dealer.gstNo}</td>
                  <td>
                    <button class="btn btn-sm btn-outline-info toggle-bank" type="button">Show</button>
                    <div class="bank-details d-none mt-2 text-start small">
                      <strong>${dealer.bankName}</strong><br/>
                      A/C: ${dealer.accountNo}<br/>
                      IFSC: ${dealer.ifscCode}<br/>
                      Branch: ${dealer.branchName}
                    </div>
                  </td>
                  <td class="text-end text-primary fw-bold">₹${dealer.totalAmount}</td>
                  <td class="text-end text-success fw-bold">₹${dealer.paidAmount}</td>
                  <td class="text-end text-danger fw-bold">₹${dealer.balanceAmount}</td>
                  <td class="text-center">
                    <a class="btn btn-sm btn-primary mb-1" href="${pageContext.request.contextPath}/dealers/update-dealer/${dealer.id}" title="Edit Dealer">
                      <i class="fas fa-edit"></i>
                    </a>
                    <form method="get" action="${pageContext.request.contextPath}/dealers/view-dealer/${dealer.id}" class="d-inline">
                      <input type="text" name="billNo" class="form-control form-control-sm mb-1" placeholder="Bill No" required />
                      <button class="btn btn-sm btn-outline-secondary" type="submit" title="View Bill">
                        <i class="fas fa-eye"></i>
                      </button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>

  </div>
</div>

<!-- Bootstrap Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Init DataTable -->
<script>
  $(document).ready(function () {
    $('#dealerTable').DataTable({
      responsive: true,
      paging: true,
      searching: true,
      ordering: true,
      info: false,
      dom: 'Bfrtip',
      buttons: ['excel', 'pdf', 'print']
    });

    // Toggle bank details
    $('.toggle-bank').on('click', function () {
      var $details = $(this).siblings('.bank-details');
      $details.toggleClass('d-none');
      $(this).text($details.hasClass('d-none') ? 'Show' : 'Hide');
    });
  });
</script>

</body>
</html>
