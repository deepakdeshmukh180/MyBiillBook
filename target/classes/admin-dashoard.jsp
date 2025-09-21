<!DOCTYPE html>
<html lang="en">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="Modern Bill Book Dashboard" />
    <meta name="author" content="" />
    <title>Dashboard - My Bill Book</title>

    <!-- CSS Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/simple-datatables/7.3.2/style.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />



    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --warning-gradient: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
            --danger-gradient: linear-gradient(135deg, #fc466b 0%, #3f5efb 100%);
            --dark-gradient: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            --glass-bg: rgba(255, 255, 255, 0.1);
            --glass-border: rgba(255, 255, 255, 0.2);
            --shadow-soft: 0 10px 40px rgba(0, 0, 0, 0.1);
            --shadow-hover: 0 20px 60px rgba(0, 0, 0, 0.15);
            --border-radius: 20px;
            --transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 30%, #f093fb 70%, #f5576c 100%);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            margin: 0;
            overflow-x: hidden;
            position: relative;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Floating particles background */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><radialGradient id="g1"><stop offset="0%" stop-color="rgba(255,255,255,0.15)"/><stop offset="100%" stop-color="rgba(255,255,255,0)"/></radialGradient><radialGradient id="g2"><stop offset="0%" stop-color="rgba(102,126,234,0.1)"/><stop offset="100%" stop-color="rgba(102,126,234,0)"/></radialGradient></defs><circle cx="20" cy="20" r="2" fill="url(%23g1)"><animate attributeName="cx" values="20;80;20" dur="12s" repeatCount="indefinite"/><animate attributeName="cy" values="20;80;20" dur="8s" repeatCount="indefinite"/></circle><circle cx="80" cy="60" r="1.5" fill="url(%23g2)"><animate attributeName="cx" values="80;20;80" dur="10s" repeatCount="indefinite"/><animate attributeName="cy" values="60;20;60" dur="14s" repeatCount="indefinite"/></circle><circle cx="40" cy="80" r="1" fill="url(%23g1)"><animate attributeName="cx" values="40;60;40" dur="16s" repeatCount="indefinite"/><animate attributeName="cy" values="80;10;80" dur="12s" repeatCount="indefinite"/></circle><circle cx="70" cy="30" r="1.2" fill="url(%23g2)"><animate attributeName="cx" values="70;30;70" dur="14s" repeatCount="indefinite"/><animate attributeName="cy" values="30;70;30" dur="10s" repeatCount="indefinite"/></circle></svg>') repeat;
            animation: float 25s linear infinite;
            pointer-events: none;
            z-index: -1;
            opacity: 0.7;
        }

        @keyframes float {
            0% { transform: translateY(0px) translateX(0px) rotate(0deg); }
            100% { transform: translateY(-100vh) translateX(20px) rotate(360deg); }
        }

        /* Modern Navbar */
        .sb-topnav {
            background: rgba(255, 255, 255, 0.1) !important;
            backdrop-filter: blur(25px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: var(--shadow-soft);
            transition: var(--transition);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .sb-topnav:hover {
            background: rgba(255, 255, 255, 0.15) !important;
        }

        .navbar-brand {
            font-weight: 800;
            font-size: 1.6rem;
            color: white !important;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
            transition: var(--transition);
            position: relative;
        }

        .navbar-brand:hover {
            transform: translateY(-3px) scale(1.05);
            text-shadow: 0 8px 16px rgba(0, 0, 0, 0.4);
            color: #f8f9fa !important;
        }

        .navbar-brand i {
            background: var(--danger-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: pulse 3s infinite;
            filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.2); }
        }

        /* Glass Card Design */
        .glass-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-soft);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .glass-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.15), transparent);
            transition: left 0.8s ease;
            z-index: 1;
        }

        .glass-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-hover);
            border-color: rgba(255, 255, 255, 0.4);
            background: rgba(255, 255, 255, 0.18);
        }

        .glass-card:hover::before {
            left: 100%;
        }

        .card-header {
            background: var(--primary-gradient) !important;
            border: none !important;
            border-radius: var(--border-radius) var(--border-radius) 0 0 !important;
            padding: 2rem;
            position: relative;
            overflow: hidden;
            z-index: 2;
        }

        .card-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: conic-gradient(from 0deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            animation: rotate 12s linear infinite;
            z-index: -1;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .card-header h5 {
            position: relative;
            z-index: 2;
            margin: 0;
            font-weight: 700;
            font-size: 1.4rem;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
            letter-spacing: 0.5px;
        }

        .card-header i {
            position: relative;
            z-index: 2;
            font-size: 1.5rem;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
        }

        .card-body {
            position: relative;
            z-index: 2;
            padding: 2rem;
        }

        /* Status Badges with Enhanced Animations */
        .status-active {
            background: var(--success-gradient);
            color: white;
            padding: 0.75rem 1.25rem;
            border-radius: 30px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 8px 25px rgba(79, 172, 254, 0.4);
            animation: slideInRight 0.6s ease;
            position: relative;
            overflow: hidden;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.85rem;
        }

        .status-deactivate {
            background: var(--danger-gradient);
            color: white;
            padding: 0.75rem 1.25rem;
            border-radius: 30px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 8px 25px rgba(252, 70, 107, 0.4);
            animation: slideInRight 0.6s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.85rem;
        }

        .status-pending {
            background: var(--warning-gradient);
            color: white;
            padding: 0.75rem 1.25rem;
            border-radius: 30px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 8px 25px rgba(246, 211, 101, 0.4);
            animation: slideInRight 0.6s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.85rem;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* Table Enhancements */
        .table-container {
            background: rgba(255, 255, 255, 0.98);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-soft);
            position: relative;
        }

        .dataTable-wrapper {
            background: rgba(255, 255, 255, 0.98);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-soft);
        }

        .dataTable-table {
            margin: 0;
            background: transparent;
        }

        .dataTable-table thead th {
            background: var(--dark-gradient);
            color: white !important;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border: none !important;
            padding: 1.5rem 1rem;
            position: relative;
            font-size: 0.85rem;
        }

        .dataTable-table tbody tr {
            transition: var(--transition);
            border: none;
            position: relative;
        }

        .dataTable-table tbody tr:nth-child(even) {
            background: rgba(102, 126, 234, 0.02);
        }

        .dataTable-table tbody tr:hover {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            transform: translateX(5px) scale(1.01);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .dataTable-table tbody td {
            padding: 1.25rem 1rem;
            border: none !important;
            vertical-align: middle;
            font-weight: 500;
            position: relative;
        }

        /* DataTable Styling */
        .dataTable-top {
            background: rgba(102, 126, 234, 0.1);
            backdrop-filter: blur(15px);
            padding: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: var(--border-radius) var(--border-radius) 0 0;
        }

        .dataTable-bottom {
            background: rgba(102, 126, 234, 0.1);
            backdrop-filter: blur(15px);
            padding: 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 0 0 var(--border-radius) var(--border-radius);
        }

        .dataTable-input {
            background: rgba(255, 255, 255, 0.95) !important;
            border: 2px solid rgba(102, 126, 234, 0.3) !important;
            border-radius: 25px !important;
            padding: 0.75rem 1.5rem !important;
            transition: var(--transition) !important;
            font-weight: 500 !important;
        }

        .dataTable-input:focus {
            border-color: #667eea !important;
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25) !important;
            transform: scale(1.05) !important;
        }

        .dataTable-selector {
            background: rgba(255, 255, 255, 0.95) !important;
            border-radius: 12px !important;
            border: 2px solid rgba(102, 126, 234, 0.3) !important;
            padding: 0.5rem 1rem !important;
            font-weight: 500 !important;
        }

        /* Edit Button Enhancement */
        .btn-outline-primary {
            border: 2px solid #667eea;
            color: #667eea;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
            font-weight: 600;
        }

        .btn-outline-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: var(--primary-gradient);
            transition: left 0.4s ease;
            z-index: 1;
        }

        .btn-outline-primary i {
            position: relative;
            z-index: 2;
            transition: var(--transition);
        }

        .btn-outline-primary:hover {
            color: white !important;
            border-color: transparent;
            transform: translateY(-3px) scale(1.1);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-outline-primary:hover::before {
            left: 0;
        }

        .btn-outline-primary:hover i {
            transform: rotate(15deg);
        }

        /* Dropdown Enhancement */
        .dropdown-menu {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 18px;
            box-shadow: var(--shadow-soft);
            animation: slideInDown 0.4s ease;
            padding: 0.75rem;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-15px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .dropdown-item {
            transition: var(--transition);
            border-radius: 12px;
            margin: 0.25rem 0;
            padding: 0.75rem 1.25rem;
            font-weight: 500;
            display: flex;
            align-items: center;
        }

        .dropdown-item:hover {
            background: var(--primary-gradient);
            color: white;
            transform: translateX(8px) scale(1.02);
        }

        .dropdown-item i {
            width: 20px;
            text-align: center;
        }

        /* Container Enhancement */
        .container-fluid {
            padding: 2.5rem;
            position: relative;
            z-index: 1;
        }

        /* Status Icons Animations */
        .status-active i {
            animation: bounce 2s infinite;
        }

        .status-pending i {
            animation: spin 2s linear infinite;
        }

        .status-deactivate i {
            animation: shake 1s ease-in-out;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-8px); }
            75% { transform: translateX(8px); }
        }

        /* Page Load Animation */
        .page-content {
            animation: fadeInUp 1s ease;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Search Bar Enhancement */
        .navbar .form-control {
            background: rgba(255, 255, 255, 0.15);
            border: 2px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 30px;
            padding: 0.75rem 1.5rem;
            backdrop-filter: blur(15px);
            transition: var(--transition);
            font-weight: 500;
        }

        .navbar .form-control::placeholder {
            color: rgba(255, 255, 255, 0.8);
            font-weight: 400;
        }

        .navbar .form-control:focus {
            background: rgba(255, 255, 255, 0.25);
            border-color: rgba(255, 255, 255, 0.6);
            color: white;
            box-shadow: 0 0 0 0.25rem rgba(255, 255, 255, 0.2);
            transform: scale(1.05);
        }

        .navbar .btn-primary {
            background: var(--primary-gradient);
            border: none;
            border-radius: 0 30px 30px 0;
            margin-left: -2px;
            padding: 0.75rem 1.5rem;
            transition: var(--transition);
        }

        .navbar .btn-primary:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        /* Contact Links */
        .contact-link {
            color: inherit;
            text-decoration: none;
            transition: var(--transition);
            padding: 0.25rem 0.5rem;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
        }

        .contact-link:hover {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
            transform: scale(1.05);
        }

        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            .container-fluid {
                padding: 1.5rem;
            }

            .card-header {
                padding: 1.5rem;
            }

            .card-header h5 {
                font-size: 1.2rem;
            }

            .card-body {
                padding: 1.5rem;
            }

            .navbar-brand {
                font-size: 1.3rem;
            }

            .status-active, .status-deactivate, .status-pending {
                font-size: 0.75rem;
                padding: 0.5rem 1rem;
            }
        }

        @media (max-width: 576px) {
            .container-fluid {
                padding: 1rem;
            }

            .glass-card {
                border-radius: 15px;
            }
        }
    </style>
</head>

<body class="sb-nav-fixed">

    <!-- Modern Navigation -->
    <nav class="sb-topnav navbar navbar-expand navbar-dark">
        <!-- Navbar Brand-->
        <a class="navbar-brand ps-4" href="#">
            <i class="fa fa-calculator me-2"></i>My Bill Book
        </a>

        <!-- Sidebar Toggle-->
        <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0 text-white" id="sidebarToggle" title="Toggle Navigation">
            <i class="fas fa-bars"></i>
        </button>

        <!-- Navbar Search-->
        <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-4 my-2 my-md-0">
            <div class="input-group">
                <input class="form-control" type="text" placeholder="Search customers..." aria-label="Search customers" />
                <button class="btn btn-primary" type="button" title="Search">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </form>

        <!-- User Menu-->
        <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle text-white d-flex align-items-center" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user-circle fa-fw me-2"></i>
                    <span class="d-none d-lg-inline">Admin</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="fas fa-user me-2 text-primary"></i>My Profile
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="fas fa-cog me-2 text-secondary"></i>Settings
                        </a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="#">
                            <i class="fas fa-chart-line me-2 text-success"></i>Analytics
                        </a>
                    </li>
                    <li><hr class="dropdown-divider" /></li>
                    <li>
                        <a class="dropdown-item text-danger" href="#">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </a>
                    </li>
                </ul>
            </li>
        </ul>
    </nav>

    <!-- Main Content -->
    <div class="container-fluid page-content">

        <!-- Statistics Cards Row -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="glass-card text-center p-4">
                    <div class="text-white">
                        <i class="fas fa-users fa-3x mb-3 text-info"></i>
                        <h3 class="fw-bold" id="totalCustomers">15</h3>
                        <p class="mb-0 opacity-75">Total Customers</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="glass-card text-center p-4">
                    <div class="text-white">
                        <i class="fas fa-check-circle fa-3x mb-3 text-success"></i>
                        <h3 class="fw-bold" id="activeCount">12</h3>
                        <p class="mb-0 opacity-75">Active Accounts</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="glass-card text-center p-4">
                    <div class="text-white">
                        <i class="fas fa-hourglass-half fa-3x mb-3 text-warning"></i>
                        <h3 class="fw-bold" id="pendingCount">2</h3>
                        <p class="mb-0 opacity-75">Pending Approval</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="glass-card text-center p-4">
                    <div class="text-white">
                        <i class="fas fa-times-circle fa-3x mb-3 text-danger"></i>
                        <h3 class="fw-bold" id="deactivatedCount">1</h3>
                        <p class="mb-0 opacity-75">Deactivated</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="glass-card mb-4">
                    <div class="card-header d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-user-edit me-3"></i>
                            <h5 class="mb-0">Update Customer Information</h5>
                        </div>
                        <div class="text-white-50">
                            <i class="fas fa-info-circle me-1"></i>
                            <small>Edit customer details and manage subscription</small>
                        </div>
                    </div>
                    <div class="card-body form-section">
                        <form name="my-form" modelAttribute="OwnerInfo" action="${pageContext.request.contextPath}/company/update-owner-info" method="POST" class="needs-validation" novalidate>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <input type="hidden" name="ownerId" value="${ownerInfo.ownerId}" />
                            <input type="hidden" name="date" value="${ownerInfo.date}" />

                            <!-- Personal Information Section -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h6 class="text-white-75 fw-bold mb-3 pb-2 border-bottom border-white-25">
                                        <i class="fas fa-user-circle me-2 text-info"></i>Personal Information
                                    </h6>
                                </div>
                            </div>

                            <div class="row g-4 mb-5">
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-user"></i>User Name
                                    </label>
                                    <input type="text" readonly class="form-control-plaintext" value="${ownerInfo.userName}" name="userName" />
                                </div>
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-store"></i>Shop Name
                                    </label>
                                    <input type="text" class="form-control" value="${ownerInfo.shopName}" name="shopName" required />
                                    <div class="invalid-feedback">
                                        <i class="fas fa-exclamation-circle me-1"></i>Shop name is required
                                    </div>
                                </div>
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-map-marker-alt"></i>Shop Address
                                    </label>
                                    <input type="text" class="form-control" value="${ownerInfo.address}" name="address" required />
                                    <div class="invalid-feedback">
                                        <i class="fas fa-exclamation-circle me-1"></i>Address is required
                                    </div>
                                </div>
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-crown"></i>Shop Owner
                                    </label>
                                    <input type="text" class="form-control" value="${ownerInfo.ownerName}" name="ownerName" required />
                                    <div class="invalid-feedback">
                                        <i class="fas fa-exclamation-circle me-1"></i>Owner name is required
                                    </div>
                                </div>
                            </div>

                            <!-- Contact Information Section -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h6 class="text-white-75 fw-bold mb-3 pb-2 border-bottom border-white-25">
                                        <i class="fas fa-address-book me-2 text-success"></i>Contact Information
                                    </h6>
                                </div>
                            </div>

                            <div class="row g-4 mb-5">
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-phone"></i>Phone Number
                                    </label>
                                    <input type="tel" class="form-control" name="mobNumber" value="${ownerInfo.mobNumber}" pattern="[0-9]{10}" required />
                                    <div class="invalid-feedback">
                                        <i class="fas fa-exclamation-circle me-1"></i>Valid 10-digit number required
                                    </div>
                                </div>
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-envelope"></i>Email Address
                                    </label>
                                    <input type="email" class="form-control" name="email" value="${ownerInfo.email}" required />
                                    <div class="invalid-feedback">
                                        <i class="fas fa-exclamation-circle me-1"></i>Valid email required
                                    </div>
                                </div>
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-receipt"></i>GST Number
                                    </label>
                                    <input type="text" class="form-control" name="gstNumber" value="${ownerInfo.gstNumber}" placeholder="Optional" />
                                    <small class="text-white-50">Optional field</small>
                                </div>
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-certificate"></i>License Number
                                    </label>
                                    <input type="text" class="form-control" name="lcNo" value="${ownerInfo.lcNo}" placeholder="Optional" />
                                    <small class="text-white-50">Optional field</small>
                                </div>
                            </div>

                            <!-- Subscription Management Section -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h6 class="text-white-75 fw-bold mb-3 pb-2 border-bottom border-white-25">
                                        <i class="fas fa-credit-card me-2 text-warning"></i>Subscription Management
                                    </h6>
                                </div>
                            </div>

                            <div class="row g-4 align-items-end">
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-calendar-check"></i>Plan Valid Until
                                    </label>
                                    <div class="form-control-plaintext d-flex align-items-center">
                                        <i class="fas fa-clock me-2 text-info"></i>
                                        <span class="fw-bold">${ownerInfo.expDate}</span>
                                    </div>
                                </div>
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-toggle-on"></i>Account Status
                                    </label>
                                    <select class="form-select" name="status" required>
                                        <option value="" ${ownerInfo.status == null ? 'selected' : ''}>-- Select Status --</option>
                                        <option value="ACTIVE" ${ownerInfo.status eq 'ACTIVE' ? 'selected' : ''}>✅ Active</option>
                                        <option value="DEACTIVATE" ${ownerInfo.status eq 'DEACTIVATE' ? 'selected' : ''}>❌ Deactivate</option>
                                        <option value="PENDING" ${ownerInfo.status eq 'PENDING' ? 'selected' : ''}>⏳ Pending Approval</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        <i class="fas fa-exclamation-circle me-1"></i>Please select account status
                                    </div>
                                </div>
                                <div class="col-lg-3 col-md-6">
                                    <label class="form-label">
                                        <i class="fas fa-calendar-alt"></i>Plan Duration
                                    </label>
                                    <select class="form-select" name="planDuration" required>
                                        <option value="" ${ownerInfo.planDuration == null ? 'selected' : ''}>-- Select Duration --</option>
                                        <option value="3" ${ownerInfo.planDuration == 3 ? 'selected' : ''}>🗓️ 3 Months - Basic</option>
                                        <option value="6" ${ownerInfo.planDuration == 6 ? 'selected' : ''}>📅 6 Months - Standard</option>
                                        <option value="9" ${ownerInfo.planDuration == 9 ? 'selected' : ''}>📆 9 Months - Extended</option>
                                        <option value="12" ${ownerInfo.planDuration == 12 ? 'selected' : ''}>🗓️ 12 Months - Premium</option>
                                        <option value="24" ${ownerInfo.planDuration == 24 ? 'selected' : ''}>📋 24 Months - Enterprise</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        <i class="fas fa-exclamation-circle me-1"></i>Please select plan duration
                                    </div>
                                </div>
                                <div class="col-lg-3 col-md-6 d-flex justify-content-end">
                                    <button type="submit" class="btn btn-success px-5 py-3">
                                        <i class="fas fa-save me-2"></i>
                                        <span>Update Customer</span>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

        <!-- Customer List Table -->
        <div class="glass-card">
            <div class="card-header d-flex align-items-center justify-content-between flex-wrap">
                <div class="d-flex align-items-center mb-2 mb-md-0">
                    <i class="fas fa-users me-3"></i>
                    <h5 class="mb-0">Customer Management Portal</h5>
                </div>
                <div class="d-flex align-items-center text-white-75">
                    <i class="fas fa-chart-line me-2"></i>
                    <span class="fw-semibold">Total Records: <span id="totalRecords">15</span></span>
                </div>
            </div>
            <div class="card-body p-0">
                <div id="customerTableContainer">
                    <table id="datatablesSimple" class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="text-center">
                                    <i class="fas fa-edit me-2"></i>Actions
                                </th>
                                <th>
                                    <i class="fas fa-store me-2"></i>Shop Details
                                </th>
                                <th>
                                    <i class="fas fa-user me-2"></i>Owner Info
                                </th>
                                <th>
                                    <i class="fas fa-map-marker-alt me-2"></i>Location
                                </th>
                                <th>
                                    <i class="fas fa-phone me-2"></i>Contact
                                </th>

                                <th>
                                    <i class="fas fa-calendar me-2"></i>Registration
                                </th>
                                <th>
                                    <i class="fas fa-clock me-2"></i>Plan
                                </th>
                                <th class="text-center">
                                    <i class="fas fa-toggle-on me-2"></i>Status
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${ownerDetails}" var="ownerDetail" varStatus="loopStatus">
                                <tr class="table-row-animate" style="animation-delay: ${loopStatus.index * 0.1}s;">
                                    <!-- Actions Column -->
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/company/get-shop-profile/${ownerDetail.ownerId}"
                                           class="btn btn-sm btn-outline-primary"
                                           title="Edit Customer Details"
                                           data-bs-toggle="tooltip"
                                           data-bs-placement="top">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                    </td>

                                    <!-- Shop Details Column -->
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="bg-primary bg-gradient rounded-circle p-2 me-3">
                                                <i class="fas fa-building text-white"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold text-primary">
                                                    <c:choose>
                                                        <c:when test="${not empty ownerDetail.shopName}">
                                                            ${ownerDetail.shopName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted fst-italic">Shop Name Not Provided</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <small class="text-muted">Business</small>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Owner Info Column -->
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="bg-secondary bg-gradient rounded-circle p-2 me-3">
                                                <i class="fas fa-user-tie text-white"></i>
                                            </div>
                                            <div>
                                                <div class="fw-semibold">
                                                    <c:choose>
                                                        <c:when test="${not empty ownerDetail.ownerName}">
                                                            ${ownerDetail.ownerName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${ownerDetail.userName}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <small class="text-muted">Owner</small>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Location Column -->
                                    <td>
                                        <div class="text-muted">
                                            <i class="fas fa-location-dot me-2 text-danger"></i>
                                            <span class="fw-medium">
                                                <c:choose>
                                                    <c:when test="${not empty ownerDetail.address}">
                                                        ${ownerDetail.address}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="fst-italic">Address not provided</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </td>

                                    <!-- Contact Column -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty ownerDetail.mobNumber}">
                                                <a href="tel:${ownerDetail.mobNumber}" class="contact-link">
                                                    <i class="fas fa-phone me-2 text-success"></i>
                                                    <span class="fw-medium">${ownerDetail.mobNumber}</span>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted fst-italic">
                                                    <i class="fas fa-phone me-2 text-muted"></i>
                                                    Phone not provided
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>



                                    <!-- Registration Date Column -->
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-calendar-plus me-2 text-secondary"></i>
                                            <span class="fw-medium">
                                                <c:choose>
                                                    <c:when test="${not empty ownerDetail.date}">
                                                        ${ownerDetail.date}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </td>

                                    <!-- Plan Duration Column -->
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-hourglass-half me-2 text-info"></i>
                                            <div>
                                                <div class="fw-bold text-info">
                                                    <c:choose>
                                                        <c:when test="${not empty ownerDetail.planDuration}">
                                                            ${ownerDetail.planDuration}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <small class="text-muted">Months</small>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Status Column with Dynamic Status Badge -->
                                    <td class="text-center">
                                        <c:set var="status" value="${fn:toUpperCase(fn:trim(ownerDetail.status))}" />
                                        <c:choose>
                                            <c:when test="${status eq 'ACTIVE'}">
                                                <span class="status-active">
                                                    <i class="fas fa-check-circle"></i>
                                                    <span>ACTIVE</span>
                                                </span>
                                            </c:when>
                                            <c:when test="${status eq 'DEACTIVATE'}">
                                                <span class="status-deactivate">
                                                    <i class="fas fa-times-circle"></i>
                                                    <span>DEACTIVATE</span>
                                                </span>
                                            </c:when>
                                            <c:when test="${status eq 'PENDING'}">
                                                <span class="status-pending">
                                                    <i class="fas fa-hourglass-half"></i>
                                                    <span>PENDING</span>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary fs-6 px-3 py-2">
                                                    <i class="fas fa-question-circle me-1"></i>
                                                    <c:choose>
                                                        <c:when test="${not empty status}">
                                                            ${status}
                                                        </c:when>
                                                        <c:otherwise>
                                                            UNKNOWN
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <!-- Empty State Row - Shows when no data is available -->
                            <c:if test="${empty ownerDetails}">
                                <tr>
                                    <td colspan="10" class="text-center py-5">
                                        <div class="d-flex flex-column align-items-center justify-content-center">
                                            <i class="fas fa-users fa-3x text-muted mb-3 opacity-50"></i>
                                            <h5 class="text-muted mb-2">No Customers Found</h5>
                                            <p class="text-muted mb-0">There are currently no customers in the system.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js"></script>


    <script>
        // Global variables
        let dataTable;

        // Enhanced DataTables initialization
        window.addEventListener('DOMContentLoaded', event => {
            // Initialize DataTable with enhanced features
            const tableElement = document.getElementById('datatablesSimple');

            if (tableElement) {
                dataTable = new simpleDatatables.DataTable(tableElement, {
                    searchable: true,
                    fixedHeight: false,
                    perPage: 10,
                    perPageSelect: [5, 10, 15, 20, 25],
                    labels: {
                        placeholder: "🔍 Search customers by name, email, or phone...",
                        perPage: "Show {select} entries per page",
                        noRows: "No customers found matching your criteria",
                        info: "Showing {start} to {end} of {rows} customers",
                        noEntries: "No customers available"
                    },
                    classes: {
                        top: "datatable-top d-flex justify-content-between align-items-center flex-wrap gap-3 p-4",
                        bottom: "datatable-bottom d-flex justify-content-between align-items-center flex-wrap gap-3 p-4"
                    }
                });

                console.log('DataTable initialized successfully');
            } else {
                console.error('Table element not found');
            }

            // Initialize tooltips
            initializeTooltips();

            // Initialize scroll effects
            initializeScrollEffects();

            // Initialize other features
            initializeFeatures();
        });

        // Initialize tooltips
        function initializeTooltips() {
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        }

        // Initialize scroll effects
        function initializeScrollEffects() {
            // Smooth scrolling and navbar effects
            window.addEventListener('scroll', () => {
                // Parallax effect for background
                const scrolled = window.pageYOffset;
                const parallax = scrolled * 0.5;
                document.body.style.backgroundPosition = `center ${parallax}px`;
            });
        }

        // Initialize other features
        function initializeFeatures() {
            // Form field enhancements
            document.querySelectorAll('.form-control, .form-select').forEach(input => {
                // Focus effects
                input.addEventListener('focus', function() {
                    this.parentElement.style.transform = 'scale(1.02)';
                    this.parentElement.style.transition = 'transform 0.3s ease';

                    // Add glow effect to label
                    const label = this.parentElement.querySelector('.form-label');
                    if (label) {
                        label.style.color = 'rgba(255, 255, 255, 1)';
                        label.style.textShadow = '0 2px 8px rgba(102, 126, 234, 0.5)';
                    }
                });

                input.addEventListener('blur', function() {
                    this.parentElement.style.transform = 'scale(1)';

                    // Reset label glow
                    const label = this.parentElement.querySelector('.form-label');
                    if (label) {
                        label.style.color = 'rgba(255, 255, 255, 0.95)';
                        label.style.textShadow = '0 1px 3px rgba(0, 0, 0, 0.3)';
                    }
                });
            });

            // Enhanced sidebar toggle with rotation
            const sidebarToggle = document.getElementById('sidebarToggle');
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function() {
                    this.style.transform = 'rotate(180deg) scale(1.2)';
                    setTimeout(() => {
                        this.style.transform = 'rotate(0deg) scale(1)';
                    }, 300);
                });
            }

            // Status badge hover effects
            document.querySelectorAll('[class*="status-"]').forEach(badge => {
                badge.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.15) rotate(2deg)';
                    this.style.transition = 'all 0.3s ease';
                    this.style.boxShadow = '0 12px 30px rgba(0, 0, 0, 0.2)';
                });

                badge.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1) rotate(0deg)';
                    this.style.boxShadow = '';
                });
            });

            // Contact link enhancements
            document.querySelectorAll('.contact-link').forEach(link => {
                link.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(5px) scale(1.05)';
                });

                link.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0) scale(1)';
                });
            });
        }

        // Enhanced search functionality
        function enhanceSearch() {
            const searchInput = document.querySelector('.navbar .form-control');
            if (searchInput && dataTable) {
                searchInput.addEventListener('input', function() {
                    dataTable.search(this.value);
                });

                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        dataTable.search(this.value);
                    }
                });
            }
        }

        // Initialize enhanced search after DataTable is ready
        setTimeout(enhanceSearch, 1000);

        // Add smooth page transitions
        document.addEventListener('DOMContentLoaded', () => {
            // Fade in page content
            const pageContent = document.querySelector('.page-content');
            if (pageContent) {
                pageContent.style.opacity = '0';
                pageContent.style.transform = 'translateY(20px)';

                setTimeout(() => {
                    pageContent.style.transition = 'all 0.8s ease';
                    pageContent.style.opacity = '1';
                    pageContent.style.transform = 'translateY(0)';
                }, 100);
            }
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl/Cmd + K for search focus
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                const searchInput = document.querySelector('.navbar .form-control');
                if (searchInput) {
                    searchInput.focus();
                }
            }

            // Escape to clear search
            if (e.key === 'Escape') {
                const searchInput = document.querySelector('.navbar .form-control');
                if (searchInput && searchInput === document.activeElement) {
                    searchInput.value = '';
                    if (dataTable) {
                        dataTable.search('');
                    }
                    searchInput.blur();
                }
            }
        });

        // Add error handling for DataTable initialization
        setTimeout(() => {
            if (!dataTable) {
                console.warn('DataTable failed to initialize, falling back to basic table');
                // Add basic search functionality
                const searchInput = document.querySelector('.navbar .form-control');
                const tableRows = document.querySelectorAll('#datatablesSimple tbody tr');

                if (searchInput) {
                    searchInput.addEventListener('input', function() {
                        const searchTerm = this.value.toLowerCase();
                        tableRows.forEach(row => {
                            const text = row.textContent.toLowerCase();
                            row.style.display = text.includes(searchTerm) ? '' : 'none';
                        });
                    });
                }
            }
        }, 2000);
    </script>

</body>
</html>