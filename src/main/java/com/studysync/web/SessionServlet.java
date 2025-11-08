package com.studysync.web;

import com.studysync.dao.StudyGroupDAO;
import com.studysync.model.Student;
import com.studysync.model.StudyGroup;
import com.studysync.model.StudySession;
import com.studysync.service.SessionService;
import com.studysync.service.GroupService;
import com.studysync.util.FlashMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Set;

@WebServlet(name = "SessionServlet", urlPatterns = {"/sessions/*"})
public class SessionServlet extends HttpServlet {
    private final SessionService sessionService = new SessionService();
    private final GroupService groupService = new GroupService();
    private final StudyGroupDAO groupDAO = new StudyGroupDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/".equals(path) || "/create".equals(path)) {
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/auth/login");
                return;
            }
            Long groupId = parseLong(req.getParameter("groupId"));
            if (groupId == null) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            StudyGroup group = groupService.trouverParId(groupId);
            if (group == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            Set<Long> joined = groupDAO.findJoinedGroupIds(user.getId());
            if (!joined.contains(groupId)) {
                resp.sendRedirect(req.getContextPath() + "/groups/list?error=joinRequired");
                return;
            }
            req.setAttribute("group", group);
            req.setAttribute("breadcrumbItems", Arrays.asList("Home", "Groups", group.getNom(), "Create Session"));
            req.setAttribute("breadcrumbUrls", Arrays.asList(
                    req.getContextPath() + "/",
                    req.getContextPath() + "/groups/list",
                    req.getContextPath() + "/groups/view?id=" + groupId,
                    ""
            ));
            req.getRequestDispatcher("/WEB-INF/views/sessions/create.jsp").forward(req, resp);
        } else if ("/edit".equals(path)) {
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            com.studysync.dao.StudySessionDAO dao = new com.studysync.dao.StudySessionDAO();
            StudySession s = dao.findById(id);
            if (s == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null || !user.getId().equals(s.getOrganisateur().getId())) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
            req.setAttribute("sessionObj", s);
            req.setAttribute("breadcrumbItems", Arrays.asList("Home", "Dashboard", "Edit Session"));
            req.setAttribute("breadcrumbUrls", Arrays.asList(
                    req.getContextPath() + "/",
                    req.getContextPath() + "/dashboard",
                    ""
            ));
            req.getRequestDispatcher("/WEB-INF/views/sessions/edit.jsp").forward(req, resp);
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
            Long groupId = parseLong(req.getParameter("groupId"));
            if (groupId == null) {
                FlashMessage.setError(req, "A group must be selected for the session.");
                resp.sendRedirect(req.getContextPath() + "/groups/list");
                return;
            }
            StudyGroup group = groupService.trouverParId(groupId);
            if (group == null) {
                FlashMessage.setError(req, "The selected group could not be found.");
                resp.sendRedirect(req.getContextPath() + "/groups/list");
                return;
            }
            java.util.Set<Long> joined = groupDAO.findJoinedGroupIds(user.getId());
            if (!joined.contains(groupId)) {
                resp.sendRedirect(req.getContextPath() + "/groups/list?error=joinRequired");
                return;
            }
            String titre = req.getParameter("titre");
            String description = req.getParameter("description");
            if (titre == null || titre.trim().isEmpty()) {
                FlashMessage.setError(req, "Session title is required");
                resp.sendRedirect(req.getContextPath() + "/sessions/create?groupId=" + groupId);
                return;
            }
            String debutStr = req.getParameter("debut");
            String finStr = req.getParameter("fin");
            if (debutStr == null || finStr == null) {
                FlashMessage.setError(req, "Start and end times are required");
                resp.sendRedirect(req.getContextPath() + "/sessions/create?groupId=" + groupId);
                return;
            }
            try {
                LocalDateTime debut = parseDateTime(debutStr);
                LocalDateTime fin = parseDateTime(finStr);
                if (fin.isBefore(debut) || fin.isEqual(debut)) {
                    FlashMessage.setError(req, "End time must be after start time");
                    resp.sendRedirect(req.getContextPath() + "/sessions/create?groupId=" + groupId);
                    return;
                }
                sessionService.planifierSession(titre.trim(), debut, fin, description != null ? description.trim() : "", group, user);
                FlashMessage.setSuccess(req, "Session created successfully!");
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            } catch (Exception ex) {
                FlashMessage.setError(req, "Invalid date/time format");
                resp.sendRedirect(req.getContextPath() + "/sessions/create?groupId=" + groupId);
            }
        } else if ("/edit".equals(path)) {
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            com.studysync.dao.StudySessionDAO dao = new com.studysync.dao.StudySessionDAO();
            StudySession s = dao.findById(id);
            if (s == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null || !user.getId().equals(s.getOrganisateur().getId())) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
            String titre = req.getParameter("titre");
            if (titre == null || titre.trim().isEmpty()) {
                FlashMessage.setError(req, "Session title is required");
                resp.sendRedirect(req.getContextPath() + "/sessions/edit?id=" + id);
                return;
            }
            String debutStr = req.getParameter("debut");
            String finStr = req.getParameter("fin");
            if (debutStr == null || finStr == null) {
                FlashMessage.setError(req, "Start and end times are required");
                resp.sendRedirect(req.getContextPath() + "/sessions/edit?id=" + id);
                return;
            }
            try {
                LocalDateTime debut = parseDateTime(debutStr);
                LocalDateTime fin = parseDateTime(finStr);
                if (fin.isBefore(debut) || fin.isEqual(debut)) {
                    FlashMessage.setError(req, "End time must be after start time");
                    resp.sendRedirect(req.getContextPath() + "/sessions/edit?id=" + id);
                    return;
                }
                s.setTitre(titre.trim());
                s.setDescription(req.getParameter("description") != null ? req.getParameter("description").trim() : "");
                s.setHeureDebut(debut);
                s.setHeureFin(fin);
                new com.studysync.dao.StudySessionDAO().saveOrUpdate(s);
                FlashMessage.setSuccess(req, "Session updated successfully!");
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            } catch (Exception ex) {
                FlashMessage.setError(req, "Invalid date/time format");
                resp.sendRedirect(req.getContextPath() + "/sessions/edit?id=" + id);
            }
        } else if ("/cancel".equals(path)) {
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            com.studysync.dao.StudySessionDAO dao = new com.studysync.dao.StudySessionDAO();
            StudySession s = dao.findById(id);
            if (s == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null || !user.getId().equals(s.getOrganisateur().getId())) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
            dao.delete(s);
            FlashMessage.setSuccess(req, "Session cancelled successfully!");
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private Long parseLong(String v) { try { return v == null ? null : Long.parseLong(v); } catch (NumberFormatException e) { return null; } }
    private LocalDateTime parseDateTime(String v) { return LocalDateTime.parse(v, DateTimeFormatter.ISO_LOCAL_DATE_TIME); }
}


