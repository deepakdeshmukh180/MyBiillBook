<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice #${invoiceNo} – ${profile.custName}</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-color: #2247A5;
            --primary-light: #3B82F6;
            --secondary-color: #10B981;
            --accent-color: #F59E0B;
            --text-dark: #111827;
            --text-medium: #374151;
            --text-light: #6B7280;
            --border-color: #E5E7EB;
            --bg-light: #F8FAFC;
            --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 50%, #f8fafc 100%);
            margin: 0;
            padding: 20px;
            color: var(--text-dark);
            font-size: 14px;
            line-height: 1.5;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
            min-height: 100vh;
        }

        /* A5 Page Container */
        .page-container {
            width: 210mm;
            height: 148mm;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            position: relative;
            border: 1px solid var(--border-color);
            transform-origin: top center;
        }

        /* Invoice Content */
        .invoice {
            width: 100%;
            height: 100%;
            padding: 6mm;
            background: white;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        /* Decorative Header Background */
        .invoice::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 15mm;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            opacity: 0.03;
            z-index: 0;
        }

        /* Header Section */
        .invoice-header {
            border-bottom: 3px solid var(--primary-color);
            padding-bottom: 4mm;
            margin-bottom: 4mm;
            position: relative;
            z-index: 1;
            background: white;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 3mm;
        }

        .company-info {
            display: flex;
            align-items: center;
            gap: 3mm;
            flex: 1;
        }

        .company-logo {
            height: 12mm;
            width: auto;
            flex-shrink: 0;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
        }

        .company-text h1 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 1mm;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            text-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }

        .company-details {
            font-size: 9px;
            line-height: 1.4;
            color: var(--text-medium);
        }

        .company-details p {
            margin-bottom: 1px;
            display: flex;
            align-items: center;
            gap: 3px;
        }

        .company-details i {
            width: 10px;
            font-size: 8px;
            color: var(--primary-color);
        }

        .invoice-meta {
            text-align: right;
            border: 2px solid var(--primary-color);
            padding: 3mm;
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            min-width: 38mm;
            position: relative;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(34, 71, 165, 0.1);
        }

        .invoice-meta h2 {
            font-size: 14px;
            margin-bottom: 2mm;
            font-weight: 600;
            color: var(--primary-color);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Enhanced QR Code in header */
        .header-qr {
            position: absolute;
            top: 2mm;
            left: -26mm;
            width: 22mm;
            height: 22mm;
            border: 2px solid var(--primary-color);
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(34, 71, 165, 0.15);
        }

        .header-qr img {
            max-width: 18mm;
            max-height: 18mm;
        }

        .header-qr i {
            font-size: 16px;
            color: var(--primary-color);
        }

        .invoice-meta .meta-item {
            margin-bottom: 1mm;
            font-size: 9px;
            font-weight: 600;
            color: var(--text-medium);
        }

        .invoice-meta .meta-item strong {
            color: var(--primary-color);
        }

        /* Enhanced Customer Section */
        .customer-section {
            background: linear-gradient(135deg, var(--bg-light) 0%, #ffffff 100%);
            border: 1px solid var(--border-color);
            padding: 3mm;
            margin-bottom: 3mm;
            border-left: 4px solid var(--secondary-color);
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }

        .customer-title {
            font-weight: 600;
            font-size: 12px;
            margin-bottom: 3mm;
            color: var(--text-dark);
            text-transform: uppercase;
            display: flex;
            align-items: center;
            gap: 2mm;
            letter-spacing: 0.5px;
        }

        .customer-title i {
            color: var(--secondary-color);
            font-size: 14px;
        }

        .customer-details {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2mm;
        }

        .customer-item {
            font-size: 10px;
            font-weight: 600;
            color: var(--text-medium);
            line-height: 1.4;
        }

        .customer-item strong {
            color: var(--text-dark);
            font-weight: 800;
        }

        /* Enhanced Items Table */
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 3mm;
            border: 2px solid var(--primary-color);
            flex: 1;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(34, 71, 165, 0.1);
        }

        .items-table thead th {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            color: white;
            padding: 2.5mm 1mm;
            font-weight: 600;
            text-align: center;
            font-size: 8px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            border-right: 1px solid rgba(255,255,255,0.2);
            text-shadow: 0 1px 2px rgba(0,0,0,0.2);
        }

        .items-table thead th:last-child {
            border-right: none;
        }

        .items-table thead th.text-left {
            text-align: left;
        }

        .items-table thead th.text-right {
            text-align: right;
        }

        .items-table tbody tr {
            border-bottom: 1px solid var(--border-color);
            transition: background-color 0.2s ease;
        }

        .items-table tbody tr:nth-child(even) {
            background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
        }

        .items-table tbody tr:hover {
            background: linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 100%);
        }

        .items-table tbody td {
            padding: 1mm 1mm;
            font-size: 8px;
            color: var(--text-dark);
            font-weight: 600;
            text-align: center;
            border-right: 1px solid var(--border-color);
        }

        .items-table tbody td:last-child {
            border-right: none;
        }

        .items-table .description {
            text-align: left !important;
            font-weight: 700;
        }

        .items-table .text-right {
            text-align: right !important;
            font-weight: 600;
        }

        .items-table .amount {
            font-weight: 600;
            color: var(--primary-color);
        }

        /* Enhanced Bottom Section */
        .bottom-section {
            display: grid;
            grid-template-columns: 1.3fr 52mm;
            gap: 3mm;
            margin-top: auto;
        }

        /* Enhanced Terms Section */
        .terms-section {
            border: 1px solid var(--border-color);
            padding: 2.5mm;
            background: linear-gradient(135deg, #ffffff 0%, var(--bg-light) 100%);
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }

        .terms-title {
            font-weight: 600;
            margin-bottom: 1.5mm;
            font-size: 9px;
            color: var(--text-dark);
            text-transform: uppercase;
            display: flex;
            align-items: center;
            gap: 2mm;
        }

        .terms-title i {
            color: var(--accent-color);
        }

        .terms-text {
            font-size: 7px;
            line-height: 1.3;
            color: var(--text-medium);
            margin-bottom: 2.5mm;
            height: 8mm;
            overflow: hidden;
        }

        .signature-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2mm;
        }

        .signature-box {
            border: 1px dashed var(--border-color);
            padding: 2mm;
            text-align: center;
            font-size: 7px;
            font-weight: 600;
            color: var(--text-medium);
            height: 8mm;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
        }

        /* Enhanced Invoice Summary */
        .invoice-summary {
            background: white;
            border: 2px solid var(--primary-color);
            padding: 2.5mm;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2mm;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(34, 71, 165, 0.15);
        }

        .summary-left, .summary-right {
            display: flex;
            flex-direction: column;
        }

        .summary-left {
            border-right: 1px solid var(--border-color);
            padding-right: 2mm;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5mm 0;
            font-size: 7px;
            border-bottom: 1px solid var(--border-color);
            font-weight: 600;
        }

        .summary-row:last-child {
            border-bottom: none;
        }

        .summary-row.highlight {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #059669 100%);
            color: white;
            margin: 1mm -2.5mm;
            padding: 2mm;
            font-weight: 600;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
        }

        .summary-row.current-balance {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            color: white;
            margin: 2mm -2.5mm 0;
            padding: 2mm;
            font-weight: 600;
            font-size: 8px;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(34, 71, 165, 0.2);
        }

        .summary-row .amount {
            font-weight: 600;
        }

        /* Enhanced Footer */
        .invoice-footer {
            text-align: center;
            padding: 1.5mm 0;
            margin-top: 2mm;
            border-top: 1px solid var(--border-color);
            font-size: 7px;
            color: var(--text-light);
            background: linear-gradient(135deg, #ffffff 0%, var(--bg-light) 100%);
            border-radius: 4px;
        }

        .invoice-footer strong {
            color: var(--primary-color);
            font-weight: 800;
        }

        /* Enhanced Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            padding: 25px;
            background: white;
            margin: 25px auto;
            max-width: 800px;
            border-radius: 12px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
            cursor: pointer;
            border: 2px solid;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            color: white;
            border-color: var(--primary-color);
            box-shadow: 0 4px 12px rgba(34, 71, 165, 0.2);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(34, 71, 165, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #10B981 0%, #059669 100%);
            color: white;
            border-color: #10B981;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
        }

        .btn-outline {
            background: white;
            color: var(--text-dark);
            border-color: var(--border-color);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .btn-outline:hover {
            background: var(--text-dark);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(17, 24, 39, 0.2);
        }

        /* Print Styles */
        @media print {
            @page {
                size: A5 landscape;
                margin: 0;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            * {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            body {
                background: white !important;
                padding: 0 !important;
                margin: 0 !important;
                font-size: 12px !important;
            }

            .page-container {
                width: 210mm !important;
                height: 148mm !important;
                max-width: none !important;
                margin: 0 !important;
                box-shadow: none !important;
                border-radius: 0 !important;
                background: white !important;
                border: none !important;
                transform: none !important;
            }

            .invoice {
                padding: 4mm !important;
                height: 140mm !important;
            }

            .action-buttons {
                display: none !important;
            }

            .invoice-header {
                border-bottom: 2px solid var(--primary-color) !important;
            }

            .invoice-meta {
                border: 2px solid var(--primary-color) !important;
            }

            .customer-section {
                border-left: 3px solid var(--secondary-color) !important;
            }

            .items-table {
                border: 2px solid var(--primary-color) !important;
            }

            .items-table thead th {
                background: var(--primary-color) !important;
                color: white !important;
            }

            .summary-row.highlight {
                background: var(--secondary-color) !important;
                color: white !important;
            }

            .summary-row.current-balance {
                background: var(--primary-color) !important;
                color: white !important;
            }
        }

        /* Mobile Responsive */
        @media screen and (max-width: 768px) {
            body {
                padding: 15px;
            }

            .page-container {
                width: 100%;
                height: auto;
                min-height: 148mm;
                transform: scale(0.8);
                margin-bottom: 40px;
            }

            .invoice {
                height: auto;
                padding: 20px;
            }

            .header-top {
                flex-direction: column;
                gap: 15px;
            }

            .company-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .customer-details {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .bottom-section {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 10px;
                padding: 20px;
            }
        }

        @media screen and (max-width: 480px) {
            .page-container {
                transform: scale(0.6);
                margin-bottom: 60px;
            }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="page-container" id="invoice-container">
    <!-- Enhanced Invoice -->
    <div class="invoice">
        <!-- Enhanced Header -->
        <div class="invoice-header">
            <div class="header-top">
                <div class="company-info">
                    <!-- Enhanced Logo -->
                    <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgwIiBoZWlnaHQ9IjQwIiB2aWV3Qm94PSIwIDAgMTgwIDQwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iNSIgeTE9IjMiIHgyPSIyNSIgeTI9IjI3IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMyMjQ3QTUiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMTQ1RkEwIi8+CjwvbGluZWFyR3JhZGllbnQ+CjxsaW5lYXJHcmFkaWVudCBpZD0icGFpbnQxX2xpbmVhciIgeDE9IjE3IiB5MT0iMTMiIHgyPSIyOCIgeTI9IjI0IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMxMEI5ODEiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDU5NjY5Ii8+CjwvbGluZWFyR3JhZGllbnQ+CjwvZGVmcz4KPCEtLSBEb2N1bWVudC9CaWxsIEljb24gLS0+CjxyZWN0IHg9IjUiIHk9IjMiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyNCIgcng9IjMiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcikiLz4KPCEtLSBMaW5lcyBvbiBkb2N1bWVudCAtLT4KPHBhdGggZD0iTTkgOWg4bS04IDRINW0tNSAzaDciIHN0cm9rZT0iI2ZmZmZmZiIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPCEtLSBDaGVja21hcmsgLS0+CjxjaXJjbGUgY3g9IjIyLjUiIGN5PSIxOC41IiByPSI1LjUiIGZpbGw9InVybCgjcGFpbnQxX2xpbmVhcikiLz4KPHBhdGggZD0ibTIwIDE4LjUgMiAyIDQtNCIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8IS0tIFRleHQgLS0+Cjx0ZXh0IHg9IjM1IiB5PSIxNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmb250LXdlaWdodD0iNzAwIiBmaWxsPSIjMjI0N0E1Ij4KQmlsbE1hdGVQcm88L3RleHQ+Cjx0ZXh0IHg9IjM1IiB5PSIyNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjgiIGZpbGw9IiM2Mzc1OEEiPgpZb3VyIEJpbGxpbmcgUGFydG5lcjwvdGV4dD4KPC9zdmc+"
                         alt="BillMatePro" class="company-logo">
                    <div class="company-text">
                        <h1>${ownerInfo.shopName}</h1>
                        <div class="company-details">
                            <p><i class="fas fa-map-marker-alt"></i> ${ownerInfo.address}</p>
                            <p><i class="fas fa-user"></i> ${ownerInfo.ownerName}</p>
                            <p><i class="fas fa-phone"></i> ${ownerInfo.mobNumber}</p>
                            <p><i class="fas fa-id-card"></i> <strong>LC:</strong> ${ownerInfo.lcNo} | <strong>GST:</strong> ${ownerInfo.gstNumber}</p>
                        </div>
                    </div>
                </div>

                <div class="invoice-meta">
                    <!-- Enhanced QR Code -->
                    <div class="header-qr">
                        <c:choose>
                            <c:when test="${not empty QRCODE}">
                                <img src="data:image/png;base64,${QRCODE}" alt="QR Code" />
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-qrcode"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h2>TAX INVOICE</h2>
                    <div class="meta-item"><strong>Invoice #:</strong> ${invoiceNo}</div>
                    <div class="meta-item"><strong>Date:</strong> ${date}</div>
                </div>
            </div>
        </div>

        <!-- Enhanced Customer Section -->
        <div class="customer-section">
            <div class="customer-title">
                <i class="fas fa-user-circle"></i>
                Customer Details
            </div>
            <div class="customer-details">
                <div class="customer-item">
                    <strong>Name:</strong> ${profile.custName}
                </div>
                <div class="customer-item">
                    <strong>Contact:</strong> ${profile.phoneNo}
                </div>
                <div class="customer-item">
                    <strong>Address:</strong> ${profile.address}
                </div>
            </div>
        </div>

        <!-- Enhanced Items Table -->
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width:6%">SR</th>
                    <th style="width:32%" class="text-left">Description</th>
                    <c:if test="${invoiceColms.contains('BRAND')}">
                        <th style="width:10%">Brand</th>
                    </c:if>
                    <c:if test="${invoiceColms.contains('BATCHNO')}">
                        <th style="width:8%">Batch</th>
                    </c:if>
                    <c:if test="${invoiceColms.contains('EXPD')}">
                        <th style="width:7%">Exp.</th>
                    </c:if>
                    <c:if test="${invoiceColms.contains('MRP')}">
                        <th style="width:9%" class="text-right">MRP</th>
                    </c:if>
                    <th style="width:6%">Qty</th>
                    <th style="width:11%" class="text-right">Rate</th>
                    <th style="width:11%" class="text-right">Amount</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${items}" var="item">
                    <tr>
                        <td>${item.itemNo}</td>
                        <td class="description">${item.description}</td>
                        <c:if test="${invoiceColms.contains('BRAND')}">
                            <td>${empty item.brand ? 'N/A' : item.brand}</td>
                        </c:if>
                        <c:if test="${invoiceColms.contains('BATCHNO')}">
                            <td>${item.batchNo}</td>
                        </c:if>
                        <c:if test="${invoiceColms.contains('EXPD')}">
                            <td>${empty item.expDate ? 'N/A' : item.expDate}</td>
                        </c:if>
                        <c:if test="${invoiceColms.contains('MRP')}">
                            <td class="text-right">₹${item.mrp}</td>
                        </c:if>
                        <td>${item.qty}</td>
                        <td class="text-right">₹${item.rate}</td>
                        <td class="text-right amount">₹${item.amount}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Enhanced Bottom Section -->
        <div class="bottom-section">
            <!-- Enhanced Terms & Conditions -->
            <div class="terms-section">
                <div class="terms-title">
                    <i class="fas fa-file-contract"></i>
                    Terms & Conditions
                </div>
                <div class="terms-text">
                    ${ownerInfo.terms}
                </div>
                <div class="signature-section">
                    <div class="signature-box">
                        <i class="fas fa-signature" style="margin-right: 2mm; color: var(--text-light);"></i>
                        Customer Signature
                    </div>
                    <div class="signature-box">
                        <i class="fas fa-store" style="margin-right: 2mm; color: var(--text-light);"></i>
                        For ${ownerInfo.shopName}
                    </div>
                </div>
            </div>

            <!-- Enhanced Invoice Summary -->
            <div class="invoice-summary">
                <!-- Left Column -->
                <div class="summary-left">
                    <div class="summary-row">
                        <span><i class="fas fa-calculator" style="margin-right: 2px; color: var(--primary-color);"></i>Sub Total</span>
                        <span class="amount">₹${totalAmout}</span>
                    </div>
                    <div class="summary-row">
                        <span><i class="fas fa-credit-card" style="margin-right: 2px; color: var(--secondary-color);"></i>Paid </span>
                        <span class="amount">₹${advamount}</span>
                    </div>
                    <div class="summary-row">
                        <span><i class="fas fa-receipt" style="margin-right: 2px;"></i>Net Total</span>
                        <span class="amount">₹${totalAmout - advamount}</span>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="summary-right">
                    <div class="summary-row">
                        <span><i class="fas fa-percentage" style="margin-right: 2px; color: var(--accent-color);"></i>GST</span>
                        <span class="amount">₹${currentinvoiceitems.tax}</span>
                    </div>
                    <div class="summary-row">
                        <span><i class="fas fa-history" style="margin-right: 2px; color: var(--text-light);"></i>Prev Bal</span>
                        <span class="amount">₹${currentinvoiceitems.preBalanceAmt}</span>
                    </div>
                    <div class="summary-row">
                        <span><i class="fas fa-wallet" style="margin-right: 2px;"></i>Cur Bal</span>
                        <span class="amount">₹${profile.currentOusting}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enhanced Footer -->
        <div class="invoice-footer">
            <i class="fas fa-code" style="margin-right: 2px; color: var(--primary-color);"></i>
            Generated by <strong>BillMatePro Solution</strong> •
            <i class="fas fa-phone" style="margin: 0 2px; color: var(--secondary-color);"></i>
            Contact: 8180080378
        </div>
    </div>
</div>

<!-- Enhanced Action Buttons -->
<div class="action-buttons">
    <button class="btn btn-outline" onclick="window.location.href='${pageContext.request.contextPath}/login/home'">
        <i class="fas fa-home"></i> Home
    </button>
    <button class="btn btn-outline" onclick="printInvoice()">
        <i class="fas fa-print"></i> Print A5
    </button>
    <button class="btn btn-primary" onclick="downloadPDF()">
        <i class="fas fa-file-pdf"></i> Download PDF
    </button>
    <a href="https://wa.me/${profile.phoneNo}/?text=Namaste!!!%20*${profile.custName}*,%20आपका%20बिल%20तैयार%20है।%20Invoice%20%23${invoiceNo}%20-%20₹${profile.currentOusting}%0A%0AThank%20you%20for%20your%20business!%0A%0A-%20${ownerInfo.shopName}" target="_blank" class="btn btn-success">
        <i class="fab fa-whatsapp"></i> WhatsApp
    </a>
</div>

</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
    // Enhanced A5 Print Function
    function printInvoice() {
        const printStyle = document.createElement('style');
        printStyle.id = 'print-styles';
        printStyle.textContent = `
            @media print {
                @page {
                    size: A5 landscape;
                    margin: 2mm;
                }
                body * {
                    visibility: hidden;
                }
                #invoice-container, #invoice-container * {
                    visibility: visible;
                }
                #invoice-container {
                    position: absolute;
                    left: 0;
                    top: 0;
                    width: 206mm !important;
                    height: 144mm !important;
                    transform: none !important;
                }
                .invoice {
                    padding: 3mm !important;
                }
                .company-logo {
                    height: 10mm !important;
                }
                .items-table {
                    font-size: 7px !important;
                }
                .summary-row {
                    font-size: 6px !important;
                }
            }
        `;
        document.head.appendChild(printStyle);

        // Trigger print
        window.print();

        // Clean up
        setTimeout(() => {
            const style = document.getElementById('print-styles');
            if (style) {
                document.head.removeChild(style);
            }
        }, 1000);
    }

    // Enhanced PDF Download with better quality
    function downloadPDF() {
        const element = document.getElementById('invoice-container');
        const customerName = '${profile.custName}' || 'Customer';
        const invoiceNo = '${invoiceNo}' || 'INV001';
        const currentDate = new Date().toISOString().slice(0, 10);

        // Show loading indicator
        const originalContent = element.innerHTML;
        const loadingDiv = document.createElement('div');
        loadingDiv.innerHTML = `
            <div style="display: flex; justify-content: center; align-items: center; height: 148mm; font-family: Inter, sans-serif;">
                <div style="text-align: center;">
                    <div style="width: 40px; height: 40px; border: 4px solid #f3f3f3; border-top: 4px solid #2247A5; border-radius: 50%; animation: spin 1s linear infinite; margin: 0 auto 20px;"></div>
                    <p style="color: #374151; font-weight: 600;">Generating PDF...</p>
                </div>
            </div>
            <style>
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
            </style>
        `;

        const opt = {
            margin: [1, 1, 1, 1],
            filename: `${customerName}_Invoice_${invoiceNo}_${currentDate}.pdf`,
            image: {
                type: 'jpeg',
                quality: 0.95
            },
            html2canvas: {
                scale: 4,
                useCORS: true,
                allowTaint: true,
                backgroundColor: '#ffffff',
                width: 1190, // A5 landscape at high DPI
                height: 842,
                scrollX: 0,
                scrollY: 0,
                letterRendering: true
            },
            jsPDF: {
                unit: 'mm',
                format: [210, 148], // A5 landscape
                orientation: 'landscape',
                compress: true,
                precision: 2
            }
        };

        // Generate PDF with enhanced error handling
        html2pdf()
            .set(opt)
            .from(element)
            .save()
            .then(() => {
                console.log('PDF generated successfully');
            })
            .catch((error) => {
                console.error('PDF generation failed:', error);
                alert('PDF generation failed. Please try the print option or check your browser settings.');
            });
    }

    // Enhanced responsive scaling
    function adjustInvoiceScale() {
        const container = document.getElementById('invoice-container');
        const viewport = window.innerWidth;

        if (viewport < 480) {
            container.style.transform = 'scale(0.5)';
            container.style.marginBottom = '80px';
        } else if (viewport < 768) {
            container.style.transform = 'scale(0.7)';
            container.style.marginBottom = '60px';
        } else if (viewport < 1200) {
            container.style.transform = 'scale(0.9)';
            container.style.marginBottom = '40px';
        } else {
            container.style.transform = 'scale(1)';
            container.style.marginBottom = '20px';
        }
    }

    // Print event handlers
    window.addEventListener('beforeprint', function() {
        document.body.style.background = 'white';
        const container = document.getElementById('invoice-container');
        container.style.transform = 'scale(1)';
        container.style.boxShadow = 'none';
    });

    window.addEventListener('afterprint', function() {
        document.body.style.background = 'linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 50%, #f8fafc 100%)';
        adjustInvoiceScale();
    });

    // Initialize on load
    window.addEventListener('load', function() {
        adjustInvoiceScale();

        // Preload fonts for better PDF quality
        document.fonts.ready.then(() => {
            console.log('Fonts loaded for enhanced invoice rendering');
        });
    });

    window.addEventListener('resize', adjustInvoiceScale);

    // Add smooth animations for buttons
    document.addEventListener('DOMContentLoaded', function() {
        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(button => {
            button.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px) scale(1.02)';
            });

            button.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    });

    // Enhanced keyboard shortcuts
    document.addEventListener('keydown', function(event) {
        if (event.ctrlKey || event.metaKey) {
            switch(event.key) {
                case 'p':
                    event.preventDefault();
                    printInvoice();
                    break;
                case 's':
                    event.preventDefault();
                    downloadPDF();
                    break;
                case 'h':
                    event.preventDefault();
                    window.location.href = '${pageContext.request.contextPath}/login/home';
                    break;
            }
        }
    });
</script>

</body>
</html>