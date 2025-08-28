<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html lang="en">
   <head>
      <meta charset="utf-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
      <meta name="description" content="" />
      <meta name="author" content="" />
      <title>Dashboard - SB Admin</title>
      <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
      <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
      <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
      <script src="${pageContext.request.contextPath}/resources/js/timeout.js" crossorigin="anonymous"></script>
      <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
 <style>
    .drop-zone {
      border: 2px dashed #007bff;
      border-radius: 10px;
      padding: 30px;
      text-align: center;
      color: #6c757d;
      cursor: pointer;
    }
    .drop-zone.dragover {
      background-color: #e9f5ff;
    }

  </style>
   </head>
   <body class="sb-nav-fixed">
   <div id="loader" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(255,255,255,0.7); z-index:9999; text-align:center; padding-top:200px;">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
      </div>
      <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
         <!-- Navbar Brand-->
         <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">My <i class="fa fa-calculator" style="font-size:20px;color:red"></i> Bill Book</a>
         <!-- Sidebar Toggle-->
         <button class="btn btn-outline-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
         <!-- Navbar Search-->
         <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
            <div class="input-group">
               <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
               <button class="btn btn-outline-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
            </div>
         </form>
         <!-- Navbar-->
         <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
            <li class="nav-item dropdown">
               <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
               <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                  <li>
                     <hr class="dropdown-divider" />
                  </li>
                  <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()"">Logout</a></li>
               </ul>
            </li>
         </ul>
      </nav>
      <div id="layoutSidenav">
         <div id="layoutSidenav_nav">
            <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
               <div class="sb-sidenav-menu">
                  <div class="nav">
                     <div class="sb-sidenav-menu-heading">Core</div>
                     <a class="nav-link" href="${pageContext.request.contextPath}/login/home">
                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                      Dashboard
                     </a>
                     <div class="sb-sidenav-menu-heading">Interface</div>
                     <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                        <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>
                        Manu
                        <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                     </a>
                     <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
                        <nav class="sb-sidenav-menu-nested nav">
                           <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">All Customers </a>
                           <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">Invoice Search</a>
                           <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">Reports</a>
                           <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products">Products</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/company/download-template">Download Products template</a>


                        </nav>
                     </div>



                  </div>
               </div>
               <div class="sb-sidenav-footer">
                  <div class="small">Logged in as:</div>
                  ${pageContext.request.userPrincipal.name}
               </div>
            </nav>
         </div>
         <div id="layoutSidenav_content">


            <main>
               <div class="container-fluid px-4">
                  <ol class="breadcrumb mb-4">
                     <li class="breadcrumb-item active"></li>
                  </ol>
                  <div class="row">
                     <div class="col-xl-12">
                        <div class="card mb-4">
                           <div class="card-header">
                              <i class="fa fa-address-book me-1"></i>
                              Products
                           </div>
                           <div class="card-body">

                           <!-- Tabs for Invoice and Transaction -->
                                               <div class="card mb-4">
                                                   <div class="card-header">
                                                       <ul class="nav nav-tabs card-header-tabs" id="reportTabs" role="tablist">
                                                           <li class="nav-item">
                                                               <a class="nav-link active" id="invoice-tab" data-bs-toggle="tab" href="#invoice" role="tab">Add/Update Product</a>
                                                           </li>
                                                           <li class="nav-item">
                                                               <a class="nav-link" id="transaction-tab" data-bs-toggle="tab" href="#transaction" role="tab">All Products</a>
                                                           </li>
                                                       </ul>
                                                   </div>
                                                   <div class="card-body tab-content" id="reportTabsContent">
                                                       <!-- Invoices Tab -->
                                                       <div class="tab-pane fade show active" id="invoice" role="tabpanel">
                                                           <form action="${pageContext.request.contextPath}/company/add-product" id="myform" method="post" class="row g-3 needs-validation" novalidate>
                                                                                           <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                                                           <input type="hidden" name="custId" value="${profile.id}">
                                                                                           <input type="hidden" name="productId" value="${product.productId}">

                                                                                           <!-- Product Name -->
                                                                                           <div class="col-md-4">
                                                                                             <label for="productName" class="form-label">Product Name</label>
                                                                                             <input type="text" name="pname" id="productName" value="${product.pname}" class="form-control" placeholder="Product Name" required>
                                                                                           </div>

                                                                                           <!-- Company -->
                                                                                           <div class="col-md-4">
                                                                                             <label for="company" class="form-label">Company</label>
                                                                                             <input type="text" name="company" id="company" value="${product.company}" class="form-control" placeholder="Company Name" required>
                                                                                           </div>

                                                                                           <!-- Packing -->
                                                                                           <div class="col-md-4">
                                                                                             <label for="quantity" class="form-label">Packing</label>
                                                                                             <input type="text" name="quantity" id="quantity" value="${product.quantity}" class="form-control" placeholder="e.g. 500ml, 1kg" required>
                                                                                           </div>

                                                                                           <!-- Batch No -->
                                                                                           <div class="col-md-4">
                                                                                             <label for="batchNo" class="form-label">Batch No</label>
                                                                                             <input type="text" name="batchNo" id="batchNo" value="${product.batchNo}" class="form-control" placeholder="Batch Number" required>
                                                                                           </div>

                                                                                           <!-- Expiry Date -->
                                                                                           <div class="col-md-4">
                                                                                             <label for="expdate" class="form-label">Expiry Date</label>
                                                                                             <input type="date" name="expdate" id="expdate" value="${product.expdate}" class="form-control" required>
                                                                                           </div>

                                                                                           <!-- MRP -->
                                                                                           <div class="col-md-4">
                                                                                             <label for="MRP" class="form-label">MRP</label>
                                                                                             <input type="number" min="0" step="0.01" name="mrp" id="MRP" value="${product.mrp}" oninput="validatePrices()" class="form-control" placeholder="MRP" required>
                                                                                           </div>

                                                                                           <!-- Dealer Price -->
                                                                                           <div class="col-md-4">
                                                                                             <label for="dealer_price_input" class="form-label">Dealer Price</label>
                                                                                             <div class="input-group">
                                                                                               <input type="password" name="delarPrice" id="dealer_price_input" value="${product.delarPrice}" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); validatePrices();" class="form-control" placeholder="Dealer Price" required>
                                                                                               <button class="btn btn-outline-outline-secondary" onclick="toggleDealerPriceVisibility(event)" type="button"><i id="toggle_icon" class="fa fa-eye-slash"></i></button>
                                                                                             </div>
                                                                                             <small id="dealer_price_error" class="text-danger d-block mt-1" style="display:none;"></small>
                                                                                           </div>

                                                                                           <!-- Selling Price -->
                                                                                           <div class="col-md-4">
                                                                                             <label for="price" class="form-label">Selling Price</label>
                                                                                             <input type="number" min="0" step="0.01" name="price" id="price" value="${product.price}" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); validatePrices();" class="form-control" placeholder="Selling Price" required>
                                                                                             <small id="selling_price_error" class="text-danger d-block mt-1" style="display:none;"></small>
                                                                                           </div>

                                                                                           <!-- Stock -->
                                                                                           <div class="col-md-2">
                                                                                             <label for="stock" class="form-label">Stock</label>
                                                                                             <input type="number" min="0" name="stock" id="stock" value="${product.stock}" class="form-control" placeholder="Available Stock" required>
                                                                                           </div>

                                                                                           <!-- GST -->
                                                                                           <div class="col-md-2">
                                                                                             <label for="taxPercentage" class="form-label">GST %</label>
                                                                                             <select class="form-select" name="taxPercentage" required>
                                                                                               <option value="" ${product.taxPercentage == null ? 'selected' : ''}>Select GST</option>
                                                                                               <option value="0" ${product.taxPercentage == 0 ? 'selected' : ''}>No-GST</option>
                                                                                               <option value="5" ${product.taxPercentage == 5 ? 'selected' : ''}>GST-5%</option>
                                                                                               <option value="12" ${product.taxPercentage == 12 ? 'selected' : ''}>GST-12%</option>
                                                                                               <option value="18" ${product.taxPercentage == 18 ? 'selected' : ''}>GST-18%</option>
                                                                                               <option value="28" ${product.taxPercentage == 28 ? 'selected' : ''}>GST-28%</option>
                                                                                             </select>
                                                                                           </div>

                                                                                           <!-- Submit -->
                                                                                           <div class="col-12 text-end mt-8">
                                                                                           <button type="button" class="btn btn-outline-primary" onclick="window.location.href='${pageContext.request.contextPath}/company/download-template'">
                                                                                             <i class="fa fa-download me-1"></i> Download Products File
                                                                                           </button>
                                                                                           <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#uploadModal">
                                                                                             <i class="fa fa-upload me-1"></i> Upload Products File
                                                                                           </button>
                                                                                             <a class="btn btn-outline-danger" href="${pageContext.request.contextPath}/company/get-all-products">
                                                                                               <i class="fa fa-close"></i> Clear
                                                                                             </a>
                                                                                             <button type="submit" class="btn btn-outline-success">
                                                                                               <i class="fa fa-plus-square me-2"></i> ${product.productId != 0 ? 'Update Product' : 'Add Product'}
                                                                                             </button>


                                                                                           </div>
                                                                                         </form>
                                                                                         <c:if test="${not empty msg}">
                                                                                                                                                                                   <div class="alert  alert-success alert-dismissible fade show mt-3" role="alert" id="success-alert">
                                                                                                                                                                                     <strong>Success!</strong> ${msg}
                                                                                                                                                                                     <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                                                                                                                                                                   </div>

                                                                                                                                                                                   <script>
                                                                                                                                                                                     window.onload = function () {
                                                                                                                                                                                       setTimeout(function () {
                                                                                                                                                                                         const alert = bootstrap.Alert.getOrCreateInstance(document.getElementById('success-alert'));
                                                                                                                                                                                         alert.close();
                                                                                                                                                                                       }, 5000);
                                                                                                                                                                                     };
                                                                                                                                                                                   </script>
                                                                                                                                                                                 </c:if>
                                                       </div>

                                                       <!-- Transactions Tab -->
                                                       <div class="tab-pane fade" id="transaction" role="tabpanel">
                                                           <table id="datatablesSimple" class="table  table-striped ">
                                                                                      <thead style=" background-color: silver; ">
                                                                                         <tr>
                                                                                            <th>Product Name</th>
                                                                                            <th>Quantity</th>
                                                                                            <th>Batch No</th>
                                                                                            <th>Exp Date</th>
                                                                                            <th> Stock</th>
                                                                                            <th>MRP</th>
                                                                                            <th>SP</th>
                                                                                            <th>GST%</th>
                                                                                            <th>Edit</th>
                                                                                            <th>Delete</th>
                                                                                         </tr>
                                                                                      </thead>
                                                                                      <tbody>
                                                                                         <c:forEach items="${products}" var="product">
                                                                                            <tr>
                                                                                               <td style="text-align: left;">${product.productName}</td>
                                                                                               <td style="text-align: center;">${product.quantity}</td>
                                                                                               <td style="text-align: center;">${product.batchNo}</td>
                                                                                               <td style="text-align: center;">${product.expdate} (${product.custId})</td>
                                                                                               <td style="text-align: center;">${product.stock}</td>
                                                                                               <td style="text-align: center;">${product.mrp}</td>
                                                                                               <td style="text-align: center;">${product.price}</td>
                                                                                               <td style="text-align: center;">${product.taxPercentage} %</td>
                                                                                               <input type="hidden" name="productId" value="${product.productId}"/>
                                                                                               <td style="text-align: center; width: 8%; ">
                                                                                               <form name="frm" method="get"
                                                                                               action="${pageContext.request.contextPath}/company/update-product-by-id">
                                                                                                                              <input type="hidden" name="productId" value="${product.productId}" />  <button type="submit" class="btn btn-outline-success"><i s class="fa">&#xf044;</i>   </button>

                                                                                                                                      </form>
                                                                                               </td>
                                                                                               <td style="text-align: center; width: 8%; ">
                                                                                                  <form name="frm" method="get"
                                                                                                     action="${pageContext.request.contextPath}/company/delete-product-by-id">
                                                                                                     <input type="hidden" name="productId" value="${product.productId}" />  <button type="submit" class="btn btn-outline-danger"><i class="fa fa-close"></i>    </button>
                                                                                                  </form>
                                                                                               </td>
                                                                                            </tr>
                                                                                         </c:forEach>
                                                                                         </tfoot>
                                                                                   </table>
                                                       </div>
                                                   </div>
                                               </div>




<!-- Upload Modal -->
<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <form id="uploadForm" action="${pageContext.request.contextPath}/company/upload" method="post" enctype="multipart/form-data">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div class="modal-header">
          <h5 class="modal-title" id="uploadModalLabel">Upload Product Excel (.xlsx)</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body">
          <div class="drop-zone" id="dropZone">
            <p>Drag & drop your .xlsx file here, or click to select</p>
            <input type="file" id="fileInput" name="file" accept=".xlsx" hidden>
          </div>

          <div id="fileInfo" class="mt-3 text-success d-none"></div>

          <div class="progress mt-3 d-none" id="uploadProgress">
            <div class="progress-bar" role="progressbar" style="width: 0%;" id="progressBar">0%</div>
          </div>
        </div>

        <div class="modal-footer">
          <button type="submit" class="btn btn-outline-primary">Upload</button>
          <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</div>



                           </div>
                        </div>
                     </div>
                  </div>

               </div>
            </main>
            <footer class="py-4 bg-light mt-auto">
               <div class="container-fluid px-4">
                  <div class="d-flex align-items-center justify-content-between small">
                     <div class="text-muted">Copyright &copy; Your Website 2023</div>
                     <div>
                        <a href="#">Privacy Policy</a>
                        &middot;
                        <a href="#">Terms &amp; Conditions</a>
                     </div>
                  </div>
               </div>
            </footer>
         </div>
      </div>
      <form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
         <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      </form>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
      <script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

      <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
      <script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>
   </body>

<script>
          jQuery( document ).ready( function ( e ) {
              if ( jQuery( '.date-picker-selector' ).length ) {
                  jQuery.datepicker.setDefaults({
                      minDate: 0,
                      maxDate: "+12m"
                  });
              }
          });

         function toggleDealerPriceVisibility(event) {
             event.preventDefault();
             const input = document.getElementById("dealer_price_input");
             const icon = document.getElementById("toggle_icon");
             if (input.type === "password") {
               input.type = "text";
               icon.classList.remove("fa-eye-slash");
               icon.classList.add("fa-eye");
             } else {
               input.type = "password";
               icon.classList.remove("fa-eye");
               icon.classList.add("fa-eye-slash");
             }
           }

           function toggleDealerPriceVisibility(event) {
               event.preventDefault();
               const input = document.getElementById("dealer_price_input");
               const icon = document.getElementById("toggle_icon");
               if (input.type === "password") {
                 input.type = "text";
                 icon.classList.remove("fa-eye-slash");
                 icon.classList.add("fa-eye");
               } else {
                 input.type = "password";
                 icon.classList.remove("fa-eye");
                 icon.classList.add("fa-eye-slash");
               }
             }






function toggleDealerPriceVisibility(event) {
  event.preventDefault();
  const input = document.getElementById('dealer_price_input');
  const icon = document.getElementById('toggle_icon');
  if (input.type === "password") {
    input.type = "text";
    icon.classList.remove('fa-eye-slash');
    icon.classList.add('fa-eye');
  } else {
    input.type = "password";
    icon.classList.remove('fa-eye');
    icon.classList.add('fa-eye-slash');
  }
}

function validatePrices() {
  const mrp = parseFloat(document.getElementById('MRP').value) || 0;
  const dealer = parseFloat(document.getElementById('dealer_price_input').value) || 0;
  const selling = parseFloat(document.getElementById('price').value) || 0;

  let isValid = true;

  document.getElementById('dealer_price_error').style.display = 'none';
  document.getElementById('selling_price_error').style.display = 'none';

  if (dealer > mrp) {
    document.getElementById('dealer_price_error').innerText = "Dealer price cannot be more than MRP.";
    document.getElementById('dealer_price_error').style.display = 'block';
    isValid = false;
  }

  if (selling > mrp) {
    document.getElementById('selling_price_error').innerText = "Selling price cannot be more than MRP.";
    document.getElementById('selling_price_error').style.display = 'block';
    isValid = false;
  }

  if (dealer > selling) {
    document.getElementById('dealer_price_error').innerText = "Dealer price cannot be more than selling price.";
    document.getElementById('dealer_price_error').style.display = 'block';
    isValid = false;
  }

  return isValid;
}

(function () {
  'use strict'
  const form = document.getElementById('myform');
  form.addEventListener('submit', function (event) {
    if (!form.checkValidity() || !validatePrices()) {
      event.preventDefault();
      event.stopPropagation();
    }
    form.classList.add('was-validated');
  }, false);
})();


const dropZone = document.getElementById("dropZone");
const fileInput = document.getElementById("fileInput");
const fileInfo = document.getElementById("fileInfo");
const progressBar = document.getElementById("progressBar");
const uploadProgress = document.getElementById("uploadProgress");

dropZone.addEventListener("click", () => fileInput.click());

dropZone.addEventListener("dragover", (e) => {
  e.preventDefault();
  dropZone.classList.add("dragover");
});

dropZone.addEventListener("dragleave", () => {
  dropZone.classList.remove("dragover");
});

dropZone.addEventListener("drop", (e) => {
  e.preventDefault();
  dropZone.classList.remove("dragover");
  const file = e.dataTransfer.files[0];
  handleFile(file);
});

fileInput.addEventListener("change", () => {
  const file = fileInput.files[0];
  handleFile(file);
});

function handleFile(file) {
  if (!file.name.endsWith(".xlsx")) {
    alert("Only .xlsx files are allowed.");
    fileInput.value = "";
    return;
  }
  fileInfo.textContent = `Selected file: ${file.name}`;
  fileInfo.classList.remove("d-none");
}

document.getElementById("uploadForm").addEventListener("submit", function (e) {
  const file = fileInput.files[0];
  if (!file) {
    e.preventDefault();
    alert("Please select a file before uploading.");
    return;
  }

  e.preventDefault();
  const formData = new FormData(this);
  const xhr = new XMLHttpRequest();
  xhr.open("POST", this.action, true);

  xhr.upload.onprogress = function (e) {
    if (e.lengthComputable) {
      const percent = Math.round((e.loaded / e.total) * 100);
      uploadProgress.classList.remove("d-none");
      progressBar.style.width = percent + "%";
      progressBar.textContent = percent + "%";
    }
  };

  xhr.onload = function () {
    if (xhr.status === 200) {
      alert("Upload successful!");
      window.location.reload(); // Refresh to see imported data
    } else {
      alert("Upload failed.");
    }
  };

  xhr.send(formData);
});

   </script>
</html>