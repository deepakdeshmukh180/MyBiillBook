<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">


<jsp:include page="../view/logo.jsp"></jsp:include>
    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4 mt-4">

                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Page Title -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="h3 mb-0 text-gray-800">All Invoices</h2>
                    <div class="d-none d-sm-inline-block">
                        <span class="text-muted">Total: ${totalInvoices} invoices</span>
                    </div>
                </div>

                <!-- Search Section -->
                <div class="row mb-4">
                    <div class="col-md-10 mx-auto">
                        <div class="input-group">
                            <input type="text" id="searchBox" class="form-control"
                                   placeholder="Search invoices by customer name or phone...">
                            <button class="btn btn-outline-secondary" type="button" onclick="location.reload();">
                                <i class="fas fa-sync-alt me-1"></i> Refresh
                            </button>
                            <button class="btn btn-outline-danger" type="button" onclick="clearSearch();">
                                <i class="fas fa-times me-1"></i> Clear
                            </button>
                        </div>
                    </div>
                </div>
                 <c:if test="${totalPages > 1}">
                                    <div id="paginationContainer" class="d-flex justify-content-center mt-4">
                                        <nav>
                                            <ul class="pagination">
                                                <c:if test="${page > 0}">
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                           href="${pageContext.request.contextPath}/company/get-all-invoices?page=${page - 1}">
                                                            <i class="fas fa-chevron-left"></i> Previous
                                                        </a>
                                                    </li>
                                                </c:if>

                                                <c:forEach begin="${page - 2 < 0 ? 0 : page - 2}"
                                                           end="${page + 2 >= totalPages ? totalPages - 1 : page + 2}" var="i">
                                                    <li class="page-item ${page == i ? 'active' : ''}">
                                                        <a class="page-link"
                                                           href="${pageContext.request.contextPath}/company/get-all-invoices?page=${i}">
                                                            ${i + 1}
                                                        </a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${page < totalPages - 1}">
                                                    <li class="page-item">
                                                        <a class="page-link"
                                                           href="${pageContext.request.contextPath}/company/get-all-invoices?page=${page + 1}">
                                                            Next <i class="fas fa-chevron-right"></i>
                                                        </a>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </nav>
                                    </div>
                                </c:if>

                <!-- Loading Indicator -->
                <div id="loader" class="text-center my-4" style="display: none;">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="text-muted mt-2">Searching invoices...</p>
                </div>

                <!-- Invoice Cards -->
                <!-- Alternative approach using conditional classes directly -->

                <!-- Invoice Cards -->
                <div id="invoiceCardsContainer" class="row g-3">
                    <c:choose>
                        <c:when test="${empty invoices}">
                            <div class="col-12">
                                <div class="no-invoices">
                                    <i class="fas fa-file-invoice fa-3x mb-3 text-muted"></i>
                                    <h5>No Invoices Found</h5>
                                    <p class="text-muted">Create your first invoice to get started.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="invoice" items="${invoices}">
                                <div class="col-12 col-sm-6 col-lg-4 col-xl-3">
                                    <div class="card invoice-card shadow-soft ${invoice.invoiceType eq 'CREDIT' ? 'credit' : (invoice.invoiceType eq 'PARTIAL' ? 'partial' : (invoice.invoiceType eq 'PAID' ? 'paid' : ''))}"
                                         onclick="window.open('${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}', '_blank')">
                                        <div class="card-body d-flex flex-column">
                                            <!-- Header -->
                                            <div class="invoice-header">
                                                <a href="${pageContext.request.contextPath}/company/get-invoice/${invoice.custId}/${invoice.invoiceId}"
                                                   class="invoice-number" target="_blank" onclick="event.stopPropagation()">
                                                    #${invoice.invoiceId}
                                                </a>
                                                <p class="customer-name">${invoice.custName}</p>
                                            </div>

                                            <!-- Amount Grid -->
                                            <div class="amount-grid">
                                                <div class="amount-item">
                                                    <div class="amount-label">Invoice</div>
                                                    <div class="amount-value">₹<fmt:formatNumber value="${invoice.totInvoiceAmt}" type="number" minFractionDigits="2" /></div>
                                                </div>
                                                <div class="amount-item">
                                                    <div class="amount-label">Balance</div>
                                                    <div class="amount-value">₹<fmt:formatNumber value="${invoice.balanceAmt}" type="number" minFractionDigits="2" /></div>
                                                </div>
                                                <div class="amount-item">
                                                    <div class="amount-label">Discount</div>
                                                    <div class="amount-value">₹<fmt:formatNumber value="${invoice.discount}" type="number" minFractionDigits="2" /></div>
                                                </div>
                                                <div class="amount-item">
                                                    <div class="amount-label">Paid</div>
                                                    <div class="amount-value">₹<fmt:formatNumber value="${invoice.advanAmt}" type="number" minFractionDigits="2" /></div>
                                                </div>
                                            </div>

                                            <!-- Footer -->
                                            <div class="status-footer">
                                                <span class="qty-badge">
                                                    <i class="fas fa-boxes me-1"></i>${invoice.totQty} items
                                                </span>

                                                <span class="badge ${invoice.invoiceType eq 'CREDIT' ? 'bg-danger' : (invoice.invoiceType eq 'PARTIAL' ? 'bg-warning text-dark' : (invoice.invoiceType eq 'PAID' ? 'bg-success' : 'bg-secondary'))}">
                                                    ${invoice.invoiceType}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination -->

            </div>
        </main>
    </div>
</div>

<!-- Hidden Logout Form -->
<!-- Enhanced logout form with better CSRF handling -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
</form>

<jsp:include page="../view/footer.jsp"></jsp:include>


<script>

// Enhanced logout function with confirmation and error handling
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

    // Load saved theme on page load
    document.addEventListener('DOMContentLoaded', function() {
        const savedTheme = localStorage.getItem('theme') || 'light';
        document.body.setAttribute('data-theme', savedTheme);
        const icon = document.getElementById('theme-icon');
        icon.classList.toggle('fa-sun', savedTheme === 'dark');
        icon.classList.toggle('fa-moon', savedTheme === 'light');

        // Initialize search functionality
        initializeSearch();

        // Initialize sidebar
        initializeSidebar();

        // Add loading animation for cards
        animateCards();
    });

    // Search functionality
    function initializeSearch() {
        const searchInput = document.getElementById('searchBox');
        const cardContainer = document.getElementById('invoiceCardsContainer');
        const paginationContainer = document.getElementById('paginationContainer');
        const loader = document.getElementById('loader');

        if (!searchInput || !cardContainer) {
            console.error('Search elements not found');
            return;
        }

        // Store original content
        const originalCards = cardContainer.innerHTML;
        const originalPagination = paginationContainer ? paginationContainer.innerHTML : '';

        let timeoutId;

        searchInput.addEventListener('input', function () {
            clearTimeout(timeoutId);
            timeoutId = setTimeout(() => {
                const query = searchInput.value.trim();

                if (query.length === 0) {
                    resetToOriginal();
                    return;
                }

                if (query.length < 2) return;

                performSearch(query);
            }, 500);
        });

        function resetToOriginal() {
            cardContainer.innerHTML = originalCards;
            if (paginationContainer) {
                paginationContainer.innerHTML = originalPagination;
                paginationContainer.style.display = 'flex';
            }
            loader.style.display = 'none';
        }

        function performSearch(query) {
            loader.style.display = 'block';
            cardContainer.innerHTML = '';

            if (paginationContainer) {
                paginationContainer.style.display = 'none';
            }

            const contextPath = getContextPath();
            const searchUrl = contextPath + '/search-invoices?query=' + encodeURIComponent(query);

            // Use fetch API with fallback to XMLHttpRequest
            if (window.fetch) {
                fetch(searchUrl, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    credentials: 'same-origin'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    loader.style.display = 'none';
                    handleSearchSuccess(data);
                })
                .catch(error => {
                    loader.style.display = 'none';
                    console.error('Search error:', error);
                    handleSearchError('Search failed: ' + error.message);
                });
            } else {
                // Fallback for older browsers
                const xhr = new XMLHttpRequest();
                xhr.open('GET', searchUrl, true);
                xhr.setRequestHeader('Content-Type', 'application/json');
                xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        loader.style.display = 'none';

                        if (xhr.status === 200) {
                            try {
                                const data = JSON.parse(xhr.responseText);
                                handleSearchSuccess(data);
                            } catch (e) {
                                console.error('Error parsing JSON:', e);
                                handleSearchError('Invalid response format');
                            }
                        } else {
                            handleSearchError('Server error: ' + xhr.status);
                        }
                    }
                };

                xhr.onerror = function() {
                    loader.style.display = 'none';
                    handleSearchError('Network error occurred');
                };

                xhr.send();
            }
        }

        function handleSearchSuccess(data) {
            if (!data || data.length === 0) {
                showNoResults();
            } else {
                displaySearchResults(data);
            }
        }

        function handleSearchError(errorMessage) {
            cardContainer.innerHTML =
                '<div class="col-12">' +
                    '<div class="text-center text-danger mt-4">' +
                        '<i class="fas fa-exclamation-triangle fa-2x mb-3"></i>' +
                        '<h5>Error loading invoices</h5>' +
                        '<p>' + errorMessage + '</p>' +
                        '<button class="btn btn-primary btn-sm mt-2" onclick="clearSearch()">' +
                            '<i class="fas fa-refresh me-1"></i> Try Again' +
                        '</button>' +
                    '</div>' +
                '</div>';
        }

        function showNoResults() {
            cardContainer.innerHTML =
                '<div class="col-12">' +
                    '<div class="text-center text-muted mt-4">' +
                        '<i class="fas fa-search fa-2x mb-3"></i>' +
                        '<h5>No invoices found</h5>' +
                        '<p>Try adjusting your search terms.</p>' +
                        '<button class="btn btn-outline-primary btn-sm mt-2" onclick="clearSearch()">' +
                            '<i class="fas fa-times me-1"></i> Clear Search' +
                        '</button>' +
                    '</div>' +
                '</div>';
        }

        function displaySearchResults(invoices) {
            var cardsHtml = '';
            for (var i = 0; i < invoices.length; i++) {
                cardsHtml += renderInvoiceCard(invoices[i]);
            }
            cardContainer.innerHTML = cardsHtml;

            // Animate new cards
            setTimeout(function() {
                var newCards = cardContainer.querySelectorAll('.invoice-card');
                for (var j = 0; j < newCards.length; j++) {
                    (function(index, card) {
                        setTimeout(function() {
                            card.style.opacity = '1';
                            card.style.transform = 'translateY(0)';
                        }, index * 50);
                    })(j, newCards[j]);
                }
            }, 100);
        }

        // Make functions globally accessible
        window.clearSearch = function() {
            searchInput.value = '';
            resetToOriginal();
            searchInput.focus();
        };

        window.resetToOriginal = resetToOriginal;
        window.performSearch = performSearch;
    }

    function renderInvoiceCard(invoice) {
        var contextPath = getContextPath();
        var cardClass = '';
        var badgeClass = 'bg-secondary';

        switch(invoice.invoiceType) {
            case 'CREDIT':
                cardClass = 'credit';
                badgeClass = 'bg-danger';
                break;
            case 'PARTIAL':
                cardClass = 'partial';
                badgeClass = 'bg-warning text-dark';
                break;
            case 'PAID':
                cardClass = 'paid';
                badgeClass = 'bg-success';
                break;
        }

        function formatAmount(amount) {
            return parseFloat(amount || 0).toFixed(2);
        }

        function escapeHtml(text) {
            var div = document.createElement('div');
            div.textContent = text || '';
            return div.innerHTML;
        }

        return '<div class="col-12 col-sm-6 col-lg-4 col-xl-3">' +
                   '<div class="card invoice-card shadow-soft ' + cardClass + '"' +
                        ' onclick="window.open(\'' + contextPath + '/get-invoice/' + invoice.custId + '/' + invoice.invoiceId + '\', \'_blank\')"' +
                        ' style="opacity: 0; transform: translateY(20px); transition: all 0.3s ease;">' +
                       '<div class="card-body d-flex flex-column">' +
                           '<div class="invoice-header">' +
                               '<a href="' + contextPath + '/get-invoice/' + invoice.custId + '/' + invoice.invoiceId + '"' +
                                  ' class="invoice-number" target="_blank" onclick="event.stopPropagation()">' +
                                   '#' + (invoice.invoiceId || 'N/A') +
                               '</a>' +
                               '<p class="customer-name">' + escapeHtml(invoice.custName || 'N/A') + '</p>' +
                           '</div>' +
                           '<div class="amount-grid">' +
                               '<div class="amount-item">' +
                                   '<div class="amount-label">Invoice</div>' +
                                   '<div class="amount-value">₹' + formatAmount(invoice.totInvoiceAmt) + '</div>' +
                               '</div>' +
                               '<div class="amount-item">' +
                                   '<div class="amount-label">Balance</div>' +
                                   '<div class="amount-value">₹' + formatAmount(invoice.balanceAmt) + '</div>' +
                               '</div>' +
                               '<div class="amount-item">' +
                                   '<div class="amount-label">Discount</div>' +
                                   '<div class="amount-value">₹' + formatAmount(invoice.discount) + '</div>' +
                               '</div>' +
                               '<div class="amount-item">' +
                                   '<div class="amount-label">Paid</div>' +
                                   '<div class="amount-value">₹' + formatAmount(invoice.advanAmt) + '</div>' +
                               '</div>' +
                           '</div>' +
                           '<div class="status-footer">' +
                               '<span class="qty-badge">' +
                                   '<i class="fas fa-boxes me-1"></i>' + (invoice.totQty || 0) + ' items' +
                               '</span>' +
                               '<span class="badge ' + badgeClass + '">' +
                                   (invoice.invoiceType || 'UNKNOWN') +
                               '</span>' +
                           '</div>' +
                       '</div>' +
                   '</div>' +
               '</div>';
    }



    // Utility functions
    function getContextPath() {
        var contextPath = '${pageContext.request.contextPath}';
        if (contextPath && contextPath !== '$' + '{pageContext.request.contextPath}') {
            return contextPath;
        }

        var pathArray = window.location.pathname.split('/');
        return pathArray.length > 1 ? '/' + pathArray[1] : '';
    }

    function animateCards() {
        var cards = document.querySelectorAll('.invoice-card');
        for (var i = 0; i < cards.length; i++) {
            (function(index, card) {
                setTimeout(function() {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            })(i, cards[i]);
        }
    }

    // Notification function
    function openNotifications() {
        console.log('Opening notifications...');
        // Implement notification logic here
    }

    // Error handling
    document.addEventListener('error', function(e) {
        if (e.target.tagName === 'IMG') {
            e.target.style.display = 'none';
        }
    }, true);

    // Network status handling
    window.addEventListener('online', function() {
        console.log('Network connection restored');
    });

    window.addEventListener('offline', function() {
        console.log('Network connection lost');
        var loader = document.getElementById('loader');
        if (loader && loader.style.display === 'block') {
            loader.style.display = 'none';
            var cardContainer = document.getElementById('invoiceCardsContainer');
            if (cardContainer) {
                cardContainer.innerHTML =
                    '<div class="col-12">' +
                        '<div class="text-center text-warning mt-4">' +
                            '<i class="fas fa-wifi fa-2x mb-3"></i>' +
                            '<h5>Connection Lost</h5>' +
                            '<p>Please check your internet connection and try again.</p>' +
                        '</div>' +
                    '</div>';
            }
        }
    });
</script>
</body>
</html>