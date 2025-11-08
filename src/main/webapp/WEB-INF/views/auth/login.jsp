<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<div class="container py-5" style="max-width: 480px;">
    <h2 class="mb-4">Login</h2>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/auth/login">
        <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input class="form-control" type="email" name="email" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Password</label>
            <input class="form-control" type="password" name="password" required>
        </div>
        <button class="btn btn-primary w-100" type="submit">Login</button>
    </form>
    <div class="mt-3">
        <a href="${pageContext.request.contextPath}/auth/register">No account? Register</a>
    </div>
    <div class="mt-3">
        <a href="${pageContext.request.contextPath}/">Back to Home</a>
    </div>
    </div>
</body>
</html>

