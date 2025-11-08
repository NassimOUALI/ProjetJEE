<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Session - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4" style="max-width: 640px;">
    <%@ include file="/WEB-INF/views/includes/breadcrumb.jspf" %>
    <h3>Edit Session</h3>
    <form method="post" action="${pageContext.request.contextPath}/sessions/edit">
        <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
        <input type="hidden" name="id" value="${sessionObj.id}" />
        <div class="mb-3">
            <label class="form-label">Title</label>
            <input class="form-control" type="text" name="titre" value="${sessionObj.titre}" required>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Start</label>
                <c:set var="debutLocal" value="${sessionObj.heureDebut.toString().substring(0, 16)}" />
                <input class="form-control" type="datetime-local" name="debut" value="${debutLocal}" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">End</label>
                <c:set var="finLocal" value="${sessionObj.heureFin.toString().substring(0, 16)}" />
                <input class="form-control" type="datetime-local" name="fin" value="${finLocal}" required>
            </div>
        </div>
        <div class="mb-3">
            <label class="form-label">Description</label>
            <textarea class="form-control" name="description" rows="4">${sessionObj.description}</textarea>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-primary" type="submit">Save</button>
            <form method="post" action="${pageContext.request.contextPath}/sessions/cancel">
                <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
                <input type="hidden" name="id" value="${sessionObj.id}" />
                <button class="btn btn-outline-danger" type="submit">Cancel Session</button>
            </form>
        </div>
    </form>
    </div>
</body>
</html>

