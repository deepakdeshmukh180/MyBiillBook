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
            <div class="container-fluid px-4 py-4">

                <!-- Success Alert -->
                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert" id="success-alert">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>Success!</strong> ${msg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="mb-1">Daily Expenses</h2>
                        <p class="text-muted mb-0">Track and manage your business expenses</p>
                    </div>
                </div>

                <!-- KPI Cards -->
                <div class="row g-3 mb-4">
                    <!-- Today's Expenses -->
                    <div class="col-md-6 col-lg-4">
                        <div class="kpi d-flex justify-content-between align-items-center p-3 shadow-sm rounded-3 bg-white">
                            <div>
                                <div class="text-muted small mb-1">Today's Expenses</div>
                                <div class="fw-bold fs-4">
                                    ₹<fmt:formatNumber value="${daily_expenses}" type="number" minFractionDigits="2"/>
                                </div>
                            </div>
                            <div class="icon bg-primary-subtle text-primary rounded-circle p-3">
                                <i class="fas fa-calendar-day fa-lg"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Monthly Expenses -->
                    <div class="col-md-6 col-lg-4">
                        <div class="kpi d-flex justify-content-between align-items-center p-3 shadow-sm rounded-3 bg-white">
                            <div>
                                <div class="text-muted small mb-1">Monthly Expenses</div>
                                <div class="fw-bold fs-4">
                                    ₹<fmt:formatNumber value="${monthly_expenses}" type="number" minFractionDigits="2"/>
                                </div>
                            </div>
                            <div class="icon bg-success-subtle text-success rounded-circle p-3">
                                <i class="fas fa-calendar-alt fa-lg"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Yearly Expenses -->
                    <div class="col-md-6 col-lg-4">
                        <div class="kpi d-flex justify-content-between align-items-center p-3 shadow-sm rounded-3 bg-white">
                            <div>
                                <div class="text-muted small mb-1">Yearly Expenses</div>
                                <div class="fw-bold fs-4">
                                    ₹<fmt:formatNumber value="${yearly_expenses}" type="number" minFractionDigits="2"/>
                                </div>
                            </div>
                            <div class="icon bg-warning-subtle text-warning rounded-circle p-3">
                                <i class="fas fa-calendar fa-lg"></i>
                            </div>
                        </div>
                    </div>
                </div>


                <!-- Add Expense & Filter -->
                <div class="row g-3 mb-4">
                    <div class="col-lg-6">
                        <div class="card card-modern">
                            <div class="card-header">
                                <i class="fas fa-plus me-2"></i>Add New Expense
                            </div>
                            <div class="card-body">
                                <form method="post" action="${pageContext.request.contextPath}/expenses/add">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label">Date</label>
                                            <input type="date" name="date" class="form-control"
                                                   value="<fmt:formatDate value='${today}' pattern='yyyy-MM-dd'/>" required/>
                                        </div>
                                        <div class="col-md-5">
                                            <label class="form-label">Expense Name</label>
                                            <input type="text" name="expenseName" class="form-control"
                                                   maxlength="100" placeholder="Enter expense name" required/>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">Amount (₹)</label>
                                            <input type="number" name="amount" class="form-control"
                                                   step="0.01" min="0" placeholder="0.00" required/>
                                        </div>
                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-2"></i>Save Expense
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="card card-modern">
                            <div class="card-header">
                                <i class="fas fa-filter me-2"></i>Filter Expenses
                            </div>
                            <div class="card-body">
                                <form method="get" action="${pageContext.request.contextPath}/expenses">
                                    <div class="row g-3">
                                        <div class="col-md-8">
                                            <label class="form-label">Filter by Date</label>
                                            <input type="date" name="date" class="form-control"
                                                   value="<fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd'/>"/>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label d-block">&nbsp;</label>
                                            <button class="btn btn-primary w-100" type="submit">
                                                <i class="fas fa-search me-2"></i>Apply
                                            </button>
                                        </div>
                                        <div class="col-12">
                                            <a class="btn btn-outline-secondary w-100" href="${pageContext.request.contextPath}/expenses">
                                                <i class="fas fa-redo me-2"></i>Reset Filter
                                            </a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Expense List & Chart -->
                <div class="row g-3">
                    <div class="col-lg-6">
                        <div class="card card-modern">
                            <div class="card-header">
                                <i class="fas fa-table me-2"></i>Expense List
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th style="width: 50px;">#</th>
                                                <th>Date</th>
                                                <th>Expense</th>
                                                <th class="text-end">Amount (₹)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:set var="total" value="0"/>
                                            <c:forEach items="${expenses}" var="e" varStatus="vs">
                                                <tr>
                                                    <td>${vs.index + 1}</td>
                                                    <td><fmt:formatDate value="${e.date}" pattern="dd MMM yyyy"/></td>
                                                    <td>${e.expenseName}</td>
                                                    <td class="text-end">
                                                        <fmt:formatNumber value="${e.amount}" type="number" minFractionDigits="2"/>
                                                    </td>
                                                </tr>
                                                <c:set var="total" value="${total + e.amount}"/>
                                            </c:forEach>
                                            <c:if test="${empty expenses}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-4">
                                                        <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                                                        No expenses found
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <th colspan="3" class="text-end">Total</th>
                                                <th class="text-end">
                                                    <fmt:formatNumber value="${total}" type="number" minFractionDigits="2"/>
                                                </th>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="card card-modern">
                            <div class="card-header">
                                <i class="fas fa-chart-bar me-2"></i>Monthly Expense Overview
                            </div>
                            <div class="card-body">
                                <canvas id="monthlyExpenseChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="py-4 bg-light mt-auto">
            <div class="container-fluid px-4">
                <div class="d-flex align-items-center justify-content-between small">
                    <div class="text-muted">Copyright &copy; BillMatePro 2025</div>
                    <div>
                        <a href="#" class="text-muted">Privacy Policy</a>
                        &middot;
                        <a href="#" class="text-muted">Terms &amp; Conditions</a>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</div>

<!-- Logout Form -->
<form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout" style="display: none;">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/scripts.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // Hide page loader
    setTimeout(() => {
        const loader = document.getElementById('pageLoader');
        if (loader) loader.classList.add('hidden');
    }, 800);

    // Auto-hide success alert
    const successAlert = document.getElementById('success-alert');
    if (successAlert) {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(successAlert);
            bsAlert.close();
        }, 3500);
    }



    // Theme toggle
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.body.setAttribute('data-theme', savedTheme);
    updateThemeIcon(savedTheme);

    // Monthly Expense Chart
    const ctx = document.getElementById('monthlyExpenseChart');
    if (ctx) {
        const chartData = {
            labels: [
                <c:forEach var="m" items="${monthlyExpenses}" varStatus="vs">
                    '<c:out value="${m.month}"/>'<c:if test="${!vs.last}">,</c:if>
                </c:forEach>
            ],
            datasets: [{
                label: 'Total Expenses',
                data: [
                    <c:forEach var="m" items="${monthlyExpenses}" varStatus="vs">
                        <c:out value="${m.totalAmount}"/><c:if test="${!vs.last}">,</c:if>
                    </c:forEach>
                ],
                backgroundColor: 'rgba(34, 71, 165, 0.7)',
                borderColor: 'rgba(34, 71, 165, 1)',
                borderWidth: 2,
                borderRadius: 8,
                barThickness: 40
            }]
        };

        new Chart(ctx.getContext('2d'), {
            type: 'bar',
            data: chartData,
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        padding: 12,
                        borderRadius: 8,
                        callbacks: {
                            label: function(context) {
                                return '₹' + context.parsed.y.toLocaleString('en-IN', {
                                    minimumFractionDigits: 2,
                                    maximumFractionDigits: 2
                                });
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)'
                        },
                        ticks: {
                            callback: function(value) {
                                return '₹' + value.toLocaleString('en-IN');
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            callback: function(value, index) {
                                const label = this.getLabelForValue(index);
                                const [year, month] = label.split('-');
                                const date = new Date(year, month - 1);
                                return date.toLocaleDateString('en-US', {
                                    month: 'short',
                                    year: 'numeric'
                                });
                            }
                        }
                    }
                }
            }
        });
    }
});

// Theme toggle function
function toggleTheme() {
    const currentTheme = document.body.getAttribute('data-theme');
    const newTheme = currentTheme === 'light' ? 'dark' : 'light';

    document.body.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    updateThemeIcon(newTheme);
}

function updateThemeIcon(theme) {
    const icon = document.getElementById('theme-icon');
    if (icon) {
        icon.className = theme === 'light' ? 'fas fa-moon' : 'fas fa-sun';
    }
}
</script>
</body>
</html>