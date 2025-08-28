<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
   <head>
      <title>AdminLTE | Dashboard</title>
      <!-- bootstrap 3.0.2 -->
      <link
         href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css"
         rel="stylesheet" type="text/css" />
      <!-- font Awesome -->
      <link
         href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css"
         rel="stylesheet" type="text/css" />
      <!-- Ionicons -->
      <link
         href="${pageContext.request.contextPath}/resources/css/ionicons.min.css"
         rel="stylesheet" type="text/css" />
      <!-- Morris chart -->
      <link
         href="${pageContext.request.contextPath}/resources/css/morris/morris.css"
         rel="stylesheet" type="text/css" />
      <!-- jvectormap -->
      <link
         href="${pageContext.request.contextPath}/resources/css/jvectormap/jquery-jvectormap-1.2.2.css"
         rel="stylesheet" type="text/css" />
      <link
         href="${pageContext.request.contextPath}/resources/css/fullcalendar/fullcalendar.css"
         rel="stylesheet" type="text/css" />
      <!-- Daterange picker -->
      <link
         href="${pageContext.request.contextPath}/resources/css/daterangepicker/daterangepicker-bs3.css"
         rel="stylesheet" type="text/css" />
      <!-- bootstrap wysihtml5 - text editor -->
      <link
         href="${pageContext.request.contextPath}/resources/css/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css"
         rel="stylesheet" type="text/css" />
      <!-- Theme style -->
      <link
         href="${pageContext.request.contextPath}/resources/css/AdminLTE.css"
         rel="stylesheet" type="text/css" />
      <link
         href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css"
         rel="stylesheet" type="text/css" />
      <!-- font Awesome -->
      <link
         href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css"
         rel="stylesheet" type="text/css" />
      <!-- Ionicons -->
      <link
         href="${pageContext.request.contextPath}/resources/css/ionicons.min.css"
         rel="stylesheet" type="text/css" />
      <!-- DATA TABLES -->
      <link
         href="${pageContext.request.contextPath}/resources/css/datatables/dataTables.bootstrap.css"
         rel="stylesheet" type="text/css" />
      <!-- Theme style -->
      <link
         href="${pageContext.request.contextPath}/resources/css/AdminLTE.css"
         rel="stylesheet" type="text/css" />
      <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
      <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
      <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.${pageContext.request.contextPath}/resources/js/1.3.0/respond.min.js"></script>
      <![endif]-->
      <style type="text/css">
         // solution 1:
         .datepicker {
         font-size: 0.875em;
         }
         /* solution 2: the original datepicker use 20px so replace with the following:*/
         .datepicker td, .datepicker th {
         width: 1.5em;
         height: 1.5em;
         }
         thead {
         background-color: lightsteelblue;
         }
         h1,
         h3 {
         text-align: center;
         color: green;
         }
         table {
         width: 100%;
         border-collapse: collapse;
         }
         th,
         td {
         padding: 1px;
         text-align: center;
         border-bottom: 1px solid black;
         }
         tr:hover {
         background-color: rgb(205, 243, 187);
         }
         .btn {
         border: 2px solid black;
         background-color: white;
         color: black;
         cursor: pointer;
         }
         /* Green */
         .success {
         border-color: #04AA6D;
         color: green;
         }
         .success:hover {
         background-color: #04AA6D;
         color: white;
         }
         /* Blue */
         .info {
         border-color: #2196F3;
         color: dodgerblue;
         }
         .info:hover {
         background: #2196F3;
         color: white;
         }
         /* Orange */
         .warning {
         border-color: #ff9800;
         color: orange;
         }
         .warning:hover {
         background: #ff9800;
         color: white;
         }
         /* Red */
         .danger {
         border-color: #f44336;
         color: red;
         }
         .danger:hover {
         background: #f44336;
         color: white;
         }
         /* Gray */
         .default {
         border-color: #e7e7e7;
         color: black;
         }
         .default:hover {
         background: #e7e7e7;
         }
         * {box-sizing: border-box}
         body {font-family: "Lato", sans-serif;}
         /* Style the tab */
         .tab {
         float: left;
         border: 1px solid #ccc;
         background-color: #f1f1f1;
         width: 17%;
         height: 740px;
         }
         .ScrollStyle
         {
         max-height: 110px;
         overflow-y: scroll;
         }
         /* Style the buttons inside the tab */
         .tab button {
         display: block;
         background-color: aliceblue;
         color: black;
         padding: 22px 16px;
         width: 100%;
         border: none;
         outline: none;
         text-align: left;
         cursor: pointer;
         transition: 0.3s;
         font-size: 17px;
         }
         table {
         font-family: sans-serif;
         border-collapse: collapse;
         max-height: 420px;
         overflow: auto;
         }
         /* Change background color of buttons on hover */
         .tab button:hover {
         background-color: #ddd;
         }
         /* Create an active/current "tab button" class */
         .tab button.active {
         background-color: lightsteelblue;
         }
         /* Style the tab content */
         .tabcontent {
         float: left;
         padding: 0px 12px;
         border: 1px solid #ccc;
         width: 79%;
         border-left: none;
         height: 740px;
         }
      </style>
      <script type="text/javascript">
         $('.datepicker').datepicker({
             weekStart: 1,
             daysOfWeekHighlighted: "6,0",
             autoclose: true,
             todayHighlight: true,
         });
         $('.datepicker').datepicker("setDate", new Date());
      </script>
   </head>
   <body style="font-size:small">
      <c:if test="${pageContext.request.userPrincipal.name != null}">
         <!-- Content Header (Page header) -->
         <section class="content-header">
            <h1>
               Reports <small>View/Download Reports</small>
            </h1>
            <form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
               <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </form>
            <h4 style="
               margin-left: 76%;
               margin-top: -2%;
               ">Welcome ${pageContext.request.userPrincipal.name} | <a onclick="document.forms['logoutForm'].submit()">Logout</a></h4>
            <ol class="breadcrumb">
               <li><a href="${pageContext.request.contextPath}/login/home"><i
                  class="fa fa-dashboard"></i> Home</a></li>
               <li class="active">Invoices</li>
            </ol>
            <div class="tab">
               <button class="tablinks" onclick="openCity(event, 'London')" id="defaultOpen">Create Invoice</button>
               <button class="tablinks" onclick="openCity(event, 'Tokyo')">Invoices</button>
               <button class="tablinks" onclick="openCity(event, 'Paris')">Transactions</button>
            </div>
            <div id="London" class="tabcontent">
               <div class="row" >
                  <div class="col-sm-12">
                     <table class="table">
                        <thead class="table-success">
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
                              <td>Mr. ${profile.custName}</td>
                              <td>${profile.address}</td>
                              <td>${profile.phoneNo}</td>
                              <td>${invoiceNo}</td>
                              <td>${date}</td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
               <div class="row" >
                  <form method="post"
                     action="${pageContext.request.contextPath}/company/save-items">
                     <div class="col-sm-1">
                        <input style=" text-align: center; " type="text" class="form-control" name="itemNo" readonly="readonly"
                           value="${itemsNo}">
                     </div>
                     <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                     <input type="hidden" name="custId" value="${profile.id}">
                     <input type="hidden" name="description" id="description" required = "required">
                     <input
                        type="hidden" name="invoiceNo" value="${invoiceNo}">
                     <div class="col-sm-4">
                        <select id="ddlViewBy" class="form-control" onchange="getProductValue(this.value)" >
                           <option value="0.00">Select Product</option>
                           <c:forEach  var="list" items="${dropdown}">
                              <option id="${list.productName}" value="${list.price}">${list.productName}</option>
                           </c:forEach>
                        </select>
                     </div>
                     <div class="col-sm-1">
                        <input type="text" class="form-control" onkeyup="calAmt()"
                           name="rate" id="rate" required = "required" class="required numeric" placeholder="Rate">
                     </div>
                     <div class="col-sm-1">
                        <input type="text" class="form-control"
                           name="qty" id="qty" value="1"placeholder="Qty" onkeyup="calAmt()" required = "required">
                     </div>
                     <div class="col-sm-2">
                        <input type="text" class="form-control" name="amount" id="amount"
                           placeholder="Amount" readonly="readonly">
                     </div>
                     <div class="col-sm-1">
                        <button type="submit" class="btn bg-olive btn-block">Add</button>
                     </div>
                     <div class="col-sm-1">
                        <button style="a" type="button" class="btn btn-primary align-items-center " data-toggle="modal" data-target="#myModal">+ New Product</button>
                     </div>
                  </form>
               </div>
               <div class="row invoice-info scrollit">
                  <div class="col-sm-12">
                     <h3 align="center"><small>Invoice Items</small></h3>
                     <table class="table">
                        <thead class="table-success">
                           <tr>
                              <th>Sr.No</th>
                              <th >Description</th>
                              <th>Batch No</th>
                              <th style="text-align: right;">Qty</th>
                              <th style="text-align: right;">MRP</th>
                              <th style="text-align: right;">SP</th>
                              <th style="text-align: right;">Amount</th>
                              <th style="text-align: right;">Action</th>
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
                                       <input type="hidden" name="itemid" value="${item.id}" /> <input
                                          type="submit" class="btn btn-danger"  value="Delete"
                                          onclick="{document.frm.hdnbt.value=this.value;document.frm.submit();}" />
                                    </form>
                                 </td>
                              </tr>
                           </c:forEach>
                        </tbody>
                     </table>
                  </div>
               </div>
               <div class="row invoice-info">
                  <div class="col-sm-12">
                     <table class="table table-bordered">
                        <thead>
                           <tr>
                              <th scope="col" style="text-align: centre;">Total Amount</th>
                              <th scope="col" style="text-align: centre;">Outstanding Amount</th>
                              <th scope="col" style="text-align: centre;">Invoice Qty</th>
                              <th scope="col" style="text-align: centre;">Invoice Amount</th>
                              <th scope="col" style="text-align: centre;">Advance Amount</th>
                              <th scope="col" style="text-align: centre;">
                                 <select class="first-select">
                                    <option value="N">Old Bills required ?:No</option>
                                    <option value="Y">Old Bills required ?:Yes</option>
                                 </select>
                                 <br><br>
                              </th>
                           </tr>
                        </thead>
                        <tbody>
                           <tr>
                              <th scope="row"><input type="text" class="form-control" readonly="readonly" style="text-align: right;"
                                 value="${profile.totalAmount}"></th>
                              <td><input type="text" class="form-control" readonly="readonly" style="text-align: right;"
                                 value="${profile.currentOusting}"></td>
                              <td><input type="text" class="form-control" readonly="readonly" style="text-align: right;"
                                 value="${totalQty}"></td>
                              <td><input type="text" class="form-control" readonly="readonly" style="text-align: right;"
                                 value="${totalAmout}"></td>
                              <td><input type="text" class="form-control" id="advanceValue" name="advanAmt" onkeyup="copyValue()" value="0.0"
                                 placeholder="Adv Amt" style="text-align: right;" ></td>
                              <td>
                                 <form name="frm" method="post"
                                    action="${pageContext.request.contextPath}/company/invoice"
                                    modelAttribute="INVOICE_DETAILS">
                                    <div class="col-sm-2">
                                       <input type="hidden" name="invoiceId" value="${invoiceNo}" /> <input
                                          type="hidden" name="custId" value="${profile.id}" /> <input
                                          type="hidden" name="custName" value="${profile.custName}" /> <input
                                          type="hidden" name="date" value="${date}" /> <input type="hidden"
                                          name="totQty" value="${totalQty}" /> <input type="hidden"
                                          name="totInvoiceAmt" value="${totalAmout}" /> <input type="hidden"
                                          name="totAmt" value="${profile.totalAmount}" /> <input
                                          type="hidden" name="balanceAmt" value="${profile.currentOusting}" />
                                       <input type="hidden" id="advanAmtsend" name="advanAmt" value="0.0"
                                          placeholder="Adv Amt">
                                       <input type="hidden" id="oldInvoicesFlag" name="oldInvoicesFlag" value="F" />
                                    </div>
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <div class="col-sm-2" >
                                       <input type="submit" class="btn btn-warning"
                                          value="Generate Invoice"
                                          onclick="{document.frm.hdnbt.value=this.value;document.frm.submit();}" />
                                    </div>
                                 </form>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
            </div>
            <div id="Tokyo" class="tabcontent">
               <h3 align="center"><small>Invoice History</small></h3>
               <table id="example" class="table table-bordered table-striped">
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
                           <td style="text-align: left;"><a href="${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}" target="_blank" >${invoice.invoiceId}</td>
                           <td style="text-align: left; width:60%">${invoice.itemDetails}</td>
                           <td style="text-align: right;">${invoice.totInvoiceAmt}</td>
                           <td style="text-align: right;">${invoice.advanAmt}</td>
                           <td style="text-align: right;">${invoice.balanceAmt}</td>
                           <td>${invoice.createdAt}</td>
                           </td>
                        </tr>
                     </c:forEach>
                  </tbody>
               </table>
            </div>
            <div id="Paris" class="tabcontent">
            <h3 align="center"><small>Amount Deposit </small></h3>
            <form
               action="${pageContext.request.contextPath}/company/balance-credit"
               method="post" modelAttribute="BalanceDeposite">
               <div class="body">
                  <div class="row">
                     <div class="col-sm-6">
                        <div class="form-group">
                           <input type="text"  class="form-control" readonly="readonly"
                              value="Cutomer name : ${profile.custName} "/>
                        </div>
                     </div>
                     <div class="col-sm-6">
                        <div class="form-group">
                           <input type="text" id="totalAmount" readonly="readonly"   class="form-control"
                              value= "Address : ${profile.address}" placeholder="Total Amount" />
                        </div>
                     </div>
                  </div>
                  <div class="row">
                     <div class="col-sm-4">
                        <div class="form-group">
                           <input type="text" id="totalAmount" readonly="readonly"   class="form-control"
                              value= "Total Amount : Rs. ${profile.totalAmount}" placeholder="Total Amount" />
                        </div>
                     </div>
                     <div class="col-sm-4">
                        <div class="form-group">
                           <input type="text" value= "Paid Amount :  Rs. ${profile.paidAmout}" id="paidAmout" readonly="readonly"  class="form-control"
                              placeholder="Paid Amount" />
                        </div>
                     </div>
                     <div class="col-sm-4">
                        <div class="form-group">
                           <input type="text" value= "Balance Amount :  Rs. ${profile.currentOusting}" readonly="readonly"  id="currentOusting"   class="form-control"
                              placeholder="Balance" />
                        </div>
                     </div>
                  </div>
                  <input type="hidden" name="custId" value="${profile.id}"
                  <div class="row">
                     <div class="col-sm-3">
                        <div class="form-group">
                           <select required name= "modeOfPayment" class="form-control"  >
                              <option  style="font-size: medium;text-align: center;"value="" selected>-- Payment Mode/Returns -- </option>
                              <option  style="font-size: medium;text-align: center;" value="Returns">Returns</option>
                              <option style="font-size: medium;text-align: center;" value="By GPay">GPay</option>
                              <option style="font-size: medium;text-align: center;" value="By PhonePe">PhonePe</option>
                              <option  style="font-size: medium;text-align: center;" value="By Cash">By Cash</option>
                              <option  style="font-size: medium;text-align: center;" value="By Cheque">By Cheque</option>
                              <option  style="font-size: medium;text-align: center;" value="Booking">Booking</option>
                              <option  style="font-size: medium;text-align: center;" value="Others">Others</option>
                           </select>
                        </div>
                     </div>
                     <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                     <div class="col-sm-3">
                        <div class="form-group">
                           <input type="text"  id="description"  name="description" class="form-control"
                              placeholder="Description" />
                        </div>
                     </div>
                     <div class="col-sm-2">
                        <div class="form-group">
                           <input type="text" id="advAmt"   name="advAmt" class="form-control"
                              required = "required"	placeholder="Enter Deposit Amount" />
                        </div>
                     </div>
                     <div class="col-sm-2">
                        <div class="form-group">
                           <input id="startDate"  name="date" class="form-control datePicker" type="date" required = "required"	placeholder="Enter Deposited Date" />
                        </div>
                     </div>
                     <div class="col-sm-2">
                        <button type="submit" style="width: 124px;" class="btn btn-success">Deposit</button>
                     </div>
                  </div>
            </form>
            <div class="col-sm-12">
            <h3 align="center"><small>Transactions</small></h3>
            <table id="example1" class="table table-bordered table-striped">
            <thead>
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
            <td style="text-align: left;">${balanceDeposit.id}</td>
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
            <div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog modal-lg">
               <!-- Modal content-->
               <div class="modal-content">
                  <div class="modal-header">
                     <button type="button" class="close" data-dismiss="modal">&times;</button>
                     <h4 class="modal-title">Modal Header</h4>
                  </div>
                  <div class="modal-body">
                     <div class="row centered-form">
                        <div class="col-xs-12">
                           <div class="panel panel-default">
                              <div class="panel-heading">
                                 <h3 class="panel-title">Add New Product</h3>
                              </div>
                              <div class="panel-body">
                                 <form
                                    action="${pageContext.request.contextPath}/company/add-product"
                                    method="post" modelAttribute="PRODUCTS">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <div class="row">
                                       <div class="col-sm-6">
                                          <div class="form-group">
                                             <input type="text" name="productName" id="productName" class="form-control input-sm" placeholder="Product Name">
                                          </div>
                                       </div>
                                       <input type="hidden" name="custId" value="${profile.id}">

                                          <div class="col-sm-6">
                                             <div class="form-group">
                                                <input type="text" name="company" id="company" class="form-control input-sm" placeholder="Company Name">
                                             </div>
                                          </div>
                                          </div>
                                          <div class="row">
                                          <div class="col-sm-4">
                                             <div class="form-group">
                                                <select class="form-control input-sm" id="sel1" name="quantity">
                                                   <option value="Bag" >Bag</option>
                                                   <option value="Pack">Pack</option>
                                                   <option value="Box">Box</option>
                                                   <option value="Nos">Nos.</option>
                                                   <option value="Quintal">Quintal</option>
                                                   <option value="100gram">100 Gram</option>
                                                   <option value="200gram">200 Gram</option>
                                                   <option value="500gram">500 Gram</option>
                                                   <option value="1kg">1 Kg</option>
                                                   <option value="2kg">2 Kg</option>
                                                   <option value="5kg">5 Kg</option>
                                                   <option value="10kg">10 Kg</option>
                                                   <option value="20Kg">20 Kg</option>
                                                   <option value="100Ml">100 ML</option>
                                                   <option value="100Ml">200 ML</option>
                                                   <option value="250Ml">250 ML</option>
                                                   <option value="750Ml">750 ML</option>
                                                   <option value="1Ltr">1 Ltr</option>
                                                   <option value="5Ltr" >5 Ltr</option>
                                                   <option value="10Ltr">10 Ltr</option>
                                                   <option value="20Ltr">20 Ltr</option>
                                                </select>
                                             </div>
                                          </div>
                                          <div class="col-sm-4">
                                             <div class="form-group">
                                                <input type="text" name="mrp" id="MRP" class="form-control input-sm" placeholder="MRP.">
                                             </div>
                                          </div>

                                       <div class="col-sm-4">
                                          <div class="form-group">
                                             <input type="text" name="price" id="price" class="form-control input-sm" placeholder="Selling Price">
                                          </div>
                                       </div>
                                       </div>
                                         <div class="row">
                                         <div class="col-sm-4">
                                                                                        <div class="form-group">
                                                                                           <input type="text" name="batchNo" id="batchNo" class="form-control input-sm" placeholder="Batch No">
                                                                                        </div>
                                                                                     </div>
                                            <div class="col-sm-4">
                                               <div class="form-group">
                                                  <input type="date" name="expdate" id="expdate" class="form-control input-sm" placeholder="Exp Date">
                                               </div>
                                            </div>
                                            <div class="col-sm-4">
                                               <div class="form-group">
                                                  <input type="text" pattern="[0-9]+" name="stock" id="stock" class="form-control input-sm" placeholder="Enter Available Stocks ">
                                               </div>
                                            </div>
                                         </div>

                                    <input type="submit" value="Add Product" class="btn btn-info btn-block">
                                 </form>
                              </div>
                           </div>
                        </div>
                     </div>
                  </div>
                  <div class="modal-footer">
                     <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                  </div>
               </div>
            </div>
            <script>
               function openCity(evt, cityName) {
                 var i, tabcontent, tablinks;
                 tabcontent = document.getElementsByClassName("tabcontent");
                 for (i = 0; i < tabcontent.length; i++) {
                   tabcontent[i].style.display = "none";
                 }
                 tablinks = document.getElementsByClassName("tablinks");
                 for (i = 0; i < tablinks.length; i++) {
                   tablinks[i].className = tablinks[i].className.replace(" active", "");
                 }
                 document.getElementById(cityName).style.display = "block";
                 evt.currentTarget.className += " active";
               }

               // Get the element with id="defaultOpen" and click on it
               document.getElementById("defaultOpen").click();
            </script>
         </section>
         <!-- jQuery 2.0.2 -->
         <script
            src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
         <!-- jQuery UI 1.10.3 -->
         <script
            src="${pageContext.request.contextPath}/resources/js/jquery-ui-1.10.3.min.js"
            type="text/javascript"></script>
         <!-- Bootstrap -->
         <script
            src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"
            type="text/javascript"></script>
         <!-- Morris.js charts -->
         <script
            src="//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/morris/morris.min.js"
            type="text/javascript"></script>
         <!-- Sparkline -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/sparkline/jquery.sparkline.min.js"
            type="text/javascript"></script>
         <!-- jvectormap -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"
            type="text/javascript"></script>
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"
            type="text/javascript"></script>
         <!-- fullCalendar -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/fullcalendar/fullcalendar.min.js"
            type="text/javascript"></script>
         <!-- jQuery Knob Chart -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/jqueryKnob/jquery.knob.js"
            type="text/javascript"></script>
         <!-- daterangepicker -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/daterangepicker/daterangepicker.js"
            type="text/javascript"></script>
         <!-- Bootstrap WYSIHTML5 -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"
            type="text/javascript"></script>
         <!-- iCheck -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/iCheck/icheck.min.js"
            type="text/javascript"></script>
         <!-- AdminLTE App -->
         <script
            src="${pageContext.request.contextPath}/resources/js/AdminLTE/app.js"
            type="text/javascript"></script>
         <!-- AdminLTE dashboard demo (This is only for demo purposes) -->
         <!-- AdminLTE for demo purposes -->
         <script
            src="${pageContext.request.contextPath}/resources/js/AdminLTE/demo.js"
            type="text/javascript"></script>
         <!-- jQuery 2.0.2 -->
         <script
            src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
         <!-- Bootstrap -->
         <script
            src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"
            type="text/javascript"></script>
         <!-- DATA TABES SCRIPT -->
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/datatables/jquery.dataTables.js"
            type="text/javascript"></script>
         <script
            src="${pageContext.request.contextPath}/resources/js/plugins/datatables/dataTables.bootstrap.js"
            type="text/javascript"></script>
         <!-- AdminLTE App -->
         <script
            src="${pageContext.request.contextPath}/resources/js/AdminLTE/app.js"
            type="text/javascript"></script>
         <!-- AdminLTE for demo purposes -->
         <script
            src="${pageContext.request.contextPath}/resources/js/AdminLTE/demo.js"
            type="text/javascript"></script>
         <!-- page script -->
         <script type="text/javascript">
            $(function() {
            	$("#example1").dataTable({

            		 lengthMenu: [ [4, 10, 25, 50, -1], [4, 10, 25, 50, "All"] ],
                              pageLength: 4
            	});
            });

            $(function() {
                  			$("#example").dataTable({

                  				 lengthMenu: [ [4, 10, 25, 50, -1], [4, 10, 25, 50, "All"] ],
                                      pageLength: 4
                  			});
                  		});


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
      </c:if>
   </body>
</html>