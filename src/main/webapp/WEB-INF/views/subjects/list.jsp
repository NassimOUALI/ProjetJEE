<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Subjects - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4">
    <section class="card-ambient p-4 p-lg-5 mb-4" aria-labelledby="subjects-hero">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
            <div>
                <span class="badge-subtle mb-2" id="subjects-hero">Subjects catalog</span>
                <h2 class="mb-2">Explore subjects to organise your sessions</h2>
                <p class="mb-0">Browse the knowledge areas available across StudySync. Admins can curate and refine the list.</p>
            </div>
            <c:if test="${isAdmin}">
                <a class="btn btn-primary btn-lg" href="${pageContext.request.contextPath}/subjects/create"><i class="bi bi-plus-circle"></i> Create Subject</a>
            </c:if>
        </div>
    </section>

    <c:choose>
        <c:when test="${empty subjects}">
            <div class="empty-state" role="status">
                <i class="bi bi-layers"></i>
                <h5 class="mb-2">No subjects available</h5>
                <p class="mb-3">Once subjects are created they will appear here for everyone to use.</p>
                <c:if test="${isAdmin}">
                    <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/subjects/create">Add first subject</a>
                </c:if>
            </div>
        </c:when>
        <c:otherwise>
            <div class="subjects-list">
                <div class="list-group list-group-flush">
                    <c:forEach var="s" items="${subjects}">
                        <article class="list-group-item" aria-label="Subject ${s.nom}">
                            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
                                <div class="d-flex gap-3 align-items-start">
                                    <div class="subject-icon" aria-hidden="true">
                                        <i class="bi bi-journal-text"></i>
                                    </div>
                                    <div>
                                        <h5 class="mb-1">${s.nom}</h5>
                                        <p class="mb-0 small">${fn:length(s.description) > 160 ? fn:substring(s.description, 0, 157).concat('...') : s.description}</p>
                                    </div>
                                </div>
                                <c:if test="${isAdmin}">
                                    <div class="d-flex flex-wrap gap-2">
                                        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/subjects/edit?id=${s.id}"><i class="bi bi-pencil"></i> Edit</a>
                                        <form method="post" action="${pageContext.request.contextPath}/subjects/delete" class="m-0">
                                            <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
                                            <input type="hidden" name="id" value="${s.id}" />
                                            <button class="btn btn-sm btn-outline-danger" type="submit"><i class="bi bi-trash"></i> Delete</button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <%@ include file="/WEB-INF/views/includes/pagination.jspf" %>
</div>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>

