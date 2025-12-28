<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Dashboard - BillMatePro</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>

<!-- Google Font -->
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"/>

<!-- Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css"/>

<!-- DataTables CSS + Extensions -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css"/>
<link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.bootstrap5.min.css"/>

<!-- Select2 CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css"/>

<!-- Custom Styles -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css"/>

<style>

/* ===================================
   UNIFIED CSS DESIGN SYSTEM
   Clean, Modern, & Reusable for All Pages
   =================================== */

/* ===================================
   ROOT VARIABLES
   =================================== */
:root {
  /* Primary Colors */
  --primary-color: #2247a5;
  --primary-dark: #145fa0;
  --primary-light: rgba(34, 71, 165, 0.1);

  /* Status Colors */
  --success-color: #10b981;
  --success-light: rgba(16, 185, 129, 0.1);
  --danger-color: #ef4444;
  --danger-light: rgba(239, 68, 68, 0.1);
  --warning-color: #f59e0b;
  --warning-light: rgba(245, 158, 11, 0.1);
  --info-color: #3b82f6;
  --info-light: rgba(59, 130, 246, 0.1);
  --secondary-color: #6b7280;

  /* Border Radius */
  --radius-sm: 8px;
  --radius-md: 12px;
  --radius-lg: 16px;
  --radius-xl: 20px;
  --radius-full: 50rem;

  /* Shadows */
  --shadow-xs: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-sm: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  --shadow-md: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
  --shadow-xl: 0 32px 64px -12px rgba(0, 0, 0, 0.25);

  /* Transitions */
  --transition-fast: 0.15s ease;
  --transition-base: 0.2s ease;
  --transition-slow: 0.3s ease;

  /* Glass Effects */
  --glass-bg: rgba(255, 255, 255, 0.1);
  --glass-border: rgba(255, 255, 255, 0.2);
}

/* ===================================
   THEME VARIABLES
   =================================== */
[data-theme="light"] {
  --bg-color: #f8fafc;
  --bg-secondary: #f1f5f9;
  --text-color: #1e293b;
  --text-secondary: #64748b;
  --card-bg: #ffffff;
  --border-color: #e2e8f0;
  --border-hover: #cbd5e1;
}

[data-theme="dark"] {
  --bg-color: #0f172a;
  --bg-secondary: #1e293b;
  --text-color: #f1f5f9;
  --text-secondary: #94a3b8;
  --card-bg: #1e293b;
  --border-color: #334155;
  --border-hover: #475569;
}

/* ===================================
   GLOBAL RESET & BASE STYLES
   =================================== */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  background-color: var(--bg-color);
  color: var(--text-color);
  min-height: 100vh;
  transition: background-color var(--transition-base), color var(--transition-base);
  overflow-x: hidden;
  line-height: 1.6;
}

/* Animated Background Gradient */
body::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--success-color) 100%);
  opacity: 0.03;
  z-index: -2;
  pointer-events: none;
}

/* ===================================
   FLOATING SHAPES ANIMATION
   =================================== */
.floating-shape {
  position: fixed;
  border-radius: 50%;
  background: linear-gradient(45deg, var(--primary-color), var(--success-color));
  opacity: 0.08;
  animation: float 6s ease-in-out infinite;
  z-index: -1;
  pointer-events: none;
}

.floating-shape:nth-child(1) {
  width: 80px;
  height: 80px;
  top: 20%;
  left: 10%;
  animation-delay: 0s;
}

.floating-shape:nth-child(2) {
  width: 120px;
  height: 120px;
  top: 60%;
  right: 10%;
  animation-delay: -2s;
}

.floating-shape:nth-child(3) {
  width: 60px;
  height: 60px;
  top: 80%;
  left: 20%;
  animation-delay: -4s;
}

.floating-shape:nth-child(4) {
  width: 100px;
  height: 100px;
  top: 10%;
  right: 25%;
  animation-delay: -3s;
}

@keyframes float {
  0%, 100% { transform: translateY(0px) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(180deg); }
}

/* ===================================
   CARD COMPONENTS
   =================================== */
.card-modern {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  transition: all var(--transition-base);
  overflow: hidden;
  position: relative;
}

.card-modern:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
  border-color: var(--border-hover);
}

.card-modern::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
  opacity: 0;
  transition: opacity var(--transition-base);
}

.card-modern:hover::before {
  opacity: 1;
}

.card-modern .card-body {
  padding: 1.5rem;
}

/* Enhanced Card with Gradient */
.enhanced-card {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-xl);
  backdrop-filter: blur(20px);
  box-shadow: var(--shadow-lg);
  transition: all var(--transition-slow) cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
  position: relative;
}

.enhanced-card:hover {
  transform: translateY(-8px);
  box-shadow: var(--shadow-xl);
}

/* ===================================
   KPI & STAT CARDS
   =================================== */
.kpi-card {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  overflow: hidden;
  position: relative;
}

.kpi-card::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
  transition: left 0.6s;
}

.kpi-card:hover {
  transform: translateY(-12px) scale(1.02);
  box-shadow: var(--shadow-xl);
}

.kpi-card:hover::after {
  left: 100%;
}

.kpi-mini {
  position: relative;
  overflow: hidden;
  border-radius: var(--radius-md);
}

.kpi-mini.primary {
  border-left: 4px solid var(--primary-color);
}

.kpi-mini.success {
  border-left: 4px solid var(--success-color);
}

.kpi-mini.danger {
  border-left: 4px solid var(--danger-color);
}

.kpi-mini.warning {
  border-left: 4px solid var(--warning-color);
}

.kpi-icon {
  width: 64px;
  height: 64px;
  border-radius: var(--radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  background: linear-gradient(45deg, var(--primary-color), var(--primary-dark));
  color: white;
  box-shadow: 0 8px 16px rgba(34, 71, 165, 0.3);
}

/* ===================================
   WELCOME & HERO CARDS
   =================================== */
.welcome-card {
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
  color: white;
  border-radius: var(--radius-xl);
  border: none;
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(20px);
  box-shadow: var(--shadow-lg);
}

.welcome-card::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -50%;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 70%);
  pointer-events: none;
}

/* ===================================
   ITEM CARDS (INVOICE ITEMS)
   =================================== */
.item-card-wrapper {
  transition: all var(--transition-base);
}

.item-card {
  border: 2px solid var(--border-color);
  border-radius: var(--radius-md);
  transition: all var(--transition-base);
  position: relative;
  overflow: hidden;
  background: var(--card-bg);
}

.item-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--info-color));
  transform: scaleX(0);
  transform-origin: left;
  transition: transform var(--transition-base);
}

.item-card:hover {
  border-color: var(--primary-color);
  box-shadow: var(--shadow-md);
  transform: translateY(-4px);
}

.item-card:hover::before {
  transform: scaleX(1);
}

/* Compact Invoice & Customer Cards */
.customer-card,
.invoice-card {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: 0.9rem 1rem;
  transition: var(--transition-base);
  box-shadow: var(--shadow-xs);
  font-size: 0.82rem;
}

/* Hover Lift Effect Reduced */
.customer-card:hover,
.invoice-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-sm);
}

/* Header */
.invoice-header {
  margin-bottom: 0.4rem;
}

.invoice-number {
  font-size: 0.85rem;
  font-weight: 600;
}

.customer-name {
  font-size: 0.85rem;
  font-weight: 600;
  opacity: 0.85;
  margin: 0;
  line-height: 1.1;
}


/* Amount Section */
.amount-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 0.25rem;
  margin: 0.4rem 0;
}

.amount-item {
  text-align: center;
}

.amount-label {
  font-size: 0.65rem;
  opacity: 0.75;
}

.amount-value {
  font-size: 0.82rem;
  font-weight: 700;
}

/* Footer Section */
.status-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 0.3rem;
}

.qty-badge {
  font-size: 0.7rem;
  opacity: 0.75;
}

/* Status Badge */
.badge {
  font-size: 0.65rem;
  padding: 0.25em 0.45em;
  border-radius: var(--radius-sm);
}

/* State Colors */
.invoice-card.paid {
  border-left: 3px solid var(--success-color);
}

.invoice-card.partial {
  border-left: 3px solid var(--warning-color);
}

.invoice-card.credit {
  border-left: 3px solid var(--danger-color);
}

.customer-avatar {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background: linear-gradient(45deg, var(--primary-color), var(--success-color));
  color: #fff;
  font-size: 0.95rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  text-transform: uppercase;
  box-shadow: 0 2px 8px rgba(34, 71, 165, 0.25);
}


/* Very small devices adjustments */
@media (max-width: 480px) {
  .amount-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

 /* ===================================
    EXPENSE CARDS
    =================================== */
 .expense-item {
   background: var(--card-bg);
   border: 1px solid var(--border-color);
   border-radius: var(--radius-lg);
   border-left: 4px solid var(--danger-color);
   box-shadow: var(--shadow-xs);
   transition: transform var(--transition-base),
               box-shadow var(--transition-base);
 }

 .expense-item:hover {
   transform: translateX(6px);
   box-shadow: var(--shadow-md);
 }

 /* Expense Icon */
 .expense-icon {
   width: 40px;
   height: 40px;
   border-radius: var(--radius-md);
   background: linear-gradient(45deg, var(--danger-color), #e74c3c);
   color: #fff;
   display: flex;
   align-items: center;
   justify-content: center;
   box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
 }

 /* ===================================
    CHART CARDS
    =================================== */
 .chart-card {
   background: var(--card-bg);
   border: 1px solid var(--border-color);
   border-radius: var(--radius-xl);
   backdrop-filter: blur(20px);
   box-shadow: var(--shadow-md);
   transition: transform var(--transition-base),
               box-shadow var(--transition-base);
 }

 .chart-card:hover {
   transform: translateY(-4px);
   box-shadow: var(--shadow-xl);
 }

/* ===================================
   FILTER & SECTION HEADERS
   =================================== */
.filter-header {
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
  color: white;
  padding: 1rem 1.5rem;
  font-weight: 600;
  font-size: 1.1rem;
  border-radius: var(--radius-lg) var(--radius-lg) 0 0;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.section-header {
  position: relative;
  padding: 1.5rem;
  background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
  border-radius: var(--radius-lg) var(--radius-lg) 0 0;
  color: white;
}

.section-title {
  font-weight: 700;
  color: white;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.section-subtitle {
  color: var(--primary-color);
  font-weight: 600;
  margin-bottom: 1.5rem;
  padding-bottom: 0.5rem;
  border-bottom: 2px solid var(--primary-color);
}

/* ===================================
   FORM ELEMENTS
   =================================== */
.form-control,
.form-select,
.form-control-modern,
.form-select-modern {
  background: var(--card-bg);
  border: 2px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: 0.75rem 1rem;
  font-size: 1rem;
  color: var(--text-color);
  transition: all var(--transition-fast);
  width: 100%;
}

.form-control:focus,
.form-select:focus,
.form-control-modern:focus,
.form-select-modern:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px var(--primary-light);
  outline: none;
  background: var(--card-bg);
  color: var(--text-color);
}

.form-control::placeholder,
.form-control-modern::placeholder {
  color: var(--text-secondary);
  opacity: 0.7;
}

.form-control[readonly] {
  background: var(--bg-secondary);
  cursor: not-allowed;
  opacity: 0.7;
}

.form-label,
.form-label-modern {
  font-weight: 600;
  color: var(--text-color);
  margin-bottom: 0.5rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.9rem;
}

.form-label-modern i {
  color: var(--primary-color);
}

/* Input with Icon */
.input-group {
  position: relative;
}

.input-icon {
  position: absolute;
  left: 1rem;
  top: 50%;
  transform: translateY(-50%);
  color: var(--primary-color);
  z-index: 10;
  font-size: 1.1rem;
}

.form-control.with-icon {
  padding-left: 3rem;
}

/* Checkbox Group */
.checkbox-group {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.checkbox-item {
  display: flex;
  align-items: center;
  padding: 0.75rem 1.25rem;
  border: 2px solid var(--border-color);
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: all var(--transition-base);
  background: var(--card-bg);
}

.checkbox-item:hover {
  border-color: var(--primary-color);
  background: var(--primary-light);
}

.checkbox-item.checked {
  border-color: var(--primary-color);
  background: var(--primary-light);
}

.checkbox-item input[type="checkbox"] {
  width: 18px;
  height: 18px;
  margin-right: 0.5rem;
  cursor: pointer;
  accent-color: var(--primary-color);
}

/* ===================================
   BUTTONS
   =================================== */
.btn {
  border-radius: var(--radius-md);
  padding: 0.75rem 1.5rem;
  font-weight: 600;
  font-size: 0.95rem;
  transition: all var(--transition-fast);
  border: 2px solid transparent;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.btn:hover {
  transform: translateY(-2px);
}

.btn-modern {
  border-radius: var(--radius-md);
  padding: 0.75rem 1.5rem;
  font-weight: 600;
  transition: all var(--transition-base);
  border: none;
}

.btn-primary,
.btn-outline-primary {
  background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
  color: white;
  border: none;
  box-shadow: 0 4px 15px rgba(34, 71, 165, 0.3);
}

.btn-outline-warning {
  background: transparent;
  border: 2px solid #ffc107;
  color: var(--primary-color);
  box-shadow: none;
}


.btn-outline-primary {
  background: transparent;
  border: 2px solid var(--primary-color);
  color: var(--primary-color);
  box-shadow: none;
}

.btn-outline-primary:hover {
  background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
  color: white;
  box-shadow: 0 6px 20px rgba(34, 71, 165, 0.4);
}

.btn-success,
.btn-outline-success,
.btn-deposit,
.btn-save {
  background: linear-gradient(135deg, var(--success-color), #059669);
  color: white;
  border: none;
  box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
}

.btn-outline-success {
  background: transparent;
  border: 2px solid var(--success-color);
  color: var(--success-color);
  box-shadow: none;
}

.btn-outline-success:hover {
  background: linear-gradient(135deg, var(--success-color), #059669);
  color: white;
  box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
}

.btn-danger,
.btn-outline-danger {
  background: linear-gradient(135deg, var(--danger-color), #dc2626);
  color: white;
  border: none;
  box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
}

.btn-outline-danger {
  background: transparent;
  border: 2px solid var(--danger-color);
  color: var(--danger-color);
  box-shadow: none;
}

.btn-outline-danger:hover {
  background: linear-gradient(135deg, var(--danger-color), #dc2626);
  color: white;
  box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4);
}

.btn-xs {
  padding: 0.375rem 0.75rem;
  font-size: 0.8rem;
}

.btn-loading {
  position: relative;
  color: transparent !important;
  pointer-events: none;
}

.btn-loading::after {
  content: '';
  position: absolute;
  width: 16px;
  height: 16px;
  top: 50%;
  left: 50%;
  margin-left: -8px;
  margin-top: -8px;
  border: 2px solid currentColor;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spinner 0.6s linear infinite;
}

@keyframes spinner {
  to { transform: rotate(360deg); }
}

/* Action Buttons */
.action-buttons {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 0.5rem;
}

.action-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.6rem;
  border-radius: var(--radius-sm);
  text-decoration: none;
  font-size: 0.85rem;
  font-weight: 500;
  transition: all var(--transition-base);
  border: 1px solid transparent;
}

.btn-invoice {
  background: var(--primary-light);
  color: var(--primary-color);
  border-color: rgba(34, 71, 165, 0.2);
}

.btn-deposit {
  background: var(--success-light);
  color: var(--success-color);
  border-color: rgba(16, 185, 129, 0.2);
}

.btn-history {
  background: var(--warning-light);
  color: var(--warning-color);
  border-color: rgba(245, 158, 11, 0.2);
}

.btn-edit {
  background: rgba(139, 69, 19, 0.1);
  color: #8b4513;
  border-color: rgba(139, 69, 19, 0.2);
}

.action-btn:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-sm);
}

/* ===================================
   TABLES
   =================================== */
.table {
  background-color: var(--card-bg);
  color: var(--text-color);
  border-color: var(--border-color);
}

.table thead th {
  background: linear-gradient(135deg, #475569, #334155);
  color: white;
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.85rem;
  letter-spacing: 0.5px;
  padding: 1rem;
  border: none;
}

.table tbody tr {
  transition: background-color var(--transition-fast);
  border-bottom: 1px solid var(--border-color);
}

.table tbody tr:hover {
  background: var(--primary-light);
}

.table tbody td {
  padding: 1rem;
  vertical-align: middle;
  color: var(--text-color);
}

.table-success thead {
  background: linear-gradient(135deg, var(--success-color) 0%, #059669 100%);
  color: white;
}

.table-primary thead {
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
  color: white;
}

.table-modern {
  border-radius: var(--radius-md);
  overflow: hidden;
}

.table-bordered {
  border: 1px solid var(--border-color);
}

.table-striped tbody tr:nth-of-type(odd) {
  background-color: var(--bg-secondary);
}

/* Amount Display */
.amount-box {
  background: var(--card-bg);
  border: 2px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: 0.875rem 1.25rem;
  font-weight: 700;
  font-size: 1.125rem;
  text-align: right;
  transition: all var(--transition-base);
}

.amount-box:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px var(--primary-light);
}

.amount-section,
.amount-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 0.75rem;
}

.amount-card {
  text-align: center;
  padding: 0.75rem;
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  background: var(--card-bg);
}

.total-card {
  background: var(--primary-light);
  border-color: rgba(34, 71, 165, 0.2);
}

.paid-card {
  background: var(--success-light);
  border-color: rgba(16, 185, 129, 0.2);
}

.balance-card {
  background: var(--warning-light);
  border-color: rgba(245, 158, 11, 0.2);
}

.amount-label {
  font-size: 0.75rem;
  font-weight: 500;
  color: var(--text-secondary);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 0.25rem;
}

.amount-value {
  font-size: 0.75rem;
  font-weight: 700;
  color: var(--text-color);
}

.amount-total {
  color: var(--primary-color);
}

.amount-paid {
  color: var(--success-color);
}

.amount-balance {
  color: var(--danger-color);
}

/* ===================================
   ALERTS & NOTIFICATIONS
   =================================== */
.alert {
  border: none;
  border-radius: var(--radius-md);
  padding: 1rem 1.5rem;
  border-left: 4px solid;
  box-shadow: var(--shadow-sm);
  animation: slideInDown 0.3s ease-out;
}

.alert-modern {
  backdrop-filter: blur(20px);
  animation: slideInRight 0.5s ease;
}

.alert-success {
  border-left-color: var(--success-color);
  background: var(--success-light);
  color: var(--success-color);
}

.alert-warning {
  border-left-color: var(--warning-color);
  background: var(--warning-light);
  color: #92400e;
}

.alert-danger {
  border-left-color: var(--danger-color);
  background: var(--danger-light);
  color: var(--danger-color);
}

.alert-info {
  border-left-color: var(--info-color);
  background: var(--info-light);
  color: var(--info-color);
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

@keyframes slideInRight {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

/* ===================================
   BADGES & TAGS
   =================================== */
.badge-modern {
  padding: 6px 12px;
  border-radius: var(--radius-full);
  font-weight: 500;
  font-size: 0.75rem;
  backdrop-filter: blur(10px);
}

.status-badge {
  display: inline-block;
  padding: 0.5rem 1rem;
  background: var(--success-color);
  color: white;
  border-radius: var(--radius-sm);
  font-weight: 500;
  text-transform: uppercase;
  font-size: 0.875rem;
}

.qty-badge {
  background: var(--bg-secondary);
  color: var(--text-color);
  padding: 4px 8px;
  border-radius: var(--radius-full);
  font-size: 0.8rem;
  font-weight: 500;
}

/* ===================================
   TABS & NAVIGATION
   =================================== */
.nav-tabs {
  border-bottom: 2px solid var(--border-color);
}

.nav-tabs .nav-link {
  border: none;
  color: var(--text-secondary);
  font-weight: 600;
  padding: 1rem 1.5rem;
  transition: all var(--transition-fast);
  position: relative;
  background: transparent;
}

.nav-tabs .nav-link::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: var(--primary-color);
  transform: scaleX(0);
  transition: transform var(--transition-base);
}

.nav-tabs .nav-link:hover {
  color: var(--primary-color);
  background: transparent;
}

.nav-tabs .nav-link.active {
  color: var(--primary-color);
  background: transparent;
  border: none;
}

.nav-tabs .nav-link.active::after {
  transform: scaleX(1);
}

.tab-content {
  padding: 1.5rem 0;
}

/* ===================================
   MODAL STYLES - FIXED BLINKING
   =================================== */
.modal {
  z-index: 1050 !important;
}

.modal-backdrop {
  z-index: 1040 !important;
  transition: opacity 0.15s linear !important;
}

.modal-backdrop.fade {
  opacity: 0;
}

.modal-backdrop.show {
  opacity: 0.5;
}

.modal.fade .modal-dialog {
  transition: transform 0.2s ease-out !important;
  transform: translate(0, -50px);
}

.modal.show .modal-dialog {
  transform: none !important;
}

.modal-content {
  border: none;
  border-radius: var(--radius-xl);
  background: var(--card-bg);
  backdrop-filter: blur(20px);
  box-shadow: var(--shadow-xl);
  -webkit-backface-visibility: hidden;
  backface-visibility: hidden;
  transform: translateZ(0);
}

.modal-header {
  background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
  color: white;
  border-radius: var(--radius-xl) var(--radius-xl) 0 0;
  padding: 1.5rem;
  border-bottom: none;
}

.modal-header .modal-title {
  font-weight: 600;
  font-size: 1.5rem;
}

.modal-header .btn-close {
  filter: brightness(0) invert(1);
  opacity: 0.8;
}

.modal-header .btn-close:hover {
  opacity: 1;
}

.modal-body {
  padding: 2rem;
  color: var(--text-color);
}

.modal-footer {
  padding: 1.5rem;
  border-top: 2px solid var(--border-color);
  background: var(--bg-secondary);
  border-radius: 0 0 var(--radius-xl) var(--radius-xl);
}

/* ===================================
   NAVIGATION & SIDEBAR
   =================================== */
.sb-topnav {
  background: var(--card-bg);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid var(--border-color);
  box-shadow: var(--shadow-sm);
  transition: all var(--transition-base);
}

.sb-topnav .navbar-brand img {
  filter: drop-shadow(0 4px 15px rgba(34, 71, 165, 0.2));
  transition: all var(--transition-base);
}

.sb-topnav .navbar-brand img:hover {
  transform: scale(1.05);
  filter: drop-shadow(0 8px 25px rgba(34, 71, 165, 0.3));
}

.sb-sidenav {
  background: var(--card-bg);
  backdrop-filter: blur(20px);
  border-right: 1px solid var(--border-color);
}

.sb-sidenav .nav-link {
  color: var(--text-color);
  border-radius: var(--radius-md);
  margin: 0.25rem 1rem;
  transition: all var(--transition-base);
  padding: 0.75rem 1rem;
}

.sb-sidenav .nav-link:hover {
  background: var(--glass-bg);
  backdrop-filter: blur(10px);
  transform: translateX(4px);
}

.sb-sidenav .nav-link.active {
  background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
  color: white;
}

/* ===================================
   THEME TOGGLE
   =================================== */
.theme-toggle {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: var(--card-bg);
  border: 2px solid var(--border-color);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all var(--transition-base);
  z-index: 1000;
  box-shadow: var(--shadow-lg);
}

.theme-toggle:hover {
  transform: scale(1.1) rotate(15deg);
  box-shadow: var(--shadow-xl);
}

.theme-toggle i {
  font-size: 1.5rem;
  color: var(--primary-color);
}

/* ===================================
   SELECT2 INTEGRATION
   =================================== */
.select2-container--default .select2-selection--single {
  border: 2px solid var(--border-color);
  border-radius: var(--radius-md);
  height: auto;
  padding: 0.625rem 1rem;
  background-color: var(--card-bg);
  transition: all var(--transition-fast);
}

.select2-container--default.select2-container--focus .select2-selection--single {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px var(--primary-light);
}

.select2-dropdown {
  border: 2px solid var(--border-color);
  border-radius: var(--radius-md);
  background-color: var(--card-bg);
  box-shadow: var(--shadow-lg);
}

.select2-results__option {
  color: var(--text-color);
  padding: 0.75rem 1rem;
}

.select2-results__option--highlighted {
  background-color: var(--primary-color) !important;
  color: white !important;
}

.select2-container--default .select2-results__option--selected {
  background-color: var(--bg-secondary);
}

/* ===================================
   DATATABLES INTEGRATION
   =================================== */
.dataTables_wrapper {
  padding: 0;
}

.dataTables_wrapper .dataTables_length,
.dataTables_wrapper .dataTables_filter {
  margin-bottom: 1rem;
}

.dataTables_wrapper .dataTables_length select,
.dataTables_wrapper .dataTables_filter input {
  background: var(--card-bg);
  border: 2px solid var(--border-color);
  border-radius: var(--radius-sm);
  padding: 0.5rem 0.75rem;
  color: var(--text-color);
  transition: all var(--transition-fast);
}

.dataTables_wrapper .dataTables_filter input:focus {
  border-color: var(--primary-color);
  outline: none;
  box-shadow: 0 0 0 3px var(--primary-light);
}

table.dataTable {
  border-collapse: collapse;
  width: 100%;
}

table.dataTable thead th {
  background: linear-gradient(135deg, #475569, #334155);
  color: white;
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.8rem;
  letter-spacing: 0.5px;
  padding: 1rem;
  border: none;
}

table.dataTable tbody tr {
  transition: all var(--transition-fast);
  border-bottom: 1px solid var(--border-color);
}

table.dataTable tbody tr:hover {
  background: var(--primary-light);
}

table.dataTable tbody td {
  padding: 1rem;
  color: var(--text-color);
  vertical-align: middle;
}

/* Pagination */
.pagination {
  display: flex;
  gap: 0.25rem;
}

.pagination .page-link {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  color: var(--text-color);
  border-radius: var(--radius-sm);
  padding: 0.5rem 0.875rem;
  transition: all var(--transition-fast);
}

.pagination .page-link:hover {
  background: var(--primary-color);
  border-color: var(--primary-color);
  color: white;
  transform: translateY(-2px);
}

.pagination .page-item.active .page-link {
  background: var(--primary-color);
  border-color: var(--primary-color);
  color: white;
}

.pagination .page-item.disabled .page-link {
  opacity: 0.5;
  cursor: not-allowed;
}

/* ===================================
   HISTORY & TRANSACTION SECTIONS
   =================================== */
.history-section {
  margin-top: 2rem;
}

.history-header {
  background: linear-gradient(135deg, #475569, #334155);
  color: white;
  padding: 1.25rem 1.5rem;
  border-radius: var(--radius-lg) var(--radius-lg) 0 0;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.history-header i {
  font-size: 1.5rem;
}

.history-header h5 {
  margin: 0;
  font-weight: 600;
  font-size: 1.25rem;
}

.history-body {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-top: none;
  border-radius: 0 0 var(--radius-lg) var(--radius-lg);
  padding: 1.5rem;
}

.transaction-link {
  color: var(--primary-color);
  text-decoration: none;
  font-weight: 600;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  transition: all var(--transition-base);
}

.transaction-link:hover {
  color: var(--primary-dark);
  transform: translateX(4px);
}

.transaction-link i {
  font-size: 1.1rem;
}

/* ===================================
   INVOICE & RECEIPT SPECIFIC
   =================================== */
.invoice-summary {
  position: relative;
  overflow: visible;
}

.invoice-summary::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color), var(--success-color), var(--primary-color));
  background-size: 200% 100%;
  animation: gradient-shift 3s ease infinite;
}

@keyframes gradient-shift {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

.summary-title {
  color: var(--text-color);
  font-weight: 700;
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.summary-title i {
  color: var(--primary-color);
  font-size: 1.75rem;
}

.invoice-header {
  border-bottom: 1px solid var(--border-color);
  padding-bottom: 12px;
  margin-bottom: 12px;
}

.invoice-number {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--primary-color);
  text-decoration: none;
  transition: color var(--transition-fast);
}

.invoice-number:hover {
  color: var(--primary-dark);
}

.deposit-form-section {
  background: linear-gradient(135deg, var(--primary-light), var(--success-light));
  border-radius: var(--radius-lg);
  padding: 2rem;
  margin-top: 2rem;
  border: 2px dashed var(--border-color);
}

/* ===================================
   QR CODE & SPECIAL ELEMENTS
   =================================== */
.qr-section {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 1rem;
  background: var(--bg-color);
  border-radius: var(--radius-md);
  border: 2px solid var(--border-color);
}

.qr-preview {
  max-width: 200px;
  height: auto;
  border-radius: var(--radius-sm);
}

/* ===================================
   LOADER & SPINNER
   =================================== */
.block-loader {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  border-radius: var(--radius-lg);
}

[data-theme="dark"] .block-loader {
  background: rgba(15, 23, 42, 0.8);
}

.block-loader .spinner {
  width: 40px;
  height: 40px;
  border: 4px solid var(--border-color);
  border-top-color: var(--primary-color);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.spinner-border {
  width: 2rem;
  height: 2rem;
  border: 3px solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  animation: spin 0.75s linear infinite;
}

/* ===================================
   GRID LAYOUTS
   =================================== */
.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 1.5rem;
  padding: 1rem 0;
}

.amount-item {
  text-align: center;
  padding: 0.75rem;
  border-radius: var(--radius-sm);
  background: rgba(255, 255, 255, 0.7);
}

[data-theme="dark"] .amount-item {
  background: rgba(30, 41, 59, 0.7);
}

/* ===================================
   INFO ITEMS
   =================================== */
.info-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.75rem;
}

.info-icon {
  width: 32px;
  height: 32px;
  border-radius: var(--radius-sm);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  flex-shrink: 0;
}

.address-icon {
  background: var(--danger-light);
  color: var(--danger-color);
}

.phone-icon {
  background: var(--success-light);
  color: var(--success-color);
}

.info-text {
  font-size: 0.9rem;
  color: var(--text-color);
  opacity: 0.8;
  line-height: 1.3;
}

.whatsapp-link {
  text-decoration: none;
  color: inherit;
  transition: color var(--transition-base);
}

.whatsapp-link:hover {
  color: var(--success-color);
}

/* ===================================
   UTILITY CLASSES
   =================================== */
.shadow-soft {
  box-shadow: var(--shadow-md) !important;
}

.text-gradient {
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--info-color) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.no-customers,
.no-invoices {
  grid-column: 1 / -1;
  text-align: center;
  padding: 3rem;
  color: var(--text-secondary);
  font-size: 1.1rem;
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
}

/* ===================================
   ANIMATIONS
   =================================== */
.fade-in-up {
  opacity: 0;
  transform: translateY(30px);
  animation: fadeInUp 0.8s ease forwards;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.stagger-1 { animation-delay: 0.1s; }
.stagger-2 { animation-delay: 0.2s; }
.stagger-3 { animation-delay: 0.3s; }
.stagger-4 { animation-delay: 0.4s; }

/* ===================================
   CAROUSEL ENHANCEMENTS
   =================================== */
.expiry-carousel .carousel-item .card {
  border: none;
  border-radius: var(--radius-xl);
  background: rgba(255, 255, 255, 0.25);
  backdrop-filter: blur(16px);
  border-left: 6px solid var(--danger-color);
  box-shadow: 0 8px 20px rgba(0,0,0,0.15);
  transition: transform 0.35s ease, box-shadow 0.35s ease;
  overflow: hidden;
}

/* Active slide gets spotlight */
.expiry-carousel .carousel-item.active .card {
  transform: scale(1.03);
  box-shadow: 0 12px 28px rgba(220,53,69,0.4);
}

/* Header styling */
.expiry-carousel .card-header {
  padding: 0.6rem 1rem;
  font-weight: 600;
  background: linear-gradient(45deg, #dc3545, #ff6b6b);
}

/* Badge glow */
.badge-modern {
  padding: 0.45rem 0.7rem;
  font-size: 0.75rem;
  border-radius: 10px;
  animation: heartbeat 1.8s infinite;
}

@keyframes heartbeat {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.08); }
}

/* Subtle hover lift */
.expiry-carousel .carousel-item .card:hover {
  transform: translateY(-4px);
}


/* ===================================
   RESPONSIVE DESIGN
   =================================== */
@media (max-width: 1024px) {
  .cards-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 1rem;
  }
}

@media (max-width: 768px) {
  .kpi-card {
    margin-bottom: 1rem;
  }

  .customer-mini-card:hover,
  .expense-item:hover {
    transform: none;
  }

  .theme-toggle {
    bottom: 1rem;
    right: 1rem;
    width: 50px;
    height: 50px;
  }

  .cards-grid {
    grid-template-columns: 1fr;
  }

  .action-buttons {
    grid-template-columns: 1fr;
  }

  .amount-section,
  .amount-grid {
    grid-template-columns: 1fr;
    gap: 0.5rem;
  }

  .modal-body {
    padding: 1.5rem;
  }

  .filter-header {
    font-size: 1rem;
    padding: 0.875rem 1rem;
  }

  .btn {
    padding: 0.625rem 1rem;
    font-size: 0.9rem;
  }
}

@media (max-width: 576px) {
  body {
    font-size: 0.9rem;
  }

  .section-title {
    font-size: 0.75rem;
  }

  .card-modern .card-body {
    padding: 1rem;
  }

  .theme-toggle {
    width: 45px;
    height: 45px;
  }

  .theme-toggle i {
    font-size: 1.2rem;
  }
}

/* ===================================
   SMOOTH SCROLLBAR
   =================================== */
::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

::-webkit-scrollbar-track {
  background: var(--bg-secondary);
  border-radius: var(--radius-sm);
}

::-webkit-scrollbar-thumb {
  background: var(--border-color);
  border-radius: var(--radius-sm);
  transition: background var(--transition-base);
}

::-webkit-scrollbar-thumb:hover {
  background: var(--secondary-color);
}

/* ===================================
   PRINT STYLES
   =================================== */
@media print {
  .filter-header,
  .btn,
  .nav-tabs,
  .theme-toggle,
  .sidebar,
  .sb-topnav {
    display: none !important;
  }

  .card-modern {
    box-shadow: none !important;
    border: 1px solid #ddd !important;
    page-break-inside: avoid;
  }

  body {
    background: white !important;
    color: black !important;
  }

  .table thead {
    background: #f5f5f5 !important;
    color: black !important;
  }
}

/* ===================================
   ACCESSIBILITY IMPROVEMENTS
   =================================== */
.btn:focus-visible,
.form-control:focus-visible,
.nav-link:focus-visible {
  outline: 2px solid var(--primary-color);
  outline-offset: 2px;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}


</style>
</head>
<body class="sb-nav-fixed" data-theme="light">

<!-- Floating background shapes -->
<div class="floating-shape"></div>
<div class="floating-shape"></div>
<div class="floating-shape"></div>
<div class="floating-shape"></div>

<!-- Theme Toggle -->
<div class="theme-toggle" onclick="toggleTheme()" title="Toggle dark/light mode">
    <i class="fas fa-moon" id="theme-icon"></i>
</div>

<!-- Top Navbar -->
<nav class="sb-topnav navbar navbar-expand navbar-light">
    <div class="logo-container">
 <a class="navbar-brand ps-3 fw-bold" href="${pageContext.request.contextPath}/login/home">
  <img alt="" src="data:image/png;base64,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"  alt="BillMatePro" style="height: 50px; margin-right: 8px;"/>
           </a>
    </div>
    <button class="btn btn-outline-primary btn-sm ms-2" id="sidebarToggle"><i class="fas fa-bars"></i></button>

      <div class="ms-auto d-flex align-items-center gap-3 pe-3">
        <div id="notificationContainer" class="position-relative" role="button" onclick="openModal()">
          <i class="bi bi-bell fs-5 text-primary"></i>
          <span id="notificationBadge" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"></span>
        </div>




        <script>
          // Example product list
          const productList = ["Product1", "Product2"]; // Replace with your actual data
          const productCount = productList ? productList.length : 0;

          const container = document.getElementById('notificationContainer');
          const badge = document.getElementById('notificationBadge');

          if (productCount > 0) {
            badge.textContent = productCount;  // Add count to badge
          } else {
            container.style.display = 'none'; // Hide bell + badge if no items
          }


      function showLoader() {
          const loader = document.getElementById("pageLoader");
          if (loader) {
              loader.style.display = "block";
          }
      }

      function hideLoader() {
          const loader = document.getElementById("pageLoader");
          if (loader) {
              loader.style.display = "none";
          }
      }


          /* -------------------------
             1. For all <a> clicks
          -------------------------- */
          document.addEventListener("click", function(e) {
              let target = e.target.closest("a");
              if (target && target.getAttribute("href") && target.getAttribute("href") !== "#") {
                  showLoader();
              }
          });

          /* -------------------------
             2. For all form submits
          -------------------------- */
          document.addEventListener("submit", function(e) {
              showLoader();
          });

          /* -------------------------
             3. For all AJAX calls
          -------------------------- */

          // jQuery Ajax
          if (window.jQuery) {
              $(document).ajaxStart(function() {
                  showLoader();
              });

              $(document).ajaxStop(function() {
                  hideLoader();
              });
          }

          // For fetch()
          (function() {
              const origFetch = window.fetch;
              window.fetch = function() {
                  showLoader();
                  return origFetch.apply(this, arguments)
                      .finally(() => hideLoader());
              }
          })();



              // Hide loader when browser goes back (bfcache restore)
              window.addEventListener("pageshow", function (event) {
                  const loader = document.getElementById("pageLoader");

                  // Detect BACK/FORWARD navigation
                  const navEntry = performance.getEntriesByType("navigation")[0];

                  if (event.persisted || (navEntry && navEntry.type === "back_forward")) {
                      if (loader) loader.style.display = "none";
                  }
              });

        </script>
 <div class="d-flex align-items-center ms-auto">


            <!-- Example user profile dropdown -->
            <div class="dropdown">
                <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                    ${sessionScope.userName}
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                </ul>
            </div>
        </div>
       <div class="dropdown">
           <a class="nav-link dropdown-toggle text-primary" id="navbarDropdown" href="#"
              data-bs-toggle="dropdown" aria-expanded="false" role="button">
               <i class="fas fa-user fa-fw"></i>
           </a>
           <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
               <li>
                   <h6 class="dropdown-header">
                       <i class="fas fa-user-circle me-2"></i>
                       ${pageContext.request.userPrincipal.name}
                   </h6>
               </li>
               <li><hr class="dropdown-divider"></li>
               <li>
                   <a class="dropdown-item" href="${pageContext.request.contextPath}/company/get-my-profile">
                       <i class="fas fa-cog me-2"></i>Account Settings
                   </a>
               </li>
               <li>
                   <a class="dropdown-item" href="#" onclick="confirmLogout(event)">
                       <i class="fas fa-sign-out-alt me-2"></i>Logout
                   </a>
               </li>
           </ul>
       </div>
      </div>
    </nav>

    <div id="layoutSidenav">
      <!-- Sidebar -->
      <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion" id="sidenavAccordion">
          <div class="sb-sidenav-menu">
            <div class="nav">
              <div class="sb-sidenav-menu-heading">Core</div>
              <a class="nav-link active" href="${pageContext.request.contextPath}/login/home">
               <div class="sb-nav-link-icon"><i class="fas fa-home"></i></div> Home

              </a>

              <div class="sb-sidenav-menu-heading">Interface</div>
              <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts">
                <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div> Menu
                <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
              </a>
              <div class="collapse" id="collapseLayouts" data-bs-parent="#sidenavAccordion">
                <nav class="sb-sidenav-menu-nested nav">
                  <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-customers"><i class="fas fa-user-friends me-2"></i>Customers</a>
                  <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-invoices"><i class="fas fa-file-invoice me-2"></i>Invoices</a>
                  <a class="nav-link" href="${pageContext.request.contextPath}/company/reports"><i class="fas fa-chart-line me-2"></i> Reports</a>
                  <a class="nav-link" href="${pageContext.request.contextPath}/company/get-all-products"><i class="fas fa-leaf me-2"></i>Products</a>
                </nav>
              </div>

              <div class="sb-sidenav-menu-heading">Addons</div>
               <a class="nav-link" href="${pageContext.request.contextPath}/company/get-my-profile">
                                              <div class="sb-nav-link-icon"><i class="fa fa-gear fa-spin"></i></div> Settings
                                            </a>
              <a class="nav-link" href="${pageContext.request.contextPath}/company/export-to-pdf">
                <div class="sb-nav-link-icon"><i class="fas fa-file-export"></i></div> Exports
              </a>

              <a class="nav-link" href="${pageContext.request.contextPath}/expenses">
                          <div class="sb-nav-link-icon"><i class="fas fa-wallet"></i></div>Expenses
                        </a>
                         <a class="nav-link" href="${pageContext.request.contextPath}/dealers/info">
                                              <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div> Dealer
                                            </a>

            </div>
          </div>
          <div class="sb-sidenav-footer">
            <div class="small">Logged in as:</div>
            ${pageContext.request.userPrincipal.name}
          </div>
        </nav>


      </div>
</body>
</html>
