<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>500 - Server Error - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<div class="container py-5">
    <div class="text-center">
        <h1 class="display-1">500</h1>
        <h2 class="mb-4">Internal Server Error</h2>
        <p class="lead text-muted mb-4">Something went wrong on our end. We're working to fix it.</p>
        <c:if test="${not empty exception}">
            <div class="alert alert-danger mt-4" style="max-width: 600px; margin: 0 auto;">
                <strong>Error:</strong> ${exception.message}
                <c:if test="${pageContext.request.getAttribute('javax.servlet.error.exception') != null}">
                    <details class="mt-2">
                        <summary>Technical Details</summary>
                        <pre class="mt-2 small"><c:forEach var="trace" items="${pageContext.request.getAttribute('javax.servlet.error.exception').stackTrace}" varStatus="status">
<c:if test="${status.count <= 5}">${trace}</c:if>
</c:forEach></pre>
                    </details>
                </c:if>
            </div>
        </c:if>
        <div class="d-flex gap-2 justify-content-center mt-4">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                <i class="bi bi-house"></i> Go Home
            </a>
            <button onclick="history.back()" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Go Back
            </button>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>

