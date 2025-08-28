<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<table class="table table-responsive">
  <tr>
    <td colspan="3" class="text-center">
      <!-- Logo can be added here if base64 is available -->
      <img src="data:image/jpeg;base64," alt="Logo" height="60">
    </td>
  </tr>
  <thead class="table-primary">
    <tr>
      <th>
        <h3><i class="ace-icon fa fa-leaf green"></i> ${ownerInfo.shopName}</h3>
        <h5><i class="fa fa-edit"></i> ${ownerInfo.address} <br>
          Owner: <span class="blue">${ownerInfo.ownerName}</span> <br>
          Mob No: ${ownerInfo.mobNumber}</h5>
      </th>
      <th>L.No ${ownerInfo.lcNo}</th>
      <th>
        Bill No.: <span class="red">#${invoiceNo}</span><br>
        Date: <span class="blue">${date}</span><br>
        GST: ${ownerInfo.gstNumber}
      </th>
    </tr>
  </thead>
</table>

<table class="table table-bordered">
  <thead class="table-success">
    <tr>
      <th>Cust Name : Mr.${profile.custName}</th>
      <th>Address : ${profile.address}</th>
      <th>Mob No. : ${profile.phoneNo}</th>
    </tr>
  </thead>
</table>

<table class="table table-bordered">
  <thead class="table-success">
    <tr>
      <th>SR.</th>
      <th>Description</th>
      <th>B.No</th>
      <th class="text-right">MRP</th>
      <th>Qty</th>
      <th class="text-right">Rate</th>
      <th class="text-right">Amount</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach items="${items}" var="item">
      <tr>
        <td>${item.itemNo}.</td>
        <td>${item.description}</td>
        <td>${item.batchNo}</td>
        <td class="text-right">&#x20b9;${item.mrp}</td>
        <td>${item.qty}</td>
        <td class="text-right">&#x20b9;${item.rate}</td>
        <td class="text-right">&#x20b9;${item.amount}</td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<div class="row">
  <div class="col-xs-6">
    <table class="table table-bordered">
      <tr>
        <th>Prev. Balance Amt</th>
        <td class="text-right">&#x20b9;${currentinvoiceitems.preBalanceAmt}</td>
      </tr>
      <tr>
        <th>Advance Amt</th>
        <td class="text-right">&#x20b9;${advamount}</td>
      </tr>
      <tr>
        <th>Curr. Balance Amt</th>
        <td class="text-right">&#x20b9;${profile.currentOusting}</td>
      </tr>
    </table>
  </div>
  <div class="col-xs-6">
    <table class="table table-bordered">
      <tr>
        <th>Total Amt before Tax</th>
        <td class="text-right">&#x20b9;${currentinvoiceitems.preTaxAmt}</td>
      </tr>
      <tr>
        <th>GST (SGST + CGST)</th>
        <td class="text-right">&#x20b9;${currentinvoiceitems.tax} (&#x20b9;${currentinvoiceitems.tax/2} + &#x20b9;${currentinvoiceitems.tax/2})</td>
      </tr>
      <tr>
        <th>Total Invoice Amt</th>
        <td class="text-right">&#x20b9;${totalAmout}</td>
      </tr>
    </table>
  </div>
</div>

<c:if test="${currentinvoiceitems.discount > 0}">
  <div class="alert alert-success mt-4 text-center" role="alert">
    🎉 <strong>Congratulations!</strong> You have saved ₹${currentinvoiceitems.discount} on the above invoice.
  </div>
</c:if>
