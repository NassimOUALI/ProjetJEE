<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Groups - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>.badge-open{background:#198754}</style>
    </head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4">
    <c:if test='${param.error == "joinRequired"}'>
        <div class="alert alert-warning">Join the group before creating a session.</div>
    </c:if>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Groups</h3>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/groups/create">Create Group</a>
    </div>
    <c:choose>
        <c:when test="${empty groups}">
            <div class="alert alert-info">No groups yet.</div>
        </c:when>
        <c:otherwise>
            <div class="row g-3">
                <c:forEach var="g" items="${groups}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-body d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <h5 class="card-title mb-0">${g.nom}</h5>
                                    <c:if test="${g.estOuvert}"><span class="badge bg-success">Open</span></c:if>
                                </div>
                                <p class="card-text text-muted small mb-2">ID: ${g.id}</p>
                                <p class="card-text">${g.description}</p>
                                <div class="mt-auto d-flex flex-wrap gap-2">
                                    <c:set var="gidToken" value=",${g.id}," />
                                    <c:choose>
                                        <c:when test='${fn:contains(joinedGroupIdsCsv, gidToken)}'>
                                            <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/sessions/create?groupId=${g.id}"><i class="bi bi-plus-circle"></i> New Session</a>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-sm btn-outline-secondary" type="button" disabled title="Join to create sessions"><i class="bi bi-plus-circle"></i> New Session</button>
                                        </c:otherwise>
                                    </c:choose>
                                    <a class="btn btn-sm btn-outline-dark" href="${pageContext.request.contextPath}/groups/view?id=${g.id}"><i class="bi bi-eye"></i> View</a>
                                    <c:set var="creatorToken" value=",${g.id}," />
                                    <c:if test='${fn:contains(creatorGroupIdsCsv, creatorToken)}'>
                                        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/groups/edit?id=${g.id}"><i class="bi bi-pencil"></i> Edit</a>
                                        <form method="post" action="${pageContext.request.contextPath}/groups/delete" class="m-0">
                                            <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
                                            <input type="hidden" name="id" value="${g.id}" />
                                            <button class="btn btn-sm btn-outline-danger" type="submit"><i class="bi bi-trash"></i> Delete</button>
                                        </form>
                                    </c:if>
                                    <c:choose>
                                        <c:when test='${fn:contains(joinedGroupIdsCsv, gidToken)}'>
                                            <span class="badge bg-primary align-self-center">Joined</span>
                                            <form method="post" action="${pageContext.request.contextPath}/groups/leave" class="m-0">
                                                <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
                                                <input type="hidden" name="groupId" value="${g.id}" />
                                                <c:set var="redirectUrl" value="${pageContext.request.contextPath}/groups/list" />
                                                <c:if test="${not empty param.page}">
                                                    <c:set var="redirectUrl" value="${redirectUrl}?page=${param.page}" />
                                                </c:if>
                                                <input type="hidden" name="redirect" value="${redirectUrl}" />
                                                <button class="btn btn-sm btn-warning" type="submit"><i class="bi bi-box-arrow-left"></i> Leave</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form method="post" action="${pageContext.request.contextPath}/groups/join" class="m-0">
                                                <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
                                                <input type="hidden" name="groupId" value="${g.id}" />
                                                <c:set var="redirectUrl" value="${pageContext.request.contextPath}/groups/list" />
                                                <c:if test="${not empty param.page}">
                                                    <c:set var="redirectUrl" value="${redirectUrl}?page=${param.page}" />
                                                </c:if>
                                                <input type="hidden" name="redirect" value="${redirectUrl}" />
                                                <button class="btn btn-sm btn-success" type="submit"><i class="bi bi-person-plus"></i> Join</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
    <%@ include file="/WEB-INF/views/includes/pagination.jspf" %>
</div>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>

