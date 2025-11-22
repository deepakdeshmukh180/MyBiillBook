<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase Invoice - ${purchase.purchaseNo}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background: #f5f5f5;
            padding: 20px;
        }

        .invoice-container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        .invoice-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 3px solid #0d6efd;
        }

        .company-info h1 {
            color: #0d6efd;
            font-size: 28px;
            margin-bottom: 5px;
        }

        .company-info p {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }

        .invoice-meta {
            text-align: right;
        }

        .invoice-meta h2 {
            color: #333;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .invoice-meta p {
            color: #666;
            font-size: 14px;
            margin: 5px 0;
        }

        .parties-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }

        .party-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #0d6efd;
        }

        .party-box h3 {
            color: #0d6efd;
            font-size: 16px;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .party-box p {
            color: #333;
            font-size: 14px;
            margin: 8px 0;
            line-height: 1.6;
        }

        .party-box strong {
            color: #000;
            display: inline-block;
            width: 120px;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .items-table thead {
            background: #0d6efd;
            color: white;
        }

        .items-table th {
            padding: 12px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .items-table th.text-center {
            text-align: center;
        }

        .items-table th.text-end {
            text-align: right;
        }

        .items-table tbody tr {
            border-bottom: 1px solid #e0e0e0;
        }

        .items-table tbody tr:hover {
            background: #f8f9fa;
        }

        .items-table td {
            padding: 12px;
            font-size: 14px;
            color: #333;
        }

        .items-table td.text-center {
            text-align: center;
        }

        .items-table td.text-end {
            text-align: right;
        }

        .summary-section {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 40px;
        }

        .summary-box {
            width: 350px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
            font-size: 14px;
        }

        .summary-row.total {
            border-top: 2px solid #0d6efd;
            border-bottom: 2px solid #0d6efd;
            margin-top: 10px;
            padding-top: 15px;
            font-size: 18px;
            font-weight: 700;
            color: #0d6efd;
        }

        .payment-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #198754;
            margin-bottom: 30px;
        }

        .payment-info h4 {
            color: #198754;
            font-size: 14px;
            margin-bottom: 15px;
            text-transform: uppercase;
        }

        .payment-info p {
            color: #333;
            font-size: 13px;
            line-height: 1.8;
        }

        .payment-info strong {
            display: inline-block;
            width: 120px;
            color: #000;
        }

        .notes-section {
            background: #fff9e6;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #ffc107;
            margin-bottom: 30px;
        }

        .notes-section h4 {
            color: #856404;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .notes-section p {
            color: #856404;
            font-size: 13px;
            line-height: 1.6;
        }

        .footer-section {
            margin-top: 60px;
            padding-top: 20px;
            border-top: 2px solid #e0e0e0;
        }

        .signature-box {
            display: flex;
            justify-content: space-between;
            margin-top: 60px;
        }

        .signature {
            text-align: center;
            width: 200px;
        }

        .signature-line {
            border-top: 2px solid #333;
            margin-top: 60px;
            padding-top: 10px;
            font-size: 14px;
            font-weight: 600;
            color: #333;
        }

        .print-button {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #0d6efd;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(13,110,253,0.3);
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .print-button:hover {
            background: #0a58ca;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(13,110,253,0.4);
        }

        @media print {
            body {
                background: white;
                padding: 0;
            }

            .invoice-container {
                box-shadow: none;
                padding: 20px;
            }

            .print-button {
                display: none;
            }

            .party-box,
            .summary-box,
            .notes-section,
            .payment-info {
                break-inside: avoid;
            }
        }
    </style>
</head>
<body>

<button class="print-button" onclick="window.print()">
    🖨️ Print Invoice
</button>

<div class="invoice-container">
    <!-- Invoice Header -->
    <div class="invoice-header">
        <div class="company-info">
            <h1>YOUR COMPANY NAME</h1>
            <p>
                Address Line 1, Address Line 2<br>
                City, State - PIN Code<br>
                Phone: +91-XXXXXXXXXX<br>
                Email: info@yourcompany.com<br>
                GSTIN: XXXXXXXXXXXX
            </p>
        </div>
        <div class="invoice-meta">
            <h2>PURCHASE INVOICE</h2>
            <p><strong>Invoice No:</strong> ${purchase.purchaseNo}</p>
          <p><strong>Invoice Date:</strong> ${purchase.invoiceDate}</p>
            <p><strong>Dealer Invoice:</strong> ${purchase.dealerInvoiceNo}</p>
        </div>
    </div>

    <!-- Parties Section -->
    <div class="parties-section">
        <div class="party-box">
            <h3>Purchased From</h3>
            <p><strong>Dealer Name:</strong> ${dealer.dealerName}</p>
            <p><strong>Mobile:</strong> ${dealer.mobileNo}</p>
            <p><strong>Address:</strong> ${dealer.dealerAddress}</p>
            <c:if test="${not empty dealer.gstNo}">
                <p><strong>GST No:</strong> ${dealer.gstNo}</p>
            </c:if>
        </div>
        <div class="party-box">
            <h3>Purchased By</h3>
            <p><strong>Company:</strong> YOUR COMPANY NAME</p>
            <p><strong>Address:</strong> Your Full Address</p>
            <p><strong>GST No:</strong> Your GST Number</p>
        </div>
    </div>

    <!-- Items Table -->
    <table class="items-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Product Name</th>
                <th>Batch No</th>
                <th class="text-center">Qty</th>
                <th class="text-end">Rate</th>
                <th class="text-end">GST %</th>
                <th class="text-end">GST Amt</th>
                <th class="text-end">Total</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${items}" var="item" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td><strong>${item.productName}</strong></td>
                    <td>${item.batchNo}</td>
                    <td class="text-center">${item.quantity}</td>
                    <td class="text-end">₹<fmt:formatNumber value="${item.rate}" pattern="#,##0.00"/></td>
                    <td class="text-end"><fmt:formatNumber value="${item.gstPercent}" pattern="#,##0.00"/>%</td>
                    <td class="text-end">₹<fmt:formatNumber value="${item.gstAmount}" pattern="#,##0.00"/></td>
                    <td class="text-end">₹<fmt:formatNumber value="${item.totalAmount}" pattern="#,##0.00"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Summary Section -->
    <div class="summary-section">
        <div class="summary-box">
            <div class="summary-row">
                <span>Total Items:</span>
                <span><strong>${purchase.totalItems}</strong></span>
            </div>
            <div class="summary-row">
                <span>Subtotal:</span>
                <span>₹<fmt:formatNumber value="${purchase.totalAmount - purchase.totalGst}" pattern="#,##0.00"/></span>
            </div>
            <div class="summary-row">
                <span>Total GST:</span>
                <span>₹<fmt:formatNumber value="${purchase.totalGst}" pattern="#,##0.00"/></span>
            </div>
            <div class="summary-row total">
                <span>Grand Total:</span>
                <span>₹<fmt:formatNumber value="${purchase.totalAmount}" pattern="#,##0.00"/></span>
            </div>
        </div>
    </div>

    <!-- Payment Information -->
    <div class="payment-info">
        <h4>💳 Payment Information</h4>
        <p><strong>Total Amount:</strong> ₹<fmt:formatNumber value="${dealer.totalAmount}" pattern="#,##0.00"/></p>
        <p><strong>Paid Amount:</strong> ₹<fmt:formatNumber value="${dealer.paidAmount}" pattern="#,##0.00"/></p>
        <p><strong>Balance Due:</strong> ₹<fmt:formatNumber value="${dealer.balanceAmount}" pattern="#,##0.00"/></p>
        <hr style="margin: 15px 0; border: none; border-top: 1px solid #dee2e6;">
        <p><strong>Bank Name:</strong> ${dealer.bankName}</p>
        <p><strong>Account No:</strong> ${dealer.accountNo}</p>
        <p><strong>IFSC Code:</strong> ${dealer.ifscCode}</p>
        <p><strong>Branch:</strong> ${dealer.branchName}</p>
    </div>

    <!-- Notes Section -->
    <c:if test="${not empty purchase.notes}">
        <div class="notes-section">
            <h4>📝 Notes</h4>
            <p>${purchase.notes}</p>
        </div>
    </c:if>

    <!-- Terms & Conditions -->
    <div class="notes-section" style="background: #e8f4f8; border-left-color: #0dcaf0;">
        <h4 style="color: #055160;">Terms & Conditions</h4>
        <p style="color: #055160;">
            1. All goods once sold will not be taken back or exchanged.<br>
            2. Interest @ 18% p.a. will be charged if payment is not made within due date.<br>
            3. All disputes subject to jurisdiction of local courts only.<br>
            4. Please check all items before accepting delivery.
        </p>
    </div>

    <!-- Signature Section -->
    <div class="footer-section">
        <div class="signature-box">
            <div class="signature">
                <div class="signature-line">Dealer's Signature</div>
            </div>
            <div class="signature">
                <div class="signature-line">Authorized Signatory</div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid #e0e0e0; color: #999; font-size: 12px;">
        <p>This is a computer-generated invoice and does not require a signature.</p>
        <p>Thank you for your business!</p>
    </div>
</div>

<script>
// Auto-print functionality (optional)
// Uncomment the line below if you want to auto-print when page loads
// window.onload = function() { window.print(); }
</script>

</body>
</html>