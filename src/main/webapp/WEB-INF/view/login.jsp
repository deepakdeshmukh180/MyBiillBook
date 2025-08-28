<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> <%@ page contentType="text/html;charset=UTF-8" language="java" %> <!DOCTYPE html> <html

pasted

Looking at your login/registration page, I can see it's a well-structured Spring MVC application with Bootstrap styling. I notice you have a logo that appears to be a base64-encoded image. Let me help you improve this page with some suggestions and optimizations.


Enhanced Login/Registration Page
Interactive artifact




5-hour limit reached ∙ resets 11:30 PM
Upgrade
Continue

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Bill Book - Login/Register</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        :root {
            --primary-color: #6366f1;
            --primary-dark: #4f46e5;
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
            opacity: 0.1;
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

        .logo-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-color), var(--success-color));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            box-shadow: 0 10px 30px rgba(99, 102, 241, 0.3);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .logo-icon i {
            font-size: 2rem;
            color: white;
        }

        .app-title {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, var(--primary-color), var(--success-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .app-subtitle {
            color: var(--text-color);
            opacity: 0.7;
            font-size: 0.9rem;
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
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
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
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
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
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
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

            .app-title {
                font-size: 1.5rem;
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
            <div class="logo-icon">
                <i class="fas fa-receipt"></i>
            </div>
            <h1 class="app-title">My Bill Book</h1>
            <p class="app-subtitle">Manage your bills with ease</p>
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
                        <i class="fas fa-sign-in-alt me-2"></i>Sign In
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
                        <i class="fas fa-user-plus me-2"></i>Create Account
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
