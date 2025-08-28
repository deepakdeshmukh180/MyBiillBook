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
      <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
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
                        Manu
                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                     </a>
                     <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
                        <nav class="sb-sidenav-menu-nested nav">
                           <a class="nav-link" href="${pageContext.request.contextPath}/company/get-custmer-by-id/${profile.id}">Create Invoice</a>
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
                  <h6 class="mt-4">Tables</h6>
                  <div class="card mb-4">



                                          <div class="card-header">
                                             <i class="fas fa-table me-1"></i>
                                             Invoice Summary
                                          </div>

                                          <div class="card-body">
                                                                  <div class="row" >
                                                                     <div class="col-sm-12" style="overflow-x:auto;">
                                                                        <table id="datatablesSimpl" class="table">
                                                                           <thead class="table-success">
                                                                              <tr>
                                                                                 <th style=" width: 22%; ">Customer Name</th>
                                                                                 <th style=" width: 15%; ">Address</th>
                                                                                 <th style=" width: 15%; ">Mob No.</th>
                                                                                 <th style=" width: 16%; ">Total Amt</th>
                                                                                 <th style=" width: 16%; ">Paid Amt</th>
                                                                                 <th style=" width: 16%; ">Balance Amt</th>

                                                                              </tr>
                                                                           </thead>
                                                                           <tbody>
                                                                              <tr>
                                                                                 <td>Mr. ${profile.custName}</td>
                                                                                 <td>${profile.address}</td>
                                                                                 <td>${profile.phoneNo}</td>
                                                                                 <td><input type="text" id="totalAmount" readonly="readonly"   class="form-control"
                                                                                                                                                             value= "&#x20b9; ${profile.totalAmount}"  style=" font-weight: bold; text-align: right; color:blue "/></td>
                                                                                 <td><input type="text" id="totalAmount" readonly="readonly"   class="form-control"
                                                                                                                                                             value= "&#x20b9; ${profile.paidAmout}"  style=" font-weight: bold; text-align: right; color:green; "/></td>
                                                                                 <td><input type="text" id="totalAmount" readonly="readonly"   class="form-control"
                                                                                                                                                             value= "&#x20b9; ${profile.currentOusting}"  style=" font-weight: bold; text-align: right; color:red; "/></td>

                                                                              </tr>
                                                                           </tbody>
                                                                        </table>
                                                                     </div>
                                                                  </div>
                                                                  <div class="row" >
                                                                    <div class="container">
                                                                      <form action="${pageContext.request.contextPath}/company/balance-credit" method="post" modelAttribute="BalanceDeposite">
                                                                        <input type="hidden" name="custId" value="${profile.id}">
                                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                                                        <div class="row mt-2">
                                                                          <div class="col-md-3">
                                                                            <div class="form-group">
                                                                              <select required name="modeOfPayment" class="form-control">
                                                                                <option value="" selected>-- Payment Mode/Returns --</option>
                                                                                <option value="Returns">Returns</option>
                                                                                <option value="By GPay">GPay</option>
                                                                                <option value="By PhonePe">PhonePe</option>
                                                                                <option value="By Cash">By Cash</option>
                                                                                <option value="By Cheque">By Cheque</option>
                                                                                <option value="Booking">Booking</option>
                                                                                <option value="Others">Others</option>
                                                                              </select>
                                                                            </div>
                                                                          </div>

                                                                          <div class="col-md-3">
                                                                            <div class="form-group">
                                                                              <input type="text" name="description" class="form-control" placeholder="Description" />
                                                                            </div>
                                                                          </div>

                                                                          <div class="col-md-2">
                                                                            <div class="form-group">
                                                                              <input name="date" class="form-control datePicker" type="date" required placeholder="Enter Deposited Date" />
                                                                            </div>
                                                                          </div>

                                                                          <div class="col-md-2">
                                                                            <div class="form-group">
                                                                              <input type="text" name="advAmt" class="form-control" required maxlength="7"
                                                                                oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
                                                                                placeholder="Enter Deposit Amount" />
                                                                            </div>
                                                                          </div>
                                                                          <div class="col-md-2">
                                                                                                                                                      <div class="form-group">
                                                                                                                                                        <div class="col-12 text-center">
                                                                                                                                                                                                                                   <button type="submit" class="btn btn-outline-success" style="width: 124px;">Deposit</button>
                                                                                                                                                                                                                                 </div>
                                                                                                                                                      </div>
                                                                                                                                                    </div>
                                                                        </div>


                                                                      </form>
                                                                    </div>



                                       </div>
                  </div>
                  </div>

                  <div class="col-xl-12">
                                              								<div class="card mb-4">
                                              									<div class="card-header">
                                              										<i class="fas fa-file-invoice me-1"></i>
                                                                                     Invoice History
                                              									</div>
                                              									<div class="card-body">

                   <table id="datatablesSimple" class="table table-bordered table-striped">
                                                                                                                                          <thead class="table-success">
                                                                                                                                             <th >Transaction Id</th>
                                                                                                                                             <th>Customer Name</th>
                                                                                                                                             <th>Description</th>
                                                                                                                                             <th >Closing Amt</th>
                                                                                                                                             <th >Payment Mode</th>
                                                                                                                                             <th >Deposited Amt</th>
                                                                                                                                             <th >Date </th>
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

                                                                                                                                                   <td style="text-align: left;">${balanceDeposit.custName}</td>
                                                                                                                                                   <td style="text-align: left;">${balanceDeposit.description}</td>
                                                                                                                                                   <td style="text-align: right;">${balanceDeposit.currentOusting}</td>
                                                                                                                                                   <td>${balanceDeposit.modeOfPayment}</td>
                                                                                                                                                   <td style="text-align: right;">${balanceDeposit.advAmt}</td>
                                                                                                                                                   <td>${balanceDeposit.date}</td>
                                                                                                                                                   </td>
                                                                                                                                                </tr>
                                                                                                                                             </c:forEach>
                                                                                                                                             </tfoot>
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
      <script
         src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
      <script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
      <script src="${pageContext.request.contextPath}/resources/assets/demo/chart-area-demo.js"></script>
      <script src="${pageContext.request.contextPath}/resources/assets/demo/chart-bar-demo.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
      <script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>
      <script src="${pageContext.request.contextPath}/resources/js/timeout.js" crossorigin="anonymous"></script>
       <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
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
      $('document').ready(function(){

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