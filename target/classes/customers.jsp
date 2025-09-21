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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - My Bill Book</title>

    <!-- Bootstrap & Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>

    <style>

        :root { --brand: #0d6efd; --soft: #f4f6f9; --ink: #33475b; }
        body { background: var(--soft); }
        .brand-gradient { background: linear-gradient(135deg, #3c7bff, #70a1ff); }
        .shadow-soft { box-shadow: 0 6px 18px rgba(0,0,0,.08); }
        .rounded-18 { border-radius: 18px; }
        .section-title { font-weight: 700; color: var(--ink); }
        #layoutSidenav_nav { transition: all 0.3s ease; width: 250px; }
        .sb-sidenav-toggled #layoutSidenav_nav { margin-left: -250px; }
        @media (max-width: 768px) {
            #layoutSidenav_nav { position: fixed; top: 0; left: -250px; height: 100%; z-index: 1050; }
            .sb-sidenav-toggled #layoutSidenav_nav { left: 0; }
            .overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1049; display: none; }
            .overlay.active { display: block; }
        }
    * { margin: 0; padding: 0; box-sizing: border-box; } body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 2rem; } .container { max-width: 1600px; margin: 0 auto; } /* 4 Cards per row layout */ .cards-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; padding: 1rem 0; } .customer-card { background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(20px); border-radius: 16px; padding: 1.5rem; box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1); position: relative; overflow: hidden; display: flex; flex-direction: column; min-height: 420px; } .customer-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, #667eea, #764ba2); transform: scaleX(0); transform-origin: left; transition: transform 0.4s ease; } .customer-card:hover::before { transform: scaleX(1); } .customer-card:hover { transform: translateY(-8px); box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15); background: rgba(255, 255, 255, 1); } .card-header { display: flex; align-items: center; margin-bottom: 1.25rem; } .customer-avatar { width: 50px; height: 50px; background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.2rem; font-weight: bold; box-shadow: 0 6px 12px rgba(102, 126, 234, 0.3); flex-shrink: 0; } .customer-name { font-size: 1.2rem; font-weight: 700; color: #2d3748; margin: 0; margin-left: 0.75rem; line-height: 1.3; } .card-content { margin-bottom: 1.25rem; flex-grow: 1; } .info-item { display: flex; align-items: flex-start; margin-bottom: 0.75rem; padding: 0.5rem; border-radius: 8px; transition: background-color 0.2s ease; } .info-item:hover { background-color: rgba(102, 126, 234, 0.05); } .info-icon { width: 28px; height: 28px; display: flex; align-items: center; justify-content: center; border-radius: 6px; margin-right: 0.6rem; font-size: 0.8rem; flex-shrink: 0; } .address-icon { background: rgba(239, 68, 68, 0.1); color: #ef4444; } .phone-icon { background: rgba(34, 197, 94, 0.1); color: #22c55e; } .info-text { color: #4a5568; font-weight: 500; text-decoration: none; flex: 1; font-size: 0.9rem; line-height: 1.4; } .whatsapp-link { text-decoration: none; color: inherit; display: flex; align-items: flex-start; width: 100%; } .whatsapp-link:hover { color: #22c55e; } .amount-section { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 0.5rem; margin-bottom: 1.25rem; } .amount-card { text-align: center; padding: 0.75rem 0.4rem; border-radius: 10px; position: relative; overflow: hidden; } .amount-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; opacity: 0.1; border-radius: 10px; } .total-card { background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.2); } .total-card::before { background: #3b82f6; } .paid-card { background: rgba(34, 197, 94, 0.1); border: 1px solid rgba(34, 197, 94, 0.2); } .paid-card::before { background: #22c55e; } .balance-card { background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.2); } .balance-card::before { background: #ef4444; } .amount-label { font-size: 0.7rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; opacity: 0.8; margin-bottom: 0.2rem; } .amount-value { font-size: 0.95rem; font-weight: 700; } .total-card .amount-label, .total-card .amount-value { color: #3b82f6; } .paid-card .amount-label, .paid-card .amount-value { color: #22c55e; } .balance-card .amount-label, .balance-card .amount-value { color: #ef4444; } .action-buttons { display: grid; grid-template-columns: 1fr 1fr; gap: 0.6rem; margin-top: auto; } .action-btn { display: flex; align-items: center; justify-content: center; padding: 0.65rem 0.8rem; border-radius: 10px; text-decoration: none; font-weight: 600; font-size: 0.8rem; transition: all 0.3s ease; border: none; cursor: pointer; position: relative; overflow: hidden; } .action-btn::before { content: ''; position: absolute; top: 0; left: -100%; width: 100%; height: 100%; background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent); transition: left 0.5s; } .action-btn:hover::before { left: 100%; } .action-btn i { margin-right: 0.4rem; font-size: 0.75rem; } .btn-invoice { background: linear-gradient(135deg, #3b82f6, #1d4ed8); color: white; box-shadow: 0 3px 10px rgba(59, 130, 246, 0.3); } .btn-invoice:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(59, 130, 246, 0.4); color: white; } .btn-deposit { background: linear-gradient(135deg, #22c55e, #16a34a); color: white; box-shadow: 0 3px 10px rgba(34, 197, 94, 0.3); } .btn-deposit:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(34, 197, 94, 0.4); color: white; } .btn-history { background: linear-gradient(135deg, #f59e0b, #d97706); color: white; box-shadow: 0 3px 10px rgba(245, 158, 11, 0.3); } .btn-history:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(245, 158, 11, 0.4); color: white; } .btn-edit { background: linear-gradient(135deg, #6b7280, #4b5563); color: white; box-shadow: 0 3px 10px rgba(107, 114, 128, 0.3); } .btn-edit:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(107, 114, 128, 0.4); color: white; } .page-header { text-align: center; margin-bottom: 2.5rem; color: white; } .page-title { font-size: 2.5rem; font-weight: 700; margin-bottom: 0.5rem; text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); } .page-subtitle { font-size: 1.1rem; opacity: 0.9; } /* Card Counter */ .card-counter { background: rgba(255, 255, 255, 0.2); backdrop-filter: blur(10px); color: white; padding: 0.75rem 1.5rem; border-radius: 25px; display: inline-block; margin-bottom: 1rem; font-weight: 600; border: 1px solid rgba(255, 255, 255, 0.3); } /* Responsive Design */ @media (max-width: 1400px) { .cards-grid { grid-template-columns: repeat(3, 1fr); } } @media (max-width: 1024px) { .cards-grid { grid-template-columns: repeat(2, 1fr); gap: 1.25rem; } .customer-card { min-height: 380px; } } @media (max-width: 768px) { .cards-grid { grid-template-columns: 1fr; gap: 1rem; } .customer-card { min-height: auto; padding: 1.25rem; } .amount-section { grid-template-columns: 1fr; gap: 0.5rem; } .action-buttons { grid-template-columns: 1fr; } .page-title { font-size: 2rem; } } @media (max-width: 480px) { body { padding: 1rem; } .customer-card { padding: 1rem; } .customer-name { font-size: 1.1rem; } .customer-avatar { width: 45px; height: 45px; font-size: 1.1rem; } } /* Animation for dynamic loading */ .customer-card { animation: cardFadeIn 0.6s ease-out forwards; opacity: 0; transform: translateY(20px); } .customer-card:nth-child(1) { animation-delay: 0.1s; } .customer-card:nth-child(2) { animation-delay: 0.2s; } .customer-card:nth-child(3) { animation-delay: 0.3s; } .customer-card:nth-child(4) { animation-delay: 0.4s; } .customer-card:nth-child(5) { animation-delay: 0.5s; } .customer-card:nth-child(6) { animation-delay: 0.6s; } .customer-card:nth-child(7) { animation-delay: 0.7s; } .customer-card:nth-child(8) { animation-delay: 0.8s; } @keyframes cardFadeIn { to { opacity: 1; transform: translateY(0); } } </style>
</head>
<body class="sb-nav-fixed">

<!-- Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark brand-gradient">
    <a class="navbar-brand ps-3 fw-bold" href="${pageContext.request.contextPath}/login/home">
        My <i class="fa fa-calculator text-warning"></i> Bill Book
    </a>
    <button class="btn btn-outline-light btn-sm ms-2" id="sidebarToggle" aria-label="Toggle Sidebar">
        <i class="fas fa-bars"></i>
    </button>

    <div class="ms-auto d-flex align-items-center gap-3 pe-3">
        <div class="dropdown">
            <a class="nav-link dropdown-toggle text-white" id="navbarDropdown" href="#" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div id="layoutSidenav">
    <!-- Sidebar -->
    <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
            <div class="sb-sidenav-menu">
                <div class="nav">
                    <div class="sb-sidenav-menu-heading">Core</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login/home">
                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div> Dashboard
                    </a>
                    <div class="sb-sidenav-menu-heading">Interface</div>
                    <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts"
                       aria-expanded="false" aria-controls="collapseLayouts">
                        <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>
                        Menu
                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                    </a>
                    <div class="collapse" id="collapseLayouts" data-bs-parent="#sidenavAccordion">
                        <nav class="sb-sidenav-menu-nested nav">
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">All Customers</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">Invoices</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">Reports</a>
                            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">Products</a>
                        </nav>
                    </div>
                    <div class="sb-sidenav-menu-heading">Addons</div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
                        <div class="sb-nav-link-icon"><i class="fa fa-gear fa-spin"></i></div> Account Settings
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/export-to-pdf">
                        <div class="sb-nav-link-icon"><i class="fas fa-file-export"></i></div> Export Customers
                    </a>
                </div>
            </div>
            <div class="sb-sidenav-footer">
                <div class="small">Logged in as:</div>
                ${pageContext.request.userPrincipal.name}
            </div>
        </nav>
    </div>

    <!-- Overlay for Mobile -->
    <div class="overlay" id="sidebarOverlay"></div>

    <!-- Main Content -->
    <div id="layoutSidenav_content">
        <div class="container-fluid px-4 my-3">
<h4 class="section-title mb-4">
                    <i class="bi bi-person-vcard me-2"></i> Customers Section
                </h4>
            <!-- Search Bar -->
            <div class="row mb-3">
                <div class="col-md-6 mx-auto">
                    <div class="input-group shadow-sm">
                        <input type="text" id="searchBox" class="form-control" placeholder="🔍 Search customer by name or phone...">
                        <button class="btn btn-outline-secondary" type="button" onclick="location.reload();">🔄 Refresh</button>
                    </div>
                </div>
            </div>

            <!-- Loader -->
            <div id="loader" class="text-center my-3" style="display: none;">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p class="text-muted small mt-2">Fetching data...</p>
            </div>

            <!-- Customer Cards -->
            <div class="cards-grid" id="customerCardContainer">
                <c:forEach items="${custmers}" var="custmer">
                    <div class="customer-card">
                        <div class="card-header">
                            <div class="customer-avatar">
                                ${fn:substring(custmer.custName, 0, 1)}${fn:substring(custmer.custName, fn:indexOf(custmer.custName, ' ') + 1, fn:indexOf(custmer.custName, ' ') + 2)}
                            </div>
                            <h3 class="customer-name">${custmer.custName}</h3>
                        </div>

                        <div class="card-content">
                            <div class="info-item">
                                <div class="info-icon address-icon">
                                    <i class="fas fa-map-marker-alt"></i>
                                </div>
                                <span class="info-text">${custmer.address}</span>
                            </div>

                            <div class="info-item">
                                <div class="info-icon phone-icon">
                                    <i class="fab fa-whatsapp"></i>
                                </div>
                                <a href="https://wa.me/${custmer.phoneNo}" target="_blank" class="whatsapp-link">
                                    <span class="info-text">${custmer.phoneNo}</span>
                                </a>
                            </div>
                        </div>

                        <div class="amount-section">
                            <div class="amount-card total-card">
                                <div class="amount-label">Total</div>
                                <div class="amount-value">₹${custmer.totalAmount}</div>
                            </div>
                            <div class="amount-card paid-card">
                                <div class="amount-label">Paid</div>
                                <div class="amount-value">₹${custmer.paidAmout}</div>
                            </div>
                            <div class="amount-card balance-card">
                                <div class="amount-label">Balance</div>
                                <div class="amount-value">₹${custmer.currentOusting}</div>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/company/get-cust-by-id?custid=${custmer.id}" class="action-btn btn-invoice">
                                <i class="fas fa-file-invoice"></i> Invoice
                            </a>
                            <a href="${pageContext.request.contextPath}/company/get-bal-credit-page/${custmer.id}" class="action-btn btn-deposit">
                                <i class="fas fa-donate"></i> Deposit
                            </a>
                            <a href="${pageContext.request.contextPath}/company/cust-history?custid=${custmer.id}" target="_blank" class="action-btn btn-history">
                                <i class="fas fa-list-ol"></i> History
                            </a>
                            <a href="${pageContext.request.contextPath}/company/update-customer/${custmer.id}" class="action-btn btn-edit">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Pagination -->
            <div id="paginationContainer" class="d-flex justify-content-center mt-3">
                <ul class="pagination pagination-sm mb-0">
                    <c:if test="${page > 0}">
                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${page - 1}">&laquo; Prev</a></li>
                    </c:if>
                    <c:forEach begin="${page - 2 < 0 ? 0 : page - 2}" end="${page + 2 >= totalPages ? totalPages - 1 : page + 2}" var="i">
                        <li class="page-item ${page == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${i}">${i + 1}</a>
                        </li>
                    </c:forEach>
                    <c:if test="${page < totalPages - 1}">
                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${page + 1}">Next &raquo;</a></li>
                    </c:if>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
    const searchInput = document.getElementById('searchBox');
    const cardContainer = document.getElementById('customerCardContainer');
    const paginationContainer = document.getElementById('paginationContainer');
    const loader = document.getElementById('loader');
    let debounceTimer;

    function showLoader(){ loader.style.display = 'block'; }
    function hideLoader(){ loader.style.display = 'none'; }

    function renderCards(customers) {
        cardContainer.innerHTML = '';

        customers.forEach(function (custmer, index) {
            // Generate avatar initials
            var nameWords = custmer.custName.split(' ');
            var initials = nameWords.length > 1
                ? nameWords[0].charAt(0).toUpperCase() + nameWords[1].charAt(0).toUpperCase()
                : custmer.custName.charAt(0).toUpperCase() + (custmer.custName.charAt(1) || '').toUpperCase();

            var card = document.createElement('div');
            card.className = 'customer-card';

            // Add staggered animation delay
            card.style.animationDelay = (index * 0.1) + 's';

            card.innerHTML =
                '<div class="card-header">' +
                    '<div class="customer-avatar">' + initials + '</div>' +
                    '<h3 class="customer-name">' + custmer.custName + '</h3>' +
                '</div>' +

                '<div class="card-content">' +
                    '<div class="info-item">' +
                        '<div class="info-icon address-icon">' +
                            '<i class="fas fa-map-marker-alt"></i>' +
                        '</div>' +
                        '<span class="info-text">' + (custmer.address || 'No address provided') + '</span>' +
                    '</div>' +

                    '<div class="info-item">' +
                        '<div class="info-icon phone-icon">' +
                            '<i class="fab fa-whatsapp"></i>' +
                        '</div>' +
                        '<a href="https://wa.me/' + custmer.phoneNo + '" target="_blank" class="whatsapp-link">' +
                            '<span class="info-text">' + custmer.phoneNo + '</span>' +
                        '</a>' +
                    '</div>' +
                '</div>' +

                '<div class="amount-section">' +
                    '<div class="amount-card total-card">' +
                        '<div class="amount-label">Total</div>' +
                        '<div class="amount-value">₹' + formatNumber(custmer.totalAmount) + '</div>' +
                    '</div>' +
                    '<div class="amount-card paid-card">' +
                        '<div class="amount-label">Paid</div>' +
                        '<div class="amount-value">₹' + formatNumber(custmer.paidAmout) + '</div>' +
                    '</div>' +
                    '<div class="amount-card balance-card">' +
                        '<div class="amount-label">Balance</div>' +
                        '<div class="amount-value">₹' + formatNumber(custmer.currentOusting) + '</div>' +
                    '</div>' +
                '</div>' +

                '<div class="action-buttons">' +
                    '<a href="' + contextPath + '/company/get-cust-by-id?custid=' + custmer.id + '" class="action-btn btn-invoice">' +
                        '<i class="fas fa-file-invoice"></i>Invoice' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/get-bal-credit-page/' + custmer.id + '" class="action-btn btn-deposit">' +
                        '<i class="fas fa-donate"></i>Deposit' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/cust-history?custid=' + custmer.id + '" target="_blank" class="action-btn btn-history">' +
                        '<i class="fas fa-list-ol"></i>History' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/update-customer/' + custmer.id + '" class="action-btn btn-edit">' +
                        '<i class="fas fa-edit"></i>Edit' +
                    '</a>' +
                '</div>';

            cardContainer.appendChild(card);
        });

        // Update card counter
        updateCardCounter();
    }

    // Helper function to format numbers with commas
    function formatNumber(num) {
        if (num === null || num === undefined) return '0';
        return parseFloat(num).toLocaleString('en-IN');
    }

    // Helper function to update card counter
    function updateCardCounter() {
        var cards = document.querySelectorAll('.customer-card');
        var counter = document.getElementById('cardCounter');
        if (counter) {
            counter.textContent = 'Total Customers: ' + cards.length;
        }
    }

    // Alternative version with error handling and better performance
    function renderCardsOptimized(customers) {
        if (!customers || customers.length === 0) {
            cardContainer.innerHTML = '<div class="no-customers">No customers found</div>';
            return;
        }

        // Create document fragment for better performance
        var fragment = document.createDocumentFragment();

        customers.forEach(function (custmer, index) {
            // Validate customer data
            if (!custmer || !custmer.custName) {
                console.warn('Invalid customer data at index', index);
                return;
            }

            // Generate avatar initials safely
            var nameWords = custmer.custName.trim().split(/\s+/);
            var initials = nameWords.length > 1
                ? nameWords[0].charAt(0).toUpperCase() + nameWords[1].charAt(0).toUpperCase()
                : custmer.custName.charAt(0).toUpperCase() + (custmer.custName.charAt(1) || '').toUpperCase();

            var card = document.createElement('div');
            card.className = 'customer-card';
            card.style.animationDelay = (index * 0.1) + 's';

            // Safe property access with fallbacks
            var address = custmer.address || 'Address not provided';
            var phoneNo = custmer.phoneNo || '';
            var totalAmount = custmer.totalAmount || 0;
            var paidAmount = custmer.paidAmout || custmer.paidAmount || 0;
            var currentOusting = custmer.currentOusting || custmer.balance || 0;

            card.innerHTML =
                '<div class="card-header">' +
                    '<div class="customer-avatar">' + initials + '</div>' +
                    '<h3 class="customer-name">' + escapeHtml(custmer.custName) + '</h3>' +
                '</div>' +

                '<div class="card-content">' +
                    '<div class="info-item">' +
                        '<div class="info-icon address-icon">' +
                            '<i class="fas fa-map-marker-alt"></i>' +
                        '</div>' +
                        '<span class="info-text" title="' + escapeHtml(address) + '">' +
                            truncateText(address, 50) +
                        '</span>' +
                    '</div>' +

                    '<div class="info-item">' +
                        '<div class="info-icon phone-icon">' +
                            '<i class="fab fa-whatsapp"></i>' +
                        '</div>' +
                        (phoneNo ?
                            '<a href="https://wa.me/' + phoneNo + '" target="_blank" class="whatsapp-link">' +
                                '<span class="info-text">' + phoneNo + '</span>' +
                            '</a>' :
                            '<span class="info-text">No phone number</span>'
                        ) +
                    '</div>' +
                '</div>' +

                '<div class="amount-section">' +
                    '<div class="amount-card total-card">' +
                        '<div class="amount-label">Total</div>' +
                        '<div class="amount-value">₹' + formatNumber(totalAmount) + '</div>' +
                    '</div>' +
                    '<div class="amount-card paid-card">' +
                        '<div class="amount-label">Paid</div>' +
                        '<div class="amount-value">₹' + formatNumber(paidAmount) + '</div>' +
                    '</div>' +
                    '<div class="amount-card balance-card">' +
                        '<div class="amount-label">Balance</div>' +
                        '<div class="amount-value">₹' + formatNumber(currentOusting) + '</div>' +
                    '</div>' +
                '</div>' +

                '<div class="action-buttons">' +
                    '<a href="' + contextPath + '/company/get-cust-by-id?custid=' + custmer.id + '" class="action-btn btn-invoice">' +
                        '<i class="fas fa-file-invoice"></i>Invoice' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/get-bal-credit-page/' + custmer.id + '" class="action-btn btn-deposit">' +
                        '<i class="fas fa-donate"></i>Deposit' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/cust-history?custid=' + custmer.id + '" target="_blank" class="action-btn btn-history">' +
                        '<i class="fas fa-list-ol"></i>History' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/update-customer/' + custmer.id + '" class="action-btn btn-edit">' +
                        '<i class="fas fa-edit"></i>Edit' +
                    '</a>' +
                '</div>';

            fragment.appendChild(card);
        });

        // Clear container and append all cards at once
        cardContainer.innerHTML = '';
        cardContainer.appendChild(fragment);

        // Update card counter
        updateCardCounter();
    }

    // Utility functions
    function escapeHtml(text) {
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function truncateText(text, maxLength) {
        if (text.length <= maxLength) return text;
        return text.substring(0, maxLength) + '...';
    }

    // CSS for no customers message
    var noCustomersStyle = `
        .no-customers {
            grid-column: 1 / -1;
            text-align: center;
            padding: 3rem;
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.2rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            backdrop-filter: blur(10px);
        }
    `;

    // Add the style to the page if it doesn't exist
    if (!document.getElementById('no-customers-style')) {
        var style = document.createElement('style');
        style.id = 'no-customers-style';
        style.textContent = noCustomersStyle;
        document.head.appendChild(style);
    }


    searchInput.addEventListener('input', function () {
        const query = this.value.trim();
        clearTimeout(debounceTimer);

        if (!query) {
            location.href = contextPath + '/company/get-all-customers';
            return;
        }
        if (query.length < 2) return;

        debounceTimer = setTimeout(() => {
            showLoader();
            fetch(contextPath + '/company/search?query=' + encodeURIComponent(query))
                .then(res => res.json())
                .then(data => {
                    hideLoader();
                    if (!data || data.length === 0) {
                        cardContainer.innerHTML = '<div class="col-12 text-center text-muted">🙁 No matching customers found</div>';
                        paginationContainer.style.display = 'none';
                        return;
                    }
                    renderCards(data);
                    paginationContainer.style.display = 'none';
                })
                .catch(() => hideLoader());
        }, 300);
    });

    // Sidebar toggle
    document.getElementById('sidebarToggle').addEventListener('click', function () {
        document.body.classList.toggle('sb-sidenav-toggled');
        document.getElementById('sidebarOverlay').classList.toggle('active');
    });
    document.getElementById('sidebarOverlay').addEventListener('click', function () {
        document.body.classList.remove('sb-sidenav-toggled');
        this.classList.remove('active');
    });
</script>
</body>
</html>
