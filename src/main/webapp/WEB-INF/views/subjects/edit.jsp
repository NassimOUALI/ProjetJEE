<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Subject - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4" style="max-width: 640px;">
    <h3>Edit Subject</h3>
    <form method="post" action="${pageContext.request.contextPath}/subjects/edit">
        <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
        <input type="hidden" name="id" value="${subject.id}" />
        <div class="mb-3">
            <label class="form-label">Name</label>
            <input class="form-control" type="text" name="nom" value="${subject.nom}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Description</label>
            <textarea class="form-control" name="description" rows="4">${subject.description}</textarea>
        </div>
        <button class="btn btn-primary" type="submit">Save</button>
        <a class="btn btn-link" href="${pageContext.request.contextPath}/subjects/list">Cancel</a>
    </form>
</div>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>

