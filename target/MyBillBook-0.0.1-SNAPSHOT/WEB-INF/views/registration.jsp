<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Create an Account</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="${contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #74ebd5, #acb6e5);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            max-width: 400px;
            margin: 60px auto;
        }

        .form-signin {
            background: #ffffff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .form-signin-heading {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .form-control {
            border-radius: 6px;
            box-shadow: none;
            border-color: #ccc;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: #5bc0de;
            box-shadow: 0 0 5px rgba(91, 192, 222, 0.5);
        }

        .btn-primary {
            background-color: #5bc0de;
            border-color: #46b8da;
        }

        .btn-primary:hover {
            background-color: #31b0d5;
            border-color: #269abc;
        }

        .form-group.has-error .form-control {
            border-color: #e74c3c;
        }

        .form-group .form-control::placeholder {
            color: #999;
        }

        .form-group form\:errors {
            color: #e74c3c;
            font-size: 0.9em;
            margin-top: 5px;
            display: block;
        }
    </style>
</head>
<body>

<div class="container">
    <form:form method="POST" modelAttribute="userForm" class="form-signin">
        <h2 class="form-signin-heading">Create Your Account</h2>

        <spring:bind path="username">
            <div class="form-group ${status.error ? 'has-error' : ''}">
                <form:input type="text" path="username" class="form-control" placeholder="Username" autofocus="true"/>
                <form:errors path="username" element="div" cssClass="text-danger"/>
            </div>
        </spring:bind>

        <spring:bind path="password">
            <div class="form-group ${status.error ? 'has-error' : ''}">
                <form:input type="password" path="password" class="form-control" placeholder="Password"/>
                <form:errors path="password" element="div" cssClass="text-danger"/>
            </div>
        </spring:bind>

        <spring:bind path="passwordConfirm">
            <div class="form-group ${status.error ? 'has-error' : ''}">
                <form:input type="password" path="passwordConfirm" class="form-control" placeholder="Confirm Password"/>
                <form:errors path="passwordConfirm" element="div" cssClass="text-danger"/>
            </div>
        </spring:bind>

        <button class="btn btn-lg btn-primary btn-block" type="submit">Create Account</button>
    </form:form>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="${contextPath}/resources/js/bootstrap.min.js"></script>
</body>
</html>
