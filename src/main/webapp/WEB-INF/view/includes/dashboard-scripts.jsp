<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Chart.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
// Global variables
let currentPage = 'dashboard';
let sidebarOpen = false;
let charts = {}; // Store chart instances
window.dashboardCharts = {};

// DOM elements
const sidebar = document.getElementById('sidebar');
const mainContent = document.getElementById('mainContent');
const sidebarToggle = document.getElementById('sidebarToggle');
const sidebarOverlay = document.getElementById('sidebarOverlay');
const themeToggle = document.getElementById('themeToggle');
const pageTitle = document.getElementById('pageTitle');

// Initialize app
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, initializing app...');
    initializeTheme();
    initializeNavigation();
    initializeNotifications();
    // Delay chart initialization to ensure DOM is ready
    setTimeout(initializeCharts, 100);

    // Check screen size on load
    if (window.innerWidth > 768) {
        toggleSidebar(true);
    }
});

// Theme functionality
function initializeTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.body.setAttribute('data-theme', savedTheme);
    updateThemeIcon(savedTheme);
}

function toggleTheme() {
    const currentTheme = document.body.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';

    document.body.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    updateThemeIcon(newTheme);
}

function updateThemeIcon(theme) {
    const icon = themeToggle.querySelector('i');
    icon.className = theme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
}

// Navigation functionality
function initializeNavigation() {
    // Sidebar toggle
    sidebarToggle.addEventListener('click', () => toggleSidebar());
    sidebarOverlay.addEventListener('click', () => toggleSidebar(false));

    // Theme toggle
    themeToggle.addEventListener('click', toggleTheme);

    // Nav links
    const navLinks = document.querySelectorAll('[data-page]');
    console.log('Found nav links:', navLinks.length);

    navLinks.forEach((link, index) => {
        console.log('Setting up nav link:', link.getAttribute('data-page'));
        link.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            const page = link.getAttribute('data-page');
            console.log('Navigating to:', page);
            navigateToPage(page);

            // Close sidebar on mobile after navigation
            if (window.innerWidth <= 768) {
                toggleSidebar(false);
            }
        });
    });

    // Handle window resize
    window.addEventListener('resize', () => {
        if (window.innerWidth > 768) {
            sidebarOverlay.classList.remove('active');
        } else if (sidebarOpen) {
            sidebarOverlay.classList.add('active');
        }
    });
}

function toggleSidebar(force) {
    if (typeof force === 'boolean') {
        sidebarOpen = force;
    } else {
        sidebarOpen = !sidebarOpen;
    }

    sidebar.classList.toggle('active', sidebarOpen);

    if (window.innerWidth > 768) {
        mainContent.classList.toggle('sidebar-open', sidebarOpen);
        sidebarOverlay.classList.remove('active');
    } else {
        mainContent.classList.remove('sidebar-open');
        sidebarOverlay.classList.toggle('active', sidebarOpen);
    }

    // Update toggle icon
    const icon = sidebarToggle.querySelector('i');
    icon.className = sidebarOpen ? 'fas fa-times' : 'fas fa-bars';
}

// Navigation function
function navigateToPage(page) {
    console.log('Navigating from', currentPage, 'to', page);

    // Hide ALL page sections first
    const allSections = document.querySelectorAll('.page-section');
    allSections.forEach(section => {
        section.classList.remove('active');
        section.style.display = 'none';
    });

    // Show new page
    const newSection = document.getElementById(page);
    if (newSection) {
        newSection.style.display = 'block';
        newSection.classList.add('active');
        console.log('Showing section:', page);
    } else {
        console.error('Section not found:', page);
        return;
    }

    // Update nav links
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
    });

    const currentNavLink = document.querySelector(`[data-page="${page}"]`);
    if (currentNavLink) {
        currentNavLink.classList.add('active');
    }

    // Update page title
    const titles = {
        dashboard: 'Dashboard',
        customers: 'Customers',
        invoices: 'Invoices',
        products: 'Products',
        expenses: 'Daily Expenses',
        reports: 'Reports',
        analytics: 'Analytics',
        profile: 'Account Settings',
        export: 'Export Data'
    };
    pageTitle.textContent = titles[page] || 'Dashboard';

    currentPage = page;

    // Reinitialize charts when navigating to pages with charts
    setTimeout(() => {
        if (page === 'dashboard' || page === 'reports' || page === 'analytics') {
            initializeChartsForPage(page);
        }
    }, 50);
}

// Charts initialization
function initializeCharts() {
    console.log('Initializing charts...');
    initializeChartsForPage('dashboard');
}

function initializeChartsForPage(page) {
    console.log('Initializing charts for page:', page);

    if (page === 'dashboard') {
        initializeDashboardCharts();
    } else if (page === 'reports') {
        initializeReportsCharts();
    } else if (page === 'analytics') {
        initializeAnalyticsCharts();
    }
}

function initializeDashboardCharts() {
    // Revenue Chart
    const revenueCtx = document.getElementById('revenueChart');
    if (revenueCtx) {
        if (charts.revenue) {
            charts.revenue.destroy();
        }

        charts.revenue = new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Revenue',
                    data: [120000, 150000, 180000, 140000, 200000, 250000],
                    borderColor: '#2247a5',
                    backgroundColor: 'rgba(34, 71, 165, 0.1)',
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#2247a5',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '₹' + (value / 1000) + 'K';
                            }
                        }
                    }
                }
            }
        });

        // Store in global object for access from other functions
        window.dashboardCharts.revenue = charts.revenue;
    }

    // Payment Chart
    const paymentCtx = document.getElementById('paymentChart');
    if (paymentCtx) {
        if (charts.payment) {
            charts.payment.destroy();
        }

        charts.payment = new Chart(paymentCtx, {
            type: 'doughnut',
            data: {
                labels: ['Total Amt', 'Paid', 'Balance'],
                datasets: [{
                    data: [${totalAmount}, ${paidAmount}, ${currentOutstanding}],
                    backgroundColor: ['#10b981', '#f59e0b', '#ef4444'],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '60%',
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }
}

function initializeReportsCharts() {
    const monthlyRevenueCtx = document.getElementById('monthlyRevenueChart');
    if (monthlyRevenueCtx) {
        if (charts.monthlyRevenue) {
            charts.monthlyRevenue.destroy();
        }

        charts.monthlyRevenue = new Chart(monthlyRevenueCtx, {
            type: 'bar',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: '2024',
                    data: [120000, 150000, 180000, 140000, 200000, 250000],
                    backgroundColor: 'rgba(34, 71, 165, 0.8)',
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '₹' + (value / 1000) + 'K';
                            }
                        }
                    }
                }
            }
        });
    }
}

function initializeAnalyticsCharts() {
    const salesTrendCtx = document.getElementById('salesTrendChart');
    if (salesTrendCtx) {
        if (charts.salesTrend) {
            charts.salesTrend.destroy();
        }

        charts.salesTrend = new Chart(salesTrendCtx, {
            type: 'line',
            data: {
                labels: ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'],
                datasets: [{
                    label: 'Sales',
                    data: [180000, 190000, 175000, 210000, 225000, 250000],
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '₹' + (value / 1000) + 'K';
                            }
                        }
                    }
                }
            }
        });
    }

    const paymentMethodsCtx = document.getElementById('paymentMethodsChart');
    if (paymentMethodsCtx) {
        if (charts.paymentMethods) {
            charts.paymentMethods.destroy();
        }

        charts.paymentMethods = new Chart(paymentMethodsCtx, {
            type: 'pie',
            data: {
                labels: ['Cash', 'UPI', 'Card', 'Bank Transfer'],
                datasets: [{
                    data: [40, 35, 15, 10],
                    backgroundColor: ['#2247a5', '#10b981', '#f59e0b', '#ef4444'],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }
}

// Notification System
function initializeNotifications() {
    // Create notification container if it doesn't exist
    if (!document.getElementById('notificationContainer')) {
        const container = document.createElement('div');
        container.id = 'notificationContainer';
        container.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            max-width: 400px;
        `;
        document.body.appendChild(container);
    }
}

function showNotification(message, type = 'info', duration = 5000) {
    const container = document.getElementById('notificationContainer');
    const notification = document.createElement('div');

    const typeClasses = {
        success: 'alert-success',
        error: 'alert-danger',
        warning: 'alert-warning',
        info: 'alert-info'
    };

    const icons = {
        success: 'fas fa-check-circle',
        error: 'fas fa-exclamation-circle',
        warning: 'fas fa-exclamation-triangle',
        info: 'fas fa-info-circle'
    };

    notification.className = `alert ${typeClasses[type]} alert-dismissible fade show`;
    notification.style.cssText = `
        margin-bottom: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        border: none;
        border-radius: 12px;
    `;

    notification.innerHTML = `
        <i class="${icons[type]} me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;

    container.appendChild(notification);

    // Auto-remove after duration
    setTimeout(() => {
        if (notification.parentNode) {
            notification.classList.remove('show');
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 150);
        }
    }, duration);
}

// Utility functions
function logout() {
    if (confirm('Are you sure you want to logout?')) {
        window.location.href = '${pageContext.request.contextPath}/logout';
    }
}

// Parallax effect for floating shapes
let ticking = false;
function updateParallax() {
    const scrolled = window.pageYOffset;
    const shapes = document.querySelectorAll('.floating-shape');

    shapes.forEach((shape, index) => {
        const speed = 0.3 + (index * 0.1);
        const yPos = -(scrolled * speed);
        shape.style.transform = `translate3d(0, ${yPos}px, 0)`;
    });

    ticking = false;
}

window.addEventListener('scroll', function() {
    if (!ticking) {
        requestAnimationFrame(updateParallax);
        ticking = true;
    }
});

// Cleanup on page unload
window.addEventListener('beforeunload', function() {
    Object.values(charts).forEach(chart => {
        if (chart && typeof chart.destroy === 'function') {
            chart.destroy();
        }
    });
});

// Expose global functions
window.navigateToPage = navigateToPage;
window.showNotification = showNotification;
window.logout = logout;
</script>