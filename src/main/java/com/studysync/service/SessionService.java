package com.studysync.service;

import com.studysync.dao.StudySessionDAO;
import com.studysync.model.Student;
import com.studysync.model.StudyGroup;
import com.studysync.model.StudySession;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

public class SessionService {
    private final StudySessionDAO sessionDAO = new StudySessionDAO();

    public StudySession planifierSession(String titre, LocalDateTime debut, LocalDateTime fin, String description,
                                         StudyGroup groupe, Student organisateur) {
        if (fin.isBefore(debut)) throw new IllegalArgumentException("End time before start time");
        StudySession s = new StudySession();
        s.setTitre(titre);
        s.setHeureDebut(debut);
        s.setHeureFin(fin);
        s.setDescription(description);
        s.setGroupe(groupe);
        s.setOrganisateur(organisateur);
        s.getParticipants().add(organisateur);
        sessionDAO.saveOrUpdate(s);
        return s;
    }

    public StudySession modifierSession(StudySession session) {
        sessionDAO.saveOrUpdate(session);
        return session;
    }

    public void annulerSession(StudySession session) {
        sessionDAO.delete(session);
    }

    public List<StudySession> prochainesSessions(List<StudySession> all) {
        LocalDateTime now = LocalDateTime.now();
        return all.stream()
                .filter(s -> !s.getHeureDebut().isBefore(now))
                .sorted(Comparator.comparing(StudySession::getHeureDebut))
                .collect(Collectors.toList());
    }
}


