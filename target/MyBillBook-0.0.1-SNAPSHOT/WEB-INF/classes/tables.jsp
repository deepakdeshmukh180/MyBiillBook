<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Tables - SB Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    </head>
    <body class="sb-nav-fixed">
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href="index.html">Start Bootstrap</a>
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
                        <li><a class="dropdown-item" href="#!">Settings</a></li>
                        <li><a class="dropdown-item" href="#!">Activity Log</a></li>
                        <li><hr class="dropdown-divider" /></li>
                        <li><a class="dropdown-item" href="#!">Logout</a></li>
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
                            <a class="nav-link" href="index.html">
                                <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                                Dashboard
                            </a>
                            <div class="sb-sidenav-menu-heading">Interface</div>
                            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                                <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>
                                Layouts
                                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>
                            <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
                                <nav class="sb-sidenav-menu-nested nav">
                                    <a class="nav-link" href="layout-static.html">Static Navigation</a>
                                    <a class="nav-link" href="layout-sidenav-light.html">Light Sidenav</a>
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
                        Start Bootstrap
                    </div>
                </nav>
            </div>
            <div id="layoutSidenav_content">
                <main>
                    <div class="container-fluid px-4">
                        <h1 class="mt-4">Tables</h1>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item"><a href="index.html">Dashboard</a></li>
                            <li class="breadcrumb-item active">Tables</li>
                        </ol>
                        <div class="card mb-4">
                            <div class="card-body">
                                DataTables is a third party plugin that is used to generate the demo table below. For more information about DataTables, please visit the
                                <a target="_blank" href="https://datatables.net/">official DataTables documentation</a>
                                .
                            </div>
                        </div>
                        <div class="container bootdey" >
                        <div class="row">
                        		<div class="col-sm-12 col-sm-offset-1">
                        			<div class="widget-box">
                        				<div class="widget-header widget-header-large" style=" margin-bottom: -12%; ">
                        					<h3 class="widget-title grey lighter">
                        						<i class="ace-icon fa fa-leaf green"></i>
                        						Bootdey receipt
                        					</h3>

                        					<div class="widget-toolbar no-border invoice-info">
                        						<span class="invoice-info-label">Invoice No :</span>
                        						<span class="red">#${invoiceNo}</span>

                        						<br>
                        						<span class="invoice-info-label">Date:</span>
                        						<span class="blue">${date}</span>
                        					</div>

                        					<div class="widget-toolbar hidden-480">
                        						<a  onclick="window.print();">
                        							<i class="ace-icon fa fa-print"></i>
                        						</a>
                        					</div>
                        				</div>
                                      <div class="row" >
                                       <div class="col-sm-12" >
                                          <table class="table table-responsive table-bordered table-sm">
                                             <thead class="table-success">
                                                <tr >
                                                   <th>Customer Name</th>
                                                   <th>Address</th>
                                                   <th>Mob No.</th>
                                                </tr>
                                             </thead>
                                             <tbody>
                                                <tr>
                                                   <td>Mr.${profile.custName}</td>
                                                   <td>${profile.address}</td>
                                                  <td>${profile.phoneNo}</td>
                                                </tr>
                                             </tbody>
                                          </table>
                                           <table style=" margin-top: -2.5%; " class="table table-responsive table-bordered table-sm">
                                                                               <thead class="table-success">
                                                                                 <tr>
                                                                                    <th>SR.</th>
                                                                                    <th>Description</th>
                                                                                    <th>Bat No</th>
                                                                                    <th>Qty</th>
                                                                                    <th>MRP</th>
                                                                                    <th>Selling Price</th>
                                                                                    <th>Amount</th>
                                                                                 </tr>
                                                                              </thead>
                                                                              <body>
                                                                                 <c:forEach items="${items}" var="item">
                                                                                    <tr>
                                                                                       <td>#${item.itemNo}</td>
                                                                                       <td>${item.description}</td>
                                                                                       <td>${item.batchNo}</td>
                                                                                       <td>${item.qty}</td>
                                                                                        <td style="text-align: right;">${item.mrp}</td>
                                                                                       <td style="text-align: right;">${item.rate}</td>
                                                                                       <td style="text-align: right;">Rs.${item.amount}</td>
                                                                                    </tr>
                                                                                 </c:forEach>
                                                                              </body>
                                                                           </table>
                                                                            <table class="table">
                                                                                                   <thead class="table-success">
                                                                                                      <tr>
                                                                                                         <th style="text-align: right;">Invoice Amount </th>
                                                                                                         <th style="text-align: left;">: Rs.${totalAmout}</th>
                                                                                                         <th style="text-align: right;">Paid Amt </th>
                                                                                                         <th style="text-align: left;">: Rs.${advamount}</th>
                                                                                                         <th style="text-align: right;">Bal Amt  </th>
                                                                                                         <th style="text-align: left;">: Rs.${profile.currentOusting}</th>
                                                                                                      </tr>
                                                                                                   </thead>
                                                                                                </table>
                                                                                        <c:if test="${oldinvoices.size() > 0}">

                                                                                         <table class="table table-responsive table-bordered table-sm">
                                                                                                                                               <thead class="table-success">
                                                                                                                <tr>
                                                                                                                   <th>Invoice No</th>
                                                                                                                   <th>Items Description(Old Invoice)</th>
                                                                                                                   <th>Bill Amt</th>
                                                                                                                   <th>Adv Amt</th>
                                                                                                                   <th>Bal</th>
                                                                                                                   <th>Date</th>
                                                                                                                </tr>
                                                                                                             </thead>
                                                                                                             <tbody>
                                                                                                                <c:forEach items="${oldinvoices}" var="invoice">
                                                                                                                   <tr>
                                                                                                                      <td>${invoice.invoiceId}</td>
                                                                                                                      <td>${invoice.itemDetails}</td>
                                                                                                                      <td style="text-align: right;">${invoice.totInvoiceAmt}</td>
                                                                                                                      <td style="text-align: right;">${invoice.advanAmt}</td>
                                                                                                                      <td style="text-align: right;">${invoice.balanceAmt}</td>
                                                                                                                      <td>${invoice.createdAt}</td>
                                                                                                                      </td>
                                                                                                                   </tr>
                                                                                                                </c:forEach>
                                                                                                             </tbody>
                                                                                                          </table>

                                                                                        </c:if>
                                                                                                                                                 <c:if test="${balanceDeposits.size() > 0}">
                                                                                                                                                        <table class="table table-responsive table-bordered table-sm">
                                                                                                                                                                                                                                                                              <thead class="table-success">
                                                                                                                                                                                            <tr>

                                                                                                                                                                                              <th>Transaction Id</th>
                                                                                                                                                                                              <th> Description</th>
                                                                                                                                                                                              <th>Balance Amount </th>
                                                                                                                                                                                              <th>Payment Mode </th>
                                                                                                                                                                                              <th>Deposited Amt </th>
                                                                                                                                                                                              <th>Date </th>
                                                                                                                                                                                            </tr>
                                                                                                                                                                                          </thead>
                                                                                                                                                                                         <tbody>
                                                                                                                                                                                                 							<c:forEach items="${balanceDeposits}" var="balanceDeposit">
                                                                                                                                                                                                 								<tr>

                                                                                                                                                                                                 									<td>${balanceDeposit.id}</td>
                                                                                                                                                                                                 									<td>${balanceDeposit.description}</td>
                                                                                                                                                                                                 									<td style="text-align: right;">${balanceDeposit.currentOusting}</td>
                                                                                                                                                                                                 									<td>${balanceDeposit.modeOfPayment}</td>
                                                                                                                                                                                                 									<td style="text-align: right;">${balanceDeposit.advAmt}</td>
                                                                                                                                                                                                 									<td>${balanceDeposit.createdAt}</td>
                                                                                                                                                                                                 									</td>
                                                                                                                                                                                                 								</tr>
                                                                                                                                                                                                 							</c:forEach>
                                                                                                                                                                                                 					</tbody>
                                                                                                                                                                                        </table>

                                                                                             </c:if>
                        <div class="row" style=" margin-left: 0%; margin-right: -7%; ">
                        							<div class="col-sm-12">
                        								<div class="row">
                        									  <hr class="three" style="  margin-right: 7%;">
                        								</div></div>
                                                              								</div>
                                                                                         <table  class="table table-bordered table-sm">
                                                                                                             <thead class="table-success table-responsive">
                                                                                                                <tr>
                                                                                                                   <th>Customer Name</th>
                                                                                                                   <th>Address</th>
                                                                                                                   <th>Mob No.</th>
                                                                                                                   <th>Invoice No.</th>
                                                                                                                   <th>Date:</th>
                                                                                                                </tr>
                                                                                                             </thead>
                                                                                                             <tbody>
                                                                                                                <tr>
                                                                                                                   <td>Mr.${profile.custName}</td>
                                                                                                                   <td>${profile.address}</td>
                                                                                                                   <td>${profile.phoneNo}</td>
                                                                                                                   <td>${invoiceNo}</td>
                                                                                                                   <td>${date}</td>
                                                                                                                </tr>
                                                                                                             </tbody>
                                                                                                          </table>
                                                                                                          <table style=" margin-top: -2.5%; " class="table table-responsive" >
                                                                                                                               <thead>
                                                                                                                                  <tr>
                                                                                                                                     <th>Invoice No</th>
                                                                                                                                     <th>Items Description(Current bill)</th>
                                                                                                                                     <th>Bill Amt</th>
                                                                                                                                     <th>Adv Amt</th>
                                                                                                                                     <th>Bal</th>

                                                                                                                                  </tr>
                                                                                                                               </thead>
                                                                                                                               <tbody>
                                                                                                                                  <tr>
                                                                                                                                     <td>${currentinvoiceitems.invoiceId}</td>
                                                                                                                                     <td>${currentinvoiceitems.itemDetails}</td>
                                                                                                                                     <td>${currentinvoiceitems.totInvoiceAmt}</td>
                                                                                                                                     <td>${currentinvoiceitems.advanAmt}</td>
                                                                                                                                     <td>${currentinvoiceitems.balanceAmt}</td>

                                                                                                                                     </td>
                                                                                                                                  </tr>
                                                                                                                               </tbody>
                                                                                                                            </table>





                                 <!-- /.content -->
                                 <script type="text/javascript">
                                    function GetFileSizeNameAndType() {
                                    	$('#btn-upload').button('enable');
                                    	var fi = document.getElementById('formFile');
                                    	var invoiceNo = document.getElementById('invoiceNumber').value
                                    			.split('/');
                                    	if (fi.files.length > 0) {
                                    		var filename = '';
                                    		var ino = '';
                                    		for (var i = 0; i <= fi.files.length - 1; i++) {
                                    			filename = fi.files.item(i).name;
                                    			ino = fi.files.item(i).name.split('_');
                                    		}
                                    		if (invoiceNo[0] != ino[0]) {
                                    			$('#btn-upload').button('disable');
                                    			alert('Invalid file selected :' + filename);
                                    		}

                                    	}
                                    }
                                 </script>
                                 <script
                                    src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
                                 <!-- Bootstrap -->
                                 <script
                                    src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"
                                    type="text/javascript"></script>
                                 <!-- AdminLTE App -->
                                 <script
                                    src="${pageContext.request.contextPath}/resources/js/AdminLTE/app.js"
                                    type="text/javascript"></script>
                                 <!-- AdminLTE for demo purposes -->
                                 <script
                                    src="${pageContext.request.contextPath}/resources/js/AdminLTE/demo.js"
                                    type="text/javascript"></script>
                              </c:if>
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
        <script src="js/scripts.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="js/datatables-simple-demo.js"></script>
    </body>
</html>
