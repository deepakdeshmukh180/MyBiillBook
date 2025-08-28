<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Dashboard - SB Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
         <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    </head>

    <style>
    @import url(https://fonts.googleapis.com/css?family=Raleway:300,400,600);


    body{
        margin: 0;
        font-size: .9rem;
        font-weight: 400;
        line-height: 1.6;
        color: #212529;
        text-align: left;
        background-color: #f5f8fa;
    }

    .navbar-laravel
    {
        box-shadow: 0 2px 4px rgba(0,0,0,.04);
    }

    .navbar-brand , .nav-link, .my-form, .login-form
    {
        font-family: Raleway, sans-serif;
    }

    .my-form
    {
        padding-top: 1.5rem;
        padding-bottom: 1.5rem;

    }

    .my-form .row
    {
      padding-top: 2%;
        margin-left: 0;
        margin-right: 0;
    }

    .login-form
    {
        padding-top: 1.5rem;
        padding-bottom: 1.5rem;
    }

    .login-form .row
    {
        margin-left: 0;
        margin-right: 0;
    }

    </style>
    <body class="sb-nav-fixed">
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">My <i class="fa fa-calculator" style="font-size:20px;color:red"></i> Bill Book</a>
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
                                Menu
                                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                            </a>
                            <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
                                <nav class="sb-sidenav-menu-nested nav">
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

                                    <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#pagesCollapseError" aria-expanded="false" aria-controls="pagesCollapseError">
                                        Error
                                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                                    </a>

                                </nav>
                            </div>
                            <div class="sb-sidenav-menu-heading">Addons</div>
                            <a class="nav-link" href="${pageContext.request.contextPath}/login/password-reset-page">
                                <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                                Password Reset
                            </a>

                        </div>
                    </div>
                    <div class="sb-sidenav-footer">
                        <div class="small">Logged in as:</div>
                        ${pageContext.request.userPrincipal.name}
                    </div>
                </nav>
            </div>
            <div id="layoutSidenav_content">
                <main>
                    <div class="container-fluid px-4">
                       <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item active"></li>
                        </ol>



<main class="my-form">
    <div>
        <div class="row justify-content-center">
            <div class="col-md-8">
                    <div class="card" style="margin-top: -5%;">
                        <div class="card-header">Owner Profile Detail</div>
                        <div class="card-body">
                            <form name="my-form" modelAttribute="OwnerInfo" action="${pageContext.request.contextPath}/company/update-owner-details" method="POST">
                                <div class="form-group row">
                                    <label for="full_name" class="col-md-4 col-form-label text-md-right">User Name</label>
                                    <div class="col-md-6">
                                        <input type="text" readonly="true" id="full_name" class="form-control" value="${ownerInfo.userName}" name="username">
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label for="email_address" class="col-md-4 col-form-label text-md-right">Shop Name</label>
                                    <div class="col-md-6">
                                        <input type="text" id="email_address" class="form-control" value="${ownerInfo.shopName}" name="shopName">
                                    </div>
                                </div>
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <div class="form-group row">
                                    <label for="user_name" class="col-md-4 col-form-label text-md-right">Shop Address</label>
                                    <div class="col-md-6">
                                        <input type="text" id="user_name" class="form-control" value="${ownerInfo.address}" name="address">
                                    </div>
                                </div>
                                <div class="form-group row">
                                                                    <label for="user_name" class="col-md-4 col-form-label text-md-right">Shop Owner</label>
                                                                    <div class="col-md-6">
                                                                        <input type="text" id="user_name" class="form-control" value="${ownerInfo.ownerName}" name="ownerName">
                                                                    </div>
                                                                </div>
<input type="hidden" name="ownerId" value="${ownerInfo.ownerId}">
                                <div class="form-group row">
                                    <label for="phone_number" class="col-md-4 col-form-label text-md-right">Phone Number</label>
                                    <div class="col-md-6">
                                        <input type="text" id="phoneNo" name="mobNumber" value="${ownerInfo.mobNumber}" class="form-control">
                                    </div>
                                </div>
                                 <div class="form-group row">
                                                                    <label for="phone_number" class="col-md-4 col-form-label text-md-right">Email</label>
                                                                    <div class="col-md-6">
                                                                        <input type="text" id="phoneNo" name="email" value="${ownerInfo.email}" class="form-control">
                                                                    </div>
                                                                </div>
                                                                 <div class="form-group row">
                                                                                                                                    <label for="phone_number" class="col-md-4 col-form-label text-md-right">GST</label>
                                                                                                                                    <div class="col-md-6">
                                                                                                                                        <input type="text" id="phoneNo" name="gstNumber" value="${ownerInfo.gstNumber}" class="form-control">
                                                                                                                                    </div>
                                                                                                                                </div>
                                                                <div class="form-group row">
                                                                                                                                    <label for="phone_number" class="col-md-4 col-form-label text-md-right">LC No. </label>
                                                                                                                                    <div class="col-md-6">
                                                                                                                                        <input type="text" id="phoneNo" name="lcNo" value="${ownerInfo.lcNo}" class="form-control">
                                                                                                                                    </div>
                                                                                                                                </div>

                                                                                                                                       <div class="form-group row">
                                                                                                                                                                                                                                                                    <label for="phone_number" class="col-md-4 col-form-label text-md-right">Plan Valid upto Date </label>
                                                                                                                                                                                                                                                                    <div class="col-md-6">
                                                                                                                                                                                                                                                                    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                                                                                                                                                                                                                                                                        <input type="text" id="phoneNo" readonly="true"  value="<fmt:formatDate value="${ownerInfo.expDate}" pattern="dd/MM/yyyy hh:mm a"/>" class="form-control readonly">
                                                                                                                                                                                                                                                                    </div>
                                                                                                                                                                                                                                                                </div>

                                                                                                                                                                                                                                                                <div class="form-group row">
                                                                                                                                                                                                                                                                                                        <label class="col-md-4 col-form-label text-md-right">Invoice Type</label>
                                                                                                                                                                                                                                                                                                        <div class="col-md-6">
                                                                                                                                                                                                                                                                                                            <select name="invoiceType" class="form-control">
                                                                                                                                                                                                                                                                                                                <option value="A4" ${ownerInfo.invoiceType == 'A4' ? 'selected' : ''}>A4-Page-size</option>
                                                                                                                                                                                                                                                                                                                <option value="A0" ${ownerInfo.invoiceType == 'A0' ? 'selected' : ''}>4X6-Thermal</option>
                                                                                                                                                                                                                                                                                                            </select>
                                                                                                                                                                                                                                                                                                        </div>
                                                                                                                                                                                                                                                                                                    </div>
 <div class="form-group row">
                                                                                                                                                                                                                                                                                                                                                                                                    <label for="upiId" class="col-md-4 col-form-label text-md-right">UPI ID </label>
                                                                                                                                                                                                                                                                                                                                                                                                    <div class="col-md-6">
                                                                                                                                                                                                                                                                                                                                                                                                        <input type="text" id="phoneNo"  name="upiId" value="${ownerInfo.upiId}" class="form-control">
                                                                                                                                                                                                                                                                                                                                                                                                    </div>
                                                                                                                                                                                                                                                                                                                                                                                                </div>
                                                                                                                                                                                                                                                                       <div class="form-group row">
                                                                                                                                                                                                                                                                                                                                                                                                    <label for="phone_number" class="col-md-4 col-form-label text-md-right">Status </label>
                                                                                                                                                                                                                                                                                                                                                                                                    <div class="col-md-6">
                                                                                                                                                                                                                                                                                                                                                                                                        <input type="text" id="phoneNo" readonly="true" name="status" value="${ownerInfo.status}" class="form-control">
                                                                                                                                                                                                                                                                                                                                                                                                    </div>
                                                                                                                                                                                                                                                                                                                                                                                                </div>
   <div class="form-group row"><div class="col-md-6 offset-md-4">
                                        <button type="submit" class="btn btn-primary">
                                        Update
                                        </button>


                                    </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <c:if test="${not empty msg}">
                                                                                          <div class="alert alert-success alert-dismissible fade show mt-3" role="alert" id="success-alert">
                                                                                            <strong>Success!</strong> ${msg}
                                                                                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                                                                          </div>

                                                                                          <script>
                                                                                            window.onload = function () {
                                                                                              setTimeout(function () {
                                                                                                const alert = bootstrap.Alert.getOrCreateInstance(document.getElementById('success-alert'));
                                                                                                alert.close();
                                                                                              }, 4000);
                                                                                            };
                                                                                          </script>
                                                                                        </c:if>
            </div>
        </div>
    </div>

</main>
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
	<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        </form>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
        <script src="${pageContext.request.contextPath}/resources/assets/demo/chart-area-demo.js"></script>
        <script src="${pageContext.request.contextPath}/resources/assets/demo/chart-bar-demo.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>
        <script src="${pageContext.request.contextPath}/resources/js/timeout.js" crossorigin="anonymous"></script>
    </body>
</html>
