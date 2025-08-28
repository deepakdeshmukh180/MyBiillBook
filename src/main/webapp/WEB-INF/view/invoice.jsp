<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>${invoiceNo} - ${profile.custName}</title>
    <meta name="viewport" content="width=384px, initial-scale=1">

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Optional: Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
      body {
        width: 384px;
        margin: auto;
        font-size: 12px;
        background-color: #fff;
        color: #000;
      }

      @media print {
        .no-print {
          display: none !important;
        }
        body {
          font-size: 10px;
          width: 384px;
        }
      }

      table th, table td {
        padding: 2px !important;
        font-size: 12px;
      }

      .text-small {
        font-size: 11px;
      }

      .invoice-border td, .invoice-border th {
        border: 1px solid #000;
      }
    </style>
  </head>
  <body>
    <c:if test="${pageContext.request.userPrincipal.name != null}">
      <div id="invoice" class="p-2">

        <!-- Header -->
        <div class="text-center mb-2">
                         <img src="data:image/jpeg;base64,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" alt="Logo" width="180" />

          <h5 class="mb-0">${ownerInfo.shopName}</h5>
          <small>${ownerInfo.address}</small><br>
          <small>Owner: ${ownerInfo.ownerName} | Mob: ${ownerInfo.mobNumber}</small><br>
          <small>L.No: ${ownerInfo.lcNo} | GST: ${ownerInfo.gstNumber}</small>
        </div>

        <!-- Invoice & Customer Info -->
        <div class="mb-2">
          <div class="d-flex justify-content-between">
            <span><strong>Invoice No:</strong> ${invoiceNo}</span>
            <span><strong>Date:</strong> ${date}</span>
          </div>
          <div class="mt-1">
            <div><strong>Customer:</strong> Mr. ${profile.custName}</div>
            <div><strong>Address:</strong> ${profile.address}</div>
            <div><strong>Mobile:</strong> ${profile.phoneNo}</div>
          </div>
        </div>

        <!-- Item Table -->
        <table class="table table-sm table-bordered invoice-border">
          <thead class="table-light">
            <tr>
              <th>SR</th>
              <th>Desc</th>
              <th>B.No</th>
              <th>Qty</th>
              <th class="text-end">MRP</th>
              <th class="text-end">Amt</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${items}" var="item">
              <tr>
                <td>${item.itemNo}</td>
                <td>${item.description}</td>
                <td>${item.batchNo}</td>
                <td>${item.qty}</td>
                <td class="text-end">&#8377;${item.mrp}</td>
                <td class="text-end">&#8377;${item.amount}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>

        <!-- Summary -->
        <table class="table table-sm table-bordered invoice-border mt-2">
          <tbody>
            <tr>
              <th>Total (Pre-Tax)</th>
              <td class="text-end">&#8377;${currentinvoiceitems.preTaxAmt}</td>
            </tr>
            <tr>
              <th>GST (SGST + CGST)</th>
              <td class="text-end">&#8377;${currentinvoiceitems.tax}</td>
            </tr>
            <tr>
              <th>Total Invoice</th>
              <td class="text-end fw-bold">&#8377;${totalAmout}</td>
            </tr>
            <tr>
              <th>Advance</th>
              <td class="text-end">&#8377;${advamount}</td>
            </tr>
            <tr>
              <th>Previous Balance</th>
              <td class="text-end">&#8377;${currentinvoiceitems.preBalanceAmt}</td>
            </tr>
            <tr>
              <th>Current Balance</th>
              <td class="text-end text-danger">&#8377;${profile.currentOusting}</td>
            </tr>
          </tbody>
        </table>

        <!-- Buttons -->
        <div class="text-center mt-3 no-print">
          <a href="${pageContext.request.contextPath}/login/home" class="btn btn-success btn-sm">
            <i class="fa fa-home"></i> Home
          </a>
          <button class="btn btn-primary btn-sm" onclick="downloadPDF()">
            <i class="fa fa-file-pdf"></i> Download
          </button>
          <a class="btn btn-warning btn-sm"
             target="_blank"
             <a
               href="https://wa.me/${profile.phoneNo}/?text=Namaste!!!%20*${profile.custName}*,%20%E0%A4%A4%E0%A5%81%E0%A4%AE%E0%A4%9A%E0%A5%87%20%E0%A4%87%E0%A4%A8%E0%A5%8D%E0%A4%B5%E0%A5%8D%E0%A4%B9%E0%A5%89%E0%A4%87%E0%A4%B8%20%E0%A4%A4%E0%A5%8D%E0%A4%AF%E0%A4%BE%E0%A4%B0%20%E0%A4%9D%E0%A4%BE%E0%A4%B2%E0%A5%87%20%E0%A4%86%E0%A4%B9%E0%A5%87.%20%E0%A4%95%E0%A5%83%E0%A4%AA%E0%A4%AF%E0%A4%BE%20%E0%A4%A4%E0%A4%AA%E0%A4%B6%E0%A5%80%E0%A4%B2%20%E0%A4%AA%E0%A4%B9%E0%A4%BE%3A%0A*%E0%A4%87%E0%A4%A8%E0%A5%8D%E0%A4%B5%E0%A5%8D%E0%A4%B9%E0%A5%89%E0%A4%87%E0%A4%B8%20%E0%A4%95%E0%A5%8D%E0%A4%B0%E0%A4%AE%E0%A4%BE%E0%A4%82%E0%A4%95:*%20${invoiceNo}%0A*%E0%A4%B0%E0%A4%95%E0%A5%8D%E0%A4%95%E0%A4%AE:*%20${totalAmout}%0A*%E0%A4%AC%E0%A4%BE%E0%A4%95%E0%A5%80:*%20${profile.currentOusting}%0A*%E0%A4%A4%E0%A4%BE%E0%A4%B0%E0%A5%80%E0%A4%96:*%20${date}.%0A%E0%A4%A7%E0%A4%A8%E0%A5%8D%E0%A4%AF%E0%A4%B5%E0%A4%BE%E0%A4%A6!%20-%20*${ownerInfo.shopName}*%20${ownerInfo.ownerName}(${ownerInfo.mobNumber})"
               target="_blank"
               class="btn btn-success"
             >
               <i class="bi bi-whatsapp"></i> WhatsApp करा
             </a>

          </a>
        </div>
      </div>
    </c:if>

    <!-- PDF Script -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <script>
      function downloadPDF() {
        const element = document.getElementById('invoice');
        const opt = {
          margin: 0.1,
          filename: '${profile.custName}_${invoiceNo}.pdf',
          image: { type: 'jpeg', quality: 1.0 },
          html2canvas: { scale: 3 },
          jsPDF: { unit: 'in', format: [4, 11], orientation: 'portrait' }
        };
        html2pdf().set(opt).from(element).save();
      }
    </script>
  </body>
</html>
