<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Receipt #${invoiceNo} – ${profile.custName}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet"/>

    <style>
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
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 50%, #f8fafc 100%);
            color: var(--text-dark);
            font-size: 14px;
            line-height: 1.4;
            padding: 15px;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        .page-container {
            width: 210mm;
            height: 148mm;
            margin: 0 auto 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            position: relative;
            border: 1px solid var(--border-color);
            page-break-after: always;
        }

        .receipt {
            width: 100%;
            height: 100%;
            padding: 4mm;
            background: white;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .receipt::before {
            content: '${ownerInfo.shopName}';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-45deg);
            font-size: 3rem;
            color: rgba(34, 71, 165, 0.03);
            font-weight: 900;
            white-space: nowrap;
            z-index: 0;
            letter-spacing: 5px;
            text-transform: uppercase;
        }

        .receipt > * {
            position: relative;
            z-index: 1;
        }

        .receipt-header {
            text-align: center;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 2mm;
            margin-bottom: 2.5mm;
        }

        .header-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5mm;
            font-size: 7.5px;
            font-weight: 600;
        }

        .header-meta-item {
            padding: 1.5mm 2.5mm;
            background: linear-gradient(135deg, var(--bg-light) 0%, #ffffff 100%);
            border: 1px solid var(--border-color);
            border-radius: 3px;
            display: flex;
            align-items: center;
            gap: 1.5mm;
        }

        .header-meta-item i {
            color: var(--primary-color);
        }

        .receipt-badge {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            color: white;
            padding: 1.5mm 3mm;
            font-size: 8px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            border-radius: 3px;
            display: inline-flex;
            align-items: center;
            gap: 1.5mm;
            box-shadow: 0 2px 8px rgba(34, 71, 165, 0.2);
        }

        .company-name {
            font-size: 16px;
            color: var(--primary-color);
            margin: 1.5mm 0;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .company-details {
            font-size: 7.5px;
            line-height: 1.4;
            color: var(--text-medium);
            font-weight: 500;
        }

        .company-details i {
            width: 9px;
            text-align: center;
            margin-right: 1.5px;
            color: var(--primary-color);
        }

        .receipt-content {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 4mm;
            flex: 1;
        }

        .receipt-left {
            border-right: 2px solid var(--border-color);
            padding-right: 4mm;
            display: flex;
            flex-direction: column;
        }

        .receipt-right {
            display: flex;
            flex-direction: column;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2.5mm;
            border: 2px solid var(--primary-color);
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(34, 71, 165, 0.1);
        }

        .info-table td {
            padding: 2mm;
            font-size: 8px;
            vertical-align: top;
            border-right: 1px solid var(--border-color);
            background: linear-gradient(135deg, var(--bg-light) 0%, #ffffff 100%);
        }

        .info-table td:last-child {
            border-right: none;
        }

        .info-table strong {
            font-weight: 700;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 1.5mm;
            margin-bottom: 1mm;
            font-size: 8px;
            text-transform: uppercase;
        }

        .info-table strong i {
            color: var(--secondary-color);
            font-size: 7.5px;
        }

        .field {
            margin: 2mm 0;
            font-size: 8.5px;
            padding: 2mm 2.5mm;
            background: linear-gradient(135deg, var(--bg-light) 0%, #ffffff 100%);
            border-left: 3px solid var(--secondary-color);
            border-radius: 3px;
            font-weight: 500;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }

        .field label {
            font-weight: 700;
            margin-right: 1.5mm;
            color: var(--text-dark);
            display: inline-flex;
            align-items: center;
            gap: 1.5mm;
            text-transform: uppercase;
            font-size: 8px;
        }

        .field label i {
            color: var(--primary-color);
            font-size: 7.5px;
        }

        .amount-highlight {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #059669 100%);
            color: white;
            padding: 1mm 2.5mm;
            font-weight: 700;
            font-size: 10px;
            border-radius: 3px;
            display: inline-block;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
        }

        .field em {
            color: var(--text-light);
            font-size: 7.5px;
            margin-left: 1.5mm;
        }

        .amount-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2.5mm;
            border: 2px solid var(--primary-color);
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(34, 71, 165, 0.1);
        }

        .amount-table td {
            border: 1px solid var(--border-color);
            padding: 2mm 2.5mm;
            font-size: 8.5px;
            font-weight: 600;
        }

        .amount-table tr td:first-child {
            font-weight: 700;
            background: linear-gradient(135deg, var(--bg-light) 0%, #ffffff 100%);
            width: 60%;
        }

        .amount-table tr td:first-child i {
            color: var(--primary-color);
            font-size: 7.5px;
            margin-right: 1.5mm;
        }

        .amount-table tr td:last-child {
            text-align: right;
            font-weight: 700;
            color: var(--primary-color);
        }

        .amount-table tr.current-balance td {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            color: white;
            font-weight: 800;
            font-size: 9.5px;
            border: none;
            box-shadow: 0 2px 4px rgba(34, 71, 165, 0.2);
        }

        .amount-table tr.current-balance td:first-child i {
            color: white;
        }

        .sign-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2.5mm;
            margin-top: auto;
        }

        .sign-box {
            border: 2px dashed var(--border-color);
            padding: 2.5mm;
            text-align: center;
            font-size: 7.5px;
            min-height: 12mm;
            font-weight: 700;
            color: var(--text-medium);
            text-transform: uppercase;
            border-radius: 3px;
            background: linear-gradient(135deg, #ffffff 0%, var(--bg-light) 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 1.5mm;
        }

        .sign-box i {
            font-size: 10px;
            color: var(--primary-color);
        }

        .receipt-footer {
            text-align: center;
            padding: 1.5mm 0;
            margin-top: 2mm;
            border-top: 2px solid var(--primary-color);
            font-size: 7px;
            color: var(--text-light);
            background: linear-gradient(135deg, #ffffff 0%, var(--bg-light) 100%);
            border-radius: 3px;
            font-weight: 600;
        }

        .receipt-footer strong {
            color: var(--primary-color);
            font-weight: 800;
        }

        .receipt-footer i {
            font-size: 6.5px;
            margin: 0 1mm;
            color: var(--primary-color);
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            padding: 20px;
            background: white;
            margin: 0 auto 20px;
            max-width: 700px;
            border-radius: 10px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border-color);
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
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

        .btn.loading {
            opacity: 0.7;
            cursor: not-allowed;
            pointer-events: none;
        }

        @media print {
            @page {
                size: A5 landscape;
                margin: 0;
            }

            * {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
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
                page-break-after: auto !important;
                page-break-inside: avoid !important;
            }

            .receipt {
                padding: 3mm !important;
                height: 142mm !important;
            }

            .action-buttons {
                display: none !important;
            }

            .receipt-header {
                border-bottom: 2px solid #000 !important;
            }

            .receipt-badge {
                background: #000 !important;
                color: white !important;
            }

            .receipt-left {
                border-right: 2px solid #ddd !important;
            }

            .info-table {
                border: 2px solid #000 !important;
            }

            .field {
                border-left: 3px solid #000 !important;
                background: #f5f5f5 !important;
            }

            .amount-highlight {
                background: #000 !important;
                color: white !important;
            }

            .amount-table {
                border: 2px solid #000 !important;
            }

            .amount-table tr.current-balance td {
                background: #000 !important;
                color: white !important;
            }

            .receipt-footer {
                border-top: 2px solid #000 !important;
                background: #f5f5f5 !important;
            }

            .company-name,
            .info-table strong,
            .field label,
            .receipt-footer strong {
                color: #000 !important;
            }

            .receipt::before {
                color: rgba(0, 0, 0, 0.03) !important;
            }
        }

        @media screen and (max-width: 900px) {
            body {
                padding: 10px;
            }

            .page-container {
                transform: scale(0.85);
                transform-origin: top center;
                margin-bottom: 40px;
            }
        }

        @media screen and (max-width: 768px) {
            .page-container {
                transform: scale(0.7);
                margin-bottom: 60px;
            }

            .action-buttons {
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

            .receipt-content {
                grid-template-columns: 1fr !important;
            }

            .receipt-left {
                border-right: none !important;
                border-bottom: 2px solid var(--border-color);
                padding-right: 0 !important;
                padding-bottom: 3mm;
            }

            .info-table td {
                display: block;
                width: 100% !important;
                border-right: none !important;
                border-bottom: 1px solid var(--border-color);
            }

            .info-table td:last-child {
                border-bottom: none;
            }
        }

        @media screen and (max-width: 480px) {
            .page-container {
                transform: scale(0.45);
                margin-bottom: 120px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }

            .header-meta {
                flex-direction: column;
                gap: 2mm;
            }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="page-container" id="receipt-container">
    <div class="receipt">
        <div class="receipt-header">
            <div class="header-meta">
                <div class="header-meta-item">
                    <i class="fas fa-file-alt"></i>
                    <span>#${balanceDeposite.id}</span>
                </div>
                <div class="receipt-badge">
                    <i class="fas fa-receipt"></i>
                    PAYMENT RECEIPT
                </div>
                <div class="header-meta-item">
                    <i class="fas fa-calendar"></i>
                    <span>${balanceDeposite.createdAt}</span>
                </div>
            </div>
            <h2 class="company-name">${ownerInfo.shopName}</h2>
            <div class="company-details">
                <div><i class="fas fa-map-marker-alt"></i> ${ownerInfo.address}</div>
                <div>
                    <i class="fas fa-user"></i> ${ownerInfo.ownerName} |
                    <i class="fas fa-phone"></i> ${ownerInfo.mobNumber}
                </div>
                <div>
                    <i class="fas fa-id-card"></i> <strong>LC:</strong> ${ownerInfo.lcNo} |
                    <i class="fas fa-building"></i> <strong>GST:</strong> ${ownerInfo.gstNumber}
                </div>
            </div>
        </div>

        <div class="receipt-content">
            <div class="receipt-left">
                <table class="info-table">
                    <tr>
                        <td>
                            <strong><i class="fas fa-user-circle"></i> CUSTOMER</strong>
                            <div>${profile.custName}</div>
                        </td>
                        <td>
                            <strong><i class="fas fa-phone"></i> CONTACT</strong>
                            <div>${profile.phoneNo}</div>
                        </td>
                        <td>
                            <strong><i class="fas fa-home"></i> ADDRESS</strong>
                            <div>${profile.address}</div>
                        </td>
                    </tr>
                </table>

                <div class="field">
                    <label><i class="fas fa-money-bill-wave"></i> RECEIVED AMOUNT:</label>
                    <span class="amount-highlight">₹ ${balanceDeposite.advAmt}</span>
                    <em>(${AMOUNT_WORD} Only)</em>
                </div>

                <div class="field">
                    <label><i class="fas fa-info-circle"></i> PURPOSE:</label>
                    ${balanceDeposite.description}
                </div>

                <div class="sign-row">
                    <div class="sign-box">
                        <i class="fas fa-signature"></i>
                        <div>CUSTOMER SIGNATURE</div>
                    </div>
                    <div class="sign-box">
                        <i class="fas fa-stamp"></i>
                        <div>AUTHORIZED SIGNATURE</div>
                    </div>
                </div>
            </div>

            <div class="receipt-right">
                <table class="amount-table">
                    <tr>
                        <td><i class="fas fa-history"></i> Previous Balance</td>
                        <td>₹ ${balanceDeposite.currentOusting}</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-plus-circle"></i> Credited Amount</td>
                        <td>₹ ${balanceDeposite.advAmt}</td>
                    </tr>
                    <tr class="current-balance">
                        <td><i class="fas fa-calculator"></i> CURRENT BALANCE DUE</td>
                        <td>₹ ${profile.currentOusting}</td>
                    </tr>
                    <tr>
                        <td><i class="fas fa-credit-card"></i> Payment Mode</td>
                        <td>${balanceDeposite.modeOfPayment}</td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="receipt-footer">
            <i class="fas fa-code"></i>
            Generated by <strong>BillMatePro Solution</strong> •
            <i class="fas fa-phone"></i>
            Contact: 8180080378 •
            <i class="fas fa-clock"></i>
            <span id="current-time"></span>
        </div>
    </div>
</div>

<div class="action-buttons">
    <button class="btn btn-outline" onclick="window.location.href='${pageContext.request.contextPath}/login/home'">
        <i class="fas fa-home"></i> Home
    </button>
    <button class="btn btn-outline" onclick="printReceipt()">
        <i class="fas fa-print"></i> Print A5
    </button>

    <a href="https://wa.me/${profile.phoneNo}/?text=Hello%20*${profile.custName}*,%20Your%20payment%20receipt%20is%20ready.%20Amount:%20₹${balanceDeposite.advAmt}.%20Balance:%20₹${profile.currentOusting}.%20Thank%20you!%0A%0A-%20${ownerInfo.shopName}"
       target="_blank" class="btn btn-success">
        <i class="fab fa-whatsapp"></i> WhatsApp
    </a>
</div>

</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
function printReceipt() {
    window.print();
}

function downloadPDF() {
    const element = document.getElementById('receipt-container');
    const btn = event.target;

    if (!element) {
        alert('Receipt element not found!');
        return;
    }

    const customerName = '${profile.custName}' || 'Customer';
    const receiptNo = '${balanceDeposite.id}' || 'RCP001';
    const currentDate = new Date().toISOString().slice(0, 10);

    const originalText = btn.innerHTML;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
    btn.classList.add('loading');

    const originalTransform = element.style.transform;
    const originalMargin = element.style.marginBottom;
    element.style.transform = 'scale(1)';
    element.style.marginBottom = '0';

    setTimeout(() => {
        const opt = {
            margin: [2, 2, 2, 2],
            filename: `Receipt_${receiptNo}_${customerName}_${currentDate}.pdf`,
            image: {
                type: 'jpeg',
                quality: 0.98
            },
            html2canvas: {
                scale: 3,
                useCORS: true,
                letterRendering: true,
                allowTaint: false,
                backgroundColor: '#ffffff',
                logging: false,
                scrollY: 0,
                scrollX: 0,
                windowWidth: element.scrollWidth,
                windowHeight: element.scrollHeight
            },
            jsPDF: {
                unit: 'mm',
                format: 'a5',
                orientation: 'landscape',
                compress: true
            },
            pagebreak: { mode: ['avoid-all', 'css', 'legacy'] }
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
                element.style.marginBottom = originalMargin;
                btn.innerHTML = originalText;
                btn.classList.remove('loading');
            })
            .catch((error) => {
                console.error('PDF generation error:', error);
                alert('PDF generation failed. Please try the print option.');
                element.style.transform = originalTransform;
                element.style.marginBottom = originalMargin;
                btn.innerHTML = originalText;
                btn.classList.remove('loading');
            });
    }, 100);
}

function adjustReceiptScale() {
    const container = document.getElementById('receipt-container');
    if (!container) return;

    const viewport = window.innerWidth;

    if (viewport < 480) {
        container.style.transform = 'scale(0.45)';
        container.style.marginBottom = '120px';
    } else if (viewport < 600) {
        container.style.transform = 'scale(0.55)';
        container.style.marginBottom = '80px';
    } else if (viewport < 768) {
        container.style.transform = 'scale(0.7)';
        container.style.marginBottom = '60px';
    } else if (viewport < 900) {
        container.style.transform = 'scale(0.85)';
        container.style.marginBottom = '40px';
    } else {
        container.style.transform = 'scale(1)';
        container.style.marginBottom = '20px';
    }
}

function setCurrentTime() {
    const timeElement = document.getElementById('current-time');
    if (timeElement) {
        timeElement.textContent = new Date().toLocaleString('en-IN', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }
}

window.addEventListener('beforeprint', function() {
    document.body.style.background = 'white';
    const container = document.getElementById('receipt-container');
    if (container) {
        container.style.transform = 'scale(1)';
    }
});

window.addEventListener('afterprint', function() {
    document.body.style.background = 'linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 50%, #f8fafc 100%)';
    adjustReceiptScale();
});

window.addEventListener('load', function() {
    adjustReceiptScale();
    setCurrentTime();

    if (document.fonts) {
        document.fonts.ready.then(function() {
            console.log('Fonts loaded successfully');
        });
    }
});

window.addEventListener('resize', adjustReceiptScale);

document.addEventListener('keydown', function(event) {
    if (event.ctrlKey || event.metaKey) {
        switch(event.key) {
            case 'p':
                event.preventDefault();
                printReceipt();
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


    // Button hover animations
    document.addEventListener('DOMContentLoaded', function() {
        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(button => {
            button.addEventListener('mouseenter', function() {
                if (!this.classList.contains('loading')) {
                    this.style.transform = 'translateY(-2px)';
                }
            });
            button.addEventListener('mouseleave', function() {
                if (!this.classList.contains('loading')) {
                    this.style.transform = 'translateY(0)';
                }
            });
        });
    });
</script>

</body>
</html>