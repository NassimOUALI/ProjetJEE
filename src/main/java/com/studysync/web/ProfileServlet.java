package com.studysync.web;

import com.studysync.model.Student;
import com.studysync.service.StudentService;
import com.studysync.util.FlashMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile/edit"})
public class ProfileServlet extends HttpServlet {
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/profile/edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Student user = (Student) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/auth/login"); return; }
        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        String email = req.getParameter("email");
        String newPassword = req.getParameter("password");
        if (nom == null || nom.trim().isEmpty() || prenom == null || prenom.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "First name, last name, and email are required");
            req.getRequestDispatcher("/WEB-INF/views/profile/edit.jsp").forward(req, resp);
            return;
        }
        if (newPassword != null && !newPassword.trim().isEmpty() && newPassword.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters");
            req.getRequestDispatcher("/WEB-INF/views/profile/edit.jsp").forward(req, resp);
            return;
        }
        try {
            Student updated = studentService.mettreAJourProfil(user, nom.trim(), prenom.trim(), email.trim(), 
                                                               newPassword != null && !newPassword.trim().isEmpty() ? newPassword : null);
            req.getSession().setAttribute("user", updated);
            FlashMessage.setSuccess(req, "Profile updated successfully!");
            resp.sendRedirect(req.getContextPath() + "/profile/edit");
        } catch (IllegalArgumentException ex) {
            req.setAttribute("error", ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/profile/edit.jsp").forward(req, resp);
        }
    }
}


