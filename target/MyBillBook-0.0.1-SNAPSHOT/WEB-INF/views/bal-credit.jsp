<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html class="bg-black">
<head>
<meta charset="UTF-8">
<title>AdminLTE | Registration Page</title>
<meta
	content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'
	name='viewport'>
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

<style type="text/css">


.form-box {
	width: 90%;
    margin-top: 0%;
}
.block {background-color: blue;width: 50vw;height: 50vh;margin: 1rem;}
.form-box1 {
	width: 90%;

}

.form-control {
    font: message-box;
    display: block;
    width: 100%;
    height: 34px;
    padding: 6px 12px;
    font-size: 15px;
    line-height: 1.428571429;
    color: #000;
    vertical-align: middle;
    background-color: #f7ffca;
    background-image: none;
    border: 1px solid #000;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
    box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
    -webkit-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
}
</style>
</head>
<body id="mainbody">
<c:if test="${pageContext.request.userPrincipal.name != null}">
<section class="content-header" >
		<h1>
		Credit <small>Balance Deposit / Returns items</small>
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
			<li class="active">Balance Credit</li>
		</ol>
	</section>
	<div class="form-box bg-gray" id="login-box">
		<div class="header">Balance Deposit / Returns items</div>
		<form
        			action="${pageContext.request.contextPath}/company/balance-credit"
        			method="post" modelAttribute="BalanceDeposite">
        			<div class="body">
        				<div class="row">
        				<div class="col-sm-4">
                        						<div class="form-group">
                        							<input type="text"  class="form-control" readonly="readonly"
                        								value="Cutomer Id :${profile.id}"  />
                        						</div>
                        					</div>
        					<div class="col-sm-8">
        						<div class="form-group">
        							<input type="text"  class="form-control" readonly="readonly"
        							value="Cutomer name : ${profile.custName} "/>
        						</div>
        					</div>

        				</div>


        				<div class="row">
        					<div class="col-sm-3">
        						<div class="form-group">
        							<input type="text" id="totalAmount" readonly="readonly"   class="form-control"
        								value= "Total Amount : ${profile.totalAmount}" placeholder="Total Amount" />
        						</div>
        					</div>
        					<div class="col-sm-3">
        						<div class="form-group">
        							<input type="text" value= "Paid Amount : ${profile.paidAmout}" id="paidAmout" readonly="readonly"  class="form-control"
        								placeholder="Paid Amount" />
        						</div>
        					</div>
        					<div class="col-sm-3">
        						<div class="form-group">
        							<input type="text" value= "Balance Amount : ${profile.currentOusting}" readonly="readonly"  id="currentOusting"   class="form-control"
        								placeholder="Balance" />
        						</div>
        					</div>
        					<div class="col-sm-3">
                                    						<div class="form-group">
                                    							<select required name= "modeOfPayment" class="form-select form-select-lg "  style="
                                                                                                                                                                     height: 34px;
                                                                                                                                                                     width: 226px;
                                                                                                                                                                 " >
                                                                                                                      <option  style="font-size: medium;text-align: center;"value="" selected>-- Payment Mode/Returns -- </option>
                                                                                                                      <option  style="font-size: medium;text-align: center;" value="Returns">Returns</option>
                                                                                                                      <option style="font-size: medium;text-align: center;" value="By GPay">GPay</option>
                                                                                                                      <option style="font-size: medium;text-align: center;" value="By PhonePe">PhonePe</option>
                                                                                                                      <option  style="font-size: medium;text-align: center;" value="By Cash">By Cash</option>
                                                                                                                       <option  style="font-size: medium;text-align: center;" value="Others">Others</option>
                                                                                                                    </select>
                                    						</div>
                                    					</div>
        				</div>

                        <input type="hidden" name="custId" value="${profile.id}"
        				<div class="row">


                        					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        					<div class="col-sm-3">
                                                            						<div class="form-group">
                                                            							<input type="text"  id="description"  name="description" class="form-control"
                                                            								placeholder="Description" />
                                                            						</div>
                                                            					</div>
                        					<div class="col-sm-3">
                        						<div class="form-group">
                        							<input type="text" id="advAmt"   name="advAmt" class="form-control"
                        							required = "required"	placeholder="Enter Deposit Amount" />
                        						</div>
                        					</div>
                        					<div class="col-sm-3">
                                                                    						<div class="form-group">

                                                                    						   <input id="startDate"  name="date" class="form-control datePicker" type="date" required = "required"	placeholder="Enter Deposited Date" />
                                                                    						</div>
                                                                    					</div>

                        					<div class="col-sm-1">
                                                                    					<button type="submit" style="width: 124px;" class="btn btn-success">Deposit</button>
                                                                    					</div>




                        				</div>



        		</form>

<table id= "tableMap" class="table " id="example1">
                      <thead >
                        <tr>

                          <th style="background-color: darkgoldenrod;">Transaction Id</th>
                         <th style="background-color: darkgoldenrod;"> Description</th>
                          <th style="background-color: darkgoldenrod;">Balance Amount </th>
                          <th style="background-color: darkgoldenrod;">Payment Mode </th>
                          <th style="background-color: darkgoldenrod;">Deposited Amt </th>
                          <th style="background-color: darkgoldenrod;">Date </th>
                        </tr>
                      </thead>
                     <tbody>
                             							<c:forEach items="${balanceDeposits}" var="balanceDeposit">
                             								<tr>

                             									<td>${balanceDeposit.id}</td>
                             									<td>${balanceDeposit.description}</td>
                             									<td>${balanceDeposit.currentOusting}</td>
                             									<td>${balanceDeposit.modeOfPayment}</td>
                             									<td>${balanceDeposit.advAmt}</td>
                             									<td>${balanceDeposit.date}</td>
                             									</td>
                             								</tr>
                             							</c:forEach>
                             					</tbody>
                    </table>

                    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>

	</div>


<script type="text/javascript">

function calAmt() {
	var totalAmount = document.getElementById("totalAmount").value;
	var  paidAmout = document.getElementById("paidAmout").value;
	  var total = parseFloat(totalAmount) - parseFloat(paidAmout);
	  var fixedNum = parseFloat(total).toFixed(2);
	  document.getElementById('currentOusting').value= fixedNum;
	}

	$.getScript(
        "https://code.jquery.com/color/jquery.color.js",
        () => console.log('loaded script!')
      ).done((script,textStatus ) => {
        console.log( document.getElementById("tableMap").outerHTML );

      }).fail(( jqxhr, settings, exception ) => {
        console.log(exception + ': ' + jqxhr.status);
      }
    );

</script>
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
    			<script type="text/javascript">
            		$(function() {
            			$("#example1").dataTable({
            				lengthMenu : [ [ 5, 10, 25, -1 ], [ 5, 10, 25, 'All' ] ]
            			});
            		});

            		let amount = document.querySelector('#advAmt'), preAmount = amount.value;
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
            	</script>
</c:if>
</body>
</html>