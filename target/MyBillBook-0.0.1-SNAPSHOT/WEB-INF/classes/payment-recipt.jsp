<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Receipt #${receiptNo} – ${profile.custName}</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" />
<style>
  body {
    font-family: 'Segoe UI', sans-serif;
    background: #f5f7fa;
    padding: 14px;
    color: #333;
    font-size: 11px;
  }
  .receipt {
    max-width: 820px;
    margin: auto;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 20px 24px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    position: relative;
  }
  /* Watermark */
  .receipt::before {
    content: "${ownerInfo.shopName}";
    position: absolute;
    top: 40%;
    left: 50%;
    transform: translate(-50%, -50%) rotate(-20deg);
    font-size: 3rem;
    color: rgba(0,0,0,0.06);
    white-space: nowrap;
    pointer-events: none;
  }
  .header {
    text-align: center;
    border-bottom: 2px solid #1976d2;
    padding-bottom: 10px;
    margin-bottom: 14px;
  }
  .company-info h2 {
    font-size: 1.4rem;
    color: #1976d2;
    margin: 0;
    font-weight: bold;
  }
  .company-info small {
    font-size: 0.75rem;
    color: #555;
    display: block;
    margin-top: 2px;
  }
  .receipt-title {
    margin-top: 6px;
    font-weight: bold;
    font-size: 1.2rem;
    color: #111;
    text-transform: uppercase;
  }
  .receipt-meta {
    font-size: 0.8rem;
    margin-top: 6px;
    color: #444;
  }
  .field {
    margin: 8px 0;
    font-size: 0.8rem;
  }
  .field label {
    font-weight: bold;
    display: inline-block;
    min-width: 100px;
    color: #222;
  }
  .highlight-amount {
    font-size: 1rem;
    font-weight: bold;
    color: #2e7d32;
  }
  table.amount-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
    font-size: 0.8rem;
  }
  table.amount-table td {
    border: 1px solid #ccc;
    padding: 6px 8px;
  }
  table.amount-table tr:nth-child(even) td:first-child {
    background: #e3f2fd;
  }
  table.amount-table td:first-child {
    font-weight: bold;
    color: #1976d2;
  }
  .sign-row {
    display: flex;
    gap: 8px;
    margin-top: 14px;
  }
  .sign-box {
    flex: 1;
    border: 1px dashed #aaa;
    padding: 6px;
    text-align: center;
    font-size: 0.7rem;
    border-radius: 4px;
    height: 50px;
    display: flex;
    align-items: flex-end;
    justify-content: center;
  }
  .footer {
    margin-top: 14px;
    font-size: 0.75rem;
    text-align: center;
    color: #666;
  }
  .btns {
    margin-top: 16px;
    gap: 8px;
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
  }
  .btn {
    font-size: 11px;
    padding: 5px 12px;
    border-radius: 16px;
    cursor: pointer;
    border: none;
    background: #1976d2;
    color: #fff;
    transition: background 0.2s ease-in-out;
  }
  .btn:hover { background: #0d47a1; }
  .btn.whatsapp { background: #25D366; }
  .btn.whatsapp:hover { background: #1da851; }
  @media print {
    body { background: #fff; padding: 0; }
    .hidden-print { display: none !important; }
    .receipt { box-shadow: none; border: none; }
    .receipt::before { display: none; } /* Hide watermark in print */
  }
</style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">
<div class="receipt">

  <!-- Header -->
  <div class="header">
    <div class="company-info">
      <h2>${ownerInfo.shopName}</h2>
      <small>
        ${ownerInfo.address} | ${ownerInfo.ownerName} | ${ownerInfo.mobNumber} | ${ownerInfo.email}
      </small>
    </div>
    <div class="receipt-title">Payment Receipt</div>
    <div class="receipt-meta">
      <strong>Receipt No:</strong> ${balanceDeposite.id} &nbsp; | &nbsp;
      <strong>Date:</strong> ${balanceDeposite.createdAt}
    </div>
  </div>

  <!-- Fields -->
  <div class="field">
    <label>Received From</label>
    <span>${profile.custName}</span> (Mob: ${profile.phoneNo})
  </div>
  <div class="field">
    <label>Received Amount</label>
    <span class="highlight-amount">₹ ${balanceDeposite.advAmt}</span>
    <small>(${AMOUNT_WORD} Only)</small>
  </div>
  <div class="field">
    <label>Purpose</label>
    <span>${balanceDeposite.description}</span>
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
    <tr>
      <td>Current Balance Due</td>
      <td style="text-align:right;">₹ ${profile.currentOusting}</td>
    </tr>
    <tr>
      <td>Payment Mode</td>
      <td style="text-align:right;">${balanceDeposite.modeOfPayment}</td>
    </tr>
  </table>

  <!-- Signature Boxes -->
  <div class="sign-row">
    <div class="sign-box">Customer Signature</div>
    <div class="sign-box">For ${ownerInfo.shopName}</div>
  </div>

  <!-- Footer -->
  <div class="footer">
    Generated by <strong>MyBillBook Solution</strong> • Contact: 8180080378 <br/>
    <em>Thank you for your payment!</em>
  </div>
</div>

<!-- Buttons -->
<center>
<div class="btns hidden-print">
  <button class="btn" onclick="location.href='${pageContext.request.contextPath}/login/home'"><i class="fa fa-home"></i> Home</button>
  <button class="btn" onclick="downloadPDF()"><i class="fa fa-file-pdf-o"></i> PDF</button>
  <a href="https://wa.me/${profile.phoneNo}/?text=Namaste!!!%20*${profile.custName}*,%20तुमचे%20पेमेंट%20रिसीप्ट%20तयार%20आहे.%20रक्कम:%20₹${amountReceived},%20बाकी:%20₹${balanceDue},%20तारीख:%20${date}" target="_blank" class="btn whatsapp">
    <i class="fa fa-whatsapp"></i> WhatsApp
  </a>
</div>
</center>
</c:if>

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>
  function downloadPDF(){
    html2pdf().set({
      margin: 0.2,
      filename: '${profile.custName}_PaymentReceipt_${receiptNo}.pdf',
      image: {type: 'jpeg', quality: 1},
      html2canvas: {scale: 2},
      jsPDF: {unit: 'mm', format: 'a4', orientation: 'portrait'}
    }).from(document.querySelector('.receipt')).save();
  }

  // Auto print
  window.onload = function() { window.print(); };
</script>
</body>
</html>
