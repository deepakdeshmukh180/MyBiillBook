<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Invoice #${invoiceNo} – ${profile.custName}</title>
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
            --table-alt: #fafbfc;
        }

        /* A5 LANDSCAPE */
        .invoice-container {
            width: 100%;
            max-width: 210mm; /* Landscape width */
            min-height: 148mm; /* Landscape height */
            margin: 0 auto 10px auto;
            background: #fff;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .invoice-content { padding: 6mm; }

        /* HEADER */
        .invoice-header {
            background: linear-gradient(135deg, var(--brand-1), var(--brand-2));
            color: #fff;
            margin: -6mm -6mm 6px -6mm;
            padding: 6px;
            text-align: center;
        }
        .invoice-meta { display:flex; justify-content:space-between; font-size:10px; margin-bottom:4px; }
        .shop-name { font-size: 14px; font-weight: 700; }
        .shop-details { font-size: 9px; line-height: 1.3; }

        /* CUSTOMER COMPACT */
        .customer-section {
            background: #f8f9ff;
            border-left: 2px solid var(--brand-1);
            padding: 4px 6px;
            margin-bottom: 6px;
            border-radius: 4px;
        }
        .customer-title { font-size: 10px; font-weight: 600; margin-bottom: 3px; color: var(--brand-1); }
        .customer-info { font-size: 10.5px; font-weight: 600; display:flex; flex-wrap:wrap; gap:10px; }

        /* ITEMS TABLE */
        .items-table { width:100%; border-collapse: collapse; margin-bottom: 6px; font-size: 10px; }
        .items-table th {
            background: #1f2937; color:#fff; padding:4px; font-size:9px;
        }
        .items-table td { padding:4px; border-bottom:1px solid #f3f4f6; text-align:center; }
        .items-table td.description { text-align:left; font-weight:500; }
        .items-table tbody tr:nth-child(even) { background-color: var(--table-alt); }

        .col-sr{width:5%} .col-desc{width:34%} .col-batch{width:10%}
        .col-mrp{width:10%} .col-qty{width:7%} .col-rate{width:10%} .col-amt{width:12%}

        /* FOOTER PANELS */
        .invoice-footer { display:grid; grid-template-columns:1.3fr auto 1fr; gap:8px; margin-top:6px; align-items:start; }

        .terms-section { border:1px solid var(--border); padding:6px; border-radius:4px; font-size:9px; }
        .signature-section { display:flex; gap:4px; margin-top:4px; }
        .signature-box { flex:1; border:1px solid #d1d5db; font-size:9px; padding:4px; text-align:center; border-radius:3px; }

        .qr-section img { width:60px; height:60px; border:1px solid var(--brand-1); border-radius:4px; padding:2px; background:#fff; }

        .summary-section { border:1px solid var(--border); border-radius:4px; overflow:hidden; }
        .summary-table { width:100%; border-collapse:collapse; font-size:9.5px; }
        .summary-table td { padding:4px 6px; border-bottom:1px solid #f3f4f6; }
        .summary-table td:first-child{color:var(--muted);font-weight:500}
        .summary-table td:last-child{text-align:right;font-weight:700;color:#111}

        .company-footer { text-align:center; font-size:8px; color:var(--muted); margin-top:6px; border-top:1px solid var(--border); padding-top:4px; }

        /* PRINT */
        @page { size: A5 landscape; margin:5mm; }
        @media print {
            body { padding:0; background:#fff; margin:0; }
            .invoice-container { box-shadow:none; border-radius:0; max-width:none; width:100%; margin:0; }
            .action-buttons { display:none !important; }
        }

        /* ACTION BUTTONS */
        .action-buttons { display:flex; justify-content:center; gap:8px; margin-top:8px; }
        .btn { font-size:11px; padding:6px 10px; border-radius:4px; cursor:pointer; border:none; font-weight:600; }
        .btn-primary{background:linear-gradient(135deg,var(--brand-1),var(--brand-2));color:#fff}
        .btn-secondary{background:#e5e7eb;color:#374151}
        .btn-success{background:linear-gradient(135deg,#059669,#10b981);color:#fff}
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">
<div class="invoice-container" id="invoiceRoot">
    <div class="invoice-content">

        <!-- HEADER -->
        <div class="invoice-header">
            <div class="invoice-meta">
                <div><strong>#${invoiceNo}</strong></div>
                <div><i class="fas fa-calendar"></i> ${date}</div>
            </div>
            <div class="shop-name">${ownerInfo.shopName}</div>
            <div class="shop-details">
                ${ownerInfo.address} | ${ownerInfo.ownerName} | ${ownerInfo.mobNumber}<br>
                LC: ${ownerInfo.lcNo} | GST: ${ownerInfo.gstNumber}
            </div>
        </div>

        <!-- CUSTOMER -->
        <div class="customer-section">
            <div class="customer-title"><i class="fas fa-user-circle"></i> Bill To</div>
            <div class="customer-info">
                <span><i class="fas fa-user"></i> ${profile.custName}</span>
                <span><i class="fas fa-phone"></i> ${profile.phoneNo}</span>
                <span><i class="fas fa-map-marker-alt"></i> ${profile.address}</span>
            </div>
        </div>

        <!-- ITEMS -->
        <table class="items-table">
            <thead>
            <tr>
                <th class="col-sr">Sr</th>
                <th class="col-desc">Description</th>
                <th class="col-batch">Batch</th>
                <th class="col-mrp">MRP</th>
                <th class="col-qty">Qty</th>
                <th class="col-rate">Rate</th>
                <th class="col-amt">Amount</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${items}" var="item" varStatus="status">
                <c:if test="${status.index < 10}"> <!-- Only 10 rows per page -->
                <tr>
                    <td>${item.itemNo}</td>
                    <td class="description">${item.description}</td>
                    <td>${item.batchNo}</td>
                    <td>₹<c:out value="${item.mrp}" default="0.00"/></td>
                    <td>${item.qty}</td>
                    <td>₹<c:out value="${item.rate}" default="0.00"/></td>
                    <td>₹<c:out value="${item.amount}" default="0.00"/></td>
                </tr>
                </c:if>
            </c:forEach>
            </tbody>
        </table>

        <!-- FOOTER -->
        <div class="invoice-footer">
            <div class="terms-section">
                <div><strong>Terms & Conditions</strong></div>
                <div>
                    1) Sold material will not be taken back.
                    2) Goods received in good condition.<br>
                    3) Agriculture use only. Highly poisonous.
                    4) Payment due within 30 days.
                </div>
                <div class="signature-section">
                    <div class="signature-box">Customer</div>
                    <div class="signature-box">For ${ownerInfo.shopName}</div>
                </div>
            </div>

            <div class="qr-section">
                <img src="data:image/png;base64,${QRCODE}" alt="QR Code"/>
            </div>

            <div class="summary-section">
                <table class="summary-table" style="width:100%; border-collapse: collapse;">
                    <tr>
                        <!-- Left Side -->
                        <td style="vertical-align: top; padding-right: 15px; width: 50%;">
                            <table style="width:100%;">
                                <tr>
                                    <td>Sub Total</td>
                                    <td>₹ <c:out value="${totalAmout}" default="0.00"/></td>
                                </tr>
                                <tr>
                                    <td>Paid</td>
                                    <td>₹ <c:out value="${advamount}" default="0.00"/></td>
                                </tr>
                                <tr>
                                    <td><strong>Net Total</strong></td>
                                    <td><strong>₹ ${totalAmout - advamount}</strong></td>
                                </tr>
                            </table>
                        </td>

                        <!-- Right Side -->
                        <td style="vertical-align: top; width: 50%;">
                            <table style="width:100%;">
                                <tr>
                                    <td>GST</td>
                                    <td>₹ <c:out value="${currentinvoiceitems.tax}" default="0.00"/></td>
                                </tr>
                                <tr>
                                    <td>Prev Bal</td>
                                    <td>₹ <c:out value="${currentinvoiceitems.preBalanceAmt}" default="0.00"/></td>
                                </tr>
                                <tr>
                                    <td><strong>Curr Bal</strong></td>
                                    <td><strong>₹ <c:out value="${profile.currentOusting}" default="0.00"/></strong></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>

        </div>

        <div class="company-footer">
            Generated by <strong>MyBillBook Solution</strong> • Ph: 8180080378
        </div>
    </div>
</div>

<!-- ACTIONS -->
<div class="action-buttons">
    <button class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/login/home'">Home</button>
    <button class="btn btn-primary" onclick="downloadPDF(event)">Download PDF</button>
    <a href="https://wa.me/${profile.phoneNo}/?text=Hello%20${profile.custName},%20your%20invoice%20is%20ready."
       target="_blank" class="btn btn-success">Share on WhatsApp</a>
</div>
</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
function downloadPDF(event) {
    const element = document.querySelector('.invoice-container');
    element.style.backgroundColor = '#ffffff';

    const opt = {
        margin: [5, 5, 5, 5],
        filename: `Invoice-${document.querySelector('.invoice-meta strong').textContent}.pdf`,
        image: { type: 'jpeg', quality: 0.85 },
        html2canvas: {
            scale: 2,   // reduce scaling so content fits
            backgroundColor: '#ffffff',
            useCORS: true,
            scrollX: 0,
            scrollY: 0
        },
        jsPDF: { unit: 'mm', format: 'a5', orientation: 'landscape' },
        pagebreak: { mode: 'avoid' }  // prevent splitting into two pages
    };

    const btn = event.target;
    const original = btn.innerHTML;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating PDF...';
    btn.disabled = true;

    html2pdf().set(opt).from(element).save().then(() => {
        btn.innerHTML = original;
        btn.disabled = false;
    }).catch(() => {
        btn.innerHTML = original;
        btn.disabled = false;
        alert('Error generating PDF.');
    });
}

</script>
</body>
</html>
