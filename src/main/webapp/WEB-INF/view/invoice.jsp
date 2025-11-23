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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet">
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
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', monospace, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
            color: var(--text-dark);
            font-size: 14px;
            line-height: 1.4;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        /* 4x6 Thermal Receipt Container - 101.6mm x 152.4mm */
        .thermal-container {
            width: 101.6mm;
            height: 152.4mm;
            margin: 0 auto 20px;
            background: white;
            border: 2px solid #000;
            overflow: hidden;
            position: relative;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        /* Receipt Content */
        .thermal-receipt {
            width: 100%;
            height: 100%;
            padding: 3mm;
            background: white;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
        }

        /* Header Section */
        .thermal-header {
            text-align: center;
            border-bottom: 2px dashed #000;
            padding-bottom: 2mm;
            margin-bottom: 2mm;
        }

        .thermal-logo {
            max-height: 12mm;
            max-width: 30mm;
            margin: 0 auto 1mm;
            display: block;
        }

        .thermal-header h1 {
            font-size: 14px;
            font-weight: 900;
            margin-bottom: 1mm;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .thermal-header .shop-details {
            font-size: 8px;
            line-height: 1.3;
            font-weight: 600;
        }

        .thermal-header .shop-details p {
            margin: 0.5mm 0;
        }

        /* Invoice Meta */
        .thermal-meta {
            text-align: center;
            padding: 2mm 0;
            border-bottom: 2px solid #000;
            margin-bottom: 2mm;
            background: #f5f5f5;
        }

        .thermal-meta h2 {
            font-size: 12px;
            font-weight: 900;
            margin-bottom: 1mm;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .thermal-meta .meta-row {
            display: flex;
            justify-content: space-between;
            font-size: 8px;
            font-weight: 700;
            margin: 0.5mm 0;
            padding: 0 1mm;
        }

        /* QR Code */
        .thermal-qr {
            text-align: center;
            margin: 2mm 0;
            padding: 2mm 0;
            border: 1px solid #000;
            background: white;
        }

        .thermal-qr img {
            max-width: 20mm;
            max-height: 20mm;
        }

        .thermal-qr i {
            font-size: 20px;
        }

        /* Customer Section */
        .thermal-customer {
            border: 1px solid #000;
            padding: 2mm;
            margin-bottom: 2mm;
            background: #f5f5f5;
        }

        .thermal-customer h3 {
            font-size: 9px;
            font-weight: 900;
            margin-bottom: 1mm;
            text-transform: uppercase;
            text-align: center;
            border-bottom: 1px solid #000;
            padding-bottom: 1mm;
        }

        .thermal-customer .customer-row {
            font-size: 7.5px;
            font-weight: 700;
            margin: 0.5mm 0;
            display: flex;
            gap: 2mm;
        }

        .thermal-customer .customer-row strong {
            min-width: 15mm;
            font-weight: 900;
        }

        /* Items Table */
        .thermal-items {
            flex: 1;
            margin-bottom: 2mm;
        }

        .thermal-items table {
            width: 100%;
            border-collapse: collapse;
            border: 2px solid #000;
        }

        .thermal-items thead {
            background: #000;
            color: white;
        }

        .thermal-items thead th {
            padding: 1mm 0.5mm;
            font-size: 7.5px;
            font-weight: 900;
            text-align: center;
            text-transform: uppercase;
            border-right: 1px solid white;
        }

        .thermal-items thead th:last-child {
            border-right: none;
        }

        .thermal-items thead th.left {
            text-align: left;
            padding-left: 1mm;
        }

        .thermal-items thead th.right {
            text-align: right;
            padding-right: 1mm;
        }

        .thermal-items tbody tr {
            border-bottom: 1px solid #000;
        }

        .thermal-items tbody tr:nth-child(even) {
            background: #f5f5f5;
        }

        .thermal-items tbody td {
            padding: 0.8mm 0.5mm;
            font-size: 7px;
            font-weight: 700;
            text-align: center;
        }

        .thermal-items tbody td.left {
            text-align: left;
            padding-left: 1mm;
            font-weight: 800;
        }

        .thermal-items tbody td.right {
            text-align: right;
            padding-right: 1mm;
            font-weight: 800;
        }

        .thermal-items tbody td.amount {
            font-weight: 900;
        }

        /* Summary Section */
        .thermal-summary {
            border: 2px solid #000;
            padding: 2mm;
            margin-bottom: 2mm;
            background: white;
        }

        .thermal-summary .summary-row {
            display: flex;
            justify-content: space-between;
            font-size: 8px;
            font-weight: 700;
            padding: 0.8mm 0;
            border-bottom: 1px dashed #000;
        }

        .thermal-summary .summary-row:last-child {
            border-bottom: none;
        }

        .thermal-summary .summary-row.total {
            font-size: 10px;
            font-weight: 900;
            border-top: 2px solid #000;
            border-bottom: 2px solid #000;
            padding: 1mm 0;
            margin-top: 1mm;
        }

        .thermal-summary .amount {
            font-weight: 900;
        }

        /* Terms & Signature */
        .thermal-terms {
            border-top: 2px dashed #000;
            padding-top: 2mm;
            margin-top: auto;
        }

        .thermal-terms h4 {
            font-size: 8px;
            font-weight: 900;
            margin-bottom: 1mm;
            text-transform: uppercase;
            text-align: center;
        }

        .thermal-terms .terms-text {
            font-size: 6.5px;
            line-height: 1.3;
            text-align: center;
            margin-bottom: 2mm;
            font-weight: 600;
        }

        .thermal-signature {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2mm;
            margin-top: 2mm;
        }

        .signature-box {
            border: 1px dashed #000;
            padding: 1.5mm;
            text-align: center;
            font-size: 7px;
            font-weight: 700;
            height: 8mm;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Footer */
        .thermal-footer {
            text-align: center;
            font-size: 6.5px;
            font-weight: 700;
            padding: 1.5mm 0;
            border-top: 1px solid #000;
            margin-top: 1mm;
        }

        .thermal-footer strong {
            font-weight: 900;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            padding: 20px;
            background: white;
            margin: 0 auto 20px;
            max-width: 600px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border: 1px solid #ddd;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
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
            background: #000;
            color: white;
            border-color: #000;
        }

        .btn-primary:hover {
            background: #333;
            transform: translateY(-2px);
        }

        .btn-success {
            background: #10B981;
            color: white;
            border-color: #10B981;
        }

        .btn-success:hover {
            background: #059669;
            transform: translateY(-2px);
        }

        .btn-outline {
            background: white;
            color: #000;
            border-color: #000;
        }

        .btn-outline:hover {
            background: #000;
            color: white;
            transform: translateY(-2px);
        }

        /* Print Styles - Thermal Optimized */
        @media print {
            @page {
                size: 4in 6in;
                margin: 0;
            }

            * {
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            body {
                background: white !important;
                padding: 0 !important;
                margin: 0 !important;
            }

            .thermal-container {
                width: 101.6mm !important;
                height: 152.4mm !important;
                margin: 0 !important;
                box-shadow: none !important;
                border: none !important;
                page-break-after: avoid !important;
                page-break-inside: avoid !important;
            }

            .thermal-receipt {
                padding: 2mm !important;
            }

            .action-buttons {
                display: none !important;
            }

            /* Enhance text for thermal printing */
            .thermal-header h1,
            .thermal-meta h2,
            .thermal-customer h3,
            .thermal-items thead th,
            .thermal-summary .summary-row.total {
                font-weight: 900 !important;
            }

            .thermal-items tbody td,
            .thermal-summary .amount {
                font-weight: 800 !important;
            }
        }

        /* Mobile Responsive */
        @media screen and (max-width: 768px) {
            body { padding: 10px; }
            .thermal-container {
                transform: scale(0.9);
                transform-origin: top center;
            }
            .action-buttons {
                flex-wrap: wrap;
                padding: 15px;
            }
            .btn {
                flex: 1 1 calc(50% - 6px);
                min-width: 120px;
                font-size: 11px;
                padding: 8px 16px;
            }
        }

        @media screen and (max-width: 480px) {
            .thermal-container {
                transform: scale(0.75);
            }
            .action-buttons {
                flex-direction: column;
            }
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="thermal-container" id="thermal-container">
    <div class="thermal-receipt">
        <!-- Header -->
        <div class="thermal-header">
            <img class="thermal-logo" src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" onerror="this.style.display='none'">
            <h1>${ownerInfo.shopName}</h1>
            <div class="shop-details">
                <p>${ownerInfo.address}</p>
                <p>☎ ${ownerInfo.mobNumber}</p>
                <p>GST: ${ownerInfo.gstNumber}</p>
            </div>
        </div>

        <!-- Invoice Meta -->
        <div class="thermal-meta">
            <h2>TAX INVOICE</h2>
            <div class="meta-row">
                <span>Invoice #:</span>
                <strong>${invoiceNo}</strong>
            </div>
            <div class="meta-row">
                <span>Date:</span>
                <strong>${date}</strong>
            </div>
        </div>

        <!-- QR Code -->
        <c:if test="${not empty QRCODE}">
            <div class="thermal-qr">
                <img src="data:image/png;base64,${QRCODE}" alt="QR Code" />
            </div>
        </c:if>

        <!-- Customer Details -->
        <div class="thermal-customer">
            <h3>CUSTOMER DETAILS</h3>
            <div class="customer-row">
                <strong>Name:</strong>
                <span>${profile.custName}</span>
            </div>
            <div class="customer-row">
                <strong>Contact:</strong>
                <span>${profile.phoneNo}</span>
            </div>
            <div class="customer-row">
                <strong>Address:</strong>
                <span>${profile.address}</span>
            </div>
        </div>

        <!-- Items Table -->
        <div class="thermal-items">
            <table>
                <thead>
                    <tr>
                        <th style="width:8%">SR</th>
                        <th style="width:38%" class="left">Item</th>
                        <c:if test="${invoiceColms.contains('MRP')}">
                            <th style="width:14%" class="right">MRP</th>
                        </c:if>
                        <th style="width:10%">Qty</th>
                        <th style="width:15%" class="right">Rate</th>
                        <th style="width:15%" class="right">Amt</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${items}" var="item">
                        <tr>
                            <td>${item.itemNo}</td>
                            <td class="left">${item.description}</td>
                            <c:if test="${invoiceColms.contains('MRP')}">
                                <td class="right">₹${item.mrp}</td>
                            </c:if>
                            <td>${item.qty}</td>
                            <td class="right">₹${item.rate}</td>
                            <td class="right amount">₹${item.amount}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Summary -->
        <div class="thermal-summary">
            <div class="summary-row">
                <span>Sub Total:</span>
                <span class="amount">₹${totalAmout}</span>
            </div>
            <div class="summary-row">
                <span>GST:</span>
                <span class="amount">₹${currentinvoiceitems.tax}</span>
            </div>
            <div class="summary-row">
                <span>Paid Amount:</span>
                <span class="amount">₹${advamount}</span>
            </div>
            <div class="summary-row">
                <span>Net Total:</span>
                <span class="amount">₹${totalAmout - advamount}</span>
            </div>
            <div class="summary-row">
                <span>Previous Balance:</span>
                <span class="amount">₹${currentinvoiceitems.preBalanceAmt}</span>
            </div>
            <div class="summary-row total">
                <span>CURRENT BALANCE:</span>
                <span class="amount">₹${profile.currentOusting}</span>
            </div>
        </div>

        <!-- Terms & Signature -->
        <div class="thermal-terms">
            <h4>TERMS & CONDITIONS</h4>
            <div class="terms-text">
                ${ownerInfo.terms}
            </div>
            <div class="thermal-signature">
                <div class="signature-box">
                    Customer Sign
                </div>
                <div class="signature-box">
                    Auth. Sign
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="thermal-footer">
            Generated by <strong>BillMatePro Solution</strong><br>
            ☎ 8180080378
        </div>
    </div>
</div>

<!-- Action Buttons -->
<div class="action-buttons">
    <button class="btn btn-outline" onclick="window.location.href='${pageContext.request.contextPath}/login/home'">
        <i class="fas fa-home"></i> Home
    </button>
    <button class="btn btn-outline" onclick="printThermal()">
        <i class="fas fa-print"></i> Print 4x6
    </button>
    <button class="btn btn-primary" onclick="downloadThermalPDF()">
        <i class="fas fa-download"></i> Download PDF
    </button>
    <a href="https://wa.me/${profile.phoneNo}/?text=Namaste!!!%20*${profile.custName}*,%20आपका%20बिल%20तैयार%20है।%20Invoice%20%23${invoiceNo}%20-%20₹${profile.currentOusting}%0A%0AThank%20you%20for%20your%20business!%0A%0A-%20${ownerInfo.shopName}" target="_blank" class="btn btn-success">
        <i class="fab fa-whatsapp"></i> WhatsApp
    </a>
</div>

</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
    // Thermal Print Function
    function printThermal() {
        window.print();
    }

    // Thermal PDF Download Function
    function downloadThermalPDF() {
        const element = document.getElementById('thermal-container');
        const customerName = '${profile.custName}'.replace(/[^a-zA-Z0-9]/g, '_') || 'Customer';
        const invoiceNo = '${invoiceNo}' || 'INV001';
        const currentDate = new Date().toISOString().slice(0, 10);

        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
        btn.disabled = true;

        const opt = {
            margin: [0, 0, 0, 0],
            filename: `Invoice_4x6_${invoiceNo}_${customerName}_${currentDate}.pdf`,
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: {
                scale: 3,
                useCORS: true,
                letterRendering: true,
                allowTaint: false,
                backgroundColor: '#ffffff',
                logging: false,
                scrollY: -window.scrollY,
                scrollX: -window.scrollX
            },
            jsPDF: {
                unit: 'in',
                format: [4, 6],
                orientation: 'portrait',
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
                btn.innerHTML = originalText;
                btn.disabled = false;
            })
            .catch((error) => {
                console.error('PDF generation failed:', error);
                alert('PDF generation failed. Please try the print option.');
                btn.innerHTML = originalText;
                btn.disabled = false;
            });
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', function(event) {
        if (event.ctrlKey || event.metaKey) {
            switch(event.key) {
                case 'p':
                    event.preventDefault();
                    printThermal();
                    break;
                case 's':
                    event.preventDefault();
                    downloadThermalPDF();
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