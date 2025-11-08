<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Post - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4" style="max-width: 640px;">
    <h3>Create Post</h3>
    <form method="post" action="${pageContext.request.contextPath}/posts/create">
        <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
        <input type="hidden" name="groupId" value="${param.groupId}" />
        <input type="hidden" name="sessionId" value="${param.sessionId}" />
        <input type="hidden" name="redirect" value="${param.redirect}" />
        <div class="mb-3">
            <label class="form-label">Type</label>
            <select class="form-select" name="type">
                <option value="Comment">Comment</option>
                <option value="Resource">Resource</option>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Content</label>
            <textarea class="form-control" rows="5" name="contenu" required></textarea>
        </div>
        <button class="btn btn-primary" type="submit">Post</button>
        <c:choose>
            <c:when test='${not empty param.sessionId}'>
                <a class="btn btn-link" href="${pageContext.request.contextPath}/posts/view?sessionId=${param.sessionId}">Cancel</a>
            </c:when>
            <c:otherwise>
                <a class="btn btn-link" href="${pageContext.request.contextPath}/posts/view?groupId=${param.groupId}">Cancel</a>
            </c:otherwise>
        </c:choose>
    </form>
    </div>
</body>
</html>

