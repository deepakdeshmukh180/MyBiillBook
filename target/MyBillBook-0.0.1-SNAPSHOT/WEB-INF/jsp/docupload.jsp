<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<title>Bootstrap Example</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.6.3/dist/jquery.slim.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
	
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
</style>
<body>

	<div class="container">
		<h2 style=" margin-top: -7%; ">Student Info</h2>
		<table class="table fl-table table-bordered" >
			<thead>
				<tr>
					<th>Firstname</th>
					<th>Lastname</th>
					<th>Email</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>${stddto.firstName}</td>
					<td>${stddto.lastName}</td>
					<td>${stddto.mailId}</td>
				</tr>
			</tbody>
		</table>

		<form id="doc-upload-form" action="${pageContext.request.contextPath}/company/" method="post"
			role="form" modelAttribute="DOCSUP" enctype="multipart/form-data">

			<input type="hidden" name="stdId" value="${stddto.stdId}">
			<div class="form-row">
				<div class="col-md-4 mb-3">
					<label for="validationCustom01">Document Type</label> <select
						class="form-control" name="docType">
						<option value="Marksheet">Marksheet</option>
						<option value="Addhar Card">Addhar Card</option>
						<option value="Leaving Certificate">Leaving Certificate</option>
					</select>
				</div>
				<div class="col-md-4 mb-3">
					<label for="validationCustom01">Choose file</label>
					<div class="custom-file">
						<input type="file" name="file" class="custom-file-input"
							id="customFile"> <label class="custom-file-label"
							for="customFile">Choose file</label>
					</div>

				</div>


				<div class="col-md-4 mb-3" style="margin-top: 3%">

					<button class="btn btn-primary" type="submit">Upload</button>
				</div>
			</div>


		</form>


		<h2>Uploaded DOCS</h2>
		<table class="table fl-table table-bordered">
			<thead>
				<tr>
					<th>Doc Id</th>
					<th>Doc Type</th>
					<th>Doc Size</th>
					<th>Download</th>
					<th>Delete</th>
				</tr>
			</thead>
			<tbody>

				<c:forEach items="${doclist}" var="doc">
					<tr>
						<td>${doc.id}</td>
						<td>${doc.docType}</td>
						<td>${doc.docSize}</td>
						<td><a href="${home}/login/download-std-doc/${doc.path}">DOWNLOAD FILE</a></td>
						<td style="background-color: red; color: white;"><a style=" color: white;"  href="${home}/login/delete-std-doc/${doc.id}">DELETE FILE</a></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

	</div>

</body>
</html>
