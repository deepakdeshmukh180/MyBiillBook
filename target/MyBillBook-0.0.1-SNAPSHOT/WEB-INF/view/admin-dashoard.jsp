<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

    <style>
        /* Status badges */
        .status-active {
            font-weight: 600;
            color: white;
            background-color: #28a745;
            padding: 0.3em 0.75em;
            border-radius: 0.25rem;
            display: inline-block;
            min-width: 100px;
            text-align: center;
        }

        .status-deactivate {
            font-weight: 600;
            color: white;
            background-color: #dc3545;
            padding: 0.3em 0.75em;
            border-radius: 0.25rem;
            display: inline-block;
            min-width: 100px;
            text-align: center;
        }

        .status-pending {
            font-weight: 600;
            color: black;
            background-color: #ffc107;
            padding: 0.3em 0.75em;
            border-radius: 0.25rem;
            display: inline-block;
            min-width: 100px;
            text-align: center;
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
        <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/company/admin">My <i class="fa fa-calculator" style="font-size:20px;color:red"></i> Bill Book</a>
        <!-- Sidebar Toggle-->
        <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
        <!-- Navbar Search-->
        <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
            <div class="input-group">
                <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
                <button class="btn btn-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
            </div>
        </form>
        <!-- Navbar-->
        <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                    <li><hr class="dropdown-divider" /></li>
                    <li><a class="dropdown-item" onclick="document.forms['logoutForm'].submit()">Logout</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="container-fluid px-5 py-4">

        <div class="card mb-4 shadow-sm">
            <div class="card-header bg-primary text-white d-flex align-items-center">
                <i class="fas fa-users me-2"></i>
                <h5 class="mb-0">My Bill Book - All Customers</h5>
            </div>
            <div class="card-body">

                <!-- Owner Info Update Form -->
                <form name="my-form" modelAttribute="OwnerInfo" action="${pageContext.request.contextPath}/company/approved-owner-info" method="POST" class="needs-validation" novalidate>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="ownerId" value="${ownerInfo.ownerId}" />
                    <input type="hidden" name="date" value="${ownerInfo.date}" />

                    <div class="row g-3 mb-3">
                        <div class="col-md-3">
                            <label class="form-label">User Name</label>
                            <input type="text" readonly class="form-control-plaintext" value="${ownerInfo.userName}" name="userName" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Shop Name</label>
                            <input type="text" class="form-control" value="${ownerInfo.shopName}" name="shopName" required />
                            <div class="invalid-feedback">Please enter Shop Name.</div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Shop Address</label>
                            <input type="text" class="form-control" value="${ownerInfo.address}" name="address" required />
                            <div class="invalid-feedback">Please enter Shop Address.</div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Shop Owner</label>
                            <input type="text" class="form-control" value="${ownerInfo.ownerName}" name="ownerName" required />
                            <div class="invalid-feedback">Please enter Shop Owner.</div>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-3">
                            <label class="form-label">Phone Number</label>
                            <input type="tel" class="form-control" name="mobNumber" value="${ownerInfo.mobNumber}" pattern="[0-9]{10}" required />
                            <div class="invalid-feedback">Please enter a valid 10-digit phone number.</div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" name="email" value="${ownerInfo.email}" required />
                            <div class="invalid-feedback">Please enter a valid email.</div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">GST</label>
                            <input type="text" class="form-control" name="gstNumber" value="${ownerInfo.gstNumber}" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">LC No.</label>
                            <input type="text" class="form-control" name="lcNo" value="${ownerInfo.lcNo}" />
                        </div>
                    </div>

                    <div class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label">Plan Valid Upto</label>
                            <input type="text" readonly class="form-control-plaintext fw-bold text-secondary" value="${ownerInfo.expDate}" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" name="status" required>
                                <option value="" ${ownerInfo.status == null ? 'selected' : ''}>-- Select Status --</option>
                                <option value="ACTIVE" ${ownerInfo.status eq 'ACTIVE' ? 'selected' : ''}>Active</option>
                                <option value="DEACTIVATE" ${ownerInfo.status eq 'DEACTIVATE' ? 'selected' : ''}>Deactivate</option>
                                <option value="PENDING" ${ownerInfo.status eq 'PENDING' ? 'selected' : ''}>Pending</option>
                            </select>
                            <div class="invalid-feedback">Please select Status.</div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Plan Duration</label>
                            <select class="form-select" name="planDuration" required>
                                <option value="" ${ownerInfo.planDuration == null ? 'selected' : ''}>-- Select Plan Duration --</option>
                                <option value="3" ${ownerInfo.planDuration == 3 ? 'selected' : ''}>3 Months</option>
                                <option value="6" ${ownerInfo.planDuration == 6 ? 'selected' : ''}>6 Months</option>
                                <option value="9" ${ownerInfo.planDuration == 9 ? 'selected' : ''}>9 Months</option>
                                <option value="12" ${ownerInfo.planDuration == 12 ? 'selected' : ''}>12 Months</option>
                                <option value="24" ${ownerInfo.planDuration == 24 ? 'selected' : ''}>24 Months</option>
                            </select>
                            <div class="invalid-feedback">Please select Plan Duration.</div>
                        </div>
                        <div class="col-md-3 d-flex justify-content-end">
                            <button type="submit" class="btn btn-success px-4">Update</button>
                        </div>
                    </div>
                </form>

            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body table-responsive">
                <table id="datatablesSimple" class="table table-striped table-hover align-middle" style="margin-top: 1rem;">
                    <thead class="table-dark">
                        <tr>
                            <th>Edit</th>
                            <th>Shop Name</th>
                            <th>Owner Name</th>
                            <th>Address</th>
                            <th>Contact No</th>
                            <th>Email</th>
                            <th>GST</th>
                            <th>Reg Date</th>
                            <th>Plan Selected</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${ownerDetails}" var="ownerDetail">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/company/get-shop-profile/${ownerDetail.ownerId}" class="btn btn-sm btn-outline-primary" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                </td>
                                <td class="fw-semibold">${ownerDetail.shopName}</td>
                                <td class="fw-semibold">${ownerDetail.ownerName}</td>
                                <td class="fw-semibold">${ownerDetail.address}</td>
                                <td class="fw-semibold">${ownerDetail.mobNumber}</td>
                                <td class="fw-semibold">${ownerDetail.email}</td>
                                <td class="fw-semibold">${ownerDetail.gstNumber}</td>
                                <td class="fw-semibold">${ownerDetail.date}</td>
                                <td class="fw-semibold">${ownerDetail.planDuration} Months</td>
                                <c:set var="status" value="${fn:toUpperCase(fn:trim(ownerDetail.status))}" />
                                <c:choose>
                                    <c:when test="${status eq 'ACTIVE'}">
                                        <td><span class="status-active"><i class="fas fa-check-circle me-1"></i>${status}</span></td>
                                    </c:when>
                                    <c:when test="${status eq 'DEACTIVATE'}">
                                        <td><span class="status-deactivate"><i class="fas fa-times-circle me-1"></i>${status}</span></td>
                                    </c:when>
                                    <c:when test="${status eq 'PENDING'}">
                                        <td><span class="status-pending"><i class="fas fa-hourglass-half me-1"></i>${status}</span></td>
                                    </c:when>
                                    <c:otherwise>
                                        <td><span class="badge bg-secondary"><i class="fas fa-question-circle me-1"></i>${status}</span></td>
                                    </c:otherwise>
                                </c:choose>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <form id="logoutForm" action="${pageContext.request.contextPath}/logout" method="POST" style="display:none;">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/simple-datatables.min.js"></script>
          <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
          <script src="${pageContext.request.contextPath}/resources/js/datatables-simple-demo.js"></script>

    <script>
        // Initialize DataTables
        window.addEventListener('DOMContentLoaded', event => {
            const dataTable = new simpleDatatables.DataTable("#datatablesSimple");
        });

        // Bootstrap validation example
        (() => {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>

</body>

</html>
