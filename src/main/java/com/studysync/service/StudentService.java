package com.studysync.service;

import com.studysync.dao.RoleDAO;
import com.studysync.dao.StudentDAO;
import com.studysync.model.Role;
import com.studysync.model.Student;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class StudentService {
    private final StudentDAO studentDAO = new StudentDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    public Student sInscrire(String nom, String prenom, String email, String password) {
        if (studentDAO.findByEmail(email) != null) {
            throw new IllegalArgumentException("Email already in use");
        }
        Student student = new Student();
        student.setNom(nom);
        student.setPrenom(prenom);
        student.setEmail(email);
        student.setPasswordHash(hashPassword(password));
        Role defaultRole = roleDAO.findById(1L);
        if (defaultRole == null) {
            throw new IllegalStateException("Default Student role not configured");
        }
        student.getRoles().add(defaultRole);
        studentDAO.saveOrUpdate(student);
        return student;
    }

    public Student seConnecter(String email, String password) {
        Student student = studentDAO.findByEmail(email);
        if (student == null) return null;
        String hash = hashPassword(password);
        return hash.equals(student.getPasswordHash()) ? student : null;
    }

    public Student mettreAJourProfil(Student existing, String nom, String prenom, String email, String newPassword) {
        if (email != null && !email.equals(existing.getEmail())) {
            Student byEmail = studentDAO.findByEmail(email);
            if (byEmail != null && !byEmail.getId().equals(existing.getId())) {
                throw new IllegalArgumentException("Email already in use");
            }
            existing.setEmail(email);
        }
        if (nom != null) existing.setNom(nom);
        if (prenom != null) existing.setPrenom(prenom);
        if (newPassword != null && !newPassword.isBlank()) {
            existing.setPasswordHash(hashPassword(newPassword));
        }
        studentDAO.saveOrUpdate(existing);
        return existing;
    }

    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encoded = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : encoded) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}


