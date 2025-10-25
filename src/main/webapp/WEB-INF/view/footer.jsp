<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Enhanced Adaptive Footer -->
<footer class="footer mt-auto py-3 text-center border-top">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-4 text-md-start text-center mb-2 mb-md-0">
                <span class="footer-text">
                    &copy; <%= java.time.Year.now() %> <strong>MyBillingSystem</strong>
                </span>
            </div>
            <div class="col-md-4 text-center mb-2 mb-md-0">
                <small class="footer-subtext">
                    Designed & Developed by
                    <a href="#" class="footer-link fw-semibold text-decoration-none">Deepak</a>
                </small>
            </div>
            <div class="col-md-4 text-md-end text-center">
                <small class="text-muted">
                    <i class="fas fa-code me-1"></i>v1.0.0
                </small>
            </div>
        </div>
    </div>
</footer>

<!-- Hidden Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
</form>

<!-- jQuery (MUST load before DataTables) -->
<!-- jQuery FIRST -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- Bootstrap Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- DataTables core -->
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

<!-- Export Dependencies (must load BEFORE Buttons HTML5 export) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>

<!-- Buttons + Responsive Extensions -->
<script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.colVis.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.5.0/js/responsive.bootstrap5.min.js"></script>

<!-- Optional: Select2 & Chart.js ONLY if needed on this page -->
<!-- <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script> -->
<!-- <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script> -->

<!-- Custom App Logic -->
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>





<!-- Footer Styling -->
<style>
    /* Base Footer Styles */
    .footer {
        transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        font-size: 0.9rem;
        box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
    }

    /* Light Theme */
    [data-theme="light"] .footer {
        background-color: #f8f9fa;
        color: #555;
        border-top: 1px solid #dee2e6;
    }

    [data-theme="light"] .footer-text {
        color: #333;
    }

    [data-theme="light"] .footer-link {
        color: #0d6efd;
        transition: color 0.2s ease;
    }

    [data-theme="light"] .footer-link:hover {
        color: #0a58ca;
        text-decoration: underline;
    }

    [data-theme="light"] .footer-subtext {
        color: #6c757d;
    }

    /* Dark Theme */
    [data-theme="dark"] .footer {
        background-color: #1e293b;
        color: #bbb;
        border-top: 1px solid #334155;
    }

    [data-theme="dark"] .footer-text {
        color: #e2e8f0;
    }

    [data-theme="dark"] .footer-text strong {
        color: #fff;
    }

    [data-theme="dark"] .footer-link {
        color: #66b2ff;
        transition: color 0.2s ease;
    }

    [data-theme="dark"] .footer-link:hover {
        color: #91d0ff;
        text-decoration: underline;
    }

    [data-theme="dark"] .footer-subtext {
        color: #94a3b8;
    }

    /* Responsive Adjustments */
    @media (max-width: 768px) {
        .footer {
            font-size: 0.8rem;
        }

        .footer .row > div {
            margin-bottom: 0.5rem;
        }

        .footer .row > div:last-child {
            margin-bottom: 0;
        }
    }

    /* Animation on Hover */
    .footer-link {
        position: relative;
        display: inline-block;
    }

    .footer-link::after {
        content: '';
        position: absolute;
        width: 0;
        height: 2px;
        bottom: -2px;
        left: 50%;
        background-color: currentColor;
        transition: all 0.3s ease;
        transform: translateX(-50%);
    }

    .footer-link:hover::after {
        width: 100%;
    }

    /* Icon Styling */
    .footer i {
        opacity: 0.7;
        transition: opacity 0.2s ease;
    }

    .footer i:hover {
        opacity: 1;
    }
</style>

<!-- Core JavaScript Functions -->
<script>
    // Prevent script loading errors
    window.addEventListener('error', function(e) {
        if (e.target.tagName === 'SCRIPT') {
            console.warn('Script loading error:', e.target.src);
        }
    });

    // Initialize on DOM ready
    document.addEventListener('DOMContentLoaded', function() {
        console.log('MyBillingSystem initialized successfully');

        // Initialize tooltips if Bootstrap is loaded
        if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        }

        // Add smooth scroll behavior
        document.documentElement.style.scrollBehavior = 'smooth';
    });

    // Enhanced logout function
    function confirmLogout(event) {
        event.preventDefault();

        if (confirm('Are you sure you want to logout?')) {
            const logoutForm = document.getElementById('logoutForm');
            if (logoutForm) {
                // Show loading indicator
                const loadingHTML = '<div class="position-fixed top-50 start-50 translate-middle" style="z-index: 9999;">' +
                    '<div class="spinner-border text-primary" role="status">' +
                    '<span class="visually-hidden">Logging out...</span></div></div>';
                document.body.insertAdjacentHTML('beforeend', loadingHTML);

                // Submit form
                logoutForm.submit();
            } else {
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        }
    }

    // Global error handler
    window.addEventListener('unhandledrejection', function(event) {
        console.error('Unhandled promise rejection:', event.reason);
    });

    // Performance monitoring (optional)
    if ('performance' in window) {
        window.addEventListener('load', function() {
            setTimeout(function() {
                const perfData = window.performance.timing;
                const pageLoadTime = perfData.loadEventEnd - perfData.navigationStart;
                console.log('Page load time:', pageLoadTime + 'ms');
            }, 0);
        });
    }
</script>

<!-- Deferred Non-Critical Scripts -->
<script defer>
    // Add back-to-top button functionality
    (function() {
        const backToTopBtn = document.createElement('button');
        backToTopBtn.innerHTML = '<i class="fas fa-arrow-up"></i>';
        backToTopBtn.className = 'btn btn-primary rounded-circle position-fixed';
        backToTopBtn.style.cssText = 'bottom: 80px; right: 20px; width: 45px; height: 45px; display: none; z-index: 999; box-shadow: 0 4px 12px rgba(0,0,0,0.15);';
        backToTopBtn.setAttribute('aria-label', 'Back to top');

        document.body.appendChild(backToTopBtn);

        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                backToTopBtn.style.display = 'block';
            } else {
                backToTopBtn.style.display = 'none';
            }
        });

        backToTopBtn.addEventListener('click', function() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    })();
</script>