<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice #${invoiceNo} – ${profile.custName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* ========================================================
           GLOBAL STYLES - ULTRA COMPACT A5 LANDSCAPE
        ======================================================== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Inter", -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f8fafc;
            color: #000000;
            padding: 10px;
            line-height: 1.2;
        }

        :root {
            --blue-primary: #2563eb;
            --blue-dark: #1e40af;
            --blue-light: #dbeafe;
            --text-dark: #1e293b;
            --text-gray: #64748b;
            --border-color: #cbd5e1;
            --green: #10b981;
            --bg-white: #ffffff;
        }

        /* ========================================================
           PAGE CONTAINER - A5 LANDSCAPE (210mm x 148mm)
        ======================================================== */
        .page-container {
            width: 210mm;
            height: 148mm;
            max-width: 100%;
            margin: 0 auto;
            background: var(--bg-white);
            padding: 4mm;
            border-radius: 2px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
        }

        .invoice-wrapper {
            border: 1.5px solid var(--blue-primary);
            padding: 2.5mm;
            height: 100%;
            border-radius: 2px;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        /* ========================================================
           ULTRA COMPACT HEADER - SINGLE ROW TABLE
        ======================================================== */
        .invoice-header {
            margin-bottom: 2mm;
        }

        .header-table {
            width: 100%;
            border-collapse: collapse;
        }

        .header-table td {
            border: 1px solid var(--blue-primary);
            padding: 2mm;
            vertical-align: top;
            font-size: 7px;
            line-height: 1.3;
        }

        /* Company Info - 50% */
        .header-table td.company-cell {
            width: 50%;
            background: linear-gradient(to right, #f8fafc, #ffffff);
        }

        .company-name {
            font-size: 11px;
            font-weight: 700;
            color: var(--blue-primary);
            margin-bottom: 1mm;
            letter-spacing: -0.3px;
        }

        .company-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5mm;
            font-size: 6.5px;
            color: var(--text-gray);
        }

        .company-info-item {
            display: flex;
            align-items: flex-start;
            gap: 1mm;
        }

        .company-info-item i {
            font-size: 6px;
            color: var(--blue-primary);
            margin-top: 0.5px;
            flex-shrink: 0;
        }

        .info-content {
            line-height: 1.3;
        }

        .info-label {
            font-weight: 600;
            color: var(--text-dark);
        }

        /* QR Code - 20% */
        .header-table td.qr-cell {
            width: 20%;
            text-align: center;
            padding: 1.5mm;
            background: linear-gradient(135deg, var(--blue-light), #ffffff);
        }

        .qr-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1mm;
        }

        .qr-label {
            font-size: 6.5px;
            font-weight: 600;
            color: var(--blue-primary);
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .qr-box {
            width: 55px;
            height: 55px;
            border: 1px solid var(--border-color);
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 2px;
        }

        .qr-box img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            image-rendering: crisp-edges;
            image-rendering: -webkit-optimize-contrast;
        }

        .qr-box i {
            font-size: 14px;
            color: var(--blue-primary);
        }

        /* Invoice Details - 30% */
        .header-table td.invoice-cell {
            width: 30%;
            background: linear-gradient(135deg, var(--blue-primary), var(--blue-dark));
            color: white;
            text-align: right;
        }

        .invoice-title {
            font-size: 8px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 1mm;
            opacity: 0.9;
        }

        .invoice-number {
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 2mm;
            letter-spacing: -0.5px;
        }

        .invoice-date {
            font-size: 7px;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 1mm;
            opacity: 0.95;
        }

        .invoice-date i {
            font-size: 7px;
        }

        .invoice-badge {
            display: inline-block;
            padding: 0.5mm 1.5mm;
            background: rgba(255, 255, 255, 0.25);
            border-radius: 8px;
            font-size: 6px;
            font-weight: 600;
            margin-top: 1mm;
            letter-spacing: 0.3px;
        }

        /* ========================================================
           COMPACT CUSTOMER SECTION
        ======================================================== */
        .customer-section {
            margin: 1.5mm 0;
            padding: 1.5mm 2mm;
            border: 1px solid var(--border-color);
            border-radius: 2px;
            background: #f8fafc;
            display: flex;
            align-items: center;
            gap: 3mm;
            font-size: 7px;
        }

        .customer-label {
            font-weight: 600;
            color: var(--blue-primary);
            display: flex;
            align-items: center;
            gap: 1mm;
            flex-shrink: 0;
        }

        .customer-label i {
            font-size: 7px;
        }

        .customer-details {
            display: flex;
            gap: 4mm;
            flex-wrap: wrap;
            flex: 1;
        }

        .customer-item {
            display: flex;
            gap: 1mm;
            color: var(--text-dark);
        }

        .customer-item strong {
            color: var(--text-gray);
            font-weight: 500;
        }

        /* ========================================================
           ULTRA COMPACT ITEMS TABLE - 10+ ITEMS FIT
        ======================================================== */
        .items-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-height: 0;
            margin: 1mm 0;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 7px;
        }

        .items-table thead th {
            background: linear-gradient(135deg, var(--blue-primary), var(--blue-dark));
            color: white;
            padding: 1.5mm 1mm;
            font-weight: 600;
            border: 1px solid var(--blue-primary);
            text-align: center;
            font-size: 7px;
            line-height: 1.2;
            letter-spacing: 0.2px;
        }

        .items-table thead th.text-left {
            text-align: left;
            padding-left: 1.5mm;
        }

        .items-table thead th.text-right {
            text-align: right;
            padding-right: 1.5mm;
        }

        .items-table tbody td {
            padding: 1mm 1mm;
            border: 0.5px solid var(--border-color);
            text-align: center;
            line-height: 1.2;
            font-size: 6.5px;
        }

        .items-table tbody td.description {
            text-align: left;
            padding-left: 1.5mm;
            font-weight: 500;
            color: var(--text-dark);
        }

        .items-table tbody td.text-right {
            text-align: right;
            padding-right: 1.5mm;
        }

        .items-table tbody td.amount {
            font-weight: 600;
            color: var(--blue-primary);
        }

        .items-table tbody tr:nth-child(even) {
            background: #fafbff;
        }

        /* ========================================================
           ULTRA COMPACT BOTTOM SECTION - 3 COLUMNS
        ======================================================== */
        .bottom-section {
            display: grid;
            grid-template-columns: 1fr 1.3fr 0.9fr;
            gap: 2mm;
            margin-top: 2mm;
        }

        /* Terms Section */
        .terms-section {
            padding: 1.5mm;
            border: 1px solid var(--border-color);
            border-radius: 2px;
            background: #fafbff;
            display: flex;
            flex-direction: column;
            gap: 1mm;
        }

        .terms-title {
            font-size: 7px;
            font-weight: 600;
            color: var(--blue-primary);
            display: flex;
            align-items: center;
            gap: 1mm;
        }

        .terms-title i {
            font-size: 6.5px;
        }

        .terms-text {
            font-size: 6px;
            line-height: 1.3;
            color: var(--text-gray);
            flex: 1;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .signature-row {
            display: flex;
            justify-content: space-between;
            gap: 2mm;
            margin-top: auto;
            padding-top: 1mm;
        }

        .signature-box {
            flex: 1;
            text-align: center;
            padding-top: 1mm;
            border-top: 0.5px dashed var(--text-gray);
            font-size: 5.5px;
            color: var(--text-gray);
        }

        /* Bank Details Section */
        .bank-section {
            padding: 1.5mm;
            border: 1px solid var(--border-color);
            border-radius: 2px;
            background: linear-gradient(to bottom, #ffffff, #f8fafc);
            display: flex;
            flex-direction: column;
            gap: 1mm;
        }

        .bank-title {
            font-size: 7px;
            font-weight: 600;
            color: var(--blue-primary);
            display: flex;
            align-items: center;
            gap: 1mm;
            margin-bottom: 0.5mm;
        }

        .bank-title i {
            font-size: 6.5px;
        }

        .bank-details {
            display: flex;
            flex-direction: column;
            gap: 0.8mm;
            font-size: 6px;
            color: var(--text-dark);
        }

        .bank-item {
            display: flex;
            gap: 1mm;
        }

        .bank-item strong {
            color: var(--text-gray);
            font-weight: 500;
            min-width: 18mm;
        }

        /* Summary Section */
        .summary-section {
            padding: 1.5mm;
            border: 1.5px solid var(--blue-primary);
            border-radius: 2px;
            background: linear-gradient(to bottom, #ffffff, var(--blue-light));
            display: flex;
            flex-direction: column;
            gap: 0.8mm;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 7px;
            padding: 0.8mm 0;
            border-bottom: 0.5px solid #e2e8f0;
        }

        .summary-row:last-child {
            border-bottom: none;
            border-top: 1.5px solid var(--blue-primary);
            font-weight: 700;
            font-size: 8px;
            padding: 1.2mm 0;
            margin-top: 0.5mm;
            background: var(--blue-light);
            padding-left: 1mm;
            padding-right: 1mm;
            border-radius: 2px;
        }

        .summary-row span:first-child {
            display: flex;
            align-items: center;
            gap: 1.5mm;
            color: var(--text-gray);
        }

        .summary-row i {
            font-size: 6.5px;
            color: var(--blue-primary);
        }

        .summary-row .amount {
            font-weight: 600;
            color: var(--blue-primary);
        }

        /* ========================================================
           COMPACT FOOTER
        ======================================================== */
        .invoice-footer {
            margin-top: 1.5mm;
            padding-top: 1mm;
            border-top: 0.5px solid var(--border-color);
            text-align: center;
            font-size: 6px;
            color: var(--text-gray);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 2mm;
            flex-wrap: wrap;
        }

        .invoice-footer i {
            color: var(--blue-primary);
            font-size: 5.5px;
        }

        .invoice-footer strong {
            color: var(--blue-primary);
        }

        /* ========================================================
           ACTION BUTTONS
        ======================================================== */
        .action-buttons {
            text-align: center;
            margin: 12px auto;
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
            max-width: 210mm;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-family: "Inter", sans-serif;
            box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .btn-outline {
            background: white;
            color: var(--blue-primary);
            border: 2px solid var(--blue-primary);
        }

        .btn-outline:hover {
            background: var(--blue-primary);
            color: white;
        }

        .btn-primary {
            background: var(--blue-primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--blue-dark);
        }

        .btn-success {
            background: var(--green);
            color: white;
        }

        .btn-success:hover {
            background: #059669;
        }

        .btn i.fa-spinner {
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* ========================================================
           PRINT STYLES - A5 LANDSCAPE
        ======================================================== */
        @media print {
            @page {
                size: A5 landscape;
                margin: 0;
            }

            body {
                background: white !important;
                padding: 0;
                margin: 0;
            }

            .page-container {
                box-shadow: none !important;
                border: none !important;
                width: 210mm;
                height: 148mm;
                margin: 0;
                padding: 4mm;
                page-break-after: avoid;
            }

            .action-buttons {
                display: none !important;
            }

            * {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            .header-table td {
                border: 1.5px solid #000 !important;
            }

            .header-table td.invoice-cell {
                background: #000 !important;
                color: #fff !important;
            }

            .header-table td.qr-cell {
                background: #f0f0f0 !important;
            }

            .items-table thead th {
                background: #000 !important;
                color: #fff !important;
                border: 1px solid #000 !important;
            }

            .items-table tbody td {
                border: 0.5px solid #000 !important;
            }

            .qr-box img {
                image-rendering: crisp-edges;
                image-rendering: -webkit-optimize-contrast;
            }
        }

        /* ========================================================
           RESPONSIVE STYLES
        ======================================================== */
        @media screen and (max-width: 900px) {
            body {
                padding: 8px;
            }

            .page-container {
                transform: scale(0.7);
                transform-origin: top center;
            }
        }

        @media screen and (max-width: 768px) {
            .page-container {
                transform: scale(0.55);
            }

            .action-buttons {
                flex-direction: column;
                padding: 0 15px;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .bottom-section {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="page-container" id="invoice-container">
    <div class="invoice-wrapper">

        <!-- ========== ULTRA COMPACT HEADER ========== -->
        <div class="invoice-header">
            <table class="header-table">
                <tbody>
                    <tr>
                        <!-- Company Info -->
                        <td class="company-cell">
                            <div class="company-name">
                                <c:out value="${ownerInfo.shopName}"/>
                            </div>
                            <div class="company-info">
                                <div class="company-info-item">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <div class="info-content">
                                        <c:out value="${ownerInfo.address}"/>
                                    </div>
                                </div>
                                <div class="company-info-item">
                                    <i class="fas fa-user"></i>
                                    <div class="info-content">
                                        <span class="info-label">Owner:</span> ${ownerInfo.ownerName}
                                    </div>
                                </div>
                                <div class="company-info-item">
                                    <i class="fas fa-id-card"></i>
                                    <div class="info-content">
                                        <span class="info-label">LC:</span> <c:out value="${ownerInfo.lcNo}"/>
                                    </div>
                                </div>
                                <div class="company-info-item">
                                    <i class="fas fa-phone"></i>
                                    <div class="info-content">
                                        <span class="info-label">Mob:</span> ${ownerInfo.mobNumber}
                                    </div>
                                </div>
                                <div class="company-info-item">
                                    <i class="fas fa-receipt"></i>
                                    <div class="info-content">
                                        <span class="info-label">GST:</span> <c:out value="${ownerInfo.gstNumber}"/>
                                    </div>
                                </div>
                            </div>
                        </td>

                        <!-- QR Code -->
                        <td class="qr-cell">
                            <div class="qr-wrapper">
                                <div class="qr-label">Scan to Pay</div>
                                <div class="qr-box">
                                    <c:choose>
                                        <c:when test="${not empty QRCODE}">
                                            <img src="data:image/png;base64,${QRCODE}" alt="Payment QR" />
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-qrcode"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </td>

                        <!-- Invoice Details -->
                        <td class="invoice-cell">
                            <div class="invoice-title">Tax Invoice</div>
                            <div class="invoice-number">#${invoiceNo}</div>
                            <div class="invoice-date">
                                <i class="fas fa-calendar-alt"></i>
                                <span>${date}</span>
                            </div>
                            <div class="invoice-badge">
                                <i class="fas fa-circle" style="font-size: 4px;"></i> ORIGINAL
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- ========== COMPACT CUSTOMER SECTION ========== -->
        <div class="customer-section">
            <div class="customer-label">
                <i class="fas fa-user-circle"></i>
                <span>BILL TO:</span>
            </div>
            <div class="customer-details">
                <div class="customer-item">
                    <strong>Name:</strong>
                    <span><c:out value="${profile.custName}"/></span>
                </div>
                <div class="customer-item">
                    <strong>Contact:</strong>
                    <span><c:out value="${profile.phoneNo}"/></span>
                </div>
                <div class="customer-item">
                    <strong>Address:</strong>
                    <span><c:out value="${profile.address}"/></span>
                </div>
            </div>
        </div>

        <!-- ========== ULTRA COMPACT ITEMS TABLE ========== -->
        <div class="items-section">
            <table class="items-table">
                <thead>
                    <tr>
                        <th style="width:3%">SR</th>
                        <th style="width:28%" class="text-left">DESCRIPTION</th>
                        <c:if test="${invoiceColms.contains('BRAND')}">
                            <th style="width:9%">BRAND</th>
                        </c:if>
                        <c:if test="${invoiceColms.contains('BATCHNO')}">
                            <th style="width:8%">BATCH</th>
                        </c:if>
                        <c:if test="${invoiceColms.contains('EXPD')}">
                            <th style="width:6%">EXP</th>
                        </c:if>
                        <c:if test="${invoiceColms.contains('MRP')}">
                            <th style="width:8%" class="text-right">MRP</th>
                        </c:if>
                        <th style="width:5%">QTY</th>
                        <th style="width:9%" class="text-right">RATE</th>
                        <th style="width:11%" class="text-right">AMOUNT</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${items}" var="item" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td class="description"><c:out value="${item.description}"/></td>
                            <c:if test="${invoiceColms.contains('BRAND')}">
                                <td><c:out value="${empty item.brand ? 'N/A' : item.brand}"/></td>
                            </c:if>
                            <c:if test="${invoiceColms.contains('BATCHNO')}">
                                <td><c:out value="${item.batchNo}"/></td>
                            </c:if>
                            <c:if test="${invoiceColms.contains('EXPD')}">
                                <td><c:out value="${empty item.expDate ? 'N/A' : item.expDate}"/></td>
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
        </div>

        <!-- ========== BOTTOM SECTION - 3 COLUMNS ========== -->
        <div class="bottom-section">

            <!-- Terms & Signatures -->
            <div class="terms-section">
                <div class="terms-title">
                    <i class="fas fa-file-contract"></i>
                    <span>Terms & Conditions</span>
                </div>
                <div class="terms-text">
                    <c:out value="${ownerInfo.terms}"/>
                </div>
                <div class="signature-row">
                    <div class="signature-box">
                        Customer Sign
                    </div>
                    <div class="signature-box">
                        Authorized Sign
                    </div>
                </div>
            </div>

            <!-- Bank Details -->
            <div class="bank-section">
                <div class="bank-title">
                    <i class="fas fa-university"></i>
                    <span>Payment Details</span>
                </div>
                <div class="bank-details">
                    <div class="bank-item">
                        <strong>Bank:</strong>
                        <span>State Bank of India</span>
                    </div>
                    <div class="bank-item">
                        <strong>A/c Number:</strong>
                        <span>1234567890</span>
                    </div>
                    <div class="bank-item">
                        <strong>IFSC Code:</strong>
                        <span>SBIN0001234</span>
                    </div>
                    <div class="bank-item">
                        <strong>Branch:</strong>
                        <span>Main Branch</span>
                    </div>
                    <div class="bank-item">
                        <strong>UPI ID:</strong>
                        <span>${ownerInfo.mobNumber}@paytm</span>
                    </div>
                </div>
            </div>

            <!-- Invoice Summary -->
            <div class="summary-section">
                <div class="summary-row">
                    <span><i class="fas fa-calculator"></i>Sub Total</span>
                    <span class="amount">₹${totalAmout}</span>
                </div>
                <div class="summary-row">
                    <span><i class="fas fa-percentage"></i>GST</span>
                    <span class="amount">₹${currentinvoiceitems.tax}</span>
                </div>
                <div class="summary-row">
                    <span><i class="fas fa-credit-card"></i>Paid</span>
                    <span class="amount">₹${advamount}</span>
                </div>
                <div class="summary-row">
                    <span><i class="fas fa-history"></i>Prev Balance</span>
                    <span class="amount">₹${currentinvoiceitems.preBalanceAmt}</span>
                </div>
                <div class="summary-row">
                    <span><i class="fas fa-wallet"></i>Balance Due</span>
                    <span class="amount">₹${currentinvoiceitems.balanceAmt}</span>
                </div>
            </div>
        </div>

        <!-- ========== FOOTER ========== -->
        <div class="invoice-footer">
            <i class="fas fa-code"></i>
            <span>Generated by <strong>BillMatePro</strong></span>
            <span>•</span>
            <i class="fas fa-phone"></i>
            <span>8180080378</span>
            <span>•</span>
            <i class="fas fa-envelope"></i>
            <span>support@billmatepro.com</span>
        </div>
    </div>
</div>

<!-- ========== ACTION BUTTONS ========== -->
<div class="action-buttons">
    <button class="btn btn-outline" onclick="window.location.href='${pageContext.request.contextPath}/login/home'">
        <i class="fas fa-home"></i> Home
    </button>
    <button class="btn btn-primary" onclick="printInvoice()">
        <i class="fas fa-print"></i> Print A5
    </button>
    <button class="btn btn-primary" id="pdfDownloadBtn" onclick="downloadPDF(this)">
        <i class="fas fa-download"></i> Download PDF
    </button>
    <a href="https://wa.me/${profile.phoneNo}/?text=Namaste!!!%20*${profile.custName}*,%20आपका%20बिल%20तैयार%20है।%20Invoice%20%23${invoiceNo}%20-%20₹${profile.currentOusting}%0A%0AThank%20you%20for%20your%20business!%0A%0A-%20${ownerInfo.shopName}"
       target="_blank"
       class="btn btn-success">
        <i class="fab fa-whatsapp"></i> Share on WhatsApp
    </a>
</div>

</c:if>

<!-- ========== SCRIPTS ========== -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
    // ========== AUTO-DOWNLOAD ON PAGE LOAD ==========
    window.addEventListener('DOMContentLoaded', function() {
        // Get download flag from JSP
        const downloadFlag = '${downloadflag}' === 'true';

        if (downloadFlag) {
            // Wait for images and content to load
            setTimeout(function() {
                const pdfBtn = document.getElementById('pdfDownloadBtn');
                if (pdfBtn && !pdfBtn.disabled) {
                    console.log('Auto-downloading PDF...');
                    downloadPDF(pdfBtn);
                }
            }, 1000);
        }
    });

    // ========== PRINT FUNCTION - A5 LANDSCAPE ==========
    function printInvoice() {
        window.print();
    }

    // ========== PDF DOWNLOAD - FULL PAGE FIX ==========
    let pdfGenerating = false;

    function downloadPDF(btn) {
        if (pdfGenerating) {
            alert('PDF generation already in progress. Please wait...');
            return;
        }

        const element = document.getElementById('invoice-container');
        const customerName = '${profile.custName}'.replace(/[^a-zA-Z0-9]/g, '_') || 'Customer';
        const invoiceNo = '${invoiceNo}' || 'INV001';
        const currentDate = new Date().toISOString().slice(0, 10);

        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating PDF...';
        btn.disabled = true;
        pdfGenerating = true;

        const opt = {
            margin: [0, 0, 0, 0],
            filename: `Invoice_${invoiceNo}_${customerName}_${currentDate}.pdf`,
            image: {
                type: 'png',
                quality: 0.98
            },
            html2canvas: {
                scale: 3,
                useCORS: true,
                letterRendering: true,
                allowTaint: false,
                backgroundColor: '#ffffff',
                scrollY: 0,
                scrollX: 0,
                width: 794,
                height: 559
            },
            jsPDF: {
                unit: 'mm',
                format: [148, 210],
                orientation: 'landscape',
                compress: true
            }
        };

        html2pdf()
            .set(opt)
            .from(element)
            .save()
            .then(() => {
                btn.innerHTML = '<i class="fas fa-check"></i> PDF Downloaded!';
                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    pdfGenerating = false;
                }, 2000);
            })
            .catch((error) => {
                console.error('PDF generation failed:', error);
                alert('PDF generation failed. Please try the print option or contact support.');
                btn.innerHTML = originalText;
                btn.disabled = false;
                pdfGenerating = false;
            });
    }

    // ========== KEYBOARD SHORTCUTS ==========
    document.addEventListener('keydown', function(event) {
        if (event.ctrlKey || event.metaKey) {
            switch(event.key.toLowerCase()) {
                case 'p':
                    event.preventDefault();
                    printInvoice();
                    break;
                case 's':
                    event.preventDefault();
                    const pdfBtn = document.getElementById('pdfDownloadBtn');
                    if (!pdfBtn.disabled) {
                        downloadPDF(pdfBtn);
                    }
                    break;
                case 'h':
                    event.preventDefault();
                    window.location.href = '${pageContext.request.contextPath}/login/home';
                    break;
            }
        }
    });

    // ========== PRINT EVENT HANDLERS ==========
    window.addEventListener('beforeprint', function() {
        document.body.style.background = 'white';
    });

    window.addEventListener('afterprint', function() {
        document.body.style.background = 'linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 50%, #f8fafc 100%)';
    });

    // ========== CONSOLE MESSAGE ==========
    console.log('%c Invoice Template - A5 Landscape Optimized! ', 'background: #1e40af; color: white; padding: 10px; font-size: 14px; font-weight: bold;');
    console.log('%c ✓ Increased font sizes for better print readability', 'color: green; font-weight: bold;');
    console.log('%c ✓ Auto-download enabled when downloadflag=true', 'color: green; font-weight: bold;');
    console.log('%c ✓ Minimum 8 products fit on single page', 'color: green; font-weight: bold;');
    console.log('%c Keyboard Shortcuts: Ctrl+P (Print) | Ctrl+S (PDF) | Ctrl+H (Home)', 'font-style: italic;');
</script>

</body>
</html>