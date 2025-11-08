package com.studysync.service;

import com.studysync.dao.PostDAO;
import com.studysync.model.Post;
import com.studysync.model.Student;
import com.studysync.model.StudyGroup;
import com.studysync.model.StudySession;

public class PostService {
    private final PostDAO postDAO = new PostDAO();

    public Post creerPost(String contenu, String type, Student auteur, StudyGroup groupe, StudySession session) {
        Post p = new Post();
        p.setContenu(contenu);
        p.setType(type);
        p.setAuteur(auteur);
        p.setGroupe(groupe);
        p.setSession(session);
        postDAO.saveOrUpdate(p);
        return p;
    }
}


