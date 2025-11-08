<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<div class="container py-5">
    <div class="text-center mb-4">
        <h1 class="display-5">StudySync</h1>
        <p class="text-muted">Collaborative study sessions made simple.</p>
    </div>
    <div class="d-flex gap-3 justify-content-center">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/dashboard">Go to Dashboard</a>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/groups/list">Manage Groups</a>
            </c:when>
            <c:otherwise>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/auth/login">Login</a>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/auth/register">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>

