<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Log in with your account</title>

    <link href="${contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body>

<div class="container">

     <h1 class="title">Register
          <div class="close"></div>
        </h1>
        <form:form method="POST" modelAttribute="userForm" class="form-signin" action="${contextPath}/registration">
          <div class="input-container">
           <spring:bind path="username">
                               <div class="form-group ${status.error ? 'has-error' : ''}">
                                   <form:input type="text" required="required" path="username" class="form-control" placeholder="Username"
                                               autofocus="true"></form:input>
                                   <form:errors path="username"></form:errors>
                               </div>
                           </spring:bind>

            <div class="bar"></div>

          </div>
           <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
          <div class="input-container">
           <spring:bind path="password">
                               <div class="form-group ${status.error ? 'has-error' : ''}">
                                   <form:input type="password" required="required"  path="password" class="form-control" placeholder="Password"></form:input>
                                   <form:errors path="password"></form:errors>
                               </div>
                           </spring:bind>

            <div class="bar"></div>
          </div>

          <div class="input-container">
           <spring:bind path="passwordConfirm">
                              <div class="form-group ${status.error ? 'has-error' : ''}">
                                  <form:input type="password" required="required"  path="passwordConfirm" class="form-control"
                                              placeholder="Confirm your password"></form:input>
                                  <form:errors path="passwordConfirm"></form:errors>
                              </div>
                          </spring:bind>


            <div class="bar"></div>
          </div>
          <div class="button-container">
            <button type="submit"><span>Register</span></button>
          </div>
          </form:form>

      </div>
</div>
<!-- /container -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="${contextPath}/resources/js/bootstrap.min.js"></script>
</body>
</html>
