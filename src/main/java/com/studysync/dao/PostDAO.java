package com.studysync.dao;

import com.studysync.model.Post;
import com.studysync.util.HibernateUtil;
import org.hibernate.Session;

import java.util.List;

public class PostDAO extends GenericDAO<Post, Long> {
    public PostDAO() {
        super(Post.class);
    }

    public Post findByIdWithRelations(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select distinct p from Post p " +
                    "left join fetch p.auteur " +
                    "left join fetch p.session " +
                    "left join fetch p.groupe " +
                    "where p.id = :id", Post.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    public List<Post> findByGroupId(Long groupId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select distinct p from Post p " +
                    "left join fetch p.auteur " +
                    "where p.groupe.id = :gid order by p.datePublication desc", Post.class)
                    .setParameter("gid", groupId)
                    .list();
        }
    }

    public List<Post> findByGroupId(Long groupId, int offset, int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select distinct p from Post p " +
                    "left join fetch p.auteur " +
                    "where p.groupe.id = :gid order by p.datePublication desc", Post.class)
                    .setParameter("gid", groupId)
                    .setFirstResult(offset)
                    .setMaxResults(limit)
                    .list();
        }
    }

    public long countByGroupId(Long groupId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return (Long) session.createQuery("select count(*) from Post p where p.groupe.id = :gid")
                    .setParameter("gid", groupId)
                    .uniqueResult();
        }
    }

    public List<Post> findBySessionId(Long sessionId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select distinct p from Post p " +
                    "left join fetch p.auteur " +
                    "where p.session.id = :sid order by p.datePublication desc", Post.class)
                    .setParameter("sid", sessionId)
                    .list();
        }
    }

    public List<Post> findBySessionId(Long sessionId, int offset, int limit) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select distinct p from Post p " +
                    "left join fetch p.auteur " +
                    "where p.session.id = :sid order by p.datePublication desc", Post.class)
                    .setParameter("sid", sessionId)
                    .setFirstResult(offset)
                    .setMaxResults(limit)
                    .list();
        }
    }

    public long countBySessionId(Long sessionId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return (Long) session.createQuery("select count(*) from Post p where p.session.id = :sid")
                    .setParameter("sid", sessionId)
                    .uniqueResult();
        }
    }
}


