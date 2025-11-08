package com.studysync.dao;

import com.studysync.model.StudyGroup;
import com.studysync.model.Student;
import com.studysync.util.HibernateUtil;
import org.hibernate.Session;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class StudyGroupDAO extends GenericDAO<StudyGroup, Long> {
    public StudyGroupDAO() {
        super(StudyGroup.class);
    }

    public void addMember(Long groupId, Long studentId) {
        executeInsideTransaction(session -> {
            StudyGroup group = session.get(StudyGroup.class, groupId);
            Student student = session.get(Student.class, studentId);
            if (group != null && student != null) {
                group.getMembres().add(student);
            }
        });
    }

    public void removeMember(Long groupId, Long studentId) {
        executeInsideTransaction(session -> {
            StudyGroup group = session.get(StudyGroup.class, groupId);
            Student student = session.get(Student.class, studentId);
            if (group != null && student != null) {
                group.getMembres().remove(student);
            }
        });
    }

    public List<StudyGroup> findByMemberId(Long studentId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select g from StudyGroup g join g.membres m where m.id = :sid", StudyGroup.class)
                    .setParameter("sid", studentId)
                    .list();
        }
    }

    public Set<Long> findJoinedGroupIds(Long studentId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Long> ids = session.createQuery("select g.id from StudyGroup g join g.membres m where m.id = :sid", Long.class)
                    .setParameter("sid", studentId)
                    .list();
            return new HashSet<>(ids);
        }
    }

    public Set<Long> findCreatorGroupIds(Long creatorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Long> ids = session.createQuery("select g.id from StudyGroup g where g.createur.id = :cid", Long.class)
                    .setParameter("cid", creatorId)
                    .list();
            return new HashSet<>(ids);
        }
    }

    public StudyGroup findByIdWithSubjects(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                    "select distinct g from StudyGroup g " +
                    "left join fetch g.sujets " +
                    "left join fetch g.createur " +
                    "where g.id = :id", StudyGroup.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }
}


