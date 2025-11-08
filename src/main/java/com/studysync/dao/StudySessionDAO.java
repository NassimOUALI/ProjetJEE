package com.studysync.dao;

import com.studysync.model.StudySession;
import com.studysync.util.HibernateUtil;
import org.hibernate.Session;

import java.util.List;

public class StudySessionDAO extends GenericDAO<StudySession, Long> {
    public StudySessionDAO() {
        super(StudySession.class);
    }

    public List<StudySession> findByGroupId(Long groupId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select distinct s from StudySession s " +
                    "left join fetch s.groupe g " +
                    "left join fetch s.organisateur " +
                    "where g.id = :gid order by s.heureDebut", StudySession.class)
                    .setParameter("gid", groupId)
                    .list();
        }
    }

    public List<StudySession> findByGroupId(Long groupId, int offset, int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select distinct s from StudySession s " +
                    "left join fetch s.groupe g " +
                    "left join fetch s.organisateur " +
                    "where g.id = :gid order by s.heureDebut", StudySession.class)
                    .setParameter("gid", groupId)
                    .setFirstResult(offset)
                    .setMaxResults(limit)
                    .list();
        }
    }

    public long countByGroupId(Long groupId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return (Long) session.createQuery("select count(distinct s) from StudySession s where s.groupe.id = :gid")
                    .setParameter("gid", groupId)
                    .uniqueResult();
        }
    }

    public List<StudySession> findByGroupIds(List<Long> groupIds) {
        if (groupIds == null || groupIds.isEmpty()) return java.util.Collections.emptyList();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select distinct s from StudySession s " +
                    "left join fetch s.groupe g " +
                    "left join fetch s.organisateur " +
                    "where g.id in (:ids) order by s.heureDebut", StudySession.class)
                    .setParameterList("ids", groupIds)
                    .list();
        }
    }

    public List<StudySession> findByGroupIds(List<Long> groupIds, int offset, int limit) {
        if (groupIds == null || groupIds.isEmpty()) return java.util.Collections.emptyList();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select distinct s from StudySession s " +
                    "left join fetch s.groupe g " +
                    "left join fetch s.organisateur " +
                    "where g.id in (:ids) order by s.heureDebut", StudySession.class)
                    .setParameterList("ids", groupIds)
                    .setFirstResult(offset)
                    .setMaxResults(limit)
                    .list();
        }
    }

    public long countByGroupIds(List<Long> groupIds) {
        if (groupIds == null || groupIds.isEmpty()) return 0;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return (Long) session.createQuery("select count(distinct s) from StudySession s where s.groupe.id in (:ids)")
                    .setParameterList("ids", groupIds)
                    .uniqueResult();
        }
    }
}


