<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
    <div class="sb-sidenav-menu">
        <div class="nav">
            <!-- Dashboard -->
            <div class="sb-sidenav-menu-heading">Core</div>
            <a class="nav-link" href="${pageContext.request.contextPath}/login/home">
                <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                Dashboard
            </a>

            <!-- Interface -->
            <div class="sb-sidenav-menu-heading">Interface</div>
            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>
                Menu
                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
            </a>
            <div class="collapse" id="collapseLayouts" data-bs-parent="#sidenavAccordion">
                <nav class="sb-sidenav-menu-nested nav">
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers">
                        <i class="fas fa-users me-2"></i> All Customers
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices">
                        <i class="fas fa-file-invoice me-2"></i> Invoices
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/company/reports">
                        <i class="fas fa-chart-line me-2"></i> Reports
                    </a>
                     <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
                                                    <div class="sb-nav-link-icon"><i class="fa fa-gear fa-spin"></i></div> Account Settings
                                                  </a>
                </nav>
            </div>

            <!-- Addons -->
            <div class="sb-sidenav-menu-heading">Addons</div>
            <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
                <div class="sb-nav-link-icon"><i class="fas fa-user-circle"></i></div>
                My Profile
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/company/export-to-pdf">
                <div class="sb-nav-link-icon"><i class="fas fa-file-export"></i></div>
                Export Customers
            </a>

                                        <a class="nav-link" href="${pageContext.request.contextPath}/login/password-reset-page">
                                            <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                                            Password Reset
                                        </a>
        </div>
    </div>

    <!-- Footer -->
    <div class="sb-sidenav-footer">
        <div class="small">Logged in as:</div>
        ${pageContext.request.userPrincipal.name}
    </div>
</nav>
