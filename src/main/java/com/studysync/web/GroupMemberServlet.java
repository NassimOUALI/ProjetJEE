package com.studysync.web;

import com.studysync.model.Student;
import com.studysync.model.StudyGroup;
import com.studysync.service.GroupService;
import com.studysync.util.FlashMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "GroupMemberServlet", urlPatterns = {"/groups/join", "/groups/leave"})
public class GroupMemberServlet extends HttpServlet {
    private final GroupService groupService = new GroupService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Student user = (Student) req.getSession().getAttribute("user");
        Long groupId = parseLong(req.getParameter("groupId"));
        if (groupId == null || user == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST); return; }
        StudyGroup g = groupService.trouverParId(groupId);
        if (g == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
        String path = req.getRequestURI();
        if (path != null && path.endsWith("/join")) {
            groupService.rejoindreGroupe(g, user);
            FlashMessage.setSuccess(req, "Joined group successfully!");
        } else if (path != null && path.endsWith("/leave")) {
            groupService.quitterGroupe(g, user);
            FlashMessage.setSuccess(req, "Left group successfully!");
        }
        String redirect = req.getParameter("redirect");
        if (redirect == null || redirect.isEmpty() || redirect.contains("/WEB-INF/")) {
            redirect = req.getContextPath() + "/groups/list";
        }
        resp.sendRedirect(redirect);
    }

    private Long parseLong(String v) { try { return v == null ? null : Long.parseLong(v); } catch (NumberFormatException e) { return null; } }
}


