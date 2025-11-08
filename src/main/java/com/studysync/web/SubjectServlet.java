package com.studysync.web;

import com.studysync.dao.SubjectDAO;
import com.studysync.model.Student;
import com.studysync.model.Subject;
import com.studysync.util.FlashMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SubjectServlet", urlPatterns = {"/subjects/*"})
public class SubjectServlet extends HttpServlet {
    private final SubjectDAO subjectDAO = new SubjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        Student user = currentUser(req);
        req.setAttribute("isAdmin", isAdmin(user));

        if (path == null || "/".equals(path) || "/list".equals(path)) {
            // Pagination parameters
            int page = 1;
            int pageSize = 20;
            try {
                String pageParam = req.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            long totalCount = subjectDAO.count();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            int offset = (page - 1) * pageSize;
            
            List<Subject> subjects = subjectDAO.findAll(offset, pageSize);
            req.setAttribute("subjects", subjects);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCount", totalCount);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("paginationBaseUrl", req.getContextPath() + "/subjects/list");
            req.getRequestDispatcher("/WEB-INF/views/subjects/list.jsp").forward(req, resp);
        } else if ("/create".equals(path)) {
            if (!ensureAdmin(req, resp)) return;
            req.getRequestDispatcher("/WEB-INF/views/subjects/create.jsp").forward(req, resp);
        } else if ("/edit".equals(path)) {
            if (!ensureAdmin(req, resp)) return;
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            Subject s = subjectDAO.findById(id);
            if (s == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            req.setAttribute("subject", s);
            req.getRequestDispatcher("/WEB-INF/views/subjects/edit.jsp").forward(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/create".equals(path)) {
            if (!ensureAdmin(req, resp)) return;
            String nom = req.getParameter("nom");
            if (nom == null || nom.trim().isEmpty()) {
                FlashMessage.setError(req, "Subject name is required");
                resp.sendRedirect(req.getContextPath() + "/subjects/create");
                return;
            }
            String description = req.getParameter("description");
            Subject s = new Subject();
            s.setNom(nom.trim());
            s.setDescription(description != null ? description.trim() : "");
            subjectDAO.saveOrUpdate(s);
            FlashMessage.setSuccess(req, "Subject created successfully!");
            resp.sendRedirect(req.getContextPath() + "/subjects/list");
        } else if ("/edit".equals(path)) {
            if (!ensureAdmin(req, resp)) return;
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            Subject s = subjectDAO.findById(id);
            if (s == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            String nom = req.getParameter("nom");
            if (nom == null || nom.trim().isEmpty()) {
                FlashMessage.setError(req, "Subject name is required");
                resp.sendRedirect(req.getContextPath() + "/subjects/edit?id=" + id);
                return;
            }
            s.setNom(nom.trim());
            s.setDescription(req.getParameter("description") != null ? req.getParameter("description").trim() : "");
            subjectDAO.saveOrUpdate(s);
            FlashMessage.setSuccess(req, "Subject updated successfully!");
            resp.sendRedirect(req.getContextPath() + "/subjects/list");
        } else if ("/delete".equals(path)) {
            if (!ensureAdmin(req, resp)) return;
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            Subject s = subjectDAO.findById(id);
            if (s != null) {
                subjectDAO.delete(s);
                FlashMessage.setSuccess(req, "Subject deleted successfully!");
            }
            resp.sendRedirect(req.getContextPath() + "/subjects/list");
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private Long parseLong(String v) { try { return v == null ? null : Long.parseLong(v); } catch (NumberFormatException e) { return null; } }

    private Student currentUser(HttpServletRequest req) {
        javax.servlet.http.HttpSession session = req.getSession(false);
        if (session == null) return null;
        Object user = session.getAttribute("user");
        return user instanceof Student ? (Student) user : null;
    }

    private boolean ensureAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Student user = currentUser(req);
        if (user == null) {
            FlashMessage.setError(req, "Please sign in to manage subjects.");
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return false;
        }
        if (!isAdmin(user)) {
            FlashMessage.setError(req, "You do not have permission to manage subjects.");
            resp.sendRedirect(req.getContextPath() + "/subjects/list");
            return false;
        }
        return true;
    }

    private boolean isAdmin(Student user) {
        return user != null && user.getRoles() != null && user.getRoles().stream()
                .anyMatch(role -> role != null && role.getNom() != null && role.getNom().equalsIgnoreCase("Admin"));
    }
}

