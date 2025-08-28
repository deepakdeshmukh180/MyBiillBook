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
    padding: 10px;
    color: #333;
    font-size: 10px;
    line-height: 1.2;
  }
  .invoice {
    max-width: 700px;
    margin: auto;
    background: #fff;
    border: solid 1px #ccc;
    border-radius: 6px;
    box-shadow: 0 1px 6px rgba(0,0,0,0.05);
    padding: 10px;
    position: relative;
    overflow: hidden;
  }
  /* ===== Watermark ===== */
  .invoice::before {
    content: "${ownerInfo.shopName}";
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotate(-30deg);
    font-size: 4rem;
    color: rgba(0, 0, 0, 0.08);
    white-space: nowrap;
    pointer-events: none;
    z-index: 0;
  }
  .invoice * {
    position: relative;
    z-index: 1;
  }

  .header { text-align: center; margin-bottom: 8px; }
  .header h2 { font-size: 1.2rem; color: #3f51b5; margin: 2px 0; }
  .header small { font-size: 0.7rem; color: #666; line-height: 1.2; display: block; }

  table { width: 100%; border-collapse: collapse; }
  .info-table td { padding: 3px 4px; vertical-align: top; font-size: 9px; }
  .items-table th, .items-table td {
    border: 1px solid #ccc; padding: 3px 4px; text-align: center; font-size: 9px;
  }
  .items-table th { background: #3f51b5; color: #fff; }
  .items-table td.description { text-align: left; }

  .merged-block { display: flex; gap: 6px; align-items: flex-start; margin-top: 6px; }
  .merged-left { flex: 1; border: 1px solid #ccc; border-radius: 4px; padding: 4px; background: #fbfbfb; font-size: 9px; line-height: 1.2; }
  .terms-title { font-weight: bold; font-size: 9px; margin-bottom: 2px; }
  .sign-row { display: flex; gap: 4px; margin-top: 4px; }
  .sign-box { flex: 1; border: 1px solid #ccc; padding: 3px; text-align: center; font-size: 8px; border-radius: 3px; }

  .merged-center { flex: 0 0 90px; display: flex; align-items: center; justify-content: center; border: 1px solid #ccc; border-radius: 4px; padding: 4px; background: #fff; }
  .qr-wrap img { max-width: 80px; max-height: 80px; }

  .merged-right { flex: 0 0 180px; border: 1px solid #ccc; border-radius: 4px; padding: 4px; background: #fff; font-size: 9px; line-height: 1.2; }
  .summary-row td { padding: 2px 4px; }
  .highlight { background: #fff8e1; font-weight: bold; border-left: 3px solid #ff8f00; }
  .current-balance { background: #e3f2fd; font-weight: bold; border-left: 3px solid #1976d2; }

  .vertical-footer { font-size: 9px; padding: 2px 4px; margin-top: 6px; text-align: center; }
  .btns { margin-top: 8px; gap: 4px; }
  .btn { font-size: 10px; padding: 4px 8px; border-radius: 20px; cursor: pointer; }

  /* Hide buttons in print */
  @media print {
    .hidden-print { display: none !important; }
  }
</style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">
<div class="invoice">

  <!-- Header -->
  <div class="header">
    <div style="display:flex; justify-content:space-between; font-size:9px; margin-bottom:4px; color:#666;">
      <div><strong>Invoice No:</strong> #${invoiceNo}</div>
      <div><strong>Tax Invoice</strong></div>
      <div><strong>Date:</strong> ${date}</div>
    </div>
    <h2>${ownerInfo.shopName}</h2>
    <small>
      <i class="fa fa-map-marker"></i> ${ownerInfo.address} |
      <i class="fa fa-user"></i> ${ownerInfo.ownerName} |
      <i class="fa fa-phone"></i> ${ownerInfo.mobNumber} <br/>
      <i class="fa fa-id-card"></i><strong>LC No:</strong> ${ownerInfo.lcNo} |
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
        <th>SR</th><th>Description</th><th>Batch No.</th>
        <th style="text-align:right;">MRP (₹)</th>
        <th>Qty</th>
        <th style="text-align:right;">Rate (₹)</th>
        <th style="text-align:right;">Amount (₹)</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach items="${items}" var="item">
        <tr>
          <td>${item.itemNo}</td>
          <td class="description">${item.description}</td>
          <td>${item.batchNo}</td>
          <td style="text-align:right;">${item.mrp}</td>
          <td>${item.qty}</td>
          <td style="text-align:right;">${item.rate}</td>
          <td style="text-align:right;">${item.amount}</td>
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
        Sold items cannot be taken back or exchanged. Please check goods at delivery.
        Warranty subject to manufacturer's terms; payment terms as agreed.
      </div>
      <div class="sign-row">
        <div class="sign-box">Customer Sign</div>
        <div class="sign-box">For ${ownerInfo.shopName}</div>
      </div>
    </div>
    <!-- QR -->
    <div class="merged-center qr-wrap">
      <img src="data:image/png;base64,${QRCODE}" />
    </div>
    <!-- Invoice Summary -->
    <div class="merged-right">
      <table>
        <tr><td>Sub Total</td><td style="text-align:right;">₹ ${totalAmout}</td></tr>
        <tr><td>GST</td><td style="text-align:right;">₹ ${currentinvoiceitems.tax}</td></tr>
        <tr class="highlight"><td>Total Invoice</td><td style="text-align:right;">₹ ${totalAmout}</td></tr>
        <tr><td>Previous Balance</td><td style="text-align:right;">₹ ${currentinvoiceitems.preBalanceAmt}</td></tr>
        <tr><td>Paid</td><td style="text-align:right;">₹ ${advamount}</td></tr>
        <tr class="current-balance"><td>Current Balance</td><td style="text-align:right;">₹ ${profile.currentOusting}</td></tr>
      </table>
    </div>
  </div>

  <!-- Footer -->
  <div class="vertical-footer">
    Generated by <strong>MyBillBook Solution</strong> • Contact: 8180080378
  </div>
</div>

<!-- Buttons -->
<center>
<div class="btns hidden-print">
  <button class="btn" onclick="location.href='${pageContext.request.contextPath}/login/home'"><i class="fa fa-home"></i> Home</button>
  <button class="btn" onclick="downloadPDF()"><i class="fa fa-file-pdf-o"></i> Download PDF</button>
  <a href="https://wa.me/${profile.phoneNo}/?text=Namaste!!!%20*${profile.custName}*,%20%E0%A4%A4%E0%A5%81%E0%A4%AE%E0%A4%9A%E0%A5%87%20%E0%A4%87%E0%A4%A8%E0%A5%8D%E0%A4%B5%E0%A5%8D%E0%A4%B9%E0%A5%89%E0%A4%87%E0%A4%B8%20%E0%A4%A4%E0%A5%8D%E0%A4%AF%E0%A4%BE%E0%A4%B0%20%E0%A4%9D%E0%A4%BE%E0%A4%B2%E0%A5%87%20%E0%A4%86%E0%A4%B9%E0%A5%87.%20%E0%A4%95%E0%A5%83%E0%A4%AA%E0%A4%AF%E0%A4%BE%20%E0%A4%A4%E0%A4%AA%E0%A4%B6%E0%A5%80%E0%A4%B2%20%E0%A4%AA%E0%A4%B9%E0%A4%BE..." target="_blank" class="btn btn-success">
    <i class="fa fa-whatsapp"></i> WhatsApp करा
  </a>
</div>
</center>
</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
// PDF download
  function downloadPDF(){
    html2pdf().set({
      margin: 0.2,
      filename: '${profile.custName}_Invoice_${invoiceNo}.pdf',
      image: {type: 'jpeg', quality: 1},
      html2canvas: {scale: 2},
      jsPDF: {unit: 'mm', format: 'a4', orientation: 'portrait'}
    }).from(document.querySelector('.invoice')).save();
  }

  // Auto print on page load
  window.onload = function() {
    window.print();
  };
</script>
</body>
</html>
