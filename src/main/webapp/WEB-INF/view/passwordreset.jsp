<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Password Reset - BillMatePro</title>

    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>

    <style>
        :root {
            --primary-color: #2247a5;
            --primary-dark: #145fa0;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --bg-light: #f8fafc;
            --bg-dark: #0f172a;
            --card-light: #ffffff;
            --card-dark: #1e293b;
            --text-light: #1e293b;
            --text-dark: #f1f5f9;
            --border-light: #e2e8f0;
            --border-dark: #334155;
            --radius-lg: 12px;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-color);
            color: var(--text-color);
            min-height: 100vh;
            transition: background 0.3s ease, color 0.3s ease;
        }

        [data-theme="light"] {
            --bg-color: var(--bg-light);
            --text-color: var(--text-light);
            --card-bg: var(--card-light);
            --border-color: var(--border-light);
        }

        [data-theme="dark"] {
            --bg-color: var(--bg-dark);
            --text-color: var(--text-dark);
            --card-bg: var(--card-dark);
            --border-color: var(--border-dark);
        }

        /* Page Loader */
        .page-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--bg-color);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 1;
            visibility: visible;
            transition: opacity 0.5s ease, visibility 0.5s ease;
        }

        .page-loader.hidden {
            opacity: 0;
            visibility: hidden;
        }

        .loader-spinner {
            width: 60px;
            height: 60px;
            border: 4px solid var(--border-color);
            border-top-color: var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Navigation */
        .sb-topnav {
            background: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        /* Sidebar */
        .sb-sidenav {
            background: var(--card-bg);
            border-right: 1px solid var(--border-color);
        }

        .sb-sidenav .nav-link {
            color: var(--text-color);
            border-radius: 8px;
            margin: 0.25rem 1rem;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .sb-sidenav .nav-link:hover {
            background: rgba(34, 71, 165, 0.1);
            transform: translateX(4px);
        }

        .sb-sidenav .nav-link.active {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
        }

        /* Modern Cards */
        .card-modern {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
        }

        .card-modern:hover {
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
        }

        .card-modern .card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border-bottom: none;
            border-radius: var(--radius-lg) var(--radius-lg) 0 0;
            padding: 1.25rem 1.5rem;
            font-weight: 600;
            font-size: 1.1rem;
        }

        /* Form Controls */
        .form-label {
            font-weight: 500;
            color: var(--text-color);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .form-control, .form-select {
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
            color: var(--text-color);
            font-size: 0.95rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(34, 71, 165, 0.1);
            background: var(--card-bg);
            color: var(--text-color);
        }

        .form-control:read-only {
            background: var(--border-color);
            cursor: not-allowed;
        }

        /* Password Strength Meter */
        .password-strength {
            margin-top: 0.5rem;
            height: 4px;
            background: var(--border-color);
            border-radius: 2px;
            overflow: hidden;
            display: none;
        }

        .password-strength.show {
            display: block;
        }

        .password-strength-bar {
            height: 100%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .strength-weak { width: 33%; background: var(--danger-color); }
        .strength-medium { width: 66%; background: var(--warning-color); }
        .strength-strong { width: 100%; background: var(--success-color); }

        .password-strength-text {
            font-size: 0.8rem;
            margin-top: 0.25rem;
            font-weight: 500;
        }

        .text-weak { color: var(--danger-color); }
        .text-medium { color: var(--warning-color); }
        .text-strong { color: var(--success-color); }

        /* Password Requirements */
        .password-requirements {
            background: rgba(34, 71, 165, 0.05);
            border-left: 3px solid var(--primary-color);
            padding: 1rem;
            border-radius: 6px;
            margin-top: 1rem;
            font-size: 0.85rem;
        }

        .requirement {
            display: flex;
            align-items: center;
            margin: 0.4rem 0;
            color: var(--text-color);
        }

        .requirement i {
            margin-right: 0.5rem;
            width: 16px;
        }

        .requirement.met {
            color: var(--success-color);
        }

        .requirement.unmet {
            color: var(--danger-color);
        }

        /* Buttons */
        .btn {
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border: none;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(34, 71, 165, 0.4);
        }

        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .btn-outline-secondary {
            border: 2px solid var(--border-color);
            color: var(--text-color);
        }

        .btn-outline-secondary:hover {
            background: var(--border-color);
            border-color: var(--border-color);
        }

        /* Theme Toggle */
        .theme-toggle {
            position: fixed;
            top: 5.5rem;
            right: 2rem;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 999;
            box-shadow: var(--shadow);
            color: var(--text-color);
        }

        .theme-toggle:hover {
            transform: scale(1.1) rotate(15deg);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }

        /* Alert Enhancement */
        .alert {
            border: none;
            border-radius: var(--radius-lg);
            border-left: 4px solid;
            box-shadow: var(--shadow);
            animation: slideInDown 0.3s ease;
            position: relative;
            padding-right: 3rem;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-success {
            border-left-color: var(--success-color);
            background: rgba(16, 185, 129, 0.1);
            color: var(--success-color);
        }

        .alert-danger {
            border-left-color: var(--danger-color);
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger-color);
        }

        .alert-close {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            font-size: 1.2rem;
            cursor: pointer;
            color: inherit;
            opacity: 0.7;
            transition: opacity 0.2s;
        }

        .alert-close:hover {
            opacity: 1;
        }

        /* Error Text */
        .error-text {
            color: var(--danger-color);
            font-size: 0.85rem;
            margin-top: 0.25rem;
            display: none;
        }

        .error-text.show {
            display: block;
            animation: shake 0.3s ease;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        /* Breadcrumb */
        .breadcrumb {
            background: transparent;
            padding: 0;
            margin-bottom: 1.5rem;
        }

        .breadcrumb-item.active {
            color: var(--text-color);
            font-weight: 500;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .theme-toggle {
                top: 1rem;
                right: 1rem;
                width: 45px;
                height: 45px;
            }

            .card-modern .card-header {
                font-size: 1rem;
                padding: 1rem 1.25rem;
            }
        }
    </style>
</head>

<body class="sb-nav-fixed" data-theme="light">

<!-- Page Loader -->
<div class="page-loader" id="pageLoader">
    <div class="text-center">
        <div class="loader-spinner mx-auto mb-3"></div>
        <div class="text-muted">Loading...</div>
    </div>
</div>

<!-- Theme Toggle -->
<div class="theme-toggle" onclick="toggleTheme()" title="Toggle theme">
    <i class="fas fa-moon" id="theme-icon"></i>
</div>

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-light">
    <a class="navbar-brand ps-3 fw-bold" href="${pageContext.request.contextPath}/login/home">
        <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgwIiBoZWlnaHQ9IjQwIiB2aWV3Qm94PSIwIDAgMTgwIDQwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iNSIgeTE9IjMiIHgyPSIyNSIgeTI9IjI3IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMyMjQ3QTUiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMTQ1RkEwIi8+CjwvbGluZWFyR3JhZGllbnQ+CjxsaW5lYXJHcmFkaWVudCBpZD0icGFpbnQxX2xpbmVhciIgeDE9IjE3IiB5MT0iMTMiIHgyPSIyOCIgeTI9IjI0IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMxMEI5ODEiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDU5NjY5Ii8+CjwvbGluZWFyR3JhZGllbnQ+CjwvZGVmcz4KPCEtLSBEb2N1bWVudC9CaWxsIEljb24gLS0+CjxyZWN0IHg9IjUiIHk9IjMiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyNCIgcng9IjMiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcikiLz4KPCEtLSBMaW5lcyBvbiBkb2N1bWVudCAtLT4KPHBhdGggZD0iTTkgOWg4bS04IDRINW0tNSAzaDciIHN0cm9rZT0iI2ZmZmZmZiIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPCEtLSBDaGVja21hcmsgLS0+CjxjaXJjbGUgY3g9IjIyLjUiIGN5PSIxOC41IiByPSI1LjUiIGZpbGw9InVybCgjcGFpbnQxX2xpbmVhcikiLz4KPHBhdGggZD0ibTIwIDE4LjUgMiAyIDQtNCIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8IS0tIFRleHQgLS0+Cjx0ZXh0IHg9IjM1IiB5PSIxNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmb250LXdlaWdodD0iNzAwIiBmaWxsPSIjMjI0N0E1Ij4KQmlsbE1hdGVQcm88L3RleHQ+Cjx0ZXh0IHg9IjM1IiB5PSIyNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjgiIGZpbGw9IiM2Mzc1OEEiPgpZb3VyIEJpbGxpbmcgUGFydG5lcjwvdGV4dD4KPC9zdmc+"
             alt="BillMatePro" style="height: 50px;">
    </a>
    <button class="btn btn-outline-primary btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>

    <div class="ms-auto d-flex align-items-center gap-3 pe-3">
        <c:if test="${not empty productList}">
            <div class="position-relative" role="button">
                <i class="bi bi-bell fs-5 text-primary"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                    ${fn:length(productList)}
                </span>
            </div>
        </c:if>
        <div class="dropdown">
            <a class="nav-link dropdown-toggle text-primary" id="navbarDropdown" href="#"
               data-bs-toggle="dropdown" aria-expanded="false" role="button">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                <li>
                    <h6 class="dropdown-header">
                        <i class="fas fa-user-circle me-2"></i>
                        ${pageContext.request.userPrincipal.name}
                    </h6>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/company/get-my-profile">
                        <i class="fas fa-cog me-2"></i>Account Settings
                    </a>
                </li>
                <li>
                    <a class="dropdown-item" href="#" onclick="event.preventDefault(); document.getElementById('logoutForm').submit();">
                        <i class="fas fa-sign-out-alt me-2"></i>Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div id="layoutSidenav">
    <!-- Sidebar -->
    <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion" id="sidenavAccordion">
            <div class="sb-sidenav-menu">
                <div class="nav">
                    <div class="sb-sidenav-menu-heading">Core</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login/home">
                        <div class="sb-nav-link-icon"><i class="fas fa-home"></i></div> Home
                    </a>

                    <div class="sb-sidenav-menu-heading">Interface</div>
                    <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts">
                        <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div> Menu
                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                    </a>
                    <div class="collapse show" id="collapseLayouts" data-bs-parent="#sidenavAccordion">
                        <nav class="sb-sidenav-menu-nested nav">
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">
                                <i class="fas fa-user-friends me-2"></i>All Customers
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">
                                <i class="fas fa-file-invoice me-2"></i>Invoices
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">
                                <i class="fas fa-chart-line me-2"></i>Daily/Monthly Reports
                            </a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">
                                <i class="fas fa-leaf me-2"></i>Products
                            </a>
                        </nav>
                    </div>

                    <div class="sb-sidenav-menu-heading">Settings</div>
                    <a class="nav-link active" href="${pageContext.request.contextPath}/reset-pass">
                        <div class="sb-nav-link-icon"><i class="fas fa-key"></i></div> Password Reset
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
                        <div class="sb-nav-link-icon"><i class="fas fa-cog"></i></div> Account Settings
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/export-to-pdf">
                        <div class="sb-nav-link-icon"><i class="fas fa-file-export"></i></div> Export Customers
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/expenses">
                        <div class="sb-nav-link-icon"><i class="fas fa-wallet"></i></div> Daily Expenses
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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/login/home">Home</a></li>
                    <li class="breadcrumb-item active">Password Reset</li>
                </ol>

                <div class="card-modern mb-4">
                    <div class="card-header">
                        <i class="fas fa-shield-alt me-2"></i>
                        Reset Your Password
                    </div>
                    <div class="card-body p-4">

                        <!-- Alert Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success" role="alert">
                                <i class="fas fa-check-circle me-2"></i> ${success}
                                <button class="alert-close" onclick="this.parentElement.remove();">&times;</button>
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i> ${error}
                                <button class="alert-close" onclick="this.parentElement.remove();">&times;</button>
                            </div>
                        </c:if>

                        <div class="row justify-content-center">
                            <div class="col-lg-8 col-xl-7">
                                <form action="${pageContext.request.contextPath}/reset-pass" method="post" id="resetForm">

                                    <!-- Email -->
                                    <div class="mb-4">
                                        <label for="email" class="form-label">
                                            <i class="fas fa-envelope me-1"></i> Username / Email
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email"
                                               value="${pageContext.request.userPrincipal.name}" readonly>
                                    </div>

                                    <!-- New Password -->
                                    <div class="mb-4">
                                        <label for="newPassword" class="form-label">
                                            <i class="fas fa-lock me-1"></i> New Password
                                        </label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="newPassword"
                                                   name="newPassword" minlength="6" required
                                                   placeholder="Enter new password">
                                            <button class="btn btn-outline-secondary" type="button"
                                                    onclick="togglePassword('newPassword', this)">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </div>
                                        <div class="password-strength" id="passwordStrength">
                                            <div class="password-strength-bar" id="strengthBar"></div>
                                        </div>
                                        <div class="password-strength-text" id="strengthText"></div>
                                    </div>

                                    <!-- Confirm Password -->
                                    <div class="mb-4">
                                        <label for="confirmPassword" class="form-label">
                                            <i class="fas fa-lock me-1"></i> Confirm New Password
                                        </label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="confirmPassword"
                                                   name="confirmPassword" minlength="6" required
                                                   placeholder="Re-enter new password">
                                            <button class="btn btn-outline-secondary" type="button"
                                                    onclick="togglePassword('confirmPassword', this)">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </div>
                                        <span id="passwordError" class="error-text">
                                            <i class="fas fa-exclamation-triangle me-1"></i>Passwords do not match
                                        </span>
                                    </div>

                                    <!-- Password Requirements -->
                                    <div class="password-requirements">
                                        <h6 class="mb-3"><i class="fas fa-info-circle me-2"></i>Password Requirements:</h6>
                                        <div class="requirement" id="req-length">
                                            <i class="fas fa-circle"></i>
                                            <span>At least 6 characters</span>
                                        </div>
                                        <div class="requirement" id="req-uppercase">
                                            <i class="fas fa-circle"></i>
                                            <span>At least one uppercase letter (A-Z)</span>
                                        </div>
                                        <div class="requirement" id="req-lowercase">
                                            <i class="fas fa-circle"></i>
                                            <span>At least one lowercase letter (a-z)</span>
                                        </div>
                                        <div class="requirement" id="req-number">
                                            <i class="fas fa-circle"></i>
                                            <span>At least one number (0-9)</span>
                                        </div>
                                    </div>

                                    <!-- CSRF -->
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                    <!-- Submit -->
                                    <div class="d-grid gap-2 mt-4">
                                        <button type="submit" class="btn btn-primary" id="submitBtn">
                                            <i class="fas fa-check-circle me-2"></i> Reset Password
                                        </button>
                                        <a href="${pageContext.request.contextPath}/login/home" class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
                                        </a>
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
                <div class="d-flex align-items-center justify-content-between small">
                    <div class="text-muted">Copyright &copy; BillMatePro 2025</div>
                    <div>
                        <a href="#" class="text-muted text-decoration-none">Privacy Policy</a>
                        &middot;
                        <a href="#" class="text-muted text-decoration-none">Terms &amp; Conditions</a>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</div>

<!-- Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

<script>
    // Toggle Password Visibility
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

    // Password Strength Checker
    function checkPasswordStrength(password) {
        let strength = 0;
        const requirements = {
            length: password.length >= 6,
            uppercase: /[A-Z]/.test(password),
            lowercase: /[a-z]/.test(password),
            number: /[0-9]/.test(password)
        };

        // Update requirement indicators
        updateRequirement('req-length', requirements.length);
        updateRequirement('req-uppercase', requirements.uppercase);
        updateRequirement('req-lowercase', requirements.lowercase);
        updateRequirement('req-number', requirements.number);

        // Calculate strength
        Object.values(requirements).forEach(met => {
            if (met) strength++;
        });

        // Update strength meter
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        const strengthMeter = document.getElementById('passwordStrength');

        if (password.length === 0) {
            strengthMeter.classList.remove('show');
            strengthText.textContent = '';
            return;
        }

        strengthMeter.classList.add('show');
        strengthBar.className = 'password-strength-bar';
        strengthText.className = 'password-strength-text';

        if (strength <= 2) {
            strengthBar.classList.add('strength-weak');
            strengthText.classList.add('text-weak');
            strengthText.innerHTML = '<i class="fas fa-exclamation-triangle me-1"></i> Weak password';
        } else if (strength === 3) {
            strengthBar.classList.add('strength-medium');
            strengthText.classList.add('text-medium');
            strengthText.innerHTML = '<i class="fas fa-shield-alt me-1"></i> Medium password';
        } else {
            strengthBar.classList.add('strength-strong');
            strengthText.classList.add('text-strong');
            strengthText.innerHTML = '<i class="fas fa-check-circle me-1"></i> Strong password';
        }
    }

    // Update Requirement Indicator
    function updateRequirement(id, met) {
        const element = document.getElementById(id);
        const icon = element.querySelector('i');

        if (met) {
            element.classList.remove('unmet');
            element.classList.add('met');
            icon.classList.remove('fa-circle');
            icon.classList.add('fa-check-circle');
        } else {
            element.classList.remove('met');
            element.classList.add('unmet');
            icon.classList.remove('fa-check-circle');
            icon.classList.add('fa-circle');
        }
    }

    // Password Match Validator
    function validatePasswordMatch() {
        const newPass = document.getElementById('newPassword').value;
        const confirmPass = document.getElementById('confirmPassword').value;
        const errorText = document.getElementById('passwordError');
        const submitBtn = document.getElementById('submitBtn');

        if (confirmPass.length === 0) {
            errorText.classList.remove('show');
            return true;
        }

        if (newPass !== confirmPass) {
            errorText.classList.add('show');
            submitBtn.disabled = true;
            return false;
        } else {
            errorText.classList.remove('show');
            submitBtn.disabled = false;
            return true;
        }
    }

    // Form Submission Handler
    document.getElementById("resetForm").addEventListener("submit", function (e) {
        const newPass = document.getElementById("newPassword").value;
        const confirmPass = document.getElementById("confirmPassword").value;

        if (newPass !== confirmPass) {
            e.preventDefault();
            document.getElementById('passwordError').classList.add('show');
            document.getElementById('confirmPassword').focus();
            return false;
        }

        // Check password strength
        if (newPass.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters long');
            return false;
        }

        return true;
    });

    // Event Listeners
    document.getElementById('newPassword').addEventListener('input', function() {
        checkPasswordStrength(this.value);
        validatePasswordMatch();
    });

    document.getElementById('confirmPassword').addEventListener('input', validatePasswordMatch);

    // Theme Toggle Function
    function toggleTheme() {
        const currentTheme = document.body.getAttribute('data-theme');
        const newTheme = currentTheme === 'light' ? 'dark' : 'light';

        document.body.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
        updateThemeIcon(newTheme);
    }

    function updateThemeIcon(theme) {
        const icon = document.getElementById('theme-icon');
        if (theme === 'dark') {
            icon.classList.remove('fa-moon');
            icon.classList.add('fa-sun');
        } else {
            icon.classList.remove('fa-sun');
            icon.classList.add('fa-moon');
        }
    }

    // Auto-hide alerts after 5 seconds
    window.addEventListener('DOMContentLoaded', () => {
        // Hide page loader
        setTimeout(() => {
            const loader = document.getElementById('pageLoader');
            if (loader) loader.classList.add('hidden');
        }, 600);

        // Auto-hide alerts
        document.querySelectorAll('.alert').forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                alert.style.transform = 'translateY(-20px)';
                setTimeout(() => alert.remove(), 300);
            }, 5000);
        });

        // Sidebar toggle
        const sidebarToggle = document.getElementById("sidebarToggle");
        if (sidebarToggle) {
            sidebarToggle.addEventListener("click", function(e) {
                e.preventDefault();
                document.body.classList.toggle("sb-sidenav-toggled");
                localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
            });
        }

        // Restore sidebar state
        if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
            document.body.classList.add('sb-sidenav-toggled');
        }

        // Restore theme
        const savedTheme = localStorage.getItem('theme') || 'light';
        document.body.setAttribute('data-theme', savedTheme);
        updateThemeIcon(savedTheme);

        // Initialize all requirements as unmet
        ['req-length', 'req-uppercase', 'req-lowercase', 'req-number'].forEach(id => {
            updateRequirement(id, false);
        });
    });

    // Prevent form resubmission on page refresh
    if (window.history.replaceState) {
        window.history.replaceState(null, null, window.location.href);
    }
</script>

</body>
</html>