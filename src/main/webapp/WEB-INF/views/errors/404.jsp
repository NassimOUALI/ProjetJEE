<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>404 - Page Not Found - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<div class="container py-5">
    <div class="text-center">
        <h1 class="display-1">404</h1>
        <h2 class="mb-4">Page Not Found</h2>
        <p class="lead text-muted mb-4">The page you're looking for doesn't exist or has been moved.</p>
        <div class="d-flex gap-2 justify-content-center">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                <i class="bi bi-house"></i> Go Home
            </a>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-primary">
                <i class="bi bi-calendar-event"></i> Dashboard
            </a>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>

