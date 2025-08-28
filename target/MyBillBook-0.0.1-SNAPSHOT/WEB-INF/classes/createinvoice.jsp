<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html lang="en">
   <style>



      .collapsible {
      background-color: #777;
      color: white;
      cursor: pointer;
      padding: 18px;
      width: 100%;
      border: none;
      text-align: left;
      outline: none;
      font-size: 15px;
      }
      .active, .collapsible:hover {
      background-color: #555;
      }
      .content {
      padding: 0 18px;
      display: none;
      overflow: hidden;
      background-color: #f1f1f1;
      }
      .select2-container .select2-selection--single{
          height:34px !important;
      }
      .select2-container--default .select2-selection--single{
               border: 1px solid #ccc !important;
           border-radius: 0px !important;
      }
   </style>
   <head>
      <meta charset="utf-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
      <meta name="description" content="" />
      <meta name="author" content="" />
      <title>Tables - SB Admin</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
      <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
      <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
      <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>

<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<!------ Include the above in your HEAD tag ---------->

<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>



      <!------ Include the above in your HEAD tag ---------->





   </head>
   <body class="sb-nav-fixed">
   <div id="loader" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(255,255,255,0.7); z-index:9999; text-align:center; padding-top:200px;">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
      </div>
      <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
         <!-- Navbar Brand-->
                   <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">My <i class="fa fa-calculator" style="font-size:20px;color:red"></i> Bill Book</a>

         <!-- Sidebar Toggle-->
         <button class="btn btn-outline-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
         <!-- Navbar Search-->
         <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
            <div class="input-group">
               <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
               <button class="btn btn-outline-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
            </div>
         </form>
         <!-- Navbar-->
          <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
                         <li class="nav-item dropdown">
                             <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                             <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                              <li><hr class="dropdown-divider" /></li>
                                 <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()"">Logout</a></li>
                             </ul>
                         </li>
                     </ul>
      </nav>
      <div id="layoutSidenav">
         <div id="layoutSidenav_nav">
            <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
               <div class="sb-sidenav-menu">
                  <div class="nav">
                     <div class="sb-sidenav-menu-heading">Core</div>
                     <a class="nav-link" href="${pageContext.request.contextPath}/login/home">
                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                        Dashboard
                     </a>
                     <div class="sb-sidenav-menu-heading">Interface</div>
                     <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                        <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>
                        Menu
                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                     </a>
                     <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
                        <nav class="sb-sidenav-menu-nested nav">
                           <a class="nav-link" href="${pageContext.request.contextPath}/company/get-bal-credit-page/${profile.id}">Deposit Amount</a>
                           <a class="nav-link" href="${pageContext.request.contextPath}/company/update-customer/${profile.id}">Update Profile</a>
                           <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">All Customers </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">Invoice Search</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">Reports</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">Products</a>

                        </nav>
                     </div>
                     <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages" aria-expanded="false" aria-controls="collapsePages">
                        <div class="sb-nav-link-icon"><i class="fas fa-book-open"></i></div>
                        Pages
                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                     </a>
                     <div class="collapse" id="collapsePages" aria-labelledby="headingTwo" data-bs-parent="#sidenavAccordion">
                        <nav class="sb-sidenav-menu-nested nav accordion" id="sidenavAccordionPages">
                           <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#pagesCollapseAuth" aria-expanded="false" aria-controls="pagesCollapseAuth">
                              Authentication
                              <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                           </a>
                           <div class="collapse" id="pagesCollapseAuth" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordionPages">
                              <nav class="sb-sidenav-menu-nested nav">
                                 <a class="nav-link" href="login.html">Login</a>
                                 <a class="nav-link" href="register.html">Register</a>
                                 <a class="nav-link" href="password.html">Forgot Password</a>
                              </nav>
                           </div>
                           <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#pagesCollapseError" aria-expanded="false" aria-controls="pagesCollapseError">
                              Error
                              <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                           </a>
                           <div class="collapse" id="pagesCollapseError" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordionPages">
                              <nav class="sb-sidenav-menu-nested nav">
                                 <a class="nav-link" href="401.html">401 Page</a>
                                 <a class="nav-link" href="404.html">404 Page</a>
                                 <a class="nav-link" href="500.html">500 Page</a>
                              </nav>
                           </div>
                        </nav>
                     </div>
                     <div class="sb-sidenav-menu-heading">Addons</div>
                     <a class="nav-link" href="charts.html">
                        <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                        Charts
                     </a>
                     <a class="nav-link" href="tables.html">
                        <div class="sb-nav-link-icon"><i class="fas fa-table"></i></div>
                        Tables
                     </a>
                  </div>
               </div><div class="sb-sidenav-footer">
                                       <div class="small">Logged in as:</div>
                                       ${pageContext.request.userPrincipal.name}
                                   </div>
            </nav>
         </div>
         <form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
                                     <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                 </form>
         <div id="layoutSidenav_content">
            <main>
               <div class="container-fluid px-4">


                     </div>
                  </div>

                 <div class="card mb-4">
                     <div class="card-header">
                         <i class="fas fa-table me-1"></i> Invoice History
                     </div>
                     <div class="card-body">

                     <div class="card mb-4">
                                          <div class="card-body">
                                             <div class="row" >
                                                <div class="col-sm-12" style="overflow-x:auto;">


                                                       <table id="datatablesSimpl" class="table">
                                                                                                                              <thead class="table table-success table-bordered">
                                                                                                                                 <tr>
                                                                                                                                    <th style=" width: 20%; ">Customer Name</th>
                                                                                                                                    <th style=" width: 14%; ">Address</th>
                                                                                                                                    <th style=" width: 12%; ">Mob No.</th>
                                                                                                                                    <th style=" width: 10%; ">Total Amt</th>
                                                                                                                                    <th style=" width: 10%; ">Paid Amt</th>
                                                                                                                                    <th style=" width: 10%; ">Bal Amt</th>
                                                                                                                                    <th style=" width: 12%; ">Invoice No.</th>
                                                                                                                                    <th style=" width: 12%; ">Date</th>

                                                                                                                                 </tr>
                                                                                                                              </thead>
                                                                                                                              <tbody>
                                                                                                                                 <tr>

                                                                                                                                     <td><input type="text" readonly="readonly"   class="form-control" value= "Mr. ${profile.custName}"  style=" font-weight: bold; text-align: left; color:black "/></td>
                                                                                                                                     <td><input type="text" readonly="readonly"   class="form-control" value= "${profile.address}"  style=" font-weight: bold; text-align: left; color:black "/></td>
                                                                                                                                    <td><input type="text" readonly="readonly"   class="form-control" value= "${profile.phoneNo}"  style=" font-weight: bold; text-align: left; color:black "/></td>
                                                                                                                                   <td><input type="text" id="totalAmount" readonly="readonly"   class="form-control" value= "&#x20b9; ${profile.totalAmount}"  style=" font-weight: bold; text-align: right; color:blue "/></td>
                                                                                                                                    <td><input type="text" id="totalAmount" readonly="readonly"   class="form-control" value= "&#x20b9; ${profile.paidAmout}"  style=" font-weight: bold; text-align: right; color:green; "/></td>
                                                                                                                                    <td><input type="text" id="totalAmount" readonly="readonly"   class="form-control" value= "&#x20b9; ${profile.currentOusting}"  style=" font-weight: bold; text-align: right; color:red; "/></td>
                                                                                                                                    <td><input type="text" readonly="readonly"   class="form-control" value= "${invoiceNo}"  style=" font-weight: bold; text-align: right; color:black "/></td>
                                                                                                                                     <td><input type="text" readonly="readonly"   class="form-control" value= "${date}"  style=" font-weight: bold; text-align: right; color:black "/></td>


                                                                                                                                 </tr>
                                                                                                                              </tbody>
                                                                                                                           </table>
                                                </div>
                                             </div>
                                             <div class="row" >
                                                <div class="col-sm-12" style="overflow-x:auto;">

                                                        <table class="table table-success table-bordered">
                                                             <thead class="table-success">
                                                            <tr>
                                                               <th>Item No</th>
                                                               <th>Select Product</th>
                                                               <th>Rate</th>
                                                               <th>Qty</th>
                                                               <th>Amount</th>
                                                               <th>Add</th>
                                                            </tr>
                                                         </thead>
                                                         <tbody>
                                                            <tr>
                                                              <form method="post" modelAttribute="ItemDetails"
                                                                                             action="${pageContext.request.contextPath}/company/save-items">
                                                               <td> <input style=" text-align: center; " type="text" class="form-control" name="itemNo" readonly="readonly"
                                                                  value="${itemsNo}"></td>
                                                               <td>
                                                                 <select id="ddlViewBy" class="form-control" onchange="getProductValue(this.value)">
                                                                   <option value="0.00">Select Product</option>
                                                                   <c:forEach var="list" items="${dropdown}">
                                                                     <option id="${list.productName}" value="${list.price}|${list.productId}">${list.productName}</option>

                                                                   </c:forEach>
                                                                 </select>

                                                               </td>
                                                               <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                               <input type="hidden" name="custId" value="${profile.id}">
                                                               <input type="hidden" name="description" id="description" required = "required">
                                                               <input type="hidden" name="productId" id="productId" required = "required">
                                                               <input type="hidden" name="invoiceNo" value="${invoiceNo}">
                                                               <td><input type="text" class="form-control" onkeyup="calAmt()"
                                                                  name="rate" id="rate" required = "required" class="required numeric" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" placeholder="Rate"></td>
                                                               <td><input type="text" class="form-control"
                                                                  name="qty" id="qty" value="1"placeholder="Qty" onkeyup="calAmt()" required = "required"></td>
                                                               <td><input type="text" class="form-control" name="amount" id="amount"
                                                                  placeholder="Amount" readonly="readonly"></td>
                                                               <td><button type="submit" class="btn btn-outline-primary align-items-center "><i class="fa fa-plus"></i> </button></td>
                                                              </form>
                                                            </tr>
                                                         </tbody>
                                                      </table>


                     <c:if test="${not empty message}">
                                                                 <div class="alert alert-warning alert-dismissible fade show" role="alert" id="alert-warning">
                                                                     <strong>Warning!</strong> ${message}
                                                                     <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                                                 </div>

                                                                 <script>
                                                                     // Auto-hide the alert after 3 seconds
                                                                     window.onload = function () {
                                                                         setTimeout(function () {
                                                                             const alert = bootstrap.Alert.getOrCreateInstance(document.getElementById('alert-warning'));
                                                                             alert.close();
                                                                         }, 3000);
                                                                     };
                                                                 </script>
                                                             </c:if>
                                                   <table class="table">
                                                      <thead class="table-primary">
                                                         <tr>
                                                            <th>Sr.No</th>
                                                            <th >Description</th>
                                                            <th>Batch No</th>
                                                            <th style="text-align: right;">Qty</th>
                                                            <th style="text-align: right;">MRP</th>
                                                             <th style="text-align: right;">Price/Unit</th>

                                                            <th style="text-align: right;">Total Amount</th>
                                                            <th style="text-align: right;">Remove</th>
                                                         </tr>
                                                      </thead>
                                                      <tbody>
                                                         <c:forEach items="${items}" var="item">
                                                            <tr>
                                                               <td>#${item.itemNo}</td>
                                                               <td style="text-align: left;">${item.description}</td>
                                                               <td style="text-align: centre;">${item.batchNo}</td>
                                                               <td style="text-align: right;">${item.qty}</td>
                                                               <td style="text-align: right;">${item.mrp}</td>
                                                               <td style="text-align: right;font-weight: bold;">${item.rate}</td>


                                                               <td style="text-align: right;">${item.amount}</td>
                                                               <td style="text-align: right;">
                                                                  <form name="frm" method="get"
                                                                     action="${pageContext.request.contextPath}/company/delete-item-by-id">
                                         <input type="hidden" name="itemid" value="${item.id}" />

                                                                                                                             												 <button type="submit" class="btn btn-outline-danger"><i class="fa fa-close"></i>    </button>

                                                                  </form>
                                                               </td>
                                                            </tr>
                                                         </c:forEach>
                                                      </tbody>
                                                   </table>
                                                  <div class="container mt-4">
                                                      <form name="frm" method="post" action="${pageContext.request.contextPath}/company/invoice" modelAttribute="INVOICE_DETAILS">

                                                          <!-- CSRF Token -->
                                                          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                                          <!-- Hidden Inputs -->
                                                          <input type="hidden" name="invoiceId" value="${invoiceNo}" />
                                                          <input type="hidden" name="custId" value="${profile.id}" />
                                                          <input type="hidden" name="custName" value="${profile.custName}" />

                                                         <input type="hidden" name="totQty" value="${totalQty}" />
                                                          <input type="hidden" name="totInvoiceAmt" id="source" value="${totalAmout}" />
                                                          <input type="hidden" name="totAmt" value="${profile.totalAmount}" />
                                                          <input type="hidden" name="balanceAmt" value="${profile.currentOusting}" />
                                                          <input type="hidden" id="advanAmtsend" name="advanAmt" value="0.0" placeholder="Adv Amt">
                                                          <input type="hidden" id="oldInvoicesFlag" name="oldInvoicesFlag" value="F" />

                                                          <table class="table table-bordered table-hover warning align-middle text-center">
                                                              <thead class="table-light">
                                                                  <tr>
                                                                      <th>Invoice Qty</th>
                                                                      <th>Invoice Amt(A)</th>
                                                                      <th>GST(B)</th>
                                                                      <th>Total Amt(A + B)</th>
                                                                      <th>Advance Amt</th>
                                                                      <th>Create Invoice</th>
                                                                  </tr>
                                                              </thead>
                                                              <tbody>
                                                                  <tr>
                                                                      <td><input type="text" class="form-control text-end" value="${totalQty}" readonly></td>
                                                                      <td><input type="text" class="form-control text-end" value="${preTaxAmt}" readonly></td>
                                                                      <td><input type="text" class="form-control text-end" value="${totGst}" readonly></td>
                                                                      <td><input type="text" class="form-control text-end" value="${totalAmout}" id="totalAmout" readonly></td>
                                                                      <td>
                                                                          <div class="d-flex align-items-center">
                                                                              <input type="text" id="advanceValue" name="advanAmt" class="form-control text-end me-2"
                                                                                     oninput="copyValue()" value="0.0" placeholder="Enter advance amount">
                                                                              <div class="form-check">
                                                                                  <input class="form-check-input" type="checkbox" id="cashCheckbox">
                                                                                  <label class="form-check-label" for="cashCheckbox">Cash</label>
                                                                              </div>
                                                                          </div>
                                                                      </td>
                                                                      <td>
                                                                          <button type="button" class="btn btn-outline-success w-100"
                                                                                  data-bs-toggle="modal" data-bs-target="#confirmModal"
                                                                                  ${empty items ? 'disabled' : ''}>
                                                                              Generate Invoice
                                                                          </button>
                                                                      </td>
                                                                  </tr>
                                                              </tbody>
                                                          </table>

                                                          <!-- Modal -->
                                                          <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
                                                            <div class="modal-dialog modal-xl">
                                                              <div class="modal-content">
                                                                <div class="modal-header">
                                                                  <h5 class="modal-title" id="confirmModalLabel">Confirm Invoice Generation</h5>
                                                                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                  <p>Are you sure you want to generate the invoice?</p>

                                                                  <table id="datatablesSimpl" class="table">
                                                                    <thead class="table-success">
                                                                      <tr>
                                                                        <th style="width: 20%;">Customer Name</th>
                                                                        <th style="width: 14%;">Address</th>
                                                                        <th style="width: 12%;">Mob No.</th>

                                                                        <th style="width: 12%;">Invoice No.</th>
                                                                        <th style="width: 12%;">Date</th>
                                                                      </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                      <tr>
                                                                        <td><span style="font-weight: bold; text-align: left; color:black;">Mr. ${profile.custName}</span></td>
                                                                        <td><span style="font-weight: bold; text-align: left; color:black;">${profile.address}</span></td>
                                                                        <td><span style="font-weight: bold; text-align: left; color:black;">${profile.phoneNo}</span></td>
                                                                        <td><span style="font-weight: bold; text-align: right; color:black;">${invoiceNo}</span></td>
                                                                        <td><span style="font-weight: bold; text-align: right; color:black;">${date}</span></td>
                                                                      </tr>
                                                                    </tbody>
                                                                  </table>

                                                                  <table class="table">
                                                                                                  <thead class="table-primary">
                                                                                                     <tr>
                                                                                                        <th>Sr.No</th>
                                                                                                        <th >Description</th>
                                                                                                        <th>Batch No</th>
                                                                                                        <th style="text-align: right;">Qty</th>
                                                                                                        <th style="text-align: right;">MRP</th>
                                                                                                         <th style="text-align: right;">Price/Unit</th>

                                                                                                        <th style="text-align: right;">Total Amount</th>

                                                                                                     </tr>
                                                                                                  </thead>
                                                                                                  <tbody>
                                                                                                     <c:forEach items="${items}" var="item">
                                                                                                        <tr>
                                                                                                           <td>#${item.itemNo}</td>
                                                                                                           <td style="text-align: left;">${item.description}</td>
                                                                                                           <td style="text-align: centre;">${item.batchNo}</td>
                                                                                                           <td style="text-align: right;">${item.qty}</td>
                                                                                                           <td style="text-align: right;">${item.mrp}</td>
                                                                                                           <td style="text-align: right;font-weight: bold;">${item.rate}</td>


                                                                                                           <td style="text-align: right;">${item.amount}</td>

                                                                                                        </tr>
                                                                                                     </c:forEach>
                                                                                                  </tbody>
                                                                                               </table>

                                                                                               <table class="table table-bordered table-hover warning align-middle text-center">
                                                                                                                                        <thead class="table-light">
                                                                                                                                            <tr>
                                                                                                                                                <th>Invoice Qty</th>
                                                                                                                                                <th>Invoice Amt(A)</th>
                                                                                                                                                <th>GST(B)</th>
                                                                                                                                                <th>Total Amt(A + B)</th>


                                                                                                                                            </tr>
                                                                                                                                        </thead>
                                                                                                                                        <tbody>
                                                                                                                                            <tr>
                                                                                                                                                <td><input type="text" class="form-control text-end" value="${totalQty}" readonly></td>
                                                                                                                                                <td><input type="text" class="form-control text-end" value="${preTaxAmt}" readonly></td>
                                                                                                                                                <td><input type="text" class="form-control text-end" value="${totGst}" readonly></td>
                                                                                                                                                <td><input type="text" class="form-control text-end" value="${totalAmout}" id="totalAmout" readonly></td>


                                                                                                                                            </tr>
                                                                                                                                        </tbody>
                                                                                                                                    </table>

                                                                </div>
                                                                <div class="modal-footer">
                                                                  <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                  <button type="submit" class="btn btn-outline-primary" onclick="document.querySelector('form').submit()">Yes, Generate</button>
                                                                </div>
                                                              </div>
                                                            </div>
                                                          </div>

                                                      </form>
                                                  </div>


                                                </div>

                                             </div>
                         <!-- Nav tabs -->
                         <ul class="nav nav-tabs" id="historyTabs" role="tablist">
                             <li class="nav-item" role="presentation">
                                 <button class="nav-link active" id="payment-tab" data-bs-toggle="tab" data-bs-target="#payment" type="button" role="tab">Payment History</button>
                             </li>
                             <li class="nav-item" role="presentation">
                                 <button class="nav-link" id="invoice-tab" data-bs-toggle="tab" data-bs-target="#invoice" type="button" role="tab">Invoice History</button>
                             </li>
                         </ul>

                         <!-- Tab panes -->
                         <div class="tab-content mt-3">
                             <!-- Payment History Tab -->
                             <div class="tab-pane fade show active" id="payment" role="tabpanel">
                                 <div class="card mb-3">
                                     <div class="card-header text-center"><strong>Payment History</strong></div>
                                     <div class="card-body">
                                         <div class="table-responsive">
                                             <table class="table table-bordered table-striped">
                                                 <thead class="table-success">
                                                     <tr>
                                                         <th>Transaction Id</th>
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
                                                             <td style="text-align: left;">
                                                                                                                                                                                                              <a href="${pageContext.request.contextPath}/company/get-bal-credit-receipt/${balanceDeposit.id}"
                                                                                                                                                                                                                 target="_blank"
                                                                                                                                                                                                                 style="text-decoration:none; color:inherit;">
                                                                                                                                                                                                                <i class="fa fa-receipt"></i> ${balanceDeposit.id}
                                                                                                                                                                                                              </a>
                                                                                                                                                                                                            </td>
                                                             <td>${balanceDeposit.custName}</td>
                                                             <td>${balanceDeposit.description}</td>
                                                             <td style="text-align: right;">${balanceDeposit.currentOusting}</td>
                                                             <td>${balanceDeposit.modeOfPayment}</td>
                                                             <td style="text-align: right;">${balanceDeposit.advAmt}</td>
                                                             <td>${balanceDeposit.date}</td>
                                                         </tr>
                                                     </c:forEach>
                                                 </tbody>
                                             </table>
                                         </div>
                                     </div>
                                 </div>
                             </div>

                             <!-- Invoice History Tab -->
                             <div class="tab-pane fade" id="invoice" role="tabpanel">
                                 <div class="card">
                                     <div class="card-header text-center"><strong>Invoice History</strong></div>
                                     <div class="card-body">
                                         <div class="table-responsive">
                                             <table class="table table-bordered table-striped">
                                                 <thead class="table-success">
                                                     <tr>
                                                         <th>Invoice No</th>
                                                         <th>Bill Amt</th>
                                                         <th>Adv Amt</th>
                                                         <th>Bal</th>
                                                         <th>Date</th>
                                                     </tr>
                                                 </thead>
                                                 <tbody>
                                                     <c:forEach items="${oldinvoices}" var="invoice">
                                                         <tr>
                                                             <td>
                                                                 <a href="${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}" target="_blank">${invoice.invoiceId}</a>
                                                             </td>
                                                             <td style="text-align: right;">${invoice.totInvoiceAmt}</td>
                                                             <td style="text-align: right;">${invoice.advanAmt}</td>
                                                             <td style="text-align: right;">${invoice.balanceAmt}</td>
                                                             <td>${invoice.createdAt}</td>
                                                         </tr>
                                                     </c:forEach>
                                                 </tbody>
                                             </table>
                                         </div>
                                     </div>
                                 </div>
                             </div>
                         </div>
                     </div>
                 </div>



               </div>

            </main>
            <footer class="py-4 bg-light mt-auto">
            <div class="container-fluid px-4">
            <div class="d-flex align-items-center justify-content-between small">
            <div class="text-muted">Copyright &copy; Your Website 2023</div>
            <div>
            <a href="#">Privacy Policy</a>
            &middot;
            <a href="#">Terms &amp; Conditions</a>
            </div>
            </div>
            </div>
            </footer>
         </div>
      </div>

      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
      <script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
      <script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>
     <script src="${pageContext.request.contextPath}/resources/js/timeout.js" crossorigin="anonymous"></script>

   </body>




   <script>
      var coll = document.getElementsByClassName("collapsible");
      var i;

      for (i = 0; i < coll.length; i++) {
        coll[i].addEventListener("click", function() {
          this.classList.toggle("active");
          var content = this.nextElementSibling;
          if (content.style.display === "block") {
            content.style.display = "none";
          } else {
            content.style.display = "block";
          }
        });
      }
   </script>
   <script type="text/javascript">

   document.getElementById('cashCheckbox').addEventListener('change', function() {
          const sourceValue = document.getElementById('totalAmout').value;
          const targetInput = document.getElementById('advanceValue');


          if (this.checked) {
            targetInput.value = sourceValue;
            document.getElementById("advanAmtsend").value=sourceValue;
          } else {
            targetInput.value = "0.0";
             document.getElementById("advanAmtsend").value="0.0"// Optional: clear target when unchecked
          }
        });


      $('document').ready(function(){
 $('#ddlViewBy').select2();
      var now = new Date();

        var day = ("0" + now.getDate()).slice(-2);
        var month = ("0" + (now.getMonth() + 1)).slice(-2);

        var today = now.getFullYear()+"-"+(month)+"-"+(day) ;


       $('.datePicker').val(today);

      });
      function calAmt() {

                  		var qty = document.getElementById("qty").value;
                  		var  rate = document.getElementById("rate").value;
                  		  var total = parseFloat(qty) * parseFloat(rate);
                  		  var fixedNum = parseFloat(total).toFixed(2);
                  		  document.getElementById('amount').value= fixedNum;
                  		}
                  	let amount = document.querySelector('#qty'), preAmount = amount.value;
                                                  amount.addEventListener('input', function(){
                                                      if(isNaN(Number(amount.value))){
                                                          amount.value = preAmount;
                                                          return;
                                                      }

                                                      let numberAfterDecimal = amount.value.split(".")[1];
                                                      if(numberAfterDecimal && numberAfterDecimal.length > 3){
                                                          amount.value = Number(amount.value).toFixed(3);;
                                                      }
                                                      preAmount = amount.value;
                                                  })

      function copyValue() {

      var amt =  document.getElementById("advanceValue").value;
      document.getElementById("advanAmtsend").value=amt;

      }


      $('.first-select').on('change', function() {
      document.getElementById("oldInvoicesFlag").value=this.value;

      })

      $("#selectCategory11").change(function(){
      var categoryId = $(this).val();
      alert($(this).find('option:selected').attr('id'));
      $.ajax({
      type: 'GET',
      url: "/categories/" + categoryId,
      success: function(data){
          var slctSubcat=$('#selectSubcat'), option="";
          slctSubcat.empty();

          for(var i=0; i<data.length; i++){
              option = option + "<option value='"+data[i].id + "'>"+data[i].subcateogory_name + "</option>";
          }
          slctSubcat.append(option);
      },
      error:function(){
          alert("error");
      }

      });
      });


      function getProductValue(value) {
    const [price, id] = value.split("|");
    console.log("Price:", price);
    console.log("ID:", id);

      var d = $('#ddlViewBy option:selected').text();
      document.getElementById("description").value = d;
       document.getElementById("productId").value=id;
      document.getElementById("rate").value = price;
      calAmt()
      }



document.getElementById("copyCheckbox").addEventListener("change", function() {
      const sourceValue = document.getElementById("source").value;
      const targetInput = document.getElementById("advanAmtsend");
      const advanceValue = document.getElementById("advanceValue");


      if (this.checked) {
        targetInput.value = sourceValue;
         advanceValue.value = sourceValue;
      } else {
        targetInput.value = "0.0";
        advanceValue.value = "0.0";

      }
    });

   </script>




</html>