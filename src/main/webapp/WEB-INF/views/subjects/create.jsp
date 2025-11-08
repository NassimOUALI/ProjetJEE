<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Subject - StudySync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/includes/nav.jspf" %>
<%@ include file="/WEB-INF/views/includes/flash-messages.jspf" %>
<div class="container py-4" style="max-width: 640px;">
    <h3>Create Subject</h3>
    <form method="post" action="${pageContext.request.contextPath}/subjects/create">
        <%@ include file="/WEB-INF/views/includes/csrf-token.jspf" %>
        <div class="mb-3">
            <label class="form-label">Name</label>
            <input class="form-control" type="text" name="nom" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Description</label>
            <textarea class="form-control" name="description" rows="4"></textarea>
        </div>
        <button class="btn btn-primary" type="submit">Save</button>
        <a class="btn btn-link" href="${pageContext.request.contextPath}/subjects/list">Cancel</a>
    </form>
</div>
<%@ include file="/WEB-INF/views/includes/footer.jspf" %>
</body>
</html>

