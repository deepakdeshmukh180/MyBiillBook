<!DOCTYPE html>
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
	width: 60%;
	margin: 90px auto 0 auto;
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
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">
<section class="content-header">
		<h1>
			Add <small>New Customer</small>
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
	<div class="form-box" id="login-box">
		<div class="header">Add New Customer</div>
		<form
			action="${pageContext.request.contextPath}/login/save-profile-details"
			method="post" modelAttribute="CustProfile">
			<div class="body bg-gray">
				<div class="row">
					<div class="col-sm-8">
						<div class="form-group">
							<input type="text" name="custName" class="form-control"
								placeholder="Cutomer name" required = "required" />
						</div>
					</div>
					<div class="col-sm-4">
						<div class="form-group">
							<input type="text" name="gstNo" class="form-control"
								placeholder="PAN No." />
						</div>
					</div>
				</div>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<input type="text" name="address1" class="form-control"
								placeholder="Street address or P.O. Box" />
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<input type="text" name="address2" class="form-control"
								placeholder="apt /suite/ unit/ building/ floor/ etc" />
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<input type="text" name="city" required = "required" class="form-control"
								placeholder="City" />
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<input type="text" name="pincode" class="form-control"
								placeholder="Pin Code" />
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<input type="text" name="phoneNo" pattern=".{10}" required = "required" class="form-control"
								placeholder="Phone No." />
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<input type="text" name="email" class="form-control"
								placeholder="Email Id" />
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-4">
						<div class="form-group">
							<input type="text" required = "required" id="totalAmount" name="totalAmount" class="form-control amount"
								placeholder="Total Amount" />
						</div>
					</div>
					<div class="col-sm-4">
						<div class="form-group">
							<input type="text" required = "required" id="paidAmout" name="paidAmout" onkeyup="calAmt()" class="form-control amount"
								placeholder="Paid Amount" />
						</div>
					</div>
					<div class="col-sm-4">
						<div class="form-group">
							<input type="text" readonly="readonly"  id="currentOusting"  name="currentOusting" class="form-control"
								placeholder="Balance" />
						</div>
					</div>
				</div>


				<div class="footer">
					<button type="submit" class="btn bg-olive btn-block">Create
						Profile</button>
				</div>
		</form>


		<div class="margin text-center">
			<span>Register using social networks</span> <br />
			<button class="btn bg-light-blue btn-circle">
				<i class="fa fa-facebook"></i>
			</button>
			<button class="btn bg-aqua btn-circle">
				<i class="fa fa-twitter"></i>
			</button>
			<button class="btn bg-red btn-circle">
				<i class="fa fa-google-plus"></i>
			</button>

		</div>
	</div>

<script type="text/javascript">

function calAmt() {

let amount = document.querySelector('#paidAmout'), preAmount = amount.value;
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
	var totalAmount = document.getElementById("totalAmount").value;
	var  paidAmout = document.getElementById("paidAmout").value;
	  var total = parseFloat(totalAmount) - parseFloat(paidAmout);
	  var fixedNum = parseFloat(total).toFixed(2);
	  document.getElementById('currentOusting').value= fixedNum;
	}

	let amount = document.querySelector('.amount'), preAmount = amount.value;
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
	<!-- jQuery 2.0.2 -->
	<script
		src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
	<!-- Bootstrap -->
	<script
		src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"
		type="text/javascript"></script>
</c:if>
</body>
</html>