<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Account Settings - My Bill Book</title>

    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>

    <style>
        :root {
            --primary: #2563eb;
            --primary-light: #eff6ff;
            --text-dark: #1f2937;
            --text-muted: #6b7280;
            --border: #e5e7eb;
            --bg-light: #f9fafb;
            --white: #ffffff;
        }

        body {
            background-color: var(--bg-light);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-dark);
        }

        .brand-gradient {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
        }

        .main-card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 12px;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }

        .section-header {
            background: var(--primary-light);
            margin: -1.5rem -1.5rem 2rem -1.5rem;
            padding: 1rem 1.5rem;
            border-radius: 12px 12px 0 0;
            border-bottom: 1px solid var(--border);
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-dark);
            margin: 0;
        }

        .form-section {
            margin-bottom: 2.5rem;
        }

        .section-subtitle {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--primary-light);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .form-control {
            border: 1.5px solid var(--border);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .form-control:read-only {
            background-color: #f8fafc;
            color: var(--text-muted);
        }

        .input-group {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            z-index: 2;
        }

        .input-group .form-control {
            padding-left: 2.5rem;
        }

        .qr-section {
            background: var(--bg-light);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
        }

        .qr-preview {
            max-width: 150px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: var(--white);
            padding: 8px;
        }

        .checkbox-group {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 0.5rem;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--white);
            border: 1.5px solid var(--border);
            border-radius: 6px;
            padding: 0.75rem 1rem;
            cursor: pointer;
            transition: all 0.2s ease;
            min-width: 120px;
        }

        .checkbox-item:hover {
            border-color: var(--primary);
            background: var(--primary-light);
        }

        .checkbox-item input[type="checkbox"] {
            margin: 0;
            accent-color: var(--primary);
        }

        .checkbox-item.checked {
            border-color: var(--primary);
            background: var(--primary-light);
        }

        .status-badge {
            background: #10b981;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
            display: inline-block;
        }

        .btn-save {
            background: var(--primary);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 500;
            transition: background-color 0.2s ease;
        }

        .btn-save:hover {
            background: #1d4ed8;
        }

        .alert-success {
            border: none;
            border-radius: 8px;
            background: #10b981;
            color: white;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .checkbox-group {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            }
        }
    </style>
</head>
<body class="sb-nav-fixed">

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark brand-gradient">
   <a class="navbar-brand ps-3 fw-bold" href="#" onclick="showSection('dashboard')">
         <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgwIiBoZWlnaHQ9IjQwIiB2aWV3Qm94PSIwIDAgMTgwIDQwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iNSIgeTE9IjMiIHgyPSIyNSIgeTI9IjI3IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiNmZmZmZmYiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjZjJmMmYyIi8+CjwvbGluZWFyR3JhZGllbnQ+CjxsaW5lYXJHcmFkaWVudCBpZD0icGFpbnQxX2xpbmVhciIgeDE9IjE3IiB5MT0iMTMiIHgyPSIyOCIgeTI9IjI0IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMxMEI5ODEiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDU5NjY5Ii8+CjwvbGluZWFyR3JhZGllbnQ+CjwvZGVmcz4KPCEtLSBEb2N1bWVudC9CaWxsIEljb24gLS0+CjxyZWN0IHg9IjUiIHk9IjMiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyNCIgcng9IjMiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcikiLz4KPCEtLSBMaW5lcyBvbiBkb2N1bWVudCAtLT4KPHBhdGggZD0iTTkgOWg4bS04IDNaNW0tNSAzaDciIHN0cm9rZT0iIzJGNDc1OSIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPCEtLSBDaGVja21hcmsgLS0+CjxjaXJjbGUgY3g9IjIyLjUiIGN5PSIxOC41IiByPSI1LjUiIGZpbGw9InVybCgjcGFpbnQxX2xpbmVhcikiLz4KPHBhdGggZD0ibTIwIDE4LjUgMiAyIDQtNCIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8IS0tIFRleHQgLS0+Cjx0ZXh0IHg9IjM1IiB5PSIxNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmb250LXdlaWdodD0iNzAwIiBmaWxsPSJ3aGl0ZSI+CkJpbGxNYXRlUHJvPC90ZXh0Pgo8dGV4dCB4PSIzNSIgeT0iMjYiIGZvbnQtZmFtaWx5PSJJbnRlciwgc2Fucy1zZXJpZiIgZm9udC1zaXplPSI4IiBmaWxsPSIjZTJlOGYwIj4KWW91ciBCaWxsaW5nIFBhcnRuZXI8L3RleHQ+Cjwvc3ZnPg=="
              alt="BillMatePro" style="height: 50px; margin-right: 8px;">
       </a>
    <button class="btn btn-outline-light btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>
    <div class="ms-auto d-flex align-items-center gap-3 pe-3">
        <div class="dropdown">
            <a class="nav-link dropdown-toggle text-white" id="navbarDropdown" href="#" data-bs-toggle="dropdown">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div id="layoutSidenav">
    <div id="layoutSidenav_nav">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp"/>
    </div>

    <div id="layoutSidenav_content">
        <main class="container-fluid py-4">
            <div class="main-card p-4">
                <div class="section-header">
                    <h4 class="section-title">
                        <i class="bi bi-gear me-2"></i>Account Settings
                    </h4>
                </div>

                <form name="account-settings-form" action="${pageContext.request.contextPath}/company/update-owner-details" method="POST">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="ownerId" value="${ownerInfo.ownerId}"/>

                    <!-- Basic Info -->
                    <div class="form-section">
                        <h6 class="section-subtitle">Basic Information</h6>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">User Name</label>
                                    <div class="input-group">
                                        <i class="bi bi-person input-icon"></i>
                                        <input type="text" readonly class="form-control" value="${ownerInfo.userName}" name="username"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">Shop Name</label>
                                    <div class="input-group">
                                        <i class="bi bi-shop input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.shopName}" name="shopName"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">Owner Name</label>
                                    <div class="input-group">
                                        <i class="bi bi-person-badge input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.ownerName}" name="ownerName"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Info -->
                    <div class="form-section">
                        <h6 class="section-subtitle">Contact & Shop Information</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Shop Address</label>
                                    <div class="input-group">
                                        <i class="bi bi-geo-alt input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.address}" name="address"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">Phone Number</label>
                                    <div class="input-group">
                                        <i class="bi bi-telephone input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.mobNumber}" name="mobNumber"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">Email</label>
                                    <div class="input-group">
                                        <i class="bi bi-envelope input-icon"></i>
                                        <input type="email" class="form-control" value="${ownerInfo.email}" name="email"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Business Info -->
                    <div class="form-section">
                        <h6 class="section-subtitle">Business Information</h6>
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">GST Number</label>
                                    <div class="input-group">
                                        <i class="bi bi-receipt input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.gstNumber}" name="gstNumber"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">LC Number</label>
                                    <div class="input-group">
                                        <i class="bi bi-card-list input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.lcNo}" name="lcNo"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">Plan Valid Upto</label>
                                    <div class="input-group">
                                        <i class="bi bi-calendar input-icon"></i>
                                        <input type="text" readonly class="form-control"
                                               value="<fmt:formatDate value='${ownerInfo.expDate}' pattern='dd/MM/yyyy hh:mm a'/>"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">Invoice Type</label>
                                    <div class="input-group">
                                        <i class="bi bi-file-earmark-text input-icon"></i>
                                        <select name="invoiceType" class="form-control">
                                            <option value="A4" ${ownerInfo.invoiceType == 'A4' ? 'selected' : ''}>A4 - Page Size</option>
                                            <option value="A0" ${ownerInfo.invoiceType == 'A0' ? 'selected' : ''}>4x6 - Thermal</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- UPI & QR Code -->
                    <div class="form-section">
                        <h6 class="section-subtitle">Payment Information</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">UPI ID</label>
                                    <div class="input-group">
                                        <i class="bi bi-upc-scan input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.upiId}" name="upiId"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">QR Code Preview</label>
                                    <div class="qr-section">
                                        <img src="data:image/png;base64,${QRCODE}" class="qr-preview"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Terms & Conditions -->
                    <div class="form-section">
                        <div class="form-group">
                            <label class="form-label">Terms & Conditions</label>
                            <textarea name="terms" class="form-control" rows="4">${ownerInfo.terms}</textarea>
                        </div>
                    </div>

                    <!-- Invoice Columns -->
                    <div class="form-section">
                        <h6 class="section-subtitle">Invoice Display Settings</h6>
                        <div class="form-group">
                            <label class="form-label">Select columns to display on invoices</label>
                            <div class="checkbox-group">
                                <label class="checkbox-item ${selectedCols.contains('BRAND') ? 'checked' : ''}">
                                    <input type="checkbox" name="invoiceColms" value="BRAND"
                                           <c:if test="${selectedCols.contains('BRAND')}">checked</c:if>>
                                    Brand
                                </label>

                                <label class="checkbox-item ${selectedCols.contains('BATCHNO') ? 'checked' : ''}">
                                    <input type="checkbox" name="invoiceColms" value="BATCHNO"
                                           <c:if test="${selectedCols.contains('BATCHNO')}">checked</c:if>>
                                    Batch No.
                                </label>

                                <label class="checkbox-item ${selectedCols.contains('EXPD') ? 'checked' : ''}">
                                    <input type="checkbox" name="invoiceColms" value="EXPD"
                                           <c:if test="${selectedCols.contains('EXPD')}">checked</c:if>>
                                    Exp. Date
                                </label>

                                <label class="checkbox-item ${selectedCols.contains('MRP') ? 'checked' : ''}">
                                    <input type="checkbox" name="invoiceColms" value="MRP"
                                           <c:if test="${selectedCols.contains('MRP')}">checked</c:if>>
                                    MRP
                                </label>

                                <label class="checkbox-item ${selectedCols.contains('DISCOUNT') ? 'checked' : ''}">
                                    <input type="checkbox" name="invoiceColms" value="DISCOUNT"
                                           <c:if test="${selectedCols.contains('DISCOUNT')}">checked</c:if>>
                                    Discount
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Status -->
                    <div class="form-section">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Account Status</label>
                                    <div>
                                        <span class="status-badge">${ownerInfo.status}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Save Button -->
                    <div class="text-end">
                        <button type="submit" class="btn-save">
                            <i class="bi bi-save me-1"></i> Save Changes
                        </button>
                    </div>
                </form>

                <!-- Success Alert -->
                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-dismissible fade show mt-4" id="success-alert">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                    </div>
                    <script>
                        window.addEventListener('load', () => {
                            setTimeout(() => {
                                const el = document.getElementById('success-alert');
                                if (el) bootstrap.Alert.getOrCreateInstance(el).close();
                            }, 3500);
                        });
                    </script>
                </c:if>
            </div>
        </main>
    </div>
</div>

<!-- Logout form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

<script>
// Simple checkbox interactions
document.addEventListener('DOMContentLoaded', function() {
    const checkboxItems = document.querySelectorAll('.checkbox-item');

    checkboxItems.forEach(item => {
        const checkbox = item.querySelector('input[type="checkbox"]');

        item.addEventListener('click', function(e) {
            if (e.target.type !== 'checkbox') {
                checkbox.checked = !checkbox.checked;
            }
            item.classList.toggle('checked', checkbox.checked);
        });

        // Initialize state
        item.classList.toggle('checked', checkbox.checked);
    });
});
</script>

</body>
</html>