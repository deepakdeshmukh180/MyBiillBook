
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>BillMatePro - Login/Register</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        :root {
            --primary-color: #2247a5;
            --primary-dark: #145fa0;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --bg-light: #f8fafc;
            --bg-dark: #0f172a;
            --card-light: #ffffff;
            --card-dark: #1e293b;
            --text-light: #1e293b;
            --text-dark: #f1f5f9;
            --border-light: #e2e8f0;
            --border-dark: #334155;
            --glass-bg: rgba(255, 255, 255, 0.1);
            --glass-border: rgba(255, 255, 255, 0.2);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-color);
            color: var(--text-color);
            min-height: 100vh;
            transition: all 0.3s ease;
            overflow-x: hidden;
        }

        /* Light theme */
        [data-theme="light"] {
            --bg-color: var(--bg-light);
            --text-color: var(--text-light);
            --card-bg: var(--card-light);
            --border-color: var(--border-light);
        }

        /* Dark theme */
        [data-theme="dark"] {
            --bg-color: var(--bg-dark);
            --text-color: var(--text-dark);
            --card-bg: var(--card-dark);
            --border-color: var(--border-dark);
        }

        /* Animated background */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--success-color) 100%);
            opacity: 0.05;
            z-index: -2;
        }

        /* Floating shapes */
        .floating-shape {
            position: fixed;
            border-radius: 50%;
            background: linear-gradient(45deg, var(--primary-color), var(--success-color));
            opacity: 0.1;
            animation: float 6s ease-in-out infinite;
            z-index: -1;
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

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        /* Main container */
        .auth-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }

        /* Glass card effect */
        .auth-card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 3rem;
            width: 100%;
            max-width: 450px;
            box-shadow:
                0 20px 25px -5px rgba(0, 0, 0, 0.1),
                0 10px 10px -5px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        [data-theme="dark"] .auth-card {
            box-shadow:
                0 20px 25px -5px rgba(0, 0, 0, 0.4),
                0 10px 10px -5px rgba(0, 0, 0, 0.2);
        }

        .auth-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
            opacity: 0.5;
        }

        /* Logo section */
        .logo-section {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo-container {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            animation: fadeInUp 0.8s ease;
        }

        .app-logo {
            max-width: 280px;
            height: auto;
            filter: drop-shadow(0 4px 15px rgba(34, 71, 165, 0.2));
            transition: all 0.3s ease;
        }

        .app-logo:hover {
            transform: scale(1.02);
            filter: drop-shadow(0 8px 25px rgba(34, 71, 165, 0.3));
        }

        [data-theme="dark"] .app-logo {
            filter:
                drop-shadow(0 4px 15px rgba(34, 71, 165, 0.2))
                brightness(1.1)
                contrast(1.05);
        }

        .app-subtitle {
            color: var(--text-color);
            opacity: 0.7;
            font-size: 0.9rem;
            margin-top: 0.5rem;
            font-weight: 500;
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

        /* Tab styling */
        .nav-tabs {
            border: none;
            margin-bottom: 2rem;
        }

        .nav-tabs .nav-link {
            border: none;
            border-radius: 10px;
            padding: 0.75rem 1.5rem;
            margin: 0 0.25rem;
            color: var(--text-color);
            opacity: 0.6;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-tabs .nav-link:hover {
            opacity: 1;
            background: var(--glass-bg);
        }

        .nav-tabs .nav-link.active {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            opacity: 1;
            box-shadow: 0 4px 15px rgba(34, 71, 165, 0.3);
        }

        /* Form styling */
        .form-group-enhanced {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .form-control {
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 1rem 1rem 1rem 3rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            color: var(--text-color);
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(34, 71, 165, 0.1);
            background: var(--card-bg);
            color: var(--text-color);
        }

        .form-icon {
            position: absolute;
            top: 50%;
            left: 1rem;
            transform: translateY(-50%);
            color: var(--primary-color);
            font-size: 1.1rem;
            z-index: 2;
        }

        /* Floating labels */
        .floating-label {
            position: absolute;
            top: 1rem;
            left: 3rem;
            color: var(--text-color);
            opacity: 0.6;
            pointer-events: none;
            transition: all 0.3s ease;
            font-size: 1rem;
            z-index: 1;
        }

        .form-control:focus + .floating-label,
        .form-control:not(:placeholder-shown) + .floating-label {
            top: -0.5rem;
            left: 1rem;
            font-size: 0.8rem;
            color: var(--primary-color);
            background: var(--card-bg);
            padding: 0 0.5rem;
            border-radius: 4px;
        }

        /* Button styling */
        .btn-enhanced {
            padding: 1rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            border: none;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            box-shadow: 0 4px 15px rgba(34, 71, 165, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(34, 71, 165, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-color), #059669);
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
        }

        /* Loading state */
        .btn-loading {
            pointer-events: none;
            opacity: 0.7;
        }

        .btn-loading::after {
            content: '';
            position: absolute;
            width: 16px;
            height: 16px;
            margin: auto;
            border: 2px solid transparent;
            border-top-color: currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            top: 0;
            right: 1rem;
            bottom: 0;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Feedback messages */
        .feedback-message {
            font-size: 0.8rem;
            margin-top: 0.5rem;
            display: block;
            transition: all 0.3s ease;
        }

        .feedback-success {
            color: var(--success-color);
        }

        .feedback-error {
            color: var(--danger-color);
        }

        /* Theme toggle */
        .theme-toggle {
            position: fixed;
            top: 2rem;
            right: 2rem;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--card-bg);
            border: 2px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 1000;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .theme-toggle:hover {
            transform: scale(1.1);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .theme-toggle i {
            font-size: 1.2rem;
            color: var(--primary-color);
        }

        /* Toast styling */
        .toast {
            border-radius: 12px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        /* Password strength indicator */
        .password-strength {
            display: flex;
            gap: 2px;
            margin-top: 0.5rem;
        }

        .strength-bar {
            height: 4px;
            flex: 1;
            border-radius: 2px;
            background: var(--border-color);
            transition: all 0.3s ease;
        }

        .strength-bar.active {
            background: var(--success-color);
        }

        .strength-bar.weak {
            background: var(--danger-color);
        }

        .strength-bar.medium {
            background: var(--warning-color);
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .auth-card {
                padding: 2rem 1.5rem;
                margin: 1rem;
                border-radius: 15px;
            }

            .theme-toggle {
                top: 1rem;
                right: 1rem;
                width: 45px;
                height: 45px;
            }

            .app-logo {
                max-width: 250px;
            }

            .app-subtitle {
                font-size: 0.8rem;
            }
        }

        /* Animation for form elements */
        .form-group-enhanced {
            opacity: 0;
            transform: translateY(20px);
            animation: slideUp 0.6s ease forwards;
        }

        .form-group-enhanced:nth-child(1) { animation-delay: 0.1s; }
        .form-group-enhanced:nth-child(2) { animation-delay: 0.2s; }
        .form-group-enhanced:nth-child(3) { animation-delay: 0.3s; }

        @keyframes slideUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>

    <c:set var="contextPath" value="${pageContext.request.contextPath}"/>
</head>
<body data-theme="light">

<!-- Floating background shapes -->
<div class="floating-shape"></div>
<div class="floating-shape"></div>
<div class="floating-shape"></div>

<!-- Theme Toggle -->
<div class="theme-toggle" onclick="toggleTheme()" title="Toggle dark/light mode">
    <i class="fas fa-moon" id="theme-icon"></i>
</div>

<div class="auth-container">
    <div class="auth-card">
        <div class="logo-section">
            <div class="logo-container">
                <img src="data:image/png;base64,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"
                     alt="BillMatePro Logo"
                     class="app-logo">
            </div>
            <p class="app-subtitle">Secure Login to Your Professional Billing Dashboard</p>
        </div>

        <ul class="nav nav-tabs justify-content-center" id="authTabs" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" id="login-tab" data-bs-toggle="tab" data-bs-target="#login"
                        type="button" role="tab">
                    <i class="fas fa-sign-in-alt me-2"></i>Login
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" id="register-tab" data-bs-toggle="tab" data-bs-target="#register"
                        type="button" role="tab">
                    <i class="fas fa-user-plus me-2"></i>Register
                </button>
            </li>
        </ul>

        <div class="tab-content">
            <!-- Login Tab -->
            <div class="tab-pane fade show active" id="login" role="tabpanel">
                <form method="POST" action="${contextPath}/login" novalidate autocomplete="off" id="loginForm">
                    <div class="form-group-enhanced">
                        <i class="fas fa-envelope form-icon"></i>
                        <input type="email" class="form-control" id="username" name="username"
                               placeholder=" " required autocomplete="off">
                        <label class="floating-label" for="username">Email Address</label>
                    </div>

                    <div class="form-group-enhanced">
                        <i class="fas fa-lock form-icon"></i>
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder=" " required minlength="6" autocomplete="off">
                        <label class="floating-label" for="password">Password</label>
                    </div>

                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <c:if test="${not empty error}">
                        <div class="feedback-message feedback-error mb-3">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                        </div>
                    </c:if>

                    <c:if test="${not empty message}">
                        <div class="feedback-message feedback-success mb-3">
                            <i class="fas fa-check-circle me-2"></i>${message}
                        </div>
                    </c:if>

                    <button type="submit" class="btn btn-primary btn-enhanced w-100">
                        <i class="fas fa-sign-in-alt me-2"></i>Sign In to BillMatePro
                    </button>
                </form>
            </div>

            <!-- Register Tab -->
            <div class="tab-pane fade" id="register" role="tabpanel">
                <form:form method="POST" modelAttribute="userForm" action="${contextPath}/registration"
                          onsubmit="return validateRegistrationForm();" autocomplete="off" id="registerForm">
                    <div class="form-group-enhanced">
                        <i class="fas fa-envelope form-icon"></i>
                        <form:input path="username" class="form-control" placeholder=" "
                                   id="rusername" type="email" required="true"
                                   htmlEscape="true" autocomplete="off" maxlength="50"/>
                        <label class="floating-label">Email Address</label>
                        <form:errors path="username" cssClass="feedback-message feedback-error"/>
                        <span id="username-feedback" class="feedback-message"></span>
                    </div>

                    <div class="form-group-enhanced">
                        <i class="fas fa-lock form-icon"></i>
                        <form:password path="password" class="form-control" placeholder=" "
                                      required="true" id="rpassword"
                                      pattern="^(?=.*[0-9])(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$"
                                      title="Password must be at least 8 characters long, contain at least one number and one special character."
                                      autocomplete="off"/>
                        <label class="floating-label">Password</label>
                        <div class="password-strength" id="passwordStrength">
                            <div class="strength-bar"></div>
                            <div class="strength-bar"></div>
                            <div class="strength-bar"></div>
                            <div class="strength-bar"></div>
                        </div>
                        <form:errors path="password" cssClass="feedback-message feedback-error"/>
                    </div>

                    <div class="form-group-enhanced">
                        <i class="fas fa-lock form-icon"></i>
                        <form:password path="passwordConfirm" class="form-control" placeholder=" "
                                      required="true" id="passwordConfirm"
                                      pattern="^(?=.*[0-9])(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$"
                                      title="Confirm password must match the password criteria."
                                      autocomplete="off"/>
                        <label class="floating-label">Confirm Password</label>
                        <form:errors path="passwordConfirm" cssClass="feedback-message feedback-error"/>
                        <div id="passwordMismatch" class="feedback-message feedback-error d-none">
                            <i class="fas fa-times-circle me-2"></i>Passwords do not match
                        </div>
                    </div>

                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" id="registerBtn" class="btn btn-success btn-enhanced w-100">
                        <i class="fas fa-user-plus me-2"></i>Join BillMatePro
                    </button>
                </form:form>
            </div>
        </div>
    </div>
</div>

<!-- Toast -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
    <div id="toastFeedback" class="toast align-items-center text-white bg-success border-0" role="alert">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-check-circle me-2"></i>Action completed successfully!
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                    aria-label="Close"></button>
        </div>
    </div>
</div>


<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>

document.getElementById('rusername').addEventListener('input', function () {
    const emailInput = this.value.trim();
    const feedback = document.getElementById('username-feedback');
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$/;

    if (emailInput === '') {
        feedback.textContent = 'Email is required.';
        feedback.style.color = 'red';
    } else if (!emailRegex.test(emailInput)) {
        feedback.textContent = 'Invalid email format.';
        feedback.style.color = 'red';
    } else {
        feedback.textContent = '';
    }
});

$(document).ready(function () {
    $('#rusername').on('blur', function () {
        var username = $(this).val().trim();
        var feedback = $('#username-feedback');
        var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$/;

        // Email format validation before AJAX
        if (!emailRegex.test(username)) {
            feedback.text('Invalid email format.').css('color', 'red');
            $('#registerBtn').prop('disabled', true);
            return;
        }

        // Proceed with AJAX only if format is valid
        if (username.length > 0) {
            $.ajax({
                url: '${pageContext.request.contextPath}/check-username',
                type: 'GET',
                data: { username: username },
                success: function (exists) {
                    if (exists) {
                        $('#registerBtn').prop('disabled', true);
                        feedback.text('Email is already taken!').css('color', 'red');
                    } else {
                        $('#registerBtn').prop('disabled', false);
                        feedback.text('Email is available. Please register.').css('color', 'green');
                    }
                },
                error: function () {
                    feedback.text('Error checking email.').css('color', 'orange');
                }
            });
        }
    });
});

function toggleTheme() {
    const body = document.body;
    const currentTheme = body.getAttribute("data-theme");
    body.setAttribute("data-theme", currentTheme === "dark" ? "light" : "dark");
}



function validateRegistrationForm() {
    const username = document.getElementById("rusername").value.trim();
    const password = document.getElementById("rpassword")[0].value;
    const confirmPassword = document.getElementsByName("passwordConfirm")[0].value;

    const usernameFeedback = document.getElementById("username-feedback");
    const passwordMismatch = document.getElementById("passwordMismatch");

    // Reset messages
    usernameFeedback.textContent = "";
    passwordMismatch.classList.add("d-none");

    let isValid = true;

    // Username validation
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailPattern.test(username)) {
      usernameFeedback.textContent = "Please enter a valid email address.";
      usernameFeedback.style.color = "red";
      isValid = false;
  }

    // Password pattern validation
    const passwordPattern = /^(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$/;
    if (!passwordPattern.test(password)) {
        alert("Password must be at least 8 characters long and contain at least one number and one special character.");
        isValid = false;
    }

    // Password confirmation
    if (password !== confirmPassword) {
        passwordMismatch.classList.remove("d-none");
        isValid = false;
    }

    return isValid;
}
</script>

</body>
</html>
