package com.studysync.web;

import com.studysync.dao.StudySessionDAO;
import com.studysync.dao.StudyGroupDAO;
import com.studysync.model.Student;
import com.studysync.model.StudySession;
import com.studysync.model.StudyGroup;
import com.studysync.service.SessionService;
import com.studysync.util.DateTimeUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {
    private final StudySessionDAO sessionDAO = new StudySessionDAO();
    private final StudyGroupDAO groupDAO = new StudyGroupDAO();
    private final SessionService sessionService = new SessionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Student user = (Student) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        // My groups (currently no pagination needed, but can be added if many groups)
        java.util.List<StudyGroup> myGroups = groupDAO.findByMemberId(user.getId());
        req.setAttribute("myGroups", myGroups);

        // Pagination for Sessions
        int sessionsPage = 1;
        int sessionsPageSize = 5;
        try {
            String pageParam = req.getParameter("sessionsPage");
            if (pageParam != null && !pageParam.isEmpty()) {
                sessionsPage = Integer.parseInt(pageParam);
                if (sessionsPage < 1) sessionsPage = 1;
            }
        } catch (NumberFormatException e) {
            sessionsPage = 1;
        }

        // Sessions limited to my groups
        java.util.List<Long> myGroupIds = new java.util.ArrayList<>();
        for (StudyGroup g : myGroups) myGroupIds.add(g.getId());
        
        // Get all sessions first, then filter upcoming, then paginate
        java.util.List<StudySession> mySessions = sessionDAO.findByGroupIds(myGroupIds);
        java.util.List<StudySession> upcoming = sessionService.prochainesSessions(mySessions);
        
        // Manual pagination after filtering (since we need to filter first)
        long totalSessions = upcoming.size();
        int totalSessionsPages = (int) Math.ceil((double) totalSessions / sessionsPageSize);
        int sessionsOffset = (sessionsPage - 1) * sessionsPageSize;
        java.util.List<StudySession> paginatedSessions = upcoming.stream()
                .skip(sessionsOffset)
                .limit(sessionsPageSize)
                .collect(java.util.stream.Collectors.toList());
        
        req.setAttribute("upcoming", paginatedSessions);
        req.setAttribute("sessionsCurrentPage", sessionsPage);
        req.setAttribute("sessionsTotalPages", totalSessionsPages);
        req.setAttribute("sessionsTotalCount", totalSessions);
        req.setAttribute("sessionsPageSize", sessionsPageSize);
        req.setAttribute("dateTimeUtil", new DateTimeUtil());
        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }
}


