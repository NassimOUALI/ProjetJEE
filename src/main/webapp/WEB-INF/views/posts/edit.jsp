<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Post - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4" style="max-width: 640px;">
    <h3>Edit Post</h3>
    <form method="post" action="${pageContext.request.contextPath}/posts/edit">
        <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
        <input type="hidden" name="id" value="${post.id}" />
        <div class="mb-3">
            <label class="form-label">Type</label>
            <select class="form-select" name="type">
                <option value="Comment" ${post.type == 'Comment' ? 'selected' : ''}>Comment</option>
                <option value="Resource" ${post.type == 'Resource' ? 'selected' : ''}>Resource</option>
                <option value="Announcement" ${post.type == 'Announcement' ? 'selected' : ''}>Announcement</option>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Content</label>
            <textarea class="form-control" name="contenu" rows="6" required>${post.contenu}</textarea>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-primary" type="submit">Update Post</button>
            <c:choose>
                <c:when test="${not empty sessionId}">
                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/posts/view?sessionId=${sessionId}">Cancel</a>
                </c:when>
                <c:when test="${not empty groupId}">
                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/posts/view?groupId=${groupId}">Cancel</a>
                </c:when>
                <c:when test="${not empty param.sessionId}">
                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/posts/view?sessionId=${param.sessionId}">Cancel</a>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/posts/view?groupId=${param.groupId}">Cancel</a>
                </c:otherwise>
            </c:choose>
        </div>
    </form>
</div>
</body>
</html>

