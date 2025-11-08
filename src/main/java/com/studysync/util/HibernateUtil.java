package com.studysync.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import com.studysync.model.Post;
import com.studysync.model.Role;
import com.studysync.model.Student;
import com.studysync.model.StudyGroup;
import com.studysync.model.StudySession;
import com.studysync.model.Subject;

public class HibernateUtil {
    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            Configuration configuration = new Configuration();
            configuration.configure("hibernate.cfg.xml");
            configuration.addAnnotatedClass(Student.class);
            configuration.addAnnotatedClass(Role.class);
            configuration.addAnnotatedClass(Subject.class);
            configuration.addAnnotatedClass(StudyGroup.class);
            configuration.addAnnotatedClass(StudySession.class);
            configuration.addAnnotatedClass(Post.class);
            return configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        getSessionFactory().close();
    }
}


