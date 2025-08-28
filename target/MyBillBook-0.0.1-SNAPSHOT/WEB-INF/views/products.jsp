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
			Products Mgmt <small>Add/Updete/Delete</small>
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
			<li class="active">Products</li>
		</ol>
	</section>
	<!-- Main content -->
	<!-- /.content -->

	<!-- add new calendar event modal -->
	<section class="content container">
		<div class="row">

			<div class="col-xs-12">
				<div class="box">
					<div class="box-header">
						<h3 class="box-title">All Products</h3>
					</div>
					<!-- /.box-header -->
					<div class="box-body table-responsive">
						<table id="example1" class="table table-bordered table-striped">
							<thead>
								<tr>

									<th>Product Name</th>
									<th>Quantity</th>
									<th>Batch No</th>
									<th>Exp Date</th>
									<th>Available Stock</th>
									<th>MRP</th>
									<th>Price</th>
									<th>Edit</th>
<th>Delete</th>

								</tr>
							</thead>
							<tbody>
								<c:forEach items="${products}" var="product">
									<tr>

											<td style="text-align: left;">${product.productName}</td>
											<td style="text-align: center;">${product.quantity}</td>
											<td style="text-align: center;">${product.batchNo}</td>
											<td style="text-align: center;">${product.expdate}</td>
											<td style="text-align: center;">${product.stock}</td>
											<td style="text-align: center;">${product.mrp}</td>
											<td style="text-align: center;">${product.price}</td>
                                            <input type="hidden" name="productId" value="${product.productId}"/>

											<td style="text-align: center; width: 8%; "><button style="a" type="button" class="btn btn-primary align-items-center " data-toggle="modal" data-target="#myModal">Edit</button></td>

                                         <td style="text-align: center; width: 8%; ">  <form name="frm" method="get"
                                                                                                                                                                                       action="${pageContext.request.contextPath}/company/delete-product-by-id">
                                                                                                                                                                                       <input type="hidden" name="itemid" value="${product.productId}" /> <input
                                                                                                                                                                                          type="submit" class="btn btn-danger"  value="Delete"
                                                                                                                                                                                          onclick="{document.frm.hdnbt.value=this.value;document.frm.submit();}" />
                                                                                                                                                                                    </form></td>


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

		<div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog">

              <!-- Modal content-->
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal">&times;</button>
                  <h4 class="modal-title">Price Update</h4>
                </div>
                <div class="modal-body">
             <div class="row centered-form">
                     <div class="col-xs-12">
                     	<div class="panel panel-default">
                     		<div class="panel-heading">
             			    		<h3 class="panel-title">Update Product</h3>
             			 			</div>
             			 			<div class="panel-body">
             			    	 <form
                                               action="${pageContext.request.contextPath}/company/update-product"
                                               method="post" modelAttribute="PRODUCTS">

           <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>


             			    			<div class="row">
                                             			    				<div class="col-sm-8">
                                             			    					<div class="form-group">
                                             			                <input type="text" name="productName" id="productName" class="form-control" required="true" placeholder="Product Name">
                                             			    					</div>
                                             			    				</div>
                                             			    				<input type="hidden" name="custId" value="${profile.id}" required="true">
                                             			    				<div class="col-sm-4">
                                             			    					<div class="form-group">
                                                            <select class="form-control input-sm" id="sel1" name="quantity" onchange="cityChanged(this.value)">
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
                                                                                           <option value="4Ltr" >4 Ltr</option>
                                                                                          <option value="5Ltr" >5 Ltr</option>
                                                                                          <option value="10Ltr">10 Ltr</option>
                                                                                          <option value="20Ltr">20 Ltr</option>
                                                                                        </select>
                                             			    					</div>
                                             			    				</div>
                                             			    			</div>
                                             			    			<div class="row">
                                                                             			    			<div class="col-sm-6" style="cursor: pointer;">
                                                                             			    					<div class="form-group">
                                                                             			                <input type="text" name="batchNo" id="batchNo" class="form-control input-sm" placeholder="Batch No.">
                                                                             			    					</div>
                                                                             			    				</div>
                                                                             			    				<div class="col-sm-6">
                                                                             			    					<div class="form-group">
                                                                             			    						<input type="text" required="true" name="price" id="price" class="form-control input-sm" placeholder="Update Product Price in Rs.">
                                                                             			    					</div>
                                                                             			    				</div>
                                                                             			    			</div>

  <input type="hidden" name="productId" id="productIdp"/>
             	    			    <input type="submit" value="Update Product" class="btn btn-info btn-block">

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

		var table = document.getElementById("example1");
        if (table) {
          for (var i = 0; i < table.rows.length; i++) {
            table.rows[i].onclick = function() {
              tableText(this);
                      var abc = $(this).closest("tr").find('[name="productId"]').val()
              $('#productIdp').val(abc);
            };
          }
        }

        function tableText(tableRow) {
          document.getElementById("productName").value = tableRow.childNodes[1].innerHTML;
              $('#sel1').val(tableRow.childNodes[3].innerHTML);
               $('#batchNo').val(tableRow.childNodes[5].innerHTML);
                $('#price').val(tableRow.childNodes[9].innerHTML);
   $('#productIdp').val();


        }

        function cityChanged(city) {
             $('#sel1').val(city);
        }
	</script>
	</c:if>
</body>
</html>