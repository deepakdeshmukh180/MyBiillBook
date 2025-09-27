<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Receipt #${invoiceNo} – ${profile.custName}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <!-- Fonts & Icons -->
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>

    <style>
        :root {
            --primary-black: #000000;
            --secondary-black: #333333;
            --light-gray: #f5f5f5;
            --medium-gray: #cccccc;
            --border-color: #666666;
            --white: #ffffff;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        /* A5 Optimized Layout */
        body {
            font-family: 'Roboto', Arial, sans-serif;
            background: #e9ecef;
            color: var(--primary-black);
            font-size: 10px;
            line-height: 1.3;
            padding: 15px;
        }

        .invoice {
            /* A5 dimensions: 5.83 x 8.27 inches */
            width: 100%;
            max-width: 420px; /* A5 width optimized for screen */
            margin: 0 auto;
            background: var(--white);
            border: 2px solid var(--primary-black);
            padding: 20px 15px;
            position: relative;
            min-height: 580px; /* A5 height optimized */
        }

        /* Sharp Watermark for B&W */
        .invoice::before {
            content: "${ownerInfo.shopName}";
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-45deg);
            font-size: 2.5rem;
            color: rgba(0, 0, 0, 0.05);
            font-weight: 900;
            white-space: nowrap;
            z-index: 0;
            letter-spacing: 3px;
        }

        .invoice * {
            position: relative;
            z-index: 1;
        }

        /* Header Section - Compact A5 */
        .header {
            text-align: center;
            margin-bottom: 15px;
            padding-bottom: 12px;
            border-bottom: 3px solid var(--primary-black);
        }

        .header .meta {
            display: flex;
            justify-content: space-between;
            font-size: 8px;
            color: var(--secondary-black);
            margin-bottom: 8px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .header .meta div {
            padding: 3px 8px;
            background: var(--light-gray);
            border: 1px solid var(--border-color);
            border-radius: 3px;
        }

        .header h2 {
            font-size: 1.4rem;
            color: var(--primary-black);
            margin: 8px 0 6px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .receipt-badge {
            display: inline-block;
            background: var(--primary-black);
            color: var(--white);
            padding: 4px 12px;
            font-size: 8px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 5px 0;
        }

        .header small {
            font-size: 9px;
            color: var(--secondary-black);
            line-height: 1.4;
            display: block;
            font-weight: 400;
        }

        .header small i {
            margin-right: 4px;
            width: 12px;
            text-align: center;
        }

        /* Compact Tables for A5 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 10px 0;
        }

        .info-table {
            background: var(--light-gray);
            border: 1px solid var(--border-color);
        }

        .info-table td {
            padding: 6px 8px;
            font-size: 9px;
            vertical-align: top;
            border-right: 1px solid var(--border-color);
            font-weight: 500;
        }

        .info-table td:last-child {
            border-right: none;
        }

        .info-table strong {
            font-weight: 700;
            color: var(--primary-black);
            display: block;
            margin-bottom: 2px;
        }

        .amount-table {
            margin: 12px 0;
            border: 2px solid var(--primary-black);
        }

        .amount-table td {
            border: 1px solid var(--border-color);
            padding: 6px 8px;
            font-size: 10px;
            font-weight: 500;
        }

        .amount-table tr td:first-child {
            font-weight: 700;
            background: var(--light-gray);
            width: 65%;
        }

        .amount-table tr td:last-child {
            text-align: right;
            font-weight: 700;
        }

        .amount-table tr.current-balance td {
            background: var(--medium-gray);
            color: var(--primary-black);
            font-weight: 900;
            font-size: 11px;
            border: 2px solid var(--primary-black);
        }

        /* Compact Fields */
        .field {
            margin: 8px 0;
            font-size: 10px;
            padding: 6px 8px;
            background: var(--light-gray);
            border-left: 3px solid var(--primary-black);
            font-weight: 500;
        }

        .field label {
            font-weight: 700;
            margin-right: 6px;
            color: var(--primary-black);
        }

        .amount-highlight {
            background: var(--primary-black);
            color: var(--white);
            padding: 2px 6px;
            font-weight: 700;
            font-size: 11px;
        }

        /* Compact Signature Section */
        .sign-row {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            gap: 10px;
        }

        .sign-box {
            flex: 1;
            border: 2px dashed var(--border-color);
            padding: 10px 5px;
            text-align: center;
            font-size: 8px;
            min-height: 35px;
            font-weight: 700;
            color: var(--secondary-black);
            text-transform: uppercase;
        }

        /* Footer */
        .vertical-footer {
            font-size: 8px;
            padding: 8px;
            margin-top: 15px;
            text-align: center;
            border-top: 2px solid var(--primary-black);
            color: var(--secondary-black);
            font-weight: 500;
            background: var(--light-gray);
        }

        /* Action Buttons */
        .btns {
            margin-top: 15px;
            gap: 8px;
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            font-size: 10px;
            padding: 8px 15px;
            border-radius: 20px;
            cursor: pointer;
            border: 2px solid var(--primary-black);
            background: var(--white);
            color: var(--primary-black);
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            text-transform: uppercase;
            transition: all 0.2s ease;
        }

        .btn:hover {
            background: var(--primary-black);
            color: var(--white);
        }

        .btn-success {
            border-color: #28a745;
            color: #28a745;
        }

        .btn-success:hover {
            background: #28a745;
            color: var(--white);
        }

        /* A5 Print Optimization */
        @media print {
            .hidden-print { display: none !important; }

            body {
                background: var(--white) !important;
                padding: 0 !important;
                font-size: 9px !important;
            }

            .invoice {
                border: 3px solid var(--primary-black) !important;
                box-shadow: none !important;
                max-width: none !important;
                width: 100% !important;
                height: auto !important;
                min-height: auto !important;
                padding: 15px !important;
                margin: 0 !important;
            }

            .amount-table tr.current-balance td {
                background: #d0d0d0 !important;
                color: var(--primary-black) !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            .receipt-badge,
            .amount-highlight {
                background: var(--primary-black) !important;
                color: var(--white) !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            .field,
            .info-table,
            .vertical-footer {
                background: #f0f0f0 !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            /* A5 page setup */
            @page {
                size: A5;
                margin: 0.5cm;
            }
        }

        /* Preview Modal for PDF */
        .preview-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.8);
        }

        .preview-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: var(--white);
            padding: 20px;
            border-radius: 8px;
            max-width: 90%;
            max-height: 90%;
            overflow: auto;
        }

        .preview-invoice {
            transform: scale(0.8);
            transform-origin: top center;
        }

        .close-preview {
            position: absolute;
            right: 10px;
            top: 10px;
            font-size: 20px;
            cursor: pointer;
            background: var(--primary-black);
            color: var(--white);
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Loading state */
        .btn.loading {
            opacity: 0.7;
            cursor: not-allowed;
        }

        /* Mobile Responsive for A5 */
        @media (max-width: 480px) {
            body { padding: 8px; }
            .invoice { padding: 12px 10px; }
            .header .meta {
                flex-direction: column;
                gap: 4px;
                align-items: center;
            }
            .sign-row { gap: 5px; }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">
    <div class="invoice">

        <!-- Header -->
        <div class="header">
            <div class="meta">
                <div><i class="fa fa-file-text"></i> #${balanceDeposite.id}</div>
                <div class="receipt-badge">PAYMENT RECEIPT</div>
                <div><i class="fa fa-calendar"></i> ${balanceDeposite.createdAt}</div>
            </div>
            <h2>${ownerInfo.shopName}</h2>
            <small>
                <i class="fa fa-map-marker"></i> ${ownerInfo.address}<br/>
                <i class="fa fa-user"></i> ${ownerInfo.ownerName} |
                <i class="fa fa-phone"></i> ${ownerInfo.mobNumber}<br/>
                <i class="fa fa-id-card"></i> <strong>LC:</strong> ${ownerInfo.lcNo} |
                <i class="fa fa-building"></i> <strong>GST:</strong> ${ownerInfo.gstNumber}
            </small>
        </div>

        <!-- Customer Info -->
        <table class="info-table">
            <tr>
                <td><strong><i class="fa fa-user"></i> CUSTOMER</strong><br/>${profile.custName}</td>
                <td><strong><i class="fa fa-phone"></i> CONTACT</strong><br/>${profile.phoneNo}</td>
                <td><strong><i class="fa fa-home"></i> ADDRESS</strong><br/>${profile.address}</td>
            </tr>
        </table>

        <!-- Receipt Fields -->
        <div class="field">
            <label><i class="fa fa-money"></i> RECEIVED AMOUNT:</label>
            <span class="amount-highlight">₹ ${balanceDeposite.advAmt}</span>
            <em>(${AMOUNT_WORD} Only)</em>
        </div>

        <div class="field">
            <label><i class="fa fa-info-circle"></i> PURPOSE:</label>
            ${balanceDeposite.description}
        </div>

        <!-- Amount Table -->
        <table class="amount-table">
            <tr>
                <td><i class="fa fa-history"></i> Previous Balance</td>
                <td>₹ ${balanceDeposite.currentOusting}</td>
            </tr>
            <tr>
                <td><i class="fa fa-plus-circle"></i> Credited Amount</td>
                <td>₹ ${balanceDeposite.advAmt}</td>
            </tr>
            <tr class="current-balance">
                <td><i class="fa fa-calculator"></i> CURRENT BALANCE DUE</td>
                <td>₹ ${profile.currentOusting}</td>
            </tr>
            <tr>
                <td><i class="fa fa-credit-card"></i> Payment Mode</td>
                <td>${balanceDeposite.modeOfPayment}</td>
            </tr>
        </table>

        <!-- Signatures -->
        <div class="sign-row">
            <div class="sign-box">
                <i class="fa fa-pencil"></i><br/>
                CUSTOMER SIGN
            </div>
            <div class="sign-box">
                <i class="fa fa-stamp"></i><br/>
                AUTHORIZED SIGN
            </div>
        </div>

        <!-- Footer -->
        <div class="vertical-footer">
            <strong>MyBillBook Solution</strong> • Ph: 8180080378 •
            Generated: <span id="current-time"></span>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="btns hidden-print">
        <button class="btn" onclick="location.href='${pageContext.request.contextPath}/login/home'">
            <i class="fa fa-home"></i> Home
        </button>
        <button class="btn" onclick="showPreview()">
            <i class="fa fa-eye"></i> Preview
        </button>
        <button class="btn" onclick="downloadPDF()">
            <i class="fa fa-file-pdf-o"></i> Download PDF
        </button>
        <button class="btn" onclick="window.print()">
            <i class="fa fa-print"></i> Print
        </button>
        <a href="https://wa.me/${profile.phoneNo}/?text=Hello%20*${profile.custName}*,%20Your%20payment%20receipt%20is%20ready.%20Amount:%20₹${balanceDeposite.advAmt}.%20Balance:%20₹${profile.currentOusting}.%20Thank%20you!"
           target="_blank" class="btn btn-success">
            <i class="fa fa-whatsapp"></i> WhatsApp
        </a>
    </div>
</c:if>

<!-- Preview Modal -->
<div id="previewModal" class="preview-modal">
    <div class="preview-content">
        <div class="close-preview" onclick="closePreview()">&times;</div>
        <div id="preview-invoice" class="preview-invoice"></div>
        <div style="text-align: center; margin-top: 15px;">
            <button class="btn" onclick="downloadFromPreview()">
                <i class="fa fa-download"></i> Download This Preview
            </button>
        </div>
    </div>
</div>

<!-- JS Libraries -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
    // High-quality PDF generation optimized for A5
    function downloadPDF(){
        const element = document.querySelector('.invoice');
        const btn = event.target.closest('.btn');

        // Show loading state
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Generating...';
        btn.classList.add('loading');
        btn.disabled = true;

        const opt = {
            margin: [0.2, 0.2, 0.2, 0.2],
            filename: '${profile.custName}_Receipt_${invoiceNo}_A5.pdf',
            image: {
                type: 'jpeg',
                quality: 1.0  // Maximum quality
            },
            html2canvas: {
                scale: 4,  // High scale for sharp text
                useCORS: true,
                letterRendering: true,
                allowTaint: false,
                backgroundColor: '#ffffff',
                removeContainer: true,
                logging: false,
                width: 420,  // A5 width
                height: 580  // A5 height
            },
            jsPDF: {
                unit: 'mm',
                format: 'a5',  // A5 format
                orientation: 'portrait',
                compress: false,  // No compression for better quality
                precision: 16
            }
        };

        html2pdf().set(opt).from(element).save().then(() => {
            btn.innerHTML = originalText;
            btn.classList.remove('loading');
            btn.disabled = false;
        }).catch(() => {
            btn.innerHTML = originalText;
            btn.classList.remove('loading');
            btn.disabled = false;
            alert('Error generating PDF. Please try again.');
        });
    }

    // Preview functionality
    function showPreview() {
        const modal = document.getElementById('previewModal');
        const previewContainer = document.getElementById('preview-invoice');
        const originalInvoice = document.querySelector('.invoice');

        // Clone the invoice for preview
        const clonedInvoice = originalInvoice.cloneNode(true);
        previewContainer.innerHTML = '';
        previewContainer.appendChild(clonedInvoice);

        modal.style.display = 'block';
    }

    function closePreview() {
        document.getElementById('previewModal').style.display = 'none';
    }

    function downloadFromPreview() {
        closePreview();
        setTimeout(downloadPDF, 100);
    }

    // Set current time
    window.onload = function() {
        document.getElementById('current-time').textContent =
            new Date().toLocaleString('en-IN', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
    };

    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        if (e.ctrlKey && e.key === 'p') {
            e.preventDefault();
            window.print();
        }
        if (e.ctrlKey && e.key === 's') {
            e.preventDefault();
            downloadPDF();
        }
        if (e.key === 'Escape') {
            closePreview();
        }
    });

    // Close preview when clicking outside
    document.getElementById('previewModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closePreview();
        }
    });
</script>

</body>
</html>