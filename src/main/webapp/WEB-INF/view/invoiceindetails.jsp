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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* ========================================================
           GLOBAL STYLES - A5 LANDSCAPE OPTIMIZED
        ======================================================== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Poppins", Arial, sans-serif;
            background: linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 50%, #f8fafc 100%);
            color: #000000;
            padding: 15px;
        }

        /* Color Variables */
        :root {
            --blue-primary: #1e40af;
            --blue-light: #e0e7ff;
            --blue-lighter: #f0f4ff;
            --text-dark: #0f172a;
            --text-gray: #475569;
            --border-light: #c7d2fe;
            --success-green: #25D366;
            --bg-white: #ffffff;
        }

        /* ========================================================
           UTILITY CLASSES
        ======================================================== */
        .text-left { text-align: left; }
        .text-right { text-align: right; }
        .text-center { text-align: center; }

        /* ========================================================
           PAGE CONTAINER - A5 LANDSCAPE (210mm x 148mm)
        ======================================================== */
        .page-container {
            width: 210mm;
            height: 148mm;
            max-width: 100%;
            margin: 0 auto;
            background: var(--bg-white);
            padding: 6mm;
            border-radius: 6px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            border: 1px solid var(--border-light);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        /* ========================================================
           HEADER SECTION - CENTERED & COMPACT
        ======================================================== */
        .header-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding-bottom: 3mm;
            border-bottom: 1.5px solid var(--blue-primary);
            margin-bottom: 2mm;
            gap: 2mm;
        }

        .company-info {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 2mm;
        }

        .company-logo {
            max-width: 30px;
            max-height: 30px;
        }

        .company-text {
            text-align: center;
        }

        .company-text h1 {
            margin: 0;
            font-size: 16px;
            font-weight: 500;
            color: var(--blue-primary);
            line-height: 1.1;
        }

        .company-details {
            display: flex;
            flex-direction: column;
            gap: 1mm;
            font-size: 8px;
            color: var(--text-gray);
            line-height: 1.2;
        }

        .company-details p {
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 2px;
        }

        .company-details i {
            font-size: 8px;
            color: var(--blue-primary);
        }

        .header-meta-row {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8mm;
            width: 100%;
        }

        .header-qr {
            width: 35px;
            height: 35px;
            border: 1px solid var(--border-light);
            border-radius: 3px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background: var(--blue-lighter);
            flex-shrink: 0;
        }

        .header-qr img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .header-qr i {
            font-size: 18px;
            color: var(--blue-primary);
        }

        .meta-info {
            text-align: center;
            font-size: 8px;
        }

        .meta-info h2 {
            font-size: 12px;
            font-weight: 500;
            color: var(--blue-primary);
            margin: 0;
        }

        .meta-item {
            font-size: 8px;
            color: var(--text-gray);
            margin: 1px 0;
            line-height: 1.2;
        }

        /* ========================================================
           CUSTOMER SECTION - COMPACT
        ======================================================== */
        .customer-section {
            margin: 1mm 0;
            padding: 2mm;
            border: 0.5px solid var(--border-light);
            border-radius: 2px;
            background: #fafbff;
            font-size: 8px;
        }

        .customer-title {
            font-size: 9px;
            font-weight: 500;
            color: var(--blue-primary);
            margin-bottom: 1mm;
            display: flex;
            align-items: center;
            gap: 2px;
        }

        .customer-details {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1mm;
        }

        .customer-item {
            font-size: 8px;
            color: var(--text-dark);
            line-height: 1.2;
        }

        .customer-item span {
            color: var(--blue-primary);
            font-weight: 500;
        }

        /* ========================================================
           ITEMS TABLE - COMPACT
        ======================================================== */
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin: 1mm 0;
            font-size: 8px;
            flex-grow: 1;
        }

        .items-table thead th {
            background: var(--blue-primary);
            color: #fff;
            padding: 1.5mm 0.8mm;
            font-weight: 500;
            border: 0.5px solid var(--blue-primary);
            text-align: center;
            line-height: 1.2;
            font-size: 8px;
        }

        .items-table thead th.text-left {
            text-align: left;
        }

        .items-table thead th.text-right {
            text-align: right;
            padding-right: 2mm;
        }

        .items-table tbody td {
            padding: 1mm 0.8mm;
            border: 0.5px solid var(--border-light);
            text-align: center;
            line-height: 1.2;
            font-size: 8px;
        }

        .items-table tbody td.description {
            text-align: left;
            padding-left: 2mm;
        }

        .items-table tbody td.text-right {
            text-align: right;
            padding-right: 2mm;
        }

        .items-table tbody td.amount {
            font-weight: 500;
            color: var(--blue-primary);
        }

        .items-table tbody tr:nth-child(even) {
            background: #f8f9ff;
        }

        /* ========================================================
           BOTTOM SECTION - SINGLE ROW LAYOUT
        ======================================================== */
        .bottom-section {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 2mm;
            margin-top: 1mm;
        }

        /* QR Section */
        .qr-section {
            padding: 2mm;
            border: 0.5px solid var(--border-light);
            border-radius: 2px;
            background: var(--blue-lighter);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 2mm;
        }

        .qr-label {
            font-size: 8px;
            font-weight: 500;
            color: var(--blue-primary);
        }

        .qr-display {
            width: 78px;
            height: 78px;
            border: 0.5px solid var(--border-light);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background: white;
        }

        .qr-display img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .qr-display i {
            font-size: 14px;
            color: var(--blue-primary);
        }

        /* Terms Section */
        .terms-section {
            padding: 2mm;
            border: 0.5px solid var(--border-light);
            border-radius: 2px;
            background: #fafbff;
            display: flex;
            flex-direction: column;
        }

        .terms-title {
            font-size: 9px;
            font-weight: 500;
            color: var(--blue-primary);
            margin-bottom: 1mm;
            display: flex;
            align-items: center;
            gap: 2px;
        }

        .terms-text {
            font-size: 7px;
            line-height: 1.2;
            color: var(--text-gray);
            flex-grow: 1;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }

        .signature-row {
            display: flex;
            justify-content: space-between;
            gap: 2mm;
            margin-top: 2mm;
        }

        .signature-box {
            flex: 1;
            text-align: center;
            padding-top: 2mm;
            border-top: 0.5px dashed var(--blue-primary);
            font-size: 6px;
            color: var(--text-gray);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1px;
        }

        .signature-box i {
            font-size: 8px;
            color: var(--blue-primary);
        }

        /* Invoice Summary */
        .invoice-summary {
            padding: 2mm;
            border: 0.5px solid var(--border-light);
            border-radius: 2px;
            background: var(--bg-white);
            display: flex;
            flex-direction: column;
            gap: 1px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 8px;
            padding: 1mm 0;
            border-bottom: 0.5px solid #f1f5f9;
            line-height: 1.2;
        }

        .summary-row:last-child {
            border-bottom: 1px solid var(--blue-primary);
            border-top: 1px solid var(--blue-primary);
            font-weight: 500;
            font-size: 9px;
            padding: 1.5mm 0;
            margin-top: 1mm;
        }

        .summary-row span:first-child {
            display: flex;
            align-items: center;
            gap: 2px;
            color: var(--text-gray);
        }

        .summary-row i {
            font-size: 8px;
            color: var(--blue-primary);
        }

        .summary-row .amount {
            font-weight: 500;
            color: var(--blue-primary);
        }

        /* ========================================================
           FOOTER - COMPACT
        ======================================================== */
        .invoice-footer {
            margin-top: 1mm;
            padding-top: 1mm;
            border-top: 0.5px solid var(--border-light);
            text-align: center;
            font-size: 7px;
            color: var(--text-gray);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 3px;
            flex-wrap: wrap;
        }

        .invoice-footer i {
            color: var(--blue-primary);
        }

        /* ========================================================
           ACTION BUTTONS
        ======================================================== */
        .action-buttons {
            text-align: center;
            margin: 15px auto;
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
            max-width: 210mm;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-family: "Poppins", Arial, sans-serif;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
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
            background: #1e3a8a;
        }

        .btn-success {
            background: var(--success-green);
            color: white;
        }

        .btn-success:hover {
            background: #20BA5A;
        }

        .btn i.fa-spinner {
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* ========================================================
           PRINT STYLES - A5 LANDSCAPE WITH LARGER FONTS
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
                border-radius: 0 !important;
                width: 210mm;
                height: 148mm;
                margin: 0;
                padding: 6mm;
                page-break-after: avoid;
            }

            .action-buttons {
                display: none !important;
            }

            * {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            .items-table thead th {
                background: var(--blue-primary) !important;
                color: #fff !important;
            }

            .items-table tbody tr:nth-child(even) {
                background: #f8f9ff !important;
            }

            /* Increased font sizes for print */
            .company-text h1 {
                font-size: 18px !important;
            }

            .company-details {
                font-size: 9px !important;
            }

            .meta-info {
                font-size: 9px !important;
            }

            .meta-info h2 {
                font-size: 13px !important;
            }

            .meta-item {
                font-size: 9px !important;
            }

            .customer-section {
                font-size: 9px !important;
            }

            .customer-title {
                font-size: 10px !important;
            }

            .customer-item {
                font-size: 9px !important;
            }

            .items-table {
                font-size: 9px !important;
            }

            .items-table thead th {
                font-size: 9px !important;
            }

            .items-table tbody td {
                font-size: 9px !important;
            }

            .terms-title {
                font-size: 10px !important;
            }

            .terms-text {
                font-size: 8px !important;
            }

            .signature-box {
                font-size: 7px !important;
            }

            .summary-row {
                font-size: 9px !important;
            }

            .summary-row:last-child {
                font-size: 10px !important;
            }

            .invoice-footer {
                font-size: 8px !important;
            }
        }

        /* ========================================================
           RESPONSIVE STYLES
        ======================================================== */
        @media screen and (max-width: 900px) {
            body {
                padding: 10px;
            }

            .page-container {
                transform: scale(0.75);
                transform-origin: top center;
            }
        }

        @media screen and (max-width: 768px) {
            .page-container {
                transform: scale(0.6);
            }

            .action-buttons {
                flex-direction: column;
                padding: 0 20px;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .bottom-section {
                grid-template-columns: 1fr;
            }
        }

        @media screen and (max-width: 480px) {
            .page-container {
                transform: scale(0.45);
            }
        }

    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="page-container" id="invoice-container">
    <div class="invoice">

        <!-- ========== HEADER SECTION - CENTERED ========== -->
        <div class="header-section">
            <div class="company-info">
                <img class="company-logo"
                     src="${pageContext.request.contextPath}/resources/images/logo.png"
                     alt="Logo"
                     onerror="this.style.display='none'">
                <div class="company-text">
                    <h1><c:out value="${ownerInfo.shopName}"/></h1>
                    <div class="company-details">
                        <p><c:out value="${ownerInfo.address}"/></p>
                    </div>
                </div>
            </div>
            <div class="header-meta-row">

                <div class="meta-info">
                    <h2>TAX INVOICE</h2>
                    <div class="meta-item">Invoice #: ${invoiceNo}</div>
                    <div class="meta-item">Date: ${date}</div>
                      <div class="meta-item">Owner: ${ownerInfo.ownerName} Mob.:${ownerInfo.mobNumber}</div>
                                            <div class="meta-item">LC No: ${ownerInfo.lcNo} GST:${ownerInfo.gstNumber}</div>

                </div>
            </div>
        </div>

        <!-- ========== OWNER INFO - TWO ROW LAYOUT ========== -->
        <div class="customer-section">

            <div class="customer-title">
                <i class="fas fa-user-circle"></i>Customer Details
            </div>
            <div class="customer-details">
                <div class="customer-item">
                    <span>Name:</span> <c:out value="${profile.custName}"/>
                </div>
                <div class="customer-item">
                    <span>Contact:</span> <c:out value="${profile.phoneNo}"/>
                </div>
                <div class="customer-item">
                    <span>Address:</span> <c:out value="${profile.address}"/>
                </div>
            </div>
        </div>

        <!-- ========== ITEMS TABLE ========== -->
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width:4%">SR</th>
                    <th style="width:26%" class="text-left">Description</th>
                    <c:if test="${invoiceColms.contains('BRAND')}">
                        <th style="width:8%">Brand</th>
                    </c:if>
                    <c:if test="${invoiceColms.contains('BATCHNO')}">
                        <th style="width:7%">Batch</th>
                    </c:if>
                    <c:if test="${invoiceColms.contains('EXPD')}">
                        <th style="width:6%">Exp.</th>
                    </c:if>
                    <c:if test="${invoiceColms.contains('MRP')}">
                        <th style="width:8%" class="text-right">MRP</th>
                    </c:if>
                    <th style="width:5%">Qty</th>
                    <th style="width:9%" class="text-right">Rate</th>
                    <th style="width:11%" class="text-right">Amount</th>
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

        <!-- ========== BOTTOM SECTION - THREE COLUMN LAYOUT ========== -->
        <div class="bottom-section">

            <!-- QR Code Section -->
            <div class="qr-section">
                <div class="qr-display">
                    <c:choose>
                        <c:when test="${not empty QRCODE}">
                            <img src="data:image/png;base64,${QRCODE}" alt="QR" />
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-qrcode"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Terms & Conditions -->
            <div class="terms-section">
                <div class="terms-title">
                    <i class="fas fa-file-contract"></i>Terms & Conditions
                </div>
                <div class="terms-text">
                    <c:out value="${ownerInfo.terms}"/>
                </div>
                <div class="signature-row">
                    <div class="signature-box">
                        <i class="fas fa-signature"></i>
                        <span>Customer Signature</span>
                    </div>
                    <div class="signature-box">
                        <i class="fas fa-store"></i>
                        <span>For <c:out value="${ownerInfo.shopName}"/></span>
                    </div>
                </div>
            </div>

            <!-- Invoice Summary -->
            <div class="invoice-summary">
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
                    <span><i class="fas fa-wallet"></i>Current Balance</span>
                    <span class="amount">₹${profile.currentOusting}</span>
                </div>
            </div>
        </div>

        <!-- ========== FOOTER ========== -->
        <div class="invoice-footer">
            <i class="fas fa-code"></i>
            <span>Generated by BillMatePro Solution</span>
            <span>•</span>
            <i class="fas fa-phone"></i>
            <span>8180080378</span>
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