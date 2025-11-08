package com.studysync.dao;

import com.studysync.model.Student;
import com.studysync.util.HibernateUtil;
import org.hibernate.Session;

public class StudentDAO extends GenericDAO<Student, Long> {
    public StudentDAO() {
        super(Student.class);
    }

    public Student findByEmail(String email) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("select distinct s from Student s left join fetch s.roles where s.email = :email", Student.class)
                    .setParameter("email", email)
                    .uniqueResult();
        }
    }
}


