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
            --text-dark: #000000;
            --text-medium: #333333;
            --border-color: #000000;
            --bg-white: #ffffff;
            --bg-light: #f5f5f5;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', monospace, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 15px;
            color: var(--text-dark);
            font-size: 14px;
            line-height: 1.4;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
            min-height: 100vh;
        }

        /* A5 Landscape Page Container - 210mm x 148mm */
        .page-container {
            width: 210mm;
            height: 148mm;
            margin: 0 auto 20px;
            background: white;
            border: 3px solid #000;
            overflow: hidden;
            position: relative;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        /* Invoice Content */
        .invoice {
            width: 100%;
            height: 100%;
            padding: 5mm;
            background: white;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        /* Header Section */
        .invoice-header {
            border-bottom: 3px dashed var(--border-color);
            padding-bottom: 3mm;
            margin-bottom: 3mm;
            position: relative;
            background: white;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 3mm;
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
            max-width: 35mm;
            object-fit: contain;
            flex-shrink: 0;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
        }

        .company-text h1 {
            font-size: 18px;
            font-weight: 900;
            margin-bottom: 1mm;
            color: var(--text-dark);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            line-height: 1.2;
        }

        .company-details {
            font-size: 8px;
            line-height: 1.4;
            color: var(--text-medium);
            font-weight: 600;
        }

        .company-details p {
            margin-bottom: 0.5mm;
            display: flex;
            align-items: center;
            gap: 2mm;
        }

        .company-details i {
            width: 10px;
            font-size: 7.5px;
            color: var(--text-dark);
        }

        .invoice-meta {
            text-align: right;
            border: 3px solid var(--border-color);
            padding: 3mm;
            background: var(--bg-light);
            min-width: 40mm;
            position: relative;
        }

        .invoice-meta h2 {
            font-size: 14px;
            margin-bottom: 2mm;
            font-weight: 900;
            color: var(--text-dark);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .header-qr {
            position: absolute;
            top: 2mm;
            left: -24mm;
            width: 22mm;
            height: 22mm;
            border: 3px solid var(--border-color);
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .header-qr img {
            max-width: 19mm;
            max-height: 19mm;
        }

        .header-qr i {
            font-size: 16px;
            color: var(--text-dark);
        }

        .invoice-meta .meta-item {
            margin-bottom: 1mm;
            font-size: 9px;
            font-weight: 700;
            color: var(--text-medium);
        }

        .invoice-meta .meta-item strong {
            color: var(--text-dark);
            font-weight: 900;
        }

        /* Customer Section */
        .customer-section {
            background: var(--bg-light);
            border: 2px solid var(--border-color);
            padding: 2.5mm;
            margin-bottom: 2.5mm;
        }

        .customer-title {
            font-weight: 900;
            font-size: 11px;
            margin-bottom: 2mm;
            color: var(--text-dark);
            text-transform: uppercase;
            display: flex;
            align-items: center;
            gap: 2mm;
            letter-spacing: 0.4px;
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 1.5mm;
        }

        .customer-title i {
            color: var(--text-dark);
            font-size: 12px;
        }

        .customer-details {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2mm;
        }

        .customer-item {
            font-size: 9px;
            font-weight: 700;
            color: var(--text-medium);
            line-height: 1.4;
        }

        .customer-item strong {
            color: var(--text-dark);
            font-weight: 800;
        }

        /* Items Table */
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2.5mm;
            border: 3px solid var(--border-color);
            flex: 1;
            overflow: hidden;
        }

        .items-table thead th {
            background: #000;
            color: white;
            padding: 2mm 1mm;
            font-weight: 900;
            text-align: center;
            font-size: 8.5px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            border-right: 1px solid white;
        }

        .items-table thead th:last-child {
            border-right: none;
        }

        .items-table thead th.text-left {
            text-align: left;
            padding-left: 2mm;
        }

        .items-table thead th.text-right {
            text-align: right;
            padding-right: 2mm;
        }

        .items-table tbody tr {
            border-bottom: 1px solid var(--border-color);
        }

        .items-table tbody tr:nth-child(even) {
            background: var(--bg-light);
        }

        .items-table tbody td {
            padding: 1.5mm 1mm;
            font-size: 8.5px;
            color: var(--text-dark);
            font-weight: 700;
            text-align: center;
            border-right: 1px solid var(--border-color);
        }

        .items-table tbody td:last-child {
            border-right: none;
        }

        .items-table .description {
            text-align: left !important;
            font-weight: 800;
            padding-left: 2mm;
        }

        .items-table .text-right {
            text-align: right !important;
            font-weight: 700;
            padding-right: 2mm;
        }

        .items-table .amount {
            font-weight: 900;
            color: var(--text-dark);
            font-size: 9px;
        }

        /* Bottom Section */
        .bottom-section {
            display: grid;
            grid-template-columns: 1.3fr 50mm;
            gap: 3mm;
            margin-top: auto;
        }

        /* Terms Section */
        .terms-section {
            border: 2px solid var(--border-color);
            padding: 2.5mm;
            background: white;
        }

        .terms-title {
            font-weight: 900;
            margin-bottom: 1.5mm;
            font-size: 9px;
            color: var(--text-dark);
            text-transform: uppercase;
            display: flex;
            align-items: center;
            gap: 2mm;
        }

        .terms-title i {
            color: var(--text-dark);
            font-size: 10px;
        }

        .terms-text {
            font-size: 7px;
            line-height: 1.3;
            color: var(--text-medium);
            margin-bottom: 2.5mm;
            height: 8mm;
            overflow: hidden;
            font-weight: 600;
        }

        .signature-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2mm;
        }

        .signature-box {
            border: 1.5px dashed var(--border-color);
            padding: 2mm;
            text-align: center;
            font-size: 7.5px;
            font-weight: 700;
            color: var(--text-medium);
            height: 8mm;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 3px;
            background: white;
        }

        .signature-box i {
            margin-right: 1.5mm;
            font-size: 8px;
        }

        /* Invoice Summary */
        .invoice-summary {
            background: white;
            border: 2.5px solid var(--primary-color);
            padding: 2.5mm;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2mm;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(34, 71, 165, 0.15);
        }

        .summary-left, .summary-right {
            display: flex;
            flex-direction: column;
        }

        .summary-left {
            border-right: 1.5px solid var(--border-color);
            padding-right: 2mm;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.2mm 0;
            font-size: 7.5px;
            border-bottom: 1px solid var(--border-color);
            font-weight: 700;
        }

        .summary-row:last-child {
            border-bottom: none;
        }

        .summary-row i {
            font-size: 7px;
            margin-right: 1.5mm;
        }

        .summary-row .amount {
            font-weight: 800;
            font-size: 8px;
        }

        /* Footer */
        .invoice-footer {
            text-align: center;
            padding: 1.5mm 0;
            margin-top: 2mm;
            border-top: 1.5px solid var(--border-color);
            font-size: 7px;
            color: var(--text-light);
            background: linear-gradient(135deg, #ffffff 0%, var(--bg-light) 100%);
            border-radius: 3px;
            font-weight: 600;
        }

        .invoice-footer strong {
            color: var(--primary-color);
            font-weight: 800;
        }

        .invoice-footer i {
            font-size: 6.5px;
            margin: 0 1mm;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            padding: 20px;
            background: white;
            margin: 0 auto 20px;
            max-width: 800px;
            border-radius: 10px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border-color);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
            cursor: pointer;
            border: 2px solid;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
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
            background: linear-gradient(135deg, #10B981 0%, #059669 100%);
            color: white;
            border-color: #10B981;
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
        }

        /* Print Styles - HD Black & White Compatible */
        @media print {
            @page {
                size: A5 landscape;
                margin: 0;
            }

            * {
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
                color-adjust: exact !important;
            }

            body {
                background: white !important;
                padding: 0 !important;
                margin: 0 !important;
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
                page-break-after: avoid !important;
                page-break-inside: avoid !important;
            }

            .invoice {
                padding: 4mm !important;
                height: 140mm !important;
            }

            .action-buttons {
                display: none !important;
            }

            /* HD Black & White Print Optimization */
            .invoice-header {
                border-bottom: 3px solid #000 !important;
            }

            .invoice-meta {
                border: 3px solid #000 !important;
                background: white !important;
                box-shadow: none !important;
            }

            .customer-section {
                border-left: 4px solid #000 !important;
                background: #f5f5f5 !important;
                border: 1.5px solid #000 !important;
            }

            .items-table {
                border: 3px solid #000 !important;
                box-shadow: none !important;
            }

            .items-table thead th {
                background: #000 !important;
                color: white !important;
                border-right: 1px solid white !important;
                font-weight: 900 !important;
            }

            .items-table tbody tr:nth-child(even) {
                background: #f0f0f0 !important;
            }

            .items-table tbody td {
                font-weight: 800 !important;
            }

            .items-table .amount {
                font-weight: 900 !important;
                color: #000 !important;
            }

            .invoice-summary {
                border: 3px solid #000 !important;
                background: white !important;
                box-shadow: none !important;
            }

            .summary-row .amount {
                font-weight: 900 !important;
            }

            .company-text h1,
            .invoice-meta h2,
            .customer-title,
            .terms-title,
            .invoice-footer strong {
                color: #000 !important;
                font-weight: 900 !important;
            }

            .header-qr {
                border: 3px solid #000 !important;
                box-shadow: none !important;
            }

            /* Remove all gradients and shadows for B&W */
            .invoice::before,
            .customer-section,
            .terms-section,
            .invoice-footer {
                background: white !important;
            }

            .items-table tbody tr:nth-child(even) {
                background: #f5f5f5 !important;
            }
        }

        /* Mobile Responsive */
        @media screen and (max-width: 900px) {
            body { padding: 10px; }
            .page-container {
                transform: scale(0.85);
                transform-origin: top center;
                margin-bottom: 30px;
            }
        }

        @media screen and (max-width: 768px) {
            .page-container {
                transform: scale(0.7);
                margin-bottom: 50px;
            }
            .action-buttons {
                flex-wrap: wrap;
                padding: 15px;
                gap: 10px;
            }
            .btn {
                flex: 1 1 calc(50% - 5px);
                min-width: 140px;
                font-size: 12px;
                padding: 8px 16px;
            }
        }

        @media screen and (max-width: 600px) {
            .page-container {
                transform: scale(0.55);
                margin-bottom: 80px;
            }
            .customer-details {
                grid-template-columns: 1fr !important;
            }
        }

        @media screen and (max-width: 480px) {
            .page-container {
                transform: scale(0.45);
                margin-bottom: 100px;
            }
            .action-buttons { flex-direction: column; }
            .btn { width: 100%; }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="page-container" id="invoice-container">
    <div class="invoice">
        <!-- Header -->
        <div class="invoice-header">
            <div class="header-top">
                <div class="company-info">
                    <img class="company-logo" src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Company Logo" onerror="this.style.display='none'">
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

        <!-- Customer Section -->
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

        <!-- Items Table -->
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width:5%">SR</th>
                    <th style="width:30%" class="text-left">Description</th>
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

        <!-- Bottom Section -->
        <div class="bottom-section">
            <!-- Terms & Conditions -->
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
                        <i class="fas fa-signature"></i>
                        Customer Signature
                    </div>
                    <div class="signature-box">
                        <i class="fas fa-store"></i>
                        For ${ownerInfo.shopName}
                    </div>
                </div>
            </div>

            <!-- Invoice Summary -->
            <div class="invoice-summary">
                <div class="summary-left">
                    <div class="summary-row">
                        <span><i class="fas fa-calculator"></i>Sub Total</span>
                        <span class="amount">₹${totalAmout}</span>
                    </div>
                    <div class="summary-row">
                        <span><i class="fas fa-credit-card"></i>Paid</span>
                        <span class="amount">₹${advamount}</span>
                    </div>
                    <div class="summary-row">
                        <span><i class="fas fa-receipt"></i>Net Total</span>
                        <span class="amount">₹${totalAmout - advamount}</span>
                    </div>
                </div>

                <div class="summary-right">
                    <div class="summary-row">
                        <span><i class="fas fa-percentage"></i>GST</span>
                        <span class="amount">₹${currentinvoiceitems.tax}</span>
                    </div>
                    <div class="summary-row">
                        <span><i class="fas fa-history"></i>Prev Bal</span>
                        <span class="amount">₹${currentinvoiceitems.preBalanceAmt}</span>
                    </div>
                    <div class="summary-row">
                        <span><i class="fas fa-wallet"></i>Cur Bal</span>
                        <span class="amount">₹${profile.currentOusting}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="invoice-footer">
            <i class="fas fa-code"></i>
            Generated by <strong>BillMatePro Solution</strong> •
            <i class="fas fa-phone"></i>
            Contact: 8180080378
        </div>
    </div>
</div>

<!-- Action Buttons -->
<div class="action-buttons">
    <button class="btn btn-outline" onclick="window.location.href='${pageContext.request.contextPath}/login/home'">
        <i class="fas fa-home"></i> Home
    </button>
    <button class="btn btn-outline" onclick="printInvoice()">
        <i class="fas fa-print"></i> Print A5
    </button>
    <button class="btn btn-primary" onclick="downloadPDF()">
        <i class="fas fa-download"></i> Download HD PDF
    </button>
    <a href="https://wa.me/${profile.phoneNo}/?text=Namaste!!!%20*${profile.custName}*,%20आपका%20बिल%20तैयार%20है।%20Invoice%20%23${invoiceNo}%20-%20₹${profile.currentOusting}%0A%0AThank%20you%20for%20your%20business!%0A%0A-%20${ownerInfo.shopName}" target="_blank" class="btn btn-success">
        <i class="fab fa-whatsapp"></i> WhatsApp
    </a>
</div>

</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
    // HD Print Function
    function printInvoice() {
        window.print();
    }

    // HD PDF Download Function
    function downloadPDF() {
        const element = document.getElementById('invoice-container');
        const customerName = '${profile.custName}'.replace(/[^a-zA-Z0-9]/g, '_') || 'Customer';
        const invoiceNo = '${invoiceNo}' || 'INV001';
        const currentDate = new Date().toISOString().slice(0, 10);

        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating HD PDF...';
        btn.disabled = true;

        const originalTransform = element.style.transform;
        element.style.transform = 'scale(1)';

        const opt = {
            margin: [0, 0, 0, 0],
            filename: `Invoice_${invoiceNo}_${customerName}_${currentDate}.pdf`,
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: {
                scale: 3,
                useCORS: true,
                letterRendering: true,
                allowTaint: false,
                backgroundColor: '#ffffff',
                logging: false,
                scrollY: -window.scrollY,
                scrollX: -window.scrollX,
                width: 794,
                height: 559,
                windowWidth: 794,
                windowHeight: 559
            },
            jsPDF: {
                unit: 'mm',
                format: 'a5',
                orientation: 'landscape',
                compress: true
            },
            pagebreak: { mode: 'avoid-all' }
        };

        html2pdf()
            .set(opt)
            .from(element)
            .toPdf()
            .get('pdf')
            .then(function(pdf) {
                const totalPages = pdf.internal.getNumberOfPages();
                if (totalPages > 1) {
                    for (let i = totalPages; i > 1; i--) {
                        pdf.deletePage(i);
                    }
                }
                return pdf;
            })
            .save()
            .then(() => {
                element.style.transform = originalTransform;
                btn.innerHTML = originalText;
                btn.disabled = false;
            })
            .catch((error) => {
                console.error('PDF generation failed:', error);
                alert('PDF generation failed. Please try the print option.');
                element.style.transform = originalTransform;
                btn.innerHTML = originalText;
                btn.disabled = false;
            });
    }

    // Print event handlers
    window.addEventListener('beforeprint', function() {
        document.body.style.background = 'white';
    });

    window.addEventListener('afterprint', function() {
        document.body.style.background = 'linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 50%, #f8fafc 100%)';
    });

    // Responsive scaling
    function adjustInvoiceScale() {
        const container = document.getElementById('invoice-container');
        const viewport = window.innerWidth;

        if (viewport < 480) {
            container.style.transform = 'scale(0.45)';
        } else if (viewport < 600) {
            container.style.transform = 'scale(0.55)';
        } else if (viewport < 768) {
            container.style.transform = 'scale(0.7)';
        } else if (viewport < 900) {
            container.style.transform = 'scale(0.85)';
        } else {
            container.style.transform = 'scale(1)';
        }
    }

    // Initialize
    window.addEventListener('load', adjustInvoiceScale);
    window.addEventListener('resize', adjustInvoiceScale);

    // Keyboard shortcuts
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