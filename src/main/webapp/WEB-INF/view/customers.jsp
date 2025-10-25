<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="../view/logo.jsp"></jsp:include>

  <!-- Main Content -->
  <div id="layoutSidenav_content">
    <main>
      <div class="container-fluid px-4 mt-4">


        <!-- Success Alert -->
        <c:if test="${not empty msg}">
          <div class="alert alert-success alert-dismissible fade show" role="alert" id="success-alert">
            <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          </div>
        </c:if>

<!-- Page Title -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="h3 mb-0 text-gray-800">All Customers</h2>
                    <div class="d-none d-sm-inline-block">
                        <span class="text-muted">Total: ${totalcustomers} Customers</span>
                    </div>
                </div>
        <!-- Search Section -->
        <div class="row mb-4">
          <div class="col-md-8 mx-auto">
            <div class="input-group">
              <input type="text" id="searchBox" class="form-control" placeholder="Search customers by name or phone...">
              <button class="btn btn-outline-secondary" type="button" onclick="location.reload();">
                <i class="fas fa-sync-alt me-1"></i> Refresh
              </button>
            </div>
          </div>
        </div>

        <!-- Loading Indicator -->
        <div id="loader" class="text-center my-4" style="display: none;">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="text-muted mt-2">Searching customers...</p>
        </div>

        <!-- Customer Cards Container -->
        <div class="cards-grid" id="customerCardContainer">
          <c:forEach items="${custmers}" var="custmer" varStatus="status">
            <div class="customer-card" style="animation-delay: ${status.index * 0.1}s;">
             <div class="card-header d-flex align-items-center gap-2">
                 <div class="customer-avatar">
                     <c:set var="nameWords" value="${fn:split(custmer.custName, ' ')}" />
                     <c:choose>
                         <c:when test="${fn:length(nameWords) > 1}">
                             ${fn:substring(nameWords[0], 0, 1)}${fn:substring(nameWords[1], 0, 1)}
                         </c:when>
                         <c:otherwise>
                             ${fn:substring(custmer.custName, 0, 1)}${fn:substring(custmer.custName, 1, 2)}
                         </c:otherwise>
                     </c:choose>
                 </div>

                 <h3 class="customer-name text-truncate mb-0">${custmer.custName}</h3>
             </div>


              <div class="card-content">
                <div class="info-item">
                  <div class="info-icon address-icon">
                    <i class="fas fa-map-marker-alt"></i>
                  </div>
                  <span class="info-text">${not empty custmer.address ? custmer.address : 'No address provided'}</span>
                </div>

                <div class="info-item">
                  <div class="info-icon phone-icon">
                    <i class="fab fa-whatsapp"></i>
                  </div>
                <c:choose>
                    <c:when test="${not empty custmer.phoneNo}">
                        <a href="https://wa.me/${custmer.phoneNo}" target="_blank" class="whatsapp-link">
                            <span class="info-text">${custmer.phoneNo}</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="info-text">No phone number</span>
                    </c:otherwise>
                </c:choose>


                </div>
              </div>

              <div class="amount-section">
                <div class="amount-card total-card">
                  <div class="amount-label">Total</div>
                  <div class="amount-value">₹<fmt:formatNumber value="${custmer.totalAmount}" pattern="#,##0.00"/></div>
                </div>
                <div class="amount-card paid-card">
                  <div class="amount-label">Paid</div>
                  <div class="amount-value">₹<fmt:formatNumber value="${custmer.paidAmout}" pattern="#,##0.00"/></div>
                </div>
                <div class="amount-card balance-card">
                  <div class="amount-label">Balance</div>
                  <div class="amount-value">₹<fmt:formatNumber value="${custmer.currentOusting}" pattern="#,##0.00"/></div>
                </div>
              </div>

              <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/company/get-cust-by-id?custid=${custmer.id}" class="action-btn btn-invoice">
                  <i class="fas fa-file-invoice"></i> Invoice
                </a>
                <a href="${pageContext.request.contextPath}/company/get-bal-credit-page/${custmer.id}" class="action-btn btn-deposit">
                  <i class="fas fa-donate"></i> Deposit
                </a>
                <a href="${pageContext.request.contextPath}/company/cust-history?custid=${custmer.id}" target="_blank" class="action-btn btn-history">
                  <i class="fas fa-list-ol"></i> History
                </a>
                <a href="${pageContext.request.contextPath}/company/update-customer/${custmer.id}" class="action-btn btn-edit">
                  <i class="fas fa-edit"></i> Edit
                </a>
              </div>
            </div>
          </c:forEach>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
        <div id="paginationContainer" class="d-flex justify-content-center mt-4">
          <nav>
            <ul class="pagination">
              <c:if test="${page > 0}">
                <li class="page-item">
                  <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${page - 1}">
                    <i class="fas fa-chevron-left"></i> Previous
                  </a>
                </li>
              </c:if>

              <c:forEach begin="${page - 2 < 0 ? 0 : page - 2}"
                         end="${page + 2 >= totalPages ? totalPages - 1 : page + 2}" var="i">
                <li class="page-item ${page == i ? 'active' : ''}">
                  <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${i}">
                    ${i + 1}
                  </a>
                </li>
              </c:forEach>

              <c:if test="${page < totalPages - 1}">
                <li class="page-item">
                  <a class="page-link" href="${pageContext.request.contextPath}/company/get-all-customers?page=${page + 1}">
                    Next <i class="fas fa-chevron-right"></i>
                  </a>
                </li>
              </c:if>
            </ul>
          </nav>
        </div>
        </c:if>

      </div>
    </main>
  </div>
</div>

<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
</form>


<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
    const searchInput = document.getElementById('searchBox');
    const cardContainer = document.getElementById('customerCardContainer');
    const paginationContainer = document.getElementById('paginationContainer');
    const loader = document.getElementById('loader');
    let debounceTimer;


    function renderCards(customers) {
        cardContainer.innerHTML = '';

        customers.forEach(function (custmer, index) {
            // Generate avatar initials
            var nameWords = custmer.custName.split(' ');
            var initials = nameWords.length > 1
                ? nameWords[0].charAt(0).toUpperCase() + nameWords[1].charAt(0).toUpperCase()
                : custmer.custName.charAt(0).toUpperCase() + (custmer.custName.charAt(1) || '').toUpperCase();

            var card = document.createElement('div');
            card.className = 'customer-card';

            // Add staggered animation delay
            card.style.animationDelay = (index * 0.1) + 's';

            card.innerHTML =
                '<div class="card-header">' +
                    '<div class="customer-avatar">' + initials + '</div>' +
                    '<h3 class="customer-name">' + custmer.custName + '</h3>' +
                '</div>' +

                '<div class="card-content">' +
                    '<div class="info-item">' +
                        '<div class="info-icon address-icon">' +
                            '<i class="fas fa-map-marker-alt"></i>' +
                        '</div>' +
                        '<span class="info-text">' + (custmer.address || 'No address provided') + '</span>' +
                    '</div>' +

                    '<div class="info-item">' +
                        '<div class="info-icon phone-icon">' +
                            '<i class="fab fa-whatsapp"></i>' +
                        '</div>' +
                        '<a href="https://wa.me/' + custmer.phoneNo + '" target="_blank" class="whatsapp-link">' +
                            '<span class="info-text">' + custmer.phoneNo + '</span>' +
                        '</a>' +
                    '</div>' +
                '</div>' +

                '<div class="amount-section">' +
                    '<div class="amount-card total-card">' +
                        '<div class="amount-label">Total</div>' +
                        '<div class="amount-value">₹' + formatNumber(custmer.totalAmount) + '</div>' +
                    '</div>' +
                    '<div class="amount-card paid-card">' +
                        '<div class="amount-label">Paid</div>' +
                        '<div class="amount-value">₹' + formatNumber(custmer.paidAmout) + '</div>' +
                    '</div>' +
                    '<div class="amount-card balance-card">' +
                        '<div class="amount-label">Balance</div>' +
                        '<div class="amount-value">₹' + formatNumber(custmer.currentOusting) + '</div>' +
                    '</div>' +
                '</div>' +

                '<div class="action-buttons">' +
                    '<a href="' + contextPath + '/company/get-cust-by-id?custid=' + custmer.id + '" class="action-btn btn-invoice">' +
                        '<i class="fas fa-file-invoice"></i>Invoice' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/get-bal-credit-page/' + custmer.id + '" class="action-btn btn-deposit">' +
                        '<i class="fas fa-donate"></i>Deposit' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/cust-history?custid=' + custmer.id + '" target="_blank" class="action-btn btn-history">' +
                        '<i class="fas fa-list-ol"></i>History' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/update-customer/' + custmer.id + '" class="action-btn btn-edit">' +
                        '<i class="fas fa-edit"></i>Edit' +
                    '</a>' +
                '</div>';

            cardContainer.appendChild(card);
        });

        // Update card counter
        updateCardCounter();
    }

    // Helper function to format numbers with commas
    function formatNumber(num) {
        if (num === null || num === undefined) return '0';
        return parseFloat(num).toLocaleString('en-IN');
    }

    // Helper function to update card counter
    function updateCardCounter() {
        var cards = document.querySelectorAll('.customer-card');
        var counter = document.getElementById('cardCounter');
        if (counter) {
            counter.textContent = 'Total Customers: ' + cards.length;
        }
    }

    // Alternative version with error handling and better performance
    function renderCardsOptimized(customers) {
        if (!customers || customers.length === 0) {
            cardContainer.innerHTML = '<div class="no-customers">No customers found</div>';
            return;
        }

        // Create document fragment for better performance
        var fragment = document.createDocumentFragment();

        customers.forEach(function (custmer, index) {
            // Validate customer data
            if (!custmer || !custmer.custName) {
                console.warn('Invalid customer data at index', index);
                return;
            }

            // Generate avatar initials safely
            var nameWords = custmer.custName.trim().split(/\s+/);
            var initials = nameWords.length > 1
                ? nameWords[0].charAt(0).toUpperCase() + nameWords[1].charAt(0).toUpperCase()
                : custmer.custName.charAt(0).toUpperCase() + (custmer.custName.charAt(1) || '').toUpperCase();

            var card = document.createElement('div');
            card.className = 'customer-card';
            card.style.animationDelay = (index * 0.1) + 's';

            // Safe property access with fallbacks
            var address = custmer.address || 'Address not provided';
            var phoneNo = custmer.phoneNo || '';
            var totalAmount = custmer.totalAmount || 0;
            var paidAmount = custmer.paidAmout || custmer.paidAmount || 0;
            var currentOusting = custmer.currentOusting || custmer.balance || 0;

            card.innerHTML =
                '<div class="card-header">' +
                    '<div class="customer-avatar">' + initials + '</div>' +
                    '<h3 class="customer-name">' + escapeHtml(custmer.custName) + '</h3>' +
                '</div>' +

                '<div class="card-content">' +
                    '<div class="info-item">' +
                        '<div class="info-icon address-icon">' +
                            '<i class="fas fa-map-marker-alt"></i>' +
                        '</div>' +
                        '<span class="info-text" title="' + escapeHtml(address) + '">' +
                            truncateText(address, 50) +
                        '</span>' +
                    '</div>' +

                    '<div class="info-item">' +
                        '<div class="info-icon phone-icon">' +
                            '<i class="fab fa-whatsapp"></i>' +
                        '</div>' +
                        (phoneNo ?
                            '<a href="https://wa.me/' + phoneNo + '" target="_blank" class="whatsapp-link">' +
                                '<span class="info-text">' + phoneNo + '</span>' +
                            '</a>' :
                            '<span class="info-text">No phone number</span>'
                        ) +
                    '</div>' +
                '</div>' +

                '<div class="amount-section">' +
                    '<div class="amount-card total-card">' +
                        '<div class="amount-label">Total</div>' +
                        '<div class="amount-value">₹' + formatNumber(totalAmount) + '</div>' +
                    '</div>' +
                    '<div class="amount-card paid-card">' +
                        '<div class="amount-label">Paid</div>' +
                        '<div class="amount-value">₹' + formatNumber(paidAmount) + '</div>' +
                    '</div>' +
                    '<div class="amount-card balance-card">' +
                        '<div class="amount-label">Balance</div>' +
                        '<div class="amount-value">₹' + formatNumber(currentOusting) + '</div>' +
                    '</div>' +
                '</div>' +

                '<div class="action-buttons">' +
                    '<a href="' + contextPath + '/company/get-cust-by-id?custid=' + custmer.id + '" class="action-btn btn-invoice">' +
                        '<i class="fas fa-file-invoice"></i>Invoice' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/get-bal-credit-page/' + custmer.id + '" class="action-btn btn-deposit">' +
                        '<i class="fas fa-donate"></i>Deposit' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/cust-history?custid=' + custmer.id + '" target="_blank" class="action-btn btn-history">' +
                        '<i class="fas fa-list-ol"></i>History' +
                    '</a>' +
                    '<a href="' + contextPath + '/company/update-customer/' + custmer.id + '" class="action-btn btn-edit">' +
                        '<i class="fas fa-edit"></i>Edit' +
                    '</a>' +
                '</div>';

            fragment.appendChild(card);
        });

        // Clear container and append all cards at once
        cardContainer.innerHTML = '';
        cardContainer.appendChild(fragment);

        // Update card counter
        updateCardCounter();
    }

    // Utility functions
    function escapeHtml(text) {
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function truncateText(text, maxLength) {
        if (text.length <= maxLength) return text;
        return text.substring(0, maxLength) + '...';
    }

    // CSS for no customers message
    var noCustomersStyle = `
        .no-customers {
            grid-column: 1 / -1;
            text-align: center;
            padding: 3rem;
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.2rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            backdrop-filter: blur(10px);
        }
    `;

    // Add the style to the page if it doesn't exist
    if (!document.getElementById('no-customers-style')) {
        var style = document.createElement('style');
        style.id = 'no-customers-style';
        style.textContent = noCustomersStyle;
        document.head.appendChild(style);
    }


    searchInput.addEventListener('input', function () {
        const query = this.value.trim();
        clearTimeout(debounceTimer);

        if (!query) {
            location.href = contextPath + '/company/get-all-customers';
            return;
        }
        if (query.length < 2) return;

        debounceTimer = setTimeout(() => {
            showLoader();
            fetch(contextPath + '/company/search?query=' + encodeURIComponent(query))
                .then(res => res.json())
                .then(data => {
                    hideLoader();
                    if (!data || data.length === 0) {
                        cardContainer.innerHTML = '<div class="col-12 text-center text-muted">🙁 No matching customers found</div>';
                        paginationContainer.style.display = 'none';
                        return;
                    }
                    renderCards(data);
                    paginationContainer.style.display = 'none';
                })
                .catch(() => hideLoader());
        }, 300);
    });


    function showLoader() {
        var loader = document.getElementById('pageLoader');
        if (loader) {
            loader.style.display = 'flex';
        }
    }

    function hideLoader() {
        var loader = document.getElementById('pageLoader');
        if (loader) {
            loader.style.display = 'none';
        }
    }

    // Example usage: show loader on page load, then hide after 2 seconds
    window.addEventListener('load', function () {
        showLoader();
        setTimeout(hideLoader, 2000); // Hide after 2 seconds
    });

    function confirmLogout(event) {
        event.preventDefault();

        // Optional: Add confirmation dialog
        if (confirm('Are you sure you want to logout?')) {
            performLogout();
        }
    }

    function performLogout() {
        try {
            const logoutForm = document.getElementById('logoutForm');
            if (logoutForm) {
                // Show loading state (optional)
                const logoutBtn = event.target;
                const originalText = logoutBtn.innerHTML;
                logoutBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Logging out...';
                logoutBtn.style.pointerEvents = 'none';

                // Submit the form
                logoutForm.submit();
            } else {
                console.error('Logout form not found');
                // Fallback: redirect to logout URL
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        } catch (error) {
            console.error('Logout failed:', error);
            // Fallback logout
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    }

    // Alternative simpler version without confirmation
    function simpleLogout() {
        try {
            const logoutForm = document.forms['logoutForm'] || document.getElementById('logoutForm');
            if (logoutForm) {
                logoutForm.submit();
            } else {
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        } catch (error) {
            console.error('Logout error:', error);
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    }

       // Theme Toggle Script
        function toggleTheme() {
            const body = document.body;
            const icon = document.getElementById('theme-icon');
            const isDark = body.getAttribute('data-theme') === 'dark';
            body.setAttribute('data-theme', isDark ? 'light' : 'dark');
            icon.classList.toggle('fa-sun', isDark);
            icon.classList.toggle('fa-moon', !isDark);

            // Save theme preference
            localStorage.setItem('theme', isDark ? 'light' : 'dark');
        }
</script>
</body>
</html>