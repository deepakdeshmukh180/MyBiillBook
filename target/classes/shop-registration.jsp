<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="My Bill Book - Multi-step Registration" />
    <meta name="author" content="" />
    <title>My Bill Book - Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/resources/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.4.0/js/all.js" crossorigin="anonymous"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-gradient: linear-gradient(135deg, #3c7bff, #70a1ff);
            --secondary-gradient: linear-gradient(135deg, #667eea, #764ba2);
            --success-gradient: linear-gradient(135deg, #11998e, #38ef7d);
            --danger-gradient: linear-gradient(135deg, #ff6b6b, #ffa500);
            --card-shadow: 0 20px 40px rgba(0,0,0,0.1);
            --card-shadow-hover: 0 30px 60px rgba(0,0,0,0.15);
            --border-radius: 20px;
            --transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            overflow-x: hidden;
        }

        /* Animated background particles */
        .bg-particles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
        }

        .particle {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); opacity: 0.7; }
            50% { transform: translateY(-20px) rotate(180deg); opacity: 1; }
        }

        .container {
            max-width: 900px;
        }

        .main-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: var(--transition);
            overflow: hidden;
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp {
            from { transform: translateY(50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .main-card:hover {
            box-shadow: var(--card-shadow-hover);
            transform: translateY(-5px);
        }

        .card-header {
            background: var(--primary-gradient);
            color: white;
            padding: 2rem;
            text-align: center;
            border: none;
            position: relative;
        }

        .brand-gradient {
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            text-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .brand-subtitle {
            opacity: 0.9;
            font-weight: 300;
            font-size: 1.1rem;
        }

        .card-body {
            padding: 3rem 2.5rem;
        }

        /* Step Indicators */
        .step-indicators {
            display: flex;
            justify-content: space-between;
            margin-bottom: 3rem;
            position: relative;
        }

        .progress-line {
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            z-index: 1;
            transform: translateY(-50%);
        }

        .progress-fill {
            height: 100%;
            background: var(--primary-gradient);
            border-radius: 2px;
            transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1);
            width: 0%;
        }

        .step-indicator {
            flex: 1;
            text-align: center;
            font-size: 0.9rem;
            position: relative;
            z-index: 2;
        }

        .step-indicator .step-circle {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: #e9ecef;
            color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 0.5rem;
            font-weight: 600;
            font-size: 1.1rem;
            transition: var(--transition);
            border: 3px solid transparent;
        }

        .step-indicator.active .step-circle {
            background: var(--primary-gradient);
            color: white;
            transform: scale(1.1);
            box-shadow: 0 8px 25px rgba(60, 123, 255, 0.4);
        }

        .step-indicator.completed .step-circle {
            background: var(--success-gradient);
            color: white;
        }

        .step-indicator .step-label {
            font-weight: 500;
            color: #6c757d;
            transition: var(--transition);
        }

        .step-indicator.active .step-label {
            color: #3c7bff;
            font-weight: 600;
        }

        /* Steps */
        .step {
            display: none;
            opacity: 0;
            transform: translateX(30px);
            transition: var(--transition);
        }

        .step.active {
            display: block;
            opacity: 1;
            transform: translateX(0);
            animation: stepSlideIn 0.5s ease-out;
        }

        @keyframes stepSlideIn {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .step-header {
            font-weight: 700;
            font-size: 1.8rem;
            margin-bottom: 1.5rem;
            color: #2c3e50;
            text-align: center;
        }

        .step-header i {
            color: #3c7bff;
            margin-right: 0.5rem;
        }

        /* Form Controls */
        .form-floating {
            margin-bottom: 1.5rem;
        }

        .form-control, .form-select {
            border-radius: 15px;
            border: 2px solid #e9ecef;
            padding: 1rem 1.25rem;
            font-size: 1rem;
            transition: var(--transition);
            background: rgba(255, 255, 255, 0.8);
        }

        .form-control:focus, .form-select:focus {
            border-color: #3c7bff;
            box-shadow: 0 0 0 0.25rem rgba(60, 123, 255, 0.1);
            background: white;
            transform: translateY(-2px);
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.75rem;
        }

        .fancy-select {
            background: linear-gradient(145deg, #ffffff, #f8f9fa);
            border: 2px solid #e9ecef;
            border-radius: 15px;
            padding: 1rem 1.25rem;
            font-size: 1rem;
            transition: var(--transition);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            position: relative;
        }

        .fancy-select:focus {
            border-color: #3c7bff;
            box-shadow: 0 0 0 0.25rem rgba(60, 123, 255, 0.15), 0 8px 25px rgba(0, 0, 0, 0.1);
            outline: none;
            transform: translateY(-2px);
        }

        .fancy-select option {
            padding: 15px;
            font-size: 1rem;
            color: #333;
            background: white;
        }

        #selectedPlanText {
            font-size: 1.3rem;
            font-weight: 700;
            background: var(--success-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-align: center;
            padding: 1rem;
            border-radius: 10px;
            background-color: rgba(17, 153, 142, 0.1);
            margin-top: 1rem;
        }

        /* Buttons */
        .step-buttons {
            margin-top: 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
        }

        .btn {
            padding: 0.875rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1rem;
            transition: var(--transition);
            border: none;
            position: relative;
            overflow: hidden;
        }

        .btn:before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: var(--transition);
        }

        .btn:hover:before {
            left: 100%;
        }

        .btn-outline-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-outline-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.3);
        }

        .btn-outline-primary {
            background: var(--primary-gradient);
            color: white;
        }

        .btn-outline-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(60, 123, 255, 0.4);
        }

        .btn-outline-success {
            background: var(--success-gradient);
            color: white;
        }

        .btn-outline-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(17, 153, 142, 0.4);
        }

        /* Input Groups */
        .input-group-modern {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            z-index: 3;
            font-size: 1.1rem;
        }

        .input-group-modern .form-control {
            padding-left: 3rem;
        }

        /* Validation Styles */
        .form-control.is-valid {
            border-color: #38ef7d;
            background-image: none;
        }

        .form-control.is-invalid {
            border-color: #ff6b6b;
            background-image: none;
        }

        .valid-feedback, .invalid-feedback {
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 0 15px;
            }

            .card-body {
                padding: 2rem 1.5rem;
            }

            .step-indicators {
                flex-direction: row;
                gap: 0.5rem;
            }

            .step-indicator .step-circle {
                width: 40px;
                height: 40px;
                font-size: 0.9rem;
            }

            .step-indicator .step-label {
                font-size: 0.8rem;
            }

            .step-buttons {
                flex-direction: column;
                gap: 1rem;
            }

            .btn {
                width: 100%;
            }
        }

        /* Loading Animation */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.8);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid rgba(255,255,255,0.3);
            border-top: 4px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <!-- Background Particles -->
    <div class="bg-particles">
        <div class="particle" style="left: 10%; animation-delay: 0s; width: 8px; height: 8px;"></div>
        <div class="particle" style="left: 20%; animation-delay: 1s; width: 12px; height: 12px;"></div>
        <div class="particle" style="left: 30%; animation-delay: 2s; width: 6px; height: 6px;"></div>
        <div class="particle" style="left: 40%; animation-delay: 3s; width: 10px; height: 10px;"></div>
        <div class="particle" style="left: 50%; animation-delay: 4s; width: 8px; height: 8px;"></div>
        <div class="particle" style="left: 60%; animation-delay: 5s; width: 12px; height: 12px;"></div>
        <div class="particle" style="left: 70%; animation-delay: 0.5s; width: 6px; height: 6px;"></div>
        <div class="particle" style="left: 80%; animation-delay: 1.5s; width: 10px; height: 10px;"></div>
        <div class="particle" style="left: 90%; animation-delay: 2.5s; width: 8px; height: 8px;"></div>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner"></div>
    </div>

    <div class="container py-5">
        <div class="card main-card shadow">
            <div class="card-header">
                <h1 class="brand-gradient">
                    <i class="fas fa-calculator"></i> My Bill Book
                </h1>
                <p class="brand-subtitle">Complete your registration in 4 simple steps</p>
            </div>

            <div class="card-body">
                <!-- Step Indicators -->
                <div class="step-indicators">
                    <div class="progress-line">
                        <div class="progress-fill" id="progressFill"></div>
                    </div>
                    <div class="step-indicator active" id="indicator-0">
                        <div class="step-circle">1</div>
                        <div class="step-label">Personal Info</div>
                    </div>
                    <div class="step-indicator" id="indicator-1">
                        <div class="step-circle">2</div>
                        <div class="step-label">Shop Details</div>
                    </div>
                    <div class="step-indicator" id="indicator-2">
                        <div class="step-circle">3</div>
                        <div class="step-label">Documents</div>
                    </div>
                    <div class="step-indicator" id="indicator-3">
                        <div class="step-circle">4</div>
                        <div class="step-label">Subscription</div>
                    </div>
                </div>

                <form method="post" modelAttribute="OWNER_INFO" action="${pageContext.request.contextPath}/save-owner-info" id="mainForm">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" value="${user.username}" name="userName" />
                    <input type="hidden" name="status" value="${user.status}" />

                    <!-- Step 1: Personal Info -->
                    <div class="step active">
                        <div class="step-header">
                            <i class="fas fa-user"></i>Personal Information
                        </div>
                        <div class="input-group-modern">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" name="ownerName" class="form-control" placeholder="Enter your full name" required />
                            <div class="invalid-feedback">Please provide a valid name.</div>
                        </div>
                        <div class="input-group-modern">
                            <i class="fas fa-phone input-icon"></i>
                            <input type="tel" name="mobNumber" class="form-control" placeholder="Enter 10-digit mobile number" pattern="[0-9]{10}" required />
                            <div class="invalid-feedback">Please provide a valid 10-digit mobile number.</div>
                        </div>
                    </div>

                    <!-- Step 2: Shop Info -->
                    <div class="step">
                        <div class="step-header">
                            <i class="fas fa-store"></i>Shop Information
                        </div>
                        <div class="input-group-modern">
                            <i class="fas fa-store input-icon"></i>
                            <input type="text" name="shopName" class="form-control" placeholder="Enter your shop name" required />
                            <div class="invalid-feedback">Please provide your shop name.</div>
                        </div>
                        <div class="input-group-modern">
                            <i class="fas fa-map-marker-alt input-icon"></i>
                            <input type="text" name="address" class="form-control" placeholder="Enter complete address" required />
                            <div class="invalid-feedback">Please provide your address.</div>
                        </div>
                        <div class="input-group-modern">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" name="email" class="form-control" placeholder="Enter email address (optional)" />
                            <div class="invalid-feedback">Please provide a valid email address.</div>
                        </div>
                    </div>

                    <!-- Step 3: Documents -->
                    <div class="step">
                        <div class="step-header">
                            <i class="fas fa-file-alt"></i>Document Details
                        </div>
                        <div class="input-group-modern">
                            <i class="fas fa-receipt input-icon"></i>
                            <input type="text" name="gstNumber" class="form-control" placeholder="Enter GST Number" required />
                            <div class="invalid-feedback">Please provide a valid GST number.</div>
                        </div>
                        <div class="input-group-modern">
                            <i class="fas fa-id-card input-icon"></i>
                            <input type="text" name="lcNo" class="form-control" placeholder="Enter License Number (optional)" />
                        </div>
                        <div class="input-group-modern">
                            <i class="fas fa-mobile-alt input-icon"></i>
                            <input type="text" name="upiId" class="form-control"   placeholder="Enter UPI ID" required/>
                            <div class="invalid-feedback">Please provide a valid UPI ID.</div>
                        </div>
                    </div>

                    <!-- Step 4: Subscription -->
                    <div class="step">
                        <div class="step-header">
                            <i class="fas fa-crown"></i>Choose Your Plan
                        </div>
                        <div class="mb-4">
                            <label for="planDuration" class="form-label">
                                <i class="fas fa-calendar-alt"></i> Select Subscription Duration
                            </label>
                            <select class="form-select fancy-select" id="planDuration" name="planDuration" required>
                                <option value="">-- Choose Your Perfect Plan --</option>
                                <c:forEach var="entry" items="${planOptions}">
                                    <option value="${entry.key}" data-price="${entry.value}">
                                        ${entry.key} Months - ₹${entry.value}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div id="selectedPlanText" style="display: none;"></div>
                    </div>

                    <!-- Navigation Buttons -->
                    <div class="step-buttons">
                        <button type="button" class="btn btn-outline-secondary" onclick="prevStep()" style="display: none;">
                            <i class="fas fa-arrow-left"></i> Previous
                        </button>
                        <div></div>
                        <button type="button" class="btn btn-outline-primary" onclick="nextStep()">
                            Next <i class="fas fa-arrow-right"></i>
                        </button>
                        <button type="submit" class="btn btn-outline-success" id="submitBtn" style="display: none;">
                            <i class="fas fa-check"></i> Complete Registration
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let currentStep = 0;
        const totalSteps = 4;

        function updateProgressBar() {
            const progressFill = document.getElementById('progressFill');
            const percentage = (currentStep / (totalSteps - 1)) * 100;
            progressFill.style.width = percentage + '%';
        }

        function showStep(step) {
            const steps = document.querySelectorAll(".step");
            const indicators = document.querySelectorAll(".step-indicator");
            const prevBtn = document.querySelector(".btn-outline-secondary");
            const nextBtn = document.querySelector(".btn-outline-primary");
            const submitBtn = document.getElementById("submitBtn");

            // Hide all steps
            steps.forEach(s => s.classList.remove("active"));

            // Show current step with animation
            setTimeout(() => {
                steps[step].classList.add("active");
            }, 100);

            // Update indicators
            indicators.forEach((indicator, i) => {
                indicator.classList.remove("active", "completed");
                if (i === step) {
                    indicator.classList.add("active");
                } else if (i < step) {
                    indicator.classList.add("completed");
                    indicator.querySelector('.step-circle').innerHTML = '<i class="fas fa-check"></i>';
                } else {
                    indicator.querySelector('.step-circle').innerHTML = i + 1;
                }
            });

            // Update buttons
            prevBtn.style.display = step === 0 ? "none" : "inline-block";
            nextBtn.style.display = step === totalSteps - 1 ? "none" : "inline-block";
            submitBtn.style.display = step === totalSteps - 1 ? "inline-block" : "none";

            // Update progress bar
            updateProgressBar();
        }

        function nextStep() {
            if (!validateStep()) return;

            if (currentStep < totalSteps - 1) {
                currentStep++;
                showStep(currentStep);
            }
        }

        function prevStep() {
            if (currentStep > 0) {
                currentStep--;
                showStep(currentStep);
            }
        }

        function validateStep() {
            const currentInputs = document.querySelectorAll(`.step:nth-of-type(${currentStep + 1}) input[required], .step:nth-of-type(${currentStep + 1}) select[required]`);
            let isValid = true;

            currentInputs.forEach(input => {
                const value = input.value.trim();

                // Reset validation classes
                input.classList.remove('is-valid', 'is-invalid');

                if (value === "") {
                    input.classList.add('is-invalid');
                    isValid = false;
                } else {
                    // Additional validation
                    if (input.type === 'tel' && input.pattern) {
                        const regex = new RegExp(input.pattern);
                        if (!regex.test(value)) {
                            input.classList.add('is-invalid');
                            isValid = false;
                        } else {
                            input.classList.add('is-valid');
                        }
                    } else if (input.type === 'email' && value !== "") {
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        if (!emailRegex.test(value)) {
                            input.classList.add('is-invalid');
                            isValid = false;
                        } else {
                            input.classList.add('is-valid');
                        }
                    } else {
                        input.classList.add('is-valid');
                    }
                }
            });

            if (!isValid) {
                // Shake animation for invalid step
                const currentStepElement = document.querySelector('.step.active');
                currentStepElement.style.animation = 'none';
                setTimeout(() => {
                    currentStepElement.style.animation = 'shake 0.5s ease-in-out';
                }, 10);
            }

            return isValid;
        }

        // Plan selection handler
        document.getElementById('planDuration').addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const planText = document.getElementById('selectedPlanText');

            if (selectedOption.value) {
                const duration = selectedOption.value;
                const price = selectedOption.getAttribute('data-price');
                planText.innerHTML = `
                    <i class="fas fa-crown"></i>
                    Selected Plan: ${duration} Months - ₹${price}
                    <br><small class="text-muted">Perfect choice for your business!</small>
                `;
                planText.style.display = 'block';
                planText.style.animation = 'slideUp 0.5s ease-out';
            } else {
                planText.style.display = 'none';
            }
        });

        // Form submission
        document.getElementById('mainForm').addEventListener('submit', function(e) {
            e.preventDefault();

            // Show loading
            document.getElementById('loadingOverlay').style.display = 'flex';

            // Simulate form submission (replace with actual submission)
            setTimeout(() => {
                this.submit();
            }, 1500);
        });

        // Real-time validation
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('input', function() {
                if (this.classList.contains('is-invalid') || this.classList.contains('is-valid')) {
                    validateStep();
                }
            });
        });

        // Initialize
        document.addEventListener("DOMContentLoaded", () => {
            showStep(currentStep);

            // Add shake animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes shake {
                    0%, 100% { transform: translateX(0); }
                    25% { transform: translateX(-10px); }
                    75% { transform: translateX(10px); }
                }
            `;
            document.head.appendChild(style);
        });

        // Keyboard navigation
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.target.matches('textarea')) {
                e.preventDefault();
                const nextBtn = document.querySelector('.btn-outline-primary');
                const submitBtn = document.getElementById('submitBtn');

                if (nextBtn.style.display !== 'none') {
                    nextStep();
                } else if (submitBtn.style.display !== 'none') {
                    document.getElementById('mainForm').dispatchEvent(new Event('submit'));
                }
            }
        });
    </script>
</body>
</html>