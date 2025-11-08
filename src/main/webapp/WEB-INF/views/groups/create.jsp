<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Group - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4" style="max-width: 640px;">
    <%@ include file="/WEB-INF/views/includes/breadcrumb.jspf" %>
    <h3>Create Group</h3>
    <form method="post" action="${pageContext.request.contextPath}/groups/create">
        <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
        <div class="mb-3">
            <label class="form-label">Name</label>
            <input class="form-control" type="text" name="nom" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Description</label>
            <textarea class="form-control" name="description" rows="4"></textarea>
        </div>
        <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="open" name="estOuvert" checked>
            <label class="form-check-label" for="open">Open group</label>
        </div>
        <div class="mb-3">
            <label class="form-label">Subjects</label>
            <jsp:useBean id="allSubjects" scope="request" type="java.util.List" />
            <c:if test="${not empty allSubjects}">
                <div class="border rounded p-2" style="max-height: 200px; overflow-y: auto;">
                    <c:forEach var="subj" items="${allSubjects}">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="subjectIds" value="${subj.id}" id="subj_${subj.id}">
                            <label class="form-check-label" for="subj_${subj.id}">${subj.nom}</label>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            <small class="text-muted"><a href="${pageContext.request.contextPath}/subjects/list">Manage subjects</a></small>
        </div>
        <button class="btn btn-primary" type="submit">Save</button>
        <a class="btn btn-link" href="${pageContext.request.contextPath}/groups/list">Cancel</a>
    </form>
    </div>
</body>
</html>

