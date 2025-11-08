<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .session-card { border-left: 4px solid #0d6efd; }
        .session-card .time { font-weight: 600; }
    </style>
    </head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<c:set var="currentUser" value="${sessionScope.user}" />
<div class="container py-4">
    <section class="card-ambient p-4 p-lg-5 mb-4" aria-labelledby="dashboard-intro">
        <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
            <div>
                <span class="badge-subtle mb-2" id="dashboard-intro">Dashboard overview</span>
                <h2 class="mb-2">Welcome back${currentUser != null ? ", " : ""}${currentUser != null ? currentUser.prenom : ""}!</h2>
                <p class="mb-0">Stay on top of your study groups and upcoming sessions with a refreshed look.</p>
            </div>
            <a class="btn btn-primary btn-lg" href="${pageContext.request.contextPath}/groups/list">
                <i class="bi bi-compass"></i> Discover new groups
            </a>
        </div>
    </section>

    <div class="row g-4">
        <div class="col-12 col-lg-5">
            <section class="card-ambient h-100 p-4" aria-labelledby="my-groups-heading">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <h3 class="mb-1" id="my-groups-heading">My Groups</h3>
                        <p class="mb-0 small">${empty myGroups ? 0 : fn:length(myGroups)} active group${empty myGroups || fn:length(myGroups) == 1 ? '' : 's'}</p>
                    </div>
                    <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/groups/list">
                        <i class="bi bi-people"></i> Browse all
                    </a>
                </div>
                <c:choose>
                    <c:when test="${empty myGroups}">
                        <div class="empty-state" role="status">
                            <i class="bi bi-emoji-smile"></i>
                            <h5 class="mb-2">No groups yet</h5>
                            <p class="mb-3">Join a group to start collaborating with fellow learners.</p>
                            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/groups/list">Explore groups</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row g-3">
                            <c:forEach var="g" items="${myGroups}">
                                <div class="col-12">
                                    <article class="card-ambient p-3 h-100" aria-label="${g.nom}">
                                        <div class="d-flex justify-content-between align-items-start gap-3">
                                            <div>
                                                <h5 class="mb-1">${g.nom}</h5>
                                                <p class="mb-2 small">${fn:length(g.description) > 120 ? fn:substring(g.description, 0, 117).concat('...') : g.description}</p>
                                                <div class="d-flex flex-wrap gap-2">
                                                    <a class="btn btn-sm btn-outline-dark" href="${pageContext.request.contextPath}/groups/view?id=${g.id}"><i class="bi bi-eye"></i> View</a>
                                                    <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/sessions/create?groupId=${g.id}"><i class="bi bi-plus-circle"></i> New Session</a>
                                                </div>
                                            </div>
                                        </div>
                                    </article>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
        <div class="col-12 col-lg-7">
            <section class="card-ambient h-100 p-4" aria-labelledby="upcoming-heading">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <h3 class="mb-1" id="upcoming-heading">Upcoming Sessions</h3>
                        <p class="mb-0 small">Sessions from groups you're part of</p>
                    </div>
                </div>
                <c:choose>
                    <c:when test="${empty upcoming}">
                        <div class="empty-state" role="status">
                            <i class="bi bi-calendar2-week"></i>
                            <h5 class="mb-2">You're all caught up</h5>
                            <p class="mb-3">No upcoming sessions right now. Create one to keep the momentum going.</p>
                            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/sessions/create"><i class="bi bi-plus-circle"></i> Schedule a session</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="s" items="${upcoming}">
                                <article class="card-ambient p-4" aria-labelledby="session-${s.id}">
                                    <div class="d-flex justify-content-between flex-wrap align-items-start gap-3">
                                        <div>
                                            <h5 class="mb-1" id="session-${s.id}">${s.titre}</h5>
                                            <div class="session-meta">
                                                <span><i class="bi bi-people"></i> ${s.groupe.nom}</span>
                                                <span><i class="bi bi-person-check"></i> Hosted by ${s.organisateur.prenom} ${s.organisateur.nom}</span>
                                                <span>
                                                    <i class="bi bi-clock-history"></i>
                                                    <fmt:formatDate value="${dateTimeUtil.toDate(s.heureDebut)}" pattern="EEE, MMM d 'at' HH:mm" />
                                                    <span aria-hidden="true">→</span>
                                                    <fmt:formatDate value="${dateTimeUtil.toDate(s.heureFin)}" pattern="HH:mm" />
                                                </span>
                                            </div>
                                        </div>
                                        <span class="chip warm">
                                            <i class="bi bi-lightning"></i>
                                            Upcoming
                                        </span>
                                    </div>
                                    <c:if test="${not empty s.description}">
                                        <p class="mt-3 mb-4">${fn:length(s.description) > 180 ? fn:substring(s.description, 0, 177).concat('...') : s.description}</p>
                                    </c:if>
                                    <div class="d-flex flex-wrap gap-2">
                                        <a class="btn btn-sm btn-outline-dark" href="${pageContext.request.contextPath}/posts/view?sessionId=${s.id}"><i class="bi bi-chat-left-text"></i> Session Posts</a>
                                        <c:if test="${sessionScope.user.id == s.organisateur.id}">
                                            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/sessions/edit?id=${s.id}"><i class="bi bi-pencil"></i> Edit</a>
                                            <form method="post" action="${pageContext.request.contextPath}/sessions/cancel" class="m-0">
                                                <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
                                                <input type="hidden" name="id" value="${s.id}" />
                                                <button class="btn btn-sm btn-outline-danger" type="submit"><i class="bi bi-x-circle"></i> Cancel</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                        <c:if test="${sessionsTotalPages > 1}">
                            <c:set var="paginationBaseUrl" value="${pageContext.request.contextPath}/dashboard" />
                            <c:set var="currentPage" value="${sessionsCurrentPage}" />
                            <c:set var="totalPages" value="${sessionsTotalPages}" />
                            <c:set var="totalCount" value="${sessionsTotalCount}" />
                            <c:set var="pageSize" value="${sessionsPageSize}" />
                            <c:set var="pageParamName" value="sessionsPage" />
                            <%@ include file="/WEB-INF/views/includes/pagination.jspf" %>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>

