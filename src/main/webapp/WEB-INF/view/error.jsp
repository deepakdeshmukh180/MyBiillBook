<%@ page isErrorPage="true" contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
</head>
<body>

<h2>Something went wrong</h2>

<p><b>Exception Type:</b>
    ${pageContext.exception['class'].name}
</p>

<p><b>Message:</b>
    ${pageContext.exception.message}
</p>

</body>
</html>
