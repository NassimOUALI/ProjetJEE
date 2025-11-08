<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4" style="max-width: 640px;">
    <h3>Edit Profile</h3>
    <c:if test='${not empty error}'>
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/profile/edit">
        <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
        <div class="mb-3">
            <label class="form-label">First name (prenom)</label>
            <input class="form-control" type="text" name="prenom" value="${sessionScope.user.prenom}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Last name (nom)</label>
            <input class="form-control" type="text" name="nom" value="${sessionScope.user.nom}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input class="form-control" type="email" name="email" value="${sessionScope.user.email}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">New password (optional)</label>
            <input class="form-control" type="password" name="password">
        </div>
        <button class="btn btn-primary" type="submit">Save</button>
    </form>
</div>
</body>
</html>

