<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Invoice #${invoiceNo} – ${profile.custName}</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" />
<style>
  body {
    font-family: 'Segoe UI', sans-serif;
    background: #f7fafc;
    margin: 0;
    padding: 5mm;
    color: #333;
    font-size: 8px;
    line-height: 1.1;
  }

  /* A4 page container */
  .page-container {
    width: 210mm;
    min-height: 297mm;
    margin: 0 auto;
    background: white;
    display: flex;
    flex-direction: column;
    gap: 5mm;
    padding: 5mm;
    box-sizing: border-box;
  }

  /* Individual A5 invoice */
  .invoice {
    width: 100%;
    height: 140mm; /* A5 height minus margins */
    background: #fff;
    border: solid 1px #333;
    border-radius: 3px;
    padding: 3mm;
    position: relative;
    overflow: hidden;
    box-sizing: border-box;
    page-break-inside: avoid;
  }

  /* Duplicate invoice container */
  .invoice-duplicate {
    border-top: 2px dashed #999;
    margin-top: 3mm;
    padding-top: 3mm;
  }

  /* Watermark - smaller for A5 */
  .invoice::before {
    content: "${ownerInfo.shopName}";
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotate(-30deg);
    font-size: 2.5rem;
    color: rgba(0, 0, 0, 0.05);
    white-space: nowrap;
    pointer-events: none;
    z-index: 0;
  }

  .invoice * {
    position: relative;
    z-index: 1;
  }

  /* Header - compact for A5 */
  .header {
    text-align: center;
    margin-bottom: 2mm;
    border-bottom: 1px solid #ddd;
    padding-bottom: 2mm;
  }

  .header-top {
    display: flex;
    justify-content: space-between;
    font-size: 7px;
    margin-bottom: 1mm;
    color: #666;
    font-weight: bold;
  }

  .header h2 {
    font-size: 11px;
    color: #2c5282;
    margin: 1mm 0;
    font-weight: bold;
  }

  .header small {
    font-size: 6px;
    color: #555;
    line-height: 1.2;
    display: block;
  }

  /* Tables - compact */
  table {
    width: 100%;
    border-collapse: collapse;
    margin: 1mm 0;
  }

  .info-table td {
    padding: 1mm;
    vertical-align: top;
    font-size: 7px;
    border-bottom: 1px solid #eee;
  }

  .items-table th, .items-table td {
    border: 1px solid #ccc;
    padding: 1mm;
    text-align: center;
    font-size: 6px;
    line-height: 1.2;
  }

  .items-table th {
    background: #2c5282;
    color: #fff;
    font-weight: bold;
  }

  .items-table td.description {
    text-align: left;
    font-size: 6px;
  }

  /* Merged bottom section - redesigned for A5 */
  .merged-block {
    display: flex;
    gap: 2mm;
    margin-top: 2mm;
    font-size: 6px;
  }

  .merged-left {
    flex: 1.2;
    border: 1px solid #ccc;
    border-radius: 2px;
    padding: 2mm;
    background: #fbfbfb;
  }

  .terms-title {
    font-weight: bold;
    font-size: 7px;
    margin-bottom: 1mm;
    color: #2c5282;
  }

  .terms-text {
    font-size: 6px;
    line-height: 1.2;
    max-height: 8mm;
    overflow: hidden;
  }

  .sign-row {
    display: flex;
    gap: 1mm;
    margin-top: 2mm;
  }

  .sign-box {
    flex: 1;
    border: 1px solid #ccc;
    padding: 3mm 1mm;
    text-align: center;
    font-size: 6px;
    border-radius: 2px;
    background: white;
  }

  .merged-center {
    flex: 0 0 20mm;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px solid #ccc;
    border-radius: 2px;
    background: #fff;
  }

  .qr-wrap img {
    max-width: 18mm;
    max-height: 18mm;
  }

  .merged-right {
    flex: 0 0 35mm;
    border: 1px solid #ccc;
    border-radius: 2px;
    padding: 2mm;
    background: #fff;
  }

  .summary-row td {
    padding: 0.5mm;
    font-size: 6px;
    line-height: 1.3;
  }

  .highlight {
    background: #fff3cd;
    font-weight: bold;
    border-left: 2px solid #ff8f00;
  }

  .current-balance {
    background: #d1ecf1;
    font-weight: bold;
    border-left: 2px solid #1976d2;
  }

  /* Footer */
  .vertical-footer {
    font-size: 6px;
    padding: 1mm;
    margin-top: 2mm;
    text-align: center;
    border-top: 1px solid #eee;
    color: #666;
  }

  /* Buttons - only show on screen */
  .btns {
    margin: 5mm auto;
    display: flex;
    gap: 2mm;
    justify-content: center;
  }

  .btn {
    font-size: 9px;
    padding: 2mm 4mm;
    border: 1px solid #ccc;
    border-radius: 15px;
    cursor: pointer;
    background: white;
    text-decoration: none;
    color: #333;
    display: inline-flex;
    align-items: center;
    gap: 1mm;
  }

  .btn:hover {
    background: #f0f0f0;
  }

  .btn-success {
    background: #25d366;
    color: white;
    border-color: #25d366;
  }

  /* Print styles */
  @media print {
    body {
      background: white;
      padding: 0;
      margin: 0;
    }

    .page-container {
      width: 210mm;
      min-height: 297mm;
      padding: 5mm;
      margin: 0;
      box-shadow: none;
    }

    .hidden-print {
      display: none !important;
    }

    .invoice {
      border: solid 1px #000;
      break-inside: avoid;
    }

    .invoice-duplicate {
      border-top: 2px dashed #000;
    }

    /* Ensure proper page breaks */
    .page-container {
      page-break-after: always;
    }

    .page-container:last-child {
      page-break-after: auto;
    }
  }

  /* Screen-only styles */
  @media screen {
    .page-container {
      box-shadow: 0 0 10mm rgba(0,0,0,0.1);
      margin-bottom: 10mm;
    }
  }

  /* Responsive adjustments for smaller screens */
  @media screen and (max-width: 800px) {
    .page-container {
      width: 100%;
      padding: 2mm;
    }

    .merged-block {
      flex-direction: column;
    }

    .merged-right {
      flex: none;
    }
  }
</style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="page-container">
  <!-- First Invoice (Original) -->
  <div class="invoice">
    <!-- Header -->
    <div class="header">
      <div class="header-top">
        <div><strong>Invoice:</strong> #${invoiceNo}</div>
        <div><strong>TAX INVOICE</strong></div>
        <div><strong>Date:</strong> ${date}</div>
      </div>
      <h2>${ownerInfo.shopName}</h2>
      <small>
        <i class="fa fa-map-marker"></i> ${ownerInfo.address} |
        <i class="fa fa-user"></i> ${ownerInfo.ownerName} |
        <i class="fa fa-phone"></i> ${ownerInfo.mobNumber}<br/>
        <i class="fa fa-id-card"></i><strong>LC:</strong> ${ownerInfo.lcNo} |
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

    <!-- Items Table -->
    <table class="items-table">
      <thead>
        <tr>
          <th style="width:8%">SR</th>
          <th style="width:30%">Description</th>

          <c:if test="${invoiceColms.contains('BRAND')}">
            <th style="width:12%">Brand</th>
          </c:if>

          <c:if test="${invoiceColms.contains('BATCHNO')}">
            <th style="width:10%">Batch</th>
          </c:if>

          <c:if test="${invoiceColms.contains('EXPD')}">
            <th style="width:8%">Exp.</th>
          </c:if>

          <c:if test="${invoiceColms.contains('MRP')}">
            <th style="width:10%">MRP</th>
          </c:if>

          <th style="width:8%">Qty</th>
          <th style="width:12%">Rate</th>
          <th style="width:12%">Amount</th>
        </tr>
      </thead>

      <tbody>
        <c:forEach items="${items}" var="item">
          <tr>
            <td>${item.itemNo}</td>
            <td class="description">${item.description}</td>

            <c:if test="${invoiceColms.contains('BRAND')}">
              <td>${empty item.brand ? 'NA' : item.brand}</td>
            </c:if>

            <c:if test="${invoiceColms.contains('BATCHNO')}">
              <td>${item.batchNo}</td>
            </c:if>

            <c:if test="${invoiceColms.contains('EXPD')}">
              <td>${empty item.expDate ? 'NA' : item.expDate}</td>
            </c:if>

            <c:if test="${invoiceColms.contains('MRP')}">
              <td style="text-align:right;">₹${item.mrp}</td>
            </c:if>

            <td>${item.qty}</td>
            <td style="text-align:right;">₹${item.rate}</td>
            <td style="text-align:right;">₹${item.amount}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <!-- Merged Section -->
    <div class="merged-block">
      <!-- Terms & Conditions + Sign -->
      <div class="merged-left">
        <div class="terms-title">Terms &amp; Conditions</div>
        <div class="terms-text">
          ${ownerInfo.terms}
        </div>
        <div class="sign-row">
          <div class="sign-box">Customer Sign</div>
          <div class="sign-box">For ${ownerInfo.shopName}</div>
        </div>
      </div>

      <!-- QR Code -->
      <div class="merged-center qr-wrap">
        <img src="data:image/png;base64,${QRCODE}" alt="QR Code" />
      </div>

      <!-- Invoice Summary -->
      <div class="merged-right">
        <table>
          <tr class="summary-row"><td>Sub Total</td><td style="text-align:right;">₹${totalAmout}</td></tr>
          <tr class="summary-row"><td>Paid</td><td style="text-align:right;">₹${advamount}</td></tr>
          <tr class="summary-row highlight"><td>Net Total</td><td style="text-align:right;">₹${totalAmout-advamount}</td></tr>
          <tr class="summary-row"><td>GST</td><td style="text-align:right;">₹${currentinvoiceitems.tax}</td></tr>
          <tr class="summary-row"><td>Prev Balance</td><td style="text-align:right;">₹${currentinvoiceitems.preBalanceAmt}</td></tr>
          <tr class="summary-row current-balance"><td>Current Balance</td><td style="text-align:right;">₹${profile.currentOusting}</td></tr>
        </table>
      </div>
    </div>

    <!-- Footer -->
    <div class="vertical-footer">
      Generated by <strong>MyBillBook Solution</strong> • Contact: 8180080378
    </div>
  </div>

  <!-- Second Invoice (Duplicate Copy) -->
  <div class="invoice invoice-duplicate">
    <!-- Header -->
    <div class="header">
      <div class="header-top">
        <div><strong>Invoice:</strong> #${invoiceNo}</div>
        <div><strong>DUPLICATE COPY</strong></div>
        <div><strong>Date:</strong> ${date}</div>
      </div>
      <h2>${ownerInfo.shopName}</h2>
      <small>
        <i class="fa fa-map-marker"></i> ${ownerInfo.address} |
        <i class="fa fa-user"></i> ${ownerInfo.ownerName} |
        <i class="fa fa-phone"></i> ${ownerInfo.mobNumber}<br/>
        <i class="fa fa-id-card"></i><strong>LC:</strong> ${ownerInfo.lcNo} |
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

    <!-- Items Table -->
    <table class="items-table">
      <thead>
        <tr>
          <th style="width:8%">SR</th>
          <th style="width:30%">Description</th>

          <c:if test="${invoiceColms.contains('BRAND')}">
            <th style="width:12%">Brand</th>
          </c:if>

          <c:if test="${invoiceColms.contains('BATCHNO')}">
            <th style="width:10%">Batch</th>
          </c:if>

          <c:if test="${invoiceColms.contains('EXPD')}">
            <th style="width:8%">Exp.</th>
          </c:if>

          <c:if test="${invoiceColms.contains('MRP')}">
            <th style="width:10%">MRP</th>
          </c:if>

          <th style="width:8%">Qty</th>
          <th style="width:12%">Rate</th>
          <th style="width:12%">Amount</th>
        </tr>
      </thead>

      <tbody>
        <c:forEach items="${items}" var="item">
          <tr>
            <td>${item.itemNo}</td>
            <td class="description">${item.description}</td>

            <c:if test="${invoiceColms.contains('BRAND')}">
              <td>${empty item.brand ? 'NA' : item.brand}</td>
            </c:if>

            <c:if test="${invoiceColms.contains('BATCHNO')}">
              <td>${item.batchNo}</td>
            </c:if>

            <c:if test="${invoiceColms.contains('EXPD')}">
              <td>${empty item.expDate ? 'NA' : item.expDate}</td>
            </c:if>

            <c:if test="${invoiceColms.contains('MRP')}">
              <td style="text-align:right;">₹${item.mrp}</td>
            </c:if>

            <td>${item.qty}</td>
            <td style="text-align:right;">₹${item.rate}</td>
            <td style="text-align:right;">₹${item.amount}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <!-- Merged Section -->
    <div class="merged-block">
      <!-- Terms & Conditions + Sign -->
      <div class="merged-left">
        <div class="terms-title">Terms &amp; Conditions</div>
        <div class="terms-text">
          ${ownerInfo.terms}
        </div>
        <div class="sign-row">
          <div class="sign-box">Customer Sign</div>
          <div class="sign-box">For ${ownerInfo.shopName}</div>
        </div>
      </div>

      <!-- QR Code -->
      <div class="merged-center qr-wrap">
        <img src="data:image/png;base64,${QRCODE}" alt="QR Code" />
      </div>

      <!-- Invoice Summary -->
      <div class="merged-right">
        <table>
          <tr class="summary-row"><td>Sub Total</td><td style="text-align:right;">₹${totalAmout}</td></tr>
          <tr class="summary-row"><td>Paid</td><td style="text-align:right;">₹${advamount}</td></tr>
          <tr class="summary-row highlight"><td>Net Total</td><td style="text-align:right;">₹${totalAmout-advamount}</td></tr>
          <tr class="summary-row"><td>GST</td><td style="text-align:right;">₹${currentinvoiceitems.tax}</td></tr>
          <tr class="summary-row"><td>Prev Balance</td><td style="text-align:right;">₹${currentinvoiceitems.preBalanceAmt}</td></tr>
          <tr class="summary-row current-balance"><td>Current Balance</td><td style="text-align:right;">₹${profile.currentOusting}</td></tr>
        </table>
      </div>
    </div>

    <!-- Footer -->
    <div class="vertical-footer">
      Generated by <strong>MyBillBook Solution</strong> • Contact: 8180080378
    </div>
  </div>
</div>

<!-- Buttons -->
<div class="btns hidden-print">
  <button class="btn" onclick="location.href='${pageContext.request.contextPath}/login/home'">
    <i class="fa fa-home"></i> Home
  </button>
  <button class="btn" onclick="downloadPDF()">
    <i class="fa fa-file-pdf-o"></i> Download PDF
  </button>
  <a href="https://wa.me/${profile.phoneNo}/?text=Namaste!!!%20*${profile.custName}*,%20%E0%A4%A4%E0%A5%81%E0%A4%AE%E0%A4%9A%E0%A5%87%20%E0%A4%87%E0%A4%A8%E0%A5%8D%E0%A4%B5%E0%A5%8D%E0%A4%B9%E0%A5%89%E0%A4%87%E0%A4%B8%20%E0%A4%A4%E0%A5%8D%E0%A4%AF%E0%A4%BE%E0%A4%B0%20%E0%A4%9D%E0%A4%BE%E0%A4%B2%E0%A5%87%20%E0%A4%86%E0%A4%B9%E0%A5%87.%20%E0%A4%95%E0%A5%83%E0%A4%AA%E0%A4%AF%E0%A4%BE%20%E0%A4%A4%E0%A4%AA%E0%A4%B6%E0%A5%80%E0%A4%B2%20%E0%A4%AA%E0%A4%B9%E0%A4%BE..." target="_blank" class="btn btn-success">
    <i class="fa fa-whatsapp"></i> WhatsApp करा
  </a>
</div>

</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
// PDF download function
function downloadPDF(){
  const element = document.querySelector('.page-container');

  html2pdf().set({
    margin: [5, 5, 5, 5], // 5mm margins
    filename: '${profile.custName}_Invoice_${invoiceNo}_A5.pdf',
    image: {type: 'jpeg', quality: 0.98},
    html2canvas: {
      scale: 2,
      useCORS: true,
      letterRendering: true
    },
    jsPDF: {
      unit: 'mm',
      format: 'a4',
      orientation: 'portrait'
    }
  }).from(element).save();
}

// Auto print on page load
window.addEventListener('load', function() {
  // Small delay to ensure fonts and images are loaded
  setTimeout(function() {
    window.print();
  }, 500);
});

// Print-specific styling
window.addEventListener('beforeprint', function() {
  document.body.style.background = 'white';
});

window.addEventListener('afterprint', function() {
  document.body.style.background = '#f7fafc';
});
</script>

</body>
</html>