<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Session - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4" style="max-width: 640px;">
    <%@ include file="/WEB-INF/views/includes/breadcrumb.jspf" %>
    <h3>Create Session<c:if test="${not empty group}"> for ${group.nom}</c:if></h3>
    <form method="post" action="${pageContext.request.contextPath}/sessions/create">
        <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
        <input type="hidden" name="groupId" value="${param.groupId}" />
        <div class="mb-3">
            <label class="form-label">Title</label>
            <input class="form-control" type="text" name="titre" required>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Start</label>
                <input class="form-control" type="datetime-local" name="debut" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">End</label>
                <input class="form-control" type="datetime-local" name="fin" required>
            </div>
        </div>
        <div class="mb-3">
            <label class="form-label">Description</label>
            <textarea class="form-control" name="description" rows="4"></textarea>
        </div>
        <button class="btn btn-primary" type="submit">Save</button>
        <a class="btn btn-link" href="${pageContext.request.contextPath}/groups/list">Cancel</a>
    </form>
    </div>
</body>
</html>

