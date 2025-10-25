<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - BillMatePro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
        }

        .error-container {
            background: white;
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 600px;
            width: 90%;
        }

        .error-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 1rem;
        }

        .error-code {
            font-size: 6rem;
            font-weight: 700;
            color: #6c757d;
            line-height: 1;
            margin-bottom: 1rem;
        }

        .error-message {
            font-size: 1.25rem;
            color: #495057;
            margin-bottom: 2rem;
        }

        .error-description {
            color: #6c757d;
            margin-bottom: 2rem;
        }

        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px;
            padding: 0.75rem 2rem;
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
            color: white;
        }

        .error-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            margin-top: 2rem;
            text-align: left;
            font-family: 'Courier New', monospace;
            font-size: 0.875rem;
            color: #dc3545;
            display: none;
        }

        .toggle-details {
            color: #6c757d;
            cursor: pointer;
            font-size: 0.875rem;
            text-decoration: underline;
        }

        .toggle-details:hover {
            color: #495057;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">
            <i class="fas fa-exclamation-triangle"></i>
        </div>

        <!-- Error Code -->
        <div class="error-code">
            <c:choose>
                <c:when test="${not empty status}">
                    ${status}
                </c:when>
                <c:otherwise>
                    500
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Error Message -->
        <div class="error-message">
            <c:choose>
                <c:when test="${status == 404}">
                    Page Not Found
                </c:when>
                <c:when test="${status == 403}">
                    Access Forbidden
                </c:when>
                <c:when test="${status == 500}">
                    Internal Server Error
                </c:when>
                <c:otherwise>
                    Something Went Wrong
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Error Description -->
        <div class="error-description">
            <c:choose>
                <c:when test="${status == 404}">
                    The page you are looking for might have been removed, renamed, or is temporarily unavailable.
                </c:when>
                <c:when test="${status == 403}">
                    You don't have permission to access this resource on this server.
                </c:when>
                <c:when test="${status == 500}">
                    We're experiencing some technical difficulties. Please try again later.
                </c:when>
                <c:otherwise>
                    An unexpected error occurred while processing your request.
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Action Buttons -->
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/" class="btn-home">
                <i class="fas fa-home me-2"></i>
                Go to Dashboard
            </a>
        </div>

        <div class="mb-3">
            <button class="btn btn-outline-secondary btn-sm" onclick="history.back()">
                <i class="fas fa-arrow-left me-2"></i>
                Go Back
            </button>
        </div>

        <!-- Toggle Error Details (for development) -->
        <c:if test="${not empty error or not empty exception}">
            <div class="toggle-details" onclick="toggleErrorDetails()">
                <i class="fas fa-code me-1"></i>
                Show Technical Details
            </div>

            <div class="error-details" id="errorDetails">
                <c:if test="${not empty error}">
                    <strong>Error:</strong><br>
                    ${error}<br><br>
                </c:if>

                <c:if test="${not empty exception}">
                    <strong>Exception:</strong><br>
                    ${exception.class.name}: ${exception.message}<br><br>
                </c:if>

                <c:if test="${not empty trace}">
                    <strong>Stack Trace:</strong><br>
                    <c:forEach items="${trace}" var="line">
                        ${line}<br>
                    </c:forEach>
                </c:if>

                <c:if test="${not empty timestamp}">
                    <br><strong>Timestamp:</strong> ${timestamp}
                </c:if>
            </div>
        </c:if>

        <!-- Contact Support -->
        <div class="mt-4 pt-3 border-top">
            <small class="text-muted">
                If this problem persists, please contact our support team.
            </small>
        </div>
    </div>

    <script>
        function toggleErrorDetails() {
            const details = document.getElementById('errorDetails');
            const toggle = document.querySelector('.toggle-details');

            if (details.style.display === 'none' || details.style.display === '') {
                details.style.display = 'block';
                toggle.innerHTML = '<i class="fas fa-code me-1"></i>Hide Technical Details';
            } else {
                details.style.display = 'none';
                toggle.innerHTML = '<i class="fas fa-code me-1"></i>Show Technical Details';
            }
        }

        // Auto-hide error details in production
        setTimeout(() => {
            const details = document.getElementById('errorDetails');
            const toggle = document.querySelector('.toggle-details');

            // Hide technical details by default in production
            if (window.location.hostname !== 'localhost' &&
                window.location.hostname !== '127.0.0.1') {
                if (toggle) toggle.style.display = 'none';
            }
        }, 100);
    </script>
</body>
</html>