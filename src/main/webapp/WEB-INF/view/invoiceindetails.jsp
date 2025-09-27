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
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e40af;
            --text-dark: #000000;
            --text-medium: #1f2937;
            --text-light: #4b5563;
            --border-color: #d1d5db;
            --bg-light: #f9fafb;
        }

        body {
            font-family: 'Arial', 'Helvetica', sans-serif;
            background: linear-gradient(135deg, #e5e7eb 0%, #f3f4f6 100%);
            margin: 0;
            padding: 15px;
            color: var(--text-dark);
            font-size: 14px;
            line-height: 1.4;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        /* A5 Page Container - Exact A5 dimensions */
        .page-container {
            width: 210mm;
            height: 148mm;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            overflow: hidden;
            position: relative;
            border: 1px solid var(--border-color);
        }

        /* Invoice Content */
        .invoice {
            width: 100%;
            height: 100%;
            padding: 8mm;
            background: white;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
        }

        /* Header Section */
        .invoice-header {
            border-bottom: 3px solid var(--text-dark);
            padding-bottom: 4mm;
            margin-bottom: 4mm;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 3mm;
        }

        .company-info h1 {
            font-size: 18px;
            font-weight: 900;
            margin-bottom: 2mm;
            color: var(--text-dark);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .company-details {
            font-size: 9px;
            line-height: 1.3;
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
        }

        .invoice-meta {
            text-align: right;
            border: 2px solid var(--text-dark);
            padding: 3mm;
            background: white;
            min-width: 35mm;
            position: relative;
        }

        .invoice-meta h2 {
            font-size: 14px;
            margin-bottom: 2mm;
            font-weight: 900;
            color: var(--text-dark);
        }

        /* QR Code in header */
        .header-qr {
            position: absolute;
            top: 3mm;
            left: -25mm;
            width: 20mm;
            height: 20mm;
            border: 1px solid var(--text-dark);
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .header-qr img {
            max-width: 18mm;
            max-height: 18mm;
        }

        .header-qr i {
            font-size: 14px;
            color: var(--text-dark);
        }

        .invoice-meta .meta-item {
            margin-bottom: 1mm;
            font-size: 9px;
            font-weight: 600;
            color: var(--text-medium);
        }

        /* Customer Section */
        .customer-section {
            background: var(--bg-light);
            border: 1px solid var(--border-color);
            padding: 3mm;
            margin-bottom: 3mm;
            border-left: 4px solid var(--text-dark);
        }

        .customer-title {
            font-weight: 900;
            font-size: 12px;
            margin-bottom: 3mm;
            color: var(--text-dark);
            text-transform: uppercase;
            display: flex;
            align-items: center;
            gap: 2mm;
            letter-spacing: 0.5px;
        }

        .customer-details {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2mm;
        }

        .customer-item {
            font-size: 10px;
            font-weight: 700;
            color: var(--text-medium);
            line-height: 1.3;
        }

        .customer-item strong {
            color: var(--text-dark);
            font-weight: 900;
        }

        /* Items Table - Print Optimized */
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 3mm;
            border: 2px solid var(--text-dark);
            flex: 1;
        }

        .items-table thead th {
            background: var(--text-dark);
            color: white;
            padding: 2mm 1mm;
            font-weight: 900;
            text-align: center;
            font-size: 8px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            border-right: 1px solid white;
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
        }

        .items-table tbody tr:nth-child(even) {
            background: #f8f9fa;
        }

        .items-table tbody td {
            padding: 1.5mm 1mm;
            font-size: 8px;
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
            font-weight: 900;
        }

        .items-table .text-right {
            text-align: right !important;
            font-weight: 900;
        }

        .items-table .amount {
            font-weight: 900;
            color: var(--text-dark);
        }

        /* Bottom Section */
        .bottom-section {
            display: grid;
            grid-template-columns: 1.2fr 50mm;
            gap: 3mm;
            margin-top: auto;
        }

        /* Terms Section */
        .terms-section {
            border: 1px solid var(--border-color);
            padding: 2mm;
            background: white;
        }

        .terms-title {
            font-weight: 900;
            margin-bottom: 1mm;
            font-size: 8px;
            color: var(--text-dark);
            text-transform: uppercase;
        }

        .terms-text {
            font-size: 7px;
            line-height: 1.2;
            color: var(--text-medium);
            margin-bottom: 2mm;
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
            font-weight: 700;
            color: var(--text-medium);
            height: 8mm;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* QR Section - Remove from bottom */
        .qr-section {
            display: none;
        }

        /* Invoice Summary - Split into two columns */
        .invoice-summary {
            background: white;
            border: 2px solid var(--text-dark);
            padding: 2mm;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2mm;
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
            padding: 1mm 0;
            font-size: 7px;
            border-bottom: 1px solid var(--border-color);
        }

        .summary-row:last-child {
            border-bottom: none;
        }

        .summary-row.highlight {
            background: #f3f4f6;
            margin: 1mm -2mm;
            padding: 2mm;
            font-weight: 900;
            color: var(--text-dark);
            border: 1px solid var(--text-dark);
        }

        .summary-row.current-balance {
            background: var(--text-dark);
            color: white;
            margin: 2mm -2mm 0;
            padding: 2mm;
            font-weight: 900;
            font-size: 8px;
        }

        .summary-row .amount {
            font-weight: 900;
        }

        /* Footer */
        .invoice-footer {
            text-align: center;
            padding: 1mm 0;
            margin-top: 2mm;
            border-top: 1px solid var(--border-color);
            font-size: 7px;
            color: var(--text-light);
        }

        /* Action Buttons - Screen Only */
        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
            padding: 20px;
            background: white;
            margin-top: 20px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s ease;
            cursor: pointer;
            border: 2px solid;
            font-size: 14px;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .btn-success {
            background: #059669;
            color: white;
            border-color: #059669;
        }

        .btn-success:hover {
            background: #047857;
            border-color: #047857;
        }

        .btn-outline {
            background: white;
            color: var(--text-dark);
            border-color: var(--text-dark);
        }

        .btn-outline:hover {
            background: var(--text-dark);
            color: white;
        }

        /* Print Styles - Critical for A5 */
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
                color: black !important;
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
                overflow: visible !important;
            }

            .invoice {
                padding: 5mm !important;
                height: 138mm !important;
                background: white !important;
            }

            .action-buttons {
                display: none !important;
            }

            /* Ensure black text for printing */
            .invoice-header,
            .company-info h1,
            .invoice-meta h2,
            .customer-title,
            .items-table thead th,
            .items-table tbody td,
            .terms-title,
            .summary-row {
                color: black !important;
            }

            /* Ensure borders print correctly */
            .invoice-header {
                border-bottom: 2px solid black !important;
            }

            .invoice-meta {
                border: 2px solid black !important;
            }

            .customer-section {
                border-left: 3px solid black !important;
                border: 1px solid black !important;
                background: white !important;
            }

            .items-table {
                border: 2px solid black !important;
            }

            .items-table thead th {
                background: black !important;
                color: white !important;
            }

            .items-table tbody tr:nth-child(even) {
                background: #f5f5f5 !important;
            }

            .summary-row.highlight {
                background: #f0f0f0 !important;
                border: 1px solid black !important;
            }

            .summary-row.current-balance {
                background: black !important;
                color: white !important;
            }

            .terms-section,
            .summary-left {
                border-right: 1px solid black !important;
            }

            .invoice-summary {
                border: 2px solid black !important;
            }

            .qr-section {
                border: 1px solid black !important;
            }

            /* Font adjustments for print */
            .company-info h1 {
                font-size: 16px !important;
            }

            .company-details {
                font-size: 8px !important;
            }

            .invoice-meta .meta-item {
                font-size: 8px !important;
            }

            .customer-item {
                font-size: 7px !important;
            }

            .items-table thead th {
                font-size: 7px !important;
                padding: 1mm !important;
            }

            .items-table tbody td {
                font-size: 7px !important;
                padding: 1mm !important;
            }

            .summary-row {
                font-size: 6px !important;
            }

            .summary-row.current-balance {
                font-size: 7px !important;
            }
        }

        /* Screen only styles */
        @media screen {
            .page-container {
                box-shadow: 0 10px 25px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
        }

        /* Mobile Responsive */
        @media screen and (max-width: 768px) {
            body {
                padding: 10px;
            }

            .page-container {
                width: 100%;
                height: auto;
                min-height: 148mm;
            }

            .invoice {
                height: auto;
                padding: 15px;
            }

            .header-top {
                flex-direction: column;
                gap: 10px;
            }

            .customer-details {
                grid-template-columns: 1fr;
                gap: 8px;
            }

            .bottom-section {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="page-container" id="invoice-container">
    <!-- Single Invoice -->
    <div class="invoice">
        <!-- Header -->
        <div class="invoice-header">
            <div class="header-top">
                <div class="company-info">
                    <h1>${ownerInfo.shopName}</h1>
                    <div class="company-details">
                        <p><i class="fas fa-map-marker-alt"></i> ${ownerInfo.address}</p>
                        <p><i class="fas fa-user"></i> ${ownerInfo.ownerName}</p>
                        <p><i class="fas fa-phone"></i> ${ownerInfo.mobNumber}</p>
                        <p><i class="fas fa-id-card"></i> <strong>LC:</strong> ${ownerInfo.lcNo} | <strong>GST:</strong> ${ownerInfo.gstNumber}</p>
                    </div>
                </div>

                <div class="invoice-meta">
                    <!-- QR Code in header -->
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
                    <div class="signature-box">Customer Signature</div>
                    <div class="signature-box">For ${ownerInfo.shopName}</div>
                </div>
            </div>

            <!-- Invoice Summary -->
            <div class="invoice-summary">
                <!-- Left Column -->
                <div class="summary-left">
                    <div class="summary-row">
                        <span>Sub Total</span>
                        <span class="amount">₹${totalAmout}</span>
                    </div>
                    <div class="summary-row">
                        <span>Paid Amount</span>
                        <span class="amount">₹${advamount}</span>
                    </div>
                    <div class="summary-row highlight">
                        <span>Net Total</span>
                        <span class="amount">₹${totalAmout - advamount}</span>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="summary-right">
                    <div class="summary-row">
                        <span>GST</span>
                        <span class="amount">₹${currentinvoiceitems.tax}</span>
                    </div>
                    <div class="summary-row">
                        <span>Prev Balance</span>
                        <span class="amount">₹${currentinvoiceitems.preBalanceAmt}</span>
                    </div>
                    <div class="summary-row highlight">
                        <span>Curr.Balance</span>
                        <span class="amount">₹${profile.currentOusting}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="invoice-footer">
            Generated by <strong>MyBillBook Solution</strong> • Contact: 8180080378
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
        <i class="fas fa-file-pdf"></i> Download A5 PDF
    </button>
    <a href="https://wa.me/${profile.phoneNo}/?text=Namaste!!!%20*${profile.custName}*,%20आपका%20बिल%20तैयार%20है।%20Invoice%20%23${invoiceNo}%20-%20₹${profile.currentOusting}%0A%0AThank%20you%20for%20your%20business!%0A%0A-%20${ownerInfo.shopName}" target="_blank" class="btn btn-success">
        <i class="fab fa-whatsapp"></i> WhatsApp करें
    </a>
</div>

</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
    // A5 Print Function
    function printInvoice() {
        // Create print-specific styles
        const printStyle = document.createElement('style');
        printStyle.textContent = `
            @media print {
                @page {
                    size: A5 landscape;
                    margin: 0mm;
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
                    width: 210mm !important;
                    height: 148mm !important;
                }
            }
        `;
        document.head.appendChild(printStyle);

        // Print
        window.print();

        // Remove print styles after printing
        setTimeout(() => {
            document.head.removeChild(printStyle);
        }, 1000);
    }

    // Enhanced A5 PDF Download
    function downloadPDF() {
        const element = document.getElementById('invoice-container');
        const customerName = '${profile.custName}' || 'Customer';
        const invoiceNo = '${invoiceNo}' || 'INV001';

        const opt = {
            margin: [0, 0, 0, 0],
            filename: `${customerName}_Invoice_${invoiceNo}_A5.pdf`,
            image: {
                type: 'jpeg',
                quality: 1.0
            },
            html2canvas: {
                scale: 3,
                useCORS: true,
                allowTaint: true,
                backgroundColor: '#ffffff',
                width: 794, // A5 landscape width in pixels at 96 DPI
                height: 559, // A5 landscape height in pixels at 96 DPI
                scrollX: 0,
                scrollY: 0
            },
            jsPDF: {
                unit: 'mm',
                format: [210, 148], // A5 landscape
                orientation: 'landscape',
                compress: true
            }
        };

        // Generate PDF
        html2pdf().set(opt).from(element).save().catch((error) => {
            console.error('PDF generation failed:', error);
            alert('PDF generation failed. Please try the print option instead.');
        });
    }

    // Enhanced print event handlers
    window.addEventListener('beforeprint', function() {
        document.body.style.background = 'white';

        // Ensure proper A5 formatting
        const container = document.getElementById('invoice-container');
        if (container) {
            container.style.width = '210mm';
            container.style.height = '148mm';
            container.style.transform = 'scale(1)';
            container.style.transformOrigin = 'top left';
        }
    });

    window.addEventListener('afterprint', function() {
        document.body.style.background = 'linear-gradient(135deg, #e5e7eb 0%, #f3f4f6 100%)';
    });

    // Auto-adjust for different screen sizes
    function adjustPageSize() {
        const container = document.getElementById('invoice-container');
        const screenWidth = window.innerWidth;

        if (screenWidth < 768) {
            // Mobile adjustment
            container.style.transform = 'scale(0.4)';
            container.style.transformOrigin = 'top center';
            container.style.marginBottom = '50px';
        } else if (screenWidth < 1024) {
            // Tablet adjustment
            container.style.transform = 'scale(0.7)';
            container.style.transformOrigin = 'top center';
        } else {
            // Desktop - no scaling needed
            container.style.transform = 'scale(1)';
        }
    }

    // Apply on load and resize
    window.addEventListener('load', adjustPageSize);
    window.addEventListener('resize', adjustPageSize);

    // Ensure fonts are loaded before operations
    document.fonts.ready.then(() => {
        console.log('All fonts loaded successfully for A5 invoice');
    });
</script>

</body>
</html>