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
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --text-dark: #000000;
            --text-medium: #333333;
            --text-light: #666666;
            --border-color: #000000;
            --bg-white: #ffffff;
        }

        body {
            font-family: 'Courier New', 'Consolas', monospace;
            background: #f0f0f0;
            margin: 0;
            padding: 10px;
            color: var(--text-dark);
            font-size: 11px;
            line-height: 1.2;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        /* 4×6 Thermal Paper Container (4 inches = 101.6mm, 6 inches = 152.4mm) */
        .thermal-container {
            width: 101.6mm;
            max-width: 101.6mm;
            min-height: 152.4mm;
            margin: 0 auto;
            background: white;
            border: 1px solid #ccc;
            overflow: hidden;
            position: relative;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        /* Invoice Content */
        .thermal-invoice {
            width: 100%;
            padding: 3mm;
            background: white;
            box-sizing: border-box;
        }

        /* Header Section - Compact */
        .thermal-header {
            text-align: center;
            border-bottom: 1px solid var(--text-dark);
            padding-bottom: 2mm;
            margin-bottom: 2mm;
        }

        .shop-name {
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 1mm;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .shop-details {
            font-size: 8px;
            line-height: 1.1;
            margin-bottom: 1mm;
        }

        .shop-details div {
            margin-bottom: 0.5mm;
        }

        .invoice-title {
            font-size: 12px;
            font-weight: bold;
            margin: 1mm 0;
            text-decoration: underline;
        }

        .invoice-meta {
            font-size: 9px;
            display: flex;
            justify-content: space-between;
            margin-bottom: 1mm;
        }

        /* QR Code - Top Right Corner */
        .qr-code {
            position: absolute;
            top: 2mm;
            right: 2mm;
            width: 12mm;
            height: 12mm;
            border: 1px solid var(--text-dark);
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
        }

        .qr-code img {
            max-width: 10mm;
            max-height: 10mm;
        }

        .qr-code i {
            font-size: 8px;
        }

        /* Customer Section - Simplified */
        .customer-section {
            border: 1px solid var(--text-dark);
            padding: 1.5mm;
            margin-bottom: 2mm;
            font-size: 8px;
        }

        .customer-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5mm;
        }

        .customer-row:last-child {
            margin-bottom: 0;
        }

        .customer-label {
            font-weight: bold;
            min-width: 20mm;
        }

        .customer-value {
            text-align: right;
            flex: 1;
            word-break: break-all;
        }

        /* Items Table - Thermal Optimized */
        .items-section {
            margin-bottom: 2mm;
        }

        .items-header {
            border-top: 1px solid var(--text-dark);
            border-bottom: 1px solid var(--text-dark);
            padding: 1mm 0;
            font-size: 7px;
            font-weight: bold;
            display: grid;
            grid-template-columns: 8mm 1fr 12mm 15mm;
            gap: 1mm;
            text-align: center;
        }

        .items-header .desc-col {
            text-align: left;
        }

        .items-header .amt-col {
            text-align: right;
        }

        .item-row {
            padding: 1mm 0;
            font-size: 7px;
            display: grid;
            grid-template-columns: 8mm 1fr 12mm 15mm;
            gap: 1mm;
            border-bottom: 1px dotted #ccc;
            align-items: start;
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .item-sr {
            text-align: center;
            font-weight: bold;
        }

        .item-desc {
            text-align: left;
            word-break: break-word;
            line-height: 1.1;
        }

        .item-desc-details {
            font-size: 6px;
            color: var(--text-medium);
            margin-top: 0.5mm;
        }

        .item-qty {
            text-align: center;
            font-weight: bold;
        }

        .item-amt {
            text-align: right;
            font-weight: bold;
        }

        /* Summary Section */
        .summary-section {
            border-top: 2px solid var(--text-dark);
            padding-top: 2mm;
            margin-bottom: 2mm;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            font-size: 8px;
            margin-bottom: 0.5mm;
            padding: 0.5mm 0;
        }

        .summary-row.highlight {
            font-weight: bold;
            border-top: 1px solid var(--text-dark);
            border-bottom: 1px solid var(--text-dark);
            padding: 1mm 0;
            margin: 1mm 0;
        }

        .summary-row.total {
            font-size: 10px;
            font-weight: bold;
            border: 2px solid var(--text-dark);
            padding: 1.5mm;
            margin: 2mm 0;
            background: #f0f0f0;
        }

        .summary-label {
            font-weight: bold;
        }

        .summary-value {
            font-weight: bold;
            text-align: right;
        }

        /* Footer Section */
        .footer-section {
            border-top: 1px solid var(--text-dark);
            padding-top: 2mm;
            text-align: center;
        }

        .terms-compact {
            font-size: 6px;
            line-height: 1.1;
            margin-bottom: 2mm;
            text-align: justify;
        }

        .signature-line {
            border-bottom: 1px solid var(--text-dark);
            margin: 3mm 0 1mm 0;
            height: 8mm;
            display: flex;
            align-items: end;
            justify-content: center;
            font-size: 7px;
        }

        .thank-you {
            font-size: 8px;
            font-weight: bold;
            margin-bottom: 1mm;
        }

        .contact-info {
            font-size: 6px;
            color: var(--text-medium);
        }

        /* Print Styles - Critical for 4×6 Thermal */
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
                overflow: visible !important;
            }

            .thermal-invoice {
                padding: 2mm !important;
            }

            .action-buttons {
                display: none !important;
            }

            /* Ensure all borders and text print in black */
            .thermal-header,
            .customer-section,
            .items-header,
            .item-row,
            .summary-section,
            .footer-section {
                color: black !important;
                border-color: black !important;
            }

            .summary-row.total {
                background: white !important;
                border-color: black !important;
            }

            /* Smaller fonts for thermal printing */
            .shop-name {
                font-size: 12px !important;
            }

            .shop-details {
                font-size: 7px !important;
            }

            .invoice-meta {
                font-size: 8px !important;
            }

            .customer-section {
                font-size: 7px !important;
            }

            .items-header,
            .item-row {
                font-size: 6px !important;
            }

            .summary-row {
                font-size: 7px !important;
            }

            .summary-row.total {
                font-size: 9px !important;
            }
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
            padding: 15px;
            background: white;
            margin-top: 15px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s ease;
            cursor: pointer;
            border: 2px solid;
            font-size: 12px;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
            border-color: #2563eb;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-success {
            background: #059669;
            color: white;
            border-color: #059669;
        }

        .btn-success:hover {
            background: #047857;
        }

        .btn-outline {
            background: white;
            color: #374151;
            border-color: #374151;
        }

        .btn-outline:hover {
            background: #374151;
            color: white;
        }

        /* Mobile Responsive */
        @media screen and (max-width: 480px) {
            body {
                padding: 5px;
            }

            .thermal-container {
                width: 100%;
                max-width: 280px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 8px;
            }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="thermal-container" id="thermal-invoice-container">
    <div class="thermal-invoice">

        <!-- QR Code -->
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

        <!-- Header -->
        <div class="thermal-header">
            <div class="shop-name">${ownerInfo.shopName}</div>
            <div class="shop-details">
                <div>${ownerInfo.address}</div>
                <div>📞 ${ownerInfo.mobNumber}</div>
                <div>GST: ${ownerInfo.gstNumber}</div>
            </div>
            <div class="invoice-title">TAX INVOICE</div>
            <div class="invoice-meta">
                <span><strong>Bill #:</strong> ${invoiceNo}</span>
                <span><strong>Date:</strong> ${date}</span>
            </div>
        </div>

        <!-- Customer Section -->
        <div class="customer-section">
            <div class="customer-row">
                <span class="customer-label">Name:</span>
                <span class="customer-value">${profile.custName}</span>
            </div>
            <div class="customer-row">
                <span class="customer-label">Phone:</span>
                <span class="customer-value">${profile.phoneNo}</span>
            </div>
            <div class="customer-row">
                <span class="customer-label">Address:</span>
                <span class="customer-value">${profile.address}</span>
            </div>
        </div>

        <!-- Items Section -->
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
                                Brand: ${item.brand}<br/>
                            </c:if>
                            <c:if test="${invoiceColms.contains('BATCHNO') && not empty item.batchNo}">
                                Batch: ${item.batchNo}<br/>
                            </c:if>
                            <c:if test="${invoiceColms.contains('EXPD') && not empty item.expDate}">
                                Exp: ${item.expDate}<br/>
                            </c:if>
                            <c:if test="${invoiceColms.contains('MRP')}">
                                MRP: ₹${item.mrp}<br/>
                            </c:if>
                            Rate: ₹${item.rate}
                        </div>
                    </div>
                    <div class="item-qty">${item.qty}</div>
                    <div class="item-amt">₹${item.amount}</div>
                </div>
            </c:forEach>
        </div>

        <!-- Summary Section -->
        <div class="summary-section">
            <div class="summary-row">
                <span class="summary-label">Sub Total:</span>
                <span class="summary-value">₹${totalAmout}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label">GST:</span>
                <span class="summary-value">₹${currentinvoiceitems.tax}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Paid Amount:</span>
                <span class="summary-value">₹${advamount}</span>
            </div>
            <div class="summary-row highlight">
                <span class="summary-label">Net Amount:</span>
                <span class="summary-value">₹${totalAmout - advamount}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Previous Balance:</span>
                <span class="summary-value">₹${currentinvoiceitems.preBalanceAmt}</span>
            </div>
            <div class="summary-row total">
                <span class="summary-label">CURRENT BALANCE:</span>
                <span class="summary-value">₹${profile.currentOusting}</span>
            </div>
        </div>

        <!-- Footer -->
        <div class="footer-section">
            <div class="terms-compact">
                ${fn:substring(ownerInfo.terms, 0, 150)}...
            </div>
            <div class="signature-line">
                Authorized Signature
            </div>
            <div class="thank-you">THANK YOU FOR YOUR BUSINESS!</div>
            <div class="contact-info">
                Generated by MyBillBook Solution • 8180080378
            </div>
        </div>

    </div>
</div>

<!-- Action Buttons -->
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
    // 4×6 Thermal Print Function
    function printThermalInvoice() {
        const printStyle = document.createElement('style');
        printStyle.textContent = `
            @media print {
                @page {
                    size: 4in 6in;
                    margin: 0mm;
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
                    width: 4in !important;
                    height: 6in !important;
                }
            }
        `;
        document.head.appendChild(printStyle);

        window.print();

        setTimeout(() => {
            document.head.removeChild(printStyle);
        }, 1000);
    }

    // 4×6 Thermal PDF Download
    function downloadThermalPDF() {
        const element = document.getElementById('thermal-invoice-container');
        const customerName = '${profile.custName}' || 'Customer';
        const invoiceNo = '${invoiceNo}' || 'INV001';

        const opt = {
            margin: [0, 0, 0, 0],
            filename: `${customerName}_Invoice_${invoiceNo}_4x6.pdf`,
            image: {
                type: 'jpeg',
                quality: 1.0
            },
            html2canvas: {
                scale: 4,
                useCORS: true,
                allowTaint: true,
                backgroundColor: '#ffffff',
                width: 384,  // 4 inches at 96 DPI
                height: 576, // 6 inches at 96 DPI
                scrollX: 0,
                scrollY: 0
            },
            jsPDF: {
                unit: 'in',
                format: [4, 6],
                orientation: 'portrait',
                compress: true
            }
        };

        html2pdf().set(opt).from(element).save().catch((error) => {
            console.error('PDF generation failed:', error);
            alert('PDF generation failed. Please try the print option instead.');
        });
    }

    // Print event handlers
    window.addEventListener('beforeprint', function() {
        document.body.style.background = 'white';
    });

    window.addEventListener('afterprint', function() {
        document.body.style.background = '#f0f0f0';
    });

    // Auto-adjust for mobile screens
    function adjustThermalSize() {
        const container = document.getElementById('thermal-invoice-container');
        const screenWidth = window.innerWidth;

        if (screenWidth < 480) {
            container.style.transform = 'scale(0.85)';
            container.style.transformOrigin = 'top center';
            container.style.marginBottom = '20px';
        } else {
            container.style.transform = 'scale(1)';
        }
    }

    window.addEventListener('load', adjustThermalSize);
    window.addEventListener('resize', adjustThermalSize);

    // Ensure fonts are loaded
    document.fonts.ready.then(() => {
        console.log('Thermal invoice fonts loaded successfully');
    });
</script>

</body>
</html>