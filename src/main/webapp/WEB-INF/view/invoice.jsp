<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thermal Invoice #${invoiceNo} – ${profile.custName}</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            --border-color: #1F2937;
            --bg-white: #ffffff;
            --bg-light: #F8FAFC;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 50%, #f8fafc 100%);
            margin: 0;
            padding: 15px;
            color: var(--text-dark);
            font-size: 11px;
            line-height: 1.3;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
            min-height: 100vh;
        }

        /* Enhanced 4×6 Thermal Paper Container */
        .thermal-container {
            width: 101.6mm;
            max-width: 101.6mm;
            min-height: 152.4mm;
            margin: 0 auto;
            background: white;
            border: 2px solid var(--border-color);
            overflow: hidden;
            position: relative;
            box-shadow: var(--shadow);
            border-radius: 8px;
        }

        /* Enhanced Invoice Content */
        .thermal-invoice {
            width: 100%;
            padding: 3.5mm;
            background: white;
            box-sizing: border-box;
            position: relative;
        }

        /* Decorative header accent */
        .thermal-invoice::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, var(--primary-color) 0%, var(--secondary-color) 50%, var(--accent-color) 100%);
            z-index: 1;
        }

        /* Enhanced Header Section */
        .thermal-header {
            text-align: center;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 2mm;
            margin-bottom: 2.5mm;
            position: relative;
            background: linear-gradient(135deg, #ffffff 0%, var(--bg-light) 100%);
            border-radius: 4px;
            padding: 2mm;
        }

        .header-logo-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1.5mm;
            margin-bottom: 2mm;
        }

        .thermal-logo {
            height: 8mm;
            width: auto;
            filter: drop-shadow(0 1px 3px rgba(0,0,0,0.2));
            margin-bottom: 1mm;
        }

        .shop-name {
            font-size: 13px;
            font-weight: 900;
            margin-bottom: 1mm;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--primary-color);
            text-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }

        .shop-details {
            font-size: 8px;
            line-height: 1.2;
            margin-bottom: 1.5mm;
            color: var(--text-medium);
        }

        .shop-details div {
            margin-bottom: 0.5mm;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 2px;
        }

        .shop-details i {
            color: var(--secondary-color);
            font-size: 7px;
            width: 8px;
        }

        .invoice-title {
            font-size: 11px;
            font-weight: 900;
            margin: 1.5mm 0;
            padding: 1mm 3mm;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            color: white;
            border-radius: 3px;
            text-shadow: 0 1px 2px rgba(0,0,0,0.2);
            display: inline-block;
        }

        .invoice-meta {
            font-size: 8.5px;
            display: flex;
            justify-content: space-between;
            margin-bottom: 1mm;
            font-weight: 600;
            color: var(--text-medium);
        }

        .invoice-meta strong {
            color: var(--primary-color);
        }

        /* Enhanced QR Code */
        .qr-code {
            position: absolute;
            top: 2mm;
            right: 2mm;
            width: 14mm;
            height: 14mm;
            border: 2px solid var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(34, 71, 165, 0.2);
        }

        .qr-code img {
            max-width: 11mm;
            max-height: 11mm;
        }

        .qr-code i {
            font-size: 9px;
            color: var(--primary-color);
        }

        /* Enhanced Customer Section */
        .customer-section {
            border: 2px solid var(--secondary-color);
            border-radius: 4px;
            padding: 2mm;
            margin-bottom: 2.5mm;
            font-size: 8px;
            background: linear-gradient(135deg, var(--bg-light) 0%, #ffffff 100%);
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.1);
        }

        .customer-title {
            font-size: 9px;
            font-weight: 900;
            color: var(--secondary-color);
            text-align: center;
            margin-bottom: 1.5mm;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 2px;
        }

        .customer-title i {
            font-size: 8px;
        }

        .customer-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.8mm;
            align-items: flex-start;
        }

        .customer-row:last-child {
            margin-bottom: 0;
        }

        .customer-label {
            font-weight: 800;
            min-width: 18mm;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 1.5px;
        }

        .customer-label i {
            font-size: 7px;
            color: var(--secondary-color);
            width: 8px;
        }

        .customer-value {
            text-align: right;
            flex: 1;
            word-break: break-all;
            font-weight: 600;
            color: var(--text-medium);
        }

        /* Enhanced Items Section */
        .items-section {
            margin-bottom: 2.5mm;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            overflow: hidden;
        }

        .items-header {
            background: linear-gradient(135deg, var(--text-dark) 0%, var(--text-medium) 100%);
            color: white;
            padding: 1.5mm 1mm;
            font-size: 7px;
            font-weight: 900;
            display: grid;
            grid-template-columns: 8mm 1fr 12mm 16mm;
            gap: 1mm;
            text-align: center;
            text-transform: uppercase;
            letter-spacing: 0.2px;
            text-shadow: 0 1px 2px rgba(0,0,0,0.2);
        }

        .items-header .desc-col {
            text-align: left;
        }

        .items-header .amt-col {
            text-align: right;
        }

        .item-row {
            padding: 1.5mm 1mm;
            font-size: 7px;
            display: grid;
            grid-template-columns: 8mm 1fr 12mm 16mm;
            gap: 1mm;
            border-bottom: 1px dotted var(--border-color);
            align-items: start;
            background: white;
            transition: background-color 0.2s ease;
        }

        .item-row:nth-child(even) {
            background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .item-sr {
            text-align: center;
            font-weight: 900;
            color: var(--primary-color);
            background: var(--bg-light);
            border-radius: 2px;
            padding: 0.5mm 0;
        }

        .item-desc {
            text-align: left;
            word-break: break-word;
            line-height: 1.2;
            font-weight: 700;
            color: var(--text-dark);
        }

        .item-desc-details {
            font-size: 6px;
            color: var(--text-light);
            margin-top: 0.8mm;
            line-height: 1.1;
            font-weight: 500;
        }

        .item-desc-details i {
            color: var(--accent-color);
            margin-right: 1px;
        }

        .item-qty {
            text-align: center;
            font-weight: 900;
            color: var(--secondary-color);
            background: var(--bg-light);
            border-radius: 2px;
            padding: 0.5mm 0;
        }

        .item-amt {
            text-align: right;
            font-weight: 900;
            color: var(--primary-color);
            background: linear-gradient(135deg, #f0f4ff 0%, #ffffff 100%);
            border-radius: 2px;
            padding: 0.5mm 1mm;
        }

        /* Enhanced Summary Section */
        .summary-section {
            border-top: 3px solid var(--primary-color);
            background: linear-gradient(135deg, #ffffff 0%, var(--bg-light) 100%);
            border-radius: 6px;
            padding: 2.5mm 2mm 2mm;
            margin-bottom: 2.5mm;
            box-shadow: 0 2px 8px rgba(34, 71, 165, 0.1);
        }

        .summary-title {
            text-align: center;
            font-size: 9px;
            font-weight: 900;
            color: var(--primary-color);
            margin-bottom: 2mm;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            font-size: 8px;
            margin-bottom: 0.8mm;
            padding: 0.8mm 0;
            font-weight: 600;
        }

        .summary-row.highlight {
            font-weight: 900;
            background: linear-gradient(135deg, var(--secondary-color) 0%, #059669 100%);
            color: white;
            border-radius: 3px;
            padding: 1.5mm 2mm;
            margin: 1.5mm -2mm;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
        }

        .summary-row.total {
            font-size: 9px;
            font-weight: 900;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            color: white;
            border-radius: 4px;
            padding: 2mm;
            margin: 2mm -2mm;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            box-shadow: 0 3px 8px rgba(34, 71, 165, 0.3);
        }

        .summary-label {
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 2px;
        }

        .summary-label i {
            font-size: 7px;
            opacity: 0.8;
        }

        .summary-value {
            font-weight: 900;
            text-align: right;
        }

        /* Enhanced Footer Section */
        .footer-section {
            border-top: 2px solid var(--border-color);
            padding-top: 2.5mm;
            text-align: center;
            background: linear-gradient(135deg, var(--bg-light) 0%, #ffffff 100%);
            border-radius: 4px;
            padding: 2.5mm 2mm 2mm;
        }

        .terms-compact {
            font-size: 6px;
            line-height: 1.2;
            margin-bottom: 2.5mm;
            text-align: justify;
            color: var(--text-light);
            font-weight: 500;
        }

        .signature-line {
            border-bottom: 2px dotted var(--border-color);
            margin: 3mm 0 2mm 0;
            height: 8mm;
            display: flex;
            align-items: end;
            justify-content: center;
            font-size: 7px;
            font-weight: 700;
            color: var(--text-medium);
        }

        .signature-line i {
            margin-right: 2px;
            color: var(--accent-color);
        }

        .thank-you {
            font-size: 9px;
            font-weight: 900;
            margin-bottom: 1.5mm;
            color: var(--secondary-color);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .contact-info {
            font-size: 6px;
            color: var(--text-light);
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 3px;
        }

        .contact-info i {
            color: var(--primary-color);
        }

        .contact-info strong {
            color: var(--primary-color);
        }

        /* Enhanced Action Buttons */
        .action-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            padding: 20px;
            background: white;
            margin: 20px auto;
            max-width: 600px;
            border-radius: 10px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border-color);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
            cursor: pointer;
            border: 2px solid;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
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
            box-shadow: 0 6px 16px rgba(34, 71, 165, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #059669 100%);
            color: white;
            border-color: var(--secondary-color);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(16, 185, 129, 0.3);
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
            box-shadow: 0 6px 16px rgba(17, 24, 39, 0.2);
        }

        /* Print Styles - Optimized for 4×6 Thermal */
        @media print {
            @page {
                size: 4in 6in;
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
                font-size: 10px !important;
            }

            .thermal-container {
                width: 4in !important;
                height: 6in !important;
                max-width: none !important;
                margin: 0 !important;
                box-shadow: none !important;
                border: none !important;
                border-radius: 0 !important;
                transform: none !important;
            }

            .thermal-invoice {
                padding: 2mm !important;
            }

            .action-buttons {
                display: none !important;
            }

            .thermal-header {
                border-bottom: 2px solid var(--primary-color) !important;
            }

            .customer-section {
                border: 2px solid var(--secondary-color) !important;
            }

            .items-header {
                background: var(--text-dark) !important;
                color: white !important;
            }

            .summary-row.highlight {
                background: var(--secondary-color) !important;
                color: white !important;
            }

            .summary-row.total {
                background: var(--primary-color) !important;
                color: white !important;
            }

            .footer-section {
                border-top: 2px solid var(--border-color) !important;
            }

            /* Optimized print font sizes */
            .shop-name {
                font-size: 11px !important;
            }

            .shop-details {
                font-size: 7px !important;
            }

            .invoice-meta {
                font-size: 7px !important;
            }

            .customer-section {
                font-size: 7px !important;
            }

            .items-header,
            .item-row {
                font-size: 6px !important;
            }

            .summary-row {
                font-size: 6.5px !important;
            }

            .summary-row.total {
                font-size: 8px !important;
            }
        }

        /* Mobile Responsive */
        @media screen and (max-width: 480px) {
            body {
                padding: 10px;
            }

            .thermal-container {
                width: 100%;
                max-width: 300px;
                transform: scale(0.9);
                margin-bottom: 30px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 10px;
                padding: 15px;
            }
        }

        @media screen and (max-width: 360px) {
            .thermal-container {
                transform: scale(0.8);
                margin-bottom: 40px;
            }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="thermal-container" id="thermal-invoice-container">
    <div class="thermal-invoice">

        <!-- Enhanced QR Code -->
        <div class="qr-code">
            <c:choose>
                <c:when test="${not empty QRCODE}">
                    <img src="data:image/png;base64,${QRCODE}" alt="QR" />
                </c:when>
                <c:otherwise>
                    <i class="fas fa-qrcode"></i>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Enhanced Header -->
        <div class="thermal-header">
            <div class="header-logo-section">
                <!-- Logo Integration -->
                <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgwIiBoZWlnaHQ9IjQwIiB2aWV3Qm94PSIwIDAgMTgwIDQwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8ZGVmcz4KPGxpbmVhckdyYWRpZW50IGlkPSJwYWludDBfbGluZWFyIiB4MT0iNSIgeTE9IjMiIHgyPSIyNSIgeTI9IjI3IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMyMjQ3QTUiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMTQ1RkEwIi8+CjwvbGluZWFyR3JhZGllbnQ+CjxsaW5lYXJHcmFkaWVudCBpZD0icGFpbnQxX2xpbmVhciIgeDE9IjE3IiB5MT0iMTMiIHgyPSIyOCIgeTI9IjI0IiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+CjxzdG9wIHN0b3AtY29sb3I9IiMxMEI5ODEiLz4KPHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjMDU5NjY5Ii8+CjwvbGluZWFyR3JhZGllbnQ+CjwvZGVmcz4KPCEtLSBEb2N1bWVudC9CaWxsIEljb24gLS0+CjxyZWN0IHg9IjUiIHk9IjMiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyNCIgcng9IjMiIGZpbGw9InVybCgjcGFpbnQwX2xpbmVhcikiLz4KPCEtLSBMaW5lcyBvbiBkb2N1bWVudCAtLT4KPHBhdGggZD0iTTkgOWg4bS04IDRINW0tNSAzaDciIHN0cm9rZT0iI2ZmZmZmZiIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0icm91bmQiLz4KPCEtLSBDaGVja21hcmsgLS0+CjxjaXJjbGUgY3g9IjIyLjUiIGN5PSIxOC41IiByPSI1LjUiIGZpbGw9InVybCgjcGFpbnQxX2xpbmVhcikiLz4KPHBhdGggZD0ibTIwIDE4LjUgMiAyIDQtNCIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLXdpZHRoPSIxLjUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIvPgo8IS0tIFRleHQgLS0+Cjx0ZXh0IHg9IjM1IiB5PSIxNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEyIiBmb250LXdlaWdodD0iNzAwIiBmaWxsPSIjMjI0N0E1Ij4KQmlsbE1hdGVQcm88L3RleHQ+Cjx0ZXh0IHg9IjM1IiB5PSIyNiIgZm9udC1mYW1pbHk9IkludGVyLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjgiIGZpbGw9IiM2Mzc1OEEiPgpZb3VyIEJpbGxpbmcgUGFydG5lcjwvdGV4dD4KPC9zdmc+"
                     alt="BillMatePro" class="thermal-logo">
                <div class="shop-name">${ownerInfo.shopName}</div>
            </div>

            <div class="shop-details">
                <div><i class="fas fa-map-marker-alt"></i> ${ownerInfo.address}</div>
                <div><i class="fas fa-phone"></i> ${ownerInfo.mobNumber}</div>
                <div><i class="fas fa-id-card"></i> GST: ${ownerInfo.gstNumber}</div>
            </div>
            <div class="invoice-title">TAX INVOICE</div>
            <div class="invoice-meta">
                <span><strong>Bill #:</strong> ${invoiceNo}</span>
                <span><strong>Date:</strong> ${date}</span>
            </div>
        </div>

        <!-- Enhanced Customer Section -->
        <div class="customer-section">
            <div class="customer-title">
                <i class="fas fa-user-circle"></i>
                Customer Details
            </div>
            <div class="customer-row">
                <span class="customer-label"><i class="fas fa-user"></i>Name:</span>
                <span class="customer-value">${profile.custName}</span>
            </div>
            <div class="customer-row">
                <span class="customer-label"><i class="fas fa-phone"></i>Phone:</span>
                <span class="customer-value">${profile.phoneNo}</span>
            </div>
            <div class="customer-row">
                <span class="customer-label"><i class="fas fa-map"></i>Address:</span>
                <span class="customer-value">${profile.address}</span>
            </div>
        </div>

        <!-- Enhanced Items Section -->
        <div class="items-section">
            <div class="items-header">
                <div>SR</div>
                <div class="desc-col">DESCRIPTION</div>
                <div>QTY</div>
                <div class="amt-col">AMOUNT</div>
            </div>

            <c:forEach items="${items}" var="item">
                <div class="item-row">
                    <div class="item-sr">${item.itemNo}</div>
                    <div class="item-desc">
                        <div>${item.description}</div>
                        <div class="item-desc-details">
                            <c:if test="${invoiceColms.contains('BRAND') && not empty item.brand}">
                                <i class="fas fa-tags"></i>Brand: ${item.brand}<br/>
                            </c:if>
                            <c:if test="${invoiceColms.contains('BATCHNO') && not empty item.batchNo}">
                                <i class="fas fa-barcode"></i>Batch: ${item.batchNo}<br/>
                            </c:if>
                            <c:if test="${invoiceColms.contains('EXPD') && not empty item.expDate}">
                                <i class="fas fa-calendar"></i>Exp: ${item.expDate}<br/>
                            </c:if>
                            <c:if test="${invoiceColms.contains('MRP')}">
                                <i class="fas fa-tag"></i>MRP: ₹${item.mrp}<br/>
                            </c:if>
                            <i class="fas fa-rupee-sign"></i>Rate: ₹${item.rate}
                        </div>
                    </div>
                    <div class="item-qty">${item.qty}</div>
                    <div class="item-amt">₹${item.amount}</div>
                </div>
            </c:forEach>
        </div>

        <!-- Enhanced Summary Section -->
        <div class="summary-section">
            <div class="summary-title">
                <i class="fas fa-calculator"></i> Invoice Summary
            </div>
            <div class="summary-row">
                <span class="summary-label"><i class="fas fa-plus"></i>Sub Total:</span>
                <span class="summary-value">₹${totalAmout}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label"><i class="fas fa-percentage"></i>GST:</span>
                <span class="summary-value">₹${currentinvoiceitems.tax}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label"><i class="fas fa-credit-card"></i>Paid Amount:</span>
                <span class="summary-value">₹${advamount}</span>
            </div>
            <div class="summary-row highlight">
                <span class="summary-label"><i class="fas fa-receipt"></i>Net Amount:</span>
                <span class="summary-value">₹${totalAmout - advamount}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label"><i class="fas fa-history"></i>Previous Balance:</span>
                <span class="summary-value">₹${currentinvoiceitems.preBalanceAmt}</span>
            </div>
            <div class="summary-row total">
                <span class="summary-label"><i class="fas fa-wallet"></i>Current Balance:</span>
                <span class="summary-value">₹${profile.currentOusting}</span>
            </div>
        </div>

        <!-- Enhanced Footer -->
        <div class="footer-section">
            <div class="terms-compact">
                ${fn:substring(ownerInfo.terms, 0, 150)}...
            </div>
            <div class="signature-line">
                <i class="fas fa-signature"></i>Authorized Signature
            </div>
            <div class="thank-you">
                <i class="fas fa-heart" style="color: var(--accent-color); margin-right: 2px;"></i>
                THANK YOU FOR YOUR BUSINESS!
            </div>
            <div class="contact-info">
                <i class="fas fa-code"></i>Generated by <strong>BillMatePro Solution</strong> •
                <i class="fas fa-phone"></i>8180080378
            </div>
        </div>

    </div>
</div>

<!-- Enhanced Action Buttons -->
<div class="action-buttons">
    <button class="btn btn-outline" onclick="window.location.href='${pageContext.request.contextPath}/login/home'">
        <i class="fas fa-home"></i> Home
    </button>
    <button class="btn btn-outline" onclick="printThermalInvoice()">
        <i class="fas fa-print"></i> Print 4×6
    </button>
    <button class="btn btn-primary" onclick="downloadThermalPDF()">
        <i class="fas fa-file-pdf"></i> Download PDF
    </button>
    <a href="https://wa.me/${profile.phoneNo}/?text=Namaste!!!%20*${profile.custName}*,%20आपका%20बिल%20तैयार%20है।%20Invoice%20%23${invoiceNo}%20-%20₹${profile.currentOusting}%0A%0AThank%20you%20for%20your%20business!%0A%0A-%20${ownerInfo.shopName}" target="_blank" class="btn btn-success">
        <i class="fab fa-whatsapp"></i> WhatsApp
    </a>
</div>

</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
    // Enhanced 4×6 Thermal Print Function
    function printThermalInvoice() {
        const printStyle = document.createElement('style');
        printStyle.id = 'thermal-print-styles';
        printStyle.textContent = `
            @media print {
                @page {
                    size: 4in 6in;
                    margin: 1mm;
                }
                body * {
                    visibility: hidden;
                }
                #thermal-invoice-container, #thermal-invoice-container * {
                    visibility: visible;
                }
                #thermal-invoice-container {
                    position: absolute;
                    left: 0;
                    top: 0;
                    width: 98mm !important;
                    height: 150mm !important;
                    transform: none !important;
                }
                .thermal-invoice {
                    padding: 2mm !important;
                }
                .thermal-logo {
                    height: 6mm !important;
                }
                .items-header,
                .item-row {
                    font-size: 5.5px !important;
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
            const style = document.getElementById('thermal-print-styles');
            if (style) {
                document.head.removeChild(style);
            }
        }, 1000);
    }

    // Enhanced 4×6 Thermal PDF Download
    function downloadThermalPDF() {
        const element = document.getElementById('thermal-invoice-container');
        const customerName = '${profile.custName}' || 'Customer';
        const invoiceNo = '${invoiceNo}' || 'INV001';
        const currentDate = new Date().toISOString().slice(0, 10);

        // Show loading feedback
        const originalBtnText = event.target.innerHTML;
        event.target.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
        event.target.disabled = true;

        const opt = {
            margin: [1, 1, 1, 1],
            filename: `${customerName}_Thermal_Invoice_${invoiceNo}_${currentDate}.pdf`,
            image: {
                type: 'jpeg',
                quality: 0.95
            },
            html2canvas: {
                scale: 4,
                useCORS: true,
                allowTaint: true,
                backgroundColor: '#ffffff',
                width: 384,  // 4 inches at 96 DPI
                height: 576, // 6 inches at 96 DPI
                scrollX: 0,
                scrollY: 0,
                letterRendering: true
            },
            jsPDF: {
                unit: 'in',
                format: [4, 6],
                orientation: 'portrait',
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
                console.log('Thermal PDF generated successfully');
                // Restore button
                event.target.innerHTML = originalBtnText;
                event.target.disabled = false;
            })
            .catch((error) => {
                console.error('Thermal PDF generation failed:', error);
                alert('PDF generation failed. Please try the print option or check your browser settings.');
                // Restore button
                event.target.innerHTML = originalBtnText;
                event.target.disabled = false;
            });
    }

    // Enhanced responsive scaling for thermal receipt
    function adjustThermalSize() {
        const container = document.getElementById('thermal-invoice-container');
        const viewport = window.innerWidth;

        if (viewport < 360) {
            container.style.transform = 'scale(0.75)';
            container.style.marginBottom = '50px';
        } else if (viewport < 480) {
            container.style.transform = 'scale(0.85)';
            container.style.marginBottom = '40px';
        } else if (viewport < 768) {
            container.style.transform = 'scale(0.95)';
            container.style.marginBottom = '30px';
        } else {
            container.style.transform = 'scale(1)';
            container.style.marginBottom = '20px';
        }
    }

    // Print event handlers
    window.addEventListener('beforeprint', function() {
        document.body.style.background = 'white';
        const container = document.getElementById('thermal-invoice-container');
        container.style.transform = 'scale(1)';
        container.style.boxShadow = 'none';
    });

    window.addEventListener('afterprint', function() {
        document.body.style.background = 'linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 50%, #f8fafc 100%)';
        adjustThermalSize();
    });

    // Initialize on load
    window.addEventListener('load', function() {
        adjustThermalSize();

        // Preload fonts for better thermal rendering
        document.fonts.ready.then(() => {
            console.log('Fonts loaded for enhanced thermal invoice rendering');
        });
    });

    window.addEventListener('resize', adjustThermalSize);

    // Add smooth animations for buttons
    document.addEventListener('DOMContentLoaded', function() {
        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(button => {
            button.addEventListener('mouseenter', function() {
                if (!this.disabled) {
                    this.style.transform = 'translateY(-2px) scale(1.02)';
                }
            });

            button.addEventListener('mouseleave', function() {
                if (!this.disabled) {
                    this.style.transform = 'translateY(0) scale(1)';
                }
            });
        });
    });

    // Enhanced keyboard shortcuts for thermal receipt
    document.addEventListener('keydown', function(event) {
        if (event.ctrlKey || event.metaKey) {
            switch(event.key) {
                case 'p':
                    event.preventDefault();
                    printThermalInvoice();
                    break;
                case 's':
                    event.preventDefault();
                    downloadThermalPDF();
                    break;
                case 'h':
                    event.preventDefault();
                    window.location.href = '${pageContext.request.contextPath}/login/home';
                    break;
                case 't':
                    event.preventDefault();
                    // Focus on thermal container for better accessibility
                    document.getElementById('thermal-invoice-container').focus();
                    break;
            }
        }
    });

    // Add thermal-specific optimizations
    function optimizeThermalRendering() {
        const container = document.getElementById('thermal-invoice-container');

        // Ensure proper thermal receipt sizing
        container.style.fontOpticalSizing = 'auto';
        container.style.textRendering = 'optimizeLegibility';

        // Add thermal print simulation mode (for testing)
        if (window.location.search.includes('thermal-preview')) {
            container.style.filter = 'contrast(1.2) brightness(0.95)';
            container.style.background = '#fefefe';
        }
    }

    // Initialize thermal optimizations
    window.addEventListener('DOMContentLoaded', optimizeThermalRendering);

    // Auto-scroll to invoice on mobile for better UX
    if (window.innerWidth < 768) {
        window.addEventListener('load', function() {
            setTimeout(() => {
                document.getElementById('thermal-invoice-container').scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });
            }, 500);
        });
    }
</script>

</body>
</html>