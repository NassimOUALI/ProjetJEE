<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Group Details - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4">
    <c:if test="${not empty group}">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/groups/list">Groups</a></li>
                <li class="breadcrumb-item active" aria-current="page">${group.nom}</li>
            </ol>
        </nav>
    </c:if>
    <c:choose>
        <c:when test="${empty group}">
            <div class="alert alert-danger">Group not found.</div>
        </c:when>
        <c:otherwise>
            <h3 class="mt-2">${group.nom}</h3>
            <p>${group.description}</p>
            <c:if test="${not empty group.sujets}">
                <div class="mb-2">
                    <strong>Subjects:</strong>
                    <c:forEach var="subj" items="${group.sujets}" varStatus="status">
                        <span class="badge bg-info">${subj.nom}</span>
                        <c:if test="${!status.last}"> </c:if>
                    </c:forEach>
                </div>
            </c:if>
            <div class="mb-3">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/sessions/create?groupId=${group.id}">Create Session</a>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/posts/view?groupId=${group.id}">View Posts</a>
                <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/posts/create?groupId=${group.id}">New Post</a>
            </div>

            <h5>Sessions</h5>
            <c:choose>
                <c:when test="${empty sessionsForGroup}">
                    <div class="alert alert-info">No sessions yet for this group.</div>
                </c:when>
                <c:otherwise>
                    <div class="list-group">
                        <c:forEach var="s" items="${sessionsForGroup}">
                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="fw-semibold">${s.titre}</div>
                                    <small class="text-muted"><i class="bi bi-clock"></i>
                                        <c:set var="debutStr" value="${s.heureDebut.toString().replace('T', ' ').substring(0, 16)}" />
                                        <c:set var="finStr" value="${s.heureFin.toString().replace('T', ' ').substring(0, 16)}" />
                                        ${debutStr} → ${finStr}
                                    </small>
                                </div>
                                <div class="d-flex gap-2">
                                    <a class="btn btn-sm btn-outline-dark" href="${pageContext.request.contextPath}/posts/view?sessionId=${s.id}">Session Posts</a>
                                    <c:if test="${not empty sessionScope.user and not empty s.organisateur and sessionScope.user.id == s.organisateur.id}">
                                        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/sessions/edit?id=${s.id}">Edit</a>
                                        <form method="post" action="${pageContext.request.contextPath}/sessions/cancel" class="m-0">
                                            <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
                                            <input type="hidden" name="id" value="${s.id}" />
                                            <button class="btn btn-sm btn-outline-danger" type="submit">Cancel</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
            <%@ include file="/WEB-INF/views/includes/pagination.jspf" %>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>

