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
</head>
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
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">
	<!-- Content Header (Page header) -->
	<section class="content-header">
		<h1>
			Invoices <small>Invoices Details</small>
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
	</section>
	<!-- Main content -->
	<!-- /.content -->

	<!-- add new calendar event modal -->
	<section class="content">
		<div class="row">

			<div class="col-xs-12">
				<div class="box">
					<div class="box-header">
						<h3 class="box-title">All Invoice Data</h3>
					</div>
					<!-- /.box-header -->
					<div class="box-body table-responsive">
						<table id="example1" class="table table-bordered table-striped">
							<thead>
								<tr>
									<th>Invoice No</th>
									<th>Customer Name</th>
									<th>Discription</th>
									<th>Invoice Amount</th>
									<th>Advance Amount</th>
									<th>Balance</th>
									<th>Date</th>
									<th>Created By</th>

								</tr>
							</thead>
							<tbody>
								<c:forEach items="${invoices}" var="invoice">
									<tr>
										<td><a href="${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}" target="_blank" >${invoice.invoiceId}</td>
										<td style="text-align: left;">${invoice.custName}</td>
										<td style="text-align: left;"">${invoice.itemDetails}</td>
										<td><input type="text" class="form-control"
											style="text-align: right; font-weight: bold;"
											readonly="readonly" value="${invoice.totInvoiceAmt}" /></td>
										<td><input type="text" class="form-control"
											style="text-align: right; color: green; font-weight: bold;"
											readonly="readonly" value="${invoice.advanAmt}" /></td>
										<td><input type="text" class="form-control"
											style="text-align: right; color: red; font-weight: bold;"
											readonly="readonly" value="${invoice.balanceAmt}" /></td>
										<td>${invoice.createdAt}</td>
										<td>${invoice.createdBy}</td>

										
	<%-- 									<c:choose>
    <c:when test="${invoice.filePath==null}">
   Not uploaded
        <br />
    </c:when>    
    <c:otherwise>
      
        <br />
    </c:otherwise>
</c:choose> --%>
											
											
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
			"sScrollX": "100%",
                            "sScrollXInner": "105%",
				lengthMenu : [ [ 5, 10, 25, -1 ], [ 5, 10, 25, 'All' ] ]
			});
		});
	</script>
	</c:if>
</body>
</html>