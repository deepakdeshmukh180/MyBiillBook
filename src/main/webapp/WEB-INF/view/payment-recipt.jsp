<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Payment Slip – ${profile.custName}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- External libs -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Inter', system-ui, Arial, sans-serif;
            font-size: 11px;
            line-height: 1.3;
            margin: 0;
            padding: 6px;
            background: #fff !important;
            color: #111827;
        }

        :root {
            --brand-1: #3c7bff;
            --brand-2: #70a1ff;
            --ink: #111827;
            --muted: #6b7280;
            --border: #e5e7eb;
        }

        /* SLIP CONTAINER */
        .slip-container {
            width: 100%;
            max-width: 210mm;
            min-height: 148mm;
            margin: 0 auto 10px auto;
            background: #fff;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .slip-content { padding: 6mm; }

        /* HEADER */
        .slip-header {
            background: linear-gradient(135deg, var(--brand-1), var(--brand-2));
            color: #fff;
            margin: -6mm -6mm 6px -6mm;
            padding: 6px;
            text-align: center;
        }
        .slip-meta { display:flex; justify-content:space-between; font-size:10px; margin-bottom:4px; }
        .shop-name { font-size: 14px; font-weight: 700; }
        .shop-details { font-size: 9px; line-height: 1.3; }

        /* FIELDS */
        .field { font-size: 11px; margin-bottom: 8px; }
        .field label { font-weight:600; color:var(--brand-1); display:inline-block; width:120px; }
        .amount-line { font-weight:600; color:#111; margin-left:4px; }

        /* AMOUNT TABLE */
        .amount-table { width:100%; border-collapse:collapse; margin:10px 0; font-size: 10.5px; }
        .amount-table td { padding:6px 8px; border-bottom:1px solid var(--border); }
        .amount-table td:first-child{color:var(--muted);font-weight:500}

        /* SIGNATURE */
        .sign-row { display:flex; justify-content:space-between; margin-top:12px; gap:10px; }
        .sign-box { flex:1; border:1px solid var(--border); padding:6px; font-size:10px; text-align:center; border-radius:4px; }

        /* FOOTER */
        .company-footer { text-align:center; font-size:8px; color:var(--muted); margin-top:6px; border-top:1px solid var(--border); padding-top:4px; }

        /* PRINT */
        @page { size: A5 landscape; margin:5mm; }
        @media print {
            body { padding:0; background:#fff; margin:0; }
            .slip-container { box-shadow:none; border-radius:0; max-width:none; width:100%; margin:0; }
            .action-buttons { display:none !important; }
        }

        /* ACTION BUTTONS */
        .action-buttons { display:flex; justify-content:center; gap:8px; margin-top:8px; flex-wrap:wrap; }
        .btn { font-size:11px; padding:6px 10px; border-radius:4px; cursor:pointer; border:none; font-weight:600; }
        .btn-primary{background:linear-gradient(135deg,var(--brand-1),var(--brand-2));color:#fff}
        .btn-secondary{background:#e5e7eb;color:#374151}
        .btn-success{background:linear-gradient(135deg,#059669,#10b981);color:#fff}

        /* MOBILE RESPONSIVE */
        @media (max-width: 768px) {
            .slip-container {
                max-width: 100%;
                min-height: auto;
                padding: 10px;
                box-shadow: none;
                border-radius: 0;
            }
            .slip-content { padding: 12px; }
            .slip-header { padding: 10px; font-size: 12px; }
            .shop-name { font-size: 16px; }
            .shop-details { font-size: 10px; }

            .field { display:block; margin-bottom:12px; }
            .field label { width:100%; display:block; margin-bottom:4px; font-size:12px; }
            .amount-line { font-size:13px; display:inline-block; margin-top:2px; }

            .amount-table { font-size:12px; }
            .amount-table td { padding:8px 6px; }

            .sign-row { flex-direction:column; gap:12px; }
            .sign-box { font-size:12px; padding:10px; }

            .company-footer { font-size:10px; margin-top:12px; }

            .action-buttons { flex-direction:column; gap:10px; padding:12px; }
            .btn { width:100%; font-size:13px; padding:10px; }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">
<div class="slip-container" id="slipRoot">
    <div class="slip-content">

        <!-- HEADER -->
        <div class="slip-header">
            <div class="slip-meta">
                <div><strong>Payment Slip</strong></div>
                <div><i class="fas fa-calendar"></i> ${date}</div>
            </div>
            <div class="shop-name">${ownerInfo.shopName}</div>
            <div class="shop-details">
                ${ownerInfo.address} | ${ownerInfo.ownerName} | ${ownerInfo.mobNumber}<br>
                LC: ${ownerInfo.lcNo} | GST: ${ownerInfo.gstNumber}
            </div>
        </div>

        <!-- FIELDS -->
        <div class="field">
            <label>Received from</label>
            <span class="amount-line">${profile.custName}</span>
            Mob: <span class="amount-line">${profile.phoneNo}</span>
        </div>
        <div class="field">
            <label>Received Amount</label>
            <span class="amount-line">₹ ${balanceDeposite.advAmt} (${AMOUNT_WORD} Only)</span>
        </div>
        <div class="field">
            <label>Purpose</label>
            <span class="amount-line">${balanceDeposite.description}</span>
        </div>

        <!-- AMOUNT TABLE -->
        <table class="amount-table">
            <tr>
                <td>Previous Balance</td>
                <td style="text-align:right;">₹ ${balanceDeposite.currentOusting}</td>
            </tr>
            <tr>
                <td>Credited Amount</td>
                <td style="text-align:right;">₹ ${balanceDeposite.advAmt}</td>
            </tr>
            <tr>
                <td>Current Balance Due</td>
                <td style="text-align:right;">₹ ${profile.currentOusting}</td>
            </tr>
            <tr>
                <td>Payment Mode</td>
                <td style="text-align:right;">${balanceDeposite.modeOfPayment}</td>
            </tr>
        </table>

        <!-- SIGNATURES -->
        <div class="sign-row">
            <div class="sign-box">Customer Sign</div>
            <div class="sign-box">For ${ownerInfo.shopName}</div>
        </div>

        <!-- FOOTER -->
        <div class="company-footer">
            Generated by <strong>MyBillBook Solution</strong> • Ph: 8180080378
        </div>
    </div>
</div>

<!-- ACTIONS -->
<div class="action-buttons">
    <button class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/login/home'">Home</button>
    <button class="btn btn-primary" onclick="downloadSlip(event)">Download PDF</button>
    <a href="https://wa.me/${profile.phoneNo}/?text=Hello%20${profile.custName},%20your%20payment%20slip%20is%20ready."
       target="_blank" class="btn btn-success">Share on WhatsApp</a>
</div>
</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
function downloadSlip(event) {
    const element = document.querySelector('.slip-container');
    element.style.backgroundColor = '#ffffff';

    const opt = {
        margin: [5,5,5,5],
        filename: `PaymentSlip-${document.querySelector('.shop-name').textContent}.pdf`,
        image: { type: 'jpeg', quality: 1.0 },
        html2canvas: { scale: 3, backgroundColor: '#ffffff', useCORS: true, scrollX:0, scrollY:0 },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'landscape' }
    };

    const btn = event.target;
    const original = btn.innerHTML;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating PDF...';
    btn.disabled = true;

    html2pdf().set(opt).from(element).save().then(() => {
        btn.innerHTML = original; btn.disabled = false;
    }).catch(() => {
        btn.innerHTML = original; btn.disabled = false;
        alert('Error generating PDF.');
    });
}
</script>
</body>
</html>
