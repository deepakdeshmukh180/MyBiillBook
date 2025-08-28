<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Dashboard - SB Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
         <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
         <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
         <script defer src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script>
<style>
    .info-label {
      font-weight: 500;
      color: #555;
    }
  </style>
    </head>

    <body class="sb-nav-fixed">
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">My <i class="fa fa-calculator" style="font-size:20px;color:red"></i> Bill Book</a>
            <!-- Sidebar Toggle-->
            <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
            <!-- Navbar Search-->
            <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
                <div class="input-group">
                    <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
                    <button class="btn btn-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
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
                    </div>
                    <div class="sb-sidenav-footer">
                        <div class="small">Logged in as:</div>
                        ${pageContext.request.userPrincipal.name}
                    </div>
                </nav>
            </div>
            <div id="layoutSidenav_content">
                <main>
                    <div class="container-fluid px-4" style=" padding-top: 1%; ">

 <div class="container my-5">
    <div class="card shadow rounded-4">
      <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h4 class="mb-0">
          <i class="bi bi-person-vcard-fill me-2"></i>Dealer Information
        </h4>

      </div>
      <div class="card-body">
        <div class="row mb-3">
          <div class="col-md-8">
            <span class="info-label"><i class="bi bi-building me-2"></i><strong>Dealer Name:</strong></span>
            <span id="dealerName">${dealer.dealerName}</span>
          </div>
          <div class="col-md-4">
            <span class="info-label"><i class="bi bi-telephone-fill me-2"></i><strong>Contact No:</strong></span>
            <span id="contactNo">+91-${dealer.mobileNo}</span>
          </div>
        </div>
        <div class="row mb-3">
          <div class="col-md-8">
            <span class="info-label"><i class="bi bi-geo-alt-fill me-2"></i><strong>Address:</strong></span>
            <span id="address" data-bs-toggle="tooltip" title="Click to copy">${dealer.dealerAddress}</span>
          </div>
          <div class="col-md-4">
            <span class="info-label"><i class="bi bi-file-earmark-text me-2"></i><strong>GST:</strong></span>
            <span id="gst">${dealer.gstNo}</span>
          </div>
        </div>
        <div class="row mb-3">
          <div class="col-md-4">
            <span class="info-label"><i class="bi bi-currency-rupee me-2"></i><strong>Total Amount:</strong></span>
            <span id="totalAmount">₹${dealer.totalAmount}</span>
          </div>
          <div class="col-md-4">
                    <span class="info-label"><i class="bi bi-currency-rupee me-2"></i><strong>Paid Amount:</strong></span>
                    <span id="paidAmount">₹${dealer.paidAmount}</span>
         </div>
          <div class="col-md-4">
                             <span class="info-label"><i class="bi bi-currency-rupee me-2"></i><strong>Balance Amount:</strong></span>
                             <span id="balanceAmount">₹${dealer.balanceAmount}</span>
                           </div>
        </div>
        <div class="row mb-3">
         <div class="col-md-3">
                    <span class="info-label"><i class="bi bi-currency-rupee me-2"></i><strong>Bank Name::</strong></span>
                    <span id="bankName">${dealer.bankName}</span>
                  </div>
                  <div class="col-md-3">
                            <span class="info-label"><i class="bi bi-currency-rupee me-2"></i><strong>Account Number:</strong></span>
                            <span id="accountNo">${dealer.accountNo}</span>
                 </div>
                  <div class="col-md-3">
                             <span class="info-label"><i class="bi bi-currency-rupee me-2"></i><strong>IFSC Code:</strong></span>
                             <span id="ifscCode">${dealer.ifscCode}</span>
                   </div>
                   <div class="col-md-3">
                                     <span class="info-label"><i class="bi bi-currency-rupee me-2"></i><strong>Branch:</strong></span>
                                     <span id="branchName">${dealer.branchName}</span>
                   </div>

                </div>

                  <div class="col-md-12">
                                        <div class="card" style="margin-top: 1%;">
                                            <div class="card-header">Create Dealer Invoice Memo for Bill No:${billNo} </div>
                                            <div class="card-body">

                                                <table class="table">
                                                                                       <thead class="table-success">
                                                                                      <tr>
                                                                                         <th>Item No</th>
                                                                                         <th>Select Product</th>
                                                                                         <th>Dealer Rate</th>
                                                                                         <th>Qty</th>
                                                                                         <th>Amount</th>
                                                                                         <th>Add</th>
                                                                                      </tr>
                                                                                   </thead>
                                                                                   <tbody>
                                                                                      <tr>
                                                                                        <form method="post" action="${pageContext.request.contextPath}/company/save-items">
                                                                                         <td> <input style=" text-align: center; " type="text" class="form-control" name="itemNo" readonly="readonly"
                                                                                            value="${itemsNo}"></td>
                                                                                         <td>
                                                                                           <select id="ddlViewBy" class="form-control" onchange="getProductValue(this.value)">
                                                                                             <option value="0.00">Select Product</option>
                                                                                             <c:forEach var="list" items="${dropdown}">
                                                                                               <option id="${list.productName}" value="${list.delarPrice}">${list.productName}</option>
                                                                                             </c:forEach>
                                                                                           </select>

                                                                                         </td>
                                                                                         <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                                                         <input type="hidden" name="custId" value="${profile.id}">
                                                                                         <input type="hidden" name="description" id="description" required = "required">
                                                                                        <td><input type="text" class="form-control" onkeyup="calAmt()"
                                                                                            name="rate" id="rate" required = "required" class="required numeric" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" placeholder="Rate"></td>
                                                                                         <td><input type="text" class="form-control"
                                                                                            name="qty" id="qty" value="1"placeholder="Qty" onkeyup="calAmt()" required = "required"></td>
                                                                                         <td><input type="text" class="form-control" name="amount" id="amount"
                                                                                            placeholder="Amount" readonly="readonly"></td>
                                                                                         <td><button type="submit" class="btn btn-primary align-items-center "><i class="fa fa-plus"></i> </button></td>
                                                                                        </form>
                                                                                      </tr>
                                                                                   </tbody>
                                                                                </table>

                                               </div>
                                            </div>
                                              </div>
      </div>
    </div>


  </div>



  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
    });
  </script>
</body>


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
	<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        </form>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>
        <script src="${pageContext.request.contextPath}/resources/js/timeout.js" crossorigin="anonymous"></script>
    </body>

       <script type="text/javascript">


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


          function getProductValue(e) {
          var d = $('#ddlViewBy option:selected').text();
          document.getElementById("description").value = d;
          document.getElementById("rate").value = e;
          calAmt()
          }


       </script>
</html>
