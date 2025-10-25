<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="../view/logo.jsp"></jsp:include>

<style>
/* ===================================
   DEALER MANAGEMENT SPECIFIC STYLES
   =================================== */

/* Stats Cards */
.stats-row {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 1rem;
    margin-bottom: 1.5rem;
}

.stats-card {
    background: var(--card-bg);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-lg);
    padding: 1.5rem;
    display: flex;
    align-items: center;
    gap: 1rem;
    transition: all var(--transition-base);
    position: relative;
    overflow: hidden;
}

.stats-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 3px;
    background: linear-gradient(90deg, var(--primary-color), var(--success-color));
    transform: scaleX(0);
    transform-origin: left;
    transition: transform var(--transition-base);
}

.stats-card:hover {
    transform: translateY(-4px);
    box-shadow: var(--shadow-md);
}

.stats-card:hover::before {
    transform: scaleX(1);
}

.stats-icon {
    width: 60px;
    height: 60px;
    border-radius: var(--radius-md);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
    flex-shrink: 0;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.stats-content {
    flex: 1;
}

.stats-label {
    font-size: 0.85rem;
    color: var(--text-secondary);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 0.25rem;
}

.stats-value {
    font-size: 1.75rem;
    font-weight: 700;
    color: var(--text-color);
    line-height: 1;
}

/* Form Card */
.form-card {
    background: var(--card-bg);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-lg);
    overflow: hidden;
    margin-bottom: 1.5rem;
    box-shadow: var(--shadow-sm);
}

.form-header {
    background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
    color: white;
    padding: 1.25rem 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.75rem;
}

.form-header h5 {
    margin: 0;
    font-weight: 600;
    font-size: 1.25rem;
}

.form-header i {
    font-size: 1.5rem;
}

.form-card form {
    padding: 1.5rem;
}

.form-group {
    margin-bottom: 1rem;
}

.form-label {
    font-size: 0.85rem;
    font-weight: 600;
    color: var(--text-color);
    margin-bottom: 0.5rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.form-label i {
    color: var(--primary-color);
    width: 16px;
}

.form-control {
    background: var(--card-bg);
    border: 2px solid var(--border-color);
    border-radius: var(--radius-sm);
    padding: 0.75rem 1rem;
    font-size: 0.9rem;
    color: var(--text-color);
    transition: all var(--transition-fast);
}

.form-control:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px var(--primary-light);
    outline: none;
    background: var(--card-bg);
}

.form-control[readonly] {
    background: var(--bg-secondary);
    cursor: not-allowed;
    opacity: 0.7;
}

.btn-submit {
    background: linear-gradient(135deg, var(--success-color), #059669);
    color: white;
    border: none;
    border-radius: var(--radius-md);
    padding: 0.75rem 1.5rem;
    font-weight: 600;
    font-size: 0.9rem;
    cursor: pointer;
    transition: all var(--transition-base);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
}

.btn-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}

/* Cards Header */
.cards-header {
    margin-bottom: 1.5rem;
}

.cards-header h4 {
    font-weight: 700;
    color: var(--text-color);
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin: 0;
}

.search-box {
    position: relative;
    width: 100%;
    max-width: 350px;
}

.search-box i {
    position: absolute;
    left: 1rem;
    top: 50%;
    transform: translateY(-50%);
    color: var(--text-secondary);
    font-size: 0.9rem;
}

.search-box input {
    width: 100%;
    padding: 0.75rem 1rem 0.75rem 2.75rem;
    border: 2px solid var(--border-color);
    border-radius: var(--radius-md);
    background: var(--card-bg);
    color: var(--text-color);
    font-size: 0.9rem;
    transition: all var(--transition-fast);
}

.search-box input:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px var(--primary-light);
    outline: none;
}

/* Dealer Cards Grid */
.dealer-cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 1.25rem;
}

.dealer-card {
    background: var(--card-bg);
    border: 2px solid var(--border-color);
    border-radius: var(--radius-lg);
    padding: 1.25rem;
    transition: all var(--transition-base);
    position: relative;
    overflow: hidden;
}

.dealer-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 4px;
    height: 100%;
    background: linear-gradient(180deg, var(--primary-color), var(--success-color));
    transform: scaleY(0);
    transform-origin: top;
    transition: transform var(--transition-base);
}

.dealer-card:hover {
    border-color: var(--primary-color);
    box-shadow: var(--shadow-md);
    transform: translateY(-4px);
}

.dealer-card:hover::before {
    transform: scaleY(1);
}

/* Edit Icon Button */
.edit-icon-btn {
    position: absolute;
    top: 1rem;
    right: 1rem;
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: var(--primary-light);
    color: var(--primary-color);
    display: flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
    transition: all var(--transition-base);
    z-index: 10;
    font-size: 0.85rem;
}

.edit-icon-btn:hover {
    background: var(--primary-color);
    color: white;
    transform: rotate(15deg) scale(1.1);
}

/* Dealer Header */
.dealer-header {
    padding-bottom: 1rem;
    border-bottom: 1px solid var(--border-color);
}

.dealer-avatar {
    width: 50px;
    height: 50px;
    border-radius: var(--radius-md);
    background: linear-gradient(135deg, var(--primary-color), var(--success-color));
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
    font-weight: 700;
    text-transform: uppercase;
    box-shadow: 0 4px 12px rgba(34, 71, 165, 0.3);
    flex-shrink: 0;
}

.dealer-info {
    flex: 1;
    min-width: 0;
}

.dealer-name {
    font-size: 1rem;
    font-weight: 600;
    color: var(--text-color);
    margin-bottom: 0.25rem;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.dealer-contact {
    font-size: 0.8rem;
    color: var(--text-secondary);
    display: flex;
    align-items: center;
    gap: 0.25rem;
}

/* Dealer Body */
.dealer-body {
    padding: 1rem 0;
}

.info-row {
    display: flex;
    align-items: flex-start;
    gap: 0.5rem;
    margin-bottom: 0.5rem;
    font-size: 0.85rem;
    color: var(--text-color);
    line-height: 1.4;
}

.info-row i {
    margin-top: 0.1rem;
    flex-shrink: 0;
}

/* Bank Badge & Popup */
.bank-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
    padding: 0.25rem 0.5rem;
    background: var(--info-light);
    color: var(--info-color);
    border-radius: var(--radius-sm);
    font-size: 0.75rem;
    font-weight: 600;
    cursor: pointer;
    transition: all var(--transition-fast);
}

.bank-badge:hover {
    background: var(--info-color);
    color: white;
    transform: scale(1.05);
}

.bank-details-popup {
    position: absolute;
    top: 100%;
    left: 0;
    margin-top: 0.5rem;
    background: var(--card-bg);
    border: 2px solid var(--border-color);
    border-radius: var(--radius-md);
    padding: 1rem;
    min-width: 250px;
    box-shadow: var(--shadow-lg);
    z-index: 100;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all var(--transition-base);
}

.bank-details-popup.show {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.bank-detail-item {
    padding: 0.5rem 0;
    border-bottom: 1px solid var(--border-color);
    font-size: 0.85rem;
    color: var(--text-color);
}

.bank-detail-item:last-child {
    border-bottom: none;
}

.bank-detail-item strong {
    color: var(--text-secondary);
    display: inline-block;
    min-width: 70px;
}

/* Financial Summary */
.financial-summary {
    background: var(--bg-secondary);
    border-radius: var(--radius-sm);
    padding: 0.875rem;
    margin-bottom: 0.75rem;
}

.financial-summary > div {
    display: flex;
    justify-content: space-between;
    margin-bottom: 0.5rem;
    font-size: 0.85rem;
}

.financial-summary > div:last-child {
    margin-bottom: 0;
    padding-top: 0.5rem;
    border-top: 1px solid var(--border-color);
}

/* Invoice Actions */
.invoice-actions {
    padding-top: 0.75rem;
    border-top: 1px solid var(--border-color);
}

.invoice-form {
    display: flex;
    gap: 0.5rem;
}

.invoice-input {
    flex: 1;
    padding: 0.5rem 0.75rem;
    border: 2px solid var(--border-color);
    border-radius: var(--radius-sm);
    background: var(--card-bg);
    color: var(--text-color);
    font-size: 0.85rem;
    transition: all var(--transition-fast);
}

.invoice-input:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 2px var(--primary-light);
    outline: none;
}

.invoice-form .btn {
    padding: 0.5rem 1rem;
    border: 2px solid var(--primary-color);
    background: transparent;
    color: var(--primary-color);
    border-radius: var(--radius-sm);
    font-size: 0.85rem;
    font-weight: 600;
    cursor: pointer;
    transition: all var(--transition-base);
    display: flex;
    align-items: center;
    gap: 0.25rem;
}

.invoice-form .btn:hover {
    background: var(--primary-color);
    color: white;
    transform: translateY(-2px);
}

/* Empty State */
.empty-state {
    text-align: center;
    padding: 4rem 2rem;
    color: var(--text-secondary);
}

.empty-state i {
    font-size: 4rem;
    margin-bottom: 1rem;
    opacity: 0.3;
}

.empty-state p {
    font-size: 1.1rem;
}

/* Alert Styles */
.alert {
    border: none;
    border-radius: var(--radius-md);
    padding: 1rem 1.5rem;
    border-left: 4px solid;
    box-shadow: var(--shadow-sm);
    animation: slideInDown 0.3s ease-out;
    display: flex;
    align-items: center;
    gap: 1rem;
}

.alert-success {
    border-left-color: var(--success-color);
    background: var(--success-light);
    color: var(--success-color);
}

.alert i {
    font-size: 1.5rem;
}

@keyframes slideInDown {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Responsive Design */
@media (max-width: 768px) {
    .stats-row {
        grid-template-columns: repeat(2, 1fr);
    }

    .dealer-cards-grid {
        grid-template-columns: 1fr;
    }

    .cards-header {
        flex-direction: column;
        align-items: stretch !important;
        gap: 1rem;
    }

    .search-box {
        max-width: 100%;
    }

    .stats-value {
        font-size: 1.5rem;
    }
}

@media (max-width: 480px) {
    .stats-row {
        grid-template-columns: 1fr;
    }

    .stats-icon {
        width: 50px;
        height: 50px;
        font-size: 1.25rem;
    }
}
</style>

<!-- Main Content -->
<div id="layoutSidenav_content">
    <main>
        <div class="container-fluid px-3 py-3">

            <!-- Success Alert -->
            <c:if test="${not empty msg}">
                <div class="alert alert-success alert-dismissible fade show mb-4" id="success-alert">
                    <i class="bi bi-check-circle-fill"></i>
                    <div>
                        <strong>Success!</strong> ${msg}
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Stats Row -->
            <div class="stats-row">
                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, #2247a5, #145fa0); color: white;">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stats-content">
                        <div class="stats-label">Total Dealers</div>
                        <div class="stats-value" style="color: var(--primary-color);">${fn:length(dealers)}</div>
                    </div>
                </div>

                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, #10b981, #059669); color: white;">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stats-content">
                        <c:set var="activeCount" value="0"/>
                        <c:forEach items="${dealers}" var="d">
                            <c:if test="${d.balanceAmount > 0}">
                                <c:set var="activeCount" value="${activeCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        <div class="stats-label">Active Accounts</div>
                        <div class="stats-value" style="color: var(--success-color);">${activeCount}</div>
                    </div>
                </div>

                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706); color: white;">
                        <i class="fas fa-rupee-sign"></i>
                    </div>
                    <div class="stats-content">
                        <c:set var="totalBalance" value="0"/>
                        <c:forEach items="${dealers}" var="d">
                            <c:set var="totalBalance" value="${totalBalance + d.balanceAmount}"/>
                        </c:forEach>
                        <div class="stats-label">Total Pending</div>
                        <div class="stats-value" style="color: var(--warning-color);">
                            ₹<fmt:formatNumber value="${totalBalance}" pattern="#,##0"/>
                        </div>
                    </div>
                </div>

                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, #ef4444, #dc2626); color: white;">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="stats-content">
                        <c:set var="highBalance" value="0"/>
                        <c:forEach items="${dealers}" var="d">
                            <c:if test="${d.balanceAmount > 10000}">
                                <c:set var="highBalance" value="${highBalance + 1}"/>
                            </c:if>
                        </c:forEach>
                        <div class="stats-label">High Balance</div>
                        <div class="stats-value" style="color: var(--danger-color);">${highBalance}</div>
                    </div>
                </div>
            </div>

            <!-- Form Section -->
            <div class="form-card">
                <div class="form-header">
                    <i class="fas fa-${not empty dealer.id ? 'edit' : 'plus-circle'}"></i>
                    <h5>${not empty dealer.id ? 'Update Dealer' : 'Add New Dealer'}</h5>
                </div>

                <form:form method="POST" modelAttribute="dealer"
                           action="${pageContext.request.contextPath}/dealers/save">
                    <form:errors path="*" cssClass="alert alert-danger" element="div"/>
                    <form:input path="id" type="hidden"/>

                    <div class="row g-3">
                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-user"></i> Dealer Name *
                                </label>
                                <form:input path="dealerName" cssClass="form-control"
                                            placeholder="John Doe" required="required"/>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-phone"></i> Mobile No *
                                </label>
                                <form:input path="mobileNo" cssClass="form-control"
                                            placeholder="+91 98765 43210" required="required"/>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-map-marker-alt"></i> Address *
                                </label>
                                <form:input path="dealerAddress" cssClass="form-control"
                                            placeholder="Street, City" required="required"/>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-file-invoice"></i> GST No *
                                </label>
                                <form:input path="gstNo" cssClass="form-control"
                                            placeholder="22XXXXX1234X1Z5" required="required"/>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-wallet"></i> Balance Amount *
                                </label>
                                <form:input path="balanceAmount" type="number" step="0.01"
                                            readonly="${not empty dealer.id}"
                                            cssClass="form-control" placeholder="0.00" required="required"/>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-university"></i> Bank Name *
                                </label>
                                <form:input path="bankName" cssClass="form-control"
                                            placeholder="HDFC Bank" required="required"/>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-hashtag"></i> Account Number *
                                </label>
                                <form:input path="accountNo" cssClass="form-control"
                                            placeholder="1234567890" required="required"/>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-code"></i> IFSC Code *
                                </label>
                                <form:input path="ifscCode" cssClass="form-control"
                                            placeholder="HDFC0001234" required="required"/>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-building"></i> Branch Name *
                                </label>
                                <form:input path="branchName" cssClass="form-control"
                                            placeholder="Main Branch" required="required"/>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="form-label" style="visibility: hidden;">Submit</label>
                                <button type="submit" class="btn-submit w-100">
                                    <i class="fas fa-${not empty dealer.id ? 'sync' : 'save'}"></i>
                                    ${not empty dealer.id ? 'Update' : 'Save'}
                                </button>
                            </div>
                        </div>
                    </div>
                </form:form>
            </div>

            <!-- Cards Section -->
            <div class="cards-header d-flex justify-content-between align-items-center flex-wrap">
                <h4>
                    <i class="fas fa-th-large"></i> Dealer Directory
                </h4>
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input id="dealerSearch" type="text" placeholder="Search dealers by name, mobile, GST..."/>
                </div>
            </div>

            <!-- Dealers Grid -->
            <div class="dealer-cards-grid" id="dealerCards">
                <c:forEach items="${dealers}" var="dealer" varStatus="status">
                    <div class="dealer-card-wrapper"
                         data-name="${dealer.dealerName}"
                         data-mobile="${dealer.mobileNo}"
                         data-gst="${dealer.gstNo}">

                        <div class="dealer-card">

                            <!-- Edit Icon -->
                            <a href="${pageContext.request.contextPath}/dealers/update-dealer/${dealer.id}"
                               class="edit-icon-btn"
                               title="Edit Dealer">
                                <i class="fas fa-edit"></i>
                            </a>

                            <!-- Header -->
                            <div class="dealer-header d-flex align-items-center">
                                <div class="dealer-avatar">
                                    ${fn:substring(dealer.dealerName, 0, 1)}
                                </div>
                                <div class="dealer-info">
                                    <div class="dealer-name">${dealer.dealerName}</div>
                                    <div class="dealer-contact">
                                        <i class="fas fa-phone-alt"></i> ${dealer.mobileNo}
                                    </div>
                                </div>
                            </div>

                            <!-- Body -->
                            <div class="dealer-body">
                                <div class="info-row">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span>${dealer.dealerAddress}</span>
                                </div>
                                <div class="info-row">
                                    <i class="fas fa-file-invoice"></i>
                                    <span>GST: ${dealer.gstNo}</span>
                                </div>
                                <div class="info-row position-relative">
                                    <i class="fas fa-university"></i>
                                    <span>Bank:</span>
                                    <span class="bank-badge" onclick="toggleBankPopup(event, ${status.index})">
                                        <i class="fas fa-eye"></i> View
                                    </span>
                                    <div class="bank-details-popup" id="bankPopup${status.index}">
                                        <div class="bank-detail-item"><strong>Bank:</strong> ${dealer.bankName}</div>
                                        <div class="bank-detail-item"><strong>A/C No:</strong> ${dealer.accountNo}</div>
                                        <div class="bank-detail-item"><strong>IFSC:</strong> ${dealer.ifscCode}</div>
                                        <div class="bank-detail-item"><strong>Branch:</strong> ${dealer.branchName}</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Financials -->
                            <div class="financial-summary">
                                <div>
                                    <span>Total:</span>
                                    <span class="fw-bold">
                                        ₹<fmt:formatNumber value="${dealer.totalAmount}" pattern="#,##0.00"/>
                                    </span>
                                </div>
                                <div>
                                    <span>Paid:</span>
                                    <span class="fw-semibold" style="color: var(--success-color);">
                                        ₹<fmt:formatNumber value="${dealer.paidAmount}" pattern="#,##0.00"/>
                                    </span>
                                </div>
                                <div>
                                    <span>Balance:</span>
                                    <span class="fw-semibold" style="color: var(--danger-color);">
                                        ₹<fmt:formatNumber value="${dealer.balanceAmount}" pattern="#,##0.00"/>
                                    </span>
                                </div>
                            </div>

                            <!-- Invoice Form -->
                            <div class="invoice-actions">
                                <form action="${pageContext.request.contextPath}/dealers/view-dealer/${dealer.id}" method="post" class="invoice-form">
                                    <input type="text"
                                           name="billNo"
                                           class="invoice-input"
                                           placeholder="Enter Bill No"
                                           required />
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="btn">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </form>
                            </div>

                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Empty State -->
            <div id="emptyState" class="empty-state d-none">
                <i class="fas fa-inbox"></i>
                <p>No dealers found matching your search</p>
            </div>

        </div>
    </main>

    <jsp:include page="../view/footer.jsp"></jsp:include>
</div>

<script>
(function() {
    'use strict';

    // ===================================
    // INITIALIZATION
    // ===================================
    document.addEventListener('DOMContentLoaded', function() {
        // Apply saved theme
        const savedTheme = localStorage.getItem('theme') || 'light';
        document.body.setAttribute('data-theme', savedTheme);
        updateThemeIcon(savedTheme);

        // Auto-hide success alert
        const successAlert = document.getElementById('success-alert');
        if (successAlert) {
            setTimeout(() => {
                const bsAlert = bootstrap.Alert.getOrCreateInstance(successAlert);
                bsAlert.close();
            }, 4000);
        }

        // Initialize animations
        initializeCardAnimations();
    });

    // ===================================
    // THEME TOGGLE
    // ===================================
    window.toggleTheme = function() {
        const body = document.body;
        const currentTheme = body.getAttribute('data-theme');
        const newTheme = currentTheme === 'light' ? 'dark' : 'light';

        body.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
        updateThemeIcon(newTheme);
    };

    function updateThemeIcon(theme) {
        const icon = document.getElementById('theme-icon');
        if (icon) {
            icon.className = theme === 'light' ? 'fas fa-moon' : 'fas fa-sun';
        }
    }

    // ===================================
    // BANK POPUP TOGGLE
    // ===================================
    window.toggleBankPopup = function(event, index) {
        event.stopPropagation();
        const popup = document.getElementById('bankPopup' + index);

        // Close all other popups
        document.querySelectorAll('.bank-details-popup').forEach(p => {
            if (p !== popup) p.classList.remove('show');
        });

        popup.classList.toggle('show');
    };

    // Close popups when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.bank-badge')) {
            document.querySelectorAll('.bank-details-popup').forEach(p => {
                p.classList.remove('show');
            });
        }
    });

    // ===================================
    // SEARCH FUNCTIONALITY
    // ===================================
    $(document).ready(function() {
        function filterDealerCards() {
            const searchText = $('#dealerSearch').val().toLowerCase();
            let visibleCount = 0;

            $('.dealer-card-wrapper').each(function() {
                const name = $(this).data('name').toString().toLowerCase();
                const mobile = $(this).data('mobile').toString().toLowerCase();
                const gst = $(this).data('gst').toString().toLowerCase();

                const matchesSearch = name.includes(searchText) ||
                                     mobile.includes(searchText) ||
                                     gst.includes(searchText);

                if (matchesSearch) {
                    $(this).show();
                    visibleCount++;
                } else {
                    $(this).hide();
                }
            });

            // Toggle empty state
            if (visibleCount === 0) {
                $('#emptyState').removeClass('d-none').hide().fadeIn(300);
            } else {
                $('#emptyState').fadeOut(300, function() {
                    $(this).addClass('d-none');
                });
            }
        }

        $('#dealerSearch').on('input', filterDealerCards);

        // ===================================
        // SIDEBAR TOGGLE FOR MOBILE
        // ===================================
        $('#sidebarToggle').on('click', function(e) {
            e.preventDefault();
            $('body').toggleClass('sb-sidenav-toggled');

            // Save state for desktop
            if ($(window).width() >= 992) {
                localStorage.setItem('sb|sidebar-toggle', $('body').hasClass('sb-sidenav-toggled'));
            }

            // Prevent body scroll on mobile
            if ($(window).width() < 992 && $('body').hasClass('sb-sidenav-toggled')) {
                $('body').css('overflow', 'hidden');
            } else {
                $('body').css('overflow', '');
            }
        });

        // Close sidebar when clicking outside (mobile)
        $(document).on('click', function(e) {
            if ($(window).width() < 992) {
                if ($('body').hasClass('sb-sidenav-toggled') &&
                    !$(e.target).closest('#layoutSidenav_nav').length &&
                    !$(e.target).closest('#sidebarToggle').length) {
                    $('body').removeClass('sb-sidenav-toggled');
                    $('body').css('overflow', '');
                }
            }
        });

        // Close sidebar on nav link click (mobile)
        $('.sb-sidenav .nav-link').on('click', function() {
            if ($(window).width() < 992) {
                setTimeout(function() {
                    $('body').removeClass('sb-sidenav-toggled');
                    $('body').css('overflow', '');
                }, 150);
            }
        });

        // Handle window resize
        $(window).on('resize', function() {
            if ($(window).width() >= 992) {
                $('body').css('overflow', '');
                if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
                    $('body').addClass('sb-sidenav-toggled');
                } else {
                    $('body').removeClass('sb-sidenav-toggled');
                }
            } else {
                $('body').removeClass('sb-sidenav-toggled');
                $('body').css('overflow', '');
            }
        });

        // Initialize sidebar state
        if ($(window).width() >= 992) {
            if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
                $('body').addClass('sb-sidenav-toggled');
            }
        } else {
            $('body').removeClass('sb-sidenav-toggled');
        }

        // ===================================
        // KEYBOARD SHORTCUTS
        // ===================================
        $(document).on('keydown', function(e) {
            // Ctrl+K for search
            if (e.ctrlKey && e.key === 'k') {
                e.preventDefault();
                $('#dealerSearch').focus();
            }
            // Ctrl+N for new dealer
            if (e.ctrlKey && e.key === 'n') {
                e.preventDefault();
                $('input[name="dealerName"]').focus();
            }
            // ESC to close popups and sidebar
            if (e.key === 'Escape') {
                $('.bank-details-popup').removeClass('show');
                if ($(window).width() < 992 && $('body').hasClass('sb-sidenav-toggled')) {
                    $('body').removeClass('sb-sidenav-toggled');
                    $('body').css('overflow', '');
                }
            }
        });

        // ===================================
        // FORM VALIDATION
        // ===================================
        $('form[modelAttribute="dealer"]').on('submit', function(e) {
            const dealerName = $('input[name="dealerName"]').val().trim();
            if (!dealerName) {
                e.preventDefault();
                alert('Please enter dealer name');
                $('input[name="dealerName"]').focus();
                return false;
            }
        });

        // ===================================
        // SCROLL TO TOP BUTTON
        // ===================================
        const scrollBtn = $('<button>', {
            class: 'btn btn-primary',
            style: 'position: fixed; bottom: 2rem; right: 2rem; z-index: 1000; border-radius: 50%; width: 50px; height: 50px; display: none; box-shadow: 0 10px 25px rgba(0,0,0,0.2);',
            html: '<i class="fas fa-arrow-up"></i>',
            title: 'Scroll to top'
        }).appendTo('body');

        $(window).scroll(function() {
            if ($(this).scrollTop() > 300) {
                scrollBtn.fadeIn();
            } else {
                scrollBtn.fadeOut();
            }
        });

        scrollBtn.on('click', function() {
            $('html, body').animate({ scrollTop: 0 }, 600);
        });

        console.log('✓ Dealer Management System Loaded');
        console.log('✓ Total Dealers:', $('.dealer-card-wrapper').length);
    });

    // ===================================
    // CARD ANIMATIONS
    // ===================================
    function initializeCardAnimations() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry, index) {
                if (entry.isIntersecting) {
                    setTimeout(function() {
                        entry.target.style.opacity = '0';
                        entry.target.style.transform = 'translateY(30px)';
                        entry.target.style.transition = 'all 0.6s ease';

                        setTimeout(function() {
                            entry.target.style.opacity = '1';
                            entry.target.style.transform = 'translateY(0)';
                        }, 50);
                    }, index * 50);

                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        document.querySelectorAll('.dealer-card-wrapper').forEach(function(card) {
            observer.observe(card);
        });
    }

    // ===================================
    // LOGOUT FUNCTION
    // ===================================
    window.confirmLogout = function(event) {
        event.preventDefault();
        if (confirm('Are you sure you want to logout?')) {
            const logoutForm = document.getElementById('logoutForm');
            if (logoutForm) {
                logoutForm.submit();
            } else {
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        }
    };

})();
</script>

</body>
</html>