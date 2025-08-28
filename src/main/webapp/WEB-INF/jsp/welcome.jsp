<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
<script
	src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<link
	href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">

</head>
<style>
@import
	url('https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css')
	;

@media ( min-width :768px) {
	body {
		margin-top: 50px;
	}
	/*html, body, #wrapper, #page-wrapper {height: 100%; overflow: hidden;}*/
}


*{
    box-sizing: border-box;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
}
body{
    font-family: Helvetica;
    -webkit-font-smoothing: antialiased;
   
}
h2{
    text-align: center;
    font-size: 18px;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: white;
    padding: 30px 0;
}

/* Table Styles */

.table-wrapper{
    margin: 10px 70px 70px;
    box-shadow: 0px 35px 50px rgba( 0, 0, 0, 0.2 );
}

.fl-table {
    border-radius: 5px;
    font-size: 12px;
    font-weight: normal;
    border: none;
    border-collapse: collapse;
    width: 100%;
    max-width: 100%;
    white-space: nowrap;
    background-color: white;
}

.fl-table td, .fl-table th {
    text-align: center;
    padding: 8px;
}

.fl-table td {
    border-right: 1px solid #f8f8f8;
    font-size: 12px;
}

.fl-table thead th {
    color: #ffffff;
    background: #4FC3A1;
}


.fl-table thead th:nth-child(odd) {
    color: #ffffff;
    background: #324960;
}

.fl-table tr:nth-child(even) {
    background: #F8F8F8;
}

/* Responsive */

@media (max-width: 767px) {
    .fl-table {
        display: block;
        width: 100%;
    }
    .table-wrapper:before{
        content: "Scroll horizontally >";
        display: block;
        text-align: right;
        font-size: 11px;
        color: white;
        padding: 0 0 10px;
    }
    .fl-table thead, .fl-table tbody, .fl-table thead th {
        display: block;
    }
    .fl-table thead th:last-child{
        border-bottom: none;
    }
    .fl-table thead {
        float: left;
    }
    .fl-table tbody {
        width: auto;
        position: relative;
        overflow-x: auto;
    }
    .fl-table td, .fl-table th {
        padding: 20px .625em .625em .625em;
        height: 60px;
        vertical-align: middle;
        box-sizing: border-box;
        overflow-x: hidden;
        overflow-y: auto;
        width: 120px;
        font-size: 13px;
        text-overflow: ellipsis;
    }
    .fl-table thead th {
        text-align: left;
        border-bottom: 1px solid #f7f7f9;
    }
    .fl-table tbody tr {
        display: table-cell;
    }
    .fl-table tbody tr:nth-child(odd) {
        background: none;
    }
    .fl-table tr:nth-child(even) {
        background: transparent;
    }
    .fl-table tr td:nth-child(odd) {
        background: #F8F8F8;
        border-right: 1px solid #E6E4E4;
    }
    .fl-table tr td:nth-child(even) {
        border-right: 1px solid #E6E4E4;
    }
    .fl-table tbody td {
        display: block;
        text-align: center;
    }
}
table {
  width: 100%;
  border-collapse: collapse;
}

td {
  border: 1px solid black;
}

/* try removing the "hack" below to see how the table overflows the .body */
.hack1 {
  display: table;
  table-layout: fixed;
  width: 100%;
}

.hack2 {
  display: table-cell;
  overflow-x: auto;
  width: 100%;
}

#wrapper {
	padding-left: 0;
}

#page-wrapper {
	width: 100%;
	padding: 0;
	background-color: #fff;
}

@media ( min-width :768px) {
	#wrapper {
		padding-left: 225px;
	}
	#page-wrapper {
		padding: 22px 10px;
	}
}

/* Top Navigation */
.top-nav {
	padding: 0 15px;
}

.top-nav>li {
	display: inline-block;
	float: left;
}

.top-nav>li>a {
	padding-top: 20px;
	padding-bottom: 20px;
	line-height: 20px;
	color: #fff;
}

.top-nav>li>a:hover, .top-nav>li>a:focus, .top-nav>.open>a, .top-nav>.open>a:hover,
	.top-nav>.open>a:focus {
	color: #fff;
	background-color: #1a242f;
}

.card-registration .select-input.form-control[readonly]:not([disabled])
	{
	font-size: 1rem;
	line-height: 2.15;
	padding-left: .75em;
	padding-right: .75em;
}

.card-registration .select-arrow {
	top: 13px;
}

.top-nav>.open>.dropdown-menu {
	float: left;
	position: absolute;
	margin-top: 0;
	/*border: 1px solid rgba(0,0,0,.15);*/
	border-top-left-radius: 0;
	border-top-right-radius: 0;
	background-color: #fff;
	-webkit-box-shadow: 0 6px 12px rgba(0, 0, 0, .175);
	box-shadow: 0 6px 12px rgba(0, 0, 0, .175);
}

.top-nav>.open>.dropdown-menu>li>a {
	white-space: normal;
}

/* Side Navigation */
@media ( min-width :768px) {
	.side-nav {
		position: fixed;
		top: 60px;
		left: 225px;
		width: 225px;
		margin-left: -225px;
		border: none;
		border-radius: 0;
		border-top: 1px rgba(0, 0, 0, .5) solid;
		overflow-y: auto;
		background-color: #222;
		/*background-color: #5A6B7D;*/
		bottom: 0;
		overflow-x: hidden;
		padding-bottom: 40px;
	}
	.side-nav>li>a {
		width: 225px;
		border-bottom: 1px rgba(0, 0, 0, .3) solid;
	}
	.side-nav li a:hover, .side-nav li a:focus {
		outline: none;
		background-color: #1a242f !important;
	}
}

.side-nav>li>ul {
	padding: 0;
	border-bottom: 1px rgba(0, 0, 0, .3) solid;
}

.side-nav>li>ul>li>a {
	display: block;
	padding: 10px 15px 10px 38px;
	text-decoration: none;
	/*color: #999;*/
	color: #fff;
}

.side-nav>li>ul>li>a:hover {
	color: #fff;
}

.navbar .nav>li>a>.label {
	-webkit-border-radius: 50%;
	-moz-border-radius: 50%;
	border-radius: 50%;
	position: absolute;
	top: 14px;
	right: 6px;
	font-size: 10px;
	font-weight: normal;
	min-width: 15px;
	min-height: 15px;
	line-height: 1.0em;
	text-align: center;
	padding: 2px;
}

.navbar .nav>li>a:hover>.label {
	top: 10px;
}

.navbar-brand {
	padding: 5px 15px;
}
</style>

<body>
	<div id="throbber" style="display: none; min-height: 120px;"></div>
	<div id="noty-holder"></div>
	<div id="wrapper">
		<!-- Navigation -->
		<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-ex1-collapse">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand"
					href="${pageContext.request.contextPath}/login/welcome"> <img
					src="http://placehold.it/200x50&text=LOGO" alt="LOGO">
				</a>
			</div>
			<!-- Top Menu Items -->
			<ul class="nav navbar-right top-nav">
				<li><a href="#" data-placement="bottom" data-toggle="tooltip"
					href="#" data-original-title="Stats"><i
						class="fa fa-bar-chart-o"></i> </a></li>
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown"><div id="username1">${user}</div> <b class="fa fa-angle-down"></b></a>
					<ul class="dropdown-menu">
						<li><a href="#"><i class="fa fa-fw fa-user"></i> Edit
								Profile</a></li>
						<li><input type="button" class="btn btn-primary"
							value="Change Password" onclick="showChangepassword()"
							style="padding-right: 68%;"></li>
						<li class="divider"></li>
						<li><a href="${pageContext.request.contextPath}/login/logout"><i
								class="fa fa-fw fa-power-off"></i> Logout</a></li>
					</ul></li>
			</ul>
			<!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
			<div class="collapse navbar-collapse navbar-ex1-collapse">
				<ul class="nav navbar-nav side-nav">
					<li><a href="#" data-toggle="collapse"
						data-target="#submenu-1"><i class="fa fa-fw fa-search"></i>
							Student Section <i class="fa fa-fw fa-angle-down pull-right"></i></a>
						<ul id="submenu-1" class="collapse">
							<li><a onclick="showStdReg()"><i
									class="fa fa-angle-double-right"></i> New Student Registration</a></li>
							
							<li><a onclick="showStdRegView()"><i class="fa fa-angle-double-right"></i>
									VIEW STUDENTS</a></li>
							<li><a href="#"><i class="fa fa-angle-double-right"></i>
									SUBMENU 1.3</a></li>
						</ul></li>
					<li><a href="#" data-toggle="collapse"
						data-target="#submenu-2"><i class="fa fa-fw fa-star"></i> MENU
							2 <i class="fa fa-fw fa-angle-down pull-right"></i></a>
						<ul id="submenu-2" class="collapse">
							<li><a href="#"><i class="fa fa-angle-double-right"></i>
									SUBMENU 2.1</a></li>
							<li><a href="#"><i class="fa fa-angle-double-right"></i>
									SUBMENU 2.2</a></li>
							<li><a href="#"><i class="fa fa-angle-double-right"></i>
									SUBMENU 2.3</a></li>
						</ul></li>
					<li><a href="investigaciones/favoritas"><i
							class="fa fa-fw fa-user-plus"></i> MENU 3</a></li>
					<li><a href="sugerencias"><i
							class="fa fa-fw fa-paper-plane-o"></i> MENU 4</a></li>
					<li><a href="faq"><i
							class="fa fa-fw fa fa-question-circle"></i> MENU 5</a></li>
				</ul>
			</div>
			<!-- /.navbar-collapse -->
		</nav>

		<div id="page-wrapper">
			<div id="welcome" class="container-fluid">
				<!-- Page Heading -->
				<div class="row" id="main">
					<div class="col-sm-12 col-md-12 well" id="content">
						<h1>Welcome !</h1>
						<h1>${user}</h1>
					</div>
				</div>
				<!-- /.row -->
			</div>
			<!-- /.container-fluid -->
		</div>

		<div id="page-wrapper">
			<div id="changepassword" class="container-fluid">
				<!-- Page Heading -->
				<div class="row" id="main">
					<form id="login-form" action="/login/update-password" method="post"
						role="form" modelAttribute="LOGIN" style="display: block;">
						<div class="form-group">
							<input type="text" readonly="readonly" name="username"
								id="username" tabindex="1" class="form-control" value="${user}">
						</div>

						<div class="form-group">
							<input type="password" name="password" id="password" tabindex="2"
								class="form-control" placeholder="Old Password">
						</div>
						<div class="form-group">
							<input type="password" name="confirmPassword"
								id="confirmPassword" tabindex="2" class="form-control"
								placeholder="New Password">
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-sm-6 col-sm-offset-3">
									<input type="submit" class="btn btn-primary"
										name="register-submit" id="register-submit" tabindex="4"
										class="form-control btn btn-register" value="Change Password">
								</div>
							</div>
						</div>
					</form>
				</div>
				<!-- /.row -->
			</div>

            	<div id="std-view">
            	<h3 class="mb-5 text-uppercase">View Students Info</h3>
            	 <div class="hack1">
    <div class="hack2">
            	<table id="stdtbl" class="table fl-table table-bordered">
  <thead>
    <tr>
      <th scope="col">Std ID</th>
      <th scope="col">First Name </th>
      <th scope="col">Last Name</th>
      <th scope="col"> Father</th>
      <th scope="col"> Mother</th>
      <th scope="col"> DOB</th>
      <th scope="col"> Gender</th>
      <th scope="col"> Email</th>
      <th scope="col"> Address</th>
       <th scope="col"> CITY</th>
        <th scope="col"> State</th>
         <th scope="col"> Pincode</th>
         <th scope="col"> Upload</th>
           <th scope="col"> Update</th>
            <th scope="col"> Delete</th>
    </tr>
  </thead>
  <tbody id="stdtbltbody">
   
  </tbody>
</table>
</div>
</div>
            	</div>


			<div id="std-reg"
				class="row d-flex justify-content-center align-items-center h-100">
				<div class="col" style="margin-right: 3%; margin-left: 4%;">
					<div class="card card-registration my-4">
						<div class="row g-0">
							<div class="col-xl-6">
								<form id="form-std-reg">
									<div class="card-body p-md-5 text-black">
										<h3 class="mb-5 text-uppercase">Student registration form</h3>

										<div class="row">
											<div class="col-md-6 mb-4">
												<div class="form-outline">
													<label class="form-label" for="form3Example1m">First
														name</label> <input type="text" id="firstName" name="firstName"
														class="form-control form-control-lg" />
												</div>
											</div>
											<div class="col-md-6 mb-4">
												<div class="form-outline">
													<label class="form-label" for="form3Example1n">Last
														name</label> <input type="text" id="lastName" name="lastName"
														class="form-control form-control-lg" />
												</div>
											</div>
										</div>
                                       <input type="hidden" id="userid" value="${user}"/> 
                                        <input type="hidden" id="stdId"/> 
                                       
										<div class="row">
											<div class="col-md-6 mb-4">
												<div class="form-outline">
													<label class="form-label" for="form3Example1m1">Mother's
														name</label> <input type="text" id="mothersName"
														name="mothersName" class="form-control form-control-lg" />
												</div>
											</div>
											<div class="col-md-6 mb-4">
												<div class="form-outline">
													<label class="form-label" for="form3Example1n1">Father's
														name</label> <input type="text" id="fatherName" name="fatherName"
														class="form-control form-control-lg" />
												</div>
											</div>
										</div>

										<div class="form-outline mb-4">
											<label class="form-label" for="form3Example8">Address</label>
											<input type="text" id="address" name="address"
												class="form-control form-control-lg" />
										</div>

										<div>

											<h6 class="mb-0 me-4">Gender:</h6>

											<div class="form-check form-check-inline">
												<label class="form-check-label" for="inlineRadio1">Male</label>
												<input class="form-check-input" type="radio" name="gender"
													id="gender" value="MALE" />

											</div>

											<div class="form-check form-check-inline">
												<label class="form-check-label" for="inlineRadio2">Female</label>
												<input class="form-check-input" type="radio" name="gender"
													id="gender" value="FEMALE" />

											</div>



										</div>

										<div class="row">
											<div class="col-md-6">
												<label class="form-check-label" for="inlineRadio2">State</label>
												<select class="form-select" id="state" name="state">
													<option>State</option>
													<option value="MAHARASHTRA">MAHARASHTRA</option>
													<option value="TELANGANA">TELANGANA</option>
													<option value="MADHYAPRADESH">MADHYAPRADESH</option>
												</select>

											</div>
											<div class="col-md-6">
												<label class="form-check-label" for="inlineRadio2">City</label>
												<select class="form-select" id="city" name="city">
													<option>City</option>
													<option value="BULDHANA">BULDHANA</option>
													<option value="NAGPUR">NAGPUR</option>
													<option value="HYDERABAD">HYDERABAD</option>
												</select>

											</div>
										</div>
										<div class="row">
											<div class="col-md-6">
												<label class="form-label" for="form3Example9">DOB</label> <input
													type="date" id="dob" name="dob"
													class="form-control form-control-lg" />
											</div>

											<div class="col-md-6">
												<label class="form-label" for="form3Example90">Pincode</label>
												<input type="text" id="pincode" name="pincode"
													class="form-control form-control-lg" />
											</div>
										</div>
										<div class="row">
											<div class="col-md-6">
												<label class="form-label" for="form3Example99">Class</label>
												<input type="text" id="classs" name="classs"
													class="form-control form-control-lg" />
											</div>

											<div class="col-md-6">
												<label class="form-label" for="form3Example97">Email
													ID</label> <input type="text" id="mailId" name="mailId"
													class="form-control form-control-lg" />
											</div>
										</div>
										<div class="row">

											<button type="button" onclick="submitAjax()"
												class="btn btn-success">Submit form</button>
											<button type="reset" class="btn btn-light">Reset
												all</button>
											<div class="col-md-4">

												<div id="role_name" >
													

												</div>
											</div>
										</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>




			<!-- /.container-fluid -->
		</div>
		<!-- /#page-wrapper -->
	</div>
	<!-- /#wrapper -->
	
	

<div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
    <div id="page-wrapper">
      <form>
  <div class="custom-file">
    <input type="file" name="fileupload" class="custom-file-input" id="fileupload">
    <label class="custom-file-label" for="customFile">Choose file</label>
    <button id="upload-button" type="button" > Upload </button>
  </div>
</form>
</div>
    </div>
  </div>
</div>
	
</body>
<script>








async function uploadFile() {
	  let formData = new FormData(); 
	  formData.append("file", fileupload.files[0]);
	  
	  $.ajax({
			type : "POST",
			contentType : "application/json",
			url : "${home}upload-student-file",
			data : JSON.stringify(formData),
			dataType : 'json',
			timeout : 100000,
			success : function(data) {
				console.log("SUCCESS: ", data.stddto);
				
			},
			error : function() {
				console.log("ERROR: ");

			},
			done : function() {
				console.log("DONE");
			}
		});
	  
	  
	  
	}


$(".custom-file-input").on("change", function() {
	  var fileName = $(this).val().split("\\").pop();
	  $(this).siblings(".custom-file-label").addClass("selected").html(fileName);
	});

	$(function() {
		$('[data-toggle="tooltip"]').tooltip();
		$(".side-nav .collapse").on(
				"hide.bs.collapse",
				function() {
					$(this).prev().find(".fa").eq(1).removeClass(
							"fa-angle-right").addClass("fa-angle-down");
				});
		$('.side-nav .collapse').on(
				"show.bs.collapse",
				function() {
					$(this).prev().find(".fa").eq(1).removeClass(
							"fa-angle-down").addClass("fa-angle-right");
				});
	})

	$(document).ready(function() {
		document.getElementById('changepassword').hidden = true;
		document.getElementById('std-reg').hidden = true;
		document.getElementById('std-view').hidden = true;
	});

	function showChangepassword() {
		document.getElementById('welcome').hidden = true;
		document.getElementById('changepassword').hidden = false;
		document.getElementById('std-reg').hidden = true;
		document.getElementById('std-view').hidden = true;
	}
	function showStdReg() {
		document.getElementById('welcome').hidden = true;
		document.getElementById('changepassword').hidden = true;
		document.getElementById('std-reg').hidden = false;
		document.getElementById('std-view').hidden = true;

	}
	
	function showStdRegView(){
		
		document.getElementById('welcome').hidden = true;
		document.getElementById('changepassword').hidden = true;
		document.getElementById('std-reg').hidden = true;
		document.getElementById('std-view').hidden = false;
		
		var formdata = {
				userId : document.getElementById('userid').value
			};
		

		$("#stdtbltbody").empty();
		
		$.ajax({
			type : "POST",
			contentType : "application/json",
			url : "${home}get-std-by-user",
			data : JSON.stringify(formdata),
			dataType : 'json',
			timeout : 100000,
			success : function(data) {
				console.log("SUCCESS: ", data.listStd);
				
				$(data.listStd).each(function (index, item) {
                    console.log(item);
                    
                    
                    
                  

                    $('#stdtbl tbody').append(
                        '<tr><td>' + item.stdId +	
                        '</td><td>' + item.firstName +
                        '</td><td>' + item.lastName +
                        '</td><td>' + item.fatherName +
                        '</td><td>' + item.mothersName + 
                        '</td><td>' + item.dob +
                        '</td><td>' + item.gender + 
                        '</td><td>' + item.mailId +
                        '</td><td>' + item.address + 
                        '</td><td>' + item.city +
                        '</td><td>' + item.state + 
                        '</td><td>' + item.pincode +
                        '</td><td>'+  '<a href="${home}/login/upload-std-doc/'+item.stdId+'">UPLOAD-DOCS</a>' +
                        '</td><td>'+ '<button data-update-id="'+item.stdId+'" type="button" class="btn btn-info">' + 'Update' + '</button>' +
                        '</td><td>'+ '<button data-city-id="'+item.stdId+'" type="button" class="btn btn-danger">' + 'Delete' + '</button>' +
                        '</td></tr>'
                    )

                });
				
				
			},
			error : function() {
				console.log("ERROR: ");

			},
			done : function() {
				console.log("DONE");
			}
		});
		
		
		
	}
	
	
	

	function submitAjax() {

		var formdata = {

			firstName : document.getElementById('firstName').value,
			lastName : document.getElementById('lastName').value,
			mothersName : document.getElementById('mothersName').value,
			fatherName : document.getElementById('fatherName').value,
			address : document.getElementById('address').value,
			gender : document.getElementById('gender').value,
			state : document.getElementById('state').value,
			city : document.getElementById('city').value,
			dob : document.getElementById('dob').value,
			pincode : document.getElementById('pincode').value,
			classs : document.getElementById('classs').value,
			mailId : document.getElementById('mailId').value,
			userId : document.getElementById('userid').value,
			stdId : document.getElementById('stdId').value
		};

		console.log(formdata);

		$.ajax({
			type : "POST",
			contentType : "application/json",
			url : "${home}save-student",
			data : JSON.stringify(formdata),
			dataType : 'json',
			timeout : 100000,
			success : function(data) {
				console.log("SUCCESS: ", data.message);
				  $('#role_name').html(data.message).fadeIn('slow');
			        //$('#msg').html("data insert successfully").fadeIn('slow') //also show a success message 
			        $('#data.message').delay(5000).fadeOut('slow');
			},
			error : function() {
				console.log("ERROR: ");

			},
			done : function() {
				console.log("DONE");
			}
		});
	}
	
	
	
		$('#stdtbl').on('click', 'button.btn', function() {
			  let id = $(this).data('city-id');
			 
			  
			  
			  var formdata = {
						userId : document.getElementById('userid').value,
						stdId  : id
					};
				

				
				
				$.ajax({
					type : "POST",
					contentType : "application/json",
					url : "${home}/login/delete-student",
					data : JSON.stringify(formdata),
					dataType : 'json',
					timeout : 100000,
					success : function(data) {
						$("#stdtbltbody").empty();
						console.log("SUCCESS: ", data.listStd);
						
						$(data.listStd).each(function (index, item) {
		                    console.log(item);
		                    
		                    
		                    
		                  

		                    $('#stdtbl tbody').append(
		                        '<tr><td>' + item.stdId +	
		                        '</td><td>' + item.firstName +
		                        '</td><td>' + item.lastName +
		                        '</td><td>' + item.fatherName +
		                        '</td><td>' + item.mothersName + 
		                        '</td><td>' + item.dob +
		                        '</td><td>' + item.gender + 
		                        '</td><td>' + item.mailId +
		                        '</td><td>' + item.address + 
		                        '</td><td>' + item.city +
		                        '</td><td>' + item.state + 
		                        '</td><td>' + item.pincode +
		                        '</td><td>'+  '<a href="${home}/login/upload-std-doc/'+item.stdId+'">doc-upload</a>' +
		                        '</td><td>'+ '<button data-update-id="'+item.stdId+'" type="button" class="btn btn-info">' + 'Update' + '</button>' +
		                        '</td><td>'+ '<button data-city-id="'+item.stdId+'" type="button" class="btn btn-danger">' + 'Delete' + '</button>' +
		                         '</td></tr>'
		                    )

		                });
						
						
					},
					error : function() {
						console.log("ERROR: ");

					},
					done : function() {
						console.log("DONE");
					}
				});
				
			  
			  
			  
			  
			  
			  
			});
		
		
		
		$('#stdtbl').on('click', 'button.btn', function() {
			  let id = $(this).data('update-id');
			 
			  
			  
			  var formdata = {
						stdId  : id
					};
				

				
				
				$.ajax({
					type : "POST",
					contentType : "application/json",
					url : "${home}update-student",
					data : JSON.stringify(formdata),
					dataType : 'json',
					timeout : 100000,
					success : function(data) {
						console.log("SUCCESS: ", data.stddto);
						document.getElementById('welcome').hidden = true;
						document.getElementById('changepassword').hidden = true;
						document.getElementById('std-reg').hidden = false;
						document.getElementById('std-view').hidden = true;
						
						$('#firstName').val(data.stddto.firstName);
						$('#lastName').val(data.stddto.lastName);
						$('#mothersName').val(data.stddto.mothersName);
						$('#fatherName').val(data.stddto.fatherName);
						$('#classs').val(data.stddto.classs);
						$('#dob').val(data.stddto.dob);
						$('#pincode').val(data.stddto.pincode);
						$('#mailId').val(data.stddto.mailId);
						$('#address').val(data.stddto.address);
						$('#city').val(data.stddto.city);
						$('#state').val(data.stddto.state);
						$('#stdId').val(data.stddto.stdId);
						
					},
					error : function() {
						console.log("ERROR: ");

					},
					done : function() {
						console.log("DONE");
					}
				});
				
			  
			  
			  
			  
			  
			  
			});
	
	
	
</script>
</html>


