<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thermal Invoice #${invoiceNo} – ${profile.custName}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Courier New', Courier, monospace;
            background: #f5f5f5;
            margin: 0;
            padding: 10px;
            color: #000;
            font-size: 11px;
            line-height: 1.2;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        /* 4×6 Thermal Paper Container */
        .thermal-container {
            width: 101.6mm;
            max-width: 101.6mm;
            min-height: 152.4mm;
            margin: 0 auto;
            background: white;
            border: 2px solid #000;
            overflow: hidden;
            position: relative;
        }

        .thermal-invoice {
            width: 100%;
            padding: 3mm;
            background: white;
            box-sizing: border-box;
        }

        /* Header Section - Optimized for B&W */
        .thermal-header {
            text-align: center;
            border-bottom: 3px double #000;
            padding-bottom: 2mm;
            margin-bottom: 2mm;
        }

        .shop-name {
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 1mm;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: 2px solid #000;
            padding: 1mm 2mm;
            background: #000;
            color: #fff;
        }

        .shop-details {
            font-size: 8px;
            line-height: 1.3;
            margin: 2mm 0;
            border-top: 1px solid #000;
            border-bottom: 1px solid #000;
            padding: 1mm 0;
        }

        .shop-details div {
            margin-bottom: 0.5mm;
        }

        .invoice-title {
            font-size: 12px;
            font-weight: bold;
            margin: 2mm 0;
            padding: 1mm 3mm;
            background: #000;
            color: #fff;
            border: 2px solid #000;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .invoice-meta {
            font-size: 8px;
            display: flex;
            justify-content: space-between;
            margin: 1mm 0;
            font-weight: bold;
            border: 1px solid #000;
            padding: 1mm;
            background: #f0f0f0;
        }

        /* QR Code - B&W Optimized */
        .qr-code {
            position: absolute;
            top: 3mm;
            right: 3mm;
            width: 15mm;
            height: 15mm;
            border: 2px solid #000;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
        }

        .qr-code img {
            max-width: 13mm;
            max-height: 13mm;
        }

        /* Customer Section - B&W */
        .customer-section {
            border: 2px solid #000;
            padding: 2mm;
            margin-bottom: 2mm;
            font-size: 8px;
            background: white;
        }

        .customer-title {
            font-size: 9px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 1mm;
            text-transform: uppercase;
            border-bottom: 1px solid #000;
            padding-bottom: 1mm;
            background: #000;
            color: #fff;
            padding: 1mm;
        }

        .customer-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.8mm;
            border-bottom: 1px dotted #000;
            padding-bottom: 0.5mm;
        }

        .customer-row:last-child {
            border-bottom: none;
        }

        .customer-label {
            font-weight: bold;
            min-width: 20mm;
        }

        .customer-value {
            text-align: right;
            flex: 1;
            word-break: break-word;
        }

        /* Items Section - B&W Thermal */
        .items-section {
            margin-bottom: 2mm;
            border: 2px solid #000;
        }

        .items-header {
            background: #000;
            color: #fff;
            padding: 1mm;
            font-size: 7px;
            font-weight: bold;
            display: grid;
            grid-template-columns: 8mm 1fr 12mm 16mm;
            gap: 1mm;
            text-align: center;
            text-transform: uppercase;
            border-bottom: 2px solid #000;
        }

        .items-header .desc-col {
            text-align: left;
        }

        .items-header .amt-col {
            text-align: right;
        }

        .item-row {
            padding: 1mm;
            font-size: 7px;
            display: grid;
            grid-template-columns: 8mm 1fr 12mm 16mm;
            gap: 1mm;
            border-bottom: 1px dashed #000;
            align-items: start;
            background: white;
        }

        .item-row:nth-child(even) {
            background: #f5f5f5;
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .item-sr {
            text-align: center;
            font-weight: bold;
            border: 1px solid #000;
            padding: 0.5mm 0;
        }

        .item-desc {
            text-align: left;
            word-break: break-word;
            line-height: 1.2;
            font-weight: bold;
        }

        .item-desc-details {
            font-size: 6px;
            margin-top: 0.5mm;
            line-height: 1.1;
            font-weight: normal;
            border-left: 2px solid #000;
            padding-left: 1mm;
            margin-left: 1mm;
        }

        .item-qty {
            text-align: center;
            font-weight: bold;
            border: 1px solid #000;
            padding: 0.5mm 0;
        }

        .item-amt {
            text-align: right;
            font-weight: bold;
            border: 1px solid #000;
            padding: 0.5mm 1mm;
        }

        /* Summary Section - B&W */
        .summary-section {
            border: 3px double #000;
            padding: 2mm;
            margin-bottom: 2mm;
            background: white;
        }

        .summary-title {
            text-align: center;
            font-size: 9px;
            font-weight: bold;
            margin-bottom: 1mm;
            text-transform: uppercase;
            border-bottom: 2px solid #000;
            padding-bottom: 1mm;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            font-size: 8px;
            margin-bottom: 0.8mm;
            padding: 0.8mm 1mm;
            font-weight: bold;
            border-bottom: 1px dotted #000;
        }

        .summary-row.highlight {
            background: #000;
            color: #fff;
            border: 2px solid #000;
            padding: 1.5mm 2mm;
            margin: 1mm 0;
        }

        .summary-row.total {
            font-size: 10px;
            font-weight: bold;
            background: #000;
            color: #fff;
            border: 3px double #000;
            padding: 2mm;
            margin: 2mm 0 0 0;
            text-transform: uppercase;
        }

        .summary-label {
            font-weight: bold;
        }

        .summary-value {
            font-weight: bold;
            text-align: right;
        }

        /* Footer Section - B&W */
        .footer-section {
            border-top: 3px double #000;
            padding-top: 2mm;
            text-align: center;
            background: white;
        }

        .terms-compact {
            font-size: 6px;
            line-height: 1.2;
            margin-bottom: 2mm;
            text-align: justify;
            border: 1px solid #000;
            padding: 1mm;
        }

        .signature-line {
            border-bottom: 2px solid #000;
            margin: 3mm 0 2mm 0;
            height: 8mm;
            display: flex;
            align-items: end;
            justify-content: center;
            font-size: 7px;
            font-weight: bold;
        }

        .thank-you {
            font-size: 10px;
            font-weight: bold;
            margin: 2mm 0;
            text-transform: uppercase;
            border: 2px solid #000;
            padding: 1mm;
            background: #000;
            color: #fff;
        }

        .contact-info {
            font-size: 6px;
            font-weight: bold;
            border-top: 1px solid #000;
            padding-top: 1mm;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
            padding: 15px;
            background: white;
            margin: 15px auto;
            max-width: 600px;
            border: 2px solid #000;
        }

        .btn {
            padding: 10px 16px;
            border: 2px solid #000;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            font-size: 12px;
            text-transform: uppercase;
            background: white;
            color: #000;
            transition: all 0.2s;
        }

        .btn:hover {
            background: #000;
            color: #fff;
        }

        .btn-primary {
            background: #000;
            color: #fff;
        }

        .btn-primary:hover {
            background: #333;
        }

        /* Print Styles - Thermal B&W Optimized */
        @media print {
            @page {
                size: 4in 6in;
                margin: 0;
            }

            body {
                background: white !important;
                padding: 0 !important;
                margin: 0 !important;
            }

            .thermal-container {
                width: 4in !important;
                height: 6in !important;
                max-width: none !important;
                margin: 0 !important;
                border: none !important;
            }

            .thermal-invoice {
                padding: 2mm !important;
            }

            .action-buttons {
                display: none !important;
            }

            /* Ensure solid blacks print correctly */
            .shop-name,
            .invoice-title,
            .customer-title,
            .items-header,
            .summary-row.highlight,
            .summary-row.total,
            .thank-you {
                background: #000 !important;
                color: #fff !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            /* Ensure borders print */
            * {
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }
        }

        /* Mobile Responsive */
        @media screen and (max-width: 480px) {
            .thermal-container {
                width: 100%;
                max-width: 320px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 8px;
            }
        }
    </style>
</head>
<body>
<c:if test="${pageContext.request.userPrincipal.name != null}">

<div class="thermal-container" id="thermal-invoice-container">
    <div class="thermal-invoice">

        <!-- QR Code -->
        <div class="qr-code">
            <c:choose>
                <c:when test="${not empty QRCODE}">
                    <img src="data:image/png;base64,${QRCODE}" alt="QR" />
                </c:when>
                <c:otherwise>
                    [QR]
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Header -->
        <div class="thermal-header">
            <div class="shop-name">${ownerInfo.shopName}</div>
            <div class="shop-details">
                <div>${ownerInfo.address}</div>
                <div>Ph: ${ownerInfo.mobNumber}</div>
                <div>GST: ${ownerInfo.gstNumber}</div>
            </div>
            <div class="invoice-title">TAX INVOICE</div>
            <div class="invoice-meta">
                <span>Bill #: ${invoiceNo}</span>
                <span>Date: ${date}</span>
            </div>
        </div>

        <!-- Customer Section -->
        <div class="customer-section">
            <div class="customer-title">CUSTOMER DETAILS</div>
            <div class="customer-row">
                <span class="customer-label">Name:</span>
                <span class="customer-value">${profile.custName}</span>
            </div>
            <div class="customer-row">
                <span class="customer-label">Phone:</span>
                <span class="customer-value">${profile.phoneNo}</span>
            </div>
            <div class="customer-row">
                <span class="customer-label">Address:</span>
                <span class="customer-value">${profile.address}</span>
            </div>
        </div>

        <!-- Items Section -->
        <div class="items-section">
            <div class="items-header">
                <div>SR</div>
                <div class="desc-col">ITEM</div>
                <div>QTY</div>
                <div class="amt-col">AMT</div>
            </div>

            <c:forEach items="${items}" var="item">
                <div class="item-row">
                    <div class="item-sr">${item.itemNo}</div>
                    <div class="item-desc">
                        <div>${item.description}</div>
                        <div class="item-desc-details">
                            <c:if test="${invoiceColms.contains('BRAND') && not empty item.brand}">
                                Brand: ${item.brand}<br/>
                            </c:if>
                            <c:if test="${invoiceColms.contains('BATCHNO') && not empty item.batchNo}">
                                Batch: ${item.batchNo}<br/>
                            </c:if>
                            <c:if test="${invoiceColms.contains('MRP')}">
                                MRP: Rs.${item.mrp}<br/>
                            </c:if>
                            Rate: Rs.${item.rate}
                        </div>
                    </div>
                    <div class="item-qty">${item.qty}</div>
                    <div class="item-amt">Rs.${item.amount}</div>
                </div>
            </c:forEach>
        </div>

        <!-- Summary Section -->
        <div class="summary-section">
            <div class="summary-title">BILL SUMMARY</div>
            <div class="summary-row">
                <span class="summary-label">Sub Total:</span>
                <span class="summary-value">Rs.${totalAmout}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label">GST:</span>
                <span class="summary-value">Rs.${currentinvoiceitems.tax}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Paid:</span>
                <span class="summary-value">Rs.${advamount}</span>
            </div>
            <div class="summary-row highlight">
                <span class="summary-label">Net Amount:</span>
                <span class="summary-value">Rs.${totalAmout - advamount}</span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Prev Balance:</span>
                <span class="summary-value">Rs.${currentinvoiceitems.preBalanceAmt}</span>
            </div>
            <div class="summary-row total">
                <span class="summary-label">CURRENT BALANCE:</span>
                <span class="summary-value">Rs.${profile.currentOusting}</span>
            </div>
        </div>

        <!-- Footer -->
        <div class="footer-section">
            <div class="terms-compact">
                ${fn:substring(ownerInfo.terms, 0, 120)}...
            </div>
            <div class="signature-line">
                Authorized Signature
            </div>
            <div class="thank-you">
                THANK YOU!
            </div>
            <div class="contact-info">
                BillMatePro | 8180080378
            </div>
        </div>

    </div>
</div>

<!-- Action Buttons -->
<div class="action-buttons">
    <button class="btn" onclick="window.location.href='${pageContext.request.contextPath}/login/home'">
        HOME
    </button>
    <button class="btn btn-primary" onclick="printThermalInvoice()">
        PRINT
    </button>
    <a href="https://wa.me/${profile.phoneNo}/?text=Bill%20%23${invoiceNo}%20Rs.${profile.currentOusting}" target="_blank" class="btn">
        WHATSAPP
    </a>
</div>

</c:if>

<script>
    function printThermalInvoice() {
        window.print();
    }

    // Auto-adjust for mobile
    if (window.innerWidth < 480) {
        window.addEventListener('load', function() {
            document.getElementById('thermal-invoice-container').scrollIntoView({
                behavior: 'smooth',
                block: 'center'
            });
        });
    }
</script>

</body>
</html>