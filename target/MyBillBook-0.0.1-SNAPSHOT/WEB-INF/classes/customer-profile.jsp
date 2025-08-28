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

    <style>
        @import url('https://fonts.googleapis.com/css?family=Raleway:300,400,600');

        body {
            margin: 0;
            font-size: .9rem;
            font-weight: 400;
            line-height: 1.6;
            color: #212529;
            text-align: left;
            background-color: #f5f8fa;
            font-family: 'Raleway', sans-serif;
        }

        .navbar-laravel {
            box-shadow: 0 2px 4px rgba(0,0,0,.04);
        }

        .navbar-brand, .nav-link, .my-form, .login-form {
            font-family: 'Raleway', sans-serif;
        }

        .my-form, .login-form {
            padding-top: 1.5rem;
            padding-bottom: 1.5rem;
        }

        .my-form .row, .login-form .row {
            margin-left: 0;
            margin-right: 0;
        }

        .card {
            border-radius: 8px;
            box-shadow: 0 2px 10px rgb(0 0 0 / 0.1);
        }

        .card-header {
            font-weight: 600;
            font-size: 1.25rem;
            background-color: #343a40;
            color: white;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }

        label {
            font-weight: 600;
        }

        .btn-group {
            margin-top: 1.5rem;
        }
    </style>
</head>

<body class="sb-nav-fixed">
    <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
        <!-- Navbar Brand-->
        <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">
            My <i class="fa fa-calculator" style="font-size:20px;color:red"></i> Bill Book
        </a>
        <!-- Sidebar Toggle-->
        <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!">
            <i class="fas fa-bars"></i>
        </button>
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
                <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user fa-fw"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                    <li><hr class="dropdown-divider" /></li>
                    <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
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
                                <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">All Customers</a>
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
                    ${pageContext.request.userPrincipal.name}
                </div>
            </nav>
        </div>

        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">Customer View</li>
                    </ol>

                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-users me-1"></i>
                            Update Customer Details
                        </div>
                        <div class="card-body">
                            <main class="my-form">
                                <div class="container">
                                    <div class="row justify-content-center">
                                        <div class="col-md-8">
                                            <div class="card">
                                                <div class="card-header">Update Customer Detail</div>
                                                <div class="card-body">
                                                    <form name="my-form" modelAttribute="CustProfile" action="${pageContext.request.contextPath}/login/update-profile-details" method="POST" novalidate>
                                                        <div class="mb-3 row">
                                                            <label for="full_name" class="col-md-4 col-form-label text-md-end">Full Name</label>
                                                            <div class="col-md-6">
                                                                <input type="text" id="full_name" class="form-control" value="${profile.custName}" name="custName" required />
                                                            </div>
                                                        </div>

                                                        <div class="mb-3 row">
                                                            <label for="address" class="col-md-4 col-form-label text-md-end">Address</label>
                                                            <div class="col-md-6">
                                                                <input type="text" id="address" class="form-control" value="${profile.address}" name="address" required />
                                                            </div>
                                                        </div>

                                                        <div class="mb-3 row">
                                                            <label for="email_address" class="col-md-4 col-form-label text-md-end">E-Mail</label>
                                                            <div class="col-md-6">
                                                                <input type="email" id="email_address" class="form-control" value="${profile.email}" name="email" required />
                                                            </div>
                                                        </div>

                                                        <div class="mb-3 row">
                                                            <label for="phoneNo" class="col-md-4 col-form-label text-md-end">Phone Number</label>
                                                            <div class="col-md-6">
                                                                <input type="tel" id="phoneNo" name="phoneNo" value="${profile.phoneNo}" class="form-control" pattern="[0-9]{10}" title="Please enter a 10 digit phone number" required />
                                                            </div>
                                                        </div>

                                                        <div class="mb-3 row">
                                                            <label for="addharNo" class="col-md-4 col-form-label text-md-end">Aadhaar Number</label>
                                                            <div class="col-md-6">
                                                                <input type="text" id="addharNo" pattern="\d{12}" title="Please enter a valid 12-digit Aadhaar number" minlength="12" maxlength="12" name="addharNo" value="${profile.addharNo}" class="form-control" required />
                                                            </div>
                                                        </div>

                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                        <input type="hidden" name="id" value="${profile.id}" />

                                                        <div class="row mb-3">
                                                            <div class="col-md-6 offset-md-4 d-flex gap-3">
                                                                <button type="submit" name="action" value="update" class="btn btn-primary flex-fill">
                                                                    Update
                                                                </button>
                                                                <button type="submit" name="action" value="delete" class="btn btn-danger flex-fill" onclick="return confirm('Are you sure you want to delete this customer?');">
                                                                    Delete
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
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
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
    <script src="${pageContext.request.contextPath}/resources/assets/demo/chart-area-demo.js"></script>
    <script src="${pageContext.request.contextPath}/resources/assets/demo/chart-bar-demo.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
    <script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>
</body>
</html>


def fun(name: str, age: int) -> str:
    if age < 18:
        return f"Hello, {name}. You are not old enough to use this app."

