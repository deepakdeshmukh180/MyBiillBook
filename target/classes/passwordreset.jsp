<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Password Reset - My Bill Book</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>

    <style>
        body {
            font-family: 'Raleway', sans-serif;
            background-color: #f5f8fa;
        }
        .card {
            border-radius: 8px;
            box-shadow: 0 2px 10px rgb(0 0 0 / 0.1);
        }
        .card-header {
            background-color: #343a40;
            color: white;
            font-weight: 600;
        }
        label {
            font-weight: 600;
        }
        .error-text {
            color: red;
            font-size: 0.85rem;
            display: none;
        }
        .alert {
            font-size: 0.95rem;
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
            border-radius: 6px;
            opacity: 1;
            transition: opacity 0.5s ease-out;
        }
        .alert i {
            font-size: 1rem;
            vertical-align: middle;
        }
    </style>
</head>

<body class="sb-nav-fixed">

    <!-- Top Navbar -->
    <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
        <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">
            My <i class="fa fa-calculator" style="font-size:20px;color:red"></i> Bill Book
        </a>
        <button class="btn btn-link btn-sm order-1 order-lg-0 me-4" id="sidebarToggle"><i class="fas fa-bars"></i></button>
        <ul class="navbar-nav ms-auto me-3 me-lg-4">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" data-bs-toggle="dropdown">
                    <i class="fas fa-user fa-fw"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                    <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <!-- Layout -->
    <div id="layoutSidenav">
        <!-- Sidebar -->
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">
                            <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div>
                            All Customers
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">
                            <div class="sb-nav-link-icon"><i class="fas fa-file-invoice"></i></div>
                            Invoice Search
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">
                            <div class="sb-nav-link-icon"><i class="fas fa-chart-bar"></i></div>
                            Reports
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">
                            <div class="sb-nav-link-icon"><i class="fas fa-box"></i></div>
                            Products
                        </a>
                    </div>
                </div>
                <div class="sb-sidenav-footer">
                    <div class="small">Logged in as:</div>
                    ${pageContext.request.userPrincipal.name}
                </div>
            </nav>
        </div>

        <!-- Main Content -->
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4 mt-4">
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">Password Reset</li>
                    </ol>

                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-key me-1"></i>
                            Reset Your Password
                        </div>
                        <div class="card-body">

                            <!-- Alert Messages -->
                            <c:if test="${not empty success}">
                                <div class="alert alert-success fade show" role="alert">
                                    <i class="fas fa-check-circle me-2"></i> ${success}
                                </div>
                            </c:if>

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i> ${error}
                                </div>
                            </c:if>

                            <div class="row justify-content-center">
                                <div class="col-md-6">
                                    <form action="${pageContext.request.contextPath}/reset-pass" method="post" id="resetForm">
                                        <!-- Email -->
                                        <div class="mb-3">
                                            <label for="email" class="form-label">Username</label>
                                            <input type="email" class="form-control" id="email" name="email" value="${pageContext.request.userPrincipal.name}" readonly>
                                        </div>

                                        <!-- New Password -->
                                        <div class="mb-3">
                                            <label for="newPassword" class="form-label">New Password</label>
                                            <div class="input-group">
                                                <input type="password" class="form-control" id="newPassword" name="newPassword" minlength="6" required>
                                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('newPassword', this)">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Confirm Password -->
                                        <div class="mb-3">
                                            <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                            <div class="input-group">
                                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" minlength="6" required>
                                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('confirmPassword', this)">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            <span id="passwordError" class="error-text">Passwords do not match.</span>
                                        </div>

                                        <!-- CSRF -->
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                        <!-- Submit -->
                                        <div class="d-grid gap-2">
                                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Reset Password</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>
            </main>

            <!-- Footer -->
            <footer class="py-4 bg-light mt-auto">
                <div class="container-fluid px-4">
                    <div class="d-flex justify-content-between small">
                        <div class="text-muted">Copyright &copy; My Bill Book 2025</div>
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

    <!-- Logout Form -->
    <form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

    <script>
        function togglePassword(fieldId, btn) {
            const field = document.getElementById(fieldId);
            const icon = btn.querySelector('i');
            if (field.type === "password") {
                field.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                field.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }

        document.getElementById("resetForm").addEventListener("submit", function (e) {
            const newPass = document.getElementById("newPassword").value;
            const confirmPass = document.getElementById("confirmPassword").value;
            const errorText = document.getElementById("passwordError");

            if (newPass !== confirmPass) {
                e.preventDefault();
                errorText.style.display = "block";
            } else {
                errorText.style.display = "none";
            }
        });

        // Auto-hide all alerts after 3 seconds
        window.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('.alert').forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 500);
                }, 3000);
            });
        });
    </script>
</body>
</html>
