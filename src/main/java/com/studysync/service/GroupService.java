package com.studysync.service;

import com.studysync.dao.StudyGroupDAO;
import com.studysync.dao.SubjectDAO;
import com.studysync.model.Subject;
import com.studysync.model.Student;
import com.studysync.model.StudyGroup;

import java.util.List;

public class GroupService {
    private final StudyGroupDAO groupDAO = new StudyGroupDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();

    public StudyGroup creerGroupe(String nom, String description, boolean estOuvert, Student createur) {
        StudyGroup group = new StudyGroup();
        group.setNom(nom);
        group.setDescription(description);
        group.setEstOuvert(estOuvert);
        group.setCreateur(createur);
        group.getMembres().add(createur);
        groupDAO.saveOrUpdate(group);
        return group;
    }

    public StudyGroup modifierGroupe(StudyGroup group) {
        groupDAO.saveOrUpdate(group);
        return group;
    }

    public void supprimerGroupe(StudyGroup group) {
        groupDAO.delete(group);
    }

    public StudyGroup rejoindreGroupe(StudyGroup group, Student student) {
        groupDAO.addMember(group.getId(), student.getId());
        return groupDAO.findById(group.getId());
    }

    public StudyGroup quitterGroupe(StudyGroup group, Student student) {
        groupDAO.removeMember(group.getId(), student.getId());
        return groupDAO.findById(group.getId());
    }

    public StudyGroup trouverParId(Long id) { return groupDAO.findById(id); }
    public List<StudyGroup> listerTous() { return groupDAO.findAll(); }

    public void attacherSujets(StudyGroup group, java.util.Set<Long> subjectIds) {
        group.getSujets().clear();
        if (subjectIds != null && !subjectIds.isEmpty()) {
            for (Long sid : subjectIds) {
                Subject s = subjectDAO.findById(sid);
                if (s != null) group.getSujets().add(s);
            }
        }
        groupDAO.saveOrUpdate(group);
    }
}


