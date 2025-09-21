<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dashboard - My Bill Book</title>

    <!-- CSRF -->
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>

    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" rel="stylesheet"/>
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>

    <!-- JS (head) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root { --brand:#0d6efd; --soft:#f4f6f9; --ink:#33475b; }
        body { background:var(--soft); }
        .brand-gradient{ background:linear-gradient(135deg,#3c7bff,#70a1ff); }
        .kpi{ border:0; border-radius:18px; box-shadow:0 10px 24px rgba(0,0,0,.08); transition:.2s transform; }
        .kpi:hover{ transform:translateY(-4px); }
        .section-title{ font-weight:700;color:var(--ink); }
        .card-modern{ border:0;border-radius:18px;box-shadow:0 8px 22px rgba(0,0,0,.08); }
    </style>
</head>
<body class="sb-nav-fixed">

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark brand-gradient">
    <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/login/home">
        My <i class="fa fa-calculator text-warning"></i> Bill Book
    </a>
    <button class="btn btn-outline-light btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>
    <div class="ms-auto d-flex align-items-center gap-3 pe-3">
        <div class="dropdown">
            <a class="nav-link dropdown-toggle text-white" id="navbarDropdown" href="#" data-bs-toggle="dropdown">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div id="layoutSidenav">
    <div id="layoutSidenav_nav">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp"/>
    </div>

    <div id="layoutSidenav_content">
        <main class="container-fluid py-4">
            <div class="main-card p-4">
                <h4 class="section-title mb-4">
                    <i class="bi bi-box-seam me-2"></i> Product Management
                </h4>

                <!-- Product Form -->
<form id="myform" method="post" class="row g-3">
                    <input type="hidden" name="productId" value="0"/>

                    <div class="col-md-4">
                        <label class="form-label">Product Name</label>
                        <input type="text" id="pname" name="pname" class="form-control" required/>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Company</label>
                        <input type="text" id="company" name="company" class="form-control"/>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Quantity</label>
                        <input type="text" id="quantity" name="quantity" class="form-control" required/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Batch No</label>
                        <input type="text" id="batchNo" name="batchNo" class="form-control"/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Expiry Date</label>
                        <input type="date" id="expdate" name="expdate" class="form-control"/>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">MRP</label>
                        <input type="number" step="0.01" id="MRP" name="mrp" class="form-control"/>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Dealer Price</label>
                        <input type="number" step="0.01" id="dealerPrice" name="dealerPrice" class="form-control"/>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Price</label>
                        <input type="number" step="0.01" id="price" name="price" class="form-control"/>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Stock</label>
                        <input type="number" id="stock" name="stock" class="form-control"/>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Tax (%)</label>
                        <input type="number" step="0.01" name="taxPercentage" class="form-control"/>
                    </div>

                    <div class="col-12">
                        <button type="submit" class="btn btn-primary">Save Product</button>
                        <button type="reset" class="btn btn-secondary"
                                onclick="document.querySelector('input[name=productId]').value=0">Reset</button>
                    </div>
                </form>
                <div id="msgBox" class="alert d-none mt-3"></div>

                <hr class="my-4"/>

                <!-- Product Table -->
               <table id="productTable" class="table table-bordered table-striped align-middle">
                   <thead class="table-dark">
                   <tr>
                       <th>Product Name</th>
                       <th>Batch</th>
                       <th>Expiry</th>
                       <th>MRP</th>
                       <th>Price</th>
                       <th>Stock</th>
                       <th>Tax (%)</th>
                       <th>Edit</th>
                       <th>Delete</th>
                   </tr>
                   </thead>
                   <tbody>
                   <c:forEach var="product" items="${products}">
                       <tr id="row-${product.productId}">
                           <td>${product.productName}</td>
                           <td>${product.batchNo}</td>
                           <td>${product.expdate}</td>
                           <td>${product.mrp}</td>
                           <td>${product.price}</td>
                           <td>${product.stock}</td>
                           <td>${product.taxPercentage}</td>
                           <td class="text-center">
                               <button type="button" class="btn btn-outline-success btn-sm"
                                       onclick="editProduct(${product.productId})">
                                   <i class="bi bi-pencil-square"></i>
                               </button>
                           </td>
                           <td class="text-center">
                               <button type="button" class="btn btn-outline-danger btn-sm"
                                       onclick="deleteProduct(${product.productId})">
                                   <i class="bi bi-trash"></i>
                               </button>
                           </td>
                       </tr>
                   </c:forEach>
                   </tbody>
               </table>


                <!-- Success Alert -->
                <div id="msgBox" class="alert d-none mt-3"></div>
            </div>
        </main>
    </div>
</div>

<!-- Logout form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>

<script>
    function getCsrf() {
        return {
            header: document.querySelector('meta[name="_csrf_header"]').content,
            token: document.querySelector('meta[name="_csrf"]').content
        };
    }

    $(document).ready(function () {
        $('#productTable').DataTable();
    });

    // Save / Update Product
    document.getElementById("myform").addEventListener("submit", function (e) {
        e.preventDefault();
        const formData = new FormData(this);
        const csrf = getCsrf();

        fetch("${pageContext.request.contextPath}/product/save-or-update", {
            method: "POST",
            body: formData,
            credentials: "same-origin",
            headers: { [csrf.header]: csrf.token }
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === "success") {
                showMessage(data.message, "success");
                location.reload();
            } else {
                showMessage(data.message, "danger");
            }
        })
        .catch(err => {
            console.error("Error saving product:", err);
            showMessage("Error saving product: " + err.message, "danger");
        });
    });

    // Delete Product
    function deleteProduct(productId) {
        if (!confirm("Are you sure you want to delete this product?")) return;
        const csrf = getCsrf();

        fetch("${pageContext.request.contextPath}/product/delete-product-by-id?productId=" + productId, {
            method: "DELETE",
            credentials: "same-origin",
            headers: { [csrf.header]: csrf.token }
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === "success") {
                showMessage(data.message, "success");
                document.getElementById("row-" + productId).remove();
            } else {
                showMessage(data.message, "danger");
            }
        })
        .catch(err => {
            console.error("Delete error:", err);
            showMessage("Delete failed: " + err.message, "danger");
        });
    }

    // Edit Product → fills form
    function editProduct(productId) {
        fetch("${pageContext.request.contextPath}/product/get-product?id=" + productId)
            .then(res => res.json())
            .then(product => {
                document.getElementById("pname").value = product.pname;
                document.getElementById("company").value = product.company;
                document.getElementById("quantity").value = product.quantity;
                document.getElementById("batchNo").value = product.batchNo;
                document.getElementById("expdate").value = product.expdate;
                document.getElementById("MRP").value = product.mrp;
                document.getElementById("dealerPrice").value = product.dealerPrice;
                document.getElementById("price").value = product.price;
                document.getElementById("stock").value = product.stock;
                document.querySelector("[name='taxPercentage']").value = product.taxPercentage;

                document.querySelector("input[name='productId']").value = product.productId;
                document.getElementById("myform").scrollIntoView({ behavior: 'smooth' });
            })
            .catch(err => {
                console.error("Fetch error:", err);
                showMessage("Error loading product: " + err.message, "danger");
            });
    }

    // Reusable alert box
    function showMessage(msg, type) {
        const box = document.getElementById("msgBox");
        box.className = "alert alert-" + type;
        box.textContent = msg;
        box.classList.remove("d-none");
        setTimeout(() => box.classList.add("d-none"), 4000);
    }
</script>

</body>
</html>
