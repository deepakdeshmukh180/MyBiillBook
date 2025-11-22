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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>

    <style>
        :root {
            --primary-color: #000000;
            --text-dark: #000000;
            --text-medium: #333333;
            --text-light: #666666;
            --border-color: #000000;
            --bg-light: #f5f5f5;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f0f0f0;
            color: var(--text-dark);
            padding: 20px;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        .page-container {
            width: 4in;
            height: 6in;
            margin: 0 auto 20px;
            background: white;
            border: 2px solid #000;
            overflow: hidden;
            position: relative;
            page-break-after: always;
        }

        .receipt {
            width: 100%;
            height: 100%;
            padding: 8px;
            background: white;
            display: flex;
            flex-direction: column;
            font-size: 11px;
        }

        .receipt-header {
            text-align: center;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 6px;
            margin-bottom: 8px;
        }

        .receipt-badge {
            background: var(--primary-color);
            color: white;
            padding: 4px 8px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
            margin-bottom: 6px;
        }

        .company-name {
            font-size: 18px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .company-details {
            font-size: 9px;
            line-height: 1.4;
            color: var(--text-medium);
        }

        .company-details div {
            margin: 2px 0;
        }

        .receipt-meta {
            display: flex;
            justify-content: space-between;
            font-size: 9px;
            font-weight: 600;
            margin-top: 4px;
            padding-top: 4px;
            border-top: 1px dashed #000;
        }

        .info-section {
            border: 2px solid var(--primary-color);
            padding: 6px;
            margin-bottom: 8px;
            background: var(--bg-light);
        }

        .info-section strong {
            font-size: 9px;
            font-weight: 700;
            text-transform: uppercase;
            display: block;
            margin-bottom: 3px;
        }

        .info-section div {
            font-size: 10px;
            margin: 2px 0;
        }

        .info-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px;
            margin-bottom: 8px;
        }

        .field {
            border-left: 3px solid var(--primary-color);
            padding: 6px;
            background: var(--bg-light);
            margin-bottom: 8px;
        }

        .field label {
            font-weight: 700;
            font-size: 9px;
            text-transform: uppercase;
            display: block;
            margin-bottom: 3px;
        }

        .field-content {
            font-size: 10px;
            font-weight: 600;
        }

        .amount-highlight {
            background: var(--primary-color);
            color: white;
            padding: 4px 8px;
            font-weight: 700;
            font-size: 14px;
            display: inline-block;
            margin-top: 2px;
        }

        .amount-word {
            font-size: 9px;
            color: var(--text-light);
            font-style: italic;
            margin-top: 2px;
        }

        .amount-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 8px;
            border: 2px solid var(--primary-color);
        }

        .amount-table td {
            border: 1px solid var(--border-color);
            padding: 5px;
            font-size: 10px;
        }

        .amount-table tr td:first-child {
            font-weight: 600;
            width: 60%;
        }

        .amount-table tr td:last-child {
            text-align: right;
            font-weight: 700;
        }

        .amount-table tr.highlight td {
            background: var(--primary-color);
            color: white;
            font-weight: 800;
            font-size: 11px;
        }

        .sign-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px;
            margin: 8px 0;
        }

        .sign-box {
            border: 2px dashed var(--border-color);
            padding: 6px;
            text-align: center;
            font-size: 8px;
            font-weight: 700;
            text-transform: uppercase;
            min-height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .receipt-footer {
            text-align: center;
            padding: 6px;
            margin-top: auto;
            border-top: 2px solid var(--primary-color);
            font-size: 8px;
            color: var(--text-medium);
            font-weight: 600;
            background: var(--bg-light);
        }

        .receipt-footer strong {
            color: var(--primary-color);
            font-weight: 800;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
            padding: 15px;
            background: white;
            margin: 0 auto 20px;
            max-width: 500px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 16px;
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
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
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
            color: var(--text-dark);
            border-color: var(--border-color);
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
                size: 4in 6in;
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
                width: 4in !important;
                height: 6in !important;
                margin: 0 !important;
                box-shadow: none !important;
                border: 2px solid #000 !important;
                page-break-after: auto !important;
                page-break-inside: avoid !important;
            }

            .receipt {
                padding: 8px !important;
            }

            .action-buttons {
                display: none !important;
            }

            .amount-highlight,
            .amount-table tr.highlight td,
            .receipt-badge {
                background: #000 !important;
                color: white !important;
            }
        }

        @media screen and (max-width: 768px) {
            body {
                padding: 10px;
            }

            .page-container {
                transform: scale(0.9);
                transform-origin: top center;
            }

            .action-buttons {
                padding: 12px;
                gap: 8px;
            }

            .btn {
                flex: 1 1 calc(50% - 4px);
                min-width: 120px;
                font-size: 12px;
                padding: 8px 12px;
            }
        }

        @media screen and (max-width: 480px) {
            .page-container {
                transform: scale(0.7);
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

<div class="page-container" id="receipt-container">
    <div class="receipt">
        <div class="receipt-header">
            <div class="receipt-badge">
                <i class="fas fa-receipt"></i> PAYMENT RECEIPT
            </div>
            <h2 class="company-name">${ownerInfo.shopName}</h2>
            <div class="company-details">
                <div><i class="fas fa-map-marker-alt"></i> ${ownerInfo.address}</div>
                <div><i class="fas fa-user"></i> ${ownerInfo.ownerName} | <i class="fas fa-phone"></i> ${ownerInfo.mobNumber}</div>
                <div><strong>LC:</strong> ${ownerInfo.lcNo} | <strong>GST:</strong> ${ownerInfo.gstNumber}</div>
            </div>
            <div class="receipt-meta">
                <span><i class="fas fa-hashtag"></i> ${balanceDeposite.id}</span>
                <span><i class="fas fa-calendar"></i> ${balanceDeposite.createdAt}</span>
            </div>
        </div>

        <div class="info-section">
            <strong><i class="fas fa-user-circle"></i> CUSTOMER DETAILS</strong>
            <div><strong>Name:</strong> ${profile.custName}</div>
            <div><strong>Phone:</strong> ${profile.phoneNo}</div>
            <div><strong>Address:</strong> ${profile.address}</div>
        </div>

        <div class="field">
            <label><i class="fas fa-money-bill-wave"></i> RECEIVED AMOUNT</label>
            <div class="field-content">
                <span class="amount-highlight">₹ ${balanceDeposite.advAmt}</span>
            </div>
            <div class="amount-word">(${AMOUNT_WORD} Only)</div>
        </div>

        <div class="field">
            <label><i class="fas fa-info-circle"></i> PURPOSE</label>
            <div class="field-content">${balanceDeposite.description}</div>
        </div>

        <table class="amount-table">
            <tr>
                <td><i class="fas fa-history"></i> Previous Balance</td>
                <td>₹ ${balanceDeposite.currentOusting}</td>
            </tr>
            <tr>
                <td><i class="fas fa-plus-circle"></i> Credited Amount</td>
                <td>₹ ${balanceDeposite.advAmt}</td>
            </tr>
            <tr class="highlight">
                <td><i class="fas fa-calculator"></i> CURRENT BALANCE</td>
                <td>₹ ${profile.currentOusting}</td>
            </tr>
            <tr>
                <td><i class="fas fa-credit-card"></i> Payment Mode</td>
                <td>${balanceDeposite.modeOfPayment}</td>
            </tr>
        </table>

        <div class="sign-row">
            <div class="sign-box">
                <i class="fas fa-signature"></i><br>CUSTOMER SIGN
            </div>
            <div class="sign-box">
                <i class="fas fa-stamp"></i><br>AUTHORIZED SIGN
            </div>
        </div>

        <div class="receipt-footer">
            Generated by <strong>BillMatePro</strong> • <i class="fas fa-phone"></i> 8180080378<br>
            <span id="current-time"></span>
        </div>
    </div>
</div>

<div class="action-buttons">
    <button class="btn btn-outline" onclick="window.location.href='${pageContext.request.contextPath}/login/home'">
        <i class="fas fa-home"></i> Home
    </button>
    <button class="btn btn-primary" onclick="printReceipt()">
        <i class="fas fa-print"></i> Print 4x6
    </button>
    <a href="https://wa.me/${profile.phoneNo}/?text=Hello%20*${profile.custName}*,%20Your%20payment%20receipt%20is%20ready.%20Amount:%20₹${balanceDeposite.advAmt}.%20Balance:%20₹${profile.currentOusting}.%20Thank%20you!%0A%0A-%20${ownerInfo.shopName}"
       target="_blank" class="btn btn-success">
        <i class="fab fa-whatsapp"></i> WhatsApp
    </a>
</div>

</c:if>

<script>
function printReceipt() {
    window.print();
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

window.addEventListener('load', function() {
    setCurrentTime();
});

document.addEventListener('keydown', function(event) {
    if (event.ctrlKey || event.metaKey) {
        switch(event.key) {
            case 'p':
                event.preventDefault();
                printReceipt();
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