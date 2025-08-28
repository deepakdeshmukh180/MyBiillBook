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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
<!-- fullCalendar -->
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

<style>
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
</style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">
	<!-- Content Header (Page header) -->
	<section class="content-header">
		<h1>
			Customers Profiles <small>Add Customer /Create new invoice</small>
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
         <div class="row myform" style="background-color: lightsteelblue; overflow-x:auto;margin-left:2% ;margin-right:2%">

               <form action="${pageContext.request.contextPath}/login/save-profile-details"
                  method="post" modelAttribute="CustProfile" role="form" >
                  <div class="col-md-2 form-group">
                     <label class="control-label" for="fullName">Customer Name</label>
                     <input  type="text" name="custName" id="custName" required="required" class="form-control" placeholder="Customer Name"/>
                  </div>
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                     <div class=" col-md-2 form-group">
                        <label>Address</label>
                        <input required type="text" required="required" name="address" id="address" class="form-control" placeholder="Address"/>
                     </div>

                  <div class="col-md-2  form-group">
                     <label class="control-label" for="phoneNo">Mobile No.</label>

                     <input required type="text" pattern="[6789][0-9]{9}" title="Please enter valid mobile number" required="required" minlength="10" maxlength="10" name="phoneNo" id="phoneNo" class="form-control" placeholder="Mobile No."/>
                  </div>
                   <div class=" col-md-2 form-group">
                                          <label>Email</label>
                                          <input  type="email" name="email" id="email" class="form-control" placeholder="Address"/>
                                       </div>
                  <div class="col-md-2 form-group">
                     <label>Balance Amount </label>
                     <input required type="text" required="required" maxlength="7" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"  name="currentOusting" id="currentOusting" value="0.00"class="form-control" placeholder="Balance Amount"/>
                  </div>
                  <div class="col-md-1  form-group">
                    <label class="control-label" >Add Customer</label>
                     <button type="submit" class="btn-success form-control" >Add</button>
                  </div>
               </form>

         </div>
           <span style="
                           color: chocolate;
                           font-size: small;
                           margin-left: 12%;
                       ">${msg}</span>
	</section>
	<!-- Main content -->
	<!-- /.content -->

	<!-- add new calendar event modal -->
	<section class="content">
		<div class="row">

			<div class="col-xs-12">
				<div class="box">

					<!-- /.box-header -->
					<div class="box-body table-responsive">
                    						<table id="example1" class="table table-bordered table-striped">
                    							<thead style="background-color: lightsteelblue;">
                    								<tr>

                    									<th >Customer Name</th>
                    									<th>Address</th>
                    									<th>Contact No</th>
                    									<th>Total Amount</th>
                    									<th>Paid Amount</th>
                    									<th>Balance Amount</th>

                    									<th>New Invoice</th>
                    									<th>Details</th>
                    								</tr>
                    							</thead>
                    							<tbody>
                    								<c:forEach items="${custmers}" var="custmer">
                    									<tr>

                    										<td >  ${custmer.custName}</td>
                    										<td>${custmer.address}</td>
                    										<td><a target="_blank" href="https://wa.me/${custmer.phoneNo}/?text=Namaste!!!  ${custmer.custName},This is a quick reminder about your payment of Rs.${custmer.currentOusting} due on ${date} . Please make the payment at your convenience.Let us know if you have any questions. Thank you!" class="whatsapp"> <i class="fa fa-whatsapp">  ${custmer.phoneNo}</td>
                    										<td><input type="text" style=" text-align: right; font-weight: bold; " readonly="readonly" class="form-control" value="${custmer.totalAmount}" /></td>
                    										<td><input type="text" style=" text-align: right; color:green ;font-weight: bold; " class="form-control" readonly="readonly" value="${custmer.paidAmout}" /></td>
                    										<td><input type="text" style=" text-align: right; color:red ; font-weight: bold; " class="form-control" readonly="readonly" value="${custmer.currentOusting}" /></td>

                    										<td>
                    											<form name="frm" method="get" action="${pageContext.request.contextPath}/company/get-cust-by-id">
                    												<input type="hidden" name="custid" value="${custmer.id}" />
                    												<input type="submit"
                    													class="btn btn-primary" value="New Invoice"
                    													onclick="{document.frm.hdnbt.value=this.value;document.frm.submit();}" />
                    											</form>
                    										</td>
                    										<td>
                                                                                											<form target="_blank" name="frm" method="get" action="${pageContext.request.contextPath}/company/cust-history">
                                                                                												<input type="hidden" name="custid" value="${custmer.id}" />
                                                                                												<input type="submit"
                                                                                													class="btn btn-warning" value="View Details"
                                                                                													onclick="{document.frm.hdnbt.value=this.value;document.frm.submit();}" />
                                                                                											</form>
                                                                                										</td>
                    									</tr>
                    								</c:forEach>
                    							</tfoot>
                    						</table>
                    					</div>
					<!-- /.box-body -->
				</div>
				<!-- /.box -->
			</div>

		</div>

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
	<script
		src="${pageContext.request.contextPath}/resources/js/AdminLTE/dashboard.js"
		type="text/javascript"></script>

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

				lengthMenu : [ [ 5, 10, 25, -1 ], [ 5, 10, 25, 'All' ] ]
			});
		});

	</script>
	</c:if>
</body>
</html>