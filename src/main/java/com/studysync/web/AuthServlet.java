package com.studysync.web;

import com.studysync.model.Student;
import com.studysync.service.StudentService;
import com.studysync.util.FlashMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth/*"})
public class AuthServlet extends HttpServlet {
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/login".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
        } else if ("/register".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        } else if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/");
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/login".equals(path)) {
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                req.setAttribute("error", "Email and password are required");
                req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
                return;
            }
            Student s = studentService.seConnecter(email.trim(), password);
            if (s == null) {
                req.setAttribute("error", "Invalid credentials");
                req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
                return;
            }
            req.getSession(true).setAttribute("user", s);
            FlashMessage.setSuccess(req, "Welcome back, " + s.getPrenom() + "!");
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else if ("/register".equals(path)) {
            String nom = req.getParameter("nom");
            String prenom = req.getParameter("prenom");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            if (nom == null || nom.trim().isEmpty() || prenom == null || prenom.trim().isEmpty() ||
                email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                req.setAttribute("error", "All fields are required");
                req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
                return;
            }
            if (password.length() < 6) {
                req.setAttribute("error", "Password must be at least 6 characters");
                req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
                return;
            }
            try {
                Student s = studentService.sInscrire(nom.trim(), prenom.trim(), email.trim(), password);
                req.getSession(true).setAttribute("user", s);
                FlashMessage.setSuccess(req, "Account created successfully!");
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            } catch (IllegalArgumentException ex) {
                req.setAttribute("error", ex.getMessage());
                req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            }
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}


