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

    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f6f9;
            padding: 16px;
            color: #333;
            font-size: 12px;
        }
        .invoice {
            max-width: 750px;
            margin: auto;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            padding: 16px 20px;
            position: relative;
        }
        /* ===== Watermark ===== */
        .invoice::before {
            content: "${ownerInfo.shopName}";
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -219%) rotate(0deg);
            font-size: 2.5rem;
            color: rgba(0, 0, 0, 0.06);
            font-weight: 600;
            white-space: nowrap;
            z-index: 0;
        }
        .invoice * { position: relative; z-index: 1; }

        .header { text-align: center; margin-bottom: 16px; }
        .header h2 {
            font-size: 1.4rem;
            color: #3f51b5;
            margin: 6px 0;
            font-weight: 700;
        }
        .header small {
            font-size: 0.8rem;
            color: #555;
            line-height: 1.4;
            display: block;
        }
        .header .meta {
            display:flex;
            justify-content:space-between;
            font-size: 0.8rem;
            color:#666;
            margin-bottom: 8px;
        }

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .info-table td { padding: 4px 6px; font-size: 0.8rem; vertical-align: top; }

        .amount-table td {
            border: 1px solid #ccc;
            padding: 6px 8px;
            font-size: 0.85rem;
        }
        .amount-table tr td:first-child { font-weight: 600; }
        .amount-table tr:nth-child(even) { background: #fafafa; }
        .amount-table tr.highlight td { background: #fff8e1; color:#c62828; font-weight: 700; }
        .amount-table tr.current-balance td { background: #e3f2fd; color:#1565c0; font-weight: 700; }

        .field { margin: 8px 0; font-size: 0.9rem; }
        .field label { font-weight: 600; margin-right: 6px; }

        .sign-row {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            gap: 10px;
        }
        .sign-box {
            flex: 1;
            border: 1px dashed #aaa;
            padding: 0px;
            text-align: center;
            font-size: 0.8rem;
            border-radius: 4px;
            min-height: 40px;
        }

        .vertical-footer {
            font-size: 0.75rem;
            padding: 6px;
            margin-top: 20px;
            text-align: center;
            border-top: 1px solid #ddd;
            color:#777;
        }

        .btns { margin-top: 14px; gap: 6px; display: flex; justify-content: center; flex-wrap: wrap; }
        .btn {
            font-size: 0.85rem;
            padding: 6px 14px;
            border-radius: 20px;
            cursor: pointer;
            border: none;
            transition: all 0.2s ease;
            background: #3f51b5;
            color: #fff;
        }
        .btn:hover { background: #303f9f; }
        .btn-success { background: #25d366; }
        .btn-success:hover { background: #1da851; }

        @media print {
            .hidden-print { display: none !important; }
            body { background: #fff; }
            .invoice { box-shadow: none; border: 1px solid #999; }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">
    <div class="invoice">

        <!-- Header -->
        <div class="header">
            <div class="meta">
                <div><strong>Invoice No:</strong> #${balanceDeposite.id}</div>
                <div><strong>Payment Receipt</strong></div>
                <div><strong>Date:</strong> ${balanceDeposite.createdAt}</div>
            </div>
            <h2>${ownerInfo.shopName}</h2>
            <small>
                <i class="fa fa-map-marker"></i> ${ownerInfo.address} |
                <i class="fa fa-user"></i> ${ownerInfo.ownerName} |
                <i class="fa fa-phone"></i> ${ownerInfo.mobNumber} <br/>
                <i class="fa fa-id-card"></i> <strong>LC No:</strong> ${ownerInfo.lcNo} |
                <strong>GST:</strong> ${ownerInfo.gstNumber}
            </small>
        </div>

        <!-- Customer Info -->
        <table class="info-table">
            <tr>
                <td><strong>Name:</strong> ${profile.custName}</td>
                <td><strong>Contact:</strong> ${profile.phoneNo}</td>
                <td><strong>Address:</strong> ${profile.address}</td>
            </tr>
        </table>

        <!-- Receipt Fields -->

        <div class="field">
            <label>Received Amount:</label> ₹ ${balanceDeposite.advAmt} (${AMOUNT_WORD} Only)
        </div>
        <div class="field">
            <label>Purpose:</label> ${balanceDeposite.description}
        </div>

        <!-- Amount Table -->
        <table class="amount-table">
            <tr>
                <td>Previous Balance</td>
                <td style="text-align:right;">₹ ${balanceDeposite.currentOusting}</td>
            </tr>
            <tr>
                <td>Credited Amount</td>
                <td style="text-align:right;">₹ ${balanceDeposite.advAmt}</td>
            </tr>
            <tr class="current-balance">
                <td>Current Balance Due</td>
                <td style="text-align:right;">₹ ${profile.currentOusting}</td>
            </tr>
            <tr>
                <td>Payment Mode</td>
                <td style="text-align:right;">${balanceDeposite.modeOfPayment}</td>
            </tr>
        </table>

        <!-- Signatures -->
        <div class="sign-row">
            <div class="sign-box">Customer Sign</div>
            <div class="sign-box">For ${ownerInfo.shopName}</div>
        </div>

        <!-- Footer -->
        <div class="vertical-footer">
            Generated by <strong>MyBillBook Solution</strong> • Contact: 8180080378
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="btns hidden-print">
        <button class="btn" onclick="location.href='${pageContext.request.contextPath}/login/home'">
            <i class="fa fa-home"></i> Home
        </button>
        <button class="btn" onclick="downloadPDF()">
            <i class="fa fa-file-pdf-o"></i> Download PDF
        </button>
        <a href="https://wa.me/${profile.phoneNo}/?text=Hello%20*${profile.custName}*,%20Your%20invoice%20is%20ready.%20Please%20check%20the%20details%20attached."
           target="_blank" class="btn btn-success">
            <i class="fa fa-whatsapp"></i> Send via WhatsApp
        </a>
    </div>
</c:if>

<!-- JS for PDF -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
    function downloadPDF(){
        html2pdf().set({
            margin: [0.5, 0.5, 0.5, 0.5],
            filename: '${profile.custName}_Receipt_${invoiceNo}.pdf',
            image: {type: 'jpeg', quality: 1},
            html2canvas: {scale: 2},
            jsPDF: {unit: 'in', format: 'a4', orientation: 'portrait'}
        }).from(document.querySelector('.invoice')).save();
    }

    // Auto print on load
    window.onload = function() { window.print(); };
</script>

</body>
</html>
