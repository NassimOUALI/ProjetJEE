package com.studysync.web;

import com.studysync.dao.PostDAO;
import com.studysync.dao.StudyGroupDAO;
import com.studysync.model.Post;
import com.studysync.model.Student;
import com.studysync.model.StudyGroup;
import com.studysync.model.StudySession;
import com.studysync.service.GroupService;
import com.studysync.service.PostService;
import com.studysync.util.FlashMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PostServlet", urlPatterns = {"/posts/*"})
public class PostServlet extends HttpServlet {
    private final PostDAO postDAO = new PostDAO();
    private final GroupService groupService = new GroupService();
    private final PostService postService = new PostService();
    private final StudyGroupDAO groupDAO = new StudyGroupDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/".equals(path) || "/create".equals(path)) {
            // Only allow creating posts if user is member of the target group
            Student user = (Student) req.getSession().getAttribute("user");
            Long groupId = parseLong(req.getParameter("groupId"));
            Long sessionId = parseLong(req.getParameter("sessionId"));
            
            // If groupId not provided, try to get it from session
            if (groupId == null && sessionId != null) {
                com.studysync.dao.StudySessionDAO sessionDAO = new com.studysync.dao.StudySessionDAO();
                StudySession session = sessionDAO.findById(sessionId);
                if (session != null && session.getGroupe() != null) {
                    groupId = session.getGroupe().getId();
                }
            }
            
            if (groupId == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            java.util.Set<Long> joined = groupDAO.findJoinedGroupIds(user.getId());
            if (!joined.contains(groupId)) {
                String redirectUrl = sessionId != null ? 
                    req.getContextPath() + "/posts/view?sessionId=" + sessionId + "&error=joinRequired" :
                    req.getContextPath() + "/posts/view?groupId=" + groupId + "&error=joinRequired";
                resp.sendRedirect(redirectUrl);
                return;
            }
            req.getRequestDispatcher("/WEB-INF/views/posts/create.jsp").forward(req, resp);
        } else if ("/edit".equals(path)) {
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            Post post = postDAO.findByIdWithRelations(id);
            if (post == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null || !user.getId().equals(post.getAuteur().getId())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            req.setAttribute("post", post);
            // Prefer URL params (current context) over post's own session/group
            String sessionIdParam = req.getParameter("sessionId");
            String groupIdParam = req.getParameter("groupId");
            if (sessionIdParam != null) {
                req.setAttribute("sessionId", sessionIdParam);
            } else if (post.getSession() != null) {
                req.setAttribute("sessionId", post.getSession().getId());
            }
            if (groupIdParam != null) {
                req.setAttribute("groupId", groupIdParam);
            } else if (post.getGroupe() != null) {
                req.setAttribute("groupId", post.getGroupe().getId());
            }
            req.getRequestDispatcher("/WEB-INF/views/posts/edit.jsp").forward(req, resp);
        } else if ("/view".equals(path)) {
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
            
            Long groupId = parseLong(req.getParameter("groupId"));
            Long sessionId = parseLong(req.getParameter("sessionId"));
            if (groupId != null) {
                long totalCount = postDAO.countByGroupId(groupId);
                int totalPages = (int) Math.ceil((double) totalCount / pageSize);
                int offset = (page - 1) * pageSize;
                List<Post> posts = postDAO.findByGroupId(groupId, offset, pageSize);
                req.setAttribute("posts", posts);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalCount", totalCount);
                req.setAttribute("pageSize", pageSize);
                req.setAttribute("paginationBaseUrl", req.getContextPath() + "/posts/view?groupId=" + groupId);
                StudyGroup g = groupService.trouverParId(groupId);
                req.setAttribute("group", g);
                req.setAttribute("groupId", groupId);
                Student user = (Student) req.getSession().getAttribute("user");
                boolean canPost = user != null && groupDAO.findJoinedGroupIds(user.getId()).contains(groupId);
                req.setAttribute("canPost", canPost);
            } else if (sessionId != null) {
                long totalCount = postDAO.countBySessionId(sessionId);
                int totalPages = (int) Math.ceil((double) totalCount / pageSize);
                int offset = (page - 1) * pageSize;
                List<Post> posts = postDAO.findBySessionId(sessionId, offset, pageSize);
                req.setAttribute("posts", posts);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalCount", totalCount);
                req.setAttribute("pageSize", pageSize);
                req.setAttribute("paginationBaseUrl", req.getContextPath() + "/posts/view?sessionId=" + sessionId);
                com.studysync.dao.StudySessionDAO dao = new com.studysync.dao.StudySessionDAO();
                StudySession sessionObj = dao.findById(sessionId);
                if (sessionObj != null) {
                    req.setAttribute("sessionObj", sessionObj);
                    Long gId = sessionObj.getGroupe().getId();
                    req.setAttribute("groupId", gId);
                    req.setAttribute("sessionId", sessionId);
                    Student user = (Student) req.getSession().getAttribute("user");
                    boolean canPost = user != null && groupDAO.findJoinedGroupIds(user.getId()).contains(gId);
                    req.setAttribute("canPost", canPost);
                }
            }
            req.getRequestDispatcher("/WEB-INF/views/posts/view.jsp").forward(req, resp);
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
                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
            String contenu = req.getParameter("contenu");
            String type = req.getParameter("type");
            Long groupId = parseLong(req.getParameter("groupId"));
            Long sessionId = parseLong(req.getParameter("sessionId"));
            StudyGroup group = groupId != null ? groupService.trouverParId(groupId) : null;
            StudySession session = null;
            if (sessionId != null) {
                com.studysync.dao.StudySessionDAO dao = new com.studysync.dao.StudySessionDAO();
                session = dao.findById(sessionId);
                if (session != null) {
                    group = session.getGroupe();
                }
            }
            if (group != null) {
                java.util.Set<Long> joined = groupDAO.findJoinedGroupIds(user.getId());
                if (!joined.contains(group.getId())) {
                    String redirectUrl = sessionId != null ? (req.getContextPath()+"/posts/view?sessionId="+sessionId) : (req.getContextPath()+"/posts/view?groupId="+group.getId());
                    resp.sendRedirect(redirectUrl + "&error=joinRequired");
                    return;
                }
            }
            if (group == null) {
                FlashMessage.setError(req, "Invalid group or session");
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }
            if (contenu == null || contenu.trim().isEmpty()) {
                FlashMessage.setError(req, "Post content is required");
                String redirectUrl = sessionId != null ? (req.getContextPath()+"/posts/create?sessionId="+sessionId) : (req.getContextPath()+"/posts/create?groupId="+group.getId());
                resp.sendRedirect(redirectUrl);
                return;
            }
            postService.creerPost(contenu.trim(), type != null ? type : "Comment", user, group, session);
            FlashMessage.setSuccess(req, "Post created successfully!");
            String redirect = req.getParameter("redirect");
            if (redirect == null || redirect.isEmpty()) {
                if (sessionId != null) {
                    redirect = req.getContextPath()+"/posts/view?sessionId="+sessionId;
                } else {
                    redirect = req.getContextPath()+"/posts/view?groupId="+group.getId();
                }
            }
            resp.sendRedirect(redirect);
        } else if ("/edit".equals(path)) {
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            Post post = postDAO.findById(id);
            if (post == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null || !user.getId().equals(post.getAuteur().getId())) {
                FlashMessage.setError(req, "You can only edit your own posts");
                String redirect = post.getSession() != null ? 
                    req.getContextPath()+"/posts/view?sessionId="+post.getSession().getId() :
                    req.getContextPath()+"/posts/view?groupId="+post.getGroupe().getId();
                resp.sendRedirect(redirect);
                return;
            }
            String contenu = req.getParameter("contenu");
            String type = req.getParameter("type");
            if (contenu == null || contenu.trim().isEmpty()) {
                FlashMessage.setError(req, "Post content is required");
                resp.sendRedirect(req.getContextPath() + "/posts/edit?id=" + id);
                return;
            }
            post.setContenu(contenu.trim());
            if (type != null && !type.trim().isEmpty()) {
                post.setType(type.trim());
            }
            postDAO.saveOrUpdate(post);
            FlashMessage.setSuccess(req, "Post updated successfully!");
            String redirect = post.getSession() != null ? 
                req.getContextPath()+"/posts/view?sessionId="+post.getSession().getId() :
                req.getContextPath()+"/posts/view?groupId="+post.getGroupe().getId();
            resp.sendRedirect(redirect);
        } else if ("/delete".equals(path)) {
            Long id = parseLong(req.getParameter("id"));
            if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
            Post post = postDAO.findById(id);
            if (post == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
            Student user = (Student) req.getSession().getAttribute("user");
            if (user == null || !user.getId().equals(post.getAuteur().getId())) {
                FlashMessage.setError(req, "You can only delete your own posts");
                String redirect = post.getSession() != null ? 
                    req.getContextPath()+"/posts/view?sessionId="+post.getSession().getId() :
                    req.getContextPath()+"/posts/view?groupId="+post.getGroupe().getId();
                resp.sendRedirect(redirect);
                return;
            }
            // Use params if provided, otherwise use post's own session/group
            Long redirectSessionId = parseLong(req.getParameter("sessionId"));
            Long redirectGroupId = parseLong(req.getParameter("groupId"));
            if (redirectSessionId == null && redirectGroupId == null) {
                redirectSessionId = post.getSession() != null ? post.getSession().getId() : null;
                redirectGroupId = post.getGroupe() != null ? post.getGroupe().getId() : null;
            }
            postDAO.delete(post);
            FlashMessage.setSuccess(req, "Post deleted successfully!");
            String redirect = redirectSessionId != null ? 
                req.getContextPath()+"/posts/view?sessionId="+redirectSessionId :
                req.getContextPath()+"/posts/view?groupId="+redirectGroupId;
            resp.sendRedirect(redirect);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private Long parseLong(String v) { try { return v == null ? null : Long.parseLong(v); } catch (NumberFormatException e) { return null; } }
}


