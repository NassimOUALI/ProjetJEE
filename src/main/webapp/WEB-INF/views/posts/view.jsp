<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Posts - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Posts<c:if test="${not empty group}"> — ${group.nom}</c:if><c:if test="${not empty sessionObj}"> — Session: ${sessionObj.titre}</c:if></h3>
        <c:set var="currentSessionId" value="${not empty param.sessionId ? param.sessionId : sessionId}" />
        <c:set var="currentGroupId" value="${not empty param.groupId ? param.groupId : (not empty groupId ? groupId : (not empty group ? group.id : ''))}" />
        <c:choose>
            <c:when test='${not empty currentSessionId}'>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/posts/create?sessionId=${currentSessionId}&redirect=${pageContext.request.contextPath}/posts/view?sessionId=${currentSessionId}">New Post</a>
                    </c:when>
            <c:when test='${not empty currentGroupId}'>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/posts/create?groupId=${currentGroupId}&redirect=${pageContext.request.contextPath}/posts/view?groupId=${currentGroupId}">New Post</a>
            </c:when>
            <c:otherwise>
                <button class="btn btn-outline-secondary" type="button" disabled>New Post</button>
            </c:otherwise>
        </c:choose>
    </div>
    <c:if test='${param.error == "joinRequired"}'>
        <div class="alert alert-warning">You must join the group to post here.</div>
    </c:if>
    <c:choose>
        <c:when test="${empty posts}">
            <div class="alert alert-info">No posts yet.</div>
        </c:when>
        <c:otherwise>
            <div class="list-group">
                <c:forEach var="p" items="${posts}">
                    <div class="list-group-item mb-2 shadow-sm">
                        <div class="d-flex w-100 justify-content-between align-items-start mb-2">
                            <div class="d-flex align-items-center">
                                <span class="badge ${p.type == 'Resource' ? 'bg-info' : p.type == 'Announcement' ? 'bg-warning' : 'bg-secondary'} me-2">${p.type}</span>
                                <div>
                                    <strong class="d-block">${p.auteur.prenom} ${p.auteur.nom}</strong>
                                    <small class="text-muted">
                                        <c:set var="pubStr" value="${p.datePublication.toString().replace('T', ' ').substring(0, 16)}" />
                                        <i class="bi bi-clock"></i> ${pubStr}
                                    </small>
                                </div>
                            </div>
                            <c:if test="${not empty sessionScope.user and sessionScope.user.id == p.auteur.id}">
                                <div class="d-flex gap-1">
                                    <c:set var="editUrl" value="${pageContext.request.contextPath}/posts/edit?id=${p.id}" />
                                    <c:if test="${not empty currentSessionId}">
                                        <c:set var="editUrl" value="${editUrl}&sessionId=${currentSessionId}" />
                                    </c:if>
                                    <c:if test="${not empty currentGroupId}">
                                        <c:set var="editUrl" value="${editUrl}&groupId=${currentGroupId}" />
                                    </c:if>
                                    <a class="btn btn-sm btn-outline-secondary" href="${editUrl}" title="Edit post">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <form method="post" action="${pageContext.request.contextPath}/posts/delete" class="m-0">
                                        <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
                                        <input type="hidden" name="id" value="${p.id}" />
                                        <c:if test="${not empty currentSessionId}">
                                            <input type="hidden" name="sessionId" value="${currentSessionId}" />
                                        </c:if>
                                        <c:if test="${not empty currentGroupId}">
                                            <input type="hidden" name="groupId" value="${currentGroupId}" />
                                        </c:if>
                                        <button class="btn btn-sm btn-outline-danger" type="submit" onclick="return confirm('Are you sure you want to delete this post?');" title="Delete post">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                        <p class="mb-0">${p.contenu}</p>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
    <%@ include file="/WEB-INF/views/includes/pagination.jspf" %>
</div>
</body>
</html>

