package com.studysync.web;

import com.studysync.dao.SubjectDAO;
import com.studysync.model.Student;
import com.studysync.model.Subject;
import com.studysync.model.StudyGroup;
import com.studysync.service.GroupService;
import com.studysync.util.FlashMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "GroupServlet", urlPatterns = {"/groups/*"})
public class GroupServlet extends HttpServlet {
    private final GroupService groupService = new GroupService();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/".equals(path) || "/list".equals(path)) {
            // Pagination parameters
            int page = 1;
            int pageSize = 10;
            try {
                String pageParam = req.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            com.studysync.dao.StudyGroupDAO dao = new com.studysync.dao.StudyGroupDAO();
            long totalCount = dao.count();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            int offset = (page - 1) * pageSize;
            
            List<StudyGroup> groups = dao.findAll(offset, pageSize);
            req.setAttribute("groups", groups);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCount", totalCount);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("paginationBaseUrl", req.getContextPath() + "/groups/list");
            
            Student user = (Student) req.getSession().getAttribute("user");
            if (user != null) {
                java.util.Set<Long> joinedIds = dao.findJoinedGroupIds(user.getId());
                req.setAttribute("joinedGroupIds", joinedIds);
                // Provide CSV string for EL compatibility where 'in' operator may not be available
                String csv = "," + joinedIds.stream().map(String::valueOf).collect(java.util.stream.Collectors.joining(",")) + ",";
                req.setAttribute("joinedGroupIdsCsv", csv);
                java.util.Set<Long> creatorIds = dao.findCreatorGroupIds(user.getId());
                String creatorsCsv = "," + creatorIds.stream().map(String::valueOf).collect(java.util.stream.Collectors.joining(",")) + ",";
                req.setAttribute("creatorGroupIdsCsv", creatorsCsv);
            }
            req.getRequestDispatcher("/WEB-INF/views/groups/list.jsp").forward(req, resp);
        } else if ("/create".equals(path)) {
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/auth/login");
                return;
            }
            List<Subject> allSubjects = loadAllSubjectsSafely(req);
            req.setAttribute("allSubjects", allSubjects);
            req.setAttribute("breadcrumbItems", Arrays.asList("Home", "Groups", "Create"));
            req.setAttribute("breadcrumbUrls", Arrays.asList(
                    req.getContextPath() + "/",
                    req.getContextPath() + "/groups/list",
                    ""
            ));
            req.getRequestDispatcher("/WEB-INF/views/groups/create.jsp").forward(req, resp);
        } else if ("/edit".equals(path)) {
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            StudyGroup g = new com.studysync.dao.StudyGroupDAO().findByIdWithSubjects(id);
            if (g == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null || !new com.studysync.dao.StudyGroupDAO().findCreatorGroupIds(user.getId()).contains(id)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            req.setAttribute("group", g);
            List<Subject> allSubjects = loadAllSubjectsSafely(req);
            req.setAttribute("allSubjects", allSubjects);
            req.setAttribute("breadcrumbItems", Arrays.asList("Home", "Groups", "Edit"));
            req.setAttribute("breadcrumbUrls", Arrays.asList(
                    req.getContextPath() + "/",
                    req.getContextPath() + "/groups/list",
                    req.getContextPath() + "/groups/view?id=" + id
            ));
            req.getRequestDispatcher("/WEB-INF/views/groups/edit.jsp").forward(req, resp);
        } else if ("/view".equals(path)) {
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            try {
                StudyGroup g = new com.studysync.dao.StudyGroupDAO().findByIdWithSubjects(id);
                if (g == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
                req.setAttribute("group", g);
                // Pagination for sessions
                int page = 1;
                int pageSize = 10;
                try {
                    String pageParam = req.getParameter("page");
                    if (pageParam != null && !pageParam.isEmpty()) {
                        page = Integer.parseInt(pageParam);
                        if (page < 1) page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
                
                // Pre-fetch sessions to avoid lazy initialization issues in JSP
                com.studysync.dao.StudySessionDAO sessionDAO = new com.studysync.dao.StudySessionDAO();
                long totalCount = sessionDAO.countByGroupId(id);
                int totalPages = (int) Math.ceil((double) totalCount / pageSize);
                int offset = (page - 1) * pageSize;
                java.util.List<com.studysync.model.StudySession> sessions = sessionDAO.findByGroupId(id, offset, pageSize);
                req.setAttribute("sessionsForGroup", sessions != null ? sessions : java.util.Collections.emptyList());
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalCount", totalCount);
                req.setAttribute("pageSize", pageSize);
                req.setAttribute("paginationBaseUrl", req.getContextPath() + "/groups/view?id=" + id);
                req.getRequestDispatcher("/WEB-INF/views/groups/view.jsp").forward(req, resp);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading group: " + e.getMessage());
            }
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/create".equals(path)) {
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/auth/login");
                return;
            }
            String nom = req.getParameter("nom");
            if (nom == null || nom.trim().isEmpty()) {
                FlashMessage.setError(req, "Group name is required");
                resp.sendRedirect(req.getContextPath() + "/groups/create");
                return;
            }
            if (nom.length() > 255) {
                FlashMessage.setError(req, "Group name must be less than 255 characters");
                resp.sendRedirect(req.getContextPath() + "/groups/create");
                return;
            }
            String description = req.getParameter("description");
            boolean estOuvert = req.getParameter("estOuvert") != null;
            StudyGroup g = groupService.creerGroupe(nom.trim(), description != null ? description.trim() : "", estOuvert, user);
            String[] subjectIds = req.getParameterValues("subjectIds");
            java.util.Set<Long> ids = new java.util.HashSet<>();
            if (subjectIds != null) {
                for (String sid : subjectIds) {
                    Long lid = parseLong(sid);
                    if (lid != null) ids.add(lid);
                }
            }
            groupService.attacherSujets(g, ids);
            FlashMessage.setSuccess(req, "Group created successfully!");
            resp.sendRedirect(req.getContextPath() + "/groups/list");
        } else if ("/edit".equals(path)) {
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            StudyGroup g = groupService.trouverParId(id);
            if (g == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null || !new com.studysync.dao.StudyGroupDAO().findCreatorGroupIds(user.getId()).contains(id)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            g.setNom(req.getParameter("nom"));
            g.setDescription(req.getParameter("description"));
            g.setEstOuvert(req.getParameter("estOuvert") != null);
            String[] subjectIds = req.getParameterValues("subjectIds");
            java.util.Set<Long> ids = new java.util.HashSet<>();
            if (subjectIds != null) {
                for (String sid : subjectIds) {
                    Long lid = parseLong(sid);
                    if (lid != null) ids.add(lid);
                }
            }
            String nom = req.getParameter("nom");
            if (nom == null || nom.trim().isEmpty()) {
                FlashMessage.setError(req, "Group name is required");
                resp.sendRedirect(req.getContextPath() + "/groups/edit?id=" + id);
                return;
            }
            g.setNom(nom.trim());
            groupService.attacherSujets(g, ids);
            groupService.modifierGroupe(g);
            FlashMessage.setSuccess(req, "Group updated successfully!");
            resp.sendRedirect(req.getContextPath() + "/groups/list");
        } else if ("/delete".equals(path)) {
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null || !new com.studysync.dao.StudyGroupDAO().findCreatorGroupIds(user.getId()).contains(id)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            StudyGroup g = groupService.trouverParId(id);
            if (g != null) {
                groupService.supprimerGroupe(g);
                FlashMessage.setSuccess(req, "Group deleted successfully!");
            }
            resp.sendRedirect(req.getContextPath() + "/groups/list");
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private List<Subject> loadAllSubjectsSafely(HttpServletRequest req) {
        try {
            List<Subject> subjects = subjectDAO.findAll();
            return subjects != null ? subjects : Collections.emptyList();
        } catch (RuntimeException e) {
            log("Failed to load subjects list", e);
            req.setAttribute("flashError", "Unable to load subjects right now. Please try again later.");
            return Collections.emptyList();
        }
    }

    private Long parseLong(String v) {
        try { return v == null ? null : Long.parseLong(v); } catch (NumberFormatException e) { return null; }
    }
}


