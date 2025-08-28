<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${invoiceNo}" /> - <c:out value="${profile.custName}" /></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1, user-scalable=no">

    <!-- External CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/resources/css/ionicons.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/resources/css/AdminLTE.css" rel="stylesheet" />

    <!-- Custom CSS -->
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        @page {
            size: A4;
            margin: 20mm;
        }

        .container.bootdey {
            width: 210mm;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border: 1px solid #ccc;
        }

        #invoice {
            width: 100%;
            padding: 20px;
            border: 1px solid #333;
            background-color: #fff;
        }

        h3, h5 {
            margin: 0;
            padding: 5px 0;
        }

        .table {
            width: 100%;
            margin-bottom: 20px;
            border-collapse: collapse;
        }

        .table th, .table td {
            border: 1px solid #ddd;
            padding: 6px 8px;
        }

        .table-primary th { background-color: #cce5ff; }
        .table-success th { background-color: #d4edda; }
        .table-info th { background-color: #d1ecf1; }

        .invoice-info-label {
            font-weight: bold;
        }

        .text-right { text-align: right; }
        .text-center { text-align: center; }

        .btn { margin: 10px; }

        @media print {
            .hidden-print { display: none !important; }
            body { background: white; }
            #invoice { border: none; }
        }
    </style>
</head>
<body>

<c:if test="${pageContext.request.userPrincipal.name != null}">
    <div class="container bootdey">
        <div class="row">
            <div class="col-sm-12">
                <div id="invoice">
                    <h3 class="text-center">My <i class="fa fa-calculator text-danger"></i> Bill Book</h3>

                    <!-- Shop Info -->
                    <table class="table table-responsive">
                        <thead class="table-primary">
                            <tr>
                                <th>
                                    <h3><i class="fa fa-leaf text-success"></i> ${ownerInfo.shopName}</h3>
                                    <h5><i class="fa fa-edit"></i> ${ownerInfo.address} <br>
                                        <span class="invoice-info-label">Owner:</span>
                                        <span class="text-primary">${ownerInfo.ownerName}</span>
                                        <span class="invoice-info-label">Mob No:</span>${ownerInfo.mobNumber}
                                    </h5>
                                </th>
                                <th>L.No ${ownerInfo.lcNo}</th>
                                <th>
                                    <span class="invoice-info-label">Date:</span> ${date}<br>
                                    <span class="invoice-info-label">GST:</span> ${ownerInfo.gstNumber}
                                </th>
                            </tr>
                        </thead>
                    </table>

                    <!-- Customer Info -->
                    <table class="table table-bordered">
                        <thead class="table-success">
                            <tr>
                                <th>Customer Name</th>
                                <th>Address</th>
                                <th>Mob No.</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Mr. ${profile.custName}</td>
                                <td>${profile.address}</td>
                                <td>${profile.phoneNo}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Invoice History -->
                    <c:if test="${oldinvoices.size() > 0}">

                        <table class="table table-bordered">
                            <thead class="table-success">
                                <tr>
                                    <th>Invoice No</th>
                                    <th>Date</th>
                                    <th>Items Description (Old Invoice)</th>
                                    <th>Bill Amt</th>
                                    <th>Adv Amt</th>
                                    <th>Bal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${oldinvoices}" var="invoice">
                                    <tr>
                                        <td>${invoice.invoiceId}</td>
                                        <td>${invoice.date}</td>
                                        <td>${invoice.itemDetails}</td>
                                        <td class="text-right">${invoice.totInvoiceAmt}</td>
                                        <td class="text-right">${invoice.advanAmt}</td>
                                        <td class="text-right">${invoice.balanceAmt}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>

                    <!-- Transaction History -->
                    <c:if test="${balanceDeposits.size() > 0}">

                        <table class="table table-bordered">
                            <thead class="table-success">
                                <tr>
                                    <th>Transaction Id</th>
                                    <th>Description</th>
                                    <th>Balance Amount</th>
                                    <th>Payment Mode</th>
                                    <th>Deposited Amt</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${balanceDeposits}" var="balanceDeposit">
                                    <tr>
                                        <td>${balanceDeposit.id}</td>
                                        <td>${balanceDeposit.description}</td>
                                        <td class="text-right">${balanceDeposit.currentOusting}</td>
                                        <td>${balanceDeposit.modeOfPayment}</td>
                                        <td class="text-right">${balanceDeposit.advAmt}</td>
                                        <td>${balanceDeposit.date}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>

                    <!-- Summary -->
                    <table class="table table-responsive table-info">
                        <thead>
                            <tr>
                                <th class="text-right">Total Amount</th>
                                <th>: Rs.${profile.totalAmount}</th>
                                <th class="text-right">Paid Amount</th>
                                <th>: Rs.${profile.paidAmout}</th>
                                <th class="text-right">Balance Amount</th>
                                <th>: Rs.${profile.currentOusting}</th>
                            </tr>
                        </thead>
                    </table>

                    <!-- Buttons -->
                    <div class="text-center">
                        <button class="btn btn-primary hidden-print" onclick="downloadPDF()">
                            <span class="fa fa-file-pdf-o"></span> Download
                        </button>
                        <a class="btn btn-warning" target="_blank"
                           href="https://wa.me/${profile.phoneNo}/?text=Namaste!!! ${profile.custName}, कृपया तुमचे मागिल खाते  तपशील पहा: *एकूण रक्कम *: Rs.${profile.totalAmount} **भरलेली रक्कम **:Rs.${profile.paidAmout}  ** शिल्लक रक्कम**: Rs.${profile.currentOusting} **इनव्हॉइस पहा/डाउनलोड करा**: ${profile.custName}.pdf .**आम्ही तुमचे सर्व बिल आणि जमा झालेले पैसे फाइलमध्ये दिले आहेत** आमच्या सेवा निवडल्याबद्दल  *धन्यवाद!!!  ${ownerInfo.shopName} - ${ownerInfo.ownerName}(Mob:${ownerInfo.mobNumber})*">
                            Share
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:if>

<!-- JS Files -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/AdminLTE/app.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/AdminLTE/demo.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/timeout.js"></script>

<!-- Custom Scripts -->
<script>
    function downloadPDF() {
        const element = document.getElementById('invoice');
        const opt = {
            margin: 0.2,
            filename: '${profile.custName}.pdf',
            image: { type: 'jpeg', quality: 1.0 },
            html2canvas: { scale: 3 },
            jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' }
        };
        html2pdf().set(opt).from(element).save();
    }
</script>

</body>
</html>
