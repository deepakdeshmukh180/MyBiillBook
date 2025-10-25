<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<style>
.input-group {
    position: relative;
}

.input-icon {
    position: absolute;
    top: 50%;
    left: 12px;
    font-size: 16px;
    transform: translateY(-50%);
    z-index: 5;
    color: #6c757d;
    pointer-events: none;
}

.form-control,
select.form-control {
    padding-left: 35px !important;
}

/* Fix overlap issue in small screens */
@media (max-width: 576px) {
    .input-icon {
        left: 10px;
        font-size: 15px;
    }
}
</style>

<jsp:include page="../view/logo.jsp"></jsp:include>



    <!-- Main Content -->
    <div id="layoutSidenav_content">
        <main>
            <div class="main-card p-4">
                <div class="section-header">
                    <h4 class="section-title">
                        <i class="bi bi-gear me-2"></i>Account Settings
                    </h4>
                </div>

                <form name="account-settings-form" action="${pageContext.request.contextPath}/company/update-owner-details" method="POST" onsubmit="return validateForm()">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="ownerId" value="${ownerInfo.ownerId}"/>

                    <!-- Basic Info -->
                    <div class="form-section">
                        <h6 class="section-subtitle">Basic Information</h6>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">User Name</label>
                                    <div class="input-group">
                                        <i class="bi bi-person input-icon"></i>
                                        <input type="text" readonly class="form-control" value="${ownerInfo.userName}" name="username"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">Shop Name</label>
                                    <div class="input-group">
                                        <i class="bi bi-shop input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.shopName}" name="shopName" required/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label">Owner Name</label>
                                    <div class="input-group">
                                        <i class="bi bi-person-badge input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.ownerName}" name="ownerName" required/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Info -->
                    <div class="form-section">
                        <h6 class="section-subtitle">Contact & Shop Information</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Shop Address</label>
                                    <div class="input-group">
                                        <i class="bi bi-geo-alt input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.address}" name="address" required/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">Phone Number</label>
                                    <div class="input-group">
                                        <i class="bi bi-telephone input-icon"></i>
                                        <input type="tel" class="form-control" value="${ownerInfo.mobNumber}" name="mobNumber" pattern="[0-9]{10}" required/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">Email</label>
                                    <div class="input-group">
                                        <i class="bi bi-envelope input-icon"></i>
                                        <input type="email" class="form-control" value="${ownerInfo.email}" name="email" required/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Business Info -->
                    <div class="form-section">
                        <h6 class="section-subtitle">Business Information</h6>
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">GST Number</label>
                                    <div class="input-group">
                                        <i class="bi bi-receipt input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.gstNumber}" name="gstNumber"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">LC Number</label>
                                    <div class="input-group">
                                        <i class="bi bi-card-list input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.lcNo}" name="lcNo"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">Plan Valid Upto</label>
                                    <div class="input-group">
                                        <i class="bi bi-calendar input-icon"></i>
                                        <input type="text" readonly class="form-control"
                                               value="<fmt:formatDate value='${ownerInfo.expDate}' pattern='dd/MM/yyyy hh:mm a'/>"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label class="form-label">Invoice Type</label>
                                    <div class="input-group">
                                        <i class="bi bi-file-earmark-text input-icon"></i>
                                        <select name="invoiceType" class="form-control">
                                            <option value="A4" ${ownerInfo.invoiceType == 'A4' ? 'selected' : ''}>A4 - Page Size</option>
                                            <option value="A0" ${ownerInfo.invoiceType == 'A0' ? 'selected' : ''}>4x6 - Thermal</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- UPI & QR Code -->
                    <div class="form-section">
                        <h6 class="section-subtitle">Payment Information</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">UPI ID</label>
                                    <div class="input-group">
                                        <i class="bi bi-upc-scan input-icon"></i>
                                        <input type="text" class="form-control" value="${ownerInfo.upiId}" name="upiId"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">QR Code Preview</label>
                                    <div class="qr-section">
                                        <img src="data:image/png;base64,${QRCODE}" class="qr-preview" alt="QR Code"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Terms & Conditions -->
                    <div class="form-section">
                        <div class="form-group">
                            <label class="form-label">Terms & Conditions</label>
                            <textarea name="terms" class="form-control" rows="4">${ownerInfo.terms}</textarea>
                        </div>
                    </div>

                    <!-- Invoice Columns -->
                    <div class="form-section">
                        <h6 class="section-subtitle">Invoice Display Settings</h6>
                        <div class="form-group">
                            <label class="form-label">Select columns to display on invoices</label>
                            <div class="checkbox-group">
                                <label class="checkbox-item ${selectedCols.contains('BRAND') ? 'checked' : ''}">
                                    <input type="checkbox" name="invoiceColms" value="BRAND"
                                    <c:if test="${selectedCols.contains('BRAND')}">checked</c:if>>
                                    Brand
                                </label>

                                <label class="checkbox-item ${selectedCols.contains('BATCHNO') ? 'checked' : ''}">
                                    <input type="checkbox" name="invoiceColms" value="BATCHNO"
                                    <c:if test="${selectedCols.contains('BATCHNO')}">checked</c:if>>
                                    Batch No.
                                </label>

                                <label class="checkbox-item ${selectedCols.contains('EXPD') ? 'checked' : ''}">
                                    <input type="checkbox" name="invoiceColms" value="EXPD"
                                    <c:if test="${selectedCols.contains('EXPD')}">checked</c:if>>
                                    Exp. Date
                                </label>

                                <label class="checkbox-item ${selectedCols.contains('MRP') ? 'checked' : ''}">
                                    <input type="checkbox" name="invoiceColms" value="MRP"
                                    <c:if test="${selectedCols.contains('MRP')}">checked</c:if>>
                                    MRP
                                </label>

                                <label class="checkbox-item ${selectedCols.contains('DISCOUNT') ? 'checked' : ''}">
                                    <input type="checkbox" name="invoiceColms" value="DISCOUNT"
                                    <c:if test="${selectedCols.contains('DISCOUNT')}">checked</c:if>>
                                    Discount
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Status -->
                    <div class="form-section">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Account Status</label>
                                    <div>
                                        <span class="status-badge">${ownerInfo.status}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Save Button -->
                    <div class="text-end">
                        <button type="submit" class="btn-save">
                            <i class="bi bi-save me-1"></i> Save Changes
                        </button>
                    </div>
                </form>

                <!-- Success Alert -->
                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-dismissible fade show mt-4" id="success-alert">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>

<!-- Hidden Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
</form>

<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

<script>
// ============================================
// PAGE LOADER
// ============================================
window.addEventListener('load', function() {
    setTimeout(function() {
        const loader = document.getElementById('pageLoader');
        if (loader) {
            loader.classList.add('hidden');
            setTimeout(() => loader.style.display = 'none', 500);
        }
    }, 1000);
});

// ============================================
// THEME TOGGLE
// ============================================
function toggleTheme() {
    const body = document.body;
    const themeIcon = document.getElementById('theme-icon');
    const currentTheme = body.getAttribute('data-theme');

    if (currentTheme === 'light') {
        body.setAttribute('data-theme', 'dark');
        themeIcon.className = 'fas fa-sun';
        localStorage.setItem('theme', 'dark');
    } else {
        body.setAttribute('data-theme', 'light');
        themeIcon.className = 'fas fa-moon';
        localStorage.setItem('theme', 'light');
    }
}

// Load saved theme preference
document.addEventListener('DOMContentLoaded', function() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.body.setAttribute('data-theme', savedTheme);
    document.getElementById('theme-icon').className = savedTheme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
});



// ============================================
// LOGOUT FUNCTIONALITY
// ============================================
function confirmLogout(event) {
    event.preventDefault();

    if (confirm('Are you sure you want to logout?')) {
        performLogout();
    }
}

function performLogout() {
    try {
        const logoutForm = document.getElementById('logoutForm');
        if (logoutForm) {
            logoutForm.submit();
        } else {
            console.error('Logout form not found');
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    } catch (error) {
        console.error('Logout failed:', error);
        window.location.href = '${pageContext.request.contextPath}/logout';
    }
}

// ============================================
// NOTIFICATIONS
// ============================================
function openNotifications() {
    // Implement notification panel logic
    alert('Notifications feature - integrate with your notification system');
    // You can redirect to a notifications page or open a modal
    // window.location.href = '${pageContext.request.contextPath}/notifications';
}

// ============================================
// CHECKBOX INTERACTIONS
// ============================================
document.addEventListener('DOMContentLoaded', function() {
    const checkboxItems = document.querySelectorAll('.checkbox-item');

    checkboxItems.forEach(item => {
        const checkbox = item.querySelector('input[type="checkbox"]');

        item.addEventListener('click', function(e) {
            if (e.target.type !== 'checkbox') {
                checkbox.checked = !checkbox.checked;
            }
            item.classList.toggle('checked', checkbox.checked);
        });

        // Initialize state
        item.classList.toggle('checked', checkbox.checked);
    });
});

// ============================================
// FORM VALIDATION
// ============================================
function validateForm() {
    const shopName = document.querySelector('input[name="shopName"]').value.trim();
    const ownerName = document.querySelector('input[name="ownerName"]').value.trim();
    const address = document.querySelector('input[name="address"]').value.trim();
    const phone = document.querySelector('input[name="mobNumber"]').value.trim();
    const email = document.querySelector('input[name="email"]').value.trim();

    if (!shopName || !ownerName || !address) {
        alert('Please fill in all required fields (Shop Name, Owner Name, and Address)');
        return false;
    }

    // Phone validation
    const phoneRegex = /^[0-9]{10}$/;
    if (phone && !phoneRegex.test(phone)) {
        alert('Please enter a valid 10-digit phone number');
        return false;
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (email && !emailRegex.test(email)) {
        alert('Please enter a valid email address');
        return false;
    }

    return true;
}

// ============================================
// AUTO-DISMISS SUCCESS ALERT
// ============================================
window.addEventListener('load', function() {
    const successAlert = document.getElementById('success-alert');
    if (successAlert) {
        setTimeout(function() {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(successAlert);
            bsAlert.close();
        }, 3500);
    }
});

// ============================================
// PREVENT DOUBLE SUBMISSION
// ============================================
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form[name="account-settings-form"]');
    if (form) {
        form.addEventListener('submit', function() {
            const submitBtn = form.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Saving...';
            }
        });
    }
});

// ============================================
// SMOOTH SCROLL TO ALERT
// ============================================
window.addEventListener('load', function() {
    const successAlert = document.getElementById('success-alert');
    if (successAlert) {
        successAlert.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
});
</script>

</body>
</html>